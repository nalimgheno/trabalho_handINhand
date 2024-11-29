import 'package:flutter/material.dart';
import 'Fundraiser.dart'; // Importa o modelo Fundraiser
import 'Fundraisers_detail.dart'; // Importa a tela de detalhes
import 'dart:convert'; // Para codificação base64
import 'dart:typed_data'; // Para manipulação de bytes
import 'dart:io'; // Para usar File no Flutter (dispositivos móveis)
import 'package:flutter/foundation.dart'; // Para verificar a plataforma

class MyFundraisersScreen extends StatefulWidget {
  final List<Fundraiser> fundraisers;

  MyFundraisersScreen({required this.fundraisers});

  @override
  _MyFundraisersScreenState createState() => _MyFundraisersScreenState();
}

class _MyFundraisersScreenState extends State<MyFundraisersScreen> {
  List<Fundraiser> ongoingFundraisers = [];
  List<Fundraiser> closedFundraisers = [];

  @override
  void initState() {
    super.initState();
    ongoingFundraisers = widget.fundraisers.where((f) => !f.isClosed).toList(); // Filtra vaquinhas em andamento
    closedFundraisers = widget.fundraisers.where((f) => f.isClosed).toList(); // Filtra vaquinhas encerradas
  }

  void _updateFundraiser(Fundraiser updatedFundraiser) {
    setState(() {
      int index = ongoingFundraisers.indexWhere((f) => f.name == updatedFundraiser.name);
      if (index != -1) {
        ongoingFundraisers[index] = updatedFundraiser;
      }
    });
  }

  void _closeFundraiser(Fundraiser fundraiser) {
    setState(() {
      // Muda o estado da vaquinha para encerrada
      fundraiser.isClosed = true;
      // Remove da lista de vaquinhas em andamento
      ongoingFundraisers.remove(fundraiser);
      // Adiciona à lista de vaquinhas encerradas, se ainda não estiver lá
      if (!closedFundraisers.contains(fundraiser)) {
        closedFundraisers.add(fundraiser);
      }
    });
  }

  void _deleteFundraiser(Fundraiser fundraiser) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Você tem certeza que deseja excluir esta vaquinha?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                closedFundraisers.remove(fundraiser);
              });
              Navigator.of(context).pop();
            },
            child: Text('Sim', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Não'),
          ),
        ],
      ),
    );
  }

  // Função para exibir a imagem da vaquinha
  Widget _buildImageWidget(dynamic imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Image(
        image: _getImageProvider(imagePath),
        height: 80, // Ajuste o tamanho da imagem para ficar proporcional
        width: double.infinity, // A imagem vai ocupar toda a largura disponível
        fit: BoxFit.cover, // A imagem vai cobrir a área sem distorcer
      ),
    );
  }

  // Função para identificar o tipo de imagem (base64, URL ou arquivo local)
  ImageProvider _getImageProvider(dynamic imagePath) {
    if (imagePath is String) {
      if (imagePath.startsWith('data:image')) {
        // Se for base64, cria a imagem a partir de dados base64
        return MemoryImage(base64Decode(imagePath.split(',').last));
      } else {
        // Se for URL, retorna a imagem da URL
        return NetworkImage(imagePath);
      }
    } else if (imagePath is Uint8List) {
      // Se for Uint8List, retorna a imagem a partir dos dados binários
      return MemoryImage(imagePath);
    } else {
      // Caso não tenha um tipo de imagem válido, retorna uma imagem padrão
      return AssetImage('assets/default_image.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Vaquinhas'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(38.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ongoingFundraisers.isEmpty
                  ? Center(child: Text('Você ainda não criou nenhuma vaquinha.', style: TextStyle(fontSize: 24)))
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Número de colunas
                  crossAxisSpacing: 16.0, // Espaço horizontal entre os cards
                  mainAxisSpacing: 16.0, // Espaço vertical entre os cards
                  childAspectRatio: 0.75, // Ajusta a proporção dos cards
                ),
                itemCount: ongoingFundraisers.length,
                itemBuilder: (context, index) {
                  final fundraiser = ongoingFundraisers[index];
                  return GestureDetector(
                    onTap: () {
                      // Ao clicar na vaquinha, navega para a tela de detalhes
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FundraiserDetailScreen(
                            fundraiser: fundraiser,
                            onUpdate: _updateFundraiser,
                            onClose: _closeFundraiser,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      // Usando Container com BoxDecoration para aplicar gradiente
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.teal[200]!, // Verde claro no topo
                              Colors.teal[900]!, // Verde escuro no fundo
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Imagem
                            if (fundraiser.images.isNotEmpty)
                              _buildImageWidget(fundraiser.images.first),
                            // Nome e propósito
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fundraiser.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // Cor do texto branca
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    fundraiser.purpose,
                                    style: TextStyle(
                                      color: Colors.white, // Cor do texto branca
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Descrição
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Descrição: ${fundraiser.description ?? 'Sem descrição'}',
                                style: TextStyle(
                                  color: Colors.white, // Cor do texto branca
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            // Valor
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'R\$ ${fundraiser.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // Cor do texto branca
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text('Vaquinhas Encerradas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
            SizedBox(height: 10),
            Expanded(
              child: closedFundraisers.isEmpty
                  ? Center(child: Text('Nenhuma vaquinha encerrada.', style: TextStyle(fontSize: 24)))
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Número de colunas
                  crossAxisSpacing: 16.0, // Espaço horizontal entre os cards
                  mainAxisSpacing: 16.0, // Espaço vertical entre os cards
                  childAspectRatio: 0.75, // Ajusta a proporção dos cards
                ),
                itemCount: closedFundraisers.length,
                itemBuilder: (context, index) {
                  final fundraiser = closedFundraisers[index];
                  return GestureDetector(
                    onTap: () {
                      // Ao clicar na vaquinha, navega para a tela de detalhes
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FundraiserDetailScreen(
                            fundraiser: fundraiser,
                            onUpdate: _updateFundraiser,
                            onClose: _closeFundraiser,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      // Usando Container com BoxDecoration para aplicar gradiente
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.teal.shade200,
                              Colors.teal.shade900,
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Imagem
                            if (fundraiser.images.isNotEmpty)
                              _buildImageWidget(fundraiser.images.first),
                            // Nome e propósito
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fundraiser.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // Cor do texto branca
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    fundraiser.purpose,
                                    style: TextStyle(
                                      color: Colors.white, // Cor do texto branca
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Descrição
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Descrição: ${fundraiser.description ?? 'Sem descrição'}',
                                style: TextStyle(
                                  color: Colors.white, // Cor do texto branca
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            // Valor
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'R\$ ${fundraiser.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // Cor do texto branca
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
