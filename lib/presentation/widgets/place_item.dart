import 'package:flutter/material.dart';

import '../../data/models/Place_suggestion.dart';

class PlaceItem extends StatelessWidget {
  final PlaceSuggestion suggestion;

  PlaceItem({required this.suggestion})
      : super(key: ValueKey(suggestion.placeId));

  @override
  Widget build(BuildContext context) {
    // Safely remove the first part of the description
    var descriptionParts = suggestion.description.split(',');
    var mainTitle = descriptionParts[0];
    var subTitle = descriptionParts.length > 1
        ? suggestion.description.replaceAll(mainTitle, '').trim()
        : '';

    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.all(8),
      padding: const EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue, // Background color for the icon
              ),
              child: const Icon(
                Icons.place,
                color: Colors.white, // White for visibility against blue
              ),
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$mainTitle\n',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: subTitle.isNotEmpty
                        ? subTitle.substring(subTitle.startsWith(',')
                            ? 1
                            : 0) // Safely removing leading comma
                        : '', // If no subtitle, leave it empty
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
