import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_radio/flutter_radio.dart';


void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
//APG2
  //String url = "http://server-23.stream-server.nl:8438";
  String url = 'https://serverssl.innovatestream.pe:8080/http://167.114.118.120:7442/;';
  //String url = 'http://node-19.zeno.fm/c49wbe2r1f8uv?rj-ttl=5&rj-tok=AAABezv3buMADyyFslIr3yebgw';

  bool isPlaying = false;
  bool isVisible = true;
  bool isEnable = true;

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
      title: 'Stereo92',
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          appBar: new AppBar(
            title: const Text('0x2 -S T E R E O   9 2 - Más Radio.'),
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
                      padding: const EdgeInsets.only(right: 10),
                      child: Align(
                        alignment: FractionalOffset.center,
                        child: IconButton(
                         iconSize: 80,
                            //apg
                          icon: isPlaying? Icon(
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
                            if(isEnable){
                            isEnable=false;
                            print("Button Press");
                            FlutterRadio.playOrPause(url: url);
                            isPlaying = !isPlaying;
                            isVisible = !isVisible;
                            isEnable=true;
                            }
                            
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