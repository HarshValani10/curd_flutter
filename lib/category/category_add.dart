import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pro1/model/categorymodel.dart';
import 'package:pro1/util/customButton.dart';
import 'package:pro1/util/customtextfild.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class CategoryAdd extends StatefulWidget {
  final CategoryModel? category; // Accept category for edit

  const CategoryAdd({super.key,this.category});

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      nameController.text = widget.category!.name;
      descriptionController.text = widget.category!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> categoryAdd() async {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('id_token');

      if (widget.category != null) {
        print("Editing category with ID: ${widget.category!.id}");
      } else {
        print("Creating a new category");
      }

      final url = widget.category == null
          ? Uri.parse("http://localhost:8081/api/pro6/category") // Add
          : Uri.parse("http://localhost:8081/api/pro6/category/${widget.category!.id}"); // Edit

      print("API URL: $url"); // Debugging the API URL

      final response = await (widget.category == null
          ? http.post(url, body: jsonEncode({
        "name": nameController.text.trim(),
        "description": descriptionController.text.trim(),
      }), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      })
          : http.patch(url, body: jsonEncode({
        "name": nameController.text.trim(),
        "description": descriptionController.text.trim(),
      }), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }));

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}"); // Print full response body

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.category == null ? "Category Created" : "Category Updated")),
        );
        Navigator.pop(context, true); // Return to refresh list
      } else {
        final errorData = jsonDecode(response.body);
        print("Error: ${errorData}"); // Print error for debugging
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Operation Failed: ${errorData['error']}")),
        );
      }
    }



    void onSubmit() {
      if (formKey.currentState!.validate()) {
        categoryAdd();
      }
    }

    return Scaffold(
    appBar: AppBar(title: Text("Category Add"),),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextField(controller: nameController, labelText: "Enter Name"),
              SizedBox(height: 20,),
              CustomTextField(controller: descriptionController, labelText: "Enter Description"),
              SizedBox(height: 20,),
              CustomButton(text: "Save", onPressed: (){
                onSubmit();

              })
            ],
          ),
        ),
      ),
    );

  }
}
