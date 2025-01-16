import 'package:flutter/material.dart';
import 'package:oms/models/serviceorders.dart';
import 'package:oms/ui/home_page/viewjobform.dart';
import 'package:oms/ui/reject_job_page/reject_form.dart';
import 'package:http/http.dart';

_updateOrder({job_id, context}) async {
  Map<String, String> headers = {"Content-type": "application/json"};
  var map = new Map<String, dynamic>();
  map['status'] = "aborted";
  map['reason'] = "rejected";
  map['job_id'] = job_id;
  Response response = await post(
      'http://moms.zetdc.co.zw/zims_incoming_jobs.php/$job_id' as Uri,
      body: map);

  if (response.statusCode == 200) {
  } else {
    print(response.statusCode);
  }
}

class RejectJobPage extends StatelessWidget {
  final String incident_number;
  final String reason;
  final String so_CURRENT_STATUS;

  RejectJobPage(
      {required Key key,
      required this.incident_number,
      required this.reason,
      required this.so_CURRENT_STATUS})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = new GlobalKey<ScaffoldState>();
    return Container(
        child: Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Abort Job', textAlign: TextAlign.center),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              RejectJobForm(
                key: UniqueKey(),
                incident_number: this.incident_number,
                reason: this.reason,
                so_CURRENT_STATUS: this.so_CURRENT_STATUS,
              )
            ],
          )),
    ));
  }
}
