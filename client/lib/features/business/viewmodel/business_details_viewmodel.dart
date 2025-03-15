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
      initializeHours(business.availableDays, availableHours);
      fetchUnavailableHours();
    }
  }

  // Initialize hours and group them by days
  void initializeHours(List<String>? days, List<String> hours) {
    availableHours = hours;
    if (days != null && days.isNotEmpty) {
      groupHoursByDays();
    }
    notifyListeners();
  }

  // Group available hours by days
  void groupHoursByDays() {
    groupedHours = {};
    for (var hour in availableHours) {
      var split = hour.split('-'); // Assuming format like 'Tuesday-09:00'
      if (split.length == 2) {
        String day = split[0];
        groupedHours.putIfAbsent(day, () => []).add(split[1]); // Store only the time
      }
    }
    notifyListeners();
  }

  // Fetch unavailable hours for the selected service
  Future<void> fetchUnavailableHours() async {
    if (selectedServiceId == null) return;

    isLoading = true;
    notifyListeners();

    try {
      unavailableHours = await _repository.fetchUnavailableHours(selectedServiceId!);
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Could not fetch unavailable hours. Try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Select a service
  Future<void> selectService(String serviceId) async {
    final selectedService = business.services.firstWhere((service) => service.id == serviceId);
    selectedServiceId = serviceId;
    availableHours = List<String>.from(selectedService.availableHours);
    selectedHour = null;

    groupHoursByDays();
    await fetchUnavailableHours();
  }

  // Select a time slot (using a unique key like 'Tuesday-09:00')
  void selectHour(String? hour) {
    selectedHour = (selectedHour == hour) ? null : hour;
    notifyListeners();
  }

  // Book a service
  Future<bool> bookService() async {
    if (selectedServiceId == null || selectedHour == null) {
      errorMessage = 'Please select a service and an available hour';
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final success = await _repository.createBooking(selectedServiceId!, selectedHour!);
      errorMessage = success ? null : 'Failed to create booking';
      return success;
    } catch (e) {
      errorMessage = 'Error creating booking: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Get the selected service
  ServiceModel? get selectedService {
    return business.services.firstWhere(
      (service) => service.id == selectedServiceId,
    );
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
