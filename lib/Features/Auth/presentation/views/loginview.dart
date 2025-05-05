import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_app/Features/Auth/presentation/widgets/custom_button.dart';
import 'package:medical_app/Features/Auth/presentation/widgets/custom_textfield.dart';
import 'package:medical_app/constant.dart';
import 'package:medical_app/core/utils/assets_data.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/utils/app_router.dart';
import '../../busines_logic/auth_cubit/cubit/auth_cubit.dart';
import '../widgets/snackbarmessage.dart';

class LoginView extends StatelessWidget {
  String? email;
  static String id = 'loginView';
  String? password;
  GlobalKey<FormState> formKey = GlobalKey();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          showSpinner = true;
        } else if (state is LoginSuccess) {
          snackbarMessage(context, 'login success');
          GoRouter.of(context).push(AppRouter.kHomeview);

          showSpinner = false;
        } else if (state is LoginFailure) {
          showSpinner = false;
          snackbarMessage(context, state.errorMessage);
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                Image.asset(AssetsData.splashpic, height: 200, width: 200),
                Text(
                  'Medical App',
                  style: TextStyle(fontSize: 35, color: Colors.white),
                ),
                Row(
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    ),
                  ],
                ),
                custom_textField(
                  onChanged: (value) {
                    email = value;
                  },
                  hint: 'User Name',
                ),
                custom_textField(
                  hint: 'password',
                  obsecure: true,
                  onChanged: (value) {
                    password = value;
                  },
                ),
                CustomButton(
                  buttonName: 'Login',
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      BlocProvider.of<AuthCubit>(context)
                          .loginUser(email: email!, password: password!);
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).push(AppRouter.kRegisterview);
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
