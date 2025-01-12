import 'package:cloudcommerce/pages/todaysorders/orders_styles.dart';
import 'package:flutter/material.dart';
import '../../styles/app_styles.dart';

class TodayOrdersPage extends StatefulWidget {
  const TodayOrdersPage({Key? key}) : super(key: key);

  @override
  State<TodayOrdersPage> createState() => _TodayOrdersPageState();
}

class _TodayOrdersPageState extends State<TodayOrdersPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<OrderData> orders = [
    OrderData(
      orderNo: 'ORD001',
      party: 'John Doe Enterprises',
      date: '12 Jan 2024',
      time: '10:30 AM',
      items: 5,
      amount: 1500.00,
      status: 'Pending',
    ),
    OrderData(
      orderNo: 'ORD002',
      party: 'Alice Smith & Co.',
      date: '12 Jan 2024',
      time: '11:45 AM',
      items: 3,
      amount: 850.00,
      status: 'Confirmed',
    ),
    // Add more orders as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildOrdersList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle new order
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(OrderStyles.appBarHeight),
      child: Container(
        decoration: OrderStyles.appBarDecoration,
        child: SafeArea(
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('Today\'s Orders', style: OrderStyles.headerTitleStyle),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search orders...',
          hintStyle: AppStyles.body2,
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    return ListView.separated(
      padding: OrderStyles.listPadding,
      itemCount: orders.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: OrderStyles.cardSpacing),
      itemBuilder: (context, index) => _buildOrderCard(orders[index]),
    );
  }

  Widget _buildOrderCard(OrderData order) {
    return Container(
      decoration: OrderStyles.orderCardDecoration,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status,
                  style: AppStyles.caption.copyWith(color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: OrderStyles.sectionSpacing),
          _buildInfoRow('Party', order.party),
          const SizedBox(height: OrderStyles.infoSpacing),
          Row(
            children: [
              Expanded(child: _buildInfoRow('Date', order.date)),
              Expanded(child: _buildInfoRow('Time', order.time)),
            ],
          ),
          const SizedBox(height: OrderStyles.infoSpacing),
          Row(
            children: [
              Expanded(child: _buildInfoRow('Items', order.items.toString())),
              Expanded(
                child: _buildInfoRow(
                  'Amount',
                  '₹${order.amount.toStringAsFixed(2)}',
                  valueStyle: OrderStyles.amountStyle,
                ),
              ),
            ],
          ),
        ],
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class OrderData {
  final String orderNo;
  final String party;
  final String date;
  final String time;
  final int items;
  final double amount;
  final String status;

  OrderData({
    required this.orderNo,
    required this.party,
    required this.date,
    required this.time,
    required this.items,
    required this.amount,
    required this.status,
  });
}
