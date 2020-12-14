import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  final String errorTitle;
  final String errorMessage;

  Error(this.errorTitle, this.errorMessage);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: [
            Text(
              "Error",
              style: TextStyle(
                  color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(errorMessage),
          ],
        ),
      ),
    );
  }
}
