class Seance {
  final String id;
  final int userId;
  final int movieId;
  final String movieTitle;
  final int cinemaId;
  final String cinemaName;
  final int seatId;
  final String seatName;
  final int roomId;
  final String roomName;
  final DateTime reservationDate;
  final DateTime reservationTime;

  String? poster; 
  
  Seance({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.movieTitle,
    required this.cinemaId,
    required this.cinemaName,
    required this.seatId,
    required this.seatName,
    required this.roomId,
    required this.roomName,
    required this.reservationDate,
    required this.reservationTime,
    this.poster,
  });

  factory Seance.fromJson(Map<String, dynamic> json) {
    return Seance(
      id: json['id'] as String,
      userId: json['userId'] as int,
      movieId: json['movieId'] as int,
      movieTitle: json['movieTitle'] as String,
      cinemaId: json['cinemaId'] as int,
      cinemaName: json['cinemaName'] as String,
      seatId: json['seatId'] as int,
      seatName: json['seatName'] as String,
      roomId: json['roomId'] as int,
      roomName: json['roomName'] as String,
      reservationDate: DateTime.parse(json['reservationDate'] as String),
      reservationTime: DateTime.parse(json['reservationTime'] as String),
    );
  }
}
