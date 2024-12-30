// import 'package:flutter/material.dart';
// import 'package:waloma/helpers/listing_widget_constructor.dart';

// class ListingDetailsMake {
//   static List<Widget> buildBasicFields() {
//     return [
//       // Dropdown for Listing Type
//       ListingsHelper.dropdownField("listing_type", "Listing Type",
//           ["Vehicle", "Job", "Home", "Scholarship", "Bid"]),
//       const SizedBox(height: 20),
//       ListingsHelper.textField("title", "Title", "Enter Listing Title",
//           maxLength: 100),
//       const SizedBox(height: 20),
//       ListingsHelper.textField(
//           "description", "Description", "Enter Listing Description",
//           maxLength: 300, keyboardType: TextInputType.multiline),
//       const SizedBox(height: 20),
//       ListingsHelper.textField("location", "Location", "Enter Location"),
//       const SizedBox(height: 20),
//       ListingsHelper.textField("price", "Price", "Enter Price",
//           keyboardType: TextInputType.number),
//       const SizedBox(height: 20),
//     ];
//   }

//   static List<Widget> buildFieldsBasedOnSelection() {
//     return [];
//   }

//   // List of fields for vehicles
//   static List<Widget> buildVehicleFields(
//       BuildContext context, handleImageSelection) {
//     return [
//       ListingsHelper.imagePickerField('vehicles', 2, 10, context,
//           onChanged: ((p0) => handleImageSelection)),
//       ListingsHelper.dropdownField('make', 'Make', ['Toyota', 'Ford', 'BMW']),
//       ListingsHelper.dropdownField(
//           'model', 'Model', ['Corolla', 'Camry', 'Highlander']),
//       ListingsHelper.dropdownField('year', 'Year of Manufacturing',
//           List.generate(50, (i) => (2023 - i).toString())),
//       ListingsHelper.dropdownField(
//           'color', 'Color', ['Black', 'White', 'Silver', 'Blue']),
//       ListingsHelper.dropdownField(
//           'interiorColor', 'Interior Color', ['Black', 'Beige', 'Gray']),
//       ListingsHelper.dropdownField(
//           'condition', 'Condition', ['New', 'Used', 'Certified']),
//       ListingsHelper.dropdownField(
//           'transmission', 'Transmission', ['Automatic', 'Manual']),
//       ListingsHelper.textField(
//           'vin', 'VIN/Chassis Number', "Enter VIN/Chassis number"),
//       ListingsHelper.dropdownField(
//           'seats', 'Number of Seats', ['2', '4', '5', '7']),
//       ListingsHelper.textField(
//           'cylinders', 'Number of Cylinders', "Enter number of cylinders"),
//       ListingsHelper.textField(
//           'engineSize', 'Engine Size', "Enter engine size"),
//       ListingsHelper.textField(
//           'horsePower', 'Horse Power', "Enter horse power"),
//     ];
//   }

//   // Helper to build Job-specific fields
//   static List<Widget> buildJobFields() {
//     return [
//       ListingsHelper.dropdownField(
//           'jobPostedBy', 'Job posted by', ['Company', 'Individual']),
//       ListingsHelper.dropdownField('jobType', 'Job Type', [
//         'Contract',
//         'Freelance',
//         'Full-time',
//         'Internship',
//         'Part-time',
//         'Temporary',
//       ]),
//       ListingsHelper.dropdownField('workSetup', 'Work Setup', [
//         'Hybrid',
//         'Office',
//         'Remote',
//       ]),
//       ListingsHelper.dropdownField('careerLevel', 'Career Level', [
//         'Junior',
//         'Leadership',
//         'Middle',
//         'Senior',
//       ]),
//       ListingsHelper.dropdownField('experience', 'Minimum Experience', [
//         '1 year',
//         '2 years',
//         '3 years',
//         '4 years',
//         '5 years',
//         'Less than 1 year',
//         'More than 5 years',
//       ]),
//       ListingsHelper.textField('applicationDeadline', 'Application Deadline',
//           "Enter application deadline"),
//       ListingsHelper.textField(
//         'responsibilities',
//         'Responsibilities',
//         "List key responsibilities",
//         maxLines: 5,
//         maxLength: 1000,
//       ),
//       ListingsHelper.textField(
//         'requirementsSkills',
//         'Requirements & Skills',
//         "List required skills",
//         maxLines: 5,
//         maxLength: 1000,
//       ),
//       ListingsHelper.textField(
//         'qualificationRequirements',
//         'Minimum Qualification Requirements',
//         "List minimum qualifications",
//         maxLines: 5,
//         maxLength: 1000,
//       ),
//     ];
//   }

