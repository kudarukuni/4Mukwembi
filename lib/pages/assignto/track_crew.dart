import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:oms/models/crews.dart';
import 'package:oms/models/unassigned.dart';

Future<List<Crews>> fetchCrews({required String depot}) async {
  var crew = Crews(
      rsc_description: '',
      rsc_label: '',
      rsc_type: '',
      ognd_description: '',
      rsc_org_area_node_id: '',
      pers_identity: '',
      rsc_id: '');
  return crew.toOrderList([
    {'rsc_description': 'L. Simoyi', 'pers_identity': 'CBD-674'},
    {'rsc_description': 'T. Saidi', 'pers_identity': 'CBD-675'},
    {'rsc_description': 'T. Mubaiwa', 'pers_identity': 'CBD-677'},
    {'rsc_description': 'B. Chikura', 'pers_identity': 'CBD-676'},
  ]);
}

_updateJob({orderJSON, context}) async {
  Map<String, String> headers = {"Content-type": "application/json"};
  dynamic exec_order = orderJSON['exec_order'],
      dispatch_date = orderJSON['dispatch_date'],
      instance_oper_node = orderJSON['instance_oper_node'],
      resource_id = orderJSON['resource_id'];

  Response response = await put(
      'https://agent.zetdc.co.zw/omsmobile/update_art.php?exec_order=$exec_order&dispatch_date=$dispatch_date&instance_oper_node=$instance_oper_node&resource_id=$resource_id'
          as Uri,
      headers: headers);

  print(resource_id + 'bho');

  if (response.statusCode == 200) {
    print("bholato artisan assigned");
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("Job assigned successfully"),
        );
      },
    );
  } else {
    print(response.statusCode);
  }
}

class TrackCrew extends StatefulWidget {
  final UnassignedOrders data;
  final Crews daata;
  TrackCrew({required Key key, required this.data, required this.daata})
      : super(key: key);

  @override
  _TrackCrewState createState() => _TrackCrewState();
}

class _TrackCrewState extends State<TrackCrew> {
  late Future<List<Crews>> crews;

  @override
  void initState() {
    super.initState();
    crews = fetchCrews(depot: widget.data.node_ID_INC);
    //crews = fetchCrews();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Crews>>(
      future: crews,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
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
                                    onTap: () {
                                      bholato();
                                    },
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.blue[400],
                                      ),
                                      title: Text(snapshot
                                          .data![index].rsc_description),
                                      trailing: Text(
                                          snapshot.data![index].pers_identity),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
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
    );
  }

  void bholato() {
    DateTime now = DateTime.now();
    DateFormat formatterDay = DateFormat('yyyy-MM-dd');
    DateFormat formatterTime = DateFormat('hh:mm:ss');
    String formattedDay = formatterDay.format(now);
    String formattedTime = formatterTime.format(now);

    var dateTime = formattedDay + 'T' + formattedTime + 'Z';

    print(dateTime);

    Map<dynamic, dynamic> dataJson = {
      "exec_order": widget.data.order_ID,
      "dispatch_date": dateTime,
      "instance_oper_node": widget.data.node_ID_INC,
      "resource_id": '26026'
    };

    _updateJob(orderJSON: dataJson, context: context);
  }
}
