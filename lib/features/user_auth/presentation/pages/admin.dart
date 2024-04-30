 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/features/user_auth/presentation/pages/home_page.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);
  
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  final product_name = TextEditingController();
  final product_url = TextEditingController();
  final product_prize = TextEditingController();
   

  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("admin"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: product_name,
                  decoration: InputDecoration(hintText: 'Enter poduct name'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: product_url,
                  decoration: InputDecoration(hintText: 'Enter poduct url'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: product_prize,
                  decoration: InputDecoration(hintText: 'Enter poduct prize'),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    CollectionReference collRef = FirebaseFirestore.instance
                        .collection('product_details');

                    if (product_name.text.isNotEmpty &&
                        product_prize.text.isNotEmpty &&
                        product_url.text.isNotEmpty) {
                      int prize = int.tryParse(product_prize.text) ?? 0;
                      collRef.add({
                        'product_name': product_name.text,
                        'product_imageUrl': product_url.text,
                        'product_prize': prize,
                      });

                      // Navigate back to the home page after adding the product
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false,
                      );
                    } else {
                      // Show a message to the user if any field is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill in all the fields.'),
                        ),
                      );
                    }
                  },
                  child: Text('Add product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
