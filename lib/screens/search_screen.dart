import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendveiw/API/api_call.dart';
import 'package:trendveiw/components/Widget/movie_slide.dart';
import 'package:trendveiw/model/movie_model.dart';
import 'package:trendveiw/components/util/dialog_box.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Controller to manage the search input field
  final TextEditingController searchController = TextEditingController();

  // Holds the future result from the API call
  Future<List<Movie>>? searchResults;

  @override
  Widget build(BuildContext context) {
    // Get current theme data for styling based on light/dark mode
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
            controller: searchController,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Search movies...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.iconTheme.color?.withAlpha(140),
              ),
              border: InputBorder.none,
              suffixIcon: IconButton(
                // Trigger search when search icon is pressed
                onPressed: () {
                  final query = searchController.text.trim();
                  if (query.isEmpty) return;

                  try {
                    // Call search API and update the UI
                    setState(() {
                      searchResults = ApiCall().searchMovies(query);
                    });
                  } catch (e) {
                    // Show error dialog if search fails
                    DialogBox.showErrorDialog(
                      context,
                      'Something went wrong during search',
                    );
                  }
                },
                icon: Icon(Icons.search),
                color: theme.iconTheme.color?.withAlpha(140),
              ),
            ),
            // Trigger search when the user submits via keyboard
            onSubmitted: (query) {
              if (query.isNotEmpty) {
                try {
                  setState(() {
                    searchResults = ApiCall().searchMovies(query.trim());
                  });
                } catch (e) {
                  DialogBox.showErrorDialog(
                    context,
                    'Something went wrong during search',
                  );
                }
              }
            },
          ),
        ),
      ),

      // Main body: shows message, loading, results, or error
      body:
          searchResults == null
              // Show message before any search is performed
              ? Center(
                child: Text(
                  'Search for movies',
                  style: GoogleFonts.aBeeZee(
                    color: Colors.pinkAccent,
                    fontSize: 24,
                  ),
                ),
              )
              // Handle future data from the search API
              : FutureBuilder(
                future: searchResults,
                builder: (context, snapshot) {
                  // Show loading spinner while waiting for data
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // When data is received
                  else if (snapshot.hasData) {
                    // Show message if no movies match the query
                    if (snapshot.data!.isEmpty) {
                      return const Text('No movies found');
                    } else {
                      // Show search results using custom MovieSlide widget
                      return MovieSlide(
                        heading: 'Search Results',
                        snapshot: snapshot,
                      );
                    }
                  }
                  // If there's an error, show it using a dialog
                  else if (snapshot.hasError) {
                    DialogBox.showErrorDialog(
                      context,
                      'An error occurred: ${snapshot.error}',
                    );
                    return const SizedBox(); // Return empty widget after dialog
                  }
                  // Fallback for unknown error states
                  else {
                    DialogBox.showErrorDialog(
                      context,
                      'Unknown error occurred during search.',
                    );
                    return const SizedBox(); // Return empty widget after dialog
                  }
                },
              ),
    );
  }
}
