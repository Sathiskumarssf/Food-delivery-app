import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late TextEditingController cardNumberController;
  late TextEditingController cvcController;
  late TextEditingController expiryDateController;
  String? selectedCardType;

  @override
  void initState() {
    super.initState();
    cardNumberController = TextEditingController();
    cvcController = TextEditingController();
    expiryDateController = TextEditingController();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    cvcController.dispose();
    expiryDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as int?;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('You need to pay total amount: $args'),
              const SizedBox(height: 20),
              ClipRRect(
                  borderRadius: BorderRadius.circular(
                      10), // Set the border radius as needed
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDeNma8sLmVhutW1rIpt2rtq0j6VytHzuIvA&s',
                    width: 350,
                    height: 200,
                    fit: BoxFit
                        .cover, // Optional: Specify how the image should be fitted within the container
                  )),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedCardType,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCardType = newValue;
                   
                  });
                },
                items: <String>['Visa', 'MasterCard', 'DebitCard']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Card Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: cvcController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'CVC',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: expiryDateController,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date (MM/YY)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (cardNumberController.text.trim() != '' &&
                      (selectedCardType != null) &&
                      cvcController.text.trim() != '' &&
                      expiryDateController.text.trim() != '') {
                    if (cardNumberController.text.length != 16) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('  wrong Card number'),
                        ),
                      );
                    }

                    if (cvcController.text.length < 3 ||
                        cvcController.text.length > 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('CVC number wrong'),
                        ),
                      );
                    }

                    

                    if ((cardNumberController.text.length == 16) &&
                        ((cvcController.text.length == 3) ||
                            (cvcController.text.length == 4))) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.green[100],
                            title: const Text('Payment successfully credited'),
                            content: const Text(
                                'You will get the product in 3 days.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {

                     if(selectedCardType == null){
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Card type should be select'),
                        ),
                      );
                    } 
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All inputs are required'),
                      ),
                    );
                    
                  
                  }
                },
                child: Text('Pay Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
