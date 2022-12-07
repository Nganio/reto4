import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gps_tracking/controlador/controladorGen.dart';
import 'package:gps_tracking/proceso/peticiones.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class listar extends StatefulWidget {
  const listar({super.key});

  @override
  State<listar> createState() => listarState();
}

class listarState extends State<listar> {
  controladorGen control = Get.find();
  @override
  void initState() {
    super.initState();
    control.cargarTodaBD();
  }

  Widget build(BuildContext context) {
    return Obx(() => Container(
          child: control.ListaPosiciones!.isEmpty == false
              ? ListView.builder(
                  itemCount: control.ListaPosiciones!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.location_searching_rounded),
                        trailing: IconButton(
                            onPressed: () {
                              Alert(
                                      type: AlertType.warning,
                                      context: context,
                                      title: "ATENCION!",
                                      buttons: [
                                        DialogButton(
                                            color: Colors.orange,
                                            child: Text("SI"),
                                            onPressed: () {
                                              peticionesDB.eliminarPosicion(
                                                  control.ListaPosiciones![
                                                      index]["id"]);
                                              control.cargarTodaBD();
                                              Navigator.pop(context);
                                            }),
                                        DialogButton(
                                            color: Colors.blue,
                                            child: Text("NO"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }),
                                      ],
                                      desc:
                                          "Esta seguro que desea eliminar la ubicacion?")
                                  .show();
                            },
                            icon: Icon(Icons.delete_outlined)),
                        title: Text(
                            control.ListaPosiciones![index]["coordenadas"]),
                        subtitle:
                            Text(control.ListaPosiciones![index]["fecha"]),
                      ),
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }
}
