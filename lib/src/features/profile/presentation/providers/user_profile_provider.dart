import 'package:flutter/foundation.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/user_profile.dart';
import '../../../onboarding/domain/onboarding_state.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfile _userProfile;
  final StorageService _storageService = StorageService();

  UserProfileProvider() : _userProfile = UserProfile(
    birthday: DateTime(1995, 1, 1), // Default fallback
  ) {
    _loadFromStorage();
  }

  UserProfile get userProfile => _userProfile;

  Future<void> _loadFromStorage() async {
    try {
      final savedProfile = await _storageService.loadUserProfile();
      if (savedProfile != null) {
        _userProfile = savedProfile;
        notifyListeners();
      }
    } catch (e) {
      // 静默处理错误，使用默认值
    }
  }

  Future<void> updateUserProfile(UserProfile newProfile) async {
    _userProfile = newProfile;
    notifyListeners();
    // Save to storage
    await _storageService.saveUserProfile(newProfile);
  }

  Future<void> updateFromOnboarding(OnboardingState state) async {
    _userProfile = UserProfile.fromOnboardingState(state);
    notifyListeners();
    // Save to storage
    await _storageService.saveUserProfile(_userProfile);
  }

  // Initialize with saved profile
  static Future<UserProfileProvider> initialize() async {
    final provider = UserProfileProvider();
    await provider._loadFromStorage();
    return provider;
  }
}
