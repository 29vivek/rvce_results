import 'package:flutter/material.dart';
import 'package:rvce_results/models/student_model.dart';

class ResultScreen extends StatefulWidget {
  final String usn;
  ResultScreen(this.usn);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  Student student = Student();
  bool isLoading = true;
  @override
  void initState() {
    loadResults();
    super.initState();
  }

  void loadResults() async {
    
    student.usn = widget.usn;
    await student.getResults();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Provisional Results'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding (
              padding: EdgeInsets.all(8.0),
              child: Hero(
                tag: 'logo',
                child: Image.asset(
                  'images/rvce_logo.png',
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}