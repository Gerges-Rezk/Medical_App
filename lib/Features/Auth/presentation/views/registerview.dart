import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_app/Features/Auth/busines_logic/auth_cubit/cubit/auth_cubit.dart';
import 'package:medical_app/Features/Auth/presentation/widgets/custom_button.dart';
import 'package:medical_app/Features/Auth/presentation/widgets/custom_textfield.dart';
import 'package:medical_app/Features/Auth/presentation/widgets/snackbarmessage.dart';
import 'package:medical_app/constant.dart';
import 'package:medical_app/core/utils/assets_data.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Registerview extends StatefulWidget {
  static String id = 'registerView';

  @override
  State<Registerview> createState() => _RegisterviewState();
}

class _RegisterviewState extends State<Registerview> {
  bool showSpinner = false;
  final GlobalKey<FormState> formKey = GlobalKey();
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          setState(() {
            showSpinner = true;
          });
        } else if (state is RegisterSuccess) {
          setState(() {
            showSpinner = false;
          });
          snackbarMessage(context, 'Register success');
          Navigator.pop(context);
        } else if (state is RegisterFailure) {
          setState(() {
            showSpinner = false;
          });
          snackbarMessage(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Scaffold(
            backgroundColor: kPrimaryColor,
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    reverse: true,
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.only( top: 100, left: 20, right: 20),
                          child: Column(
                            spacing: 20,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Center(child: CircleAvatar(radius: 100,backgroundImage: AssetImage(AssetsData.splashpic),)),
                              Center(
                                child: const Text(
                                  'Medical App',
                                  style: TextStyle(
                                    fontSize: 35,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 35,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              custom_textField(
                                hint: 'User Name',
                                email: email,
                                onChanged: (value) {
                                  email = value;
                                },
                              ),
                              custom_textField(
                                hint: 'Password',
                                password: password,
                                onChanged: (value) {
                                  password = value;
                                },
                              ),
                              const SizedBox(height: 20),
                              CustomButton(
                                buttonName: 'Register',
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    BlocProvider.of<AuthCubit>(context)
                                        .registerUser(
                                            email: email!,
                                            password: password!);
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Already have an account?',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
