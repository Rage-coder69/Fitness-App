import 'package:app/screens/dash_board_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static String id = '/';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isLoading = false;

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  check if user details are stored in local storage
    //  if yes, navigate to home screen
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          isLoading = true;
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushNamed(context, DashBoardScreen.id);
        });
      }
    } catch (e) {
      print(e);
    }
    //  if no, navigate to login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: ModalProgressHUD(
        progressIndicator: const CircularProgressIndicator(
          color: Colors.white,
        ),
        inAsyncCall: isLoading,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1E1E1E),
                    Color(0xFF1E1E1E),
                  ],
                ),
                image: DecorationImage(
                  image: AssetImage(
                      'images/home.jpg') /*NetworkImage('http://harisrahat.mo.cloudinary.net/fitness')*/ /*AssetImage('images/home.jpg')*/,
                  fit: BoxFit.cover,
                ),
              ),
              foregroundDecoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00000000),
                    Color(0x00000000),
                    Color(0xD4000000),
                    Color(0xD4000000),
                  ],
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pump',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    children: [
                      const Text('Solutions for Body Fit',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        height: 35.0,
                      ),
                      const Text(
                          'Pump is the best solution for making your body fit & healthy',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        height: 35.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RawMaterialButton(
                            constraints:
                                BoxConstraints.tight(const Size(56, 56)),
                            onPressed: () {
                              Navigator.pushNamed(context, LoginScreen.id);
                            },
                            shape: CircleBorder(
                              side: BorderSide(
                                color: Colors.black,
                                width: 5.0,
                                //strokeAlign: StrokeAlign.inside,
                              ),
                            ),
                            fillColor: Colors.white,
                            child: const Icon(Icons.arrow_forward),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Photo by Photo by <a href="https://unsplash.com/@visualsbyroyalz?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Anastase Maragos</a> on <a href="https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
