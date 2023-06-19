import 'dart:convert';
import 'dart:typed_data';

import '../../flutter_flow/flutter_flow_util.dart';

import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start PimoApi Group Code

class PimoApiGroup {
  static String baseUrl = 'pimoesriapi.azurewebsites.net';
  static Map<String, String> headers = {};
  static GetUserCall getUserCall = GetUserCall();
  static LoginCall loginCall = LoginCall();
}

class GetUserCall {
  Future<ApiCallResponse> call({
    String? email = '',
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'GetUser',
      apiUrl: '${PimoApiGroup.baseUrl}/api/controller/user/GetUserByEmail',
      callType: ApiCallType.GET,
      headers: {
        ...PimoApiGroup.headers,
      },
      params: {
        'email': "bosmane1123@gmail.com",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class LoginCall {
  Future<ApiCallResponse> call({
    String? userPassword = 'M@ckey001',
    String? userEmail = 'bosmane1123@gmail.com',
  }) {
    final body = '''
{
  "userPassword": "M@ckey001",
  "userEmail": "bosmane1123@gmail.com"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Login',
      apiUrl:
          '${PimoApiGroup.baseUrl}/api/controller/user/AuthenticateUserByEmail',
      callType: ApiCallType.POST,
      headers: {
        ...PimoApiGroup.headers,
      },
      params: {},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

/// End PimoApi Group Code

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list);
  } catch (_) {
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar);
  } catch (_) {
    return isList ? '[]' : '{}';
  }
}
