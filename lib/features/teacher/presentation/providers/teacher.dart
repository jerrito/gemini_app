import 'package:flutter/widgets.dart';
import 'package:gemini/features/authentication/domain/entities/admin.dart';

class TeacherProvider extends ChangeNotifier{

  Admin? _admin;
  
  Admin get admin=> _admin!;

  set admin(Admin? admin){
    _admin=admin!;
    notifyListeners();
  }
}