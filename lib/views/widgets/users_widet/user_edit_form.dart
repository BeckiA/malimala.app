import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/model/user_models/user_registration_request_model.dart';
import 'package:waloma/core/services/user_auth_services/user_api_services.dart';
import 'package:waloma/core/services/user_auth_services/user_shared_services.dart';
import 'package:waloma/views/screens/waloma_success_page.dart';

class EditUserProfileForm extends StatefulWidget {
  const EditUserProfileForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditUserProfileFormState createState() => _EditUserProfileFormState();
}

class _EditUserProfileFormState extends State<EditUserProfileForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, String> _errors = {};
  int? _id;
  String? firstName = '';
  String? lastName = '';
  String? phoneNumberValue = '';
  String? username = '';
  String? email = '';
  String? password = '';
  String? userType = '';
  bool _userTypeHasError = true;
  List<String> userTypeLists = ["job_seeker", "broker", "admin", "employer"];
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final response = await SharedService.loginDetails();

    if (response?.success == true) {
      setState(() {
        _id = response?.user!.id;
        firstName = response?.user!.firstName;
        lastName = response?.user!.lastName;
        username = response?.user!.username;
        email = response?.user!.email;
        phoneNumberValue = response?.user!.phoneNumber;
        userType = response?.user!.userType;
        _isLoading = false; // Loading complete
      });
    } else {
      setState(() {
        _errors = response!.success == false
            ? {"error": "Unable to fetch user data"}
            : {};
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Display a loading indicator while fetching user data
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return FormBuilder(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // First Name Field
          FormBuilderTextField(
            name: 'first_name',
            initialValue: firstName, // Pre-fill with user's first name
            decoration: InputDecoration(
              hintText: 'First Name',
              errorText: _errors['first_name'],
              prefixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/Profile.svg',
                    color: AppColor.primary),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.border, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.primary, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: AppColor.primarySoft,
              filled: true,
            ),
            validator: (onValidateVal) {
              if (onValidateVal == null || onValidateVal.isEmpty) {
                return 'First Name can\'t be empty.';
              }
              return null;
            },
            onSaved: (onSavedVal) {
              firstName = onSavedVal ?? '';
            },
          ),

          const SizedBox(height: 16),

          // Last Name Field
          FormBuilderTextField(
            name: 'last_name',
            initialValue: lastName, // Pre-fill with user's last name
            decoration: InputDecoration(
              hintText: 'Last Name',
              errorText: _errors['last_name'],
              prefixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/Profile.svg',
                    color: AppColor.primary),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.border, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.primary, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: AppColor.primarySoft,
              filled: true,
            ),
            validator: (onValidateVal) {
              if (onValidateVal == null || onValidateVal.isEmpty) {
                return 'Last Name can\'t be empty.';
              }
              return null;
            },
            onSaved: (onSavedVal) {
              lastName = onSavedVal ?? '';
            },
          ),

          const SizedBox(height: 16),

          IntlPhoneField(
            style: const TextStyle(fontSize: 16.0),
            initialValue: phoneNumberValue, // Pre-fill phone number
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: 'Phone Number',
              errorText: _errors['phone_number'],
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.border, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.primary, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: AppColor.primarySoft,
              filled: true,
              counterText: "",
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            initialCountryCode: "ET",
            onChanged: (phone) {
              phoneNumberValue = phone.completeNumber;
            },
            validator: (value) {
              if (value == null || value.completeNumber.isEmpty) {
                return 'Please enter your phone number';
              }
              if (!value.isValidNumber()) {
                return 'Please enter a valid phone number';
              }
              if (value.completeNumber.length < 9) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // User Type Dropdown
          FormBuilderDropdown<String>(
            name: 'userType',
            initialValue: userType, // Pre-fill user type
            decoration: InputDecoration(
              hintText: 'Select User Type',
              errorText: _errors['user_type'],
              prefixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/Users.svg',
                    color: AppColor.primary),
              ),
              suffixIcon: _userTypeHasError
                  ? const Icon(Icons.error, color: Colors.red)
                  : const Icon(Icons.check, color: Colors.green),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.border, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.primary, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: AppColor.primarySoft,
              filled: true,
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                  errorText: "User type can't be empty"),
            ]),
            items: userTypeLists
                .map((users) => DropdownMenuItem(
                      alignment: AlignmentDirectional.center,
                      value: users,
                      child: Text(users),
                    ))
                .toList(),
            onChanged: (val) {
              setState(() {
                _userTypeHasError =
                    !(_formKey.currentState?.fields['userType']?.validate() ??
                        false);
                userType = val;
              });
            },
          ),

          const SizedBox(height: 24),

          // Update Profile Button
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _errors = {};
              });
              if (validateAndSave()) {
                print("I'm WORKING");
                UserRegistrationRequestModel model =
                    UserRegistrationRequestModel(
                  firstName: firstName,
                  lastName: lastName,
                  userType: userType,
                  username: username,
                  email: email,
                  phoneNumber: phoneNumberValue,
                );

                UserAPIService.updateUserProfile(_id!.toInt(), model)
                    .then((response) async {
                  print("THIS ONE $response");
                  if (response['success']) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WalomaSuccessPage(
                                headLineTitle: 'Update Profile Success!',
                                subHeadlineTitle:
                                    'You\'ve updated your profile successfully, You can repeat this action anytime',
                              )),
                    );
                  } else {
                    setState(() {
                      _errors = response['errors'] ??
                          {}; // Safely handle empty or null errors
                    });
                  }
                });
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
              primary: AppColor.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: const Text(
              'Update Profile',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  fontFamily: 'poppins'),
            ),
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
