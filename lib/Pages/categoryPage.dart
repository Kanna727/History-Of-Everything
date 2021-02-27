import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:history_of_everything/Pages/detailsPage.dart';
import 'subCategoryPage.dart';

class CategoryPage extends StatefulWidget {
  final String categoryName;
  CategoryPage(this.categoryName);
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.categoryName),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(widget.categoryName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        List tempList = snapshot.data.documents;
        tempList.sort((a,b) => a.data["index"].compareTo(b.data["index"]));

        return _buildList(context, tempList);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          onTap: () {
            if(data["sub"]) {
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new SubCategoryPage(widget.categoryName,record.name)));
            }
            else {
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DetailsPage(record.name)));
            }
          }
        ),
      ),
    );
  }
}

class Record {
  final String name;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name>";
}