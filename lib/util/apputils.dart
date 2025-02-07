import 'package:flutter/material.dart';

void showCustomSnackbar(BuildContext context, String message, {bool isError = false}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50, // Adjust this value to change position
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isError ? Colors.red.shade300 : Colors.green.shade300,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                spreadRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isError ? Icons.error : Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  // Remove after 2 seconds
  Future.delayed(Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}
