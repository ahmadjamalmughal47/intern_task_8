import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: AugersoftDB()));
}

class AugersoftDB extends StatefulWidget {
  AugersoftDB({Key? key}) : super(key: key);

  @override
  _AugersoftDBState createState() => _AugersoftDBState();
}

class _AugersoftDBState extends State<AugersoftDB> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var snapshots = FirebaseFirestore.instance.collection('texts').snapshots();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("enter some text"),
                    content: TextField(
                      controller: _controller,
                      onSubmitted: (context) {
                        FirebaseFirestore.instance
                            .collection('texts')
                            .add({'text': _controller.text});
                      },
                    ),
                  );
                });
          });
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("FetchingData"),
      ),
      body: StreamBuilder(
        stream: snapshots,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(snapshot.data!.docs[index]['text']),
                  ),
                );
              });
        },
      ),
    );
  }
}
