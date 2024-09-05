import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/viewmodels/expense_viewmodel.dart';

class AddEditExpenseScreen extends StatefulWidget {
  final Expense? expense;

  AddEditExpenseScreen({this.expense});

  @override
  _AddEditExpenseScreenState createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0.0;
  DateTime _date = DateTime.now();
  String? _description;

  List<CategoryItem> _categories = [
    CategoryItem('Food', Icons.restaurant),
    CategoryItem('Transport', Icons.directions_car),
    CategoryItem('Entertainment', Icons.movie),
    CategoryItem('Bills', Icons.receipt),
  ];

  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _title = widget.expense!.title;
      _amount = widget.expense!.amount;
      _date = widget.expense!.date;
      _description = widget.expense!.description;
      _selectedCategory = widget.expense!.category; 
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseViewModel = Provider.of<ExpenseViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.expense == null ? 'Add Expense' : 'Edit Expense',
          style: TextStyle(color: Colors.black, fontFamily: 'Inter'),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What did you spend on?',
                      style: TextStyle(fontSize: 16, color: Color(0xFF183856), fontFamily: 'Inter'),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      initialValue: _title,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Expense Title',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      onSaved: (value) => _title = value!,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Amount Spent',
                      style: TextStyle(fontSize: 16, color: Color(0xFF183856), fontFamily: 'Inter'),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      initialValue: _amount.toString(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: '\$ 1000',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      onSaved: (value) => _amount = double.parse(value!),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Date',
                      style: TextStyle(fontSize: 16, color: Color(0xFF183856), fontFamily: 'Inter'),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      readOnly: true,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2025),
                        );
                        if (picked != null && picked != _date)
                          setState(() {
                            _date = picked;
                          });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Select Date',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Select Category',
                      style: TextStyle(fontSize: 16, color: Color(0xFF183856), fontFamily: 'Inter'),
                    ),
                    SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map<Widget>((categoryItem) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              children: [
                                FilterChip(
                                  avatar: CircleAvatar(
                                    backgroundColor: Colors.grey[200],
                                    child: Icon(categoryItem.icon, size: 18, color: Colors.black),
                                  ),
                                  label: Text(categoryItem.label),
                                  selected: _selectedCategory == categoryItem.label,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedCategory = categoryItem.label;
                                      } else {
                                        _selectedCategory = null;
                                      }
                                    });
                                  },
                                ),
                                SizedBox(height: 4),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Description',
                      style: TextStyle(fontSize: 16, color: Color(0xFF183856), fontFamily: 'Inter'),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      initialValue: _description,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Description',
                      ),
                      onSaved: (value) => _description = value,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final expense = Expense(
                          id: widget.expense?.id,
                          title: _title,
                          amount: _amount,
                          date: _date,
                          category: _selectedCategory ?? '',
                          description: _description,
                        );
                        if (widget.expense == null) {
                          expenseViewModel.addExpense(expense);
                        } else {
                          expenseViewModel.updateExpense(expense);
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Text(widget.expense == null ? 'Add Expense' : 'Update Expense', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF183856),
                    ),
                  ),
                  if (widget.expense != null) Spacer(), 
                  if (widget.expense != null)
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirm Deletion'),
                            content: Text('Are you sure you want to delete this expense?'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await expenseViewModel.deleteExpense(widget.expense!.id!);
                                  Navigator.pop(context); 
                                  Navigator.pop(context); 
                                },
                                child: Text('Delete',),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text('Delete'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItem {
  final String label;
  final IconData icon;

  CategoryItem(this.label, this.icon);
}
