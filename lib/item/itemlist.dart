import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:pro1/model/itemmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../util/customButton.dart';
import 'itemadd.dart';

class ItemList extends StatefulWidget {
  final String categoryID;
  const ItemList({super.key,required this.categoryID});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  bool isLoading = true;
  List<ItemModel> itemList = [];

  @override
  void initState() {
    super.initState();
    getItems(); // Fetch categories on init
  }

  Future<void> getItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('id_token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication token not found!")),
      );
      return;
    }

    final url = Uri.parse("http://localhost:8081/api/pro6/category/${widget.categoryID}/item");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add the Bearer token
        },
      );

      print("Response Body: ${response.body}"); // Debugging: Print API response

      if (response.statusCode == 200) {
        try {
          final List<dynamic> data = jsonDecode(response.body);
          setState(() {
            itemList =
                data.map((json) => ItemModel.fromJson(json)).toList();
            isLoading = false;
          });
        } catch (e) {
          print("JSON Parsing Error: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error parsing JSON")),
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load categories: ${response.statusCode}")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> deleteCategory(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('id_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication token not found!")),
      );
      return;
    }

    final url = Uri.parse("http://localhost:8081/api/pro6/item/$itemId");

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Item deleted successfully")),
        );
        getItems();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete Item: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item List"),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);

        }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: itemList.length,
              itemBuilder: (BuildContext context, int index) {
                final items = itemList[index];
                return SwipeActionCell(
                  key: ValueKey(index),
                  trailingActions: [
                    SwipeAction(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onTap: (handler) async {
                           final result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> ItemAdd(item: items,categoryID: items.id,)));

                          if (result == true) {
                            getItems(); // Refresh the list after editing
                           }
                        },
                        color: Colors.transparent
                    ),
                    SwipeAction(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onTap: (handler) async {
                          _showDeleteDialog(context,items.id);
                        },
                        color: Colors.transparent
                    )
                  ],
                  child: GestureDetector(
                    onTap: (){
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ItemList()));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Add margin for spacing
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.5), // Border for each item
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                        color: Colors.white, // Background color
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2), // Shadow effect
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: Offset(0, 2), // Shadow direction
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), // Padding inside the item
                        leading: const Icon(Icons.list),
                        title: Text(items.name.toString()),
                        subtitle: Text(items.price.toString()),
                      ),
                    ),

                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()async{
        final result = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => ItemAdd(categoryID: widget.categoryID)));
        if (result == true) {
          getItems(); // Refresh list after adding category
        }
      },
        child: Icon(Icons.add),),

    );

  }
  // Function to show the confirmation dialog
  void _showDeleteDialog(BuildContext context,String itemId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this item?"),
          actions: [
            CustomButton(text: "Cancel", onPressed: () {
              Navigator.pop(context);
            },),
            CustomButton(text: "Delete", onPressed: () {
              deleteCategory(itemId);
              Navigator.pop(context);
            },),
          ],
        );
      },
    );
  }

}
