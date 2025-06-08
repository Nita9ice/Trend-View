import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  

    return Expanded(
      child: GridView.builder(
        itemCount: snapshot.data[futureindex].length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          String imagePath = ApiKey.imageBasePath + snapshot.data[futureindex][index].posterPath;
          String title = snapshot.data[futureindex][index].title;
          
         

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
    
              // Movie title
              Text(
                title,
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
    );
  }
}
