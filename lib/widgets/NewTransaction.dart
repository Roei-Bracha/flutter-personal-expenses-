import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleControler = TextEditingController();
  final amountControler = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void submitData() {
    final String enteredTitle = titleControler.text;
    final double enteredAmount = double.parse(amountControler.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate==null) {
      return;
    }
    widget.addTx(enteredTitle, enteredAmount,_selectedDate);
    Navigator.of(context).pop(); // close the modal on submit
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((value) {
      if (value != null) {
        setState(() {
          _selectedDate = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // avoid keyboard interupt
          child: Card(
        elevation: 5,
        child: Container(
          // avoid keyboard interupt
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleControler,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountControler,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => {submitData()},
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Text(_selectedDate == null ?'No Date Chosen' : DateFormat.yMd().format(_selectedDate)),
                    FlatButton(
                      onPressed: _presentDatePicker,
                      child: Text('Choose Date'),
                      textColor: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
              RaisedButton(
                onPressed: submitData,
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                child: Text('AddTransaction'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
