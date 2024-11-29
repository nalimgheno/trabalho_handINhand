import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:io'; // Para File
import 'dart:typed_data'; // Para Image.memory
import 'package:flutter/foundation.dart'; // Importar kIsWeb
import 'dart:convert'; // Para codificação base64
import 'Fundraiser.dart';

class StartFundraiserScreen extends StatefulWidget {
  final Function(Fundraiser) onFundraiserCreated;
  final Fundraiser? initialData; // Para edição

  StartFundraiserScreen({required this.onFundraiserCreated, this.initialData});

  @override
  _StartFundraiserScreenState createState() => _StartFundraiserScreenState();
}

class _StartFundraiserScreenState extends State<StartFundraiserScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _phone;
  String? _amount;
  String? _purpose;
  String? _description;
  List<dynamic> _images = []; // Lista dinâmica que pode conter tanto String quanto Uint8List (bytes da imagem)
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      // Carrega os dados iniciais de edição
      _name = widget.initialData!.name;
      _phone = widget.initialData!.phone;
      _amount = widget.initialData!.amount.toString(); // Converte para string
      _purpose = widget.initialData!.purpose;
      _description = widget.initialData!.description;
      _images = widget.initialData!.images;
    }
  }

  // Função para escolher a imagem dependendo da plataforma
  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Usar image_picker_web na web
      final pickedFile = await ImagePickerWeb.getImageAsBytes(); // Captura a imagem como bytes
      if (pickedFile != null) {
        // Adiciona os bytes diretamente à lista de imagens
        setState(() {
          _images.add(pickedFile); // Armazena a imagem como bytes (Uint8List)
        });
      }
    } else {
      // Usar image_picker no mobile
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _images.add(pickedFile.path); // Adiciona o caminho da imagem como String
        });
      }
    }
  }

  // Widget para exibir as imagens
  Widget _buildImageGallery() {
    return Column(
      children: _images.map<Widget>((image) {
        if (image is String && image.startsWith('data:image')) {
          // Para a web, a imagem é uma String base64
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Image.memory(
              base64Decode(image), // Converte a string base64 de volta para bytes
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          );
        } else if (image is String) {
          // Para dispositivos móveis, usamos o caminho do arquivo
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Image.file(
              File(image),
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          );
        } else if (image is Uint8List) {
          // Para web (quando é armazenado como bytes)
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Image.memory(
              image, // Exibe a imagem diretamente dos bytes
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          );
        } else {
          // Caso não seja um tipo esperado
          return SizedBox.shrink();
        }
      }).toList(),
    );
  }

  // Função para o campo de texto com validação e borda verde
  Widget _buildTextFormField(String label, String? initialValue, Function(String?) onSaved, {int maxLines = 1}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black), // Cor do texto do label
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal), // Cor da borda
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal), // Cor da borda quando o campo é focado
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
      initialValue: initialValue,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira $label';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }

  // Função de envio do formulário
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Fundraiser fundraiser = Fundraiser(
        name: _name!,
        phone: _phone!,
        amount: double.tryParse(_amount!) ?? 0.0,
        purpose: _purpose!,
        description: _description!,
        images: _images, // Agora _images é uma lista de dynamic (que pode armazenar String ou Uint8List)
        goal: 1000.0, // Ajuste conforme necessário
      );

      // Certifique-se de que a função callback está sendo chamada corretamente
      widget.onFundraiserCreated(fundraiser); // Passa os dados da vaquinha criada
      Navigator.pop(context); // Volta para a tela anterior
    } else {
      // Exibir um feedback caso o formulário não passe na validação
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos corretamente!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialData != null ? 'Editar Vaquinha' : 'Iniciar Vaquinha'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Preencha as informações abaixo',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildTextFormField('Nome', _name, (value) => _name = value),
                SizedBox(height: 10),
                _buildTextFormField('Telefone', _phone, (value) => _phone = value),
                SizedBox(height: 10),
                _buildTextFormField('Quantia (R\$)', _amount, (value) => _amount = value),
                SizedBox(height: 10),
                _buildTextFormField('Propósito', _purpose, (value) => _purpose = value),
                SizedBox(height: 10),
                _buildTextFormField('Descrição', _description, (value) => _description = value, maxLines: 3),
                SizedBox(height: 20),

                // Botão para selecionar a imagem
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Selecionar Imagem'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    onPrimary: Colors.white,
                  ),
                ),

                SizedBox(height: 20),

                // Exibe as imagens selecionadas
                _buildImageGallery(),

                SizedBox(height: 20),

                // Botão para enviar o formulário centralizado
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(widget.initialData != null ? 'Atualizar Vaquinha' : 'Iniciar Vaquinha'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
