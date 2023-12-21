import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  /* VIDEO 109. Letting Flutter do the Work with TextEditingController:
  Vamos a declarar una propiedad (_titleController) que será un controlador de 
  editor de texto. */
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  /* VIDEO #115. Adding a Dropdown Button 
  _selectedCategory almacena la categoría "leisure" en el dropDownButton para 
  que al momento de mostrar el drop, no aparezca en blanco. */
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    // firstDate será la fecha mínima que se puede seleccionar
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    /* VIDEO #114. Working with "Futures" for Handling Data from the Future
    showDatePicker retorna un dato FUTURE, es un objeto del futuro que ENVUELVE 
    UN VALOR QUE AÚN NO TIENES, pero que tendrás en el futuro. Es importante 
    entender que este objeto futuro, se devuelve inmediatamente pero no contiene 
    el valor recogido todavía. En su lugar, este objeto nos da un método THEN al
    que podemos llamar y al que podemos pasar una función. Pero hay un método 
    más conveniente y es añadir ASYNC (después del método) y AWAIT (delante del 
    código que produce tal futuro) y se almacena en pickedDate. La palabra AWAIT
    le dice a Flutter que este valor debe ser almacenado en pickedDate pero no 
    estará diponible inmediatamente, pero sí en algún momento en el futuro. */
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now, //lastDate será la fecha máxima que se puede seleccionar
    ) /* .then((value) => null)*/;
    /*Esta línea de aquí solo se ejecutará una vez el valor esté disponible, 
    así que esperará este valor. */
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  /* 139. Building Adaptive Widgets */
  void _showDialog() {
    /* VIDEO #139. Building Adaptive Widgets
      Cupertino es el nombre del lenguaje estilístico o de diseño de iOS. 
      Entonces vamos a crear un showDialog con el diseño de iOS. Aquí, vamos a 
      tener un problema, ya que necesitamos averiguar en cual plataforma estamos
      ejecutando la app, y que no podemos mostrar los dos showDailog. La 
      solución, será la siguiente: 
    */
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    /*Vamos a convertir _amountController (string) a un double y devuelve un 
    null si no es capaz de convertirlo. Ejemplo: tryParse('Hello') => null */
    final enteredAmount = double.tryParse(_amountController.text);
    /* En Dart, podemos hacer la siguiente condición. Si algunas de las dos 
    siguientes condiciones se cumple, amountIsInvalid será TRUE. */
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    //Trim quita espacios en blanco
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      //Show error message
      /* VIDEO #117. Validating User Input & Showing an Error Dialog
      Ver video si no entiende el siguiente código*/
      _showDialog();
      /* Al añadir el siguiente return, estoy diciéndole a Flutter que me estoy 
      devolviendo después de llamar a showDialog hasta la sentencia if. Entonces 
      si la condición no se cumple, el gasto no se guardará hasta que los campos 
      sean correctos*/
      return;
    }

    /* Recordar que usamos la palabra widget para poder usar una variable desde 
    la otra clase (función onAddExpense) StateFul */
    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        /* Recordar que le agregamos ! a _selectedDate por que Dart piensa que 
      podría ser nulo, pero sabemos que no gracias a la validación de arriba. */
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  /* VIDEO 109. Letting Flutter do the Work with TextEditingController:
  Además, le tenemos que decir a Flutter que elimine ese controlador cuando el 
  widget ya no sea necesario, por ejemplo, cuando el showModalBottomSheet se 
  cierra ya que este controlador vivirá en la memoria aunque el widget ya no sea
  visible. Es por eso, que cuando se usa este controlador de edición de texto, 
  se debe agregar el método DISPOSE.
  Dispose, como "InitState" y "build" es parte del ciclo de vida de 
  StateFulWidget. Es llamado automáticamente por Flutter cuando el widget y su 
  estado están a punto de ser destruidos. */
  @override
  void dispose() {
    /* Aquí le estamos diciendo a Flutter, que _titleController ya no es 
    necesario, de lo contrario no se eliminará del UI. Haciendo que la memoria 
    del dispositivo esté ocupada y la app se bloquee. Por lo tanto, SIEMPRE 
    DEBEMOS DE ELIMINAR ESTE TIPO DE CONTROLADORES*/
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    /* 136. Handling to Screen Overlays like the Soft Keyboard
    Con la siguiente MediaQuery, estamos obteniendo la cantidad de espacio 
    ocupado por el teclado */
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    /* 138. Using the LayoutBuilder Widget 
    Al usar este widget, podemos acceder a nuevas propiedades constraints. Por 
    ejemplo: minWidth, maxWidth, minHeight. Éstos valores son importante 
    tenerlos en cuenta, ya que con ellos sabré cuánto espacio dispone y podrá 
    decidir que disposición debe adoptar, lo que nos permite construir un widget
    que se pueda usar en el Widget Tree. No le importa la orientación de la 
    pantalla, sólo le importa cuanto ancho y alto está disponible este widget.*/
    /* ESTE WIDGET ES IMPORTANTE TENERLO EN CUENTA, YA QUE SE ACTUALIZA CADA VEZ
    QUE HAYA UN CAMBIO ENTRE LOS VALORES DE LAS DIMENSIONES DE LA PANTALLA */
    return LayoutBuilder(builder: (ctx, constraints) {
      //print(constraints.maxHeight);
      //print(constraints.maxWidth);
      final width = constraints.maxWidth;
      /* Aquí estamos almacenando el maxWidth que podemos usar en una variable. 
      LayoutBuilder volverá a llamar a la función constructora 
      (ctx, constraints) cada vez que cambien las restricciones, por ejemplo, si
      el widget se mueve a otro lugar o si se cambia la orientación del 
      dispositivo*/
      return SizedBox(
        /* 136. Handling to Screen Overlays like the Soft Keyboard
      Hacemos un wrapped a SingleChildScrollView con SizedBox ya que con este 
      widget, podemos fijar la altura */
        height: double.infinity, // Ocupa todo el espacio disponible
        child: SingleChildScrollView(
          child: Padding(
            /* 136. Handling to Screen Overlays like the Soft Keyboard
          Añadimos el espacio del teclado en el bottom del padding */
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                /* 138. Using the LayoutBuilder Widget
                Podemos usar el siguiente condicional, en este caso, no hay 
                necesidad de usar { } */
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    /* Recordar que usamos Expanded ya que los textField y Row son 
                    widgets que nos tienen restricciones de tamaño*/
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _amountController,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    /* VIDEO #108. Getting User Input on Every Keystroke:
                    Permite registrar una función que se disparará cada vez que cambie 
                    el valor del campo de texto */
                    //onChanged: _saveTitleInput, /*Ya no usamos este código, se cambia
                    //por controller */
                    controller: _titleController,
                    //Sólo permite 50 caracteres
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value:
                                    category, //Este es el valor que se almacena
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end, //Horizontal
                          crossAxisAlignment:
                              CrossAxisAlignment.center, //Vertical
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                              /* _selectedDate puede ser un valor nulo, pero lo 
                              estamos comprobando por medio de la condición. Aún 
                              así, aparece un error en Dart, por eso ponemos un 
                              signo de exclamación para decirle a Dart que ese valor 
                              en ese instante (después de la condición) nunca será 
                              nulo. */
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      /* Cuando dentro de un Row hay un TextField debemos usar tambien 
                  EXPANDED, ya que TextField quiere tomar tanto espacio horizontal 
                  como sea posible y Row, por defecto, no restringe la cantidad de 
                  espacio que puede ocupar. */
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _amountController,
                          decoration: const InputDecoration(
                            /*Recordar que $ es un carácter especial, por lo cual, uso \ 
                        para imprimir el dólar. */
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      /* Como estamos usando un Row dentro de un Row, esto nos genera 
                  problemas, por lo cual usaremos Expanded. */
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end, //Horizontal
                          crossAxisAlignment:
                              CrossAxisAlignment.center, //Vertical
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                              /* _selectedDate puede ser un valor nulo, pero lo 
                              estamos comprobando por medio de la condición. Aún 
                              así, aparece un error en Dart, por eso ponemos un 
                              signo de exclamación para decirle a Dart que ese valor 
                              en ese instante (después de la condición) nunca será 
                              nulo. */
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                if (width >= 600)
                  Row(children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        /* Navigator.pop necesita un contexto como argumento, en este 
                      caso, el contexto del build. Luego, pop simplemente elimina 
                      esta superposición de la pantalla. */
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _submitExpenseData,
                      child: const Text('Save Expense'),
                    ),
                  ])
                else
                  Row(
                    children: [
                      /* VIDEO #115. Adding a Dropdown Button
                  En DropdownButton, el argumento items espera una lista, por lo 
                  cual pasamos Category, pero el problema es que Category no es una 
                  lista es un enum. Por lo cual, debemos usar map, para mapear todos
                   los elementos del enum y convertilos a una lista (toList)*/
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value:
                                    category, //Este es el valor que se almacena
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      /* Recordar que Spacer ocupa el espacio vacío que hay entre los 
                  widgets, hacien que se vayan hacia un lado de la pantalla. */
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          /* Navigator.pop necesita un contexto como argumento, en este 
                      caso, el contexto del build. Luego, pop simplemente elimina 
                      esta superposición de la pantalla. */
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Expense'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
