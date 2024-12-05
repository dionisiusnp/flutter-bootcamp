import 'package:flutter/material.dart';
import 'package:marketplace_apps/api/product_api.dart';
import 'package:marketplace_apps/model/product_model.dart';
import 'package:marketplace_apps/seller/product/create_screen.dart';

class IndexProductScreen extends StatefulWidget {
  @override
  _IndexProductState createState() => _IndexProductState();
}

class _IndexProductState extends State<IndexProductScreen> {
  late ProductApi productApi;
  late Future<List<Product>> futureProduct;

  @override
  void initState() {
    super.initState();
    productApi = ProductApi();
    futureProduct = productApi.getProduct();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.shopping_cart, color: Colors.black),
            SizedBox(width: 8),
            Text(
              'Produk',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search, color: Colors.black),
            ),
          ],
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No products found."));
          }

          final products = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    DropdownButton<String>(
                      value: 'harga',
                      items: ['harga', 'nama', 'populer']
                          .map((value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (value) {},
                    ),
                    Spacer(),
                    Text(
                      '${products.length} barang ditemukan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Jumlah kolom
                      mainAxisSpacing: 16, // Jarak vertikal antar item
                      crossAxisSpacing: 16, // Jarak horizontal antar item
                      childAspectRatio: 2 / 2.5, // Rasio ukuran item
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(products[index]);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateProductScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[300],
                child: Center(
                  child: Image.asset(
                    'images/produk-digital.jpeg', // Gunakan asset untuk gambar produk
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Rp ${product.price.toString()}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              product.description ?? '',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Edit Button
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    
                  },
                ),
                // Delete Button
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteProduct(product.name ?? '-', product.id ?? 0);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _deleteProduct(String productName, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Apakah anda yakin ingin menghapus "$productName"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Tutup dialog tanpa aksi
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async { // Tambahkan async di sini
              final success = await productApi.deleteProduct(id);
              Navigator.of(ctx).pop(); // Tutup dialog tanpa aksi

              if (success) {
                setState(() {
                  futureProduct = productApi.getProduct(); // Refresh data
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Produk berhasil dihapus.')),
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
