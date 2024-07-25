import 'package:gemini/features/authentication/data/models/user_model.dart';
import 'package:gemini/features/authentication/domain/entities/admin.dart';

class AdminModel extends Admin {
  const AdminModel(
      {required super.isAppoved,
      required super.subject,
      required super.studentCount});

  factory AdminModel.fromJson(Map json) => AdminModel(
        isAppoved: json["isAppoved"],
        subject: json["subject"],
        studentCount: json["studentCount"],
      );
}

class AdminModelResponse extends AdminResponse {
  const AdminModelResponse({
    required super.admin,
    required super.user,
  });

  factory AdminModelResponse.fromJson(Map json) => AdminModelResponse(
        admin: AdminModel.fromJson(json["Admin"]),
        user: UserModel.fromJson(json["updateRole"]),
      );
}
