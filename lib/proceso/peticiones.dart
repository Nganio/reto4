import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart' as sql;

class peticionesDB {
  static Future<void> crearTabla(sql.Database database) async {
    await database.execute(""" CREATE TABLE posiciones (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      coordenadas TEXT,
      fecha TEXT
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("geo.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await crearTabla(database);
    });
  }

  static Future<List<Map<String, dynamic>>> mostrarUbicaciones() async {
    final base = await peticionesDB.db();
    return base.query("posiciones", orderBy: "fecha");
  }

  static Future<void> eliminarPosicion(int idPosicion) async {
    final base = await peticionesDB.db();
    base.delete("posiciones", where: "id=?", whereArgs: [idPosicion]);
  }

  static Future<void> eliminarTodo() async {
    final base = await peticionesDB.db();
    base.delete("posiciones");
  }

  static Future<void> guardarPosicion(coor, fecha) async {
    final base = await peticionesDB.db();
    final datos = {"coordenadas": coor, "fecha": fecha};
    await base.insert("posiciones", datos,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
