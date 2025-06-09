import 'package:flutter/material.dart';
import 'package:trendveiw/API/api_key.dart';
import 'package:trendveiw/screens/details_page.dart';


class MovieSlide extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final String heading;

  const MovieSlide({super.key, required this.snapshot, required this.heading});

  @override
  State<MovieSlide> createState() => _MovieSlideState();
}

class _MovieSlideState extends State<MovieSlide> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              String imagePath =
                  ApiKey.imageBasePath + widget.snapshot.data[index].posterPath;
              String title = widget.snapshot.data[index].title;
              String overView = widget.snapshot.data[index].overview;
              String rating = widget.snapshot.data[index].voteAverage.toString();
              String heading = widget.heading;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => Details(
                        heading: heading,
                        title: title,
                        imagePath: imagePath,
                        overView: overView,
                        rating: rating,
                      ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 200,
                  height: 300,
                  child: Image.network(
                    ApiKey.imageBasePath +
                        widget.snapshot.data[index].posterPath,
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
