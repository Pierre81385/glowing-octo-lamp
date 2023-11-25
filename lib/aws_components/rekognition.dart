import 'package:flutter/material.dart';
import 'package:glowing_octo_lamp/helpers/image_picker.dart';
import '../helpers/constants.dart';
import '../models/api_model.dart';

class RekognitionComponent extends StatefulWidget {
  const RekognitionComponent({super.key});

  @override
  State<RekognitionComponent> createState() => _RekognitionComponentState();
}

class _RekognitionComponentState extends State<RekognitionComponent> {
  final api =
      ApiService(baseUrl: '${ApiConstants.baseUrl}${ApiConstants.port}');
  Map<String, dynamic> _response = {};
  bool _error = false;
  String _errorMessage = "";
  String _image = "";

  Future<void> getRekognition(file) async {
    Map<String, dynamic> image = {'image': file};
    try {
      final resp = await api.postRekognition("aws/rekognition", image);
      setState(() {
        _response = resp;
      });
    } on Exception catch (e) {
      setState(() {
        _error = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ImagePickerComponent(
                onSelect: (value) {
                  _image = value!;
                },
              ),
              OutlinedButton(
                  onPressed: () {
                    getRekognition(_image);
                  },
                  child: Text("Rekognize")),
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Back')),
              Expanded(
                child: ListView(children: [
                  _error == false
                      ? Text(_response.toString())
                      : Text(_errorMessage),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
