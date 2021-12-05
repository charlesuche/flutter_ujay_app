import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'HomePage.dart';

// https://media.timbu.com/poi/830/unij2-830-5771e3f620c67.jpg?w=300?w=300

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://media.timbu.com/poi/830/unij2-830-5771e3f620c67.jpg?w=300?w=300',
                ),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.7), BlendMode.dstATop),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 80,
                  width: 80,
                  //color: Colors.red,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4L-9Cw2Ksr6gqdtiiVyl7AozPUSVFTzym9Xo5qpGlqkyKUK3QumqUNRGSPwY8jZWYZjs&usqp=CAU',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Stack(children: [
            Container(
              height: 390,
              color: Colors.white,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                      Column(
                        children: [
                          Text(
                            'Quick Search',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 10,
                            ),
                            maxLines: 3,
                            softWrap: true,
                          ),
                          Text(
                              'Don\'t be the freshman\n who needs to ask for\n directions.')
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.navigation_outlined,
                        color: Colors.blue,
                      ),
                      Column(
                        children: [
                          Text(
                            'Navigate',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 10,
                            ),
                            maxLines: 3,
                            softWrap: true,
                          ),
                          Text(
                              'Don\'t be the freshman\n who needs to ask for\n directions.')
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                      Column(
                        children: [
                          Text(
                            'Quick Search',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 10,
                            ),
                            maxLines: 3,
                            softWrap: true,
                          ),
                          Text(
                              'Don\'t be the freshman\n who needs to ask for\n directions.')
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              top: 250,
              left: 70,
              child: ElevatedButton(
                child: Text(
                  'Next',
                  style: TextStyle(
                      fontSize: 30, decoration: TextDecoration.underline),
                ),
                onPressed: () => Get.offAll(
                  () => HomePage(),
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.only(left: 80, right: 80, top: 15, bottom: 15),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.white;
                    return Colors.blue;
                  }),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
