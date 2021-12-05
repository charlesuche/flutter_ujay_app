import 'package:flutter/material.dart';

import 'facultyModel.dart';

class FacultyCard extends StatelessWidget {
  const FacultyCard(
      {required this.itemIndex, required this.press, required this.faculty});
  //: super(key: key);

  final int itemIndex;
  final Faculty faculty;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(right: 22.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 0.0,
        child: GestureDetector(
            //onTap: press,
            child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: NetworkImage(faculty.image),
            fit: BoxFit.cover,
            scale: 2.0,
          )),
          width: 200.0,
          child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          faculty.title.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                      ],
                    ),
                  )
                ],
              )),
        )));
  }
}
