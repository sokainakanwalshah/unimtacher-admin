import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unimatcher_admin/utils/constants/colors.dart';

class AdminChatScreen extends StatefulWidget {
  @override
  _AdminChatScreenState createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('Users');
  String? _selectedUserId;
  String? _selectedUserName;
  String? _selectedUserEmail;
  String? _selectedUserProfilePicture;
  CollectionReference? _selectedUserChats;

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _selectedUserId == null)
      return;

    try {
      await _selectedUserChats!.add({
        'message': _messageController.text,
        'timestamp': Timestamp.now(),
        'sender': 'admin',
        'seen': false,
      });

      _messageController.clear();
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  void _selectUser(String userId, String userName, String userEmail,
      String profilePicture) async {
    setState(() {
      _selectedUserId = userId;
      _selectedUserName = userName;
      _selectedUserEmail = userEmail;
      _selectedUserProfilePicture = profilePicture;
      _selectedUserChats = FirebaseFirestore.instance
          .collection('chats')
          .doc(_selectedUserId)
          .collection('messages');
    });

    try {
      var snapshot = await _selectedUserChats!
          .where('seen', isEqualTo: false)
          .where('sender', isNotEqualTo: 'admin')
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.update({'seen': true});
      }
    } catch (e) {
      print("Error updating seen status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Chat',
          style: TextStyle(color: UMColors.white),
        ),
        backgroundColor: UMColors.primary,
      ),
      body: Row(
        children: [
          // User list section
          Expanded(
            flex: 2,
            child: Container(
              color: UMColors.lightGrey,
              child: StreamBuilder(
                stream: _users.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var users = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var user = users[index];
                      String firstName = user['FirstName'];
                      String lastName = user['LastName'];
                      String email = user['Email'];
                      String image = user['ProfilePicture'];
                      String userId = user.id;
                      String fullName = '$firstName $lastName';

                      return ListTile(
                        title: Text(fullName,
                            style: TextStyle(color: UMColors.primary)),
                        subtitle: Text(email,
                            style: TextStyle(color: UMColors.black)),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(image),
                        ),
                        trailing: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('chats')
                              .doc(userId)
                              .collection('messages')
                              .where('seen', isEqualTo: false)
                              .where('sender', isNotEqualTo: 'admin')
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> messageSnapshot) {
                            if (!messageSnapshot.hasData) {
                              return SizedBox.shrink();
                            }
                            int unseenCount = messageSnapshot.data!.docs.length;
                            return unseenCount > 0
                                ? CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.red,
                                    child: Text(
                                      unseenCount.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  )
                                : SizedBox.shrink();
                          },
                        ),
                        onTap: () =>
                            _selectUser(userId, fullName, email, image),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // Chat window section
          Expanded(
            flex: 5,
            child: Container(
              color: UMColors.white,
              child: Column(
                children: [
                  _selectedUserId == null
                      ? Expanded(
                          child: Center(
                              child: Text('Select a user to view messages')))
                      : Expanded(
                          child: StreamBuilder(
                            stream: _selectedUserChats!
                                .orderBy('timestamp')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }

                              var messages = snapshot.data!.docs;
                              return ListView.builder(
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  var message = messages[index];
                                  var isAdminMessage =
                                      message['sender'] == 'admin';
                                  return Align(
                                    alignment: isAdminMessage
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      decoration: BoxDecoration(
                                        color: isAdminMessage
                                            ? UMColors.primaryBackground
                                            : UMColors.secondary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            isAdminMessage
                                                ? 'Admin'
                                                : _selectedUserName!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: UMColors.primary),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            message['message'],
                                            style: TextStyle(
                                                color: UMColors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              labelText: 'Type your message',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: UMColors.primary),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: UMColors.primary),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // User details section
          Expanded(
            flex: 3,
            child: Container(
              color: UMColors.white,
              padding: EdgeInsets.all(16.0),
              child: _selectedUserId == null
                  ? Center(child: Text('Select a user to view details'))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(_selectedUserProfilePicture ?? ""),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'User Details',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: UMColors.primary),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Name: $_selectedUserName',
                          style:
                              TextStyle(fontSize: 18, color: UMColors.primary),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Email: $_selectedUserEmail',
                          style:
                              TextStyle(fontSize: 18, color: UMColors.primary),
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
