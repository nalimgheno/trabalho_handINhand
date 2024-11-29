import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // Importando o pacote de compartilhamento
import 'DonationScreen.dart'; // Importa a nova tela de doação

class ProjectDetailScreen extends StatefulWidget {
  final int projectIndex; // Adicionando o parâmetro projectIndex

  // Construtor que recebe o índice do projeto
  ProjectDetailScreen({required this.projectIndex});

  @override
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final List<String> _comments = [];
  final TextEditingController _commentController = TextEditingController();

  int _likeCount = 0; // Contador de curtidas
  int _dislikeCount = 0; // Contador de descurtidas
  bool _isLiked = false; // Controla se o usuário curtiu o projeto
  bool _isDisliked = false; // Controla se o usuário descurtiu o projeto

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _comments.add(_commentController.text);
        _commentController.clear();
      });
    }
  }

  // Função para compartilhar o projeto
  void _shareProject() {
    final String projectLink = 'https://www.exemplo.com/projeto';
    final String projectDescription = 'Confira este incrível projeto que ajuda o meio ambiente!';
    Share.share('$projectDescription $projectLink');
  }

  // Função para curtir o projeto
  void _likeProject() {
    setState(() {
      // Se já curtiu, desfaz a curtida
      if (_isLiked) {
        _likeCount--; // Desfaz a curtida
        _isLiked = false;
      } else {
        _likeCount++; // Adiciona a curtida
        _isLiked = true;
        // Se curtir, desmarca o deslike
        if (_isDisliked) {
          _dislikeCount--; // Remove o deslike
          _isDisliked = false;
        }
      }
    });
  }

  // Função para descurtir o projeto
  void _dislikeProject() {
    setState(() {
      // Se já descurtiu, desfaz o deslike
      if (_isDisliked) {
        _dislikeCount--; // Desfaz o deslike
        _isDisliked = false;
      } else {
        _dislikeCount++; // Adiciona o deslike
        _isDisliked = true;
        // Se descurtir, desmarca o like
        if (_isLiked) {
          _likeCount--; // Remove a curtida
          _isLiked = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Projeto', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do projeto
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                'images/meio-ambiente.webp',
                height: 250,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 16),
            // Nome do projeto - Usando projectIndex para exibir um nome de projeto baseado no índice
            Text(
              'Projeto ${widget.projectIndex + 1}', // Usando o projectIndex para personalizar o nome
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 8),
            // Descrição do projeto
            Text(
              'Descrição: esse projeto ajuda o meio ambiente através do...',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 20),
            // Botões para participar, compartilhar e curtir
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DonationScreen()), // Navega para DonationScreen
                    );
                  },
                  child: Text('Participar do Projeto'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
                SizedBox(width: 10), // Espaçamento entre os botões
                IconButton(
                  icon: Icon(Icons.share, color: Colors.teal), // Ícone de compartilhamento
                  onPressed: _shareProject, // Chama a função para compartilhar
                  iconSize: 24, // Tamanho do ícone de compartilhar
                ),
                IconButton(
                  icon: Icon(
                    _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined, // Ícone de curtir vazio ou preenchido
                    color: Colors.teal,
                  ),
                  onPressed: _likeProject, // Chama a função de curtir
                  iconSize: 24, // Tamanho do ícone de curtir
                ),
                Text('$_likeCount', style: TextStyle(fontSize: 16, color: Colors.teal)), // Exibe a quantidade de curtidas
                SizedBox(width: 10), // Espaçamento entre os ícones
                IconButton(
                  icon: Icon(
                    _isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined, // Ícone de descurtir vazio ou preenchido
                    color: Colors.teal,
                  ),
                  onPressed: _dislikeProject, // Chama a função de descurtir
                  iconSize: 24, // Tamanho do ícone de descurtir
                ),
                Text('$_dislikeCount', style: TextStyle(fontSize: 16, color: Colors.teal)), // Exibe a quantidade de descurtidas
              ],
            ),
            SizedBox(height: 20),
            // Progresso do projeto
            Text(
              'Progresso do Projeto',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: 0.7,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade200),
              minHeight: 10.0,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0%', style: TextStyle(fontSize: 12.0)),
                Text('Progresso: 70%', style: TextStyle(fontSize: 12.0, color: Colors.black)),
                Text('100%', style: TextStyle(fontSize: 12.0)),
              ],
            ),
            SizedBox(height: 20),
            // Título da seção de comentários
            Text(
              'Comentários',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 10),
            // Lista de comentários
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _comments[index],
                    style: TextStyle(color: Colors.black87),
                  ),
                  leading: Icon(Icons.comment, color: Colors.teal),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _commentController,
          decoration: InputDecoration(
            hintText: 'Adicionar comentário...',
            suffixIcon: IconButton(
              icon: Icon(Icons.send, color: Colors.teal),
              onPressed: _addComment,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.teal.shade200),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
      ),
    );
  }
}
