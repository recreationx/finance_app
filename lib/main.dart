import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      useMaterial3: true,
    ),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController codeController = TextEditingController();
  TextEditingController supController = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  late String itemCode;
  late String supplier;
  late int quantity;
  List data = [];

  List<DataRow> populateRows() {
    List<DataRow> rows = [];
    data.forEach((element) {
      rows.add(DataRow(
        cells: [
          DataCell(Text(element[0])),
          DataCell(Text(element[1])),
          DataCell(Text(element[2].toString()))
        ]
      ));

    });
    return rows;
  }
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
  }

  String validate() {
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(columns: [
                    DataColumn(label: Text('Item Code')),
                    DataColumn(label: Text('Supplier')),
                    DataColumn(label: Text('Quantity'))
                  ], rows: populateRows()),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}


