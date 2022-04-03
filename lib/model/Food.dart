class Food{
  String id;
  int qty;
  int isUpdate;
  int isNew;
  String name;
  double price;
  String image;

  Food({String name, double price, String image, String id, int qty, int isUpdate, int isNew}){
      this.id = id;
      this.name = name;
      this.price = price;
      this.image = image;
      this.qty = qty;
      this.isUpdate = isUpdate;
      this.isNew = isNew;
  }

  Food.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    qty = json['qty'];
    isUpdate = json['isUpdate'];
    isNew = json['isNew'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['image'] = this.image;
    data['qty'] = this.qty;
    data['isUpdate'] = this.isUpdate;
    data['isNew'] = this.isNew;

    return data;
  }
}