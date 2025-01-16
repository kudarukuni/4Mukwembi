import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oms/models/materials.dart';
import 'package:http/http.dart' as http;
import 'package:oms/utils/settings.dart';

class ReserveMaterials extends StatefulWidget {
  late int job_id;
  late Materials materials;
  ReserveMaterials(
      {required Key key, required this.job_id, required this.materials})
      : super(key: key);

  @override
  _ReserveMaterialsState createState() => _ReserveMaterialsState();
}

class _ReserveMaterialsState extends State<ReserveMaterials> {
  Future<http.Response> sentMaterialReq({required String materialReq}) async {
    URLconfigs urLconfigs;
    urLconfigs = new URLconfigs();
    String url = urLconfigs.getMaterialRequisitionURL();
    final response = await http.post(url as Uri, body: materialReq, headers: {
      "accept": "application/json",
      "content-type": "application/json"
    });
    return response;
  }

  Future<void> _stfNumber(
      {required BuildContext context, required String stfnumber}) async {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Your STF Number is $stfnumber'),
              ],
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController resDateController = TextEditingController();
  TextEditingController createdbyController = TextEditingController();
  TextEditingController moveTypeController = TextEditingController();
  TextEditingController materialController = TextEditingController();
  TextEditingController plantController = TextEditingController();
  TextEditingController stgelocController = TextEditingController();
  TextEditingController entryqntController = TextEditingController();
  TextEditingController reqDateController = TextEditingController();
  TextEditingController itemtextController = TextEditingController();

  late String resDate;
  late String createdby;
  late String moveType;
  late String material;
  late String plant;
  late String stgeloc;
  late String entryqnt;
  late String reqDate;
  late String itemtext;

  Materials materials = new Materials(
    id: null,
    resDate: '',
    createdby: '',
    moveType: '',
    material: '',
    plant: '',
    stgeloc: '',
    entryqnt: '',
    reqDate: '',
    itemtext: '',
  );

  DateTime selectedDate = DateTime.now();
  DateTime selectDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var job_id;
    return Container(
        alignment: Alignment.center,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Reserve materials', textAlign: TextAlign.center),
            ),
            body: Padding(
              padding: EdgeInsets.only(top: 15.0, left: 30.0, right: 30.0),
              child: Form(
                key: _formKey,
                child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Reservation Date',
                                hintText: 'Reservation Date'),
                            controller: resDateController,
                            keyboardType: TextInputType.datetime,
                            onSaved: (value) => this.resDate = value as String,
                          ),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Created By', hintText: 'Created By'),
                        controller: createdbyController,
                        onSaved: (value) => this.createdby = value as String,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Movement Type',
                            hintText: 'Movement Type'),
                        controller: moveTypeController,
                        onSaved: (value) => this.moveType = value as String,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Material', hintText: 'Material'),
                        controller: materialController,
                        onSaved: (value) => this.material = value as String,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Plant', hintText: 'Plant'),
                        controller: plantController,
                        keyboardType: TextInputType.number,
                        onSaved: (value) => this.plant = value as String,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Storage Location',
                            hintText: 'Storage Location'),
                        controller: stgelocController,
                        keyboardType: TextInputType.number,
                        onSaved: (value) => this.stgeloc = value as String,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Quantity', hintText: 'Quantity'),
                        controller: entryqntController,
                        keyboardType: TextInputType.number,
                        onSaved: (value) => this.entryqnt = value as String,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Item Text', hintText: 'Item Text'),
                        controller: itemtextController,
                        onSaved: (value) => this.itemtext = value as String,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Row(children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Request Materials',
                                    textScaleFactor: 1.3),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    Map<String, dynamic> newMaterialReq = {
                                      "ResDate": resDate,
                                      "CreatedBy": createdby,
                                      "MoveType": moveType,
                                      "Material": material,
                                      "Plant": plant,
                                      "StgeLoc": stgeloc,
                                      "ReqDate": resDate,
                                      "ItemText": itemtext,
                                      "entryqnt": entryqnt
                                    };

                                    sentMaterialReq(
                                            materialReq:
                                                json.encode(newMaterialReq))
                                        .then((response) {
                                      if (response.statusCode == 200) {
                                        _stfNumber(
                                            stfnumber: jsonDecode(
                                                response.body)['Reservation'],
                                            context: context);
                                      }
                                    }).catchError((err) {
                                      print(err);
                                    });
                                  }
                                },
                              ),
                            )
                          ])),
                    ]),
              ),
            )));
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectDate,
        firstDate: DateTime(2021, 5),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectDate) {
      setState(() {
        selectDate = picked;
        var date =
            "${picked.year.toString()}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        resDateController.text = date;
      });
    }
  }
}
