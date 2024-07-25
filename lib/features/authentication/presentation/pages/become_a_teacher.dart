import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/widgets/default_button.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gemini/features/search_text/presentation/widgets/show_snack.dart';
import 'package:gemini/features/teacher/presentation/providers/teacher.dart';
import 'package:gemini/features/user/presentation/providers/user_provider.dart';
import 'package:gemini/locator.dart';
import 'package:go_router/go_router.dart';

class BecomeATeacher extends StatefulWidget {
  const BecomeATeacher({super.key});

  @override
  State<BecomeATeacher> createState() => _BecomeATeacherState();
}

class _BecomeATeacherState extends State<BecomeATeacher> {
  final authBloc = sl<AuthenticationBloc>();
  late UserProvider userProvider;
  late TeacherProvider teacherProvider;
  String value = "English";
  final data = {
    'English': 'English',
    'Mathematics': 'Mathematics',
    'Science': 'Science',
    'Social Studies': 'Social Studies'
  };
  List<DropdownMenuItem> items = [];
  @override
  Widget build(BuildContext context) {
    teacherProvider=context.read<TeacherProvider>();
    userProvider=context.read<UserProvider>();
    items = data.entries
        .map(
          (entry) => DropdownMenuItem<String>(
            value: entry.key,
            child: Text(
              entry.value,
            ),
          ),
        )
        .toList();
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes().width(context, 0.04),
          ),
          child: Column(
            children: [
              DropdownButton(
                items: items,
                onChanged: (value) {
                  setState(() {
                    this.value = value;
                  });
                },
                value: value,
              ),
              SizedBox(height: Sizes().height(context, 0.05)),
            ],
          ),
        ),
        bottomSheet: BlocConsumer(
            bloc: authBloc,
            listener: (context, state) {
              if (state is BecomeATeacherLoaded) {
                final data = state.adminResponse;
              userProvider.user = data.user;
                teacherProvider.admin=data.admin;
                context.goNamed("learning");
              }
              if (state is BecomeATeacherError) {
                if (!context.mounted) return;
                showSnackbar(context: context, message: state.errorMessage);
              }
            },
            builder: (context, state) {
              if (state is BecomeATeacherLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return const DefaultButton();
            }));
  }
}
