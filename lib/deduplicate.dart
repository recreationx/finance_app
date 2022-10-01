import 'package:flutter/material.dart';

class Deduplicate extends StatefulWidget {
  const Deduplicate({Key? key}) : super(key: key);

  @override
  State<Deduplicate> createState() => _DeduplicateState();
}

class _DeduplicateState extends State<Deduplicate> {
  TextEditingController codeController = TextEditingController();
  TextEditingController supController = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  late String itemCode;
  late String supplier;
  late int quantity;
  List data = [];

  showAlertDialog(BuildContext context, message) {
    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("$message"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void clearFields() {
    codeController.clear();
    supController.clear();
    qtyController.clear();
    itemCode = "";
    supplier = "";
    quantity = 0;
  }

  String validate() {
    if (itemCode == "" || supplier == "" || itemCode == 0) {
      return "Invalid data.";
    }
    for (var i=0; i < data.length; i++) {
      if (itemCode == data[i][0] && supplier == data[i][1]) {
        var old_data = data[i];
        data.insert(0, [itemCode, supplier, quantity + data[i][2]]);
        data.remove(old_data);
        return "Item $itemCode from supplier $supplier incremented.";
      } else if (itemCode == data[i][0] && supplier != data[i][1]){
        return "Item from ${data[i][1]} already exists. "
            "Conflict between selected supplier $supplier "
            "and existing supplier ${data[i][1]}.";
      }
    }
    data.insert(0, [itemCode, supplier, quantity]);
    return "Added item $itemCode from supplier $supplier.";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          appBar: AppBar(
              title: Text('Deduplication'),
              surfaceTintColor: Colors.white,
              elevation: 0.0,
              actions: [
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        showAlertDialog(context, "Deduplication Tool made by zn");
                      },
                      child: Icon(
                          Icons.info
                      ),
                    )
                ),
              ]
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 10.0),
                TextField(
                  controller: codeController,
                  onChanged: (text) {
                    itemCode = text;
                  },
                  decoration: InputDecoration(
                      icon: Icon(Icons.code),
                      border: OutlineInputBorder(),
                      labelText: 'Item Code'
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: supController,
                  onChanged: (text) {
                    supplier = text;
                  },
                  decoration: InputDecoration(
                      icon: Icon(Icons.shop),
                      border: OutlineInputBorder(),
                      labelText: 'Supplier'
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: qtyController,
                  onChanged: (text) {
                    quantity = int.parse(text);
                  },
                  decoration: InputDecoration(
                      icon: Icon(Icons.numbers),
                      border: OutlineInputBorder(),
                      labelText: 'Quantity'
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          setState(() {
                            String message = validate();
                            showAlertDialog(context, message);
                            clearFields();
                          });
                        },
                        child: Text('Add',
                            style: TextStyle(
                                fontSize: 20.0
                            ))),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            data.clear();
                          });
                        },
                        child: Text('Clear',
                            style: TextStyle(
                                fontSize: 20.0
                            ))),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          surfaceTintColor: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                  leading: Icon(Icons.shopping_bag),
                                  title: Text(data[index][0]),
                                  subtitle: Text(data[index][1]),
                                  trailing: Text(data[index][2].toString(),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ))
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(onPressed: () {
                                    setState(() {
                                      data.remove(data[index]);
                                    });
                                  }, child: Text('Remove'))
                                ],
                              )
                            ],
                          )
                      );
                    },
                    itemCount: data.length,
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}