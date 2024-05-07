import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eztransfer/models/passwordfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'models/validator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Receiver extends StatefulWidget {
  const Receiver({Key? key}) : super(key: key);

  @override
  State<Receiver> createState() => _ReceiverState();
}

class _ReceiverState extends State<Receiver> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  var _isObscured = true;

  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receiver"),
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
              onPressed: () {
                _startScan();
              },
              child: const Text("Scan Code"),
            ),
            SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: PasswordField(
                txtController: passwordController,
                label: "Password",
                validator: validatePassword,
                iconVal: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                  child: Icon(
                      _isObscured ? Icons.visibility : Icons.visibility_off),
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
                  // Check password in Firestore
                  checkPasswordInFirestore(passwordController.text.trim());
                }
              },
              child: const Text("Confirm"),
            )
          ],
        ),
      ),
    );
  }

  void _startScan() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            Expanded(
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ],
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        passwordController.text = scanData.code!;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> checkPasswordInFirestore(String password) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('TransferFiles')
          .where('qrPassword', isEqualTo: passwordController.text.trim())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Password matches, display "File Found" message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File Found'),
          ),
        );

        // Retrieve the filename and download the file
        String filename = querySnapshot.docs.first.get('filename');
        downloadFileFromStorage(filename);
      } else {
        // No matching password found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid password'),
          ),
        );
      }
    } catch (e) {
      // Error handling
      print('Error checking password in Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error checking password. Please try again.'),
        ),
      );
    }
  }

  void downloadFileFromStorage(String filename) async {
    try {
      // Get reference to the file in Firebase Storage
      Reference ref =
          FirebaseStorage.instance.ref().child('UploadedFiles/$filename');

      // Get temporary directory path
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      // Create File object with temporary path
      File downloadToFile = File('$tempPath/$filename');

      // Download the file to device storage
      await ref.writeToFile(downloadToFile);

      // File downloaded successfully
      print('File downloaded to: ${downloadToFile.path}');
    } catch (e) {
      // Error handling
      print('Error downloading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error downloading file. Please try again.'),
        ),
      );
    }
  }
}
