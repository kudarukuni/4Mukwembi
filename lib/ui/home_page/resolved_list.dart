import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:oms/database/DBHelper.dart';
import 'package:oms/models/pending_so.dart';

_updateOrder({orderJSON, context, data}) async {
  var job_id = data.job_id;
  Response response = await put(
      'http://10.0.2.2:8000/api/update_active_job/$job_id' as Uri,
      body: orderJSON);
  if (response.statusCode == 200) {
    print(job_id);
  } else {
    print(job_id);
  }
}

Future<void> _asyncConfirmDialog(
    {required BuildContext context,
    required PendingServiceOrder order,
    data}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text('Are you sure you want to send this job?'),
        actions: <Widget>[
          TextButton(
            child: const Text('NO'),
            onPressed: () {
              Navigator.of(context).pop(context);
            },
          ),
          TextButton(
            child: const Text('YES'),
            onPressed: () {
              Map<dynamic, dynamic> dataJson = {
                "attendance_START": data.attendance_START,
                "fault_IDENTIFICATION": data.fault_IDENTIFICATION,
                "arrival_AT_LOCATION": data.arrival_AT_LOCATION,
                "notes": data.notes,
                "weather_CONDITION": data.weather_CONDITION,
                "cause": data.cause,
                "so_CURRENT_STATUS": data.so_CURRENT_STATUS
              };
              _updateOrder(orderJSON: dataJson, context: context, data: data);
              Navigator.of(context).pop(context);

              hongu() {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text("Data successfully sent"),
                    );
                  },
                );
              }
            },
          )
        ],
      );
    },
  );
}

Future<List<PendingServiceOrder>> getPendingServiceOrderFromDB() async {
  var dbHelper = DatabaseHelper();
  Future<List<PendingServiceOrder>> orderz = dbHelper.getServiceOrders();
  return orderz;
}

class ResolvedList extends StatefulWidget {
  ResolvedList({required Key key}) : super(key: key);

  @override
  _ResolvedListState createState() => _ResolvedListState();
}

class _ResolvedListState extends State<ResolvedList> {
  bool view = false;
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
                    if (snapshot.data![index].so_CURRENT_STATUS != '') {
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
                                            leading:
                                                Icon(Icons.album, size: 50),
                                            title: Text(snapshot
                                                .data![index].job_id
                                                .toString()),
                                            subtitle: Text(snapshot
                                                .data![index].attendance_START),
                                            trailing: GestureDetector(
                                              child: Icon(Icons.delete,
                                                  color: Colors.red),
                                              onTap: () {
                                                var dbHelper = DatabaseHelper();
                                                dbHelper.deleteServiceOrder(
                                                    snapshot
                                                        .data![index].job_id);
                                                setState(() {
                                                  getPendingServiceOrderFromDB();
                                                });
                                              },
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              var data = snapshot.data![index];
                              _asyncConfirmDialog(
                                  context: context,
                                  data: data,
                                  order: PendingServiceOrder(
                                      ids: null,
                                      job_id: 0,
                                      attendance_START: '',
                                      arrival_AT_LOCATION: '',
                                      fault_IDENTIFICATION: '',
                                      notes: '',
                                      weather_CONDITION: '',
                                      cause: '',
                                      so_CURRENT_STATUS: ''));
                            },
                            child: const Text('Sync',
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  });
            } else if (snapshot.data!.length == 0) {
              return Text('No Data Found');
            }
          }

          // show loadinf indicator wen snapshot is empty
          return new Container(
            alignment: AlignmentDirectional.center,
            child: new CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
