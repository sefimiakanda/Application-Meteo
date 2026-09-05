# Activité 4 Formation Dclic - Application météo avec OpenWeather

Application Flutter qui consulte l’API OpenWeather pour afficher la météo d’une ville saisie par l’utilisateur.

## Présentation

Cette application permet de :

- rechercher une ville;
- récupérer la météo actuelle via l’API OpenWeather;
- afficher les informations principales (température, ressenti, humidité, vent, pression, visibilité, lever/coucher du soleil);
- gérer les états de chargement et d’erreur proprement;
- afficher un historique des dernières villes recherchées;
- proposer une interface moderne et réactive avec animations.

## Stack technique

- Flutter
- Dart
- Provider
- HTTP
- Intl
- flutter_animate

## Architecture

Le projet suit une logique MVC :

- Modèle : `lib/models/weather_model.dart`
- Vue : `lib/views/weather_view.dart`
- Contrôleur : `lib/controllers/weather_controller.dart`
- Service API : `lib/services/weather_service.dart`
- Utilitaires : `lib/utils/weather_utils.dart`
- Widgets : `lib/widgets/weather_widgets.dart`

## Prérequis

Avant de lancer le projet, vérifiez que vous avez installé :

- Flutter SDK
- Android Studio ou VS Code avec les outils Flutter
- Un émulateur Android ou un périphérique physique connecté

## Clé API OpenWeather

Cette application utilise la clé API suivante :

```text
721d3b7a5e66562478cac13c6b1c6f0d
```

> Il est recommandé de garder cette clé dans un fichier de configuration ou dans un environnement sécurisé si vous la réutilisez dans un projet réel. Pour une version de démonstration, elle est directement intégrée dans le service API.

## Installation

1. Clonez le projet :

```bash
git clone https://github.com/sefimiakanda/Application-Meteo.git
cd activite4
```

2. Installez les dépendances :

```bash
flutter pub get
```

3. Vérifiez que le projet compile :

```bash
flutter analyze
```

## Lancer l’application

### Sur un émulateur Android

```bash
flutter run
```

### Sur un appareil connecté

1. Activez le mode développeur et le débogage USB sur votre téléphone.
2. Connectez le téléphone à l’ordinateur.
3. Lancez :

```bash
flutter devices
flutter run
```

## Fonctionnement

1. Saisir le nom d’une ville dans le champ de recherche.
2. Appuyer sur le bouton de recherche.
3. L’application envoie une requête HTTP vers OpenWeather.
4. Les données sont affichées dans l’interface.
5. En cas d’erreur, un message explicite est affiché.

## Gestion des erreurs

Le service HTTP gère notamment :

- clé API invalide,
- ville introuvable,
- limite de requêtes,
- absence de connexion,
- erreur serveur.

## Remarques

Pour un projet de démonstration, cette version est conçue pour fonctionner rapidement en local et être facilement déployée sur GitHub.

## Auteur

Fidèle Miakanda.
