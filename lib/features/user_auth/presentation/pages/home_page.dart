import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/features/user_auth/presentation/pages/admin.dart';
import 'package:my_flutter_app/features/user_auth/presentation/pages/cart.dart';
import 'package:my_flutter_app/features/user_auth/presentation/widgets/form_container_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchController;
  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _stream =
        FirebaseFirestore.instance.collection('product_details').snapshots();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> searchItems(String searchText) async {
    if (searchText.trim().isNotEmpty) {
      setState(() {
        _stream = FirebaseFirestore.instance
            .collection('product_details')
            .where('product_name', isGreaterThanOrEqualTo: searchText.trim())
            .where('product_name',
                isLessThanOrEqualTo: searchText.trim() + '\uf8ff')
            .snapshots();
      });
    } else {
      setState(() {
        _stream = FirebaseFirestore.instance
            .collection('product_details')
            .snapshots();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
     final args = ModalRoute.of(context)!.settings.arguments as String?;
    final email =
        args ?? "No Email Provided";
    // var email = "asarakmal@gmail.com";
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text("Welcome to Pizza Bank"),
        backgroundColor: const Color.fromARGB(255, 211, 211, 211),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "All type of pizza avalible!!",
                      style: TextStyle(
                          color: Color.fromARGB(255, 88, 209, 92),
                          fontSize: 20.0),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.green[100],
                              title: const Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.email), // Icon widget
                                          SizedBox(width: 8), // Optional: Add spacing between icon and text
                                          Text('pizzabank12@gmail.com ' ,style: TextStyle(fontSize: 20.0),),
                                          SizedBox(width: 8),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.phone), // Icon widget
                                          SizedBox(width: 8), // Optional: Add spacing between icon and text
                                          Text('+94 75969634',style: TextStyle(fontSize: 20.0))
                                        ],
                                      ),
                                                                            
                                    ],
                                  ),
                                   
                              content:const Text("Any time you can contect don't hesitate to contact us"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.contact_emergency),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: FormContainerWidget(
                            controller: _searchController,
                            hintText: "search",
                            onFieldSubmitted: (email) {
                              searchItems(_searchController.text);
                            },
                            onchanged: (email) {
                              searchItems(_searchController.text);
                            },
                            isPasswordField: false,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            searchItems(_searchController.text);
                          },
                          child: const Icon(Icons.search),
                          style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(Size(30.0, 45.0)),
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 214, 213, 211)),
                            alignment: Alignment.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        print('Snapshot data: $snapshot');
                        final List<DocumentSnapshot> documents =
                            snapshot.data!.docs;
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            int dataIndex = index * 2;
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
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4.0),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              productImageUrl1,
                                              width: 600,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Text(productName1),
                                          Text(
                                            '\$ ${productPrize1.toString()} ',
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
                                                'useremail': email,
                                              });

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      '$productName1 is add into the card'),
                                                ),
                                              );
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                const Color.fromARGB(
                                                    255, 241, 172, 23),
                                              ),
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
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4.0),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              productImageUrl2,
                                              width: 300,
                                              height: 200,
                                              fit: BoxFit.cover,
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
                                                'useremail': email,
                                              });

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      '$productName2 is add into the card'),
                                                ),
                                              );
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                const Color.fromARGB(
                                                    255, 241, 172, 23),
                                              ),
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
                  left: 400,
                  bottom: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/cart", arguments: email);
                    },
                    child: const Text('Go To Cart'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 17, 236, 178),
                      ),
                    ),
                  ),
                ),
                Text(email),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
