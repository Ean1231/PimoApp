import 'package:flutter/material.dart';
import 'backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static final FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _DisplayName = prefs.getString('ff_DisplayName') ?? _DisplayName;
    });
    _safeInit(() {
      _email = prefs.getString('ff_email') ?? _email;
    });
    _safeInit(() {
      _userId = prefs.getString('ff_userId') ?? _userId;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _DisplayName = '';
  String get DisplayName => _DisplayName;
  set DisplayName(String _value) {
    _DisplayName = _value;
    prefs.setString('ff_DisplayName', _value);
  }

  String _email = '';
  String get email => _email;
  set email(String _value) {
    _email = _value;
    prefs.setString('ff_email', _value);
  }

  String _userId = '';
  String get userId => _userId;
  set userId(String _value) {
    _userId = _value;
    prefs.setString('ff_userId', _value);
  }

  String _imagePath =
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/yuzu-zx8u2b/assets/0fjp2xxq016g/nordwood-themes-F3Dde_9thd8-unsplash.jpg';
  String get imagePath => _imagePath;
  set imagePath(String _value) {
    _imagePath = _value;
  }

  List<String> _questions = ['Hello World', 'Hello World2', 'Hello World3'];
  List<String> get questions => _questions;
  set questions(List<String> _value) {
    _questions = _value;
  }

  void addToQuestions(String _value) {
    _questions.add(_value);
  }

  void removeFromQuestions(String _value) {
    _questions.remove(_value);
  }

  void removeAtIndexFromQuestions(int _index) {
    _questions.removeAt(_index);
  }

  void updateQuestionsAtIndex(
    int _index,
    String Function(String) updateFn,
  ) {
    _questions[_index] = updateFn(_questions[_index]);
  }
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
