import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  late List<int> counterValues; // List to store counter values for each item

  @override
  void initState() {
    super.initState();
    counterValues = [1]; // Initialize the counter values list
  }

  void _incrementCounter(int index) {
        
      setState(() {
        counterValues[index]++; // Increment the counter value at the specified index
      });

  }
  void _decrementCounter(int index) {
  if (counterValues[index] > 0) {
    setState(() {
      counterValues[index]--; // Decrement the counter value at the specified index
    });
  }
}


  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Cart"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Cartproduct')
              .where('useremail', isEqualTo: email)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                data['product_prize'].toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _incrementCounter(index), // Pass index to _incrementCounter
                                    child: Text('+'),
                                  ),
                                  Text('${counterValues[index]}'), // Use counter value from the list
                                   ElevatedButton(
                                    onPressed: () => _decrementCounter(index), // Pass index to _incrementCounter
                                    child:  Text('-'),
                                  ),
                                ],
                              ),
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
                // Implement functionality for the right floating button
                Navigator.pushNamed(context, "/home", arguments: email);
              },
              child: Text('home'),
            ),
          ),
          Positioned(
            right: 16.0,
            bottom: 16.0,
            
             child: ElevatedButton(
              onPressed: () {
               Navigator.pushNamed(context, "/home", arguments: email);
              },
              child: Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
