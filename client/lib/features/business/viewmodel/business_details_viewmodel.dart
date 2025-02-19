import 'package:flutter/material.dart';
import 'package:nexdoor/features/business/models/business_model.dart';
import 'package:nexdoor/features/business/models/services_model.dart';
import 'package:nexdoor/features/business/repositories/business_repository.dart';

class BusinessDetailsViewModel extends ChangeNotifier {
  final BusinessRepository _repository;
  final BusinessModel business;

  String? selectedServiceId;
  String? selectedHour; // Stores the unique key (e.g., 'Tuesday-09:00')
  List<String> availableHours = []; // Flat list of all available hours
  List<String> unavailableHours = []; // Flat list of all unavailable hours
  Map<String, List<String>> groupedHours = {}; // Hours grouped by days
  bool isLoading = false;
  String? errorMessage;

  BusinessDetailsViewModel(this._repository, this.business) {
    if (business.services.isNotEmpty) {
      selectedServiceId = business.services[0].id;
      availableHours = List<String>.from(business.services[0].availableHours);
      initializeHours(business.availableDays??[], availableHours); // Initialize hours
      fetchUnavailableHours();
    }
  }

  // Initialize hours and group them by days
  void initializeHours(List<String> days, List<String> hours) {
    availableHours = hours;
    groupHoursByDays(); // Group hours by days
    notifyListeners();
  }

  // Group available hours by days
  void groupHoursByDays() {
    groupedHours = {};
    int hoursPerDay = availableHours.length ~/ business.availableDays!.length; // Assuming equal hours per day
    for (int i = 0; i < business.availableDays!.length; i++) {
      int startIndex = i * hoursPerDay;
      int endIndex = startIndex + hoursPerDay;
      groupedHours[business.availableDays![i]] = availableHours.sublist(startIndex, endIndex);
    }
    notifyListeners();
  }

  // Fetch unavailable hours for the selected service
  Future<void> fetchUnavailableHours() async {
    if (selectedServiceId == null) return;

    try {
      isLoading = true;
      notifyListeners();

      unavailableHours = await _repository.fetchUnavailableHours(selectedServiceId!);

      isLoading = false;
      errorMessage = null;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to fetch unavailable hours: $e';
      notifyListeners();
    }
  }

  // Select a service
  void selectService(String serviceId) {
    final selectedService = business.services.firstWhere((service) => service.id == serviceId);
    selectedServiceId = serviceId;
    availableHours = List<String>.from(selectedService.availableHours);
    selectedHour = null; // Reset selected hour
    groupHoursByDays(); // Re-group hours by days
    fetchUnavailableHours();
  }

  // Select a time slot (using a unique key like 'Tuesday-09:00')
  void selectHour(String? hour) {
    if (selectedHour == hour) {
      selectedHour = null; // Deselect if already selected
    } else {
      selectedHour = hour; // Select the new hour
    }
    notifyListeners();
  }

  // Book a service
  Future<bool> bookService() async {
    if (selectedServiceId == null || selectedHour == null) {
      errorMessage = 'Please select a service and an available hour';
      notifyListeners();
      return false;
    }

    try {
      isLoading = true;
      notifyListeners();

      final success = await _repository.createBooking(selectedServiceId!, selectedHour!);

      isLoading = false;
      if (success) {
        errorMessage = null;
      } else {
        errorMessage = 'Failed to create booking';
      }
      notifyListeners();
      return success;
    } catch (e) {
      isLoading = false;
      errorMessage = 'Error creating booking: $e';
      notifyListeners();
      return false;
    }
  }

  // Get the selected service
  ServiceModel? get selectedService {
    if (selectedServiceId == null) return null;

    try {
      return business.services.firstWhere(
        (service) => service.id == selectedServiceId,
      );
    } catch (e) {
      return null;
    }
  }

  // Get available hours for a specific day
  List<String> getAvailableHoursForDay(String day) {
    return groupedHours[day] ?? [];
  }

  // Check if a time slot is unavailable
  bool isHourUnavailable(String hour) {
    return unavailableHours.contains(hour);
  }
}