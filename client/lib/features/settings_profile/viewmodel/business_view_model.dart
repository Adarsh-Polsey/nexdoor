import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:nexdoor/features/business/models/business_model.dart';
import 'package:nexdoor/features/settings_profile/repositories/create_business_repository.dart';

class BusinessViewModel extends ChangeNotifier {
  final CreateBusinessRepository _repository;

  BusinessViewModel(this._repository);

  // State variables
  List<BusinessModel> _businesses = [];
  BusinessModel? _currentBusiness;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<BusinessModel> get businesses => _businesses;
  BusinessModel? get currentBusiness => _currentBusiness;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch user's businesses
  Future<void> fetchUserBusinesses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentBusiness = await _repository.fetchUserBusiness();
      if (_currentBusiness == null) {
        _errorMessage = 'No businesses found';
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch businesses: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch a specific business by ID
  Future<void> fetchBusinessById(String? businessId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentBusiness = await _repository.getBusinessById(businessId);

      if (_currentBusiness == null) {
        _errorMessage = 'Business not found';
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch business: $e';
      log(_errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new business
  Future<bool> createBusiness(BusinessModel business) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Validate business data
      if (!_validateBusinessData(business)) {
        return false;
      }

      final createdBusiness = await _repository.createBusiness(business);

      if (createdBusiness != null) {
        _businesses.add(createdBusiness);
        _currentBusiness = createdBusiness;
        return true;
      }

      _errorMessage = 'Failed to create business';
      return false;
    } catch (e) {
      _errorMessage = 'Error creating business: $e';
      log(_errorMessage!);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an existing business
  Future<bool> updateBusiness(BusinessModel business) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Validate business data
      if (!_validateBusinessData(business)) {
        return false;
      }

      final updatedBusiness = await _repository.updateBusiness(business);

      if (updatedBusiness != null) {
        // Update business in the list
        final index = _businesses.indexWhere((b) => b.id == business.id);
        if (index != -1) {
          _businesses[index] = updatedBusiness;
        }

        _currentBusiness = updatedBusiness;
        return true;
      }
      _errorMessage = 'Failed to update business';
      return false;
    } catch (e) {
      _errorMessage = 'Error updating business: $e';
      log(_errorMessage!);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete a business
  Future<bool> deleteBusiness(String businessId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.deleteBusiness(businessId);

      if (success) {
        // Remove business from the list
        _businesses.removeWhere((b) => b.id == businessId);

        // Reset current business if it was the deleted one
        if (_currentBusiness?.id == businessId) {
          _currentBusiness = null;
        }

        return true;
      }

      _errorMessage = 'Failed to delete business';
      return false;
    } catch (e) {
      _errorMessage = 'Error deleting business: $e';
      log(_errorMessage!);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Validate business data
  bool _validateBusinessData(BusinessModel business) {
    if (business.name.isEmpty) {
      _errorMessage = 'Business name is required';
      notifyListeners();
      return false;
    }

    if (business.category.isEmpty) {
      _errorMessage = 'Business category is required';
      notifyListeners();
      return false;
    }

    if (business.businessType.isEmpty) {
      _errorMessage = 'Business type is required';
      notifyListeners();
      return false;
    }

    if (business.location.isEmpty) {
      _errorMessage = 'Business location is required';
      notifyListeners();
      return false;
    }

    return true;
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Reset current business
  void resetCurrentBusiness() {
    _currentBusiness = null;
    notifyListeners();
  }
}
