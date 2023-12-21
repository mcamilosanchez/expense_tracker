import 'package:expense_tracker/widgets/expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/* VIDEO #123. Setting & Using a Color Scheme 
Como vamos a crear nuestro propio colorScheme, debemos trabajar sobre uno ya 
establecido, por eso usamos fromSeed*/
var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

/* VIDEO #126. Adding Dark Mode
Vamos a empezar a crear nuestro Dark Mode */
var kDarkColorScheme = ColorScheme.fromSeed(
  /* Esto le dice a Flutter que este es un esquema de color para un brillo 
  oscuro. */
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

void main() {
  /* VIDEO #133. Locking the Device Orientiation 
  Aquí estamos asegurando que el bloqueo de la orientación y runApp funciona 
  correctamente */
  //WidgetsFlutterBinding.ensureInitialized();
  /* Aquí estamos definiendo la orientación del dispositivo */
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  //    .then((fn) {
  runApp(
    MaterialApp(
      /* VIDEO #126. Adding Dark Mode
      Ahora, vamos a crear nuestro darkTheme */
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
      ),
      /* VIDEO #122. Getting Started with Theming 
      Como vamos a crear un nuevo tema y en lugar de configurarlo y tener que 
      darle estilo desde cero, por medio de copyWith, usaremos un tema por 
      defecto configurado por Flutter y sólo estaríamos anulando estilos o 
      aspectos seleccionados. */
      theme: ThemeData().copyWith(
        useMaterial3: true,
        /* VIDEO #123. Setting & Using a Color Scheme */
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
          /* VIDEO #122. Getting Started with Theming
            Aqui también podemos hacer muchas cosas más en este tema de appBar, 
            que el título esté siempre centrado o que haya alguna sombra  por
            detrás. Recordar que copyWith, copia los ajustes de un tema, 
            ahorrándonos la molestia de configurar un tema desde cero. */
        ),
        /* VIDEO #124. Setting Text Themes */
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        /* VIDEO #124. Setting Text Themes
        styleFrom y copyWith al parecer funcionan para lo mismo pero tienen 
        incoherencias, ver este video o documentación si no entiende. */
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        /* VIDEO #124. Setting Text Themes
        styleFrom y copyWith al parecer funcionan para lo mismo pero tienen 
        incoherencias, ver este video o documentación si no entiende. */
        textTheme: ThemeData().textTheme.copyWith(
              /* Es importante buscar la documentación en Google, para saber qué 
              queremos modificar */
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: kColorScheme.onSecondaryContainer,
                fontSize: 16,
              ),
            ),
      ),
      /* 126. Adding Dark Mode
      Aqui abajo, vamos a escoger que tema usar, en este caso ThemeMode.system 
      utiliza el tema claro u oscuro según lo que el usuario haya seleccionado 
      en la configuración del sistema.  */
      //themeMode: ThemeMode.system, //Este es el themeMode por defautl
      home: const Expenses(),
    ),
  );
  //});
}
