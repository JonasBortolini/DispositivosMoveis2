class Item {
  final int id;
  String title;
  double price;
  String description;
  String category;
  String image;
  Rating rating;

  Item(this.id, this.title, this.price, this.description, this.category, this.image, this.rating);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      json['id'],
      json['title'],
      (json['price'] as num).toDouble(),
      json['description'],
      json['category'],
      json['image'],
      Rating.fromJson(json['rating']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rate': rating.rate,
      'count': rating.count,
    };
  }

  @override
  String toString() {
    return 'Item{id: $id, title: $title, price: $price, description: $description, category: $category, image: $image, rating: $rating}';
  }
}

class Rating {
  double rate;
  int count;

  Rating(this.rate, this.count);

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      (json['rate'] as num).toDouble(),
      json['count'],
    );
  }

  @override
  String toString() {
    return 'Rating{rate: $rate, count: $count}';
  }
}