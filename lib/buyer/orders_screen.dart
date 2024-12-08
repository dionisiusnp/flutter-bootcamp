import 'package:flutter/material.dart';
import 'package:marketplace_apps/buyer/chat_room_screen.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatRoomScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}