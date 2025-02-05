import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pro1/dashboard/dashboard.dart';
import 'package:pro1/model/usermodel.dart';
import 'package:pro1/util/customButton.dart';
import 'package:pro1/util/customtextfild.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;
    TextEditingController usernameController = TextEditingController(text: "meet12");
    TextEditingController passwordController = TextEditingController(text: "meet12");

    /// **Login API Function**
    Future<void> login() async {
      setState(() => isLoading = true);

      final url = Uri.parse("http://127.0.0.1:8081/api/authenticate"); // Replace with actual API
      final response = await http.post(
        url,
        body: jsonEncode({
          "username": usernameController.text.trim(),
          "password": passwordController.text.trim(),
        }),
        headers: {"Content-Type": "application/json"},
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        // Convert response to UserModel
        final user = UserModel.fromJsonString(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Successful"),
            behavior: SnackBarBehavior.floating, // Makes it float
            margin: EdgeInsets.only(top: 10, left: 20, right: 20), // Adjust position
          ),
        );
        print("Login Successful: Token = ${user.idToken}");

        // Store token in SharedPreferences for future use
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("id_token", user.idToken);

        // Navigate to Dashboard
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        final errorData = jsonDecode(response.body);
        print("Login Failed: ${errorData['error']}");

        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Failed: ${errorData['error']}")),
        );
      }
    }

    void _validateAndLogin() {
      if (formKey.currentState!.validate()) {
        login();
      }
    }



    return Scaffold(
      appBar: AppBar(
        title: Text("Login",style: TextStyle(fontSize: 20),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextField(controller: usernameController, labelText: "Enter UserName",validator: (value) {
                if (value == null || value.isEmpty) {
                  return "UserName is require";
                }
                // else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+")
                //     .hasMatch(value)) {
                //   return "Enter a valid email";
                // }
                return null;
              },
              ),
              SizedBox(height: 20,),
              CustomTextField(controller: passwordController, labelText: "Enter Password",validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password is require";
                }
                return null;
              },),
              SizedBox(height: 20,),
              isLoading
                  ?CircularProgressIndicator()
                  :CustomButton(text: "Login", onPressed: _validateAndLogin)
              // CustomButton(text: "Login", onPressed: (){
              //   _validateAndLogin();
              // })
            ],
          ),
        ),
      ),
    );
  }
}


