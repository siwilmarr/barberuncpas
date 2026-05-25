class BarberShop {
  final String name;
  final String address;
  final String image;
  final double rating;
  final int reviews;
  final String openingHours;
  final List<String> categories; // e.g., ['Premium', 'Standard']
  final String type; // 'EXPERT', 'VIP', 'PRO'
  final int price;
  final String phoneNumber;
  final String mapsUrl;
  final String description;

  BarberShop({
    required this.name,
    required this.address,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.openingHours,
    required this.categories,
    required this.type,
    required this.price,
    required this.phoneNumber,
    required this.mapsUrl,
    required this.description,
  });
}
