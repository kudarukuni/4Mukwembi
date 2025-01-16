class PendingServiceOrder {
  late int? ids;
  late int job_id;
  late String attendance_START;
  late String arrival_AT_LOCATION;
  late String fault_IDENTIFICATION;
  late String notes;
  late String weather_CONDITION;
  late String cause;
  late String so_CURRENT_STATUS;

  int? get id => ids;
  int get execLabel => job_id;
  set execLabel(int value) => job_id = value;
  String get attendance_start => attendance_START;
  set attendance_start(String value) => attendance_START = value;
  String get arrival_at_location => arrival_AT_LOCATION;
  set arrival_at_location(String value) => arrival_AT_LOCATION = value;
  String get faultidentification => fault_IDENTIFICATION;
  set faultidentification(String value) => fault_IDENTIFICATION = value;
  String get notez => notes;
  set notez(String value) => notes = value;
  String get weather_condition => weather_CONDITION;
  set weather_condition(String value) => weather_CONDITION = value;
  String get causez => cause;
  set causez(String value) => cause = value;
  String get so_CURRENT_STATUz => so_CURRENT_STATUS;
  set so_CURRENT_STATUz(String value) => so_CURRENT_STATUS = value;

  PendingServiceOrder({
    required this.ids,
    required this.job_id,
    required String attendance_START,
    required String arrival_AT_LOCATION,
    required String fault_IDENTIFICATION,
    required String notes,
    required String weather_CONDITION,
    required String cause,
    required String so_CURRENT_STATUS,
  })  : attendance_START = attendance_START,
        arrival_AT_LOCATION = arrival_AT_LOCATION,
        fault_IDENTIFICATION = fault_IDENTIFICATION,
        notes = notes,
        weather_CONDITION = weather_CONDITION,
        cause = cause,
        so_CURRENT_STATUS = so_CURRENT_STATUS;

  PendingServiceOrder.withID(
    this.ids,
    this.job_id,
    String attendance_START,
    String arrival_AT_LOCATION,
    String fault_IDENTIFICATION,
    String notes,
    String weather_CONDITION,
    String cause,
    String so_CURRENT_STATUS,
  )   : attendance_START = attendance_START,
        arrival_AT_LOCATION = arrival_AT_LOCATION,
        fault_IDENTIFICATION = fault_IDENTIFICATION,
        notes = notes,
        weather_CONDITION = weather_CONDITION,
        cause = cause,
        so_CURRENT_STATUS = so_CURRENT_STATUS;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = ids;
    }
    map['job_id'] = job_id;
    map['attendance_START'] = attendance_START;
    map['arrival_AT_LOCATION'] = arrival_AT_LOCATION;
    map['fault_IDENTIFICATION'] = fault_IDENTIFICATION;
    map['notes'] = notes;
    map['weather_CONDITION'] = weather_CONDITION;
    map['cause'] = cause;
    map['so_CURRENT_STATUS'] = so_CURRENT_STATUS;

    return map;
  }

  PendingServiceOrder.fromMapObject(Map<String, dynamic> map) {
    this.ids = map['id'];
    this.job_id = map['job_id'];
    this.attendance_START = map['attendance_start'];
    this.arrival_AT_LOCATION = map['arrival_at_location'];
    this.fault_IDENTIFICATION = map['fault_IDENTIFICATION'];
    this.notes = map['notes'];
    this.weather_CONDITION = map['weather_condition'];
    this.cause = map['cause'];
    this.so_CURRENT_STATUS = map['so_CURRENT_STATUS'];
  }
}
