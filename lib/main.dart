// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/models/transaction.dart';
import 'package:flutter_complete_guide/widgets/chart.dart';
import 'package:flutter_complete_guide/widgets/new_transaction.dart';
import 'package:flutter_complete_guide/widgets/transaction_list.dart';

void main() => {
      // WidgetsFlutterBinding.ensureInitialized(),
      // SystemChrome.setPreferredOrientations(
      //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]),
      runApp(MyApp()),
    };

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  final List<Transaction> _userTransaction = [
    // Transaction(
    //   id: '1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: '2',
    //   title: 'New Bag',
    //   amount: 50.99,
    //   date: DateTime.now(),
    // )
  ];

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime dateTime) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: dateTime,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Flutter App'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                    onTap: () => _startAddNewTransaction(context),
                    child: Icon(CupertinoIcons.add))
              ],
            ),
          )
        : AppBar(
            title: Text('Flutter App'),
            actions: <Widget>[
              IconButton(
                  onPressed: () => _startAddNewTransaction(context),
                  icon: Icon(Icons.add))
            ],
          );
    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransaction, _deleteTransaction));
    final bodyWidget = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Show Chart'),
                  Switch(
                      activeColor: Theme.of(context).primaryColor,
                      value: _showChart,
                      onChanged: (val) {
                        setState(
                          () {
                            _showChart = val;
                          },
                        );
                      }),
                ],
              ),
            if (!isLandscape)
              Container(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.3,
                  child: Chart(_recentTransactions)),
            if (!isLandscape) txListWidget,
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions))
                  : txListWidget
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: bodyWidget,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyWidget,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
