import 'package:flutter/material.dart';
import 'package:rvce_results/screens/result_screen.dart';
class InputScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('RVCE Results'),
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: TextField(
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.characters,
            onSubmitted: (String enteredText) {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ResultScreen(enteredText),
              ));
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              labelText: 'Your USN:',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                gapPadding: 8.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}