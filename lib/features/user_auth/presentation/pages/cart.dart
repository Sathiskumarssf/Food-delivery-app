import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  late List<int> counterValues ; // List to store counter values for each item

  @override
  void initState() {
    super.initState();
    counterValues = [1]; // Initialize the counter values list
  }

  void _incrementCounter(int index) {
    setState(() {
      counterValues[
          index]++; // Increment the counter value at the specified index
    });
  }

 void _removeProduct(String email,String productName) async {
    await FirebaseFirestore.instance
        .collection('Cartproduct')
        .where('useremail', isEqualTo:  email)
        .where('product_name', isEqualTo: productName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }
 

  void _decrementCounter(int index) {
    if (counterValues[index] > 0) {
      setState(() {
        counterValues[
            index]--; // Decrement the counter value at the specified index
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String;
    int totalamount = 0; // Initialize total amount to 0

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Cart"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Cartproduct')
              .where('useremail', isEqualTo: email)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> data =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                // Initialize counter value for each item if not already initialized
                if (counterValues.length <= index) {
                  counterValues.add(0);
                }

                totalamount += (data['product_prize'] as int) *
                    counterValues[index]; // Calculate total amount
             
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              data['product_url'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Text(
                                data['product_name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ('\$'+data['product_prize'].toString() ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _incrementCounter(
                                        index), // Pass index to _incrementCounter
                                    child: Text('+'),
                                  ),
                                  Text( '${counterValues[index]}',
                                  style: TextStyle(fontSize: 20.0),), // Use counter value from the list
                                  ElevatedButton(
                                    onPressed: () => _decrementCounter(
                                        index), // Pass index to _incrementCounter
                                    child: Text('-'),
                                  ),
                                ],
                              ),

                              ElevatedButton(
                                  onPressed: () => _removeProduct(email, data['product_name']),
                                  child: Icon(Icons.delete), // Use delete icon as child
                                )

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: 16.0,
            bottom: 16.0,
            child: ElevatedButton(
              onPressed: () {
                // Implement functionality for the left floating button
                Navigator.pushNamed(context, "/home", arguments: email);
              },
              child: Text('home'),
            ),
          ),
          Positioned(
            right: -5.0,
            bottom: 16.0,
            child: ElevatedButton(
              onPressed: () {
                // Implement functionality for the right floating button
                Navigator.pushNamed(context, "/checkout", arguments: totalamount);
              },
              child: Text('Checkout'),
            ),
          ),


        ],

        
      ),
    );
  }
}
