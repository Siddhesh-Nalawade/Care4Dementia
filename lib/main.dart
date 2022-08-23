import 'dart:convert';
import 'package:care_for_dementia/widgets/sections_list.dart';
import 'package:cbl/cbl.dart';
import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final String demoDataResponse =
      await rootBundle.loadString('assets/demo_data.json');
  final demoData = await json.decode(demoDataResponse);

  await CouchbaseLiteFlutter.init();
  late AsyncDatabase database;
  database = await Database.openAsync('tempDB');
  database.delete();
  database = await Database.openAsync('tempDB');
  final doc = MutableDocument.withId('c4d', demoData['data']['attributes']);
  await database.saveDocument(doc);

  await database.createIndex(
    'overviewFTSIndex',
    FullTextIndexConfiguration(
      ['app_name'],
      language: FullTextLanguage.english,
    ),
  );

  // var queryString = 'Aggressive behaviours';
  // final query = await Query.fromN1ql(
  //   database,
  //   r'''
  //   SELECT mainCategoryName FROM _ WHERE MATCH(overviewFTSIndex,'Bite or spit') ORDER BY RANK(overviewFTSIndex)
  //   ''',
  // );

  // Query parameters are defined by prefixing an identifier with `$`.
  // await query.setParameters(Parameters({'query': '$queryString*'}));

  // Each time a query is executed, its results are returned in a ResultSet.
  // final resultSet = await query.execute();

  // // To create the NoteSearchResults, we turn the ResultSet into a stream
  // // and collect the results into a List, after transforming them into
  // // NoteSearchResults.
  // var result =
  //     await resultSet.asStream().map((event) => event.toPlainMap()).toList();
  // print(result);
  runApp(MaterialApp(
    title: 'Care For Dementia',
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var db;
  var doc;

  Future<void> getData() async {
    var temp_db = await Database.openAsync('tempDB');
    var temp_doc = await temp_db.document('c4d');
    setState(() {
      db = temp_db;
      doc = temp_doc;
    });
  }

  @override
  void initState() {
    // getData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 13, 60, 98),
        leading: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Icon(
            Icons.arrow_back,
            size: 35,
          ),
        ),
        title: Container(
          height: 35,
          child: TextField(
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: 'enter symptom',
              filled: true,
              fillColor: Colors.white,
              suffixIcon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Icon(
              Icons.home,
              size: 40,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromARGB(255, 13, 60, 98),
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  color: Color.fromARGB(255, 85, 65, 151),
                  child: Center(
                    child: Text(
                      doc.string('app_name'),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: 5,
                  color: Color.fromARGB(255, 155, 73, 26),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  height: 125,
                  color: Colors.white,
                  child: Text(
                    doc.string('app_description'),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 250, left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: ListView.builder(
              itemCount: doc.array('sub_category').length,
              itemBuilder: (BuildContext ctx, int value) {
                return Card(
                  child: ListTile(
                    title: Text(
                      "${doc.array('sub_category').dictionary(value).string('title')}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      var collection_name = doc
                          .array('sub_category')
                          .dictionary(value)
                          .string('collection_name');

                      // print(doc.dictionary(collection_name).array('data'));
                      if (doc
                              .array('sub_category')
                              .dictionary(value)
                              .string('collection_name') ==
                          'care_4_dementia_gcsps') {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Details(
                                details: doc
                                    .dictionary(collection_name)
                                    .array('data')
                                    .dictionary(0)
                                    .dictionary('attributes')
                                    .array('sub_section'))));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SectionsList(
                                options: doc
                                    .dictionary(collection_name)
                                    .array('data'))));
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
