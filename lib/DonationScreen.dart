import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; // Importando o pacote de impressão
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart'; // Importando para acessar a área de transferência

class DonationScreen extends StatefulWidget {
  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final TextEditingController _donorNameController = TextEditingController();
  final TextEditingController _donationAmountController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  String? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doação', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Quanto você gostaria de doar?'),
              SizedBox(height: 10),
              _buildDonationAmountField(),
              SizedBox(height: 20),
              _buildSectionTitle('Seu Nome (opcional)'),
              SizedBox(height: 10),
              _buildDonorNameField(),
              _buildAnonymousCheckbox(),
              SizedBox(height: 20),
              _buildSectionTitle('Selecione o Método de Pagamento'),
              SizedBox(height: 10),
              _buildPaymentMethodDropdown(),
              SizedBox(height: 20),
              _buildPaymentOptions(context),
              SizedBox(height: 20),
              Center(child: _buildDonateButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
    );
  }

  Widget _buildDonationAmountField() {
    return TextField(
      controller: _donationAmountController,
      decoration: _inputDecoration('Valor da Doação', Icons.monetization_on),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDonorNameField() {
    return TextField(
      controller: _donorNameController,
      decoration: _inputDecoration('Seu Nome', Icons.person),
    );
  }

  Widget _buildAnonymousCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _donorNameController.text.isEmpty,
          onChanged: (value) {
            if (value == true) {
              _donorNameController.clear();
            }
            setState(() {});
          },
          activeColor: Colors.teal,
        ),
        Text('Doar Anonimamente', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildPaymentMethodDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPaymentMethod,
      hint: Text('Escolha o Método de Pagamento'),
      isExpanded: true,
      items: <String>['PIX', 'Boleto', 'Cartão de Crédito']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedPaymentMethod = newValue;
        });
      },
      decoration: _inputDecoration('', null),
    );
  }

  Widget _buildPaymentOptions(BuildContext context) {
    if (_selectedPaymentMethod == null) {
      return SizedBox.shrink();
    }

    switch (_selectedPaymentMethod) {
      case 'Boleto':
        return _buildBoletoOption();
      case 'PIX':
        return _buildPixOption();
      case 'Cartão de Crédito':
        return _buildCreditCardOption();
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildBoletoOption() {
    return Column(
      children: [
        Text(
          'Gerar Boleto',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _generateBoleto(),
          child: Text('Gerar Boleto'),
          style: ElevatedButton.styleFrom(primary: Colors.teal),
        ),
      ],
    );
  }

  Widget _buildPixOption() {
    return Column(
      children: [
        Text(
          'PIX Copiar & Colar:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        SizedBox(height: 10),
        SelectableText(
          'pix@exemplo.com',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _copyPixToClipboard,
          child: Text('Copiar PIX'),
          style: ElevatedButton.styleFrom(primary: Colors.teal),
        ),
      ],
    );
  }

  Widget _buildCreditCardOption() {
    return Column(
      children: [
        Text(
          'Digite os Dados do Cartão de Crédito',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _cardNumberController,
          decoration: _inputDecoration('Número do Cartão', Icons.credit_card),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _cardHolderController,
          decoration: _inputDecoration('Nome do Titular', Icons.person),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _expiryDateController,
                decoration: _inputDecoration('Data de Validade (MM/AA)', null),
                keyboardType: TextInputType.datetime,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _cvvController,
                decoration: _inputDecoration('CVV', null),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDonateButton() {
    return ElevatedButton(
      onPressed: () {
        if (_selectedPaymentMethod != null) {
          _showDonationConfirmation(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Por favor, selecione um método de pagamento')),
          );
        }
      },
      child: Text('Doar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        primary: Colors.teal,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  InputDecoration _inputDecoration(String labelText, IconData? prefixIcon) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.teal) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.teal),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.teal, width: 2),
      ),
    );
  }

  void _copyPixToClipboard() {
    final pixText = 'pix@exemplo.com';
    Clipboard.setData(ClipboardData(text: pixText)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Caminho do PIX copiado para a área de transferência')),
      );
    });
  }

  void _showDonationConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmação de Doação'),
          content: Text('Obrigado pela sua doação!'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                Navigator.of(context).pop(); // Retorna à página anterior
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _generateBoleto() async {
    try {
      // Gerar PDF para o boleto
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(child: pw.Text('Pagamento via Boleto', style: pw.TextStyle(fontSize: 24)));
          },
        ),
      );

      // Imprimir ou compartilhar o PDF gerado
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'boleto.pdf');

      // Notificar o usuário da geração bem-sucedida
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Boleto gerado e compartilhado!')),
      );
    } catch (e) {
      print("Erro ao gerar o PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao gerar o boleto PDF')),
      );
    }
  }
}
