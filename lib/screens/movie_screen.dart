import 'package:flutter/material.dart';
import 'package:trendveiw/API/api_key.dart';
import 'package:trendveiw/screens/details_page.dart';

class MovieScreen extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final String heading;
  final int futureindex;

  const MovieScreen({
    super.key,
    required this.snapshot,
    required this.heading,
    required this.futureindex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
title: Text(heading),

      ),// RGBA(18, 18, 18, 1)
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: snapshot.data[futureindex].length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 18,
              crossAxisSpacing: 18,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final movie = snapshot.data[futureindex][index];
              final imagePath = ApiKey.imageBasePath + movie.posterPath;
              final title = movie.title;


          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie poster
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    String imagePath =
                  ApiKey.imageBasePath + snapshot.data[futureindex][index].posterPath;
              String title = snapshot.data[futureindex][index].title;
              String overView = snapshot.data[futureindex][index].overview;
              int id = snapshot.data[futureindex][index].id;
              String rating = snapshot.data[futureindex][index].voteAverage.toString();
              
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
                  );},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(imagePath),
                  ),
                ),
              ),

                  const SizedBox(height: 8),

                  // Movie Title
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
