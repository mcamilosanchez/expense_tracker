import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(context) {
    return Card(
      /* Card no tiene padding, pero lo puedo simular, factorizando este widget 
      de texto y envolviéndolo con el widget de padding. */
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          children: [
            Text(expense.title),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('\$${expense.amount.toStringAsFixed(2)}'),
                /* Se quiere agrupar la CATEGORIA y la FECHA juntos, por lo cual
                se añade otra fila (ROW). 
                Spacer() es un widget que se usa en cualquier columna o fila, el 
                cual ocupa todo el espacio RESTANTE que puede conseguir entre el 
                otro widget, en este caso, empujando Row hacia la derecha. */
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(width: 8),
                    /* En formattedDate no se añade paréntesis porque es un 
                    getter, no un método. */
                    Text(expense.formattedDate),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
