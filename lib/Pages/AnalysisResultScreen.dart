import 'dart:io';

import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plantify/Provider/auth.dart';

class AnalysisResultScreen extends StatefulWidget {
  final String predictedClass;
  final File imageFile;

  AnalysisResultScreen({
    required this.predictedClass,
    required this.imageFile,
    Key? key,
  }) : super(key: key);

  @override
  _AnalysisResultScreenState createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  String solution = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analysis Result',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff181a20),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color(0xFF181a20),
      body: SingleChildScrollView(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: Image.file(
              widget.imageFile,
              height: 250.0,
              width: 200.0,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Possible Disease Problem: ${widget.predictedClass}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            fetchResponse();
          },
          style: ElevatedButton.styleFrom(
            elevation: 12.0,
            backgroundColor: Colors.green,
            textStyle: TextStyle(color: Colors.white),
          ),
          child: const Text(
            'Find Solution',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(height: 20), // Add some spacing between the button and the text
        Container(
          padding: EdgeInsets.all(15),
          child: Text(
            solution,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20,)
      ],
    ),
    ),

    );
  }
  Future fetchResponse() async{
    final String apiUrl = URLprovider.BaseUrl + "/disease-plant";

// Prepare the request body
    Map<String, dynamic> requestBody = {
      'input_string': widget.predictedClass,
    };

    try {
      // Create a Dio instance
      Dio dio = Dio();

      // Make the POST request
      final response = await dio.post(
        apiUrl,
        data: requestBody, // Set the request body
        options: Options(
          contentType: 'application/json', // Set the content type header
        ),
      );

      // Check if the request was successful (status code 200)
      print(response);

      if (response.statusCode == 200) {
        // Parse the response data
        Map<String, dynamic> responseData = response.data;
        String solution = responseData['processed_string'];

        setState(() {
          this.solution = solution;
        });
      } else {
        // Handle the error
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
    }
  }
}
