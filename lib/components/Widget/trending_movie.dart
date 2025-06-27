import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:trendveiw/API/api_key.dart';
import 'package:trendveiw/screens/details_page.dart';

// This widget displays trending movies in a horizontal auto-playing carousel.
class TrendingMovie extends StatelessWidget {
  // properties of the class

  // The list of movies (snapshot from API)
  final AsyncSnapshot snapshot;

  // Heading or category name to display on the details page
  final String heading;

  // initializing the properties
  const TrendingMovie({
    super.key,
    required this.snapshot,
    required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,

      child: CarouselSlider.builder(
        // Total number of movies
        itemCount: snapshot.data.length,
        options: CarouselOptions(
          // How much of each item to show
          viewportFraction: 0.4,
          // Enable auto-play
          autoPlay: true,
          // Delay between slides
          autoPlayInterval: Duration(seconds: 2),
          // Animation curve
          autoPlayCurve: Curves.fastOutSlowIn,
          // Enlarge the center movie item
          enlargeCenterPage: true,
        ),
        // Builder for each movie item in the carousel
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
          return GestureDetector(
            // When a movie is tapped, navigate to the Details screen
            onTap: () {
              // Get movie details from snapshot
              String imagePath =
                  ApiKey.imageBasePath + snapshot.data[itemIndex].posterPath;
              String title = snapshot.data[itemIndex].title;
              String overView = snapshot.data[itemIndex].overview;
              int id = snapshot.data[itemIndex].id;
              String rating = snapshot.data[itemIndex].voteAverage.toString();

              // Navigate to the Details screen with the selected movie info
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

            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 200,
                height: 400,
                child: Image.network(
                  // Display the movie poster
                  ApiKey.imageBasePath + snapshot.data[itemIndex].posterPath,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
