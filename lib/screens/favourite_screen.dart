import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendveiw/API/api_key.dart';
import 'package:trendveiw/screens/details_page.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  // Get the currently logged-in user from Firebase Authentication
  final user = FirebaseAuth.instance.currentUser;

  // This will hold a reference to the user's 'favorites' collection in Firestore
  late final CollectionReference favouritesRef;

  @override
  void initState() {
    super.initState();
    // Initialize the Firestore reference to the user's favorites list
    favouritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites');
  }

  @override
  Widget build(BuildContext context) {
    // Get the current app theme (light or dark)
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Favourite Videos',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: theme.primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: StreamBuilder<QuerySnapshot>(
          // Listen for real-time updates from the 'favorites' collection
          stream: favouritesRef.snapshots(),
          builder: (context, snapshot) {
            // Show a loading spinner while waiting for the data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // If no data or the list is empty, show a message
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No favourite videos yet.'));
            }

            // Store the list of favorite movies from the snapshot
            final favVideos = snapshot.data!.docs;

            return GridView.builder(
              itemCount: favVideos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                final movie = favVideos[index];
                final imagePath = ApiKey.imageBasePath + movie['imagePath'];
                final title = movie['title'];

                return Center(
                  child: Column(
                    children: [
                      // Show movie poster in a clickable container
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // On tap, collect movie details from Firestore
                            String imagePath =
                                ApiKey.imageBasePath + movie['imagePath'];
                            String title = movie['title'];
                            String overView = movie['overview'];
                            int id = movie['id'];
                            String rating = movie['rating'].toString();

                            // Navigate to the movie details screen with the selected movie data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => Details(
                                      heading: 'TrendVeiw',
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
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(imagePath),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Show the movie title below the image
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
