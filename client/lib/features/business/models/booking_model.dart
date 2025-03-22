
class BookingModel {
  final String? id;
  final String? userId;
  final String? serviceId;
  final String? businessId;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  BookingModel({
    this.id,
    this.userId,
    this.serviceId,
    this.businessId,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id']??"",
      userId: json['user_id']??"",
      serviceId: json['service_id']??"",
      businessId: json['business_id']??"",
      bookingDate: json['booking_date']??"",
      startTime: json['start_time']??"",
      endTime: json['end_time']??"",
      status: json['status']??"",
      createdAt: json['created_at']??"",
      updatedAt: json['updated_at']??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'service_id': serviceId,
      'business_id': businessId,
      'booking_date': bookingDate,
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
    };
  }
}

// time_slot_model.dart
class TimeSlot {
  final String time;
  final bool isAvailable;

  TimeSlot({
    required this.time,
    required this.isAvailable,
  });
}