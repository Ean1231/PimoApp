import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class APIService {
  static Future<bool> authenticateUser(
      String userEmail, String userPassword) async {
    // Define the login API endpoint URL
    //String baseUrl = "https://localhost:7147/api";

    var url = Uri.parse(
        'https://localhost:7147/api/controller/user/AuthenticateUserByEmail');

    // Prepare the login request body
    var requestBody = {
      "login": "",
      "UserID": 0,
      "UserName": "string",
      "PasswordHash": userPassword,
      "UserPassword": userPassword,
      "UserDescription": "string",
      "UserEmail": userEmail,
      "ManagerID": 0,
      "DisplayName": "string",
      "FailedLoginAttempts": 0,
      "LastLoginAttempt": "2023-06-07T14:30:46.598Z",
      "ExcludeFromLockoutPolicy": true
    };

    // Encode the request body as JSON
    var requestBodyJson = convert.jsonEncode(requestBody);

    // Set the request headers
    var headers = {'Content-Type': 'application/json'};

    try {
      // Send the login request
      var response =
          await http.post(url, headers: headers, body: requestBodyJson);

      // Check the response status code
      if (response.statusCode == 200) {
        // Request was successful
        print('Login successful');
        var jsonResponse = convert.jsonDecode(response.body);
        // Process the response data here

        // Return true to indicate successful authentication
        return true;
      } else {
        // Request failed
        print('Login failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      // An error occurred
      print('An error occurred during login: $e');
    }

    // Return false to indicate authentication failure
    return false;
  }
}
