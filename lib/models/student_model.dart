import 'package:rvce_results/utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:rvce_results/resources/history_database.dart';
class Student {
  String examTime;
  String usn;
  bool resultFound = false; // default false if error has occured
  bool _errorOccured = false;


  Map<String, String> _headers = {};
  Map<String, String> quickResult;
  List<String> allResult;
  List<String> _orderOfAllResult;

  void _updateCookies(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if(rawCookie != null) {
      int index = rawCookie.indexOf(';');
      _headers['cookie'] = index == -1 ? rawCookie :rawCookie.substring(0, index);
    }
  }

  Future<int> _captchaResult() async {
    try { 
      http.Response response = await http.get(url, headers: _headers);
      print(response.statusCode);
      _updateCookies(response);
      
      var document = parse(response.body);
      List<Element> labels = document.querySelectorAll('form > label');
      
      int sum=0;
      // second label is the 'What is 3+9?' string
      labels[1].text.split('').forEach((String char) {
        int num = int.tryParse(char);
        if(num != null) 
          sum+=num;
      });

      return sum;
    } on Exception {
      rethrow;
    }
  }

  Future<void> getResults() async {
    int captcha = 0;
    try {
      captcha = await _captchaResult();
    } catch (_) {
      print(_);
      _errorOccured = true;
    }
    
    if(!_errorOccured) {
      Map<String, String> payload = {'usn': usn, 'captcha': '$captcha'};
      http.Response response = await http.post(url, body: payload, headers: _headers);
      // without headers, it returns a 302 response
      print(response.statusCode);
      
      var document = parse(response.body);
      examTime = document.querySelector('h3').text.trim().split(':')[1];
      print(examTime);

      List<Element> tables = document.querySelectorAll('table');
      print(tables.length);
      if(tables.length < 2) 
        resultFound = false;
      else 
        resultFound = true;

      if(resultFound) {
        List<Element> headings = tables[0].querySelectorAll('th');
        List<Element> datas = tables[0].querySelectorAll('td');
        
        List<String> keys = headings.map((Element ele) => ele.text.trim()).toList();
        List<String> values = datas.map((Element ele) => ele.text.trim()).toList(); 
        quickResult = Map.fromIterables(keys, values);
        print(quickResult);

        List<Element> order = tables[1].querySelector('thead').querySelectorAll('th');
        List<Element> all = tables[1].querySelector('tbody').querySelectorAll('td');

        _orderOfAllResult = order.map((Element val) => val.text.trim()).toList();
        allResult = all.map((Element val) => val.text.trim()).toList().sublist(0, all.length-_orderOfAllResult.length);
        // the last entry is the 'go back' button so we dont need that
        print(_orderOfAllResult);
        print(allResult);

        await HistoryDatabase.instance.insert(this);

      }
    }
    // if error has occured, then the resultFound is set to false by default, so it says result not found.
  }

  Map<String, dynamic> inFormatForDb() {
    return <String, dynamic> {
      HistoryDatabase.columnUsn : quickResult['USN'],
      HistoryDatabase.columnName : quickResult['NAME'],
      HistoryDatabase.columnSemester : int.tryParse(quickResult['SEMESTER']) ?? 0,
      HistoryDatabase.columnSgpa : double.tryParse(quickResult['SGPA']) ?? 0.0,
    };
  }
}