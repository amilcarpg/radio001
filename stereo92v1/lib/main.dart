import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class ConstantesApp {
  static const String TITULO_APP = 'S T E R E O   9 2 - Más Radio.';
  static const Color COLOR_PRIMARIO = Color(0xFF0292D6);
  static const double TAMANO_ICONO = 80.0;
  static const String URL_STREAM = 'http://stream.zeno.fm/c49wbe2r1f8uv';
  static const double VOLUMEN_INICIAL = 1.0;
  static const double ALTURA_ESPACIADOR = 50.0;
  static const String MENSAJE_SIN_CONEXION = 'No hay conexión a internet';
}

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String url = ConstantesApp.URL_STREAM;

  bool isPlaying = false;
  bool isVisible = true;
  bool isEnable = true;
  bool isLoading = false;
  bool tieneError = false;
  String mensajeError = '';
  bool estaCargando = false;
  double volumen = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initBackgroundService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      audioStart();
    });
  }

  Future<void> initBackgroundService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
      ),
    );
  }

  static void onStart(ServiceInstance service) async {
    // Mantener la reproducción en segundo plano
    service.on('playAudio').listen((event) async {
      await FlutterRadio.audioStart();
      FlutterRadio.playOrPause(url: ConstantesApp.URL_STREAM);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        // La app está en segundo plano
        if (isPlaying) {
          FlutterBackgroundService().invoke('playAudio');
        }
        break;
      case AppLifecycleState.resumed:
        // La app vuelve al primer plano
        break;
      default:
        break;
    }
  }

  Future<void> audioStart() async {
    setState(() {
      isLoading = true;
      tieneError = false;
    });
    try {
      await FlutterRadio.audioStart();
      print('Audio iniciado correctamente');
    } catch (e) {
      setState(() {
        tieneError = true;
        mensajeError = e.toString();
      });
      print('Error al iniciar audio: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> verificarConectividad() async {
    var resultadoConectividad = await (Connectivity().checkConnectivity());
    return resultadoConectividad != ConnectivityResult.none;
  }

  void manejarBuffer(bool cargando) {
    setState(() {
      estaCargando = cargando;
    });
  }

  void ajustarVolumen(double valor) {
    setState(() {
      volumen = valor;
      FlutterRadio.setVolume(volumen);
    });
  }

  Future<void> manejarReproduccion() async {
    if (!isEnable) return;
    
    final tieneConexion = await verificarConectividad();
    if (!tieneConexion) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ConstantesApp.MENSAJE_SIN_CONEXION))
      );
      return;
    }

    setState(() {
      isEnable = false;
      isPlaying = !isPlaying;
      FlutterRadio.playOrPause(url: url);
      isEnable = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Stereo92',
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          appBar: new AppBar(
            title: const Text(ConstantesApp.TITULO_APP),
            backgroundColor: ConstantesApp.COLOR_PRIMARIO,
            centerTitle: true,
          ),
          body: Container(
            
            color: Colors.black,
            child: new Column(
                children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: Image.asset('assets/images/stereo92n.png'),
                  ),
                  if (tieneError)
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        mensajeError,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          IconButton(
                            iconSize: ConstantesApp.TAMANO_ICONO,
                            icon: isPlaying
                                ? Icon(
                                    Icons.pause_circle_outline,
                                    size: ConstantesApp.TAMANO_ICONO,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: ConstantesApp.TAMANO_ICONO,
                                  ),
                            onPressed: manejarReproduccion,
                          ),
                          Slider(
                            value: volumen,
                            onChanged: ajustarVolumen,
                            min: 0.0,
                            max: 1.0,
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ConstantesApp.ALTURA_ESPACIADOR),
                ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    FlutterRadio.stop();
    super.dispose();
  }
}