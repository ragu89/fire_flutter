import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_flutter/model/document.dart';
import 'package:flutter/material.dart';

class DocumentsScreen extends StatefulWidget {
  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  CollectionReference _documentsReference =
      FirebaseFirestore.instance.collection('documents');
  List<Document> _documents;

  @override
  void initState() {
    super.initState();
    _initStateAsync();
  }

  void _initStateAsync() {
    _loadDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Documents"),
        actions: [
          _addButton(),
        ],
      ),
      body: _listOfDocuments(),
    );
  }

  Widget _listOfDocuments() {
    if (_documents == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        itemCount: _documents.length,
        itemBuilder: (context, index) => ListTile(
            title: Text(_documents[index].title),
            subtitle: Text(_documents[index].subtitle)),
      );
    }
  }

  Future<void> _loadDocuments() async {
    print("loadDocuments async");
    try {
      var snapshot = await _documentsReference.get();
      if (snapshot.docs.isNotEmpty) {
        _documents = snapshot.docs
            .map((snapshot) => Document.fromMap(snapshot.data(), snapshot.id))
            .where((mappedItem) => mappedItem.title != null)
            .toList();
        setState(() {
          _documents.sort((a, b) => a.compareTo(b));
        });
        print("document loaded!");
      }
    } catch (e) {
      print("error when trying to fetch the list documents: e");
      return null;
    }
  }

  Widget _addButton() {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () async {
        print("Add new document");
        try {
          var now = new DateTime.now();
          var document = {
            'title': now.toIso8601String(),
            'subtitle':
                "${now.hour} hours ${now.minute} minutes and ${now.second} seconds"
          };
          print("ready to call add method");
          var documentAdded = await _documentsReference.add(document);
          print("document added : ${documentAdded.id}");
          await _loadDocuments();
        } catch (error) {
          print("error when trying to add a document: $error");
        }
      },
    );
  }
}
