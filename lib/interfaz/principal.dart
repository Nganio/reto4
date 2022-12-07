import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gps_tracking/controlador/controladorGen.dart';
import 'package:gps_tracking/interfaz/listar.dart';
import 'package:gps_tracking/proceso/peticiones.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Geo-tracker'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  controladorGen control = Get.find();

  void obtenerLocalizacion() async {
    Position posicion = await peticionesDB.determinePosition();
    print(posicion.toString());
    control.cargaUnaPosicion(posicion.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Alert(
                        type: AlertType.warning,
                        context: context,
                        title: "ATENCION!",
                        buttons: [
                          DialogButton(
                              color: Colors.lime,
                              child: Text("SI"),
                              onPressed: () {
                                peticionesDB.eliminarTodo();
                                control.cargarTodaBD();
                                Navigator.pop(context);
                              }),
                          DialogButton(
                              color: Colors.grey,
                              child: Text("NO"),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                        desc:
                            "Esta seguro que desea eliminar TODAS LAS UBICACIONES?")
                    .show();
              },
              icon: Icon(Icons.delete_forever))
        ],
      ),
      body: listar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          obtenerLocalizacion();
          Alert(
                  title: "ATENCION!",
                  desc: "Seguro desea almacenar su ubicacion?",
                  type: AlertType.info,
                  buttons: [
                    DialogButton(
                        color: Colors.amber,
                        child: Text("SI"),
                        onPressed: () {
                          peticionesDB.guardarPosicion(
                              control.UnaPosicion, DateTime.now().toString());
                          control.cargarTodaBD();
                          Navigator.pop(context);
                        }),
                    DialogButton(
                        color: Colors.red,
                        child: Text("NO"),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                  context: context)
              .show();
        },
        child: Icon(Icons.location_on_outlined),
      ),
    );
  }
}
