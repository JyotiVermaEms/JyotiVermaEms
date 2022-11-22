import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

Widget imageViewDialogChat(context, itemData) {
  return AlertDialog(
    title: Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.cancel,
          color: Colors.grey,
          size: 30,
        ),
      ),
    ),
    content: Container(
      width: 800,
      height: 800,
      child: PhotoView(
          backgroundDecoration: BoxDecoration(color: Colors.white),
          imageProvider: NetworkImage(itemData)),
    ),
  );
}

Widget imageViewDialog(context, _currentIndex, itenImgArr) {
  print("object itemData ${itenImgArr.length}");
  print("_currentIndex-=->>$_currentIndex");
  CarouselController carouselController = new CarouselController();
  return StatefulBuilder(builder: (context, setState) {
    // carouselController.animateToPage(_currentIndex);
    return AlertDialog(
      scrollable: true,
      title: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.cancel,
            color: Colors.grey,
            size: 30,
          ),
        ),
      ),
      content: SizedBox(
          width: 600,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 400,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                    // print(_currentIndex);
                  },
                ),
                carouselController: carouselController,
                items: itenImgArr
                    .map<Widget>((item) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: PhotoView(
                              backgroundDecoration:
                                  const BoxDecoration(color: Colors.white),
                              imageProvider: NetworkImage(item)),
                        ))
                    .toList(),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    // textColor: Colors.white,
                    // color: Colors.black,
                    child: Text("Previous"),
                    onPressed: () {
                      carouselController.previousPage();
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  TextButton(
                    // textColor: Colors.white,
                    // color: Colors.black,
                    child: Text("Next"),
                    onPressed: () {
                      carouselController.nextPage();
                    },
                  )
                ],
              ),
            ],
          )),
    );
  });
}

Widget groupChatInfoDialog(context, groupMemberList) {
  return AlertDialog(
    title: Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.cancel,
          color: Colors.grey,
          size: 30,
        ),
      ),
    ),
    content: Container(
        height: 300.0, // Change as per your requirement
        width: 300.0, // Change as per your requirement
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('Gujarat, India'),
            );
          },
        )),
  );
}
