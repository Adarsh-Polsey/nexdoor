import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexdoor/features/business/models/booking_model.dart';
import 'package:nexdoor/features/business/models/business_model.dart';
import 'package:nexdoor/features/business/models/services_model.dart';
import 'package:nexdoor/features/business/repositories/business_repository.dart';

class BusinessDetailViewModel extends ChangeNotifier {
  final BusinessRepository _businessRepository;
  final BookingRepository _bookingRepository;

  BusinessModel? _business;
  ServicesModel? _selectedService;
  DateTime _selectedDate = DateTime.now();
  List<TimeSlot> _availableTimeSlots = [];
  String? _selectedTimeSlot;
  bool _isLoading = false;
  String? _errorMessage;
  bool _bookingSuccess = false;

  BusinessDetailViewModel({
    required BusinessRepository businessRepository,
    required BookingRepository bookingRepository,
  })  : _businessRepository = businessRepository,
        _bookingRepository = bookingRepository;

  // Getter methods
  BusinessModel? get business => _business;
  ServicesModel? get selectedService => _selectedService;
  DateTime get selectedDate => _selectedDate;
  List<TimeSlot> get availableTimeSlots => _availableTimeSlots;
  String? get selectedTimeSlot => _selectedTimeSlot;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get bookingSuccess => _bookingSuccess;

  // For Provider dependency updates if needed
  void updateRepositories(BusinessRepository businessRepo, BookingRepository bookingRepo) {
    // This method allows the Provider to update the repositories if they change
  }

  Future<void> loadBusinessDetails() async {
    _setLoading(true);
    try {
      _business = await _businessRepository.getBusinessDetails();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load business details: $e');
    } finally {
      _setLoading(false);
    }
  }

  void selectService(ServicesModel service) {
    _selectedService = service;
    _selectedTimeSlot = null;
    generateAvailableTimeSlots();
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    _selectedTimeSlot = null;
    generateAvailableTimeSlots();
    notifyListeners();
  }

  void selectTimeSlot(String timeSlot) {
    _selectedTimeSlot = timeSlot;
    notifyListeners();
  }

  String getDayOfWeek(DateTime date) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    // DateTime.weekday returns 1 for Monday, 2 for Tuesday, etc.
    return days[date.weekday - 1];
  }

  Future<void> generateAvailableTimeSlots() async {
    if (_selectedService == null) return;

    _availableTimeSlots = [];
    
    // Check if service is available on selected day
    final dayOfWeek = getDayOfWeek(_selectedDate);
    if (!_selectedService!.availableDays.contains(dayOfWeek)) {
      _setError('Service not available on $dayOfWeek');
      return;
    }

    // Get existing bookings for this day to check availability
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final bookings = await _bookingRepository.getBusinessBookings(
        _selectedService!.businessId??"",
        dateStr,
      );

      final bookedSlots = <String>{};
      for (var booking in bookings) {
        if (booking.serviceId == _selectedService!.id) {
          bookedSlots.add(booking.startTime);
        }
      }

      // Generate time slots based on service's available hours
      for (var time in _selectedService!.availableHours) {
        final isAvailable = !bookedSlots.contains(time);
        _availableTimeSlots.add(TimeSlot(time: time, isAvailable: isAvailable));
      }

      notifyListeners();
    } catch (e,s) {
      _setError('Failed to load time slots: $e $s');
    }
  }

  Future<void> createBooking() async {
    if (_selectedService == null || _selectedTimeSlot == null) {
      _setError('Please select a service and time slot');
      return;
    }

    _setLoading(true);
    _bookingSuccess = false;
    
    try {
      // Calculate end time based on service duration
      final startTime = _selectedTimeSlot!;
      final startHour = int.parse(startTime.split(':')[0]);
      final startMinute = int.parse(startTime.split(':')[1]);
      
      final endDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        startHour,
        startMinute,
      ).add(Duration(minutes: _selectedService!.duration));
      
      final endTime = '${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}';
      
      final booking = BookingModel(
        serviceId: _selectedService!.id,
        businessId: _selectedService!.businessId,
        bookingDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
        startTime: startTime,
        endTime: endTime,
        status: 'pending',
      );

      await _bookingRepository.createBooking(booking);
      _bookingSuccess = true;
      notifyListeners();
    } catch (e) {
      _setError('Failed to create booking: $e');
    } finally {
      _setLoading(false);
    }
  }

  void resetBookingState() {
    _bookingSuccess = false;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
}