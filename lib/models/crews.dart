class Crews {
  final String rsc_type;
  final String rsc_description;
  final String rsc_label;
  final String ognd_description;
  final String rsc_org_area_node_id;
  final String pers_identity;
  final String rsc_id;

  Crews(
      {required this.rsc_description,
      required this.rsc_label,
      required this.rsc_type,
      required this.ognd_description,
      required this.rsc_org_area_node_id,
      required this.pers_identity,
      required this.rsc_id});

  toOrderList(json) {
    List<Crews> crews = [];
    for (var daata in json) {
      Map<dynamic, dynamic> order = {
        'rsc_type': daata['rsc_type'],
        'rsc_description': daata['rsc_description'],
        'rsc_label': daata['rsc_label'],
        'ognd_description': daata['ognd_description'],
        'rsc_org_area_node_id': daata['rsc_org_area_node_id'],
        'pers_identity': daata['pers_identity'],
        'rsc_id': daata['rsc_id']
      };
      crews.add(Crews(
          rsc_type: order['rsc_type'],
          rsc_description: order['rsc_description'],
          rsc_label: order['rsc_label'],
          ognd_description: order['ognd_description'],
          rsc_org_area_node_id: order['rsc_org_area_node_id'],
          pers_identity: order['pers_identity'],
          rsc_id: order['rsc_id']));
    }
    return crews;
  }
}
