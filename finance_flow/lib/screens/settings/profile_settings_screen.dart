import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_theme.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/glass_card.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  late TextEditingController _nameController;
  final List<int> _themeColors = [
    0xFF98DA27, // Neon Green
    0xFF7BD0FF, // Sky Blue
    0xFFFFB4AB, // Soft Red
    0xFFCABEFF, // Lavender
    0xFFFFD966, // Saffron
    0xFF80CBC4, // Teal
  ];

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>();
    _nameController = TextEditingController(text: settings.userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      context.read<SettingsProvider>().updateProfile(imagePath: image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile & Settings', style: AppTextStyles.headlineMd),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildProfileImage(settings),
            const SizedBox(height: 32),
            _buildNameInput(settings),
            const SizedBox(height: 40),
            _buildColorPicker(settings),
            const SizedBox(height: 40),
            _buildAppInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(SettingsProvider settings) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: settings.primaryColor, width: 3),
              image: settings.profileImagePath != null
                  ? DecorationImage(
                      image: FileImage(File(settings.profileImagePath!)),
                      fit: BoxFit.cover,
                    )
                  : const DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1000'),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: settings.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.black, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameInput(SettingsProvider settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('YOUR NAME', style: AppTextStyles.labelMd),
        const SizedBox(height: 12),
        TextField(
          controller: _nameController,
          onChanged: (v) => settings.updateProfile(name: v),
          style: AppTextStyles.bodyLg,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceContainer,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            prefixIcon: const Icon(Icons.person_outline),
          ),
        ),
      ],
    );
  }

  Widget _buildColorPicker(SettingsProvider settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ACCENT COLOR', style: AppTextStyles.labelMd),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _themeColors.map((colorValue) {
            final isSelected = settings.primaryColorValue == colorValue;
            return GestureDetector(
              onTap: () => settings.updateProfile(colorValue: colorValue),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Color(colorValue),
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                ),
                child: isSelected ? const Icon(Icons.check, color: Colors.black) : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAppInfo() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('App Version', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('1.0.1', style: AppTextStyles.labelMd.copyWith(color: AppColors.outline)),
        ],
      ),
    );
  }
}
