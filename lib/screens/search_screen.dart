import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendveiw/API/api_call.dart';
import 'package:trendveiw/components/Widget/movie_slide.dart';
import 'package:trendveiw/model/movie_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<Movie>>? searchResults;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color:
                theme.brightness == Brightness.dark
                    ? const Color.fromRGBO(30, 30, 30, 1)
                    : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: _searchController,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Search movies...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.iconTheme.color?.withOpacity(0.5),
              ),
              border: InputBorder.none,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    searchResults = ApiCall().searchMovies(
                      _searchController.text,
                    );
                  });
                },
                icon: Icon(Icons.search),
                color: theme.iconTheme.color?.withOpacity(0.7),
              ),
            ),
            onSubmitted: (query) {
              if (query.isNotEmpty) {
                setState(() {
                  searchResults = ApiCall().searchMovies(query.trim());
                });
              }
            },
          ),
        ),
      ),
      body:
          searchResults == null
              ? Center(
                child: Text(
                  'Search for movies',
                  style: GoogleFonts.aBeeZee(
                    color: Colors.pinkAccent,
                    fontSize: 24,
                  ),
                ),
              )
              : FutureBuilder(
                future: searchResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    // ignore: avoid_print
                    print('search results: ${snapshot.data}');
                    // ignore: avoid_print
                    print('Number of results: ${snapshot.data!.length}');
                    if (snapshot.data!.isEmpty) {
                      return Text('No movies found');
                    } else {
                      return MovieSlide(
                        heading: 'Search Results',
                        snapshot: snapshot,
                      );
                    }
                  } else if (snapshot.hasError) {
                    // ignore: avoid_print
                    print('Error:${snapshot.error}');
                    return Text('Error:${snapshot.error}');
                  } else {
                    // ignore: avoid_print
                    print('Unknown error');
                    return Text('Unknown error');
                  }
                },
              ),
    );
  }
}
