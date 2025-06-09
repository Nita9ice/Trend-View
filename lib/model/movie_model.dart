class Movie {
  String title;
  String releaseDate;
  String overview;
  String posterPath;
  double voteAverage;

  Movie({
    required this.releaseDate,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });

  factory Movie.fromjson(Map<String, dynamic> json) {
    return Movie(
      releaseDate: json["release_date"],
      title: json["title"],
      overview: json["overview"],
      posterPath: json["poster_path"],
      voteAverage: json["vote_average"],
    );
  }
}
