import 'package:flutter/material.dart';
import 'Fundraiser.dart'; // Importa o modelo Fundraiser
import 'Fundraisers_detail.dart'; // Importa a tela de detalhes
import 'dart:convert'; // Para codificação base64
import 'dart:typed_data'; // Para manipulação de bytes

class ClosedFundraisersScreen extends StatelessWidget {
  final List<Fundraiser> closedFundraisers;

  ClosedFundraisersScreen({required this.closedFundraisers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vaquinhas Encerradas'),
        backgroundColor: Colors.teal,
      ),
      body: closedFundraisers.isEmpty
          ? Center(child: Text('Nenhuma vaquinha encerrada.', style: TextStyle(fontSize: 24)))
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.75,
        ),
        itemCount: closedFundraisers.length,
        itemBuilder: (context, index) {
          final fundraiser = closedFundraisers[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FundraiserDetailScreen(
                    fundraiser: fundraiser,
                    onUpdate: (updatedFundraiser) {},
                    onClose: (fundraiser) {},
                  ),
                ),
              );
            },
            child: Card(
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
                    if (fundraiser.images.isNotEmpty)
                      _buildImageWidget(fundraiser.images.first),  // Usando a função para exibir imagem
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fundraiser.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            fundraiser.purpose,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Descrição: ${fundraiser.description ?? 'Sem descrição'}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'R\$ ${fundraiser.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
}
