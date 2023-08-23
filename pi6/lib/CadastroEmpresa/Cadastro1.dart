import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:mailer/mailer.dart';
import 'package:projeto_integrador6/CadastroEmpresa/Cadastro.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:projeto_integrador6/Settings/db.dart';
import 'package:projeto_integrador6/Cadastro_Login_choose.dart';

class Cadastro1 extends StatefulWidget {
  String cnpj, nome, telefone, email, rep, dataFundacao, cep, setor;

  Cadastro1(this.cnpj, this.nome, this.telefone, this.email, this.rep, this.dataFundacao, this.cep, this.setor, {super.key});

  @override
  _Cadastro1State createState() => _Cadastro1State();
}

class _Cadastro1State extends State<Cadastro1> {
  TextEditingController celularRepresentanteController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController representanteLegalController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController codigoVerifController = TextEditingController();

  bool _obscureText = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    celularRepresentanteController.text = "N/A";
    emailController.text = widget.email;
    representanteLegalController.text = widget.rep;
  }

  late String codigo;

  //PARA GERAR O CÓDIGO QUE SERÁ ENVIADO PELO EMAIL
  String codigoConfirmacao(){
    Random random = Random();
    int numero = random.nextInt(999999);
    codigo = numero.toString().padLeft(6, '0');

    return codigo;
  }

  //PARA ENVIAR O EMAIL COM O CÓDIGO GERADO NA FUNÇÃO "CODIGOCONFIRMACAO"
  Future emailConfirmacao()async{

    var email = emailController.text;
    var nome = widget.nome;

    final smtpServer = gmail('pi5triplex@gmail.com', 'zsamiktyuvykyigb');

    final message = Message()
      ..from = Address(email, 'Cherry Solutions - Código para confirmação de cadastro')
      ..recipients.add(email)
      ..subject = 'Código para confirmar cadastro da empresa\n$nome '
      ..text = 'Código:${codigoConfirmacao()}\nAtenciosamente,\nEquipe Cherry Solutions';

    await send(message, smtpServer);
  }

  //FUNÇÃO QUE SALVARA NO MONGODB OS DADOS DA EMPRESA
  Future<bool> cadastrarEmpresa() async {
    try {
      String cnpj = widget.cnpj;
      String nome = widget.nome;
      String tel = widget.telefone;
      String cel = celularRepresentanteController.text;
      String email = emailController.text;
      String rep = representanteLegalController.text;
      String dataFund = widget.dataFundacao;
      String cep = widget.cep;
      String setor = widget.setor;
      String senha = senhaController.text;

      var bytes = utf8.encode(senha);
      var digest = sha256.convert(bytes);
      var senhaCodificada = digest.toString();

      var db = await Db.getConnectionStartup();
      var col = db.collection('user');

      await col.insertOne({
        'email' : email,
        'senha' : senhaCodificada,
        'cnpj' : cnpj,
        'status_cadastro' : 'pendente',
        'informacoes_empresa' : {
          'nome' : nome,
          'telefone_empresa' : tel,
          'celular_representante' : cel,
          'nome_representante' : rep,
          'data_fundacao' : dataFund,
          'cep' : cep,
          'setor' : setor,
        }
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroLoginChoose(),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Conta cadastrada com sucesso!!'),
          duration: Duration(seconds: 5),
        ),
      );

      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Erro ao tentar cadastrar.'),
          duration: Duration(seconds: 5),
        ),
      );
      return false;
    }
  }

  //APENAS PARA GERAR UM DIALOG QUE O USUÁRIO DIGITARÁ O CÓDIGO
  void dialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 80,
                ),
                SizedBox(height: 10),
                Text(
                  "Quase lá!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Um código de confirmação foi enviado ao seu email.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  "Código:",
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                TextFormField(
                  controller: codigoVerifController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    if (codigoVerifController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Preencha o código de confirmação para continuar.'),
                          duration: Duration(seconds: 5),
                        ),
                      );
                    } else {
                      setState(() {
                        isLoading = true;
                      });

                      if (codigoVerifController.text == codigo) {
                        try {
                          await cadastrarEmpresa();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Desculpe, ocorreu um erro no sistema...\nTente novamente em instantes.'),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Código incorreto.'),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      }

                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text("Confirmar"),
                )
              ],
            ),
          ),
        );
      },
    );
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Informações Gerais',
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CNPJValidationScreen()),);
                      },
                    )
                  ],
                ),
                SizedBox(height: 30),
                _buildInfoField('CNPJ', widget.cnpj),
                SizedBox(height: 10),
                _buildInfoField('Nome', widget.nome),
                SizedBox(height: 10),
                _buildInfoField('Telefone (Empresa)', widget.telefone),
                SizedBox(height: 10),
                _buildInfoField('Celular (Representante)', '', controller: celularRepresentanteController),
                SizedBox(height: 10),
                _buildInfoField('Email', '', controller: emailController),
                SizedBox(height: 10),
                _buildInfoField('Representante Legal', '', controller: representanteLegalController),
                SizedBox(height: 10),
                _buildInfoField('Data Fundação', widget.dataFundacao),
                SizedBox(height: 10),
                _buildInfoField('CEP', widget.cep),
                SizedBox(height: 10),
                _buildInfoField('Setor', widget.setor),
                SizedBox(height: 10),
                _buildInfoField('Senha', '', controller: senhaController),
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
                if (celularRepresentanteController.text.isEmpty || celularRepresentanteController.text == "N/A" || emailController.text.isEmpty
                    || representanteLegalController.text.isEmpty || representanteLegalController.text == "N/A" || senhaController.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Preencha todos os campos.\nNão são aceitos campos vazios ou N/A.'), duration: Duration(seconds: 5),),
                  );
                } else {
                  emailConfirmacao();
                  dialog();
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF1F6E8D),
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Finalizar', style: TextStyle(fontSize: 16)),
            ),
          ),
        )
    );
  }

  Widget _buildInfoField(String label, String initialValue, {TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 6),
        TextFormField(
          controller: controller ?? TextEditingController(text: initialValue),
          readOnly: controller == null,
          obscureText: label == 'Senha' ? _obscureText : false,
          inputFormatters: label == 'Celular (Representante)' ? [MaskedInputFormatter('(##) #####-####')] : [],
          keyboardType: label == 'Celular (Representante)' ? TextInputType.number : TextInputType.text,
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[350],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: label == 'Senha' ? IconButton(
              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ) : null,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}