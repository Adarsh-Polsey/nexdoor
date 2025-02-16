class Service {
  final String name;
  final String? description;
  final int duration; // Duration in minutes
  final double price;
  final Map<String, List<String>> availability; // Days and time slots

  Service({
    required this.name,
    this.description,
    required this.duration,
    required this.price,
    required this.availability,
  });

  // Convert the Service object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'duration': duration,
      'price': price,
      'availability': availability,
    };
  }
}