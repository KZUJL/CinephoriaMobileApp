#🎬 Cinephoria Mobile App (Flutter)

L’application mobile Cinephoria permet aux utilisateurs de :

Se connecter

Voir leurs séances réservées à venir

Afficher le QR code de chaque réservation

## 🚀 Prérequis

Flutter SDK
Visual Studio Code
Android Studio
Un appareil ou un émulateur Android/iOS

## 📂 Installation
Cloner le dépôt
git clone https://github.com/KZUJL/CinephoriaMobileApp.git
cd CinephoriaMobileApp

Installer les dépendances
flutter pub get

Configuration de l’API

L’application utilise un fichier de configuration central (lib/config.dart) pour l’URL de l’API :
class AppConfig {
  static const String apiBaseUrl = "https://apicinephoria-bf9xgq.fly.dev/api/";
}
Pour tester en local, modifie simplement l’URL :
static const String apiBaseUrl = "https://localhost:7121/api/";
Cette URL sera utilisée par toutes les pages pour les requêtes HTTP.

## Lancer l’application en local

Lancer un émulateur (ou brancher un appareil physique) :
flutter emulators --launch Pixel_7a_API_35
Exécuter l’application :
flutter run

## Fonctionnalités principales

Connexion :
Les utilisateurs se connectent avec email et mot de passe.

Séances réservées :
Après connexion, l’app montre uniquement les séances à venir pour l’utilisateur connecté (séances non passées).

QR Code :
En cliquant sur une séance, un QR code est affiché pour la réservation.

## 📦 Générer un APK (Android)

Pour générer un fichier APK à distribuer ou tester :
flutter build apk --release

Le fichier se trouve ensuite dans :
build/app/outputs/flutter-apk/app-release.apk

# Notes

L’API doit être lancée et accessible pour que l’application fonctionne.

Les secrets et utilisateurs doivent être configurés côté back-end.


# Autres dépôts du projet Cinephoria

- [Cinephoria Front-end (Vue.js)](https://github.com/KZUJL/CinephoriaWeb)
- [Cinephoria Back-end (C# .NET)](https://github.com/ton-org/CinephoriaApi)
- [Cinephoria Mobile (Flutter)](https://github.com/KZUJL/CinephoriaMobileApp)
- [Cinephoria Desktop (C#)](https://github.com/KZUJL/CinephoriaDesktop)
