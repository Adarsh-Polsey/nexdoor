import 'package:flutter/material.dart';
import 'package:nexdoor/features/business/models/business_model.dart';
import 'package:nexdoor/features/business/models/services_model.dart';
import 'package:nexdoor/features/business/repositories/business_repository.dart';

class BusinessDetailsViewModel extends ChangeNotifier {
  final BusinessRepository _repository;
  final BusinessModel business;
  
  String? selectedServiceId;
  String? selectedHour;
  List<String> availableHours = [];
  List<String> unavailableHours = [];
  bool isLoading = false;
  String? errorMessage;

  BusinessDetailsViewModel(this._repository, this.business) {
    if (business.services.isNotEmpty) {
      selectedServiceId = business.services[0].id;
      availableHours = List<String>.from(business.services[0].availableHours);
      fetchUnavailableHours();
    }
  }

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

  void selectService(String serviceId) {
    final selectedService = business.services.firstWhere((service) => service.id == serviceId);
    selectedServiceId = serviceId;
    availableHours = List<String>.from(selectedService.availableHours);
    selectedHour = null;
    fetchUnavailableHours();
  }

  void selectHour(String hour) {
    selectedHour = hour;
    notifyListeners();
  }

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
}