import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spandingAmount;
  final double spandingPctOfTotal;
  ChartBar(this.label, this.spandingAmount, this.spandingPctOfTotal, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(height:20,child: FittedBox(child: Text('\$${spandingAmount.toStringAsFixed(0)}'))),
          Container(
            height: 60,
            width: 10,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10)),
                ),
                FractionallySizedBox(
                  heightFactor: spandingPctOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          Text(label)
        ],
      ),
    );
  }
}
