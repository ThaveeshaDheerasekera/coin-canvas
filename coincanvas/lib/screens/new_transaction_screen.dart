import 'dart:io';
import 'package:coincanvas/configs/constants.dart';
import 'package:coincanvas/widgets/global/text_field_widget_copy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransactionScreen extends StatefulWidget {
  const NewTransactionScreen({super.key});
  @override
  State<NewTransactionScreen> createState() {
    return _NewTransactionScreenState();
  }
}

class _NewTransactionScreenState extends State<NewTransactionScreen>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime? _selectedDate = DateTime.now();
  Category? _selectedCategory;
  Type? _selectedType;

  final formatter = DateFormat.yMd();

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
      _dateController.text = formatter.format(_selectedDate!);
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: Text(
                  'Invalid Input',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                content: const Text(
                    'Please make sure a valid title, amount, category, type and date was entered.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Okay'),
                  ),
                ],
              ));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Invalid Input',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: Text(
            'Please make sure a valid title, amount, category, type and date was entered.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              style: Theme.of(context).textButtonTheme.style,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedType == null ||
        _selectedCategory == null ||
        _selectedDate == null) {
      _showDialog();
      return;
    }

    // Provider.of<Transactions>(context, listen: false).addTransaction(
    //   Transaction(
    //     title: _titleController.text,
    //     description: _notesController.text,
    //     amount: enteredAmount,
    //     dateTime: _selectedDate!,
    //     category: _selectedCategory!,
    //     type: _selectedType!,

    //   ),
    // );

    _formKey.currentState?.reset();

    // final selectedIndexProvider =
    //     Provider.of<SelectedIndexProvider>(context, listen: false);
    // if (_selectedType == Type.Expense) {
    //   selectedIndexProvider.selectedIndex = 2;
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const HomeScreen()),
    //   );
    // } else {
    //   selectedIndexProvider.selectedIndex = 1;
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const HomeScreen()),
    //   );
    // }
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = '';
    _amountController.text = '';
    _notesController.text = '';
    _dateController.text = formatter.format(_selectedDate!);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ExTrack [ADD EXPENSE]',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                labelWidget(context, 'Title'),
                TextFieldWidgetCopy(
                  hintText: 'Title',
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  maxLength: 50,
                  textCapitalization: TextCapitalization.sentences,
                ),
                labelWidget(context, 'Notes'),
                TextFieldWidgetCopy(
                  hintText: 'Notes...',
                  controller: _notesController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),
                labelWidget(context, 'Amount'),
                TextFieldWidgetCopy(
                  hintText: '15.00',
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  suffixWidget: Text(
                    'LKR',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
                const SizedBox(height: 16),
                labelWidget(context, 'Category'),
                categoryDropdownWidget(),
                const SizedBox(height: 16),
                labelWidget(context, 'Type'),
                typeDropdownWidget(),
                const SizedBox(height: 16),
                labelWidget(context, 'Date'),
                TextFieldWidgetCopy(
                  // readOnly: true,
                  controller: _dateController,
                  onTap: _presentDatePicker,
                  // suffixIcon: const Icon(Icons.calendar_month),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _submitExpenseData,
                      child: const Text('Save Transaction'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: const BottomNavbarWidget(),
    );
  }

  Container labelWidget(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 0, 0, 4),
      alignment: Alignment.topLeft,
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  DropdownButtonFormField<Type> typeDropdownWidget() {
    return DropdownButtonFormField<Type>(
      hint: Text(
        'Click to select type',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
      ),
      isExpanded: true,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(width: 1, color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      value: _selectedType,
      items: Type.values.map((type) {
        return DropdownMenuItem<Type>(
          value: type,
          child: Row(
            children: [
              Text(
                type.name,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
              const SizedBox(width: 32),
              Icon(
                Constants.typeIcons[type],
              ),
            ],
          ),
        );
      }).toList(),
      selectedItemBuilder: (BuildContext context) => Type.values
          .map(
            (type) => Row(
              children: [
                Text(
                  type.name,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
                const SizedBox(width: 32),
                Icon(
                  Constants.typeIcons[type],
                ),
              ],
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) {
          return;
        }
        setState(() {
          _selectedType = value;
        });
      },
    );
  }

  DropdownButtonFormField<Category> categoryDropdownWidget() {
    return DropdownButtonFormField<Category>(
      hint: Text(
        'Click to select category',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
      ),
      isExpanded: true,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(width: 1, color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      value: _selectedCategory,
      items: Category.values.map((category) {
        return DropdownMenuItem<Category>(
          value: category,
          child: Row(
            children: [
              Text(
                category.name,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
              const SizedBox(width: 32),
              Icon(
                Constants.categoryIcons[category],
              ),
            ],
          ),
        );
      }).toList(),
      selectedItemBuilder: (BuildContext context) => Category.values
          .map(
            (category) => Row(
              children: [
                Text(
                  category.name,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
                const SizedBox(width: 32),
                Icon(
                  Constants.categoryIcons[category],
                ),
              ],
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
    );
  }
}
