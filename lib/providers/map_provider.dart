// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
//
// import '../data/api/catagories_api.dart';
// import '../data/models/category_model.dart';
//
// enum MapProviderState {initial,loading,loaded}
//
// class MapProvider with ChangeNotifier{
//   MapProviderState state = MapProviderState.initial;
//
//   late List<Categories> categoriesList;
//
//   loadCategories() async{
//     categoriesList = await CatagoriesAPI().getCatagory();
//     state = MapProviderState.loaded;
//     notifyListeners();
//   }
//
// }