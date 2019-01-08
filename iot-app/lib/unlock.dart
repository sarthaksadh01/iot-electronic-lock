import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';

class Unlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UnlockFull(),
      theme: ThemeData(primaryColor: Colors.white),
    );
  }
}

class UnlockFull extends StatefulWidget {
  @override
  _UnlockFullState createState() => _UnlockFullState();
}

class _UnlockFullState extends State<UnlockFull> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('DoorLock'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            unlock();
          },
          child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.green),
              child: Center(
                child: Text('Unlock', style: TextStyle(color: Colors.white)),
              )),
        ),
      ),
    );
  }

  void unlock() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      Dio dio = new Dio();
      Response<String> response = await dio.get("http://192.168.4.1/?lock=1");
      if (response.data == "you are connected") {
        _scaffoldKey.currentState
            .showSnackBar(new SnackBar(content: Text('Door Unlocked')));
      }
      print(response.data);
    }
    else{
       _scaffoldKey.currentState
            .showSnackBar(new SnackBar(content: Text('Device Disconnected!')));
    }

  }
}
