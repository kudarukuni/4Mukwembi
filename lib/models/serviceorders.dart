class ServiceOrders {
  final String job_id;
  final String address;
  final String status;
  final String complaintno;

  final String out_type_description;
  final String meterno;
  final String artisanassignedon;
  final String additional_notes;

  ServiceOrders(
      {required this.address,
      required this.status,
      required this.out_type_description,
      required this.job_id,
      required this.meterno,
      required this.artisanassignedon,
      required this.complaintno,
      required this.additional_notes});

  toOrderList(json) {
    List<ServiceOrders> orders = [];
    for (var data in json) {
      Map<dynamic, dynamic> order = {
        'job_id': data['job_id'],
        'address': data['address'],
        'status': data['status'],
        'out_type_description': data['out_type_description'],
        'meterno': data['meterno'],
        'complaintno': data['complaintno'],
        'artisanassignedon': data['artisanassignedon'],
        'additional_notes': data['additional_notes']
      };
      orders.add(ServiceOrders(
          job_id: order['job_id'],
          address: order['address'],
          status: order['status'],
          complaintno: order['complaintno'],
          out_type_description: order['out_type_description'],
          meterno: order['meterno'],
          artisanassignedon: order['artisanassignedon'],
          additional_notes: order['additional_notes']));
    }
    return orders;
  }
}
