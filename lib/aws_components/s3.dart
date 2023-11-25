import 'package:flutter/material.dart';

import '../helpers/constants.dart';
import '../models/api_model.dart';

class S3BucketComponent extends StatefulWidget {
  const S3BucketComponent({super.key});

  @override
  State<S3BucketComponent> createState() => _S3BucketComponentState();
}

class _S3BucketComponentState extends State<S3BucketComponent> {
  final api =
      ApiService(baseUrl: '${ApiConstants.baseUrl}${ApiConstants.port}');
  Map<String, dynamic> _response = {};
  bool _error = false;
  String _errorMessage = "";

  Future<void> getBucket() async {
    try {
      final resp = await api.getS3("aws/s3");
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
              OutlinedButton(
                  onPressed: () {
                    getBucket();
                  },
                  child: Text("Get Bucket")),
              _error == false
                  ? Text(_response.toString())
                  : Text(_errorMessage),
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Back'))
            ],
          ),
        ),
      ),
    );
  }
}
