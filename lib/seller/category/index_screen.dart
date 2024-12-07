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
              return _buildCategoryItem(category, category.name ?? 'Unknown', Icons.category, Colors.blue, category.id ?? 0);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Menunggu hasil dari CreateCategoryScreen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateCategoryScreen()),
          );

          // Jika berhasil menambahkan kategori, refresh tampilan
          if (result != null && result) {
            setState(() {
              futureCategoryProduct = productCategoryApi.getProductCategory(); // Refresh data kategori
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryItem(ProductCategory $category, String title, IconData icon, Color color, int id) {
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
        title: Text(
          title,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // Atur ukuran agar tidak mengambil ruang penuh
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateCategoryScreen(category: $category,)),
                );

                // Jika berhasil menambahkan kategori, refresh tampilan
                if (result != null && result) {
                  setState(() {
                    futureCategoryProduct = productCategoryApi.getProductCategory(); // Refresh data kategori
                  });
                } // Panggil fungsi edit dengan ID
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteCategory(title, id); // Panggil fungsi delete dengan ID
              },
            ),
          ],
        ),
      ),
    );
  }

  void _deleteCategory(String categoryName, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Apakah anda yakin ingin menghapus "$categoryName"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Tutup dialog tanpa aksi
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async { // Tambahkan async di sini
              final success = await productCategoryApi.deleteProductCategory(id); // Gunakan instance
              Navigator.of(ctx).pop(); // Tutup dialog

              if (success) {
                setState(() {
                  futureCategoryProduct = productCategoryApi.getProductCategory(); // Refresh data
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Kategori produk berhasil dihapus.')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Produk gagal terhapus')),
                );
              }
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }
}
