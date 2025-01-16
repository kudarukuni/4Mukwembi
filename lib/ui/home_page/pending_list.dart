import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:oms/database/DBHelper.dart';
import 'package:oms/models/materials.dart';
import 'package:oms/models/pending_so.dart';
import 'package:oms/pages/materials/reserve_materials.dart';
import 'package:oms/pages/pending.dart';
import 'package:shared_preferences/shared_preferences.dart';

_updateOrder({orderJSON, context}) async {
  Map<String, String> headers = {"Content-type": "application/json"};
  dynamic exec = orderJSON['job_id.toString()'],
      fault_IDENTIFICATION = orderJSON['fault_IDENTIFICATION'],
      attendance_START = orderJSON['attendance_START'],
      arrival_AT_LOCATION = orderJSON['arrival_AT_LOCATION'],
      notes = orderJSON['notes'],
      weather_CONDITION = orderJSON['weather_CONDITION'],
      cause = orderJSON['cause'],
      so_CURRENT_STATUS = orderJSON['so_CURRENT_STATUS'];

  Response response = await put(
      'https://agent.zetdc.co.zw/omsmobile/update_order.php?job_id.toString()=$exec&fault_IDENTIFICATION=$fault_IDENTIFICATION&attendance_START=$attendance_START&arrival_AT_LOCATION=$arrival_AT_LOCATION&notes=$notes&weather_CONDITION=$weather_CONDITION&cause=$cause&so_CURRENT_STATUS=$so_CURRENT_STATUS'
          as Uri,
      headers: headers);

  print(fault_IDENTIFICATION + 'identify');

  if (response.statusCode == 200) {
    print('bholato');
  } else {
    print(response.statusCode);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text("Success"));
        });
  }
}

Future<dynamic> arriveIdentfy({job_id}) async {
  var dbHelper = DatabaseHelper();
  Future<List<PendingServiceOrder>> order =
      dbHelper.getOneServiceOrder(job_id: job_id);
  return order;
}

Future<List<PendingServiceOrder>> getPendingServiceOrderFromDB() async {
  var dbHelper = DatabaseHelper();
  Future<List<PendingServiceOrder>> orderz = dbHelper.getServiceOrders();
  return orderz;
}

class PendingList extends StatefulWidget {
  PendingList({required Key key}) : super(key: key);

  @override
  _PendingListState createState() => _PendingListState();
}

