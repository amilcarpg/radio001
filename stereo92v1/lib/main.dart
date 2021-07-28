import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_radio/flutter_radio.dart';


void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
//APG
  //String url = "http://server-23.stream-server.nl:8438";
  String url = 'http://node-30.zeno.fm/c49wbe2r1f8uv?rj-ttl=5&rj-tok=AAABet_F7jwAAu6yUsiz21ickA';

  bool isPlaying = false;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    audioStart();
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'IndieXL Online Radio',
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          appBar: new AppBar(
            title: const Text('S T E R E O   9 2 - Más Radio.'),
            backgroundColor: Color(0xFF002d81),
            centerTitle: true,
          ),
          body: Container(
            color: Color(0xFF002d81),
            child: new Column(
                children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: Image.asset('assets/images/stereo92.png'),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: Align(
                        alignment: FractionalOffset.center,
                        child: IconButton(icon: isPlaying? Icon(
                          Icons.pause_circle_outline,
                          size: 80,
                          color: Colors.white,
                        )
                            : Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                          size: 80,
                        ),
                            onPressed: (){
                          setState(() {
                            FlutterRadio.playOrPause(url: url);
                            isPlaying = !isPlaying;
                            isVisible = !isVisible;
                          });
                            },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50,)
                ],
            ),
          ),
        ));
  }
}