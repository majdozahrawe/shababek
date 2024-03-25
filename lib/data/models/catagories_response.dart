import 'category_model.dart';

class CatagoriesResponse{

   late List<Categories> data;
   CatagoriesResponse();

  factory CatagoriesResponse.fromJson(Map<String,dynamic>json){
    CatagoriesResponse catagoriesResponse = CatagoriesResponse();

    catagoriesResponse.data = [];
    // print(catagoriesResponse.data);
    for(var c in json['data']){
      Categories temp = Categories.fromJson(c);
      catagoriesResponse.data.add(temp as Categories);
    }
    print("categoriesResponse");
    print(catagoriesResponse.data);
    return catagoriesResponse;
  }

}