import 'package:rvce_results/utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class Student {
  String examTime;
  String usn;
  bool resultFound = false;
  
  Map<String, String> headers = {};
  Map<String, String> quickResult;
  List<String> allResult;
  List<String> orderOfAllResult;

  void _updateCookies(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if(rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] = index == -1 ? rawCookie :rawCookie.substring(0, index);
    }
  }

  Future<int> _captchaResult() async {
    http.Response response = await http.get(url, headers: headers);
    _updateCookies(response);

    var document = parse(response.body);
    List<Element> labels = document.querySelectorAll('form > label');
    print(response.statusCode);
    
    int sum=0;
    // second label is the 'What is 3+9?' string
    labels[1].text.split('').forEach((String char) {
      int num = int.tryParse(char);
      if(num != null) 
        sum+=num;
    });

    return sum;
  }

  Future<void> getResults() async {
    int captcha = await _captchaResult();
    Map<String, dynamic> payload = {'usn': usn, 'captcha': '$captcha'};
    http.Response response = await http.post(url, body: payload, headers: headers);
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

      orderOfAllResult = order.map((Element val) => val.text.trim()).toList();
      allResult = all.map((Element val) => val.text.trim()).toList().sublist(0, all.length-orderOfAllResult.length);
      
      print(orderOfAllResult);
      print(allResult);
    }
  }

  
}