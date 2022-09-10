import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tuple/tuple.dart';

class LocalVariables {
  static List<String> idsListRecipes = [];
  static List<Ingredient> ingredientsPantry = [];
  static List<Ingredient> ingredientsHomePantry = [];
  static List<Tuple3<dynamic, dynamic, dynamic>> filters = [
    const Tuple3("Mais Vistos", "views", ""),
    const Tuple3("Mais Recentes", "createdOn", "asc"),
    const Tuple3("Mais Antigos", "createdOn", ""),
    const Tuple3("Mais Favoritos", "favorites", ""),
    Tuple3("Tempo de preparação", timeFilter, "open"),
  ];
  static List<Tuple3> timeFilter = const [
    Tuple3("MIN", "Tempo de Preparação da Receita", "Tempo de preparação"),
    Tuple3(5, "infos.preparation_time", "<"),
    Tuple3(15, "infos.preparation_time", "<"),
    Tuple3(30, "infos.preparation_time", "<"),
    Tuple3(60, "infos.preparation_time", "<"),
    Tuple3(120, "infos.preparation_time", "<"),
    Tuple3(120, "infos.preparation_time", ">"),
  ];
  static int minIngredients = 7;
}
