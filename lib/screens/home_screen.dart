import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<String> categories = [
    'Trending',
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Sci-Fi',
  ];

  final List<Map<String, String>> movies = [
    {'title': 'Movie 1', 'image': 'https://via.placeholder.com/150x225'},
    {'title': 'Movie 2', 'image': 'https://via.placeholder.com/150x225'},
    {'title': 'Movie 3', 'image': 'https://via.placeholder.com/150x225'},
    {'title': 'Movie 4', 'image': 'https://via.placeholder.com/150x225'},
    {'title': 'Movie 5', 'image': 'https://via.placeholder.com/150x225'},
    {'title': 'Movie 6', 'image': 'https://via.placeholder.com/150x225'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
        elevation: 0,
        title: Text(
          'TrendVeiw',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.pinkAccent,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(30, 30, 30, 1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  icon: const Icon(Icons.search, color: Colors.white54),
                  hintText: 'Search movies...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Categories horizontal list
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return Chip(
                    label: Text(
                      categories[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.pinkAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Movies grid
            Expanded(
              child: GridView.builder(
                itemCount: movies.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movie poster
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            movie['image']!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Movie title
                      Text(
                        movie['title']!,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
