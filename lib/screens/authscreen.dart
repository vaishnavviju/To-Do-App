import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolistapp/widgets/userimgpicker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formkey = GlobalKey<FormState>();
  var _isLogin = true;
  var emailId = '';
  var uname = '';
  var pwd = '';
  var _isUploading = false;
  File? Img;

  void _submit() async {
    final _isValid = _formkey.currentState!.validate();

    if (!_isValid || !_isLogin && Img == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Authentication failed."),
        ),
      );
      return;
    }

    _formkey.currentState!.save();
    try {
      setState(() {
        _isUploading = true;
      });
      if (_isLogin) {
        final credCheck = await _firebase.signInWithEmailAndPassword(
            email: emailId, password: pwd);
        //print(userCred);
      } else {
        QuerySnapshot emailquery = await FirebaseFirestore.instance
            .collection('users')
            .where("email", isEqualTo: emailId)
            .get();

        print(emailquery.docs);
        QuerySnapshot userquery = await FirebaseFirestore.instance
            .collection('users')
            .where("username", isEqualTo: uname)
            .get();
        if (emailquery.docs.isNotEmpty) {
          throw Exception(
              "Email address already exists. Enter a valid email address.");
        } else if (userquery.docs.isNotEmpty) {
          throw Exception("Username already exists. Enter a valid username.");
        } else {
          // the
          final userCred = await _firebase.createUserWithEmailAndPassword(
              email: emailId, password: pwd);

          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_img')
              .child('${userCred.user!.uid}.jpg');

          await storageRef.putFile(Img!);
          final imgUrl = await storageRef.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCred.user!.uid)
              .set({
            'username': uname,
            'email': emailId,
            'image_url': imgUrl,
          });
          //print(userCred);
        }
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? "Authentication failed.'"),
        ),
      );
    } on Exception catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "This username is already taken. Please enter a new username"),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 251, 169),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(blurRadius: 1.0, blurStyle: BlurStyle.outer)
                    ],
                    borderRadius: BorderRadius.circular(80),
                    color: Color.fromARGB(255, 236, 197, 57)),
                padding: const EdgeInsets.all(14),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                    Text(
                      "To-Do App",
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 2,
                    )
                  ],
                ),
              ),
              if (_isLogin)
                const SizedBox(
                  height: 100,
                ),
              if (!_isLogin)
                const SizedBox(
                  height: 40,
                ),
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      const BoxShadow(
                          blurRadius: 1.0, blurStyle: BlurStyle.outer)
                    ],
                    borderRadius: BorderRadius.circular(80),
                    color: Color.fromARGB(255, 236, 197, 57)),
                padding: EdgeInsets.all(14),
                // margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            UserImgPicker(
                              onPickImage: (pickedImg) {
                                Img = pickedImg;
                              },
                            ),
                          TextFormField(
                            style: GoogleFonts.montserrat(
                                fontSize: 15, color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.mail),
                                prefixIconColor: Colors.white,
                                //fillColor: Colors.white,
                                labelText: 'Email Address',
                                labelStyle: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@') ||
                                  !value.contains('.com')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              emailId = newValue!;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              cursorColor: Colors.white,
                              style: GoogleFonts.montserrat(
                                  color: Colors.white, fontSize: 15),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  prefixIconColor: Colors.white,
                                  labelText: 'Username',
                                  labelStyle: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return 'Please enter atleast 4 characters.';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                uname = newValue!;
                              },
                            ),
                          TextFormField(
                            cursorColor: Colors.white,
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: 15),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                prefixIconColor: Colors.white,
                                labelText: 'Password',
                                labelStyle: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Please enter a valid password';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              pwd = newValue!;
                            },
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          if (_isUploading) const CircularProgressIndicator(),
                          if (!_isUploading)
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(200, 60),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 20),
                                  backgroundColor:
                                      Color.fromARGB(255, 10, 4, 99)),
                              child: Text(_isLogin ? 'Log In' : 'Sign Up',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white, fontSize: 15)),
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (!_isUploading)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                _isLogin
                                    ? 'Create an account.'
                                    : 'I already have an account.',
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
