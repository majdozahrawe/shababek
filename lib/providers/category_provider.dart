import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../data/api/catagories_api.dart';
import '../data/models/category_model.dart';

enum GridScreenState {initial,loading,loaded}

class CategoriesGridProvider with ChangeNotifier{
GridScreenState state = GridScreenState.initial;

  late List<Categories> categoriesList;
  var categoryID,categoryName;

  loadCategories() async{
    categoriesList = await CatagoriesAPI().getCatagory();
    state = GridScreenState.loaded;
    notifyListeners();
  }


setCategoryID(var pressedCatID) async{
  categoryID = pressedCatID;
  notifyListeners();
}

getCategoryName(var cat_name) async{
  categoryName = cat_name;
  notifyListeners();
}

}