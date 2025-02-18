class BookingModel {
  final String id;
  final String serviceId;
  final String timeSlot;
  final String status;

  BookingModel({
    required this.id,
    required this.serviceId,
    required this.timeSlot,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      serviceId: json['service_id'],
      timeSlot: json['time_slot'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'time_slot': timeSlot,
    };
  }
}