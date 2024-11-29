import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorias'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CategoryTile(icon: Icons.science_outlined, title: 'Ciência'),
            CategoryTile(icon: Icons.airplane_ticket_outlined, title: 'Viagem'),
            CategoryTile(icon: Icons.pets_sharp, title: 'Animais'),
            CategoryTile(icon: Icons.fastfood_outlined, title: 'Comida'),
            CategoryTile(icon: Icons.local_hospital_outlined, title: 'Saúde'),
            CategoryTile(icon: Icons.settings, title: 'Mecanismos Gerais'),
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const CategoryTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          child: Icon(icon, color: Colors.teal),
        ),
        title: Text(title, style: TextStyle(fontSize: 18.0)),
        onTap: () {
          // Ação ao tocar na categoria
        },
      ),
    );
  }
}
