import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/snackBar.dart';
import '../constants.dart';
import '../utils/auth_methods.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static String id = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController nameTextFieldController = TextEditingController();
  TextEditingController emailTextFieldController = TextEditingController();
  TextEditingController passwordTextFieldController = TextEditingController();

  // late String email;
  // late String password;
  Uint8List? _image;
  bool isLoading = false;

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No image selected');
  }

  void selectImage() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    print(image == null);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String? res = await AuthMethods().signUpUser(
      email: emailTextFieldController.text,
      password: passwordTextFieldController.text,
      name: nameTextFieldController.text,
      file: _image!,
    );
    setState(() {
      isLoading = false;
    });
    if (res != 'success') {
      setState(() {
        isLoading = false;
      });
      showSnackBar(res!, context);
    }
    setState(() {
      isLoading = false;
      _image = null;
    });
    nameTextFieldController.clear();
    emailTextFieldController.clear();
    passwordTextFieldController.clear();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameTextFieldController.dispose();
    emailTextFieldController.dispose();
    passwordTextFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          leadingWidth: 90.0,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: RawMaterialButton(
            shape: const CircleBorder(),
            constraints: const BoxConstraints.tightFor(
              width: 20.0,
              height: 20.0,
            ),
            padding: EdgeInsets.all(0.0),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 30.0,
            ),
          )),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/register.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black54,
                    BlendMode.darken,
                  ),
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
                    width: constraints.maxWidth,
                    height: MediaQuery.of(context).size.longestSide -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context)
                            .padding
                            .top /*constraints.maxHeight - (AppBar().preferredSize.height + 23.0)*/,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Welcome to the Club!',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        /*const SizedBox(height: 185.0),*/
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                color: Colors.transparent,
                                padding:
                                    EdgeInsets.only(top: 10.0, bottom: 10.0),
                                alignment: Alignment.center,
                                child: Stack(
                                  children: [
                                    _image != null
                                        ? CircleAvatar(
                                            radius: 64,
                                            backgroundImage:
                                                MemoryImage(_image!),
                                          )
                                        : const CircleAvatar(
                                            radius: 64,
                                            backgroundImage: NetworkImage(
                                                'http://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
                                          ),
                                    Positioned(
                                      bottom: -10,
                                      left: 80,
                                      child: IconButton(
                                        onPressed: selectImage,
                                        icon: const Icon(
                                          Icons.add_a_photo,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              TextField(
                                style: const TextStyle(
                                  color: Color(0xE8184045),
                                ),
                                controller: nameTextFieldController,
                                cursorColor: const Color(0xFF184045),
                                keyboardType: TextInputType.name,
                                decoration: kTextFieldDecoration.copyWith(
                                  hintText: 'Enter your name',
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              TextField(
                                controller: emailTextFieldController,
                                style: const TextStyle(
                                  color: Color(0xE8184045),
                                ),
                                cursorColor: const Color(0xFF184045),
                                keyboardType: TextInputType.emailAddress,
                                decoration: kTextFieldDecoration.copyWith(
                                  hintText: 'Enter your email',
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              TextField(
                                controller: passwordTextFieldController,
                                obscureText: true,
                                style: const TextStyle(
                                  color: Color(0xE8184045),
                                ),
                                cursorColor: const Color(0xFF184045),
                                keyboardType: TextInputType.visiblePassword,
                                decoration: kTextFieldDecoration.copyWith(
                                  hintText: 'Enter your password',
                                ),
                              ),
                              const SizedBox(height: 35.0),
                              TextButton(
                                onPressed:
                                    signUpUser /*() async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  emailTextFieldController.clear();
                                  passwordTextFieldController.clear();
                                  try {
                                    UserCredential user = await _auth
                                        .createUserWithEmailAndPassword(
                                            email:
                                                emailTextFieldController.text,
                                            password:
                                                passwordTextFieldController
                                                    .text);
                                    if (user != null) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      print('user created');
                                      Navigator.pop(context);
                                    }
                                  } catch (e) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    print(e);
                                  }
                                }*/
                                ,
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFF184045),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 35.0),
                              const Text(
                                'By tapping Sign Up, you agree to our Terms of Service and Privacy Policy',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

//Photo by <a href="https://unsplash.com/@nate_dumlao?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Nathan Dumlao</a> on <a href="https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

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
