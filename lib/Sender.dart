import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:eztransfer/QRCode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eztransfer/transferfiles.dart';

class Sender extends StatefulWidget {
  const Sender({Key? key}) : super(key: key);

  @override
  State<Sender> createState() => _SenderState();
}

class _SenderState extends State<Sender> {
  late String password;
  List<File?> files = [];

  String generatePassword() {
    const length = 12;
    const lettersUpperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lettersLowerCase = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';

    String chars = '';
    chars += '$lettersUpperCase$lettersLowerCase';
    chars += '$numbers';

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);

      return chars[indexRandom];
    }).join('');
  }

  void getMultipleFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );

    if (result != null) {
      List<File?> file = result.paths.map((path) => File(path!)).toList();
      files = file;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select atleast 1 file'),
      ));
    }
  }

  Future<void> uploadFilesToStorage(List<File?> files) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageRef = storage.ref().child('UploadedFiles');

    for (int i = 0; i < files.length; i++) {
      if (files[i] != null) {
        File file = files[i]!;
        String fileName = file.path.split("/").last;

        TaskSnapshot taskSnapshot =
            await storageRef.child(fileName).putFile(file);

        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        print('File uploaded: $downloadUrl');

        await saveTransferDataToFirestore(TransferFiles(
          filename: fileName,
          qrpassword: password,
        ));
      }
    }
  }

  Future<void> saveTransferDataToFirestore(TransferFiles transferFiles) async {
    try {
      await FirebaseFirestore.instance
          .collection('TransferFiles')
          .add(transferFiles.toJson());
      print('Data saved to Firestore');
    } catch (e) {
      print('Error saving data to Firestore: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    password = generatePassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sender"),
        centerTitle: true,
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(width: 3, color: Colors.lightGreenAccent),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: const Icon(
                        Icons.description_outlined,
                        size: 35,
                      ),
                      title: Text(
                        files[index]?.path.split("/").last ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(
                  width: 3,
                  color: Colors.lightGreenAccent,
                ),
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
              onPressed: () async {
                getMultipleFile();
              },
              child: const Text("Choose File"),
            ),
            const SizedBox(
              height: 20,
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
              onPressed: () async {
                await uploadFilesToStorage(files);
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => QRCode(password: password)),
                );
              },
              child: const Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}
