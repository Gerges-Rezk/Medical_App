import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_app/Features/Auth/busines_logic/auth_cubit/cubit/auth_cubit.dart';
import 'package:medical_app/Features/Auth/presentation/views/loginview.dart';
import 'package:medical_app/Features/Auth/presentation/views/registerview.dart';
import 'package:medical_app/Features/Register%20Patient/presentation/views/register_patient_view.dart';
import 'package:medical_app/Features/home/presentation/home_view.dart';
import 'package:medical_app/Features/splash/presentation/views/splash_view.dart';

abstract class AppRouter {
  static const kloginView = '/Loginview';
  static const kRegisterview = '/Registerview';
  static const kHomeview = '/Homeview';
  static const kMonitorView = '/MonitorView';
  static const kRegisterpatient = '/Registerpatient';
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: kloginView,
        builder: (context, state) => BlocProvider(
          create: (context) => AuthCubit(),
          child: LoginView(),
        ),
      ),
      GoRoute(
        path: kHomeview,
        builder: (context, state) => Homeview(),
      ),
      GoRoute(
        path: kRegisterpatient,
        builder: (context, state) => Registerpatient(),
      ),
      GoRoute(
        path: kRegisterview,
        builder: (context, state) => BlocProvider(
          create: (context) => AuthCubit(),
          child: Registerview(),
        ),
      ),
    ],
  );
}
