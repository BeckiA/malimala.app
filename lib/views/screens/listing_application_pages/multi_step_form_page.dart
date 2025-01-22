import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:waloma/constant/app_color.dart';

class MultiStepFormPage extends StatefulWidget {
  @override
  _MultiStepFormPageState createState() => _MultiStepFormPageState();
}

class _MultiStepFormPageState extends State<MultiStepFormPage> {
  int _currentStep = 0;
  String? phoneNumberValue;

  // Controllers for form fields
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Please fill your personal details',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColor.primary,
            onPrimary: Colors.white,
            surface: AppColor.primary,
          ),
        ),
        child: FormBuilder(
          key: _formKey,
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 2) {
                setState(() => _currentStep++);
              } else {
                _submitForm();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep--);
              }
            },
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (_currentStep != 0)
                      OutlinedButton(
                        onPressed: details.onStepCancel,
                        child: const Text('Previous Step'),
                        style: OutlinedButton.styleFrom(
                          primary: AppColor.primary,
                        ),
                      ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text(_currentStep == 2 ? 'Submit' : 'Next Step'),
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.primary,
                      ),
                    ),
                  ],
                ),
              );
            },
            steps: [
              // Step 1: Personal Details
              Step(
                title: const Text("Step 1"),
                content: Column(
                  children: [
                    _textField(
                      "first_name",
                      "First Name",
                      "Enter your first name",
                      initialValue: "",
                    ),
                    _textField(
                      "last_name",
                      "Last Name",
                      "Enter your last name",
                      initialValue: "",
                    ),
                    _textField(
                      "email",
                      "Email",
                      "Enter your email address",
                      initialValue: "",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _phoneField(),
                  ],
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep > 0 ? StepState.complete : StepState.indexed,
              ),
              // Step 2: Educational Background
              Step(
                title: const Text("Step 2"),
                content: Column(
                  children: [
                    _textField(
                      "degree",
                      "Degree",
                      "Enter your degree",
                      initialValue: "",
                    ),
                    _textField(
                      "institution",
                      "Institution",
                      "Enter your institution name",
                      initialValue: "",
                    ),
                    _datePickerField(
                      "graduation",
                      "Select your graduation year",
                      "Graduation Year",
                      initialDate: DateTime.now(),
                    ),
                    _textField(
                      "gpa",
                      "GPA",
                      "Enter your GPA",
                      initialValue: "",
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                isActive: _currentStep >= 1,
                state:
                    _currentStep > 1 ? StepState.complete : StepState.indexed,
              ),
              // Step 3: Document Uploads
              Step(
                title: const Text("Step 3"),
                content: Column(
                  children: const [
                    Text("Upload CV/Resume"),
                    SizedBox(height: 10),
                    Text("Upload Cover Letter"),
                    SizedBox(height: 10),
                    Text("Upload Additional Documents"),
                  ],
                ),
                isActive: _currentStep >= 2,
                state: StepState.indexed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to create Text input form field
  Widget _textField(
    String name,
    String label,
    String hintText, {
    required String initialValue,
    TextInputType? keyboardType,
    int maxLines = 1,
    int maxLength = 300,
  }) {
    return Column(
      children: [
        FormBuilderTextField(
          name: name,
          initialValue: initialValue,
          keyboardType: keyboardType,
          decoration: _inputDecoration(label, hintText),
          validator: FormBuilderValidators.required(
            errorText: "$label is required",
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Helper method to create DatePicker form field
  Widget _datePickerField(String name, String hintText, String labelText,
      {required DateTime initialDate}) {
    return Column(
      children: [
        FormBuilderDateTimePicker(
          name: name,
          initialValue: initialDate,
          inputType: InputType.date,
          decoration: _inputDecoration(labelText, hintText).copyWith(
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: AppColor.primary,
            ),
          ),
          validator: FormBuilderValidators.required(
            errorText: 'Please select $labelText',
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Helper method to create phone input field
  Widget _phoneField() {
    return IntlPhoneField(
      style: const TextStyle(fontSize: 16.0),
      decoration: _inputDecoration("Phone Number", "Enter your phone number"),
      // initialCountryCode: "ET",
      initialCountryCode: "ET",
      onChanged: (phone) {
        phoneNumberValue = phone.completeNumber;
      },
      validator: (value) {
        if (value == null || value.completeNumber.isEmpty) {
          return 'Please enter your phone number';
        }
        return null;
      },
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

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState?.value;
      print("Form Data: $formData");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Form Submission"),
          content: const Text("Your form has been successfully submitted."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      print("Validation failed");
    }
  }
}
