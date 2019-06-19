import 'package:flutter/material.dart';
import 'package:rvce_results/resources/history_database.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<HistoryScreen> createState() {
    return HistoryScreenState();
  }
}

class HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.delete_forever),
        onPressed: () async {
          setState(() {
            HistoryDatabase.instance.clearAllEntries();
          });
        },
        tooltip: 'Clear history',
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: HistoryDatabase.instance.getAllData(),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            print(snapshot.hasData);
            if(snapshot.data.isEmpty) {
              return ListTile(
                title: Text('History is empty!'),
                subtitle: Text('Search for results first.'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int id) {
               return Dismissible(
                  key: Key('$id'),
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: Text(snapshot.data[id][HistoryDatabase.columnName]),
                          subtitle: Text(snapshot.data[id][HistoryDatabase.columnUsn]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text('${HistoryDatabase.columnSemester}: ${snapshot.data[id][HistoryDatabase.columnSemester]}', style: TextStyle(letterSpacing: 2.0),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
                          child: Text('${HistoryDatabase.columnSgpa}: ${snapshot.data[id][HistoryDatabase.columnSgpa]}', style: TextStyle(letterSpacing: 2.0),),
                        ),
                      ],
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerRight, 
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(Icons.delete)
                      )
                    ),
                  ),
                  onDismissed: (DismissDirection direction) {
                    setState(() {
                      HistoryDatabase.instance.clearSingleRow(snapshot.data[id][HistoryDatabase.columnUsn]);
                    });
                  },
                );
              },
            );
          } else {
            return LinearProgressIndicator(value: 8.0,);
          }
        },
      ),
    );
  }

}