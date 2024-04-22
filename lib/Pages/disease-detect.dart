import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dio/dio.dart';
import 'package:plantify/Provider/auth.dart';

import 'AnalysisResultScreen.dart';

class DiseaseDetect extends StatefulWidget {
  const DiseaseDetect({super.key});

  @override
  State<DiseaseDetect> createState() => _DiseaseState();
}

class _DiseaseState extends State<DiseaseDetect> {
  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? imageFile;
  var isWeb = kIsWeb;
  // Initial Selected Value
  final List<String> items = ["Apple", "Cassava", "Cherry", "Chili", "Coffee", "Corn", "Cucumber", "Gauva", "Grape", "Jamun", "Lemon", "Mango", "Peach", "Pepper", "Pomegranate", "Potato", "Rice", "Soybean", "Strawberry", "Sugarcane", "Tea", "Tomato", "Wheat"];
  String? selectedValue;

  String URL = URLprovider.BaseUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage: AssetImage("assets/logogreen.png"),
          radius: 30.0,
          backgroundColor: Color(0xff181a20),
        ), // Your logo widget
        title: const Text(
          "Diagnose",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true, // Aligns title to the center
        backgroundColor: Color(0xff181a20),
      ),
      backgroundColor: Color(0xFF181a20),
      body: Center(
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 4.0,
              margin: const EdgeInsets.all(10.0),
              color: Color(0xFF1f222a),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/scanlogo.png",
                      width: 80.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Check Your Plant",
                            style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            "Take photos, start diagnose diseases. & get plant care tips.",
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (isWeb) {
                                showImagePicker(context);
                              } else {
                                // Check if permissions are granted
                                Map<Permission, PermissionStatus> statuses =
                                    await [
                                  Permission.camera,
                                ].request();
                                // Check if both permissions are granted
                                if (statuses[Permission.camera]!.isGranted) {
                                  showImagePicker(context);
                                } else {
                                  // If permissions are not granted, show a dialog
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Permissions Required"),
                                        content: Text(
                                            "Please grant the necessary permissions to access the camera and storage."),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("OK"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Select The Photo',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Color(0xFF00a86b)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select the Plant",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Select Item',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  items: items
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  value: selectedValue,
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value!;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    width: 450,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: Color(0xFF1f222a),
                    ),
                    elevation: 2,
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                    iconSize: 14,
                    iconEnabledColor: Color(0xFF00a86b),
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    width: 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Color(0xFF1f222a),
                    ),
                    offset: const Offset(-20, 0),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all<double>(6),
                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            if (imageFile == null) Image.asset(
                    'assets/logo.png',
                    height: 250.0,
                    width: 200.0,
                  ) else ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Image.file(
                      imageFile!,
                      height: 250.0,
                      width: 200.0,
                      fit: BoxFit.fill,
                    )),
            ElevatedButton(
              onPressed: () async {
                if (imageFile != null) {
                  final client = ImageClassifierClient(
                    baseUrl: URL,
                  );
                  try {
                    final response = await client.predictImageClass(
                      imageFile!.path
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnalysisResultScreen(
                          predictedClass: response,
                          imageFile: imageFile!,
                        ),
                      ),
                    );
                  } on Exception catch (e) {
                    print('Error classifying image: $e');
                    // Handle error, for example, show an error message in your UI
                  }
                }
              },
              child: Text(
                'Analysis',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Color(0xFF00a86b),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  final picker = ImagePicker();

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                      child: Column(
                        children: const [
                          Icon(
                            Icons.image,
                            size: 60.0,
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "Gallery",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.pop(context);
                      },
                    )),
                    Expanded(
                        child: InkWell(
                      child: SizedBox(
                        child: Column(
                          children: const [
                            Icon(
                              Icons.camera_alt,
                              size: 60.0,
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              "Camera",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.pop(context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  _imgFromGallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      if (value != null) {
        var isWeb = kIsWeb;
        if (isWeb) {
          setState(() {
            imageFile = File(value.path);
          });
        } else {
          _cropImage(File(value.path));
        }
      }
    });
  }

  _imgFromCamera() async {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((value) {
      if (value != null) {
        var isWeb = kIsWeb;
        if (isWeb) {
          setState(() {
            imageFile = File(value.path);
          });
        } else {
          _cropImage(File(value.path));
        }
      }
    });
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Image Cropper",
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: "Image Cropper",
          )
        ]);
    if (croppedFile != null) {
      imageCache.clear();
      setState(() {
        imageFile = File(croppedFile.path);
      });
      // reload();
    }
  }
}

class ImageClassifierClient {
  final String baseUrl;

  const ImageClassifierClient({required this.baseUrl});

  Future<String> predictImageClass(String imageFile) async {
    File tempImage = File(imageFile);
    final Dio dio = Dio();
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(tempImage.path,
          filename: tempImage.path.split('/').last),
    });

    try {
      final response = await dio.post(
        '$baseUrl/predict',
        data: formData,
        options: Options(
          contentType: Headers
              .formUrlEncodedContentType, // Set content type for FormData
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data ;
        String predicted_class = responseData['predicted_class'];
        return predicted_class;
      } else {
        throw Exception(
            'Failed to predict image class. Status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Error sending request: ${e}');
    } catch (e) {
      rethrow; // Rethrow unexpected exceptions
    }
  }
}
