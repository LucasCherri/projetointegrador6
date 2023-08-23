import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:mailer/mailer.dart';

class CadastroInvestidor extends StatefulWidget {
  @override
  _CadastroInvestidorState createState() => _CadastroInvestidorState();
}

class _CadastroInvestidorState extends State<CadastroInvestidor> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController celularController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  bool _obscureText = true;
  bool isLoading = false;

  late String codigo;

  @override
  void initState() {
    super.initState();
    // Inicialize os controladores de acordo com os valores padrão ou vazios.
  }

  String codigoConfirmacao() {
    Random random = Random();
    int numero = random.nextInt(999999);
    codigo = numero.toString().padLeft(6, '0');

    return codigo;
  }

  Future emailConfirmacao() async {
    var email = emailController.text;

    final smtpServer = gmail('seu_email@gmail.com', 'sua_senha');

    final message = Message()
      ..from = Address(email, 'Confirmação de Cadastro')
      ..recipients.add(email)
      ..subject = 'Código de Confirmação de Cadastro'
      ..text = 'Código: ${codigoConfirmacao()}\n\nAtenciosamente,\nCherry Solutions';

    await send(message, smtpServer);
  }

  Future<bool> cadastrarInvestidor() async {
    try {
      String nome = nomeController.text;
      String cpf = cpfController.text;
      String email = emailController.text;
      String celular = celularController.text;
      String dataNascimento = dataNascimentoController.text;
      String senha = senhaController.text;

      var bytes = utf8.encode(senha);
      var digest = sha256.convert(bytes);
      var senhaCodificada = digest.toString();

      // Conecte-se ao banco de dados e insira os dados do investidor.

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Conta cadastrada com sucesso!'),
          duration: Duration(seconds: 5),
        ),
      );

      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao tentar cadastrar.'),
          duration: Duration(seconds: 5),
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF384870B2),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 60, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ...
              _buildInfoField('Nome', controller: nomeController),
              SizedBox(height: 10),
              _buildInfoField('CPF', controller: cpfController),
              SizedBox(height: 10),
              _buildInfoField('Email', controller: emailController),
              SizedBox(height: 10),
              _buildInfoField('Celular', controller: celularController),
              SizedBox(height: 10),
              _buildInfoField('Data de Nascimento', controller: dataNascimentoController),
              SizedBox(height: 10),
              _buildInfoField('Senha', controller: senhaController),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 0, right: 0),
        child: Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF1F6E8D),
              onPrimary: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text('Finalizar', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, {TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          // ...
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