class _PendingListState extends State<PendingList> {
  late String arrivalTime;
  late bool arrive;
  late bool id;
  late bool view = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: FutureBuilder<List<PendingServiceOrder>>(
        future: getPendingServiceOrderFromDB(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data![index].arrival_AT_LOCATION == '') {
                      this.arrive = true;
                      this.id = false;
                    } else {
                      this.arrive = false;
                      if (snapshot.data![index].fault_IDENTIFICATION == '') {
                        this.id = true;
                        this.view = false;
                      } else {
                        this.view = true;
                        this.id = false;
                      }
                    }
                    return new Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {},
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.album,
                                          size: 50,
                                          color: Colors.orange,
                                        ),
                                        title: Text(snapshot.data![index].job_id
                                            .toString()),
                                        subtitle: Text(snapshot
                                            .data![index].attendance_START),
                                      ),
                                    ),
                                    Visibility(
                                      visible: this
                                          .arrive, //(snapshot.data[index].attendance_START == '')? true : false,
                                      child: TextButton(
                                          child: const Text('ARRIVE',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          onPressed: () {
                                            DateTime now = DateTime.now();
                                            DateFormat formatterDay =
                                                DateFormat('yyyy-MM-dd');
                                            DateFormat formatterTime =
                                                DateFormat('hh:mm:ss');
                                            String formattedDay =
                                                formatterDay.format(now);
                                            String formattedTime =
                                                formatterTime.format(now);

                                            var dateTime = formattedDay +
                                                'T' +
                                                formattedTime +
                                                'Z';

                                            Map<dynamic, dynamic> dataJson = {
                                              "job_id.toString()": snapshot
                                                  .data![index].job_id
                                                  .toString(),
                                              "attendance_START": snapshot
                                                  .data![index]
                                                  .attendance_START,
                                              "fault_IDENTIFICATION": '',
                                              "arrival_AT_LOCATION": dateTime,
                                              "notes": '',
                                              "weather_CONDITION": '',
                                              "cause": '',
                                              "so_CURRENT_STATUS": ''
                                            };

                                            _updateOrder(
                                                orderJSON: dataJson,
                                                //orderJSON: jsonEncode(dataJson),
                                                context: context);

                                            var job = PendingServiceOrder(
                                                job_id: snapshot
                                                    .data![index].job_id,
                                                arrival_AT_LOCATION: dateTime,
                                                ids: null,
                                                attendance_START: '',
                                                fault_IDENTIFICATION: '',
                                                notes: '',
                                                weather_CONDITION: '',
                                                cause: '',
                                                so_CURRENT_STATUS: '');

                                            var db = DatabaseHelper();
                                            db.updateServiceOrderArrivalAtLocation(
                                                job);

                                            print(snapshot
                                                .data![index].attendance_START);
                                            print(snapshot.data![index]
                                                .arrival_AT_LOCATION);

                                            // apa takubisa arrive from UX toisa id
                                            setState(() {
                                              this.arrive = false;
                                              // getPendingServiceOrderFromDB();
                                            });

                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      content: Text(
                                                          "Arival time saved"));
                                                });
                                          }),
                                    ),
                                    Visibility(
                                      visible: this.id,
                                      child: TextButton(
                                        child: const Text('IDENTIFY FAULT',
                                            style:
                                                TextStyle(color: Colors.blue)),
                                        onPressed: () {
                                          setState(() {
                                            this.id = false;
                                          });
                                          DateTime now = DateTime.now();
                                          DateFormat formatterDay =
                                              DateFormat('yyyy-MM-dd');
                                          DateFormat formatterTime =
                                              DateFormat('hh:mm:ss');
                                          String formattedDay =
                                              formatterDay.format(now);
                                          String formattedTime =
                                              formatterTime.format(now);

                                          var dateTime = formattedDay +
                                              'T' +
                                              formattedTime +
                                              'Z';

                                          Map<dynamic, dynamic> dataJson = {
                                            "job_id.toString()": snapshot
                                                .data![index].job_id
                                                .toString(),
                                            "attendance_START": snapshot
                                                .data![index].attendance_START,
                                            "fault_IDENTIFICATION": dateTime,
                                            "arrival_AT_LOCATION": snapshot
                                                .data![index]
                                                .arrival_AT_LOCATION,
                                            "notes": '',
                                            "weather_CONDITION": '',
                                            "cause": '',
                                            "so_CURRENT_STATUS": ''
                                          };

                                          _updateOrder(
                                              orderJSON: dataJson,
                                              //orderJSON: jsonEncode(dataJson),
                                              context: context);

                                          var job = PendingServiceOrder(
                                              job_id:
                                                  snapshot.data![index].job_id,
                                              fault_IDENTIFICATION: dateTime,
                                              ids: null,
                                              attendance_START: '',
                                              arrival_AT_LOCATION: '',
                                              notes: '',
                                              weather_CONDITION: '',
                                              cause: '',
                                              so_CURRENT_STATUS: '');

                                          var db = DatabaseHelper();
                                          db.updateServiceOrderFaultID(job);

                                          print(snapshot
                                              .data![index].attendance_START);
                                          print(snapshot.data![index]
                                              .arrival_AT_LOCATION);
                                          print(snapshot.data![index]
                                              .fault_IDENTIFICATION);

                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                    content: Text(
                                                        "Fault ID time saved"));
                                              });
                                        },
                                      ),
                                    ),
                                    ButtonBar(
                                      alignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReserveMaterials(
                                                          job_id: snapshot
                                                              .data![index]
                                                              .job_id,
                                                          key: UniqueKey(),
                                                          materials: Materials(
                                                              id: null,
                                                              resDate: '',
                                                              createdby: '',
                                                              moveType: '',
                                                              material: '',
                                                              plant: '',
                                                              stgeloc: '',
                                                              entryqnt: '',
                                                              reqDate: '',
                                                              itemtext: ''),
                                                        )));
                                          },
                                          child: Text('Reserve Materials'),
                                          style: ElevatedButton.styleFrom(
                                            elevation: 4,
                                            iconColor:
                                                Theme.of(context).primaryColor,
                                            // Set the elevation value here
                                          ),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                getPendingServiceOrderFromDB();
                                              });
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          PendingPage(
                                                            job_id: snapshot
                                                                .data![index]
                                                                .job_id,
                                                            key: UniqueKey(),
                                                            DateTime: '',
                                                          )));
                                            },
                                            child: Text('View more'),
                                            style: ElevatedButton.styleFrom(
                                              elevation: 4,
                                              iconColor: Theme.of(context)
                                                  .primaryColor,
                                              // Set the elevation value here
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  });
            } else if (snapshot.data!.length == 0) {
              return Text('No Data Found');
            }
          }
          return new Container(
            alignment: AlignmentDirectional.center,
            child: new CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
