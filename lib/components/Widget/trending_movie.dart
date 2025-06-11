
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:trendveiw/API/api_key.dart';
import 'package:trendveiw/screens/details_page.dart';


class TrendingMovie extends StatelessWidget {
final AsyncSnapshot snapshot;
final String heading;

   const TrendingMovie({
    super.key, required this.snapshot, required this.heading
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      
      child: CarouselSlider.builder(
        itemCount: snapshot.data.length,
        options: CarouselOptions(
          viewportFraction: 0.4,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 2),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
        ),
        itemBuilder: (
          BuildContext context,
          int itemIndex,
          int pageViewIndex,
        ) {
          return GestureDetector(
            onTap: () {
              String imagePath =
                  ApiKey.imageBasePath + snapshot.data[itemIndex].posterPath;
              String title = snapshot.data[itemIndex].title;
              String overView = snapshot.data[itemIndex].overview;
              int id = snapshot.data[itemIndex].id;
              String rating = snapshot.data[itemIndex].voteAverage.toString();
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
              child:SizedBox(
                
                width: 200,
                height: 400,
                child: Image.network(ApiKey.imageBasePath+snapshot.data[itemIndex].posterPath,
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,),
            
              ),
            ),
          );
        },
      ),
    );
  }
}
