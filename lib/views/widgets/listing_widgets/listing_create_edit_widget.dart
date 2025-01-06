import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/config/app_configuration.dart';
import 'package:waloma/core/model/listing_models/listing_request_model.dart';
import 'package:waloma/core/model/listing_models/listing_response_model.dart';
import 'package:waloma/core/model/user_models/user_login_response_model.dart';
import 'package:waloma/core/services/listing_services/listing_api_services.dart';
import 'package:waloma/core/services/user_auth_services/user_shared_services.dart';
import 'package:waloma/views/widgets/listing_widgets/Success_toast.dart';

class ListingCreateEdit extends StatefulWidget {
  ListingCreateEdit({
    Key? key,
    required GlobalKey<FormBuilderState> formKey,
    required this.maxDescriptionWords,
    this.listing,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormBuilderState> _formKey;
  final int maxDescriptionWords;
  final Listings? listing;
  @override
  State<ListingCreateEdit> createState() => _ListingCreateEditState();
}

class _ListingCreateEditState extends State<ListingCreateEdit> {
  List<String> category = [
    "Home",
    "Car",
    "Job",
    "Scholarship",
    "Bid",
  ];

  String _priceLabel = "Price";
  String? _selectedListingType;

  List<File> _selectedImages = [];
  List<String> _removedImages = [];
  bool _isImageChanged = false;
// Function to handle image selection changes from the image picker
  void _handleImageSelection(
      List<File> newImages, List<String> removedImages, bool isImageChanged) {
    // Handle the updated image state
    print("New images: $newImages");
    print("Removed images: $removedImages");
    print("Is Image Changed: $isImageChanged");

    // Add your custom logic to handle the images here, for example:
    setState(() {
      _selectedImages = newImages; // Update the list of new images
      _removedImages = removedImages; // Track removed images
      _isImageChanged = isImageChanged; // Track if changes were made
    });
  }

  UserLoginResponseModel? user;
  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Set initial selected listing type to trigger conditional fields
    _selectedListingType = widget.listing != null
        ? widget.listing!.listingType.toLowerCase()
        : null;
  }

  // Function to load cached user data from SharedService
  Future<void> _loadUserData() async {
    UserLoginResponseModel? cachedUser =
        await SharedService.loginDetails(); // Get cached user details

    if (cachedUser != null) {
      setState(() {
        user = cachedUser; // Update state with the fetched user data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: widget._formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Listing Type Dropdown with pre-filled value if editing
                FormBuilderDropdown<String>(
                  name: 'listing_type',
                  initialValue: widget.listing != null
                      ? capitalizeFirstLetter(widget.listing!.listingType)
                      : null,
                  decoration: _buildInputDecoration("Listing Type"),
                  items: category
                      .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(capitalizeFirstLetter(type))))
                      .toList(),
                  validator: FormBuilderValidators.required(
                      errorText: "Please select a listing type"),
                  onChanged: (selectedType) {
                    setState(() {
                      _selectedListingType = selectedType?.toLowerCase();
                      _priceLabel = selectedType == "job" ? "Salary" : "Price";
                    });
                  },
                ),

                // Title Field with pre-filled value if editing
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'title',
                  initialValue: widget.listing?.title ?? "",
                  decoration: _buildInputDecoration("Title"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "Title is required"),
                    FormBuilderValidators.maxLength(100,
                        errorText: "Title must be under 100 characters"),
                  ]),
                ),

