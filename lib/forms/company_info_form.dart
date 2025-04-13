import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_dev/models/business_profile.dart';
import 'package:app_dev/auth/eval.dart';
import 'package:uuid/uuid.dart';

import '../auth/eval.dart';
import '../models/business_profile.dart';

class CompanyInfoForm extends StatefulWidget {
  final BusinessProfile businessProfile;
  final VoidCallback onNext;

  const CompanyInfoForm({
    super.key,
    required this.businessProfile,
    required this.onNext,
  });

  @override
  State<CompanyInfoForm> createState() => _CompanyInfoFormState();
}

class _CompanyInfoFormState extends State<CompanyInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _addressController = TextEditingController();
  File? _selectedImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _companyNameController.text = widget.businessProfile.companyName;
    _addressController.text = widget.businessProfile.address;
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      // Upload image to Supabase Storage
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final fileExtension = _selectedImage!.path.split('.').last;
      final fileName = '${const Uuid().v4()}.$fileExtension';

      final bytes = await _selectedImage!.readAsBytes();

      await supabase.storage.from('company_logos').uploadBinary(
        fileName,
        bytes,
      );

      final imageUrl = supabase.storage.from('company_logos').getPublicUrl(fileName);

      widget.businessProfile.photoUrl = imageUrl;

    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.businessProfile.companyName = _companyNameController.text;
      widget.businessProfile.address = _addressController.text;
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Company Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Company Logo
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(75),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: _isUploading
                        ? const CircularProgressIndicator()
                        : _selectedImage != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: Image.file(
                        _selectedImage!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Add Photo',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Company Name
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your company name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your company address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Next Button
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
