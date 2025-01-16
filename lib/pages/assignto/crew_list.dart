import 'package:flutter/material.dart';
import 'package:oms/models/crews.dart';
import 'package:oms/models/unassigned.dart';
import 'package:oms/pages/assignto/track_crew.dart';

class CrewList extends StatefulWidget {
  final UnassignedOrders data;
  CrewList({required Key key, required this.data}) : super(key: key);

  @override
  _CrewListState createState() => _CrewListState();
}

class _CrewListState extends State<CrewList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Crew List', textAlign: TextAlign.center),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                Expanded(
                  child: TrackCrew(
                    data: widget.data,
                    key: UniqueKey(),
                    daata: Crews(
                        rsc_description: '',
                        rsc_label: '',
                        rsc_type: '',
                        ognd_description: '',
                        rsc_org_area_node_id: '',
                        pers_identity: '',
                        rsc_id: ''),
                  ),
                )
              ])),
    );
  }
}
