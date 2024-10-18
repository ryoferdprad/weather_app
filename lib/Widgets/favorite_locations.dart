import 'package:flutter/material.dart';

class FavoriteLocations extends StatelessWidget {
  final List<String> favoriteLocations;
  final Function(String) onSelectLocation;
  final Function(String) onRemoveLocation;

  const FavoriteLocations({
    Key? key,
    required this.favoriteLocations,
    required this.onSelectLocation,
    required this.onRemoveLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Text(
            'Favorite Locations',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        if (favoriteLocations.isEmpty)
          ListTile(
            title: Text('No favorite locations added.'),
          ),
        for (var location in favoriteLocations)
          ListTile(
            title: Text(location),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => onRemoveLocation(location),
            ),
            onTap: () => onSelectLocation(location),
          ),
      ],
    );
  }
}