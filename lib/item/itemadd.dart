import 'dart:convert';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pro1/model/itemmodel.dart';
import 'package:pro1/util/customButton.dart';
import 'package:pro1/util/customtextfild.dart';

import '../util/apputils.dart';

class ItemAdd extends StatefulWidget {
  final ItemModel? item;
  final String categoryID; //get cat id
  const ItemAdd({super.key,this.item,required this.categoryID});

  @override
  State<ItemAdd> createState() => _ItemAddState();
}

class _ItemAddState extends State<ItemAdd> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      nameController.text = widget.item!.name;
      priceController.text = widget.item!.price;
    }
  }

  @override
  Widget build(BuildContext context) {

    Future<void> itemAdd() async {
      final store = StoreProvider.of<String>(context, listen: false); // Retrieve Redux state
      final token = store.state; // Get the token

      if (widget.item != null) {
        print("Editing item with ID: ${widget.item!.id}");
      } else {
        print("Creating a new item");
      }

      final url = widget.item == null
          ? Uri.parse("http://localhost:8081/api/pro6/category/${widget.categoryID}/item") // Add
          : Uri.parse("http://localhost:8081/api/pro6/item/${widget.item!.id}"); // Edit

      print("API URL: $url"); // Debugging the API URL

      final response = await (widget.item == null
          ? http.post(url, body: jsonEncode({
        "name": nameController.text.trim(),
        "price": priceController.text.trim(),
      }), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      })
          : http.patch(url, body: jsonEncode({
        "name": nameController.text.trim(),
        "price": priceController.text.trim(),
      }), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }));

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}"); // Print full response body

      if (response.statusCode == 201 || response.statusCode == 200) {
        showCustomSnackbar(context, widget.item == null ? "Item Created" : "Item Updated");
        Navigator.pop(context, true); // Return to refresh list
      } else {
        final errorData = jsonDecode(response.body);
        print("Error: ${errorData}"); // Print error for debugging
        showCustomSnackbar(context, "Error",isError: true);
      }
    }

    void onSubmit() {
      if (formKey.currentState!.validate()) {
        itemAdd();
      }
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.item == null ? "Item Add" : "Item Edit"),),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextField(controller: nameController, labelText: "Enter Name",validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Name is require";
                }
                return null;
              }),
              SizedBox(height: 20,),
              CustomTextField(controller: priceController, labelText: "Enter Price",validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Price is require";
                }
                return null;
              }),
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
