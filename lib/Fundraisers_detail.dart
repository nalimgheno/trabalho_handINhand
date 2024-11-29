import 'package:flutter/material.dart';
import 'Fundraiser.dart'; // Importa o modelo Fundraiser
import 'StartFundraiserScreen.dart'; // Importa a tela de criação da vaquinha

class FundraiserDetailScreen extends StatelessWidget {
  final Fundraiser fundraiser;
  final Function(Fundraiser) onUpdate;
  final Function(Fundraiser) onClose;

  FundraiserDetailScreen({
    required this.fundraiser,
    required this.onUpdate,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    double goal = fundraiser.goal;
    double raised = fundraiser.amount;
    double percentage = goal > 0 ? (raised / goal) * 100 : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(fundraiser.name),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fundraiser.purpose,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Descrição: ${fundraiser.description ?? 'Sem descrição'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Total Arrecadado: R\$ ${fundraiser.amount}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[300],
              color: Colors.teal,
            ),
            SizedBox(height: 8),
            Text('${percentage.toStringAsFixed(1)}% do objetivo alcançado', style: TextStyle(fontWeight: FontWeight.bold)),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.teal),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StartFundraiserScreen(
                          onFundraiserCreated: (updatedFundraiser) {
                            onUpdate(updatedFundraiser);
                            Navigator.pop(context);
                          },
                          initialData: fundraiser,
                        ),
                      ),
                    );
                  },
                  child: Text('Editar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () {
                    onClose(fundraiser);
                    Navigator.pop(context);
                  },
                  child: Text('Encerrar Vaquinha'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
