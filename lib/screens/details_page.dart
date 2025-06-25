import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendveiw/API/api_call.dart';
import 'package:trendveiw/components/dialog_box.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Details extends StatefulWidget {
  // properties for this class
  final String heading;
  final int id;
  final String title;
  final String imagePath;
  final String overView;
  final String rating;
  final String? releaseDate;
  final String? genre;
  final String? duration;

  // initializing the properties
  const Details({
    super.key,
    required this.title,
    required this.imagePath,
    required this.overView,
    required this.heading,
    required this.rating,
    required this.id,
    this.releaseDate,
    this.genre,
    this.duration,
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  // Fetches the video key for the movie using the movie ID passed to this screen
  late Future<String> movieKey = ApiCall().getMoviesVideo(widget.id);

  // Tracks whether the current movie is marked as a favorite by the user
  bool isFavorite = false;

  // Gets the currently authenticated Firebase user
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Checks if the current movie is already in the user's favorites when the screen initializes
    checkIfFavorite();
  }

  // Function to  Checks if the current movie is already marked as a favorite by the user
  Future<void> checkIfFavorite() async {
    // Exit early if no user is logged in
    if (user == null) return;

    // Attempt to retrieve the document for this movie in the user's favorites collection
    final doc =
        await FirebaseFirestore.instance
            // Access 'users' collection
            .collection('users')
            // Get the document for the current user
            .doc(user!.uid)
            // Access user's 'favorites' subcollection
            .collection('favorites')
            // Reference the document by movie ID
            .doc(widget.id.toString())
            // Fetch the document
            .get();

    // Update the UI if the widget is still mounted in the widget tree
    if (mounted) {
      setState(() {
        // If the document exists, it means the movie is marked as favorite
        isFavorite = doc.exists;
      });
    }
  }

  //  Function to Toggles the favorite status of a movie for the current user
  Future<void> toggleFavorite() async {
    // If the user is not logged in, show a dialog prompting them to log in
    if (user == null) {
      DialogBox.showInfoDialog(
        context,
        'Login Required',
        'Please login to add favorites',
      );
      return;
    }

    setState(() {
      // This Immediately update the UI by toggling the isFavorite flag
      isFavorite = !isFavorite;
    });

    try {
      if (isFavorite) {
        // If the movie is marked as favorite, add it to Firestore under the user's "favorites" collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('favorites')
            .doc(widget.id.toString())
            .set({
              'id': widget.id,
              'title': widget.title,
              'imagePath': widget.imagePath,
              'overview': widget.overView,
              'rating': widget.rating,
              'timestamp': FieldValue.serverTimestamp(),
            });
      }
      // If the movie is unmarked as favorite, remove it from Firestore
      else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('favorites')
            .doc(widget.id.toString())
            .delete();
      }
    }
    // If an error occurs, revert the UI state to its previous value
    catch (e) {
      setState(() {
        // Revert favorite status on error
        isFavorite = !isFavorite;
      });
      // Show an error dialog with the caught exception message
      if (!mounted) return;
      DialogBox.showErrorDialog(context, 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current app theme (light or dark)
    final theme = Theme.of(context);
    // Convert rating to a number, use 0.0 if it's not valid
    final double ratingValue = double.tryParse(widget.rating) ?? 0.0;

    // Pick a color based on the rating value
    final Color ratingColor = _getRatingColor(ratingValue);

    //This Controls the YouTube video player
    YoutubePlayerController youTubeController;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.heading,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: theme.primaryColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            // Display a filled or outlined heart icon based on favorite status
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              // Use red color if favorite, else used icon theme color
              color:
                  isFavorite
                      ? Color.fromRGBO(231, 63, 63, 1)
                      : theme.iconTheme.color,
            ),
            // When tapped, add or remove the item from favorites
            onPressed: toggleFavorite,
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster with gradient overlay and title details
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                // Poster image with error handling
                SizedBox(
                  width: double.infinity,
                  height: 400,
                  child: Image.network(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.movie,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                  ),
                ),

                // Gradient overlay to enhance text readability
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withAlpha(140)],
                    ),
                  ),
                ),

                // Movie title and release info
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title text
                      Text(
                        widget.title.trim().toUpperCase(),
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Release year and duration
                      Row(
                        children: [
                          if (widget.releaseDate != null)
                            Text(
                              widget.releaseDate!.split('-')[0],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          if (widget.duration != null) ...[
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.schedule,
                              color: Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.duration!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Rating circle and genres
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Circular rating badge
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ratingColor.withAlpha(140),
                      border: Border.all(color: ratingColor, width: 3),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ratingValue.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ratingColor,
                            ),
                          ),
                          const Text(
                            '/10',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Genre chips and star rating
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Genre chips
                        if (widget.genre != null)
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children:
                                widget.genre!
                                    .split(',')
                                    .map(
                                      (g) => Chip(
                                        label: Text(
                                          g.trim(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        backgroundColor: Colors.grey[200],
                                      ),
                                    )
                                    .toList(),
                          ),
                        const SizedBox(height: 8),

                        // Star rating display
                        Row(
                          children: [
                            _buildStarRating(ratingValue / 2),
                            const SizedBox(width: 8),
                            Text(
                              '${(ratingValue / 2).toStringAsFixed(1)}/5',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Trailer video player (if available)
            FutureBuilder(
              future: movieKey,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  // Clean and extract YouTube video key
                  final dataWithBrackets = snapshot.data ?? '';
                  String clean = dataWithBrackets.replaceAll(
                    RegExp(r'[()]'),
                    '',
                  );
                  final values = clean.split(', ');
                  final firstNonNull = values.firstWhere(
                    (value) => value != 'null',
                  );

                  if (firstNonNull.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No trailer available',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  // Setup YouTube controller
                  youTubeController = YoutubePlayerController(
                    initialVideoId: firstNonNull,
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                    ),
                  );

                  // Display YouTube player
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: YoutubePlayer(
                        controller: youTubeController,
                        showVideoProgressIndicator: true,
                        aspectRatio: 16 / 9,
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Error loading trailer: ${snapshot.error}'),
                  );
                }
              },
            ),

            // Overview text section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overview',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.overView,
                    style: GoogleFonts.roboto(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  // Returns a color based on the movie rating value.
  Color _getRatingColor(double rating) {
    if (rating >= 8.0) return Colors.green;
    if (rating >= 6.0) return Colors.lightGreen;
    if (rating >= 4.0) return Colors.orange;
    if (rating >= 2.0) return Colors.orangeAccent;
    return Colors.red;
  }

  // Returns a row of 5 stars based on the given rating (full, half, or empty).
  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: Colors.amber, size: 18);
        } else if (index < rating.ceil()) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 18);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 18);
        }
      }),
    );
  }
}
