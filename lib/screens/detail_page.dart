
import '../models/seance.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


class DetailPage extends StatelessWidget {
  final Seance seance;

  const DetailPage({super.key, required this.seance});

@override
Widget build(BuildContext context) {
  final qrData = 'Réservation : ${seance.id}\n'
      'Film : ${seance.movieTitle}\n'
      'Salle : ${seance.roomName}\n'
      'Siège : ${seance.seatName}\n'
      'Date : ${seance.reservationDate.toLocal().toString().split(' ')[0]}\n'
      'Heure : ${seance.reservationTime.toLocal().toString().split(' ')[1].substring(0, 5)}';

  return Scaffold(
    appBar: AppBar(title: Text(seance.movieTitle)),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // QR code dans une Card blanche
          Card(
            color: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: QrImageView(
                data: qrData,
                size: 200,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Séance le ${seance.reservationDate.toLocal().toString().split(' ')[0]} à ${seance.reservationTime.toLocal().toString().split(' ')[1].substring(0, 5)}',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          Text(
            'Salle ${seance.roomName}, siège : ${seance.seatName}',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    ),
  );
}
}
