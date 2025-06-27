import 'package:flutter/material.dart';
import 'package:trendveiw/API/api_key.dart';
import 'package:trendveiw/screens/details_page.dart';

// A horizontal movie slider widget that displays movie posters
// and navigates to a details page when a poster is tapped.
class MovieSlide extends StatefulWidget {
  // properties of the class

  // Holds the async snapshot of fetched movie data
  final AsyncSnapshot snapshot;

  // Heading/category title (e.g., Trending, Top Rated)
  final String heading;

  // initializing the properties
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
        // Adds bounce effect on scroll
        physics: BouncingScrollPhysics(),
        // Scroll horizontally
        scrollDirection: Axis.horizontal,
        // Number of movie items
        itemCount: widget.snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // Extract data from snapshot
              String imagePath =
                  ApiKey.imageBasePath + widget.snapshot.data[index].posterPath;
              String title = widget.snapshot.data[index].title;
              String overView = widget.snapshot.data[index].overview;
              int id = widget.snapshot.data[index].id;
              String rating =
                  widget.snapshot.data[index].voteAverage.toString();
              String heading = widget.heading;
              // Navigate to the movie details page
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
                        id: id,
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
