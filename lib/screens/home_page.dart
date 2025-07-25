import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';
import '../models/seance.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  final int userId;
  final void Function() onLogout;

  const HomePage({
    super.key,
    required this.userId,
    required this.onLogout,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  late Future<List<Seance>> _futureSeances;

  @override
  void initState() {
    super.initState();
    _futureSeances = fetchSeances(widget.userId);
  }

  Future<List<Seance>> fetchSeances(int userId) async {
    final url = Uri.parse('https://10.0.2.2:7121/api/Reservation?userId=$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final seances = data.map((json) => Seance.fromJson(json)).toList();

        // Récupération des affiches de film
        for (var seance in seances) {
          final movie = await fetchMovie(seance.movieId);
          seance.poster = movie.poster;
        }

        // (Optionnel) Tri ou filtrage ici
        return seances;
      } else {
        throw Exception('Erreur API : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }

  Future<Movie> fetchMovie(int movieId) async {
    final url = Uri.parse('https://10.0.2.2:7121/api/Movies/$movieId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Erreur lors du chargement du film $movieId');
    }
  }

    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Mes séances'),
            actions: [
                IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Déconnexion',
                onPressed: () {
                    widget.onLogout(); // Appelle la fonction du parent
                },
                ),
            ],
            ),


      body: FutureBuilder<List<Seance>>(
        future: _futureSeances,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune séance trouvée.'));
          }

          final seances = snapshot.data!;
          return ListView.builder(
            itemCount: seances.length,
            itemBuilder: (context, index) {
              final seance = seances[index];

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(seance: seance),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      seance.poster != null
                          ? Image.network(
                              seance.poster!,
                              width: 100,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : const SizedBox(
                              width: 100,
                              height: 150,
                              child: Icon(Icons.movie, size: 40),
                            ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                seance.movieTitle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '📅 ${seance.reservationDate.toLocal().toString().split(' ')[0]} à ${seance.reservationTime.toLocal().toString().substring(11, 16)}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text('🎬 Salle : ${seance.roomName}',
                                  style: const TextStyle(color: Colors.white)),
                              Text('💺 Siège : ${seance.seatName}',
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
