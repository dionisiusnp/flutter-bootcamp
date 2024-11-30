import 'package:flutter/material.dart';
import 'package:marketplace_apps/model/chat_model.dart';
import 'package:marketplace_apps/api/chat_api.dart';

class ChatRoomScreen extends StatefulWidget {
  final int userId;

  const ChatRoomScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late ChatApi chatApi;
  late Future<List<Chat>> futureChats;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatApi = ChatApi();
    futureChats = chatApi.getChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Room (User ID: ${widget.userId})"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Chat>>(
              future: futureChats,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No messages."));
                }

                List<Chat> chats = snapshot.data!
                    .where((chat) => chat.user_id == widget.userId)
                    .toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    Chat chat = chats[index];
                    bool isSeller = chat.is_seller_reply == 1;
                    return Align(
                      alignment: isSeller
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSeller
                              ? Colors.blue[100]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(chat.message ?? ""),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(hintText: "Type a message..."),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
