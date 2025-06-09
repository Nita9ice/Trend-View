import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        .collection('favourites');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourite Videos')),
      body: StreamBuilder<QuerySnapshot>(
        stream: favouritesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No favourite videos yet.'));
          }

          final favVideos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: favVideos.length,
            itemBuilder: (context, index) {
              final video = favVideos[index];
              final title = video['title'];
              final videoUrl = video['videoUrl'];
              final thumbnailUrl = video['thumbnailUrl'];

              return ListTile(
                leading:
                    thumbnailUrl != null
                        ? Image.network(
                          thumbnailUrl,
                          width: 60,
                          fit: BoxFit.cover,
                        )
                        : const Icon(Icons.play_circle_fill),
                title: Text(title),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/videoDetail',
                    arguments: {
                      'title': title,
                      'videoUrl': videoUrl,
                      'thumbnailUrl': thumbnailUrl,
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
