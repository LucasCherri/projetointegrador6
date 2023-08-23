import 'package:flutter/material.dart';
import 'package:projeto_integrador6/CadastroEmpresa/Cadastro.dart';
import 'package:projeto_integrador6/CadastroInvestidor/CadastroInvestidor.dart';
import 'package:projeto_integrador6/Cadastro_Login_choose.dart';
import 'package:projeto_integrador6/Login.dart';

class InvestidorStartupChoose extends StatefulWidget {
  const InvestidorStartupChoose({Key? key}) : super(key: key);

  @override
  _InvestidorStartupChooseState createState() => _InvestidorStartupChooseState();
}

class _InvestidorStartupChooseState extends State<InvestidorStartupChoose> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF384870B2),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cadastro',
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CadastroLoginChoose()),);
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
                Text("Escolha uma das opções abaixo para continuar com o processo de cadastro!", style: TextStyle(fontSize: 21, fontFamily: 'Outfit',
                    fontWeight: FontWeight.w300, color: Colors.white)),
                SizedBox(
                  height: 80,
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CNPJValidationScreen(),
                      ),
                    );
                  },
                  child: Text('Empresa'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    primary: Color(0xFF1F6E8D),
                    onPrimary: Colors.white,
                    textStyle: TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CadastroInvestidor(),
                      ),
                    );
                  },
                  child: Text('Investidor(a)'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    primary: Colors.white,
                    onPrimary: Color(0xFF1F6E8D),
                    textStyle: TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                    },
                    child: Text("Já possui uma conta?", style: TextStyle(fontSize: 15, fontFamily: 'Outfit',
                        fontWeight: FontWeight.w400, color: Color(0xFF3696BE), decoration: TextDecoration.underline)),)
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }
}
