import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p_08_firebase/constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late CollectionReference messageRef;

  @override
  void initState() {
    super.initState();
    messageRef = fireStore.collection('Messages');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messageRef.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  
                } //
                else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: kMyInputDecoration.copyWith(
                    hintText: 'Type your message...',
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Colors.blue,
                ),
                onPressed: sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    String text = controller.text;
    print(text);
    if (text.length <= 2) {
      print('type sth more');
      return;
    }

    Map<String, dynamic> newMap = Map();
    newMap['text'] = text;
    newMap['time'] = DateTime.now();

    messageRef.add(newMap).then((value) => print(value));
  }
}
