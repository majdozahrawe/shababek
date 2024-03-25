import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shababeek/data/models/catagories_response.dart';

import '../models/category_model.dart';


class CatagoriesAPI {

  Future<List<Categories>> getCatagory() async {

    var url = 'https://shababeek-bdbc3d3e9971.herokuapp.com/api/v1/Category/All';

    http.Response response = await http.get(Uri.parse(url),);

    CatagoriesResponse catagoriesResponse = CatagoriesResponse();

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      catagoriesResponse = CatagoriesResponse.fromJson(jsonResponse);
    }

else {
  print('Request failed with status : ${response.statusCode}.');
    }
    return catagoriesResponse.data;

  }
}

