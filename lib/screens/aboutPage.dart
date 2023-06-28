import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PDFTable extends StatelessWidget {
  final String downloadUrl;
  final String fileName;

  PDFTable({required this.downloadUrl, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Table'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _openPDF(context);
          },
          child: Text('Download PDF'),
        ),
      ),
    );
  }

  Future<void> _openPDF(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      Navigator.of(context).pop(); // Dismiss the progress dialog
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(fileName),
            ),
            body: WebView(
              initialUrl: downloadUrl,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
        ),
      );
    } catch (error) {
      Navigator.of(context).pop(); // Dismiss the progress dialog
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to load PDF'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
