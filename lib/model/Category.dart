class Category {
  final int? id;
  final String Categoryx;
  final String price;
  final String ranking;
  final String ty;

  Category({
    this.id,
    required this.Categoryx,
    required this.price,
    required this.ranking,
    required this.ty,
  });

  Map<String, dynamic> toMap() {
    return {
      'Category': Category,
      'price': price,
      'ranking': ranking,
      'ty': ty,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      Categoryx: map['Categoryx'],
      price: map['price'],
      ranking: map['ranking'],
      ty: map['ty'],
    );
  }
}
