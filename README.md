
# my_app

Application Flutter avec une page d’accueil, un menu latéral et des pages de
navigation pour les rubriques de l’atelier.

## Images

Les six illustrations de l’accueil et la photo de profil sont déjà dans
`images/`. Elles reprennent les visuels de la capture fournie. Pour les
remplacer, conservez ces noms ou modifiez les chemins dans
`lib/config/global.params.dart` :

- `meteo.png`
- `maps.png`
- `contacts.png`
- `messenger.png`
- `chatbot.png`
- `parametres.png`

Le dossier est déclaré dans `pubspec.yaml`. Après avoir ajouté ou remplacé des
images, exécutez `flutter pub get` puis relancez l’application.

## Getting Started

This project is a starting point for a Flutter application.

## Page Maps

La page Maps utilise OpenStreetMap pour afficher la carte et rechercher une
ville sans clé API. La carte nécessite une connexion Internet et affiche
l’attribution © OpenStreetMap contributors. Vous pouvez aussi activer Google
Geocoding comme fournisseur de recherche sur Android/iOS en fournissant une
clé :

- Activez **Geocoding API** dans Google Cloud Console et associez un compte de
  facturation.
- Fournissez la clé à Flutter avec
  `--dart-define=GOOGLE_GEOCODING_API_KEY=VOTRE_CLE_GEOCODING` lors de
  `flutter run` ou `flutter build`. Restreignez cette clé à l’API Geocoding et
  ne la publiez pas. Sans cette clé, la recherche utilise Nominatim.
- Dans le navigateur, la recherche utilise Nominatim et aucune clé Google
  n’est requise. Autorisez l’accès à la localisation dans le navigateur pour
  utiliser le GPS.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
