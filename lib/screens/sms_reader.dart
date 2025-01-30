import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class EBillReaderPage extends StatefulWidget {
  @override
  _EBillReaderPageState createState() => _EBillReaderPageState();
}

class _EBillReaderPageState extends State<EBillReaderPage> {
  File? _image;
  List<Map<String, dynamic>> _recognizedFoodItems = [];
  List<List<dynamic>> _csvData = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadCsvData();
  }

  Future<void> _loadCsvData() async {
    final String csvString = await rootBundle.loadString('assets/food_data.csv');
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString);

    setState(() {
      _csvData = csvTable;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _recognizedFoodItems = [];
      });
      await _extractTextFromImage();
    }
  }

  Future<void> _extractTextFromImage() async {
    if (_image == null) {
      print("No image selected!");
      return;
    }

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFile(_image!);

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      textRecognizer.close();

      _filterFoodItems(recognizedText.text);
    } catch (e) {
      print("Error recognizing text: $e");
      setState(() {
        _recognizedFoodItems = [];
      });
    }
  }

  void _filterFoodItems(String extractedText) {
    List<String> extractedWords = extractedText.toLowerCase().split("\n");
    List<Map<String, dynamic>> matchedFoods = [];

    for (String word in extractedWords) {
      for (var row in _csvData.skip(1)) {
        String foodName = row[0].toString().toLowerCase();
        String classification = row[1].toString().toLowerCase(); // Fetch classification from CSV

        // Match only food items based on the extracted text
        if (word.contains(foodName) && !matchedFoods.any((item) => item['name'] == foodName)) {
          matchedFoods.add({
            'name': foodName,
            'classification': classification, // Add classification here
          });
        }
      }
    }

    setState(() {
      _recognizedFoodItems = matchedFoods;
    });
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("How to Use"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Upload an image of your bill and check if the items you bought are healthy or junk.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text("Junk"),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  SizedBox(width: 10),
                  Text("Healthy"),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Bill Reader"),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_image != null) Image.file(_image!, height: 200),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Pick an Image"),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: _recognizedFoodItems.isEmpty
                  ? Text("No recognized food items found!", textAlign: TextAlign.center)
                  : Column(
                children: _recognizedFoodItems.map((item) {
                  return ListTile(
                    title: Text("${item['name']}"),
                    subtitle: Text("${item['classification']}"),
                    trailing: Icon(
                      item['classification'] == "junk"
                          ? Icons.close // Red Cross for Junk
                          : Icons.check_circle, // Green Tick for Healthy
                      color: item['classification'] == "junk"
                          ? Colors.red
                          : Colors.green,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
