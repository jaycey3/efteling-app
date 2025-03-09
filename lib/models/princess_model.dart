class Character {
  final String id;
  final String name;
  final String imagePath;
  final String silhouettePath;
  final String beaconUUID;
  final int beaconMajor;
  final int beaconMinor;
  bool isUnlocked;

  Character({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.silhouettePath,
    required this.beaconUUID,
    required this.beaconMajor,
    required this.beaconMinor,
    this.isUnlocked = false,
  });
}