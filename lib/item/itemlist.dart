import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';

import '../util/customButton.dart';
import 'itemadd.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item List"),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);

        }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (BuildContext context, int index) {
                return SwipeActionCell(
                  key: ValueKey(index),
                  trailingActions: [
                    SwipeAction(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onTap: (handler) async {
                        },
                        color: Colors.transparent
                    ),
                    SwipeAction(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onTap: (handler) async {
                          _showDeleteDialog(context);
                        },
                        color: Colors.transparent
                    )
                  ],
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ItemList()));
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
                        title: Text("List item $index"),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ItemAdd()));
      },
        child: Icon(Icons.add),),

    );

  }
  // Function to show the confirmation dialog
  void _showDeleteDialog(BuildContext context) {
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
              Navigator.pop(context);
            },),
          ],
        );
      },
    );
  }

}
