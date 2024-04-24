import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/features/user_auth/presentation/pages/admin.dart';

// import 'package:my_flutter_app/features/user_auth/presentation/pages/login_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

 

  @override
  Widget build(BuildContext context) {

     final args = ModalRoute.of(context)!.settings.arguments as String?;
     final email = args ?? "No Email Provided"; // Handle the case where arguments are null
    
    return Scaffold(
      backgroundColor: Colors.amber[50],
     
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              children: [
                const Text("home derectory"),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    height: 50,
                    width: 200,
                    child: GestureDetector(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Admin()),
                          (route) => false,
                        );
                      },
                      child: const Text("Go to login"),
                    )),
            
                Expanded(
                  child: Container(
                    
                  
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('product_details').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        print('Snapshot data: $snapshot');
                        final List<DocumentSnapshot> documents = snapshot.data!.docs;
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                                // Calculate the index for accessing the data
                                int dataIndex = index * 2;

                                // Check if there are at least two products left to display in a pair
                                if (dataIndex + 1 < documents.length) {
                                  final Map<String, dynamic> data1 = documents[dataIndex].data() as Map<String, dynamic>;
                                  final String productName1 = data1['product_name'];
                                  final String productImageUrl1 = data1['product_imageUrl'];
                                  final int productPrize1 = data1['product_prize'];

                                  final Map<String, dynamic> data2 = documents[dataIndex + 1].data() as Map<String, dynamic>;
                                  final String productName2 = data2['product_name'];
                                  final String productImageUrl2 = data2['product_imageUrl'];
                                  final int productPrize2 = data2['product_prize'];

                                  return Row(
                                    
                                    children: [
                                      
                                      Expanded(
                                        child: Container(
                                           
                                          color: Color.fromARGB(255, 242, 239, 239),
                                          margin: EdgeInsets.symmetric( vertical: 8.0,horizontal: 4.0),
                                          
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(10), // Set the border radius as needed
                                                child: Image.network(
                                                  productImageUrl1,
                                                  width: 600,
                                                  height: 200,
                                                  fit: BoxFit.cover, // Optional: Specify how the image should be fitted within the container
                                                ),
                                              ),
                                              Text(productName1),
                                               Text(
                                                ' \$ ${productPrize1.toString()} ',
                                                style: TextStyle(fontSize: 15.0),
                                              )
,
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Add to cart action for product 1
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 241, 172, 23)),
                                                ),
                                                child: const Text(
                                                  'Add to Cart',
                                                  style: TextStyle(fontSize: 10.0, color: Color.fromARGB(255, 83, 81, 76)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                           
                                             color: Color.fromARGB(255, 242, 239, 239),
                                          margin: EdgeInsets.symmetric( vertical: 8.0,horizontal: 4.0),
                                          child: Column(
                                            children: [
                                               ClipRRect(
                                                borderRadius: BorderRadius.circular(10), // Set the border radius as needed
                                                child: Image.network(
                                                  productImageUrl2,
                                                  width: 300,
                                                  height: 200,
                                                  fit: BoxFit.cover, // Optional: Specify how the image should be fitted within the container
                                                ),
                                              ),

                                              Text(productName2),
                                             Text(
                                                '\$ ${productPrize2.toString()} ',
                                                style: TextStyle(fontSize: 15.0),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Add to cart action for product 2
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 192, 95, 154)),
                                                ),
                                                child: const Text(
                                                  'Add to Cart',
                                                  style: TextStyle(fontSize: 10.0, color: Color.fromARGB(255, 83, 81, 76)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              },

                        );
                      },
                    ),
                  ),
                ),
                Text(email)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
