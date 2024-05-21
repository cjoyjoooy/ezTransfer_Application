import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eztransfer/authenticator.dart';
import 'package:eztransfer/models/passwordfield.dart';
import 'package:eztransfer/models/textfield.dart';
import 'package:eztransfer/models/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eztransfer/user.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  late String errormessage;
  late bool isError;

  var _isObscured;

  @override
  void initState() {
    errormessage = "This is an error";
    isError = false;
    super.initState();
    _isObscured = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'REGISTER',
                    style: txtstyle,
                  ),
                  const SizedBox(height: 15),
                  mytextfield(
                      txtController: namecontroller,
                      label: "Enter name",
                      validator: validateName),
                  // TextField(
                  //   controller: namecontroller,
                  //   decoration: const InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     labelText: 'Enter name',
                  //     prefixIcon: Icon(Icons.person),
                  //   ),
                  // ),
                  const SizedBox(height: 15),
                  mytextfield(
                      txtController: emailcontroller,
                      label: "Email",
                      validator: validateEmail),
                  // TextField(
                  //   controller: emailcontroller,
                  //   decoration: const InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     labelText: 'Enter Email Address',
                  //     prefixIcon: Icon(Icons.email),
                  //   ),
                  // ),
                  const SizedBox(height: 15),
                  PasswordField(
                    txtController: passwordcontroller,
                    label: "Password",
                    validator: validatePassword,
                    iconVal: _isObscured
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                            child: const Icon(Icons.visibility),
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                            child: const Icon(Icons.visibility_off),
                          ),
                    obscurevalue: _isObscured,
                  ),
                  // TextField(
                  //   obscureText: true,
                  //   controller: passwordcontroller,
                  //   decoration: const InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     labelText: 'Enter password',
                  //     prefixIcon: Icon(Icons.lock),
                  //   ),
                  // ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.lightGreenAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        registerUser();
                      }
                    },
                    child: const Text('Register'),
                  ),
                  const SizedBox(height: 15),
                  (isError)
                      ? Text(
                          errormessage,
                          style: errortxtstyle,
                        )
                      : Container(),
                ],
              ),
            )),
      ),
    );
  }

  var errortxtstyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.red,
    letterSpacing: 1,
    fontSize: 18,
  );
  var txtstyle = const TextStyle(
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    fontSize: 38,
  );

  Future registerUser() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );
      createUser();
      setState(() {
        errormessage = "";
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        errormessage = e.message.toString();
      });
    }
  }

  Future createUser() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;
    final docUser = FirebaseFirestore.instance.collection('User').doc(userid);

    final newUser = Users(
      id: userid,
      name: namecontroller.text,
      email: emailcontroller.text,
    );

    final json = newUser.toJson();
    await docUser.set(json);
    goToAuthenticator();
  }

  goToAuthenticator() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Authenticator(),
      ),
    );
  }
}
