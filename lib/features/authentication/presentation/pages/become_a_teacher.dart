import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';
import 'package:gemini/core/widgets/default_button.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gemini/features/authentication/presentation/providers/token.dart';
import 'package:gemini/features/search_text/presentation/widgets/show_snack.dart';
import 'package:gemini/features/teacher/presentation/providers/teacher.dart';
import 'package:gemini/features/user/presentation/providers/user_provider.dart';
import 'package:gemini/locator.dart';
import 'package:go_router/go_router.dart';

class BecomeATeacher extends StatefulWidget {
 final bool isStudent;
  const BecomeATeacher({super.key,required this.isStudent});

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
    teacherProvider = context.read<TeacherProvider>();
    userProvider = context.read<UserProvider>();
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
        appBar: AppBar(
          title: Text(widget.isStudent? 'Become A Student':'Become A Teacher'),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizes().width(context, 0.04),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Space().height(
                  context,
                  0.02,
                ),
                const Text(
                  "Select your teaching subject",
                ),
                DropdownButton(
                  isExpanded: true,
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
        ),
        bottomSheet: BlocConsumer(
            bloc: authBloc,
            listener: (context, state) {
              if (state is BecomeATeacherLoaded) {
                final data = state.adminResponse;
                userProvider.user = data.user as dynamic;
                teacherProvider.admin = data.admin;
                context.goNamed("learning");
              }
              if (state is BecomeATeacherError) {
                if (!context.mounted) return;
                showSnackbar(context: context, message: state.errorMessage);
              }
            },
            builder: (context, state) {
              if (state is BecomeATeacherLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Sizes().height(context, 0.01),
                    vertical: Sizes().height(context, 0.02)),
                child: DefaultButton(
                  label: "Continue",
                  onTap: () {
                    final Map<String, dynamic> params = {
                      "token": context.read<TokenProvider>().token,
                      "body": {"subject": value}
                    };
                    authBloc.add(BecomeATeacherEvent(params: params));
                  },
                ),
              );
            }));
  }
}
