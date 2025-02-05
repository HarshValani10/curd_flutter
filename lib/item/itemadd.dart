import 'package:flutter/material.dart';
import 'package:pro1/util/customButton.dart';
import 'package:pro1/util/customtextfild.dart';

class ItemAdd extends StatefulWidget {
  const ItemAdd({super.key});

  @override
  State<ItemAdd> createState() => _ItemAddState();
}

class _ItemAddState extends State<ItemAdd> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Item Add"),),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(controller: nameController, labelText: "Enter Name"),
            SizedBox(height: 20,),
            CustomTextField(controller: priceController, labelText: "Enter Price",keyboardType: TextInputType.number,),
            SizedBox(height: 20,),
            CustomButton(text: "Save", onPressed: (){

            })
          ],
        ),
      ),
    );

  }
}
