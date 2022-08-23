import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final details;
  const Details({Key? key, required this.details}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState(details: this.details);
}

class _DetailsState extends State<Details> {
  var details;
  _DetailsState({required this.details});

  List<Widget> getList() {
    var children = <Widget>[];
    for (var i = 0; i < details.length; i++) {
      //print(details.dictionary(i).string('sub_heading'));
      if (details.dictionary(i).string('sub_heading') != null) {
        children.add(Text(
          details.dictionary(i).string('sub_heading'),
          style: TextStyle(fontWeight: FontWeight.bold),
        ));
      }

      children.add(Text(details.dictionary(i).string('data')));
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: getList(),
        ),
      ),
    );
  }
}
