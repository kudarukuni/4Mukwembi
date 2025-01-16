import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:oms/models/serviceorders.dart';
import 'package:oms/ui/home_page/viewjob.dart';

Future<List<dynamic>> fetchServiceOrders({ecnumber}) async {
  var serviceOrders = ServiceOrders(
      address: '',
      status: '',
      out_type_description: '',
      job_id: '',
      meterno: '',
      artisanassignedon: '',
      complaintno: '',
      additional_notes: '');
  var map = new Map<String, dynamic>();
  map['ecnumber'] = ecnumber;
  final response = await http
      .post('http://10.0.2.2:8000/api/artisan_get_jobs/$ecnumber' as Uri);
  print(response);
  if (response.statusCode == 200) {
    var serviceOrders = ServiceOrders(
        address: '',
        status: '',
        out_type_description: '',
        job_id: '',
        meterno: '',
        artisanassignedon: '',
        complaintno: '',
        additional_notes: '');

    return json.decode(response.body);
  } else if (response.contentLength == null) {
    var context;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text("No obs found"));
        });
  }
  return serviceOrders.toOrderList([
    {'address': 'L. Simoyi', 'pers_identity': 'CBD-674'},
    {'address': 'T. Saidi', 'pers_identity': 'CBD-675'},
    {'address': 'T. Mubaiwa', 'pers_identity': 'CBD-677'},
    {'address': 'B. Chikura', 'pers_identity': 'CBD-676'},
  ]);
}

String getOrderAddress(address) {
  if (address != null) {
    return address;
  } else {
    return 'No Address';
  }
}

class Jobs extends StatefulWidget {
  final String ecnumber;
  Jobs({required Key key, required this.ecnumber}) : super(key: key);

  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  late Future<List<dynamic>> serviceOrders;

  @override
  void initState() {
    super.initState();
    serviceOrders = fetchServiceOrders(ecnumber: widget.ecnumber);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: serviceOrders,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return AlertDialog(
              content: Text(
                "Awaiting Jobs",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              actions: []);
        }
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
                                            builder: (context) => ViewJobPage(
                                                  data: snapshot.data![index],
                                                  key: UniqueKey(),
                                                )),
                                      );
                                    },
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.build,
                                        size: 30,
                                        color: Colors.orange,
                                      ),
                                      title: Text(
                                          snapshot.data![index]['address']),
                                      subtitle: Text(snapshot.data![index]
                                          ['out_type_description']),
                                      trailing: Text(snapshot.data![index]
                                              ['job_id']
                                          .toString()),
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
