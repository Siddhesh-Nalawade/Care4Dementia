import 'package:care_for_dementia/widgets/details.dart';

import 'package:flutter/material.dart';

class SectionsList extends StatefulWidget {
  final options;
  const SectionsList({Key? key, required this.options}) : super(key: key);

  @override
  State<SectionsList> createState() =>
      _SectionsListState(options: this.options);
}

class _SectionsListState extends State<SectionsList> {
  final options;

  _SectionsListState({required this.options});

  getTitle(var index) {
    print('4');
    try {
      if (options.dictionary(index).dictionary('attributes').string('title') !=
          null) {
        return options
            .dictionary(index)
            .dictionary('attributes')
            .string('title');
      }
      if (options.dictionary(index).dictionary('attributes').string('title') ==
          null) {
        if (options.dictionary(index).string('heading') != null) {
          return options.dictionary(index).string('heading');
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Details(
                  details: options.dictionary(index).array('sub_section'),
                ),
              ),
            );
          });
        }
      }
    } catch (e) {
      if (options.dictionary(index).string('heading') != null) {
        return options.dictionary(index).string('heading');
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Details(
                details: options.dictionary(index).array('sub_section'),
              ),
            ),
          );
        });
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 500,
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (BuildContext ctx, int value) {
                return Card(
                  child: ListTile(
                    title: Text(
                      getTitle(value),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: (() {
                      try {
                        if (options
                                .dictionary(value)
                                .dictionary('attributes')
                                .dictionary('care_4_dementia_sections') !=
                            null) {
                          print('1');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SectionsList(
                                options: options
                                    .dictionary(value)
                                    .dictionary('attributes')
                                    .dictionary('care_4_dementia_sections')
                                    .array('data'),
                              ),
                            ),
                          );
                        } else if (options
                                .dictionary(value)
                                .dictionary('attributes')
                                .array('section') !=
                            null) {
                          print('2');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SectionsList(
                                options: options
                                    .dictionary(value)
                                    .dictionary('attributes')
                                    .array('section'),
                              ),
                            ),
                          );
                        } else {
                          print('3');

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Details(
                                details: options
                                    .dictionary(value)
                                    .dictionary('attributes')
                                    .array('sub_section'),
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        print('hii');
                        try {
                          if (options
                                  .dictionary(value)
                                  .dictionary('attributes')
                                  .array('sub_section') !=
                              null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Details(
                                  details: options
                                      .dictionary(value)
                                      .dictionary('attributes')
                                      .array('sub_section'),
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Details(
                                details: options
                                    .dictionary(value)
                                    .array('sub_section'),
                              ),
                            ),
                          );
                        }
                      }
                    }),
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
