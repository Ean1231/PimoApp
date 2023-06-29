import 'package:flutter/material.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:pimoapp/screens/home_screen.dart';

class healthSafety   extends StatefulWidget {
    final String email;
    final String displayName;
    Position? currentPosition;
   String? currentAddress;
   String? currentDate;
   int manageID;
   String? currentSuburb;
   String? currentPostalCode;
   String? currentMunicipality;


  healthSafety  ({required this.manageID ,required this.email, required this.displayName, this.currentPosition, this.currentAddress,required this.currentDate, required this. currentSuburb, required this. currentPostalCode, required this.currentMunicipality,});  
  
  

  @override
  _healthSafetyState createState() => _healthSafetyState();
}
// Updated code 25th sunday 23-- from morning to 22:31
class _healthSafetyState extends State<healthSafety  > {
  
  List<String> inspectionElements = [
    '5.1 External Walls and Wall Finishes ',
    '5.2 External Doors',
    '5.3 External Windows',
    '5.4 External Floors and Finishes',
    '5.5 External Ceiling and Ceiling Finishes',
  ];
  List<String> ratingOptions = [
    '',
    'C1 (Very Poor)',
    'C2 (Poor)',
    'C3 (Fair)',
    'C4 (Good)',
    'C5 (Excellent)',
  ];
  List<String> selectedRatings = List<String>.filled(5, '');
  List<String> comments = List<String>.filled(5, '');
  List<List<String>> imagePaths = List<List<String>>.generate(
    5,
    (_) => List<String>.filled(2, ''),
  );
final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();



  bool isRatingSelected() {
    return selectedRatings.any((rating) => rating != null && rating.isNotEmpty);
  }

  Future<void> _pickImage(int elementIndex, int imageIndex) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await showDialog<XFile>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Select/Capture an Image'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text('Camera'),
                onTap: () async {
                  Navigator.pop(context, await _picker.pickImage(
                    source: ImageSource.camera,
                  ));
                },
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context, await _picker.pickImage(
                    source: ImageSource.gallery,
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );

    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditingScreen(
            imagePath: pickedFile.path,
            onSave: (editedImagePath) {
              setState(() {
                imagePaths[elementIndex][imageIndex] = editedImagePath;
              });
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      );
    }
  }

 String trimName() {
    List<String> nameParts = widget.displayName.split(' ');
  
    if (nameParts.length < 2) {
      return widget.displayName;
    }
  
    String firstName = nameParts[0];
    String lastName = nameParts[nameParts.length - 1];
    String initials = firstName[0] + '.';
  
    return '$initials $lastName';
  }


  Widget _buildRatingDropdown(int index) {
    return DropdownButtonFormField<String>(
      value: index == 0 ? selectedRatings[index] : '',
      items: ratingOptions.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedRatings[index] = value!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Rating',
        hintText: 'Select a rating',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCommentField(int index) {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          comments[index] = value;
        });
      },
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Comments',
        hintText: 'Enter comments',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildImagePicker(int elementIndex, int imageIndex) {
    final imagePath = imagePaths[elementIndex][imageIndex];
    return Padding (
      padding: EdgeInsets.symmetric(horizontal: 10.0),
    child: GestureDetector(
      onTap: () => _pickImage(elementIndex, imageIndex),
      child: Container(
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: imagePath.isEmpty
            ? Icon(Icons.add_a_photo, size: 50.0, color: Colors.grey)
            : Image.file(File(imagePath), fit: BoxFit.cover),
      ),
    ),
    );
  }

