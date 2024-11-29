import 'package:flutter/material.dart';
import 'project_detail_screen.dart'; // Alterando a importação para o arquivo correto

class CategoryProjectsScreen extends StatefulWidget {
  final int categoryIndex;

  CategoryProjectsScreen({required this.categoryIndex});

  @override
  _CategoryProjectsScreenState createState() => _CategoryProjectsScreenState();
}

class _CategoryProjectsScreenState extends State<CategoryProjectsScreen> {
  final List<String> _projects = [
    'Projeto 1',
    'Projeto 2',
    'Projeto 3',
    'Projeto 4',
    'Projeto 5',
  ];

  List<String> _filteredProjects = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredProjects = _projects;
  }

  void _filterProjects(String query) {
    setState(() {
      _searchQuery = query;
      _filteredProjects = query.isEmpty
          ? _projects
          : _projects.where((project) => project.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projetos', style: TextStyle(fontFamily: 'Montserrat')),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Container(
        color: Colors.white, // Fundo branco
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Projeto por Categoria ${widget.categoryIndex + 1}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 16.0),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.grey.shade200,
              ),
              child: TextField(
                onChanged: _filterProjects,
                decoration: InputDecoration(
                  hintText: 'Procurar Projetos...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.teal),
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredProjects.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectDetailScreen(projectIndex: index), // Alterando a navegação
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        gradient: LinearGradient(
                          colors: [Colors.teal.shade900, Colors.teal.shade200],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                            child: Image.asset(
                              'images/meio-ambiente.webp',
                              height: 150,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              _filteredProjects[index],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'Descrição de ${_filteredProjects[index]}.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.0),
                        ],
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
