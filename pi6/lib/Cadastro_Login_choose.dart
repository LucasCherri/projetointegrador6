import 'package:flutter/material.dart';
import 'package:projeto_integrador6/Investidor_Startup_choose.dart';
import 'package:projeto_integrador6/Login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CadastroLoginChoose(),
    );
  }
}

class CadastroLoginChoose extends StatefulWidget {
  const CadastroLoginChoose({Key? key}) : super(key: key);

  @override
  _CadastroLoginChooseState createState() => _CadastroLoginChooseState();
}

class _CadastroLoginChooseState extends State<CadastroLoginChoose> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF384870B2),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Start", style: TextStyle(fontSize: 38, fontFamily: 'Outfit',
                      fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("Venture", style: TextStyle(fontSize: 35, fontFamily: 'Outfit',
                      fontWeight: FontWeight.bold, color: Color(0xFF1F6E8D))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Invest", style: TextStyle(fontSize: 32, fontFamily: 'Outfit',
                      fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              SizedBox(height: 130,),
              Text("Seja bem-vindo(a)", style: TextStyle(fontSize: 28, fontFamily: 'Outfit',
                  fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 40,),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 2, 0, 20),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InvestidorStartupChoose(),
                            ),
                          );
                        },
                        child: Text('Cadastro'),
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
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 2, 0, 80),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text('Login'),
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
