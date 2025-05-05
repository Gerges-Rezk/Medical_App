import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:medical_app/Features/splash/presentation/widgets/splash_view_body.dart';
import 'package:medical_app/constant.dart';
import 'package:medical_app/core/utils/assets_data.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SplashViewBody()
        );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية (ممكن صورة أو لون)
          Container(
            decoration: BoxDecoration(
              color: kPrimaryColor,
              image: DecorationImage(
                image: AssetImage(AssetsData.splashpic),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // تأثير الضبابية
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
                color: kPrimaryColor.withOpacity(0.2) // إضافة طبقة شفافة
                ),
          ),
          // اللوجو والنص
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.security,
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  'Medical App',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
