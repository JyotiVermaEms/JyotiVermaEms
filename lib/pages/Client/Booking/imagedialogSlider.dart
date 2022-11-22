import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageSilder extends StatefulWidget {
  var item;
  ImageSilder(this.item);

  @override
  _ImageSilder createState() => _ImageSilder();
}

class _ImageSilder extends State<ImageSilder> {
  int _currentIndex = 0;

  Widget build(BuildContext context) {
    print("-=-==-==-=7${widget.item}");
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
          child: CarouselSlider(
            options: CarouselOptions(
              enableInfiniteScroll: false,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
                //print(_currentIndex);
              },
            ),
            items: widget.item
                .map<Widget>((item) => PhotoView(
                    backgroundDecoration: BoxDecoration(color: Colors.white),
                    imageProvider: NetworkImage(widget.item)))
                .toList(),
          )),
    );
  }
}
