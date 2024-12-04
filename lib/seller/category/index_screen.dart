import 'package:flutter/material.dart';
import 'package:marketplace_apps/api/product_category_api.dart';
import 'package:marketplace_apps/model/product_category_model.dart';
import 'package:marketplace_apps/seller/category/create_screen.dart';

class IndexCategoryScreen extends StatefulWidget {
  @override
  _IndexCategoryState createState() => _IndexCategoryState();
}

class _IndexCategoryState extends State<IndexCategoryScreen> {
  late ProductCategoryApi productCategoryApi;
  late Future<List<ProductCategory>> futureCategoryProduct;

  @override
  void initState() {
    super.initState();
    productCategoryApi = new ProductCategoryApi();
    futureCategoryProduct = productCategoryApi.getProductCategory();
  }

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
      body: FutureBuilder<List<ProductCategory>>(
        future: futureCategoryProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No categories found."));
          }

          final categories = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryItem(category.name ?? 'Unknown', Icons.category, Colors.blue);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateCategoryScreen()),
          );
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
