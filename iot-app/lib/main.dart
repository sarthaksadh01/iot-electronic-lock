import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:wifi/wifi.dart';
import 'package:connectivity/connectivity.dart';
import './unlock.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoorLock',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: MyHomePage(title: 'DoorLock'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List ssidList = [];

  @override
  void initState() {
    // TODO: implement initState
    //connection();
    checkState();
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
            
            shape:  new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
              color: Colors.blue,
              minWidth: 50,
              child: Text(
                'Connect to device',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                loadData();
              },
            ),
          ],
        ),
      ),
    );
  }

  void checkState() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: Text('Please turn on your wifi to scan nearby devices')));
    } else if (connectivityResult == ConnectivityResult.wifi) {
      _getWifiName();
      // I am connected to a wifi network.
    }
  }

  Future<Null> _getWifiName() async {
    String wifiName = await Wifi.ssid;
    if (wifiName == "doorlock") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Unlock()));
    }
    else{
      loadData();
    }
  }

  void loadData() {
    Wifi.list('').then((list) {
      setState(() {
        ssidList = list;
      });
      print(ssidList);
      for (int i = 0; i < ssidList.length; i++) {
        if (ssidList[i] == "doorlock") {
          connection('doorlock', 'your password');
          return;
        }
      }
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: Text('No Device Found!')));
    });
  }

  Future<Null> connection(String ssid, String password) async {
    Wifi.connection(ssid, password).then((v) {
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: Text('Connected to $ssid')));
           Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Unlock()));
    //  print(v);
    });
  }

  void unlock() async {
    Dio dio = new Dio();
    Response<String> response = await dio.get("http://192.168.4.1/?lock=1");
    print(response.data);
  }
}
