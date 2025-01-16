import 'dart:io' as io;
import 'dart:async';
import 'package:oms/models/pending_so.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final serviceOrdersTable = "serviceOrder_table";
  static Database? db_instance;
  Future<Database> get db async {
    if (db_instance == null) {
      db_instance = await initDB();
    }
    return db_instance!;
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "moms.db");
    var db = await openDatabase(path, version: 4, onCreate: onCreateFunc);
    return db;
  }

  void onCreateFunc(Database db, int version) async {
    await db.execute('''CREATE TABLE $serviceOrdersTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        job_id INTEGER,
        attendance_START TEXT,
        arrival_AT_LOCATION TEXT,
        fault_IDENTIFICATION TEXT,
        notes TEXT,
        weather_CONDITION TEXT,
        cause TEXT,
        so_CURRENT_STATUS TEXT       
         );''');
  }

  Future<List<PendingServiceOrder>> getServiceOrders() async {
    var db_connection = await db;
    List<Map<String, dynamic>> list =
        await db_connection.rawQuery('SELECT * FROM $serviceOrdersTable');
    List<PendingServiceOrder> serviceOrders = [];
    for (var i = 0; i < list.length; i++) {
      PendingServiceOrder serviceOrder = PendingServiceOrder(
          ids: null,
          job_id: 0,
          attendance_START: '',
          arrival_AT_LOCATION: '',
          fault_IDENTIFICATION: '',
          notes: '',
          weather_CONDITION: '',
          cause: '',
          so_CURRENT_STATUS: '');
      serviceOrder.job_id = list[i]['job_id'];
      serviceOrder.attendance_START = list[i]['attendance_START'];
      serviceOrder.arrival_AT_LOCATION = list[i]['arrival_AT_LOCATION'];
      serviceOrder.fault_IDENTIFICATION = list[i]['fault_IDENTIFICATION'];
      serviceOrder.notes = list[i]['notes'];
      serviceOrder.weather_CONDITION = list[i]['weather_CONDITION'];
      serviceOrder.cause = list[i]['cause'];
      serviceOrder.so_CURRENT_STATUS = list[i]['so_CURRENT_STATUS'];
      serviceOrders.add(serviceOrder);
    }
    return serviceOrders;
  }

  Future<List<PendingServiceOrder>> getOneServiceOrder({job_id}) async {
    var db_connection = await db;
    List<Map> list = await db_connection
        .rawQuery('SELECT * FROM $serviceOrdersTable WHERE job_id = $job_id');
    List<PendingServiceOrder> serviceOrders = [];
    for (var i = 0; i < list.length; i++) {
      PendingServiceOrder serviceOrder = new PendingServiceOrder(
          ids: null,
          job_id: 0,
          attendance_START: '',
          arrival_AT_LOCATION: '',
          fault_IDENTIFICATION: '',
          notes: '',
          weather_CONDITION: '',
          cause: '',
          so_CURRENT_STATUS: '');
      serviceOrder.job_id = list[i]['job_id'];
      serviceOrder.attendance_START = list[i]['attendance_START'];
      serviceOrder.arrival_AT_LOCATION = list[i]['arrival_AT_LOCATION'];
      serviceOrder.fault_IDENTIFICATION = list[i]['fault_IDENTIFICATION'];
      serviceOrder.notes = list[i]['notes'];
      serviceOrder.weather_CONDITION = list[i]['weather_CONDITION'];
      serviceOrder.cause = list[i]['cause'];
      serviceOrder.so_CURRENT_STATUS = list[i]['so_CURRENT_STATUS'];
      serviceOrders.add(serviceOrder);
    }
    return serviceOrders;
  }

  void addServiceOrder(PendingServiceOrder serviceOrder) async {
    var db_connection = await db;
    String sql = '''INSERT INTO $serviceOrdersTable(
          job_id,
          attendance_START,
          arrival_AT_LOCATION,
          fault_IDENTIFICATION,
          notes,
          weather_CONDITION,
          cause,
          so_CURRENT_STATUS
          
          ) VALUES(
            \'${serviceOrder.job_id}\',
            \'${serviceOrder.attendance_START}\',
            \'${serviceOrder.arrival_AT_LOCATION}\',
            \'${serviceOrder.fault_IDENTIFICATION}\',
            \'${serviceOrder.notes}\',
            \'${serviceOrder.weather_CONDITION}\',
            \'${serviceOrder.cause}\',
            \'${serviceOrder.so_CURRENT_STATUS}\'            
            )''';
    await db_connection.transaction((action) async {
      return await action.rawInsert(sql);
    });
  }

  void updateServiceOrderArrivalAtLocation(
      PendingServiceOrder serviceOrder) async {
    var db_connection = await db;
    String sql = '''UPDATE $serviceOrdersTable SET 
      arrival_AT_LOCATION =\'${serviceOrder.arrival_AT_LOCATION}\'
      WHERE job_id='${serviceOrder.job_id}' ''';
    await db_connection.transaction((action) async {
      return await action.rawQuery(sql);
    });
  }

  void updateServiceOrderFaultID(PendingServiceOrder serviceOrder) async {
    var db_connection = await db;
    String sql = '''UPDATE $serviceOrdersTable SET 
      fault_IDENTIFICATION =\'${serviceOrder.fault_IDENTIFICATION}\'
      WHERE job_id='${serviceOrder.job_id}' ''';
    await db_connection.transaction((action) async {
      return await action.rawQuery(sql);
    });
  }

  void updateServiceInexecution(PendingServiceOrder serviceOrder) async {
    var db_connection = await db;
    String sql = '''UPDATE $serviceOrdersTable SET 
      
      notes =\'${serviceOrder.notes}\',
      weather_CONDITION =\'${serviceOrder.weather_CONDITION}\',
      cause =\'${serviceOrder.cause}\',
      so_CURRENT_STATUS =\'${serviceOrder.so_CURRENT_STATUS}\'    
          
   
      WHERE job_id='${serviceOrder.job_id}' ''';
    await db_connection.transaction((action) async {
      return await action.rawQuery(sql);
    });
  }

  void deleteServiceOrder(job_id) async {
    var db_connection = await db;
    String sql = 'DELETE FROM $serviceOrdersTable WHERE job_id = "$job_id"';
    await db_connection.transaction((action) async {
      return await action.rawQuery(sql);
    });
  }
}
