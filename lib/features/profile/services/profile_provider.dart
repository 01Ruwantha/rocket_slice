import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider extends ChangeNotifier {
  static const String _boxName = 'profile_box';
  late Box _box;

  String _name = 'Guest User';
  String _email = 'Not provided';
  String _phone = 'Not set';
  String _deliveryAddress = 'Add delivery address';
  String? _profileImagePath;
  String _selectedAvatarEmoji = '🚀';

  ProfileProvider() {
    _loadProfileData();
  }

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get deliveryAddress => _deliveryAddress;
  String? get profileImagePath => _profileImagePath;
  String get selectedAvatarEmoji => _selectedAvatarEmoji;

  void _loadProfileData() {
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box(_boxName);
      _name = _box.get('name', defaultValue: 'Guest User');
      _email = _box.get('email', defaultValue: 'Not provided');
      _phone = _box.get('phone', defaultValue: 'Not set');
      _deliveryAddress = _box.get(
        'deliveryAddress',
        defaultValue: 'Add delivery address',
      );
      _profileImagePath = _box.get('profileImagePath');
      _selectedAvatarEmoji = _box.get(
        'selectedAvatarEmoji',
        defaultValue: '🚀',
      );
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String deliveryAddress,
    String? profileImagePath,
    String? avatarEmoji,
  }) async {
    _name = name;
    _email = email;
    _phone = phone;
    _deliveryAddress = deliveryAddress;
    if (profileImagePath != null) {
      _profileImagePath = profileImagePath;
    }
    if (avatarEmoji != null) {
      _selectedAvatarEmoji = avatarEmoji;
    }

    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box(_boxName);
      await _box.put('name', _name);
      await _box.put('email', _email);
      await _box.put('phone', _phone);
      await _box.put('deliveryAddress', _deliveryAddress);
      if (_profileImagePath != null) {
        await _box.put('profileImagePath', _profileImagePath);
      }
      await _box.put('selectedAvatarEmoji', _selectedAvatarEmoji);
    }
    notifyListeners();
  }

  Future<void> pickProfileImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 85,
      );

      if (image != null) {
        _profileImagePath = image.path;
        if (Hive.isBoxOpen(_boxName)) {
          _box = Hive.box(_boxName);
          await _box.put('profileImagePath', _profileImagePath);
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking profile image: $e');
    }
  }

  Future<void> setAvatarEmoji(String emoji) async {
    _selectedAvatarEmoji = emoji;
    _profileImagePath = null; // Clear custom image if emoji selected
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box(_boxName);
      await _box.put('selectedAvatarEmoji', emoji);
      await _box.delete('profileImagePath');
    }
    notifyListeners();
  }
}
