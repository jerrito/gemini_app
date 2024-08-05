import 'package:gemini/features/authentication/presentation/pages/become_a_teacher.dart';
import 'package:gemini/features/authentication/presentation/pages/landing_page.dart';
import 'package:gemini/features/authentication/presentation/pages/no_internet_page.dart';
import 'package:gemini/features/authentication/presentation/pages/number_page.dart';
import 'package:gemini/features/authentication/presentation/pages/signin_page.dart';
import 'package:gemini/features/authentication/presentation/pages/signup_page.dart';
import 'package:gemini/features/connection_page.dart';
import 'package:gemini/features/learning/presentation/pages/home.dart';
import 'package:gemini/features/search_text/presentation/pages/search_page.dart';
import 'package:gemini/features/search_text/presentation/pages/test.dart';
import 'package:gemini/features/user/presentation/pages/user_profile.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(initialLocation: "/", routes: [
  GoRoute(
      path: "/searchPage",
      name: "searchPage",
      builder: (context, state) => const SearchTextPage(),
      routes: [
        GoRoute(
            path: "becomeATeacher",
            name: "becomeATeacher",
            builder: (context, state) => BecomeATeacher(
                isStudent: bool.parse(
                    state.uri.queryParameters["isStudent"].toString()))),
        GoRoute(
            path: "test",
            name: "test",
            builder: (context, state) => TestPage(
                  changeNotif: ChangeNotif(),
                ),
            routes: [
              GoRoute(
                path: "test2",
                name: "test2",
                builder: (context, state) =>
                    TestPage2(changeNotif: ChangeNotif()),
              )
            ]),
        GoRoute(
            path: "user",
            name: "user",
            builder: (context, state) => const UserProfile())
      ]),
  GoRoute(
    path: "/",
    name: "connection",
    builder: (context, state) => const ConnectionPage(),
  ),
  GoRoute(
    path: "/no_internet",
    name: "noInternet",
    builder: (context, state) => const NoInternetPage(),
  ),
  GoRoute(
      path: "/landing",
      name: "landing",
      builder: (context, state) => const LandingPage(),
      routes: [
        GoRoute(
            path: "phone",
            name: "phone",
            builder: (context, state) => const PhoneNumberPage(
                  isLogin: true,
                ),
            routes: [
              GoRoute(
                path: "signup",
                name: "signup",
                builder: (context, state) => SignupPage(
                    phoneNumber:
                        state.uri.queryParameters["phoneNumber"].toString()),
              ),
            ]),
        GoRoute(
          path: "signin",
          name: "signin",
          builder: (context, state) => SigninPage(
            phoneNumber: state.uri.queryParameters["phoneNumber"].toString(),
          ),
        ),
      ]),
  GoRoute(
      path: "/learning",
      name: "learning",
      builder: (context, state) => const LearningHomePage())
]);
