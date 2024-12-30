import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waloma/constant/app_color.dart';

class ListingsHelper {
  static Widget imagePickerField(
    String name,
    int minImages,
    int maxImages,
    BuildContext context, {
    required Function(List<File>) onChanged,
  }) {
    Future<void> _showImageSourceActionSheet(
      BuildContext context,
      FormFieldState<List<File>> field,
    ) async {
      final picker = ImagePicker();
      final selectedOption = await showModalBottomSheet<ImageSource>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Wrap(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColor.primarySoft,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset('assets/icons/Image.svg',
                        width: 32, height: 32),
                  ),
                  title: const Text('Gallery',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColor.primarySoft,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset('assets/icons/Camera.svg',
                        width: 32, height: 32),
                  ),
                  title: const Text('Camera',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
              ],
            ),
          );
        },
      );

      if (selectedOption != null) {
        final pickedImage = await picker.pickImage(source: selectedOption);
        if (pickedImage != null && field.value!.length < maxImages) {
          // Convert XFile to File for further processing
          final selectedFile = File(pickedImage.path);
          final updatedImages = [...field.value!, selectedFile];
          field.didChange(updatedImages);
          onChanged(updatedImages);
        }
      }
    }

    return FormBuilderField<List<File>>(
      name: name,
      validator: (images) {
        if (images == null || images.length < minImages) {
          return 'Please add at least $minImages photos.';
        } else if (images.length > maxImages) {
          return 'You can only add up to $maxImages photos.';
        }
        return null;
      },
      initialValue: [],
      builder: (FormFieldState<List<File>> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Add at least 2 photos",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                // Display current selected images
                ...field.value!.map(
                  (image) => Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadiusDirectional.all(
                                Radius.circular(10))),
                        child: Image.file(
                          image,
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: -10,
                        right: -10,
                        child: IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: () {
                            final updatedImages = List<File>.from(field.value!)
                              ..remove(image);
                            field.didChange(updatedImages);
                            onChanged(updatedImages);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Add Image button with the SVG icon
                if (field.value!.length < maxImages)
                  GestureDetector(
                    onTap: () => _showImageSourceActionSheet(context, field),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColor.primarySoft,
                        borderRadius: BorderRadiusDirectional.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: SizedBox(
                        width: 75,
                        height: 75,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/Add.svg',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  // Helper method to create DatePicker form field
  static Widget datePickerField(
      String name, String hintText, String labelText, BuildContext context) {
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogTheme(
              backgroundColor:
                  AppColor.primarySoft, // Your custom background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            colorScheme: const ColorScheme.light(
              primary: AppColor.primary, // Color for selected date and header
              onPrimary: Colors.white, // Color for text in header
              onSurface: Colors.black, // Color for dates
            ),
          ),
          child: FormBuilderDateTimePicker(
            name: name,
            inputType: InputType.date,
            decoration: _inputDecoration(
              labelText,
              hintText,
            ).copyWith(
              suffixIcon: const Icon(
                Icons.calendar_today,
                color: AppColor.primary,
              ),
            ),
            style: const TextStyle(color: AppColor.primary),
            initialEntryMode: DatePickerEntryMode.calendar,
            validator: FormBuilderValidators.required(
              errorText: 'Please select $labelText',
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Helper method for consistent InputDecoration styling
  static InputDecoration _inputDecoration(String labelText, String hintText) {
    return InputDecoration(
      labelText: labelText,
      floatingLabelStyle:
          const TextStyle(color: AppColor.primary, fontSize: 18),
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      fillColor: AppColor.primarySoft,
      filled: true,
    );
  }

  // Helper to create Dropdown form field
  static Widget dropdownField(
      String name, String label, List<String> options, onchanged) {
    return Column(
      children: [
        FormBuilderDropdown<String>(
          name: name,
          decoration: _inputDecoration(label, "Select $label"),
          items: options
              .map((option) =>
                  DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          validator:
              FormBuilderValidators.required(errorText: "$label is required"),
          onChanged: onchanged,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Helper to create Text input form field
  static Widget textField(
    String name,
    String label,
    String hintText, {
    TextInputType? keyboardType,
    int maxLines = 1,
    int maxLength = 300,
  }) {
    return Column(
      children: [
        FormBuilderTextField(
          keyboardType: keyboardType,
          name: name,
          decoration: _inputDecoration(label, hintText),
          validator:
              FormBuilderValidators.required(errorText: "$label is required"),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
