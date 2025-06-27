class Movie {
  // properties of this class

  // Movie ID
  int id;

  // Movie title
  String title;

  // Movie release date
  String releaseDate;

  // Short description or summary of the movie
  String overview;

  // Path to the movie poster image
  String posterPath;

  // Average user rating of the movie
  double voteAverage;

  // initializing the properties
  Movie({
    required this.releaseDate,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.id,
  });

  // Factory method to create a Movie from JSON data
  factory Movie.fromjson(Map<String, dynamic> json) {
    return Movie(
      releaseDate: json['release_date'] ?? 'Not a value', // fallback if null
      title: json['title'] ?? 'Not a value',
      overview: json['overview'] ?? 'Not a value',
      posterPath: json['poster_path'] ?? 'Not a value',
      voteAverage: json['vote_average'] ?? 0,
      id: json['id'] ?? 0,
    );
  }
}