                // Description Field
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'description',
                  initialValue: widget.listing?.description ?? "",
                  maxLines: 5,
                  decoration: _buildInputDecoration("Description"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "Description is required"),
                    FormBuilderValidators.maxLength(300,
                        errorText: "Description can't exceed 300 characters"),
                  ]),
                ),

                // Price or Salary Field
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'price',
                  initialValue: widget.listing?.price.toString() ?? "",
                  decoration: _buildInputDecoration(_priceLabel),
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "$_priceLabel is required"),
                    FormBuilderValidators.numeric(
                        errorText: "Please enter a valid number"),
                  ]),
                ),

                // Location Field
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'location',
                  initialValue: widget.listing?.location ?? "",
                  decoration: _buildInputDecoration("Location"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "Location is required"),
                  ]),
                ),

                const SizedBox(height: 20),
                // Additional fields for selected listing type
                if (_selectedListingType == null)
                  ..._buildFieldsBasedOnSelection(),
                if (_selectedListingType == "car") ..._buildVehicleFields(),
                if (_selectedListingType == "job") ..._buildJobFields(),
                if (_selectedListingType == "home") ..._buildHomeFields(),
                if (_selectedListingType == "scholarship")
                  ..._buildScholarshipFields(),
                if (_selectedListingType == "bid") ..._buildBiddingFields(),
              ],
            ),
          ),
        ),

        // Submit Button
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.925,
          child: ElevatedButton(
            onPressed: _submitListing,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              primary: AppColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              widget.listing != null ? "Update Listing" : "Post Listing",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelStyle:
          const TextStyle(color: AppColor.primary, fontSize: 18),
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

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input; // Handle empty string
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  // Helper function to populate category-specific details
  Details _populateDetails(Map<String, dynamic>? formData) {
    Details details = Details.fromJson({});

    if (_selectedListingType == "car") {
      details.additionalFields = {
        'make': formData?['make'],
        'model': formData?['model'],
        'year': formData?['year'],
        'color': formData?['color'],
        'interior_color': formData?['interior_color'],
        'condition': formData?['condition'],
        'transmission': formData?['transmission'],
        'vin': formData?['vin'],
        'seats': formData?['seats'],
        'cylinders': formData?['cylinders'],
        'engine_size': formData?['engine_size'],
        'horse_power': formData?['horse_power'],
      };
    } else if (_selectedListingType == "job") {
      details.additionalFields = {
        'posted_by': formData?['posted_by'],
        'job_type': formData?['job_type'],
        'work_setup': formData?['work_setup'],
        'career_level': formData?['career_level'],
        'min_experience': formData?['min_experience'],
        'application_deadline': formData?['application_deadline'] is DateTime
            ? (formData?['application_deadline'] as DateTime).toIso8601String()
            : formData?['application_deadline'],
        'responsibilities': formData?['responsibilities'],
        'requirements': formData?['requirements'],
        'min_qualification': formData?['min_qualification'],
      };
    } else if (_selectedListingType == "home") {
      details.additionalFields = {
        'video_link': formData?['video_link'],
        'address': formData?['address'],
        'condition': formData?['condition'],
        'square_meters': formData?['square_meters'],
        'furnishing': formData?['furnishing'],
      };
    } else if (_selectedListingType == "scholarship") {
      details.additionalFields = {
        'scholarship_type': formData?['scholarship_type'],
        'eligibility': formData?['eligibility'],
        'provider': formData?['provider'],
        'application_deadline': formData?['application_deadline'] is DateTime
            ? (formData?['application_deadline'] as DateTime).toIso8601String()
            : formData?['application_deadline'] ??
                widget.listing?.details['application_deadline'],
        'benefits': formData?['benefits'],
        'duration': formData?['duration'],
      };
    } else if (_selectedListingType == "bid") {
      details.additionalFields = {
        'bidder_type': formData?['bidder_type'],
        'starting_price': formData?['starting_price'],
        'bid_deadline': formData?['bid_deadline'] is DateTime
            ? (formData?['bid_deadline'] as DateTime).toIso8601String()
            : formData?['bid_deadline'],
        'terms_and_conditions': formData?['terms_and_conditions']
      };
    }

    return details;
  }

  void _submitListing() async {
    if (widget._formKey.currentState?.saveAndValidate() ?? false) {
      final formData = widget._formKey.currentState!.value;
      final currentUser = user?.user;

      // Prepare listing data
      final listingData = ListingRequestModel(
        userId: currentUser!.id,
        listingType: formData['listing_type'].toLowerCase(),
        title: formData['title'],
        description: formData['description'],
        location: formData['location'],
        price: int.tryParse(formData['price'] ?? "0"),
        contactNumber: "0987654321",
        details: _populateDetails(formData),
      );

      // Separate retained and new images
      final retainedImages =
          widget.listing?.listingImages ?? []; // Retained images
      final newImages = _selectedImages
          .map((image) => File(image.path))
          .toList(); // Newly added images

      try {
        // Determine whether it's a create or edit operation
        final response = widget.listing == null
            ? await ListingService.createListing(listingData, newImages)
            : await ListingService.updateListing(
                widget.listing!.id,
                listingData,
                newImages,
                retainedImages: retainedImages,
              );

        if (response['success']) {
          // Success: Show a success toast
          final successMessage = widget.listing == null
              ? 'Listing created successfully'
              : 'Listing updated successfully';
          showSuccessToast(context, successMessage);

          // Clear form fields and images if creating a new listing
          if (widget.listing == null) {
            widget._formKey.currentState?.reset();
            setState(() {
              _selectedImages.clear();
            });
          } else {
            // Pass a signal to refresh listings after editing
            Navigator.pop(context, true);
          }
        } else {
          // Error: Show an error toast
          showErrorToast(
              context, response['message'] ?? 'Failed to submit listing');
        }
      } catch (e) {
        // Handle unexpected errors
        if (e is TimeoutException) {
          showTimeoutToast(context);
        } else {
          showErrorToast(
              context, 'An unexpected error occurred. Please try again.');
        }
        print("Error submitting listing: $e");
      }
    }
  }

// Toast functions for success and error
  void showSuccessToast(BuildContext context, String message) {
    showToastWidget(
      IconToastWidget.success(msg: message),
      context: context,
      position: StyledToastPosition.center,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      duration: const Duration(seconds: 4),
      animDuration: const Duration(seconds: 1),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }

  void showErrorToast(BuildContext context, String message) {
    showToast(
      message,
      context: context,
      animation: StyledToastAnimation.slideFromBottomFade,
      reverseAnimation: StyledToastAnimation.slideToBottomFade,
      startOffset: const Offset(0.0, 3.0),
      reverseEndOffset: const Offset(0.0, 3.0),
      position:
          const StyledToastPosition(align: Alignment.bottomCenter, offset: 0.0),
      duration: const Duration(seconds: 4),
      animDuration: const Duration(milliseconds: 400),
      curve: Curves.linearToEaseOut,
      reverseCurve: Curves.fastOutSlowIn,
      backgroundColor: Colors.redAccent,
      textStyle: const TextStyle(color: Colors.white),
    );
  }

  void showTimeoutToast(BuildContext context) {
    showToastWidget(
      IconToastWidget.error(
          msg: "Server is currently unavailable. Please try again later."),
      context: context,
      position: StyledToastPosition.top,
      animation: StyledToastAnimation.slideFromBottom,
      duration: const Duration(seconds: 4),
    );
  }

  List<Widget> _buildFieldsBasedOnSelection() {
    return [];
  }

  // List of fields for vehicles
  List<Widget> _buildVehicleFields() {
    final details = widget.listing?.details;

    return [
      _imagePickerField('vehicles', 2, 10,
          onChanged: _handleImageSelection,
          existingImages: widget.listing?.listingImages ?? []),
      _dropdownField('make', 'Make', ['Toyota', 'Ford', 'BMW'],
          initialValue: details?['make']),
      _dropdownField('model', 'Model', ['Corolla', 'Camry', 'Highlander'],
          initialValue: details?['model']),
      _dropdownField('year', 'Year of Manufacturing',
          List.generate(50, (i) => (2023 - i).toString()),
          initialValue: details?['year']),
      _dropdownField('color', 'Color', ['Black', 'White', 'Silver', 'Blue'],
          initialValue: details?['color']),
      _dropdownField(
          'interior_color', 'Interior Color', ['Black', 'Beige', 'Gray'],
          initialValue: details?['interior_color']),
      _dropdownField('condition', 'Condition', ['New', 'Used', 'Certified'],
          initialValue: details?['condition']),
      _dropdownField('transmission', 'Transmission', ['Automatic', 'Manual'],
          initialValue: details?['transmission']),
      _textField('vin', 'VIN/Chassis Number', "Enter VIN/Chassis number",
          initialValue: details?['vin']),
      _dropdownField('seats', 'Number of Seats', ['2', '4', '5', '7'],
          initialValue: details?['seats']),
      _textField(
          'cylinders', 'Number of Cylinders', "Enter number of cylinders",
          initialValue: details?['cylinders']),
      _textField('engine_size', 'Engine Size', "Enter engine size",
          initialValue: details?['engine_size']),
      _textField('horse_power', 'Horse Power', "Enter horse power",
          initialValue: details?['horse_power']),
    ];
  }

// Repeat similar updates for _buildJobFields, _buildHomeFields, etc.

// Example for _buildJobFields:
  List<Widget> _buildJobFields() {
    final details = widget.listing?.details;

    return [
      _dropdownField('posted_by', 'Job posted by', ['Company', 'Individual'],
          initialValue: details?['posted_by']),
      _dropdownField(
          'job_type',
          'Job Type',
          [
            'Contract',
            'Freelance',
            'Full-time',
            'Internship',
            'Part-time',
            'Temporary'
          ],
          initialValue: details?['job_type']),
      _dropdownField('work_setup', 'Work Setup', ['Hybrid', 'Office', 'Remote'],
          initialValue: details?['work_setup']),
      _dropdownField('career_level', 'Career Level',
          ['Junior', 'Leadership', 'Middle', 'Senior'],
          initialValue: details?['career_level']),
      _dropdownField(
          'min_experience',
          'Minimum Experience',
          [
            '1 year',
            '2 years',
            '3 years',
            '4 years',
            '5 years',
            'Less than 1 year',
            'More than 5 years'
          ],
          initialValue: details?['min_experience']),
      _datePickerField(
          'application_deadline', 'deadline', 'Application Deadline',
          initialDate: details?['application_deadline'] != null
              ? DateTime.parse(details?['application_deadline'])
              : null),
      _textField(
          'responsibilities', 'Responsibilities', "List key responsibilities",
          initialValue: details?['responsibilities'],
          maxLines: 5,
          maxLength: 1000),
      _textField(
          'requirements', 'Requirements & Skills', "List required skills",
          initialValue: details?['requirements'], maxLines: 5, maxLength: 1000),
      _textField('min_qualification', 'Minimum Qualification Requirements',
          "List minimum qualifications",
          initialValue: details?['min_qualification'],
          maxLines: 5,
          maxLength: 1000),
    ];
  }

  // Helper to build Home-specific fields
  List<Widget> _buildHomeFields() {
    final details = widget.listing?.details;
    return [
      _imagePickerField("pick_image", 2, 5,
          onChanged: _handleImageSelection,
          // onChanged: _handleImageSelection,
          existingImages: widget.listing?.listingImages ?? []),
      _textField(
        initialValue: details?['video_link'],
        'video_link',
        'Link to YouTube or Facebook Video',
        'Enter video link',
      ),
      _textField(
        initialValue: details?['address'],
        'address',
        'Address',
        'Enter address',
        maxLength: 50,
      ),
      _dropdownField(
        initialValue: details?['condition'] ?? "",
        'condition',
        'Condition',
        [
          'Fairly Used',
          'Newly-Built',
          'Old',
          'Under construction',
        ],
      ),
      _textField(
        initialValue: details?['square_meters'],
        'square_meters',
        'Square Meters',
        'Enter square meters',
        keyboardType: TextInputType.number,
      ),
      _dropdownField(
        initialValue: details?['furnishing'],
        'furnishing',
        'Furnishing',
        [
          'Furnished',
          'Semi-Furnished',
          'Unfurnished',
        ],
      ),
    ];
  }

// Helper to build Scholarship-specific fields
  List<Widget> _buildScholarshipFields() {
    final details = widget.listing?.details;
    return [
      _textField(
        initialValue: details?['provider'],
        'provider',
        'Scholarship Provider',
        'Enter scholarship provider',
      ),
      _dropdownField(
        initialValue: details?['scholarship_type'],
        'scholarship_type',
        'Type of Scholarship',
        [
          'Undergraduate',
          'Postgraduate',
          'Doctoral',
          'Research',
          'Exchange Program',
        ],
      ),
      _textField(
        initialValue: details?['eligibility'],
        'eligibility',
        'Eligibility Criteria',
        'Describe eligibility requirements',
        maxLines: 3,
      ),
      _datePickerField(
        initialDate: details?['application_deadline'] != null
            ? DateTime.parse(details?['application_deadline'])
            : null,
        'application_deadline',
        'deadline',
        'Application Deadline',
      ),
      _textField(
        initialValue: details?['benefits'],
        'benefits',
        'Benefits ',
        'Describe Benefits',
        maxLines: 3,
      ),
      _textField(
        initialValue: details?['duration'],
        'duration',
        'Duration ',
        'Application Duration',
        maxLines: 3,
      ),
    ];
  }

  List<Widget> _buildBiddingFields() {
    final details = widget.listing?.details;
    return [
      _textField(
        initialValue: details?['starting_price'],
        'starting_price',
        'Bid Starting Price',
        'Enter the starting price',
        keyboardType: TextInputType.number,
      ),
      _datePickerField(
        initialDate: details?['bid_deadline'] != null
            ? DateTime.parse(details?['bid_deadline'])
            : null,
        'bid_deadline',
        'bidDeadline',
        'Bid Deadline',
      ),
      _dropdownField(
        initialValue: details?['bidder_type'],
        'bidder_type',
        'Bidder Type',
        [
          'Individual',
          'Company',
        ],
      ),
      _textField(
        initialValue: details?['terms_and_conditions'],
        'terms_and_conditions',
        'Terms and Conditions',
        'Enter bid terms and conditions',
        maxLines: 5,
      ),
    ];
  }

  // Helper to create Dropdown form field
  Widget _dropdownField(
    String name,
    String label,
    List<String> options, {
    required String? initialValue,
  }) {
    // Ensure the initialValue is valid or fallback to null
    String? validatedInitialValue =
        options.contains(initialValue) ? initialValue : null;

    return Column(
      children: [
        FormBuilderDropdown<String>(
          initialValue: validatedInitialValue,
          name: name,
          decoration: _inputDecoration(label, "Select $label"),
          items: options
              .map((option) =>
                  DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          validator:
              FormBuilderValidators.required(errorText: "$label is required"),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Helper to create Text input form field
  Widget _textField(
    String name,
    String label,
    String hintText, {
    required initialValue,
    TextInputType? keyboardType,
    int maxLines = 1,
    int maxLength = 300,
  }) {
    return Column(
      children: [
        FormBuilderTextField(
          initialValue: initialValue,
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

  // Helper method for consistent InputDecoration styling
  InputDecoration _inputDecoration(String labelText, String hintText) {
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

  // Helper method to create DatePicker form field
  Widget _datePickerField(String name, String hintText, String labelText,
      {required initialDate}) {
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
            initialDate: initialDate,
            initialValue: initialDate,
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

  Widget _imagePickerField(
    String name,
    int minImages,
    int maxImages, {
    required Function(List<File> newImages, List<String> removedImages,
            bool isImageChanged)
        onChanged,
    required List<String> existingImages, // Existing image URLs for editing
  }) {
    List<String> removedImages = [];
    List<String> existingImages = [];
    bool isImageChanged = false;

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
                    child: SvgPicture.asset(
                      'assets/icons/Image.svg',
                      width: 32,
                      height: 32,
                    ),
                  ),
                  title: const Text(
                    'Gallery',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
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
                    child: SvgPicture.asset(
                      'assets/icons/Camera.svg',
                      width: 32,
                      height: 32,
                    ),
                  ),
                  title: const Text(
                    'Camera',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
              ],
            ),
          );
        },
      );

      if (selectedOption != null) {
        final pickedImage = await picker.pickImage(source: selectedOption);
        if (pickedImage != null &&
            field.value!.length + existingImages.length < maxImages) {
          final selectedFile = File(pickedImage.path);
          final updatedImages = [...field.value!, selectedFile];
          field.didChange(updatedImages);
          isImageChanged = true; // Mark as changed
          onChanged(updatedImages, removedImages, isImageChanged);
        }
      }
    }

    String _normalizeImageUrl(String imagePath) {
      if (imagePath.startsWith('http')) {
        return imagePath;
      }
      imagePath =
          imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
      return 'http://${AppConfiguration.apiURL}/$imagePath';
    }

    return FormBuilderField<List<File>>(
      name: name,
      validator: (images) {
        final totalImages = (images?.length ?? 0) + existingImages.length;
        if (totalImages < minImages) {
          return 'Please add at least $minImages photos.';
        } else if (totalImages > maxImages) {
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
                "Add at least $minImages photos",
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
                // Display new selected images
                ...field.value!.map(
                  (image) => Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadiusDirectional.all(
                            Radius.circular(10),
                          ),
                        ),
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
                            isImageChanged = true;
                            onChanged(
                                updatedImages, removedImages, isImageChanged);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Display existing images
                ...existingImages.map(
                  (imageUrl) => Stack(
                    children: [
                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(_normalizeImageUrl(imageUrl)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -10,
                        right: -10,
                        child: IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: () {
                            existingImages.remove(imageUrl);
                            removedImages.add(imageUrl);
                            isImageChanged = true;
                            onChanged(field.value ?? [], removedImages,
                                isImageChanged);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Add Image button
                if (field.value!.length + existingImages.length < maxImages)
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
}
