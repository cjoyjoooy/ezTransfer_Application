import 'package:eztransfer/models/passwordfield.dart';
import 'package:eztransfer/models/textfield.dart';
import 'package:eztransfer/models/validator.dart';
import 'package:eztransfer/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernamecontroller = TextEditingController();
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
                    'SIGN IN',
                    style: txtstyle,
                  ),
                  const SizedBox(height: 15),
                  mytextfield(
                      txtController: usernamecontroller,
                      label: "Email",
                      validator: validateEmail),
                  // TextField(
                  //   controller: usernamecontroller,
                  //   decoration: const InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     labelText: 'Enter Username',
                  //     prefixIcon: Icon(Icons.person),
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
                  //     labelText: 'Enter Password',
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
                        checkLogin(
                          usernamecontroller.text,
                          passwordcontroller.text,
                        );
                      }
                    },
                    child: const Text('LOGIN'),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          color: Colors
                              .lightGreenAccent, // Choose your border color
                          width: 3, // Set the border width to 2
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Register(),
                        ),
                      );
                    },
                    child: const Text('Sign Up'),
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

  void checkLogin(username, password) async {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      setState(() {
        errormessage = "";
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        errormessage = e.message.toString();
      });
    }
    Navigator.pop(context);
  }
}
