import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:oms/models/unassigned.dart';

import 'assign_page.dart';

Future<List<UnassignedOrders>> fetchServiceOrders({ecnumber}) async {
  var serviceOrders = UnassignedOrders(
      network_SERVICE_SUBTYPE: '',
      situation: '',
      network_SERVICE_NUMBER: '',
      creation_DATE_INC: '',
      reference_ELEMENT_ADDRESS: '',
      voltage_LEVEL: '',
      hood_LABEL_INC: '',
      node_ID_INC: '',
      order_ID: 0);
  return serviceOrders.toOrderList([
    {
      'network_SERVICE_NUMBER': 'ZIMS2022-235',
      'network_SERVICE_SUBTYPE': 'TREE ON LINE',
      'situation': 'No Power On Red Phase',
      'creation_DATE_INC': '2022-08-07',
      'reference_ELEMENT_ADDRESS': '69 Chiremba Road, Wilmington Park',
      'voltage_LEVEL': 'MV',
      'hood_LABEL_INC': 'Chiremba Areas',
      'node_ID_INC': ''
    }
  ]);
}

String getOrderAddress(adres) {
  if (adres != null) {
    return adres;
  } else {
    return 'No Address';
  }
}

class AssignToPage extends StatefulWidget {
  final String ecnumber;
  AssignToPage({required Key key, required this.ecnumber}) : super(key: key);

  @override
  _AssignToPageState createState() => _AssignToPageState();
}

class _AssignToPageState extends State<AssignToPage> {
  late Future<List<UnassignedOrders>> unassignedOrders;

  @override
  void initState() {
    super.initState();
    unassignedOrders = fetchServiceOrders(ecnumber: widget.ecnumber);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UnassignedOrders>>(
      future: unassignedOrders,
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AssignJobPage(
                                                  data: snapshot.data![index],
                                                  key: UniqueKey(),
                                                )),
                                      );
                                    },
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.build,
                                        size: 30,
                                        color: Colors.red,
                                      ),
                                      title: Text(getOrderAddress(snapshot
                                          .data![index]
                                          .reference_ELEMENT_ADDRESS)),
                                      subtitle: Text(snapshot.data![index]
                                          .network_SERVICE_SUBTYPE),
                                      trailing: Text(snapshot
                                          .data![index].network_SERVICE_NUMBER),
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
        // By default, show a loading spinner.
        return new Container(
          alignment: AlignmentDirectional.center,
          child: new CircularProgressIndicator(),
        );
      },
    );
  }
}
