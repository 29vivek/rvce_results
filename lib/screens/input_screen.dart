import 'package:flutter/material.dart';
import 'package:rvce_results/screens/result_screen.dart';
import 'package:rvce_results/utilities/constants.dart';
import 'package:rvce_results/screens/history_screen.dart';

class InputScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('RVCE Results'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                Navigator.push(context, 
                  MaterialPageRoute(
                    builder: (context) => HistoryScreen(),
                  )
                );
              },
            )
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            Padding (
              padding: EdgeInsets.all(8.0),
              child: Hero(
                tag: 'logo',
                child: Image.asset('images/rvce_logo.png', width: kInputScreenImageSize, height: kInputScreenImageSize,),
              ),
            ),
            Padding(
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
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:EdgeInsets.only(bottom: 8.0), 
                  child: Text('Made with ❤️ by Vivek Kekuda'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}