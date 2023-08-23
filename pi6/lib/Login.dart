import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:projeto_integrador6/Settings/db.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  bool _obscureText = true;
  bool isVerifying = false;

  void verificarLogin() async {

    setState(() {
      isVerifying = true;
    });

    var db = await Db.getConnectionStartup();
    var col = db.collection('user');
    var doc = await col.findOne(mongo.where.eq('email', emailController.text));

    String senha = senhaController.text;

    var bytes = utf8.encode(senha);
    var digest = sha256.convert(bytes);
    var senhaCodificada = digest.toString();

    try {
      if(emailController.text.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Preencha todos os campos.'), duration: Duration(seconds: 5),),
        );
      }else{
        if (doc != null) {
          if (doc['senha'] == senhaCodificada) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login bem-sucedido'), duration: Duration(seconds: 5),),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Credenciais inválidas. Tente novamente.'), duration: Duration(seconds: 5),),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email não cadastrado'), duration: Duration(seconds: 5),),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Desculpe, ocorreu um erro no sistema...\nTente novamente em instantes.'), duration: Duration(seconds: 5),),
      );
    }finally {
      setState(() {
        isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF384870B2),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 60),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              SizedBox(height: 30),
              _buildTextField('Email/CNPJ', controller: emailController),
              SizedBox(height: 10),
              _buildTextField('Senha', isPassword: true, controller: senhaController),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    verificarLogin();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF1F6E8D),
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isVerifying
                  ? CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ) : Text('Entrar', style: TextStyle(fontSize: 16)),
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {bool isPassword = false, TextEditingController? controller}) {
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
          obscureText: isPassword && _obscureText,
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[350],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
