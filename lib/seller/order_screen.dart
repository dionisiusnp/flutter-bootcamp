import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final List<Map<String, dynamic>> _allProducts = [
    {"created_at": "22 November 2024", "buyer": "Dionisius", "total": 100000,  "status": "Process"},
    {"created_at": "22 November 2024", "buyer": "Nanda", "total": 150000, "status": "Paid"},
    {"created_at": "22 November 2024", "buyer": "Priyadi", "total": 50000, "status": "Cancel"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
