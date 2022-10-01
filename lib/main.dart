import 'package:flutter/material.dart';
import 'package:finance_tools/deduplicate.dart';
void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      "/": (context) => Home(),
      "/dedup": (context) => Deduplicate(),
    },
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Finance Tools"),
        elevation: 0.0,
        surfaceTintColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Deduplication Tool",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    letterSpacing: 1.0
                                )),
                          ),
                          TextButton(onPressed: () {
                            Navigator.pushNamed(context, '/dedup');
                          }, child: Text('Open'))
                        ],
                      ),
                    ),
              )]
                ),
        )
            )
    );
  }
}




