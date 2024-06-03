import 'package:flutter/material.dart';
import 'package:pos/utils/Helper.dart';
import 'CompanyModel.dart'; // Ensure the path is correct
import 'OutletController.dart'; // Ensure the path is correct

class EditCompanyScreen extends StatefulWidget {
  final Company company;

  const EditCompanyScreen({Key? key, required this.company}) : super(key: key);

  @override
  _EditCompanyScreenState createState() => _EditCompanyScreenState();
}

class _EditCompanyScreenState extends State<EditCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _contactPersonNameController;
  late TextEditingController _contactPersonNumberController;

  Helper helper = Helper(); // Create an instance of the Helper class
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.company.name);
    _addressController = TextEditingController(text: widget.company.address);
    _contactPersonNameController =
        TextEditingController(text: widget.company.contactPersonName);
    _contactPersonNumberController =
        TextEditingController(text: widget.company.contactPersonNumber);

    comapnyId = widget.company.id;
  }

  var comapnyId = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactPersonNameController.dispose();
    _contactPersonNumberController.dispose();
    super.dispose();
  }

  _handleUpdate() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    if (_formKey.currentState!.validate()) {
      Company updatedCompany = Company(
        id: widget.company.id,
        name: _nameController.text,
        address: _addressController.text,
        contactPersonName: _contactPersonNameController.text,
        contactPersonNumber: _contactPersonNumberController.text,
        status: widget.company.status,
      );
      comapnyId = widget.company.id;

      final success =
          await OutletController().updateCompany(updatedCompany, comapnyId);
      if (success == true) {
        helper.successToast('Company update successfully');
        setState(() {
          _isLoading = false; // Show loading indicator
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Company update successfully')),
        );
        Navigator.pop(context, updatedCompany);
      } else {
        setState(() {
          _isLoading = false; // Show loading indicator
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update company')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Company'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                ),
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Company Address',
                ),
              ),
              TextField(
                controller: _contactPersonNameController,
                decoration: const InputDecoration(
                  labelText: 'Contact Person Name',
                ),
              ),
              TextField(
                controller: _contactPersonNumberController,
                decoration: const InputDecoration(
                  labelText: 'Contact Person Number',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  _handleUpdate();
                },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