//   // Helper to build Home-specific fields
//   static List<Widget> buildHomeFields(
//       BuildContext context, handleImageSelection) {
//     return [
//       ListingsHelper.imagePickerField(
//         "pickimage",
//         2,
//         5,
//         context,
//         onChanged: handleImageSelection,
//       ),
//       ListingsHelper.textField(
//         'videoLink',
//         'Link to YouTube or Facebook Video',
//         'Enter video link',
//       ),
//       ListingsHelper.textField(
//         'address',
//         'Address',
//         'Enter address',
//         maxLength: 50,
//       ),
//       ListingsHelper.dropdownField(
//         'condition',
//         'Condition',
//         [
//           'Fairly Used',
//           'Newly-Built',
//           'Old',
//           'Under construction',
//         ],
//       ),
//       ListingsHelper.textField(
//         'squareMeters',
//         'Square Meters',
//         'Enter square meters',
//         keyboardType: TextInputType.number,
//       ),
//       ListingsHelper.dropdownField(
//         'furnishing',
//         'Furnishing',
//         [
//           'Furnished',
//           'Semi-Furnished',
//           'Unfurnished',
//         ],
//       ),
//     ];
//   }

// // Helper to build Scholarship-specific fields
//   static List<Widget> buildScholarshipFields(BuildContext context) {
//     return [
//       ListingsHelper.textField(
//         'provider',
//         'Scholarship Provider',
//         'Enter scholarship provider',
//       ),
//       ListingsHelper.dropdownField(
//         'scholarshipType',
//         'Type of Scholarship',
//         [
//           'Undergraduate',
//           'Postgraduate',
//           'Doctoral',
//           'Research',
//           'Exchange Program',
//         ],
//       ),
//       ListingsHelper.textField(
//         'eligibility',
//         'Eligibility Criteria',
//         'Describe eligibility requirements',
//         maxLines: 3,
//       ),
//       ListingsHelper.datePickerField(
//           'deadline', 'deadline', 'Application Deadline', context),
//       ListingsHelper.textField(
//         'awardAmount',
//         'Award Amount',
//         'Enter award amount',
//         keyboardType: TextInputType.number,
//       ),
//       ListingsHelper.textField(
//         'contactInfo',
//         'Contact Information',
//         'Enter contact details for inquiries',
//         maxLines: 2,
//       ),
//     ];
//   }

//   static List<Widget> buildBiddingFields(BuildContext context) {
//     return [
//       ListingsHelper.textField(
//         'bidAmount',
//         'Bid Amount',
//         'Enter your bid amount',
//         keyboardType: TextInputType.number,
//       ),
//       ListingsHelper.datePickerField(
//           'deadline', 'bidDeadline', 'Bid Deadline', context),
//       ListingsHelper.dropdownField(
//         'bidderType',
//         'Bidder Type',
//         [
//           'Individual',
//           'Company',
//         ],
//       ),
//       ListingsHelper.textField(
//         'contactInfo',
//         'Contact Information',
//         'Enter your contact details',
//         maxLines: 2,
//       ),
//       ListingsHelper.textField(
//         'additionalNotes',
//         'Additional Notes',
//         'Enter any additional requirements',
//         maxLines: 5,
//       ),
//     ];
//   }
// }
