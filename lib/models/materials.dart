class Materials {
  final int? id;
  final String resDate;
  final String createdby;
  final String moveType;
  final String material;
  final String plant;
  final String stgeloc;
  final String entryqnt;
  final String reqDate;
  final String itemtext;

  Materials(
      {required this.id,
      required this.resDate,
      required this.createdby,
      required this.moveType,
      required this.material,
      required this.plant,
      required this.stgeloc,
      required this.entryqnt,
      required this.reqDate,
      required this.itemtext});

  toOrderList(json) {
    List<Materials> materials = [];
    for (var daaata in json) {
      Map<dynamic, dynamic> orderly = {
        'id': daaata['id'],
        'resDate': daaata['resDate'],
        'createdby': daaata['createdby'],
        'moveType': daaata['moveType'],
        'material': daaata['material'],
        'plant': daaata['plant'],
        'stgeloc': daaata['stgeloc'],
        'entryqnt': daaata['entryqnt'],
        'reqDate': daaata['reqDate'],
        'itemtext': daaata['itemtext']
      };
      materials.add(Materials(
          id: orderly['id'],
          resDate: orderly['resDate'],
          createdby: orderly['createdby'],
          moveType: orderly['moveType'],
          material: orderly['material'],
          plant: orderly['plant'],
          stgeloc: orderly['stgeloc'],
          entryqnt: orderly['entryqnt'],
          reqDate: orderly['reqDate'],
          itemtext: orderly['itemtext']));
    }
    return materials;
  }
}
