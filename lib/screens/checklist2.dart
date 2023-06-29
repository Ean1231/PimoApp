import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pimoapp/screens/inspection.dart';
import 'package:pimoapp/screens/userprofile.dart';
import 'package:pimoapp/backend_api/api_service.dart';

import 'home_screen.dart';

class QuizPage2 extends StatefulWidget {
   final String email;
  final String displayName;
  int manageID;
       Position? currentPosition;
  String? currentAddress;
  String currentDate = '';
  QuizPage2({required this.manageID ,required this.email, required this.displayName, required this.currentPosition, required this.currentAddress,required this.currentDate, String? currentSuburb, String? currentPostalCode, String? currentMunicipality});

  @override
  _QuizPage2State createState() => _QuizPage2State();
}

class _QuizPage2State extends State<QuizPage2> {
  int _selectedIndex = 1;
  final APIService apiService = APIService();


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });


    
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(email: widget.email, displayName: widget.displayName, manageID: widget.manageID)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuizPage2(displayName: widget.displayName, email: widget.email, manageID: widget.manageID, currentAddress: widget.currentAddress, currentDate: widget.currentDate, currentPosition: widget.currentPosition,)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(displayName: widget.displayName, email: widget.email, manageID: widget.manageID)),
        );
        break;
    }
  }

  int _currentQuestionIndex = 0;
  int _score = 0;

  final List<String?> _selectedOptions = [];
  TextEditingController _textFieldController = TextEditingController();
  List<List<File?>> _capturedImages = List.generate(5, (_) => List.filled(3, null));

  final List<Map<String, dynamic>> _quizData = [
    {
      'subelement': '5.1 External Walls and Wall Finishes',
      'options': ['C1 (Very Poor)', 'C2 (Poor)', 'C3 (Fair)', 'C4 (Good)', 'C5 (Excellent)'],
      'imageIndexes': [0, 1, 2],
    },
    {
      'subelement': '5.2 External Doors',
      'options': ['C1 (Very Poor)', 'C2 (Poor)', 'C3 (Fair)', 'C4 (Good)', 'C5 (Excellent)'],
      'imageIndexes': [3, 4, 5],
    },
    {
      'subelement': '5.3 External Windows',
      'options': ['C1 (Very Poor)', 'C2 (Poor)', 'C3 (Fair)', 'C4 (Good)', 'C5 (Excellent)'],
      'imageIndexes': [6, 7, 8],
    },
    {
      'subelement': '5.4 External Floors and Finishes',
      'options': ['C1 (Very Poor)', 'C2 (Poor)', 'C3 (Fair)', 'C4 (Good)', 'C5 (Excellent)'],
      'imageIndexes': [9, 10, 11],
    },
    {
      'subelement': '5.5 External Ceiling and Ceiling Finishes',
      'options': ['C1 (Very Poor)', 'C2 (Poor)', 'C3 (Fair)', 'C4 (Good)', 'C5 (Excellent)'],
      'imageIndexes': [12, 13, 14],
    },
    
  ];

  void _checkAnswer() {
    if (_currentQuestionIndex < _quizData.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _textFieldController.clear();
      });
    } else {
      // Quiz is finished
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Inspection Complete'),
            content: Text('Do you want to finish up?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignaturePage(email: widget.email, displayName: widget.displayName)),
                  );
                },
                child: Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  return;
                },
                child: Text('CANCEL'),
              ),
            ],
          );
        },
      );
      final quizData = QuizData(subelement: _quizData[_currentQuestionIndex]['subelement'],selectedOption: _selectedOptions[_currentQuestionIndex], imageIndexes: _quizData[_currentQuestionIndex]['imageIndexes'],);
      apiService.saveQuizDataToServer(quizData);
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _textFieldController.clear();
      });
    }
   
    _selectedOptions[_currentQuestionIndex + 1] = _selectedOptions[_currentQuestionIndex];
  }

  Future<void> _captureImage(int questionIndex, int imageIndex) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _capturedImages[questionIndex][imageIndex] = File(image.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedOptions.addAll(List<String?>.filled(_quizData.length, null));
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFirstQuestion = _currentQuestionIndex == 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Inspection'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _quizData[_currentQuestionIndex]['subelement'],
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                ...(_quizData[_currentQuestionIndex]['options'] as List<String>).map(
                  (option) => RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: _selectedOptions[_currentQuestionIndex],
                    onChanged: (value) {
                      setState(() {
                        _selectedOptions[_currentQuestionIndex] = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: List.generate(
                    3,
                    (index) => Expanded(
                      child: InkWell(
                        onTap: () => _captureImage(_currentQuestionIndex, index),
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          color: Color.fromARGB(255, 202, 214, 208),
                          child: _capturedImages[_currentQuestionIndex][index] != null
                              ? Image.file(_capturedImages[_currentQuestionIndex][index]!)
                              : const Center(
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 50.0,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _textFieldController,
                  decoration: const InputDecoration(
                    labelText: 'Comment',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: isFirstQuestion ? null : _goToPreviousQuestion,
                      child: Text('Prev'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF3CB371)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _selectedOptions[_currentQuestionIndex] != null ? _checkAnswer : null,
                      child: Text('Next'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF3CB371)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromRGBO(76, 175, 80, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Inspection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User Profile',
          ),
        ],
      ),
    );
  }
}

class QuizData {
  final String subelement;
  final String? selectedOption;
  final List<int> imageIndexes;

  QuizData({
    required this.subelement,
    required this.selectedOption,
    required this.imageIndexes,
  });

  Map<String, dynamic> toJson() {
    return {
      'subelement': subelement,
      'selectedOption': selectedOption,
      'imageIndexes': imageIndexes,
    };
  }
}

