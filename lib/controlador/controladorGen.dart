import 'package:get/get.dart';
import 'package:gps_tracking/proceso/peticiones.dart';

class controladorGen extends GetxController {
  final Rxn<List<Map<String, dynamic>>> listaPosiciones =
      Rxn<List<Map<String, dynamic>>>();
  final unaPosicion = "".obs;

/////////////////////////////////////
  void cargaUnaPosicion(String x) {
    unaPosicion.value = x;
  }

  String get UnaPosicion => unaPosicion.value;
/////////////////////////////////////
  void cargarPosiciones(List<Map<String, dynamic>> x) {
    listaPosiciones.value = x;
  }

  List<Map<String, dynamic>>? get ListaPosiciones => listaPosiciones.value;

////////////////////////////////////////

  Future<void> cargarTodaBD() async {
    final datos = await peticionesDB.mostrarUbicaciones();
    cargarPosiciones(datos);
  }
}
