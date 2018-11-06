import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../util/utils.dart' as util;

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {

  String _cityEntered;

  Future _goToNextScreen(BuildContext context) async{
    Map results = await Navigator.of(context).push(
      new MaterialPageRoute<Map>(builder: (BuildContext context){

        return new ChangeCity();

      }));
      if( results != null && results.containsKey('enter')){
        _cityEntered = results['enter'].toString();

        //print(results['enter'].toString());
      }

  }

  void showStuff() async{
    Map data = await getWeather(util.apiId, util.defaultCity);
    print(data.toString());
  }
  @override
  Widget build(BuildContext context) {

    return new Scaffold(

      appBar: new AppBar(
        title: Text("Totoro Weather",
        style: new TextStyle(color: Colors.white, fontSize: 27.0)
        
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.menu),
            color: Colors.white,
            onPressed: () {_goToNextScreen(context);},
          )
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/night.jpg',
            width: 420.0,
            height: 900.0,
            fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text(
              '${_cityEntered == null ? util.defaultCity : _cityEntered}',
            style: cytyStyle(),
            ),
          ),
          new Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 180.0),
            child: new Image.asset('images/totorito.png',
            height: 130.0,
            width: 130.0,
            ),
          ),
          //Contains weather Data
          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 290.0, 0.0, 0.0),
            child: updateTempWidget(_cityEntered)
          )
        ],
      ),
    );
  }

Future<Map> getWeather(String appId, String city) async{
  String apiUrl = "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.apiId}&units=metric";
  http.Response response = await http.get(apiUrl);

  return json.decode(response.body); 

}

Widget updateTempWidget(String city){
  return new FutureBuilder(
    future: getWeather(util.apiId, city == null ? util.defaultCity : city),
    builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
      //Where we get all of the json data, we setup widgets etc.
      if (snapshot.hasData){
        Map content = snapshot.data;
        return new Container(
          child: new Column(
            children: <Widget>[
              new ListTile(
                title: new Text(content['main']['temp'].toString()+" C",
                style: tempStyle(),
                ),
                subtitle: new ListTile(
                  title: new Text(
                    "Humidity: ${content['main']['humidity'].toString()}\n"
                    "Min: ${content['main']['temp_min'].toString()} C\n"
                    "Max: ${content['main']['temp_max'].toString()} C",
                    style: extraData(),
                  ),
                ),
              )

            ],
          ),
        );
      }
    });

}
}

class ChangeCity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _cityFieldController = new TextEditingController();
        return new Scaffold(
    
          appBar: new AppBar(
            backgroundColor: Colors.blueAccent,
            title: new Text("Change City",
            style: new TextStyle(color: Colors.white, fontSize: 27.0),
            ),
            centerTitle: true,
          ),
          body: new Stack(
            children: <Widget>[
              new Center(
                child: new Image.asset("images/totoro_enter.jpg",
                width: 410.0,
                fit: BoxFit.fill,
                ),
              ),
    
              new ListView(
                children: <Widget>[
                  new ListTile(
                    title: new TextField(
                      decoration: new InputDecoration(
                        hintText: 'Enter city',
                      ),
                      controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
                new ListTile(
                  title: new FlatButton(
                    onPressed: (){
                      Navigator.pop(context,{
                        'enter': _cityFieldController.text
                      });
                    },
                    textColor: Colors.white,
                    color: Colors.blue.shade900,
                    child: new Text('Get Weather'),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}

TextStyle extraData(){
  return new TextStyle(
    color: Colors.white,
    fontSize: 35.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold
  );

}

TextStyle cytyStyle(){
  return new TextStyle(
    color: Colors.white,
    fontSize: 28.0,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold
  );
}

TextStyle tempStyle(){
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 66.0,

  );
}