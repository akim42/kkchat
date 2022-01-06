import 'package:flutter/material.dart';

class DeleteAndSaveBloc extends ChangeNotifier{
  static bool _show = false;
  static bool _delete = false;

  bool currentState(){
    return _show ? true : false;
  }

  bool isDelete(){
    return _delete ? true : false;
  }

  void toDelete(){
    _delete = !_delete;
    notifyListeners();
  }

  void change(){
    _show = !_show;
    notifyListeners();
  }
}