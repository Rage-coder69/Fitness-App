import 'package:app/constants.dart';
import 'package:app/screens/dash_board_screen.dart';
import 'package:app/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String id = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController emailTextFieldController = TextEditingController();
  TextEditingController passwordTextFieldController = TextEditingController();
  late String email;
  late String password;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/login.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            foregroundDecoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xD4000000),
                  Color(0x00000000),
                  Color(0x00000000),
                  Color(0xD4000000),
                  Color(0xD4000000),
                ],
              ),
            ),
          ),
          SafeArea(
            child: ListView(reverse: true, children: [
              Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: SizedBox(
                  //720
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top,
                  /*    MediaQuery.of(context).viewInsets.bottom,*/
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: const Text(
                          'Ready to Pump?',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      /*const SizedBox(height: 20.0),*/
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextField(
                                  controller: emailTextFieldController,
                                  style: const TextStyle(
                                    color: Color(0xE8184045),
                                  ),
                                  cursorColor: const Color(0xE8184045),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: kTextFieldDecoration.copyWith(
                                    hintText: 'Enter your email',
                                  ),
                                  onChanged: (value) {
                                    email = value;
                                  },
                                ),
                                const SizedBox(height: 20.0),
                                TextField(
                                  controller: passwordTextFieldController,
                                  obscureText: true,
                                  style:
                                      const TextStyle(color: Color(0xE8184045)),
                                  cursorColor: const Color(0xE8184045),
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: kTextFieldDecoration.copyWith(
                                    hintText: 'Enter your password',
                                  ),
                                  onChanged: (value) {
                                    password = value;
                                  },
                                ),
                                const SizedBox(height: 40.0),
                                TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      UserCredential user = await _auth
                                          .signInWithEmailAndPassword(
                                              email: email, password: password);
                                      if (user != null) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Navigator.pushNamed(
                                            context, DashBoardScreen.id);
                                      }
                                    } catch (e) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      print(e);
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFF184045),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    child: Text('Sign In',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                                const SizedBox(height: 40.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Don\'t have an account?',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, RegisterScreen.id);
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 5.0),
                                        child: Text('Sign Up',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF184045),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

// Photo by <a href="https://unsplash.com/@victorfreitas?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Victor Freitas</a> on <a href="https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

//0XFF060608

//Google login button
/*TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFF244A4F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.mail, color: Colors.white),
                                  SizedBox(width: 10.0),
                                  Text('Gmail',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            ),
                          ),*/
