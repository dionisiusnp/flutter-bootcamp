import 'package:flutter/material.dart';
import 'package:marketplace_apps/api/product_api.dart';
import 'package:marketplace_apps/buyer/cart/cart_screen.dart';
import 'package:marketplace_apps/model/product_model.dart';
import 'package:marketplace_apps/util/auth.dart';
import 'package:marketplace_apps/util/config.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ProductApi productApi;
  late Future<List<Product>> futureProduct;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = ''; 

  @override
  void initState() {
    super.initState();
    productApi = ProductApi();
    futureProduct = productApi.getProduct();
  }

  void _performSearch() {
    setState(() {
      futureProduct = productApi.getProduct(query: _searchQuery);
    });
  }

  Future<void> _logout() async {
    final bool confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Apakah Anda yakin ingin logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (confirm) {
      await Auth.logout(context: context);
    }
  }

  final ScrollController _scrollController = ScrollController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.shopping_basket),
            SizedBox(width: 8),
            Text('Produk',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                )
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen())
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Logout",
          ),
        ],
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Cari produk...',
                              border: InputBorder.none,
                            ),
                            onSubmitted: (value) {
                              setState(() {
                                _searchQuery = value;
                                _performSearch();
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              _searchQuery = _searchController.text;
                              _performSearch();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
          ),
        ),
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
                    Text(
                      '${products.length} produk',
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
                    product.image ?? 'images/produk-digital.jpeg', // Gunakan asset untuk gambar produk
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${Config().formatCurrency(product.price ?? 0)}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700], fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              product.name ?? '',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              product.description ?? '',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart, color: Colors.blueAccent),
                  onPressed: () {
                    // _addProduct(product);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addProduct(product) {
    // setState(() {
    //   // Ensure the price field exists and is not null, else provide a default value
    //   double price = product['price'] ?? 0.0;
    //   // Find the product in the cart
    //   var existingProduct = _addedProducts.firstWhere(
    //     (p) => p['name'] == product['name'],
    //     orElse: () =>
    //         Map<String, dynamic>(), // Return an empty map if not found
    //   );

    //   if (existingProduct.isNotEmpty) {
    //     // If the product exists, increment the quantity
    //     existingProduct['quantity']++;
    //   } else {
    //     // If the product doesn't exist, add it to the cart with quantity 1
    //     _addedProducts.add({
    //       ...product,
    //       'quantity': 1,
    //       'price': price, // Ensure price is added to the cart
    //     });
    //   }
    // });

    // Show SnackBar after product is added
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product["name"]} berhasil ditambahkan ke keranjang!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
