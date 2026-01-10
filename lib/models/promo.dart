class Promo {
  final String title;
  final String description;
  final String imageUrl;
  final String link;

  Promo({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.link,
  });

  factory Promo.fromXml(dynamic element) {
    return Promo(
      title: element.findElements('Title').first.text,
      description: element.findElements('Description').first.text,
      imageUrl: element
          .findElements('ImageUrl')
          .first
          .text
          .replaceAll('forex-images.instaforex.com', 'forex-images.ifxdb.com'),
      link: element.findElements('Link').first.text,
    );
  }
}
