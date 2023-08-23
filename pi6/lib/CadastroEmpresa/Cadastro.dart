import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:projeto_integrador6/CadastroEmpresa/Cadastro1.dart';
import 'package:projeto_integrador6/Settings/db.dart';

class CNPJValidationScreen extends StatefulWidget {
  @override
  _CNPJValidationScreenState createState() => _CNPJValidationScreenState();
}

class _CNPJValidationScreenState extends State<CNPJValidationScreen> {
  String cnpj = "";
  String nome = "";
  String telefone = "";
  String email = "";
  String rep = "";
  String dataFundacao = "";
  String cep = "";
  String setor = "";
  bool isLoading = false;
  bool isVerifying = false;
  bool isValid = false;

  //FUNÇÃO QUE CHAMA API NO PYTHON PARA CONSULTAR CNPJ DIGITADO
  Future<void> consultarCNPJ() async {
    setState(() {
      isLoading = true;
      nome = "";
      telefone = "";
      email = "";
      rep = "";
      dataFundacao = "";
      cep = "";
      setor = "";
    });

    final dio = Dio();

    try {
      final response = await dio.get(
        "http://seu_ip_aqui:5000/consulta_cnpj",
        queryParameters: {"cnpj": cnpj},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          nome = data["nome"];
          telefone = data["telefone"] ?? "N/A";
          email = data["email"] ?? "N/A";
          rep = data["nome_ceo"] ?? "N/A";
          dataFundacao = data["data_fundacao"] ?? "N/A";
          cep = data["cep"] ?? "N/A";
          setor = data["setor"] ?? "N/A";
          isValid = true;
        });
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('CNPJ inválido.'), duration: Duration(seconds: 5),),
          );
          isValid = false;
        });
      }
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao validar CNPJ.\nTente novamente mais tarde!'), duration: Duration(seconds: 5)),
        );
        isValid = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //FUNÇÃO PARA VERIFICAR SE JÁ EXISTE CNPJ CADASTRADO
  void verificarExistenciaCadastro() async {
    setState(() {
      isVerifying = true;
    });

    var db = await Db.getConnectionStartup();
    var col = db.collection('user');

    try {
      var doc = await col.findOne(mongo.where.eq('cnpj', cnpj));

      if (doc == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Cadastro1(
              cnpj,
              nome,
              telefone,
              email,
              rep,
              dataFundacao,
              cep,
              setor,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('CNPJ já cadastrado.'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Desculpe, ocorreu um erro no sistema...\nTente novamente em instantes.',
          ),
          duration: Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF384870B2),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: const EdgeInsets.only(top: 60, left: 16.0, right: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
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
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 50,),
                  Text(
                    'Informe o CNPJ:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        cnpj = value;
                      });
                    },
                    maxLength: 14,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[350],
                      counterStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.black),
                  ),

                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if(cnpj.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Preencha todos os campos.'), duration: Duration(seconds: 5)),
                          );
                        }else{
                          consultarCNPJ();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF1F6E8D),
                        onPrimary: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text('Validar', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  SizedBox(height: 10),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : isValid
                      ? Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Card(
                      color: Color(0xFF1F6E8D),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.check, color: Colors.greenAccent, size: 50),
                            SizedBox(height: 10),
                            Text(
                              nome,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 10),
                            Text("Telefone: $telefone", style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10),
                            Text("Email: $email", style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10),
                            Text("Rep. Legal: $rep", style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10),
                            Text("Data de Fundação: $dataFundacao", style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10),
                            Text("CEP: $cep", style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10),
                            Text("Setor: $setor", style: TextStyle(color: Colors.white)),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                if (email == "N/A") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Email não cadastrado na base de dados.'),
                                      duration: Duration(seconds: 5),
                                    ),
                                  );
                                } else {
                                  verificarExistenciaCadastro();
                                }
                              },
                              child: isVerifying
                                  ? CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                                  : Text(
                                'Prosseguir',
                                style: TextStyle(fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                minimumSize: Size(double.infinity, 0), // Faz o botão ocupar o width máximo possível
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                      : SizedBox(),
                ],
              ),
            )
        ),
      ),
    );
  }
}
