import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
    final String email;
  final String displayName;

  ContactUsPage({required this.email, required this.displayName});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Contact Us'),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Department of Public Works And Infrastructure Head Office',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Physical Address:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Qhasana Building, Independence Ave 5605'),
                Text('Bhisho, Eastern Cape'),
                SizedBox(height: 20),
                Text(
                  'Contact Information:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('Tel'),
                  subtitle: Text('040 602 4000'),
                  onTap: () => launch('tel:0406024000'),
                ),
                ListTile(
                  leading: Icon(Icons.print),
                  title: Text('Fax'),
                  subtitle: Text('0800 864 951'),
                  onTap: () => launch('tel:0800864951'),
                ),
                ListTile(
                  leading: Icon(Icons.call),
                  title: Text('Call Centre'),
                  subtitle: Text('0800 864 951'),
                  onTap: () => launch('tel:0800864951'),
                ),
                ListTile(
                  leading: Icon(Icons.mail),
                  title: Text('Email'),
                  subtitle: Text('info@ecdpw.gov.za'),
                  onTap: () => launch('mailto:info@ecdpw.gov.za'),
                ),
                SizedBox(height: 20),
                Text(
                  'Website:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => launch('https://www.ecdpw.gov.za'),
                  child: Text(
                    'www.ecdpw.gov.za',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Social Media:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => launch('https://www.facebook.com/EasternCapeDPWI'),
                  child: Text(
                    'Facebook Page: Eastern Cape Department of Public Works',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'OFFICE OF THE MEC',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  title: Text('Chief of Staff'),
                  subtitle: Text('Mr Sibongile Sotshongaye'),
                  onTap: () => launch('tel:0795073813'),
                ),
                ListTile(
                  title: Text('Media Liaison Officer'),
                  subtitle: Text('Ms Zine George'),
                  onTap: () => launch('tel:0836675376'),
                ),
                ListTile(
                  title: Text('Personal Assistant to the Hon MEC'),
                  subtitle: Text('Ms Thembisa Cekeshe'),
                  onTap: () => launch('tel:0664848330'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
