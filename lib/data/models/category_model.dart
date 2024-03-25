class Categories {
  String id,category_name,image_url;

  Categories({ required this.id , required this.category_name, required this.image_url});

  factory Categories.fromJson(Map<String,dynamic> json){
    Categories c = Categories(image_url: "",category_name: "",id: "");
    c.id = json['_id'].toString();
    c.category_name = json['categoryName'].toString();
    c.image_url = json['imageUrl'].toString();
    return c;
  }

}