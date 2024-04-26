import 'package:eztransfer/models/passwordfield.dart';
import 'package:flutter/material.dart';

import 'Confirm.dart';
import 'models/validator.dart';

class Reciever extends StatefulWidget {
  const Reciever({super.key});

  @override
  State<Reciever> createState() => _RecieverState();
}

class _RecieverState extends State<Reciever> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordcontroller = TextEditingController();
  var _isObscured;

  @override
  void initState() {
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
      appBar: AppBar(
        title: const Text("Reciever"),
        centerTitle: true,
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Scan Sender's QR Code",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                side:
                    const BorderSide(width: 3, color: Colors.lightGreenAccent),
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {},
              child: const Text("Scan Code"),
            ),
            SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: PasswordField(
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
            ),
            const SizedBox(
              height: 30,
            ),
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (contect) => ConfirmationPage()));
                  }
                },
                child: const Text("Confirm"))
          ],
        ),
      ),
    );
  }
}
