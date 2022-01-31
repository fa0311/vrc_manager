import 'package:flutter/material.dart';
import 'api.dart';

class VRChatMobile extends StatefulWidget {
  const VRChatMobile({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<VRChatMobile> createState() => _LoginPageState();
}

class _LoginPageState extends State<VRChatMobile> {
  bool _isPasswordObscure = true;
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            TextFormField(
              // ignore: prefer_const_constructors
              controller: _userController,
              decoration: const InputDecoration(labelText: 'Username/Email'),
            ),
            TextFormField(
              obscureText: _isPasswordObscure,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordObscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPasswordObscure = !_isPasswordObscure;
                    });
                  },
                ),
              ),
            ),
            Container(
              height: 20,
            ),
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () => VRCAPI(context).login(_userController.text, _passwordController.text),
            ),
          ],
        ),
      ),
    );
  }
}
