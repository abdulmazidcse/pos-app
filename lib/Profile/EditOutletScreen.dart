import 'package:flutter/material.dart';
import 'package:pos/utils/Helper.dart';
import 'OutletModel.dart'; // Ensure the path is correct
import 'OutletController.dart'; // Ensure the path is correct

class EditOutletScreen extends StatefulWidget {
  final Outlet outlet;

  const EditOutletScreen({super.key, required this.outlet});

  @override
  EditOutletScreenState createState() => EditOutletScreenState();
}

class EditOutletScreenState extends State<EditOutletScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _contactPersonNameController;
  late TextEditingController _outletNumberController;
  late TextEditingController _addressController;

  Helper helper = Helper(); // Create an instance of the Helper class
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.outlet.name);
    _contactPersonNameController =
        TextEditingController(text: widget.outlet.contactPersonName);
    _outletNumberController =
        TextEditingController(text: widget.outlet.outletNumber);
    _addressController = TextEditingController(text: widget.outlet.addrs);
    outletId = widget.outlet.id;
  }

  var outletId = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _contactPersonNameController.dispose();
    _outletNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  _handleUpdate(context) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    if (_formKey.currentState!.validate()) {
      final updatedOutlet = Outlet(
        id: widget.outlet.id,
        companyId: widget.outlet.companyId,
        name: _nameController.text,
        contactPersonName: _contactPersonNameController.text,
        outletNumber: _outletNumberController.text,
        districtId: widget.outlet.districtId,
        districtName: widget.outlet.districtName,
        areaId: widget.outlet.areaId,
        areaName: widget.outlet.areaName,
        policeStation: widget.outlet.policeStation,
        roadNo: widget.outlet.roadNo,
        plotNo: widget.outlet.plotNo,
        latitude: widget.outlet.latitude,
        longitude: widget.outlet.longitude,
        address: widget.outlet.address,
        status: widget.outlet.status,
        addrs: widget.outlet.addrs,
      );
      outletId = widget.outlet.id;

      final success =
          await OutletController().updateOutlet(updatedOutlet, outletId);
      if (success) {
        helper.successToast('Outlet update successfully');
        setState(() {
          _isLoading = false; // Show loading indicator
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Outlet update successfully')),
        );
        Navigator.pop(context, updatedOutlet);
      } else {
        setState(() {
          _isLoading = false; // Show loading indicator
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update outlet')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Outlet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the outlet name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactPersonNameController,
                decoration:
                    const InputDecoration(labelText: 'Contact Person Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the contact person name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _outletNumberController,
                decoration: const InputDecoration(labelText: 'Outlet Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the outlet number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _handleUpdate(context);
                },
                style: ElevatedButton.styleFrom(
                    elevation: 9.0,
                    backgroundColor: Colors.green,
                    fixedSize: const Size(30, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
