import 'package:cpesproject/main.dart';
import 'package:cpesproject/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  bool ValidEmail = false;
  bool PassNotEqualPass = false;
  bool ExistEmail = false;
  bool PassLessthan7 = false;
  bool ExistCivilID = false;
  bool ExistUserName = false;
  bool isLoading = false;
  String UserEmail = '';
  String UserPass = '';
  String UserPassConfirmation = '';
  String UserCivilID = '';
  String UserName = '';
  String errorf = '';
  String UN = '';
  bool isNameEmpty = false;
  bool isUserNameEmpty = false;
  bool baw = false;
  bool isCivilIDEmpty = false;
  String errorMessage = '';
  final _auth = FirebaseAuth.instance;

  void _sumbitAuthForm(String Name, String Usnm,String email,
      String password, BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        isLoading = true;
        ValidEmail = false;
        PassNotEqualPass = false;
        ExistEmail = false;
        PassLessthan7 = false;
        ExistCivilID = false;
        isNameEmpty = false;
        isUserNameEmpty = false;
        isCivilIDEmpty = false;
      });

      print(Usnm);

      if (!email.contains("@") || !email.contains("."))
        setState(() {
          ValidEmail = true;
        });


      if (password.length < 7) {
        setState(() {
          PassLessthan7 = true;
        });
      }
      if (Name.length < 1) {
        setState(() {
          isNameEmpty = true;
        });
      }

      if (Usnm.length < 1) {
        setState(() {
          isUserNameEmpty = true;
        });
      }




      final UserN = await FirebaseFirestore.instance
          .collection('UserNames')
          .doc(Usnm)
          .get();
      if(UserN.exists)
      {
        setState(() {
          ExistUserName = true;
        });
      }

      if (!ValidEmail &&
          !PassNotEqualPass &&
          !ExistEmail &&
          !PassLessthan7 &&
          !ExistCivilID &&
          !isNameEmpty &&
          !isUserNameEmpty &&
          !ExistUserName) {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(authResult.user!.uid);

        String getToken = "";
        FirebaseMessaging.instance.getToken().then((value) => getToken = value!);

        await FirebaseFirestore.instance
            .collection('UserNames')
            .doc(Usnm)
            .set({
          'UserName': Usnm,
          'deviceID': getToken,
          'UID': authResult.user!.uid,
        });
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(authResult.user!.uid)
            .set({
          'Name': Name,
          'email': email.toLowerCase(),
          'psssword': password,
          'isDisability': 'false',
          'deviceID': getToken,
          'UserName': Usnm,
          'FirstTime': "true",


        });
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => MyApp())
        );

      }
    } on FirebaseAuthException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message!;

        switch (err.code) {
          case "invalid-email":
            setState(() {
              ValidEmail = true;
              isLoading = false;
            });
            ValidEmail= true;
            errorMessage = "Your email address appears to be malformed.";
            isLoading = false;
            break;
          case "email-already-in-use":
            setState(() {
              isLoading = false;
              ExistEmail = false;
            });
            ExistEmail = true;
            errorMessage = "email already exist.";
            isLoading = false;
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "ERROR_USER_DISABLED":
            errorMessage = "User with this email has been disabled.";
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            errorMessage = "Too many requests. Try again later.";
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        setState(() {
          isLoading = false;

        });
      }



      setState(() {
        isLoading = false;

      });
    } catch (err) {
      print(err);

      setState(() {
        isLoading = false;

      });
    }

  }
  String Name = "";
  String UserN = "";
  String Email = "";
  String Password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Color(0xff6bceff),
                      Color(0xff6bceff)
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
                    child: Icon(Icons.person,
                      size: 90,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 32,
                          right: 32
                      ),
                      child: Text('Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                        ),
                      ),
                    ),
                  ),
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
                        hintText: 'Full Name',
                      ),
                      onChanged: (value)
                      {
                        Name = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
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
                        hintText: 'Username',
                      ),
                      onChanged: (value)
                      {
                        UserN = value;

                        print(UserN);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
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
                        hintText: 'Email',
                      ),
                      onChanged: (value)
                      {
                        Email = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
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
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                      onChanged: (value)
                      {
                        Password = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if(isLoading)
                    CircularProgressIndicator()
                  else
                    InkWell(
                      onTap: (){
                        _sumbitAuthForm(Name, UserN, Email, Password, context);
                      },
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width/1.2,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff6bceff),
                                Color(0xFF00abff),
                              ],
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(50)
                            )
                        ),
                        child: Center(
                          child: Text('Sign Up'.toUpperCase(),
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

            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Have an account ?"),
                  Text("Login",style: TextStyle(color: Color(0xff6bceff)),),
                ],
              ),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => LoginPage()),);
              },
            ),
          ],

        ),
      ),
    );
  }
}