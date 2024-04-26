// ignore: file_names
import 'dart:io';

import 'package:eztransfer/QRCode.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Sender extends StatefulWidget {
  Sender({super.key});

  @override
  State<Sender> createState() => _SenderState();
}

class _SenderState extends State<Sender> {
  @override
  getMultipleFile() async {
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

  List<File?> files = [];
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
                    border:
                        Border.all(width: 3, color: Colors.lightGreenAccent),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Scrollbar(
                    child: ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: const Icon(
                        Icons.description_outlined,
                        size: 35,
                      ),
                      title: Text(files[index]!.path.split("/").last,
                          // To show name of files selected
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black)),
                    );
                  },
                )),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                      width: 3, color: Colors.lightGreenAccent),
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
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (contect) => QRCode()));
                },
                child: const Text("Confirm"),
              ),
            ],
          ),
        ));
  }
}
