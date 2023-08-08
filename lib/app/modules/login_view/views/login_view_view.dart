import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_view_controller.dart';

class LoginViewView extends GetView<LoginViewController> {
  const LoginViewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginViewView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LoginViewView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
