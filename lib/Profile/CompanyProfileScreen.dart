import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos/Profile/EditCompanyScreen.dart';
import 'package:pos/utils/Api.dart';
import 'package:pos/utils/Drawer.dart';
import 'CompanyModel.dart'; // Ensure the path is correct
import 'OutletController.dart'; // Ensure the path is correct

class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  CompanyProfileScreenState createState() => CompanyProfileScreenState();
}

class CompanyProfileScreenState extends State<CompanyProfileScreen> {
  late Future<Company> _companyFuture;
  int companyId = 0;

  @override
  void initState() {
    super.initState();
    // Initialize with a placeholder future
    _companyFuture = Future.error('Company data not loaded');
    userData();
  }

  void userData() async {
    final userInfo = await Api().userInfo();
    var decodeInfo = jsonDecode(userInfo);
    if (decodeInfo != null) {
      setState(() {
        companyId = decodeInfo['company_id'];
        _companyFuture = OutletController().fetchCompany(companyId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Company Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Company>(
            future: _companyFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No company found.'));
              } else {
                final data = snapshot.data!;
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.orange.withOpacity(0.2),
                              child: const Icon(
                                Icons.store,
                                color: Colors.orange,
                                size: 80,
                              ),
                            ),
                            const Positioned(
                              right: 0,
                              bottom: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                child:
                                    Icon(Icons.camera_alt, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          data.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          data.contactPersonName,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  data.contactPersonName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final updatedCompany = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditCompanyScreen(company: data),
                                  ),
                                );
                                if (updatedCompany != null) {
                                  setState(() {
                                    _companyFuture =
                                        Future.value(updatedCompany);
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        _buildInfoRow('Company Name', data.name),
                        _buildInfoRow('Company Address', data.address),
                        _buildInfoRow(
                            'Company Contact', data.contactPersonName),
                        _buildInfoRow(
                            'Contact Number', data.contactPersonNumber),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
