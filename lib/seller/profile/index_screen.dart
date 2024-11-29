import 'package:flutter/material.dart';

class IndexProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile.jpg'), // Ganti dengan path gambar profil Anda
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Name *",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "E-Mail",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Location (optional)",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}