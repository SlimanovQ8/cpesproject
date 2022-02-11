import 'package:cpesproject/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }
  final GlobalKey<FormState> _formKePy = new GlobalKey<FormState>();

  bool ValidEmail = false;
  bool ValidMoiNumber = false;
  bool ValidPass = false;
  bool isLoading = false;
  bool isCivPressed = true;
  String UserEmail = '';
  String UserPass = '';
  final _auth = FirebaseAuth.instance;


  void _sumbitAuthForm( String email,
      String password, BuildContext ctx) async {
    UserCredential authResult;
    try {
      print(email);
      setState(() {
        isLoading = true;
        ValidEmail = false;
      });


      authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );



      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => MyApp()),);


    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message!;

        // ignore: deprecated_member_use
        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme
                .of(ctx)
                .errorColor,
          ),
        );
      }
      setState(() {
        isLoading = false;
        ValidEmail = true;
      });
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
        ValidEmail = true;
      });
    }
  }

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff4a8cff),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/3.5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff014c8f),
                      Color(0xff014c8f)
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(90)
                  )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: ImageIcon(
                      AssetImage("images/nbkLogo.png"),
                      color: Colors.black,

                      size: 160,
                    ),
                  ),
                  Spacer(),

                ],
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height/2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 62),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 45,
                    padding: EdgeInsets.only(
                        top: 4,left: 16, right: 16, bottom: 4
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(50)
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5
                          )
                        ]
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.person,
                          color: Color(0xff4a8cff),
                        ),
                        hintText: 'Username',
                      ),
                      onChanged: (value)
                      {
                        email = value;
                      },
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 45,
                    margin: EdgeInsets.only(top: 32),
                    padding: EdgeInsets.only(
                        top: 4,left: 16, right: 16, bottom: 4
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(50)
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5
                          )
                        ]
                    ),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.vpn_key,
                          color: Color(0xff4a8cff),
                        ),
                        hintText: 'Password',
                      ),
                      onChanged: (value)
                      {
                        password = value;
                      },
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16, right: 32
                      ),
                      child: Text('Forgot Password ?',
                        style: TextStyle(
                            color: Colors.grey
                        ),
                      ),
                    ),
                  ),
                  Spacer(),

                  if(isLoading)
                    CircularProgressIndicator()
                  else
                    InkWell(
                      onTap: (){
                        _sumbitAuthForm(email, password, context);
                      },
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width/1.2,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff4a8cff),
                                Color(0xFF00abff),
                              ],
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(50)
                            )
                        ),
                        child: Center(
                          child: Text('Login'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Dnon't have an account ?"),
                  Text("Sign Up",style: TextStyle(color: Color(0xff4a8cff)),),
                ],
              ),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => SignupPage()),);

              },
            ),
          ],

        ),
      ),
    );
  }
}