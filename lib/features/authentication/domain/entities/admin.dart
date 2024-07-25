import 'package:equatable/equatable.dart';
import 'package:gemini/features/authentication/domain/entities/user.dart';

class Admin extends Equatable {
  final bool? isAppoved;
  final String? subject;
  final num? studentCount;

  const Admin({
    required this.isAppoved,
    required this.subject,
    required this.studentCount,
  });
  @override
  
  List<Object?> get props => [isAppoved,subject,studentCount];
}


class AdminResponse extends Equatable{
  final Admin admin;
  final User user;

  const AdminResponse({required this.admin, required this.user});
  @override
  List<Object?> get props => [admin,user];

}