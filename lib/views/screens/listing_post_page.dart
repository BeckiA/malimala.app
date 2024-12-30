import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:waloma/core/model/listing_models/listing_response_model.dart';
import 'package:waloma/views/screens/homepage_helpers/home_hero_page.dart';
import 'package:waloma/views/widgets/listing_widgets/listing_create_edit_widget.dart';

class ListingPostScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final int maxDescriptionWords = 300;
  final Listings? listings;
  ListingPostScreen({Key? key, this.listings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
          // Section 1
          HomeHeroDisplayPage(
            titleMessage:
                listings != null ? 'Edit Listing' : 'Post a New Listing',
            isCreateListing: true,
            isEditListing: listings != null ? true : false,
          ),
          // Section 2 -
          ListingCreateEdit(
            formKey: _formKey,
            maxDescriptionWords: maxDescriptionWords,
            listing: listings,
          ),
        ]));
  }
}
