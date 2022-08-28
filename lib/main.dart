import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

import 'controllers/image_controller.dart';
import 'services/image_service.dart';

void main() async {
  // Load .env file config
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: 'Upload Image',
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Image'), centerTitle: true),
      body: const Center(
        child: ImageWidget(),
      ),
    );
  }
}

class ImageWidget extends StatefulWidget {
  const ImageWidget({Key? key}) : super(key: key);

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  XFile? _image;
  bool _uploadingImage = false;

  Future<void> _getImage() async {
    try {
      _image = await openCamera();
      setState(() {});
    } catch (_) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error in take picture'),
      ));
    }
  }

  Future<void> _uploadImage() async {
    try {
      setState(() {
        _uploadingImage = true;
      });

      await ImageController.uploadImage(_image!);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Upload successful'),
      ));
    } catch (_) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Upload error'),
      ));
    } finally {
      setState(() {
        _uploadingImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_uploadingImage) ...[
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text('Uploading Image'),
          ] else ...[
            if (_image != null) ...[
              const Text(
                'Picture',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.file(File(_image!.path)),
              ),
              const SizedBox(height: 20),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _getImage,
                child: const Text('Take Picture'),
              ),
            ),
            if (_image != null) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.purple),
                  ),
                  onPressed: _uploadImage,
                  child: const Text('Upload Picture'),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
