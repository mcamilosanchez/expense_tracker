/* El objetivo de este widget es darno tres áreas principales en la pantalla 
de inicio: Toolbar, el gráfico y la lista de de gastos. */

import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  /* Esto es un método que no devuelve nada */
  void _openAddExpenseOverlay() {
    /* VIDEO #106. Adding a Modal Sheet & Understanding Context:
    It is important to watch this video, as it explains the concept of context. 
    El contexto se considera como un objeto que pertenece a un widget en 
    específico. Es decir, cada widget tiene su propio objeto de contexto 
    relacionado con la posición de los widgets en la INTEREFAZ DE USUARIO 
    GLOBAL en el árbol de widgets en general.
    Cuando vemos una argumento llamado BUILDER, básicamente significa que 
    debemos proporcionar una función como valor y también espera un contexto 
    (ctx) el nombre debe ser diferente al global (context). En este caso, es 
    una función que retorna un widget */
    showModalBottomSheet(
      /* Cuando isScrollControlled se establece a TRUE, el ModalBottomSheet 
      tomará toda la altura disponible. */
      isScrollControlled: true,
      /* VIDEO #137. Understanding "Safe Areas"
      useSafeArea es una característica que se asegura de que nos mantengamos 
      alejados de las características del dispositivo, como la cámara que podría
      estar afectando nuestra UI  */
      useSafeArea: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    /* Es importante iniciar de nuevo el estado para que la UI se acutalice al 
    momento de añadir el nuevo gasto. */
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removedExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    /* Cuando eliminamos dos o más gastos al mismo tiempo, el snackbar se 
    acumula y no queremos eso, por lo cual ejecutamos el siguiente código que 
    elimina cualquier Snackbar. */
    ScaffoldMessenger.of(context).clearSnackBars();
    /* 121. Showing & Managing "Snackbars"
    Este objeto Scaffold messenger tiene un método of que debemos ejecutar, el 
    cual quiere un valor de contexto  */
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted.'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(
              () {
                /* Ya que vamos a recuperar el gasto recién eliminado, no vamos a usar
          add, sino insert. Ambos añaden un elemento a la lista, pero la 
          diferencia entre los dos, es que insert añade el elemento en una 
          posición específica ya que quiero traer de vuelta el gasto eliminado 
          en el mismo lugar dónde estaba antes. */
                _registeredExpenses.insert(expenseIndex, expense);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    /* VIDEO #134. Updating the UI based on the Available Space
    Para saber el ancho del dispositivo, hacemos lo siguiente:*/
    final width = MediaQuery.of(context).size.width;
    /* Obteniendo el largo del dispositivo  */
    final height = MediaQuery.of(context).size.height;
    /* Es importante saber que cada vez que se gira el dispositivo, el método 
    BUILD se ejecuta de nuevo, es algo que Flutter hace por nosotros  */

    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      /* Si la lista no está vacía hace lo siguiente: */
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removedExpense,
      );
    }
    return Scaffold(
      /* VIDEO #105. Setting an AppBar with a Title & Actions:
      Scaffold también recibe como parámetro un appbar
       */
      appBar: AppBar(
        /* Actions espera una LISTA de widgets, se usa típicamente botones */
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            /* Ejecutamos sin PARÉNTESIS ya que no lo queremos usar como 
            función, en su lugar queremos usarlo como un valor para onPressed.*/
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      /* VIDEO #134. Updating the UI based on the Available Space
      Vamos a realizar una expresión terniaria (estructura condicional que 
      evalúa una expresión booleana) antes de Column. */
      body: width < 600
          ? Column(
              children: [
                /* VIDEO #129. Adding Chart Widgets */
                Chart(expenses: _registeredExpenses),
                /* VIDEO #102. Using Lists Inside Of Lists
          Si tenemos combinaciones como una columna dentro de una columna o una 
          lista dentro de una lista (como en este caso) tendremos problemas con 
          Flutter, ya que no sabe dimensionar o cómo restringir la columna 
          interior, por lo cual el CONTENIDO NO SE MOSTRARÁ. Para solucionar 
          este error hacemos un wrapp a ExpensesList por medio de EXPANDED: */
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          /* Si la condición no se cumple, es decir, si el width es mayor o 
          igual que 600, entonces la pantalla pasó de ser vertical a horizontal.
          Por lo cual los widgets, estarán mejor ordenados si están ubicados en
          Row. Entonces, lo único que tenemos que hacer es copiar y pegar en 
          children : */
          : Row(
              /* VIDEO #134. Updating the UI based on the Available Space
              Al momento de volver horizontal el dispositivo, tenemos un 
              inconveniente. Ya que si tenemos un children que intenta conseguir
              todo el ancho (en este caso, Chart) y tenemos un padre que intenta
              conseguir lo mismo (ya que lo vamos a volver horizontal) obtenemos
              un ERROR en la UI. Para evitarlo, hacemos otro Expanded dentro del
              hijo Chart. Esta es SIEMPRE LA SOLUCION CUANDO TENEMOS WIDGETS 
              ANIDADOS QUE NO FUNCIONEN JUNTOS*/
              /* 135. Understanding Size Constraints
              En resumen, se debe tener cuidado cuando usamos widgets anidados 
              debido a las restricciones de su altura y ancho. Ya que la altura 
              máxima que alcance el hijo, será la altura máxima que alcance el 
              padre y éste, debe estar restringido para que así no se salga de 
              la pantalla. Una solución es usar EXPANDED, ya que establece la 
              altura o anchura máxima qie hijos realmente puedan ocupar*/
              children: [
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
