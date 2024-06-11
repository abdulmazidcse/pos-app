import 'package:flutter/material.dart';
import 'package:pos/Products/ProductModel.dart';
import 'package:pos/Products/ProductController.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product;

  EditProductPage({required this.product});

  @override
  EditProductPageState createState() => EditProductPageState();
}

class EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  late TextEditingController productNameController;
  late TextEditingController mrpPriceController;
  late TextEditingController costPriceController;
  late TextEditingController productCodeController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with product data
    productNameController =
        TextEditingController(text: widget.product.productName);
    mrpPriceController =
        TextEditingController(text: widget.product.mrpPrice.toString());
    costPriceController =
        TextEditingController(text: widget.product.costPrice.toString());
    productCodeController =
        TextEditingController(text: widget.product.productCode);
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    productNameController.dispose();
    mrpPriceController.dispose();
    costPriceController.dispose();
    productCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate(context) async {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = ProductModel(
        id: widget.product.id,
        productName: productNameController.text,
        productCode: productCodeController.text,
        costPrice: double.parse(costPriceController.text),
        mrpPrice: double.parse(mrpPriceController.text),

        productNativeName: widget.product.productNativeName,
        categoryId: widget.product.categoryId,
        subCategoryId: widget.product.subCategoryId,
        brandId: widget.product.brandId,
        minOrderQty: widget.product.id,
        depoPrice: widget.product.id,
        taxMethod: widget.product.id,
        productTax: widget.product.id,
        quantity: widget.product.id,
        status: widget.product.id,
        discount: widget.product.id,
        // category: widget.product.id,
      );
      try {
        final success = await ProductController().updateProduct(updatedProduct);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully')),
          );
          Navigator.pop(context, updatedProduct);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update product')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('An error occurred. Please try again later.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: productNameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: mrpPriceController,
                decoration: const InputDecoration(labelText: 'MRP Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter MRP price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: costPriceController,
                decoration: const InputDecoration(labelText: 'Cost Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cost price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: productCodeController,
                decoration: const InputDecoration(labelText: 'Product Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _handleUpdate(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
