import 'package:flutter/material.dart';
import 'package:rvce_results/models/student_model.dart';
import 'package:rvce_results/utilities/constants.dart';

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

  List<Widget> _buildLoadingCircle() {
    return <Widget> [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(value: 8.0,),
        ),
      )
    ];
  }

  List<Widget> _buildNotFoundTile() {
    return <Widget> [
      ListTile(
        title: Text('Result Not Found!'),
        subtitle: Text('Check your USN or try again later.'),
        isThreeLine: true,
    )];
  }

  List<Widget> _buildResultTiles() {
    List<Widget> list = [];
    student.quickResult.forEach((String key, String value) {
      list.add(
        ListTile(
          title: Text(key),
          subtitle: Text(value),
          isThreeLine: true,
        ),
      );
    });
    
    return <Widget> [
      ExpansionTile(
        title: Text('Overview'),
        children: list,
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset('images/rvce_logo.png',),
                  ),
                ),
              ),
              expandedHeight: kResultScreenImageSize,
              // reappear when scrolled down even without reaching the top
              floating: true,
              snap: true,
              title: Text('Results'),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                isLoading ? _buildLoadingCircle() : !student.resultFound ? _buildNotFoundTile() : _buildResultTiles(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}