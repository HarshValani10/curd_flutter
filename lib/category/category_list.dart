import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:pro1/category/category_add.dart';
import 'package:pro1/item/itemlist.dart';
import 'package:pro1/model/categorymodel.dart';
import 'package:pro1/util/customButton.dart';
import 'package:http/http.dart' as http;


class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  bool isLoading = true;
  List<CategoryModel> categoryList = [];

  Future<void> getCategories() async {
    final store = StoreProvider.of<String>(context, listen: false); // Retrieve Redux state
    final token = store.state; // Get the token

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication token not found!")),
      );
      return;
    }

    final url = Uri.parse("http://localhost:8081/api/pro6/category");

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
            categoryList =
                data.map((json) => CategoryModel.fromJson(json)).toList();
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
        SnackBar(content: Text("Errcxcdxvcor: $e")),
      );
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    final store = StoreProvider.of<String>(context, listen: false); // Retrieve Redux state
    final token = store.state; // Get the token

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication token not found!")),
      );
      return;
    }

    final url = Uri.parse("http://localhost:8081/api/pro6/category/$categoryId");

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
          SnackBar(content: Text("Category deleted successfully")),
        );
        getCategories(); // Refresh list after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete category: ${response.statusCode}")),
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
  void initState() {
    super.initState();
    getCategories(); // Fetch categories on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category List"),
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
              itemCount: categoryList.length,
              itemBuilder: (BuildContext context, int index) {
                final category = categoryList[index];
                return SwipeActionCell(
                  key: ValueKey(index),
                  trailingActions: [
                    SwipeAction(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onTap: (handler) async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CategoryAdd(category: category)),
                        );
                        if (result == true) {
                          getCategories(); // Refresh the list after editing
                        }
                      },
                      color: Colors.transparent,
                    ),

                    SwipeAction(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onTap: (handler) async {
                        _showDeleteDialog(context, category.id);
                      },
                        color: Colors.transparent
                    )
                  ],
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ItemList(categoryID: category.id)));
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
                        title: Text(category.name),
                        subtitle: Text(category.description),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async{
        final result = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => CategoryAdd()));
        if (result == true) {
        getCategories(); // Refresh list after adding category
        }
      },
        child: Icon(Icons.add),),

    );

  }
  // Function to show the confirmation dialog
  void _showDeleteDialog(BuildContext context, String categoryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this item?"),
          actions: [
            CustomButton(
              text: "Cancel",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CustomButton(
              text: "Delete",
              onPressed: () {
                deleteCategory(categoryId); // Pass categoryId as a String
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


}
