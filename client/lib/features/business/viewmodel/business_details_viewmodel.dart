import 'package:flutter/material.dart';
import 'package:nexdoor/features/business/models/business_model.dart';
import 'package:nexdoor/features/business/models/services_model.dart';
import 'package:nexdoor/features/business/repositories/business_repository.dart';

class BusinessDetailsViewModel extends ChangeNotifier {
  final BusinessRepository _repository;
  final BusinessModel business;

  // State variables
  String? _selectedServiceId;
  String? _selectedHour;
  List<String> _availableHours = [];
  List<String> _unavailableHours = [];
  Map<String, List<String>> _groupedHours = {};

  // Booking state
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _selectedDate;
  List<DateTime> _availableDates = [];

  // Getters
  String? get selectedServiceId => _selectedServiceId;
  String? get selectedHour => _selectedHour;
  List<String> get availableHours => _availableHours;
  List<String> get unavailableHours => _unavailableHours;
  Map<String, List<String>> get groupedHours => _groupedHours;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get selectedDate => _selectedDate;
  List<DateTime> get availableDates => _availableDates;

  BusinessDetailsViewModel(this._repository, this.business) {
    _initializeViewModel();
  }

  Future<void> fetchAvailableTimeSlots() async {
    if (_selectedServiceId == null) {
      _errorMessage = 'No service selected';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      // Fetch available hours for the selected service
      _availableHours =
          await _repository.fetchAvailableHours(_selectedServiceId!);

      // Group hours by days
      _groupHoursByDays();

      // Fetch unavailable hours
      await _fetchUnavailableHours();

      // Fetch available dates
      await _fetchAvailableDates();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to fetch available time slots: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchAvailableDates() async {
    try {
      _availableDates =
          await _repository.fetchAvailableDates(_selectedServiceId!);
    } catch (e) {
      _errorMessage = 'Failed to fetch available dates';
      _availableDates = _generateDefaultAvailableDates();
    }
    notifyListeners();
  }

  List<DateTime> _generateDefaultAvailableDates() {
    final now = DateTime.now();
    return List.generate(30, (index) => now.add(Duration(days: index)))
        .where((date) {
      // Exclude weekends or add any other filtering logic
      return date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday;
    }).toList();
  }

  void _initializeViewModel() {
    if (business.services.isNotEmpty) {
      _selectedServiceId = business.services.first.id;
      _availableHours =
          List<String>.from(business.services.first.availableHours);
      _initializeHours(business.availableDays, _availableHours);
      fetchAvailableTimeSlots();
    }
  }

  void _initializeHours(List<String>? days, List<String> hours) {
    _availableHours = hours;
    if (days != null && days.isNotEmpty) {
      _groupHoursByDays();
    }
    notifyListeners();
  }

  void _groupHoursByDays() {
    _groupedHours = {};
    for (var hour in _availableHours) {
      var split = hour.split('-');
      if (split.length == 2) {
        String day = split[0];
        _groupedHours.putIfAbsent(day, () => []).add(split[1]);
      }
    }
    notifyListeners();
  }

  Future<void> _fetchUnavailableHours() async {
    if (_selectedServiceId == null) return;

    try {
      _unavailableHours =
          await _repository.fetchUnavailableHours(_selectedServiceId!);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Could not fetch unavailable hours. Try again.';
    }
    notifyListeners();
  }

  Future<void> selectService(String serviceId) async {
    final selectedService =
        business.services.firstWhere((service) => service.id == serviceId);
    _selectedServiceId = serviceId;
    _availableHours = List<String>.from(selectedService.availableHours);
    _selectedHour = null;
    _selectedDate = null;

    _groupHoursByDays();
    await fetchAvailableTimeSlots();
  }

  void selectHour(String? hour) {
    _selectedHour = (_selectedHour == hour) ? null : hour;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<bool> bookService() async {
    // Comprehensive validation
    if (!_validateBooking()) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final bookingDetails = {
        'serviceId': _selectedServiceId,
        'hour': _selectedHour,
        'date': _selectedDate,
      };

      final success = await _repository.createBooking(bookingDetails);

      if (success) {
        _resetBookingState();
      } else {
        _errorMessage = 'Booking failed. Please try again.';
      }

      return success;
    } catch (e) {
      _errorMessage = 'Error creating booking: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _validateBooking() {
    if (_selectedServiceId == null) {
      _errorMessage = 'Please select a service';
      notifyListeners();
      return false;
    }

    if (_selectedHour == null) {
      _errorMessage = 'Please select an available hour';
      notifyListeners();
      return false;
    }

    if (_selectedDate == null) {
      _errorMessage = 'Please select a date';
      notifyListeners();
      return false;
    }

    return true;
  }

  void _resetBookingState() {
    _selectedServiceId = null;
    _selectedHour = null;
    _selectedDate = null;
    _errorMessage = null;
    _availableHours.clear();
    _unavailableHours.clear();
    _groupedHours.clear();
  }

  ServiceModel? get selectedService {
    try {
      return business.services.firstWhere(
        (service) => service.id == _selectedServiceId,
      );
    } catch (e) {
      return null;
    }
  }

  List<String> getAvailableHoursForDay(String day) {
    return _groupedHours[day] ?? [];
  }

  bool isHourUnavailable(String hour) {
    return _unavailableHours.contains(hour);
  }

  bool get isBookingValid {
    return _selectedServiceId != null &&
        _selectedHour != null &&
        _selectedDate != null;
  }

  void resetBooking() {
    // Reset all booking-related state variables
    _selectedServiceId = null;
    _selectedHour = null;
    _selectedDate = null;
    _errorMessage = null;

    // Clear available and unavailable hours
    _availableHours.clear();
    _unavailableHours.clear();
    _groupedHours.clear();
    _availableDates.clear();

    // If there are services, reinitialize with the first service
    if (business.services.isNotEmpty) {
      _selectedServiceId = business.services.first.id;
      _availableHours =
          List<String>.from(business.services.first.availableHours);
      _initializeHours(business.availableDays, _availableHours);

      // Fetch new time slots
      fetchAvailableTimeSlots();
    }

    // Notify listeners of the state change
    notifyListeners();
  }

  // Alternative method if you want to reset to a specific service
  void resetBookingForService(String serviceId) {
    _selectedServiceId = serviceId;
    _selectedHour = null;
    _selectedDate = null;
    _errorMessage = null;

    // Clear previous data
    _availableHours.clear();
    _unavailableHours.clear();
    _groupedHours.clear();
    _availableDates.clear();

    // Find the service and initialize
    final selectedService = business.services.firstWhere(
      (service) => service.id == serviceId,
      orElse: () => business.services.first,
    );

    _availableHours = List<String>.from(selectedService.availableHours);
    _initializeHours(business.availableDays, _availableHours);

    // Fetch new time slots
    fetchAvailableTimeSlots();

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
