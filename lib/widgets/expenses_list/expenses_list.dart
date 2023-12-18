import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  final void Function(Expense expense) onRemoveExpense;
  final List<Expense> expenses;

  @override
  Widget build(context) {
    /* 
    VIDEO #101. Efficiently Rendering Long Lists with ListView: 

    Recordar que el widget Column es perfecto para mostrar widgets unos 
    encima de otros, también se puede usar para el contenido de listas. Pero no 
    es aconsejable usarlo cuando existen muchos datos en la lista o cuando se 
    desconoce la cantidad de datos de la lista (como en este caso). Por lo cual,
    en ves de usar Columnm, se usa ListView.
    
    Al usar ListView, se obtendrá una lista desplazable que crea todos los 
    elementos inmediatamente cuando la lista se muestre en la pantalla. Pero no 
    es ideal para este escenario, ya que inicialmente podríamos tener muchos 
    elementos que no serán visibles inicialmente (esto es un problema). Entonces
    usaremos ListView.builder, es una función constructora especial que al final
    le dice a Flutter que debe crear una lista desplazable SÓLO CUANDO LOS 
    ELEMENTOS DE LA LISTA SON VISIBLES O ESTÁN A PUNTO DE SER VISIBLES, no si NO
    SON VISIBLES.
    
    En el constructor, pasamos una función a itemBuilder que retornará un Widget
    Recordar que usamos => cuando quiero que la función solamente devuelva un 
    valor. ItemCount es el recuento de elementos que al final define cuantos 
    elementos de la lista se renderizarán finalmente. Ejemplo: si itemCount es 
    dos, porque tenemos dos elementos en nuestra lista, esta función:
    (ctx, index) => Text(expenses[index].title) será llamada dos veces
    */
    return ListView.builder(
      itemCount: expenses.length,
      /* VIDEO #120. Using the Dismissible Widget for Dismissing List Items
      Flutter nos proporciona un widget especial donde podemos envolver 
      alrededor de los elementos de la lista que debe ser swipeable o 
      removible.  */
      itemBuilder: (ctx, index) => Dismissible(
        /* VIDEO #120. Using the Dismissible Widget for Dismissing List Items
      Hasta este momento del curso, solamente hemos usado la palabra KEY, en los
      constructores de cada clase. Pero en este caso, la usaremos ya que las 
      KEYS son mecanismos que existen para hacer que los widgets se 
      identificlables de forma única. Una KEY de este tipo, puede crearse 
      utilizando la función ValueKey(). Entonces, necesitamos una key que 
      identifique el expense para poder borrarlo correctamente, por eso usamos 
      el argumento expenses[index] el cual es el gasto identificado por el 
      index. */
        key: ValueKey(expenses[index]),
        /* 120. Using the Dismissible Widget for Dismissing List Items
        El argumento onDismissed está esperando un void function con un 
        argumento DismissDirection, por eso usamos la palabra direction.*/
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItem(
          expenses[index],
        ),
      ),
      /* Al aplicar el código anterior, estamos removiendo los gastos pero 
      NO ESTAMOS ELIMINANDO LOS DATOS CONECTADOS, por lo cual, al momento de 
      agregar un nuevo gasto, aparecerá un error ya que tenemos un desajuste 
      entre lo que se muestra en la pantalla y los datos que todavía se 
      almacenan internamente. Para solucionar este inconveniente, añadiremos el 
      parámetro onDismissed que permite activar una función cada vez que un 
      widget ha sido removido. */
    );
  }
}
