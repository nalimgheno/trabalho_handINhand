import 'package:flutter/material.dart';
import 'project_detail_screen.dart';
import 'categories_screen.dart';
import 'category_projects_screen.dart';
import 'StartFundraiserScreen.dart'; // Importa a tela para iniciar a vaquinha
import 'MyFundraisersScreen.dart'; // Importa a tela para listar as vaquinhas
import 'Fundraiser.dart'; // Importa o modelo Fundraiser

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Fundraiser> _fundraisers = []; // Lista para armazenar as vaquinhas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Tela de Início',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove o botão de voltar automaticamente
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'start_fundraiser':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StartFundraiserScreen(
                        onFundraiserCreated: (newFundraiser) {
                          setState(() {
                            _fundraisers.add(newFundraiser);
                          });
                        },
                      ),
                    ),
                  );
                  break;
                case 'my_fundraisers':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyFundraisersScreen(fundraisers: _fundraisers),
                    ),
                  );
                  break;
                case 'settings':
                // Implementar lógica para configurações
                  break;
                case 'help':
                // Implementar lógica para ajuda
                  break;
                case 'report_fraud':
                // Implementar lógica para denunciar fraude
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'start_fundraiser',
                child: Text('Iniciar Vaquinha'),
              ),
              PopupMenuItem<String>(
                value: 'my_fundraisers',
                child: Text('Minhas Vaquinhas'),
              ),
              PopupMenuItem<String>(
                value: 'settings',
                child: Text('Configurações'),
              ),
              PopupMenuItem<String>(
                value: 'help',
                child: Text('Ajuda'),
              ),
              PopupMenuItem<String>(
                value: 'report_fraud',
                child: Text('Denuncie Fraude'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'AJUDE ALGUÉM OU INVISTA HOJE!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.teal.shade800,
                ),
              ),
              SizedBox(height: 16.0),
              // Barra de pesquisa
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.2),
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Pesquisar',
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: Icon(Icons.search, color: Colors.teal),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'CATEGORIAS',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 12.0),
              GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Icons.science_outlined,
                  Icons.airplane_ticket_outlined,
                  Icons.pets_sharp,
                  Icons.fastfood_outlined,
                  Icons.local_hospital_outlined,
                  Icons.settings,
                ].asMap().entries.map((entry) {
                  int idx = entry.key;
                  IconData icon = entry.value;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CategoryProjectsScreen(categoryIndex: idx)),
                      );
                    },
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        gradient: LinearGradient(
                          colors: [
                            Colors.teal.shade200,
                            Colors.teal.shade900,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.3),
                            blurRadius: 6.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20.0),
              Text(
                'PROJETOS POPULARES',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 12.0),
              GestureDetector(
                onTap: () {
                  // Passe o projectIndex para a tela de detalhes
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectDetailScreen(projectIndex: 0), // Aqui você passa o projectIndex
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade400, Colors.teal.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.4),
                        blurRadius: 8.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'images/meio-ambiente.webp',
                          height: 150.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Nome do Projeto',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 6.0),
                              LinearProgressIndicator(
                                value: 0.7,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade200),
                                minHeight: 8.0,
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'Progresso: 70%',
                                style: TextStyle(fontSize: 12.0, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
