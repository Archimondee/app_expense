import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<Transaction> transaction = [
    Transaction(
        id: '1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    Transaction(id: '2', title: 'New Bag', amount: 50.00, date: DateTime.now()),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter App'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              child: Container(
                child: Text('Chart'),
                width: double.infinity,
                height: 100,
              ),
              color: Colors.blue,
              elevation: 5,
            ),
            Column(
              children: transaction.map((tx) {
                return Card(
                    child: Row(
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Text(
                        tx.amount.toString(),
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                    Column(
                      children: <Widget>[
                        Text(tx.title),
                        Text(
                          tx.date.toString(),
                        ),
                      ],
                    )
                  ],
                ));
              }).toList(),
            )
          ],
        ));
  }
}
