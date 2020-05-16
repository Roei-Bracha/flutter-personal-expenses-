import 'dart:math';

import 'package:flutter/material.dart';
import 'package:personal_expenses/widgets/Chart.dart';
import 'package:personal_expenses/widgets/NewTransaction.dart';
import 'package:personal_expenses/widgets/TransactionList.dart';

import 'models/trasaction.dart';

void main() {
  // allow only portrait, dont allow the user to rottate the device
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18 * MediaQuery.textScaleFactorOf(context),
                fontWeight: FontWeight.bold),
            button: TextStyle(color: Colors.white)),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20 * MediaQuery.textScaleFactorOf(context),
                    fontWeight: FontWeight.bold),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
        id: 't1',
        title: 'New shoes',
        amount: 69.99,
        date: DateTime.now().subtract(Duration(days: 1))),
    Transaction(
        id: 't2',
        title: 'Weekly Groceries',
        amount: 16.53,
        date: DateTime.now().subtract(Duration(days: 2))),
  ];
  bool _showChart = true;
  void _addNewTrasaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
        amount: amount, date: date, id: Random().toString(), title: title);
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return NewTransaction(_addNewTrasaction);
        });
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where((element) =>
            element.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  void toggleChart(bool val) {
    setState(() {
      _showChart = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text("Personal Expanse"),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _startAddNewTransaction(context);
            })
      ],
    );
    final _isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final txList = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            (_isLandscape ? 1 : 0.7),
        child: TransactionList(_userTransactions, _deleteTransaction));
    
    return Scaffold(
      appBar: appBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _startAddNewTransaction(context);
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (_isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Show Chart'),
                  Switch(value: _showChart, onChanged: toggleChart)
                ],
              ),
              if(!_isLandscape)Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        (0.25),
                    child: Chart(_recentTransactions)),
                  if(!_isLandscape)  txList,
            if (_isLandscape) _showChart
                ? Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        (0.8),
                    child: Chart(_recentTransactions))
                : txList,
          ],
        ),
      ),
    );
  }
}
