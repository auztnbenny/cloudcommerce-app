import 'package:cloudcommerce/pages/todaysorders/new_order_page.dart';
import 'package:cloudcommerce/pages/todaysorders/orders_styles.dart';
import 'package:cloudcommerce/services/todaysorder.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrderService _orderService = OrderService();
  final TextEditingController _searchController = TextEditingController();
  List<Order> orders = [];
  List<Order> filteredOrders = [];
  List<Employee> employees = [];
  DateTime? selectedDate;
  Employee? selectedEmployee;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await fetchEmployees();
    await fetchOrders();
  }

  Future<void> fetchEmployees() async {
    try {
      final employeeList = await _orderService.fetchEmployees();
      setState(() => employees = employeeList);
    } catch (e) {
      _showError('Error loading employees: $e');
    }
  }

  Future<void> fetchOrders() async {
    setState(() => isLoading = true);
    try {
      final orderList =
          await _orderService.fetchOrders(selectedDate, selectedEmployee);
      setState(() {
        orders = orderList;
        filteredOrders = List.from(orders);
      });
    } catch (e) {
      _showError('Error loading orders: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _filterOrders(String query) {
    setState(() {
      filteredOrders = orders
          .where((order) =>
              order.orderNo.toLowerCase().contains(query.toLowerCase()) ||
              order.partyName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _showFilterDialog() async {
    Employee? tempEmployee = selectedEmployee;
    DateTime? tempDate = selectedDate;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: OrderStyles.dialogDecoration,
            padding: const EdgeInsets.all(OrderStyles.spacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Filter Orders',
                    style: OrderStyles.dialogTitleStyle),
                const SizedBox(height: OrderStyles.spacing),
                DropdownButtonFormField<Employee>(
                  value: tempEmployee,
                  decoration: OrderStyles.filterInputDecoration.copyWith(
                    labelText: 'Select Employee',
                  ),
                  items: [
                    const DropdownMenuItem<Employee>(
                      value: null,
                      child: Text('All Employees'),
                    ),
                    ...employees.map((e) => DropdownMenuItem<Employee>(
                          value: e,
                          child: Text('${e.employeeName} (${e.empCode})'),
                        )),
                  ],
                  onChanged: (value) => setState(() => tempEmployee = value),
                ),
                const SizedBox(height: OrderStyles.spacing),
                CalendarDatePicker(
                  initialDate: tempDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  onDateChanged: (date) => setState(() => tempDate = date),
                ),
                const SizedBox(height: OrderStyles.spacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: OrderStyles.secondaryButtonStyle,
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: OrderStyles.smallSpacing),
                    ElevatedButton(
                      style: OrderStyles.primaryButtonStyle,
                      onPressed: () {
                        this.setState(() {
                          selectedEmployee = tempEmployee;
                          selectedDate = tempDate;
                        });
                        Navigator.pop(context);
                        fetchOrders();
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrderStyles.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(OrderStyles.appBarHeight),
        child: Container(
          decoration: OrderStyles.appBarDecoration,
          child: SafeArea(
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title:
                  const Text('Today\'s Orders', style: OrderStyles.headerStyle),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: _showFilterDialog,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(OrderStyles.spacing),
            child: TextField(
              controller: _searchController,
              decoration: OrderStyles.searchInputDecoration,
              onChanged: _filterOrders,
            ),
          ),
          if (selectedEmployee != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: OrderStyles.spacing),
              child: Wrap(
                spacing: OrderStyles.smallSpacing,
                children: [
                  Chip(
                    label: Text(selectedEmployee!.employeeName),
                    onDeleted: () {
                      setState(() => selectedEmployee = null);
                      fetchOrders();
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredOrders.isEmpty
                    ? const Center(child: Text('No orders found'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(OrderStyles.spacing),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) =>
                            _buildOrderTile(filteredOrders[index]),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewOrderPage()),
          );
        },
        backgroundColor: OrderStyles.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildOrderTile(Order order) {
    return Container(
      margin: const EdgeInsets.only(bottom: OrderStyles.cardSpacing),
      decoration: OrderStyles.orderCardDecoration,
      child: Padding(
        padding: OrderStyles.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.orderNo}',
                  style: OrderStyles.orderNumberStyle,
                ),
                Container(
                  padding: OrderStyles.chipPadding,
                  decoration: OrderStyles.statusChipDecoration,
                  child: Text(
                    'Pending', // Replace with actual status
                    style: OrderStyles.statusStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: OrderStyles.sectionSpacing),
            _buildInfoRow('Party', order.partyName),
            const SizedBox(height: OrderStyles.infoSpacing),
            Row(
              children: [
                Expanded(child: _buildInfoRow('Date', order.orderDate)),
                Expanded(
                    child: _buildInfoRow(
                        'Time', '10:30 AM')), // Add time to your Order model
              ],
            ),
            const SizedBox(height: OrderStyles.infoSpacing),
            Row(
              children: [
                Expanded(
                    child: _buildInfoRow(
                        'Items', '5')), // Add items count to your Order model
                Expanded(
                  child: _buildInfoRow(
                    'Amount',
                    '₹${order.totAmt}',
                    valueStyle: OrderStyles.amountStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {TextStyle? valueStyle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: OrderStyles.labelStyle),
        const SizedBox(height: 4),
        Text(value, style: valueStyle ?? OrderStyles.valueStyle),
      ],
    );
  }
}
