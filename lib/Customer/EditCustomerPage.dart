import 'package:flutter/material.dart';
import 'package:pos/Customer/CustomerModel.dart';
import 'package:pos/utils/Helper.dart';
import 'CustomerController.dart';

class EditCustomerPage extends StatefulWidget {
  final CustomerModel customer;

  const EditCustomerPage({super.key, required this.customer});

  @override
  EditCustomerPageState createState() => EditCustomerPageState();
}

class EditCustomerPageState extends State<EditCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _codeController;
  // Add controllers for other fields

  Helper helper = Helper(); // Create an instance of the Helper class
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.name);
    _phoneController =
        TextEditingController(text: widget.customer.phone.toString());
    _addressController =
        TextEditingController(text: widget.customer.address.toString());
    _emailController =
        TextEditingController(text: widget.customer.email.toString());
    _codeController =
        TextEditingController(text: widget.customer.customerCode.toString());
    // Initialize controllers for other fields
  }

  _handleUpdate(context) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    if (_formKey.currentState!.validate()) {
      CustomerModel updatedCompany = CustomerModel(
        id: widget.customer.id,
        name: _nameController.text,
        address: _addressController.text,
        email: _emailController.text,
        customerCode: _codeController.text,
        customerGroupId: widget.customer.customerGroupId,
        customerReceivableAccount: widget.customer.customerReceivableAccount,
        phone: _phoneController.text,
      );

      CustomerController controller =
          CustomerController(); // Create an instance of CustomerController
      final success = await controller
          .updateCustomer(updatedCompany); // Call the instance method
      if (success) {
        helper.successToast('Customer update successfully');
        setState(() {
          _isLoading = false; // Show loading indicator
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer update successfully')),
        );
        Navigator.pop(context, updatedCompany);
      } else {
        setState(() {
          _isLoading = false; // Show loading indicator
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update customer info')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Code'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              // Add fields for other details
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
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
