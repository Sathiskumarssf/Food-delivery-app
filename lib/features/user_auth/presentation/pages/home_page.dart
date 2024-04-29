import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/features/user_auth/presentation/pages/admin.dart';
import 'package:my_flutter_app/features/user_auth/presentation/pages/cart.dart';
import 'package:my_flutter_app/features/user_auth/presentation/widgets/form_container_widget.dart';

// import 'package:my_flutter_app/features/user_auth/presentation/pages/login_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final TextEditingController _SearchController = TextEditingController();
  QuerySnapshot? snapshots;

  Future<void> searchItems() async {
    if (_SearchController.text.trim() != '') {
      try {
        // Assign result to the class-level variable when condition is true
        snapshots = await FirebaseFirestore.instance
            .collection('product_details')
            .where('product_name',
                isGreaterThanOrEqualTo: _SearchController.text.trim())
            .where('product_name',
                isLessThanOrEqualTo: _SearchController.text.trim() + '\uf8ff')
            .get();

        snapshots!.docs.forEach((doc) {
          // Access the data in each document
          print(doc['product_name']);
          print(doc['product_prize']);
        });
      } catch (error) {
        print("Error searching items: $error");
        // Handle any errors here
      }
    } else {
      // Use a different variable when condition is false
      var snapshots =
          await FirebaseFirestore.instance.collection('product_details').get();
      snapshots.docs.forEach((doc) {
        print(doc['product_name']);
        print(doc['product_prize']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as String?;
    // final email =
    //     args ?? "No Email Provided"; // Handle the case where arguments are null
    var email = "asarakmal@gmail.com";
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

                // SizedBox(
                //     height: 50,
                //     width: 200,
                //     child: GestureDetector(
                //       onTap: () {
                //         FirebaseAuth.instance.signOut();
                //         Navigator.pushAndRemoveUntil(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => const Admin()),
                //           (route) => false,
                //         );
                //       },
                //       child: const Text("Go to login"),
                //     )
                //     ),

                //  Container(

                //    height: 50,
                //     width: 200,
                //      child:
                //       ElevatedButton(onPressed: (){},
                //       child: Icon(Icons.search)

                //       ),
                //    ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Align items to the center vertically
                      children: [
                        Expanded(
                          child: FormContainerWidget(
                            controller: _SearchController,
                            hintText: "Email",
                            isPasswordField: false,
                          ),
                        ),
                        SizedBox(
                            width:
                                16.0), // Add horizontal spacing between the button and the text field
                        ElevatedButton(
                          onPressed: searchItems,
                          child: Icon(Icons.search),
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                                Size(40.0, 45.0)), // Rounded to integers
                            backgroundColor:
                                MaterialStateProperty.all(Colors.orange),
                            alignment: Alignment.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Expanded(
                  child: Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('product_details')
                          .snapshots(),
                      builder: (context, snapshots) {
                        if (!snapshots.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        print('Snapshot data: $snapshots');
                        final List<DocumentSnapshot> documents =
                            snapshots.data!.docs;
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            // Calculate the index for accessing the data
                            int dataIndex = index * 2;

                            // Check if there are at least two products left to display in a pair
                            if (dataIndex + 1 < documents.length) {
                              final Map<String, dynamic> data1 =
                                  documents[dataIndex].data()
                                      as Map<String, dynamic>;
                              final String productName1 = data1['product_name'];
                              final String productImageUrl1 =
                                  data1['product_imageUrl'];
                              final int productPrize1 = data1['product_prize'];

                              final Map<String, dynamic> data2 =
                                  documents[dataIndex + 1].data()
                                      as Map<String, dynamic>;
                              final String productName2 = data2['product_name'];
                              final String productImageUrl2 =
                                  data2['product_imageUrl'];
                              final int productPrize2 = data2['product_prize'];

                              return Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: Color.fromARGB(255, 242, 239, 239),
                                      margin: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4.0),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10), // Set the border radius as needed
                                            child: Image.network(
                                              productImageUrl1,
                                              width: 600,
                                              height: 200,
                                              fit: BoxFit
                                                  .cover, // Optional: Specify how the image should be fitted within the container
                                            ),
                                          ),
                                          Text(productName1),
                                          Text(
                                            ' \$ ${productPrize1.toString()} ',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              CollectionReference collRef =
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'Cartproduct');
                                              collRef.add({
                                                'product_name': productName1,
                                                'product_prize': productPrize1,
                                                'product_url': productImageUrl1,
                                                'useremail': email
                                              });
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color.fromARGB(
                                                          255, 241, 172, 23)),
                                            ),
                                            child: const Text(
                                              'Add to Cart',
                                              style: TextStyle(
                                                  fontSize: 10.0,
                                                  color: Color.fromARGB(
                                                      255, 83, 81, 76)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 242, 239, 239),
                                      margin: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4.0),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10), // Set the border radius as needed
                                            child: Image.network(
                                              productImageUrl2,
                                              width: 300,
                                              height: 200,
                                              fit: BoxFit
                                                  .cover, // Optional: Specify how the image should be fitted within the container
                                            ),
                                          ),
                                          Text(productName2),
                                          Text(
                                            '\$ ${productPrize2.toString()} ',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              CollectionReference collRef =
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'Cartproduct');
                                              collRef.add({
                                                'product_name': productName2,
                                                'product_prize': productPrize2,
                                                'product_url': productImageUrl2,
                                                'useremail': email
                                              });
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color.fromARGB(
                                                          255, 241, 172, 23)),
                                            ),
                                            child: const Text(
                                              'Add to Cart',
                                              style: TextStyle(
                                                  fontSize: 10.0,
                                                  color: Color.fromARGB(
                                                      255, 83, 81, 76)),
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
                Positioned(
                  left: 400, // 40 pixels from the left edge
                  bottom: 160, // Adjust as needed
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/cart", arguments: email);
                    },
                    child: Text('Go To Cart'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 17, 236, 178)),
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
