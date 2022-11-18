import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tudo_em_casa_receitas/model/categorie_list_model.dart';
import 'package:tudo_em_casa_receitas/model/ingredient_model.dart';
import 'package:tudo_em_casa_receitas/model/notification_model.dart';
import 'package:tuple/tuple.dart';

import '../model/user_model.dart';

class LocalVariables {
  static List<String> idsListRecipes = [];
  static List<Ingredient> ingredientsPantry = [];
  static List<Ingredient> ingredientsHomePantry = [];
  static List<Tuple3<dynamic, dynamic, dynamic>> filters = [
    const Tuple3("Mais Vistos", "views", ""),
    const Tuple3("Mais Recentes", "createdOn", ""),
    const Tuple3("Mais Antigos", "createdOn", "asc"),
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

  static const AssetImage facebookLogo = AssetImage(
    "assets/facebook_icon.png",
  );
  static const AssetImage googleLogo = AssetImage(
    "assets/facebook_icon.png",
  );
  static bool isDartkMode = false;
  static bool showNotifcations = true;
  static UserModel currentUser = UserModel.empty();

  static List<CategorieList> listCategories = [];
  static List<NotificationModel> listNotifications = [];
  static final formatDateHoursAndMinutes = DateFormat('hh:mm');
  static final formatDateDays = DateFormat('dd');
  static List months = [
    'jan',
    'fev',
    'mar',
    'abr',
    'mai',
    'jun',
    'jul',
    'ago',
    'set',
    'out',
    'nov',
    'dez'
  ];

  static checkDate(DateTime dateCheck) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = dateCheck;
    final aDate =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    if (aDate == today) {
      return "Hoje às ${formatDateHoursAndMinutes.format(dateCheck)}";
    } else if (aDate == yesterday) {
      return "Ontem às ${formatDateHoursAndMinutes.format(dateCheck)}";
    } else {
      return "${formatDateDays.format(dateCheck)} de ${months[dateCheck.month - 1]} às ${formatDateHoursAndMinutes.format(dateCheck)}";
    }
  }
}
