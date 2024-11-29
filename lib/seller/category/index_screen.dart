import 'package:flutter/material.dart';
import 'package:marketplace_apps/seller/category/create_screen.dart';

class IndexCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Category',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          _buildCategoryItem('Books', Icons.menu_book, Colors.red),
          _buildCategoryItem('Vehicle', Icons.directions_car, Colors.blue),
          _buildCategoryItem('Clothes', Icons.checkroom, Colors.orange),
          _buildCategoryItem('Shoes', Icons.hiking, Colors.brown),
          _buildCategoryItem('Computer & Accessories', Icons.computer, Colors.green),
          _buildCategoryItem('Smartphone', Icons.smartphone, Colors.blueAccent),
          _buildCategoryItem('Watch', Icons.watch, Colors.orangeAccent),
          _buildCategoryItem('Mother & Baby', Icons.child_care, Colors.yellow),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => CreateCategoryScreen())
          );
          // Action for add category
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, Color color) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: color, width: 4.0),
            ),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
        onTap: () {
          // Handle category tap
        },
      ),
    );
  }
}
