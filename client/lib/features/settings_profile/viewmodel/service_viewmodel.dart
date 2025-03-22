import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:nexdoor/features/business/models/services_model.dart';
import 'package:nexdoor/features/settings_profile/repositories/create_service_repository.dart';

class ServiceViewModel extends ChangeNotifier {
  final CreateServiceRepository _repository;

  ServiceViewModel(this._repository);
  // State variables
  List<ServicesModel> _services = [];
  ServicesModel? _currentService;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ServicesModel> get services => _services;
  ServicesModel? get currentService => _currentService;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

   // Get current service
  Future<ServicesModel?> getUserService({bool forceRefresh = false}) async {
    // If current service is already set and not forcing refresh, return it
    if (_currentService != null && !forceRefresh) {
      return _currentService;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentService ??= await _repository.fetchUserService();

      // If services exist, set the first one as current
      if (_services.isNotEmpty) {
        _currentService = _services.first;
        return _currentService;
      }

      // If no services found
      _errorMessage = 'No services found';
      return null;
    } catch (e) {
      _errorMessage = 'Failed to fetch current service: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  

  // Fetch services for a specific business
  Future<void> fetchBusinessServices(String businessId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _services = await _repository.fetchBusinessServices(businessId);
      
      if (_services.isNotEmpty) {
        _currentService = _services.first;
      } else {
        _currentService = null;
        _errorMessage = 'No services found';
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch services: $e';
      log(_errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch a service by ID
  Future<ServicesModel?> fetchServiceById(String serviceId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final service = await _repository.getServiceById(serviceId);
      
      if (service != null) {
        _currentService = service;
        
        return _currentService;
      }

      _errorMessage = 'Service not found';
      return null;
    } catch (e) {
      _errorMessage = 'Failed to fetch service: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new service
  Future<bool> createService(ServicesModel service) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final createdService = await _repository.createService(service);
      
      if (createdService != null) {
        _currentService = createdService;
        _services.add(createdService);
        return true;
      }

      _errorMessage = 'Failed to create service';
      return false;
    } catch (e) {
      _errorMessage = 'Error creating service: $e';
      log(_errorMessage!);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an existing service
  Future<bool> updateService(ServicesModel service) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedService = await _repository.updateService(service);
      
      if (updatedService != null) {
        // Update service in the list
        final index = _services.indexWhere((s) => s.id == service.id);
        if (index != -1) {
          _services[index] = updatedService;
        }
        
        _currentService = updatedService;
        return true;
      }

      _errorMessage = 'Failed to update service';
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update service: $e';
      log(_errorMessage!);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete a service
  Future<bool> deleteService(String serviceId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.deleteService(serviceId);
      
      if (success) {
        // Remove the service from the list
        _services.removeWhere((service) => service.id == serviceId);
        
        // Reset current service if it was the deleted one
        if (_currentService?.id == serviceId) {
          _currentService = null;
        }
        
        return true;
      }

      _errorMessage = 'Failed to delete service';
      return false;
    } catch (e) {
      _errorMessage = 'Failed to delete service: $e';
      log(_errorMessage!);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search services
  Future<void> searchServices({
    String? query,
    String? businessId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _services = await _repository.searchServices(
        query: query,
        businessId: businessId,
      );
      
      if (_services.isNotEmpty) {
        _currentService = _services.first;
      } else {
        _currentService = null;
        _errorMessage = 'No services found';
      }
    } catch (e) {
      _errorMessage = 'Error searching services: $e';
      log(_errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Utility methods
  void setCurrentService(ServicesModel service) {
    _currentService = service;
    
    // Add to services list if not already present
    if (!_services.any((s) => s.id == service.id)) {
      _services.add(service);
    }
    
    notifyListeners();
  }

  void clearCurrentService() {
    _currentService = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void resetState() {
    _services = [];
    _currentService = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}