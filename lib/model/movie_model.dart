class Movie {
  int id;
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
    required this.id,
  });

  factory Movie.fromjson(Map<String, dynamic> json) {
    return Movie(
      releaseDate: json["release_date"]??"Not a value",
      title: json["title"]??"Not a value",
      overview: json["overview"]??"Not a value",
      posterPath: json["poster_path"]??"Not a value",
      voteAverage: json["vote_average"]??0,
      id: json["id"]??0,
    );
  }
}
