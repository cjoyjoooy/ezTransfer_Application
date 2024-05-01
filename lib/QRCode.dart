import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCode extends StatefulWidget {
  const QRCode({super.key});

  @override
  State<QRCode> createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController passwordcontroller = TextEditingController();

  var _isObscured;

  void initState() {
    super.initState();
    _isObscured = true;
  }

  @override
  void dispose() {
    passwordcontroller.dispose();
    super.dispose();
  }

  String generatePassword() {
    final length = 12;
    final lettersUpperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final lettersLowerCase = 'abcdefghijklmnopqrstuvwxyz';
    final numbers = '0123456789';

    String chars = '';
    chars += '$lettersUpperCase$lettersLowerCase';
    chars += '$numbers';

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);

      return chars[indexRandom];
    }).join('');
  }

  @override
  Widget build(BuildContext context) {
    String password = generatePassword();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send File"),
        centerTitle: true,
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 350,
              color: Colors.white,
              child: QrImageView(
                data: password,
                size: 350,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "Password:   ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  password, //i limit lang arun dili kaayo taas
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            // ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       textStyle: const TextStyle(
            //         fontSize: 18,
            //         fontWeight: FontWeight.bold,
            //       ),
            //       minimumSize: const Size.fromHeight(50),
            //       backgroundColor: Colors.lightGreenAccent,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(15),
            //       ),
            //     ),
            //     onPressed: () {
            //       Navigator.of(context).push(MaterialPageRoute(
            //           builder: (contect) => ConfirmationPage()));
            //     },
            //     child: const Text("Confirm"))
          ],
        ),
      ),
    );
  }
}
