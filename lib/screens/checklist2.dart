import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pimoapp/screens/inspection.dart';
import 'package:pimoapp/screens/userprofile.dart';
import 'package:pimoapp/screens/checklist2.dart';
import 'package:pimoapp/screens/login_screen.dart';
import 'package:pimoapp/screens/home_screen.dart';

class QuizPage2 extends StatefulWidget {
  @override
  _QuizPage2State createState() => _QuizPage2State();
}

class _QuizPage2State extends State<QuizPage2> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Perform specific actions based on the selected index
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuizPage2()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  int _currentQuestionIndex = 0;
  int _score = 0;

  final List<String?> _selectedOptions = [];
  TextEditingController _textFieldController = TextEditingController();
  List<File?> _capturedImages = List.filled(3, null);

  final List<Map<String, dynamic>> _quizData = [
    {
      'subelement': '5.1 External Walls and Wall Finishes',
      'options': ['C1 (Very Poor)', 'C2 (Poor)', 'C3 (Fair)', 'C4 (Good)', 'C5 (Excellent)'],
    },
    {
      'subelement': '5.2 External Doors',
      'options': ['C1 (Very Poor)', 'C2 (Poor)', 'C3 (Fair)', 'C4 (Good)', 'C5 (Excellent)'],
    },
    {
      'subelement': '5.3 External Windows',
      'options': ['C1 (Very Poor)', 'C2 (Poor)', 'C3 (Fair)', 'C4 (Good)', 'C5 (Excellent)'],
    },
    {
      'subelement': '5.4 External Floors and Finishes',
      'options': ['C1 (Very Poor)', 'C2 (Poor)', 'C3 (Fair)', 'C4 (Good)', 'C5 (Excellent)'],
    },
    {
      'subelement': '5.5 External Ceiling and Ceiling Finishes',
      'options': ['C1 (Very Poor)', 'C2 (Poor)', 'C3 (Fair)', 'C4 (Good)', 'C5 (Excellent)'],
    },
    // Add more questions here
  ];

  void _checkAnswer() {
    if (_currentQuestionIndex < _quizData.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _textFieldController.clear();
        _capturedImages = List.filled(3, null);
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
                    MaterialPageRoute(builder: (context) => SignaturePage()),
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
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _textFieldController.clear();
      });
    }
    // Update selected options and captured images
    _selectedOptions[_currentQuestionIndex + 1] = _selectedOptions[_currentQuestionIndex];
    _capturedImages[_currentQuestionIndex + 1] = _capturedImages[_currentQuestionIndex];
  }

  Future<void> _captureImage(int index) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _capturedImages[index] = File(image.path);
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
        title: Text('Inspection Checklist'),
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
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _captureImage(0),
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          color: Color.fromARGB(255, 202, 214, 208),
                          child: _capturedImages[0] != null
                              ? Image.file(_capturedImages[0]!)
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
                    SizedBox(width: 16.0),
                    Expanded(
                      child: InkWell(
                        onTap: () => _captureImage(1),
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          color: Color.fromARGB(255, 202, 214, 208),
                          child: _capturedImages[1] != null
                              ? Image.file(_capturedImages[1]!)
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
                    SizedBox(width: 16.0),
                    Expanded(
                      child: InkWell(
                        onTap: () => _captureImage(2),
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          color: Color.fromARGB(255, 202, 214, 208),
                          child: _capturedImages[2] != null
                              ? Image.file(_capturedImages[2]!)
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
                  ],
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