pw.Widget _buildPdfContent() {
  final elements = inspectionElements.asMap().entries.map((entry) {
    final index = entry.key;
    final element = entry.value;
    final rating = selectedRatings[index];
    final comment = comments[index];
    final imagePath1 = imagePaths[index][0];
    final imagePath2 = imagePaths[index][1];

    pw.ImageProvider? imageProvider1;
    if (imagePath1.isNotEmpty) {
      final imageFile1 = File(imagePath1);
      if (imageFile1.existsSync()) {
        final imageBytes = imageFile1.readAsBytesSync();
        imageProvider1 = pw.MemoryImage(imageBytes);
      }
    }

    pw.ImageProvider? imageProvider2;
    if (imagePath2.isNotEmpty) {
      final imageFile2 = File(imagePath2);
      if (imageFile2.existsSync()) {
        final imageBytes = imageFile2.readAsBytesSync();
        imageProvider2 = pw.MemoryImage(imageBytes);
      }
    }

    return pw.Container(
      margin: pw.EdgeInsets.symmetric(vertical: 10.0),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Sub Element: $element',
            style: pw.TextStyle(
              fontSize: 16.0,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Padding(padding: pw.EdgeInsets.only(bottom: 5.0)),
          pw.Text('Rating: $rating'),
          pw.Padding(padding: pw.EdgeInsets.only(bottom: 5.0)),
          pw.Text('Comments: $comment'),
          pw.Padding(padding: pw.EdgeInsets.only(bottom: 10.0)),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              if (imageProvider1 != null)
                pw.Container(
                  margin: pw.EdgeInsets.only(right: 10.0),
                  child: pw.Image(
                    imageProvider1,
                    width: 150.0,
                    height: 150.0,
                    fit: pw.BoxFit.cover,
                  ),
                ),
              if (imageProvider2 != null)
                pw.Container(
                  child: pw.Image(
                    imageProvider2,
                    width: 150.0,
                    height: 150.0,
                    fit: pw.BoxFit.cover,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }).toList();

   final currentDate = DateTime.now().toString();
  final displayName = widget.displayName;

  return pw.Container(
    padding: pw.EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
      pw.Text(
          'Inspector: $displayName',
          style: pw.TextStyle(
            fontSize: 16.0,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
          pw.Padding(padding: pw.EdgeInsets.only(bottom: 10.0)),
        pw.Text(
          'Inspection Date: $currentDate',
          style: pw.TextStyle(
            fontSize: 16.0,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
          pw.Padding(padding: pw.EdgeInsets.only(bottom: 10.0)),
        pw.Text(
          'Coordinates: ${widget.currentPosition}',
          style: pw.TextStyle(
            fontSize: 16.0,
            fontWeight: pw.FontWeight.bold,
          ),
        ),  pw.Padding(padding: pw.EdgeInsets.only(bottom: 10.0)),
         pw.Text(
          'Address: ${widget.currentAddress} ${widget.currentPostalCode}',
          style: pw.TextStyle(
            fontSize: 16.0,
            fontWeight: pw.FontWeight.bold,
          ),
        ),pw.Padding(padding: pw.EdgeInsets.only(bottom: 10.0)), 
         pw.Text(
         'Local Minucipality:  ${widget.currentSuburb}',
          style: pw.TextStyle(
            fontSize: 16.0,
            fontWeight: pw.FontWeight.bold,
          ),
        ),pw.Padding(padding: pw.EdgeInsets.only(bottom: 10.0)), 
         pw.Text(
          'Compiler Signature: ${trimName()}',
          style: pw.TextStyle(
            fontSize: 16.0,
            fontWeight: pw.FontWeight.bold,
          ),
        ),pw.Padding(padding: pw.EdgeInsets.only(bottom: 10.0)),
        pw.Divider(thickness: 1.0, color: PdfColors.grey),
        pw.SizedBox(height: 10.0),
        ...elements,
      ],
    ),
  );
}

// 

Future<void> _generatePdf() async {
  try{
  final pdf = pw.Document();

  // Create the PDF content using _buildPdfContent() method
  final content = _buildPdfContent();

  // Add multiple pages using pw.MultiPage widget
  pdf.addPage(
    pw.MultiPage(
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Container(
            padding: pw.EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Buildings inspection Report',
                  style: pw.TextStyle(fontSize: 24.0, fontWeight: pw.FontWeight.bold),
                ),
                pw.Padding(padding: pw.EdgeInsets.only(bottom: 10.0)),
              ],
            ),
          ),
          content,
        ];
      },
    ),
  );
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmation'),
        content: Text('Are you sure you want to submit the form?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Continue'),
            onPressed: () {
              Navigator.of(context).pop();
              _savePdf();
            },
          ),
        ],
      );
    },
  );

  // Specify the download directory path
  Directory directory = Directory('/storage/emulated/0/Documents');

  // Save the PDF document to the specified directory
  final pdfPath = '${directory.path}/Buildings_inspection_Report.pdf';
  final file = File(pdfPath);
  await file.writeAsBytes(await pdf.save());

  print('PDF saved at: $pdfPath');
  // _showConfirmation('PDF saved in Documents folder');
  } catch(e){
    _showError('Failed to save PDF');
  }
   
}
Future<void> _savePdf() async {
  try {
    // Create the PDF document and save it

    // Show confirmation message
    _showConfirmation('PDF saved in on phone External Documents folder');

    // Navigate to the home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage(displayName: widget.displayName, email: widget.email, manageID: widget.manageID,)),
    );
  } catch (e) {
    _showError('Failed to save PDF');
  }
}

void _showConfirmation(String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void _showError(String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

  bool isSubmitEnabled() {
    for (int i = 0; i < selectedRatings.length; i++) {
      if (selectedRatings[i] == '') {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, 
      appBar: AppBar(
        backgroundColor: Colors.green, 
        title: Text('Buildings Inspection'),
      automaticallyImplyLeading: false,
    actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage(displayName: widget.displayName, email: widget.email,manageID: widget.manageID)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inspection sub Elements',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), 
                itemCount: inspectionElements.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        inspectionElements[index],
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.0),
                      _buildRatingDropdown(index),
                      SizedBox(height: 10.0),
                      _buildCommentField(index),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          _buildImagePicker(index, 0),
                          SizedBox(width: 10.0),
                          _buildImagePicker(index, 1),
                        ],
                      ),
                      SizedBox(height: 20.0),
                    ],
                  );
                },
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: isSubmitEnabled() ? _generatePdf : null,
                    style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Set the background color to green
                    onPrimary: Colors.white, // Set the text color to white
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // Increase the button size
                  ),
                  child: Text('Submit',style: TextStyle(fontSize: 16.0),),
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageEditingScreen extends StatefulWidget {
  final String imagePath;
  final Function(String) onSave;

  ImageEditingScreen({required this.imagePath, required this.onSave});

  @override
  _ImageEditingScreenState createState() => _ImageEditingScreenState();
}

class _ImageEditingScreenState extends State<ImageEditingScreen> {
  late String editedImagePath;
  bool isSavingImage = false;


  @override
  void initState() {
    super.initState();
    editedImagePath = widget.imagePath;
  }

 Future<void> _saveImage() async {
  
  setState(() {
    isSavingImage = true;
  });



  await Future.delayed(Duration(seconds: 2));

  widget.onSave(editedImagePath);

  setState(() {
    isSavingImage = false;
  });

  Navigator.pop(context);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, 
        title: Text('Confirm image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(File(widget.imagePath), width: 400.0, height: 350.0),
            SizedBox(height: 20.0),
           ElevatedButton(
              onPressed: _saveImage,
                style: ElevatedButton.styleFrom(
                primary: Colors.green, 
                fixedSize: Size(200, 50), 
              ),
              child: isSavingImage
                  ? CircularProgressIndicator()
                  : Text('Save Image'),
            ),
          ],
        ),
      ),
    );
  }
}



