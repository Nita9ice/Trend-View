import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendveiw/API/api_call.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class Details extends StatefulWidget {
  final String heading;
  final int id;
  final String title;
  final String imagePath;
  final String overView;
  final String rating;
  final String? releaseDate;
  final String? genre;
  final String? duration;

    Details({

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
late Future<String> movieKey = ApiCall().getMoviesVideo(widget.id);
bool isFavorite = false;
 final User? user = FirebaseAuth.instance.currentUser;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
     _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
     if (user == null) return;
    
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(widget.id.toString())
        .get();

    if (mounted) {
      setState(() {
        isFavorite = doc.exists;
      });
    }
  }

 Future<void> _toggleFavorite() async {
    if (user == null) {
      // Optionally show a login prompt
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to add favorites')),
      );
      return;
    }

    setState(() {
      isFavorite = !isFavorite;
    });

    try {
      if (isFavorite) {
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
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('favorites')
            .doc(widget.id.toString())
            .delete();
      }
    } catch (e) {
      setState(() {
        isFavorite = !isFavorite; // Revert on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double ratingValue = double.tryParse(widget.rating) ?? 0.0;
    final Color ratingColor = _getRatingColor(ratingValue);
    YoutubePlayerController youTubeController;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.heading),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster with gradient overlay
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 400,
                  child: Image.network(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.movie, size: 100, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            const Icon(Icons.schedule, color: Colors.white70, size: 16),
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

            // Rating and basic info section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating circle
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ratingColor.withOpacity(0.2),
                      border: Border.all(
                        color: ratingColor,
                        width: 3,
                      ),
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
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Additional info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.genre != null)
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: widget.genre!
                                .split(',')
                                .map((g) => Chip(
                                      label: Text(
                                        g.trim(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      backgroundColor: Colors.grey[200],
                                    ))
                                .toList(),
                          ),
                        const SizedBox(height: 8),
                        // Star rating visualization
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

//Trailer vidoe
  FutureBuilder(
                future: movieKey,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    final dataWithBrackets = snapshot.data??"";
                   
                  String clean = dataWithBrackets.replaceAll(RegExp(r'[()]'), '');  // Notice the pattern changed
final values = clean.split(', ');



final firstNonNull = values.firstWhere(
  (value) => value != "null",

);

/*  */



         if (firstNonNull.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No trailer available', textAlign: TextAlign.center),
                      );
                    }

                    youTubeController = YoutubePlayerController(
                      initialVideoId: firstNonNull,
                      flags: const YoutubePlayerFlags(
                        autoPlay: false,
                        mute: false,
                      ),
                    );

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


            // Overview section
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
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),

            // Additional sections can be added here
            // For example: Cast, Similar Movies, Reviews, etc.

            


           
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 8.0) return Colors.green;
    if (rating >= 6.0) return Colors.lightGreen;
    if (rating >= 4.0) return Colors.orange;
    if (rating >= 2.0) return Colors.orangeAccent;
    return Colors.red;
  }

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
