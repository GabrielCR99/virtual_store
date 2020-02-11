import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/tiles/place_tile.dart';

class PlacesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else
          return ListView(
            children:
              snapshot.data.documents.map((doc) => PlaceTile(doc)).toList(),
          );
      },
      future: Firestore.instance.collection('places').getDocuments(),
    );
  }
}
