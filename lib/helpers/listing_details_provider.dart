// // Helper function to populate category-specific details
// import 'package:waloma/core/model/listing_models/listing_request_model.dart';
// import 'package:waloma/views/widgets/listing_widgets/listing_create_edit_widget.dart';

// Details populateDetails(Map<String, dynamic>? formData) {
//   // Create a new instance of Details
//   Details details = Details.fromJson({});

//   if (ListingCreateEdit.selectedListingType == "vehicle") {
//     details.additionalFields = {
//       'make': formData?['make'],
//       'model': formData?['model'],
//       'year': formData?['year'],
//       'color': formData?['color'],
//       'interior_color': formData?['interior_color'],
//       'condition': formData?['condition'],
//       'transmission': formData?['transmission'],
//       'vin': formData?['vin'],
//       'seats': formData?['seats'],
//       'cylinders': formData?['cylinders'],
//       'engine_size': formData?['engine_size'],
//       'horse_power': formData?['horse_power'],
//     };
//   } else if (ListingCreateEdit.selectedListingType == "job") {
//     details.additionalFields = {
//       'posted_by': formData?['posted_by'],
//       'job_type': formData?['job_type'],
//       'work_setup': formData?['work_setup'],
//       'career_level': formData?['career_level'],
//       'min_experience': formData?['min_experience'],
//       'application_deadline': formData?['application_deadline'],
//       'responsibilities': formData?['responsibilities'],
//       'requirements': formData?['requirements'],
//       'min_qualification': formData?['min_qualification'],
//     };
//   } else if (ListingCreateEdit.selectedListingType == "home") {
//     details.additionalFields = {
//       'video_link': formData?['videoLink'],
//       'address': formData?['address'],
//       'condition': formData?['condition'],
//       'square_meters': formData?['squareMeters'],
//       'furnishing': formData?['furnishing'],
//     };
//   } else if (ListingCreateEdit.selectedListingType == "scholarship") {
//     details.additionalFields = {
//       'scholarship_type': formData?['scholarship_type'],
//       'eligibility': formData?['eligibility'],
//       'application_deadline': formData?['application_deadline'],
//       'benefits': formData?['benefits'],
//       'duration': formData?['duration'],
//     };
//   } else if (ListingCreateEdit.selectedListingType == "bid") {
//     details.additionalFields = {
//       'bid_type': formData?['bid_type'],
//       'starting_price': formData?['starting_price'],
//       'bid_deadline': formData?['bid_deadline'],
//       'terms_and_conditions': formData?['terms_and_conditions'],
//     };
//   }

//   return details;
// }
