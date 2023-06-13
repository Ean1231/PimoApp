import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SignaturePage extends StatefulWidget {
  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  List<Offset?> _points = [];
  String _name = '';
  String _currentDate = '';
  String _currentTime = '';
  bool _isDrawing = false;

  @override
  void initState() {
    super.initState();
    _getCurrentDateTime();
  }

  void _getCurrentDateTime() {
    final now = DateTime.now();
    _currentDate = DateFormat('yyyy-MM-dd').format(now);
    _currentTime = DateFormat('HH:mm:ss').format(now);
  }

  void _clearSignature() {
    setState(() {
      _points.clear();
    });
  }

  Future<Uint8List?> _captureSignature() async {
    if (_points.isEmpty) {
      return null;
    }

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < _points.length - 1; i++) {
      if (_points[i] != null && _points[i + 1] != null) {
        canvas.drawLine(_points[i]!, _points[i + 1]!, paint);
      }
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(300, 150);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  void _saveSignature() async {
    final signatureData = await _captureSignature();
    if (signatureData != null) {
      // Save the signature data or perform any desired action
      // You can use signatureData as an image or upload it to a server
      print('Signature saved!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signature Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Inspector name: Ean Bosman',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'Occupation: Bosman',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Inspection Date: $_currentDate',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Inspection Completed Time: $_currentTime',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: GestureDetector(
                onPanDown: (details) {
                  setState(() {
                    _isDrawing = true;
                    RenderBox renderBox = context.findRenderObject() as RenderBox;
                    Offset localPosition =
                        renderBox.globalToLocal(details.globalPosition);
                    _points.add(localPosition);
                  });
                },
                onPanUpdate: (details) {
                  if (_isDrawing) {
                    setState(() {
                      RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      Offset localPosition =
                          renderBox.globalToLocal(details.globalPosition);
                      _points.add(localPosition);
                    });
                  }
                },
                onPanEnd: (details) {
                  setState(() {
                    _isDrawing = false;
                    _points.add(null); // Add null to indicate the end of drawing
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: CustomPaint(
                    painter: SignaturePainter(points: _points),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _clearSignature,
                  child: Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: _saveSignature,
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset?> points; // Update the list type to Offset?

  SignaturePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
