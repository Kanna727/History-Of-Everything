import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  final String detailsName;
  DetailsPage(this.detailsName);
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final defaultStyle = TextStyle(color: Colors.black);
  final blueStyle = TextStyle(color: Colors.blue);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.detailsName),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(widget.detailsName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print(widget.detailsName);
          print('no data');
          return LinearProgressIndicator();
        }
        // List tempList = snapshot.data.documents;
        // tempList.sort((a,b) => a.data["index"].compareTo(b.data["index"]));

        return _buildList(context, snapshot.data.documents);
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
    if (data.data["data"] is String) {
      return Padding(
        key: ValueKey(data["data"]),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(child: Text(data["data"])),
      );
    } else {
      var map = data.data["data"].toString();
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: new Column(
          children: <Widget> [
            new Text(map)
          ],
        ),
      );
    }
  }
}
