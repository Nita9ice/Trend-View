import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trendveiw/API/api_key.dart';
import 'package:trendveiw/screens/details_page.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late final CollectionReference favouritesRef;

  @override
  void initState() {
    super.initState();
    favouritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Favourite Videos')),
      body: StreamBuilder<QuerySnapshot>(
        stream: favouritesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print("Snapshot printed is: $snapshot");
            return const Center(child: Text('No favourite videos yet.'));
          }

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
              final imagePath = ApiKey.imageBasePath + movie["imagePath"];
              final title = movie["title"];


          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie poster
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    String imagePath =
                  ApiKey.imageBasePath + movie["imagePath"];
              String title = movie["title"];
              String overView = movie["overview"];
              int id = movie["id"];
              String rating = movie["rating"].toString();
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => Details(
                        heading: "heading",
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
          );
        },
      ),
    );
  }
}
