import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class BrokerFileUpload extends StatefulWidget {
  @override
  _BrokerFileUploadState createState() => _BrokerFileUploadState();
}

class _BrokerFileUploadState extends State<BrokerFileUpload>
    with SingleTickerProviderStateMixin {
  final String _image =
      'https://ouch-cdn2.icons8.com/84zU-uvFboh65geJMR5XIHCaNkx-BZ2TahEpE9TpVJM/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODU5/L2E1MDk1MmUyLTg1/ZTMtNGU3OC1hYzlh/LWU2NDVmMWRiMjY0/OS5wbmc.png';
  late AnimationController loadingController;
  File? _file;
  PlatformFile? _platformFile;

  Future<void> selectFile() async {
    // Request permission
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      // Open file picker
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'png', 'jpg', 'jpeg'],
        );

        if (result != null) {
          setState(() {
            _file = File(result.files.single.path!);
            _platformFile = result.files.first;
          });

          loadingController.forward();
        }
      } catch (e) {
        print('Error picking file: $e');
      }
    } else {
      print('Permission denied');
    }
  }

  Future<void> uploadFile() async {
    if (_file == null || _platformFile == null) {
      print('No file selected.');
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://your-server-endpoint.com/upload'), // Replace with your server URL
      );

      request.files.add(
        await http.MultipartFile.fromPath('file', _file!.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        print('File uploaded successfully!');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('File uploaded successfully!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print('File upload failed: ${response.statusCode}');
        _showErrorDialog('File upload failed. Please try again.');
      }
    } catch (e) {
      print('Error during upload: $e');
      _showErrorDialog('An error occurred while uploading the file.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Image.network(_image, width: 300),
            const SizedBox(height: 50),
            Text(
              'Upload your file',
              style: TextStyle(
                fontSize: 25,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'File should be jpg, png, pdf, doc',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: selectFile,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 20.0),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  dashPattern: const [10, 4],
                  strokeCap: StrokeCap.round,
                  color: Colors.blue.shade400,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50.withOpacity(.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Iconsax.folder_open,
                            color: Colors.blue, size: 40),
                        const SizedBox(height: 15),
                        Text(
                          'Select your file',
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _platformFile != null
                ? Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected File',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 15),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                offset: const Offset(0, 1),
                                blurRadius: 3,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              _platformFile!.extension != null &&
                                      ['png', 'jpg', 'jpeg']
                                          .contains(_platformFile!.extension)
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(_file!, width: 70),
                                    )
                                  : Icon(Icons.insert_drive_file,
                                      color: Colors.blue, size: 40),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _platformFile!.name,
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.black),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '${(_platformFile!.size / 1024).ceil()} KB',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade500),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      height: 5,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.blue.shade50,
                                      ),
                                      child: LinearProgressIndicator(
                                          value: loadingController.value),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: uploadFile,
                          child: const Text('Upload File'),
                        ),
                      ],
                    ),
                  )
                : Container(),
            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }
}
