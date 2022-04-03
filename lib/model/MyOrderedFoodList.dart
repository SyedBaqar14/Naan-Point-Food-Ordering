import 'dart:convert';

import 'Food.dart';

List<Food> foods = new List();

void clearItemsList(){
  foods.clear();
  foods = new List();
}

void addItemsToList({Food food}) {
  for (Food foodd in foods) {
    if (foodd.name == food.name) {
      foods[foods.indexOf(foodd)].qty++;
      return;
    }
  }

  foods.add(food);
}

void addItemsToList1({Food food}) {

  foods.add(food);
}

void add({Food food}){
  for (Food foodd in foods) {
    if (foodd.name == food.name) {

      foods[foods.indexOf(foodd)].qty = foods[foods.indexOf(foodd)].qty + 1;

      return;
    }
  }
}

void subtract({Food food}){
  for (Food foodd in foods) {
    if (foodd.name == food.name) {

      if(foods[foods.indexOf(foodd)].qty > 1){
        foods[foods.indexOf(foodd)].qty = foods[foods.indexOf(foodd)].qty - 1;
      }else{
        foods.remove(foodd);
      }

      return;
    }
  }
}

void addAll({List<Food> foods}){
  clearItemsList();

  for(var food in foods){
    addItemsToList(food: food);
  }
}

int getItemsListSize(){
  return foods.length;
}

List<Food> getItemsList(){
  return foods;
}

void removeItem({Food food}){
  if(foods.contains(food)){
    foods.remove(food);
  }
}

double getTotalPrice(){
  double price = 0.0;

  for(Food food in foods){
    var temmpPrice = food.price * food.qty;

    price += temmpPrice;
  }

  return price;
}

String toJson(){
  var json = jsonEncode(foods.map((e) => e.toJson()).toList());
  return json;
}