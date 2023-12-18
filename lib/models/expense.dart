/* En esta clase, vamos a describir la estructura de datos y gastos. Como es un 
modelo de estructura de datos, no extiende StateFulWidget ni StateLessWidget*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

/* VIDEO #104. Using Icons & Formatting Dates
Para darle el formato a Date se tuvo que descargar una librería 
desde el terminal (flutter pub add intl) */
final formatter = DateFormat.yMd();

/* VIDEO #98. Adding an Expense Data Model with a Unique ID & Exploring 
Initializer Lists:
Esta variable de abajo me permite crear un id dinámico. Se declara afuera ya que
no pertenece a la clase Expense. En su lugar, es sólo un objeto de utilidad que
ahora podemos utilizar en cualquier parte de este archivo para generar IDs 
únicos. Para usarlo, se tuvo que descargar el paquete desde el terminal*/
const uuid = Uuid();

/* Los Enum proporcionan una forma más legible y segura de trabajar con 
conjuntos discretos de valores, especialmente cuando se trata de valores que 
son conocidos y fijos. */
enum Category { food, travel, leisure, work }

/* VIDEO #104. Using Icons & Formatting Dates:
Vamos a crear íconos dinámicos por medio de map */
const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
/* También necesitaremos un constructor que recibirá ciertos parámetros*/
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();
  /* Los dos puntos anteriores, significa que estamos inicializando la propiedad
  id con valores que NO son recibidos como argumentos de la función 
  constructora. */

  //Vamos a declarar las siguientes propiedades
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  /* VIDEO #104. Using Icons & Formatting Dates
  No basta con almacenar propiedades en clases, también podemos añadir métodos a
  las clases. Para darle el formato a Date se tuvo que descargar una librería 
  desde el terminal*/
  String get formattedDate {
    return formatter.format(date);
  }
}
