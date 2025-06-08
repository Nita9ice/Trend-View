import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
/* import 'package:youtube_player_flutter/youtube_player_flutter.dart'; */

class Details extends StatelessWidget {
final String heading;
final String title;
final String imagePath;
final String overView;
final String rating;

   const Details({super.key, required this.title, required this.imagePath,required this.overView, required this.heading , required this.rating});
/* final YoutubePlayerController _youTubecontroller= YoutubePlayerController(initialVideoId: "eWzPKrNoSyM",
flags: YoutubePlayerFlags(autoPlay: false)
); */


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
title: Text(heading),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                      
        
                //Title
          SelectableText(title.trim().toUpperCase(), style: GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.w900), textAlign: TextAlign.center,), 
                //Image
          /* SizedBox(
          width: double.infinity,
          
          child: YoutubePlayer(
            controller: _youTubecontroller,
            showVideoProgressIndicator: true,
            
            ),
          
          ), */
          SizedBox(
          width: double.infinity,
          height: 300,
          child: Image.network(imagePath),
          
          ),
        
          //Rating
        SizedBox(height: 5,),
        
        Text("Rating: $rating ", style: GoogleFonts.aBeeZee(fontSize: 15, color: Colors.amber), ),
        
        
        SizedBox(height: 5,),
        
           //Overview
          SizedBox(
          width: double.infinity,
          child: Text(overView,style: GoogleFonts.aBeeZee(), textAlign: TextAlign.center, )
          
          )
          
               
                
                
                
            
              ],
            
            ),
          ),
        ),
      ),

    );
  }
}