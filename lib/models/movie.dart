class Movie {
  final int movieId;
  final String title;
  final String poster; 

  Movie({
    required this.movieId,
    required this.title,
    required this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      movieId: json['movieId'],
      title: json['title'],
      poster: json['poster'], 
    );
  }
}
