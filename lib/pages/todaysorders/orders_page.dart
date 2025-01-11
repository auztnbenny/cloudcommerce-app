import 'package:cloudcommerce/pages/todaysorders/orders_styles.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({Key? key}) : super(key: key);

  final List<OrderItem> orders = [
    OrderItem(
      id: '999602',
      date: '25 Dec 2023',
      time: '3:52 PM',
      status: 'Delivered',
      rating: 5,
      image: 'assets/images/today.png',
    ),
    OrderItem(
      id: '684032',
      date: '15 Dec 2023',
      time: '1:05 PM',
      status: 'Delivered',
      rating: 4,
      image: 'assets/images/today.png',
    ),
    OrderItem(
      id: '558123',
      date: '14 Dec 2023',
      time: '5:30 PM',
      status: 'Delivered',
      rating: 4,
      image: 'assets/images/today.png',
    ),
    OrderItem(
      id: '444302',
      date: '13 Dec 2023',
      time: '2:45 PM',
      status: 'Delivered',
      rating: 5,
      image: 'assets/images/today.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrderStyles.backgroundColor,
      appBar: _buildAppBar(context),
      body: _buildOrdersList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: OrderStyles.fabColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: OrderStyles.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: OrderStyles.primaryTextColor),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'My Orders',
        style: OrderStyles.titleStyle,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list,
              color: OrderStyles.primaryTextColor),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildOrdersList() {
    return ListView.separated(
      padding: OrderStyles.listPadding,
      itemCount: orders.length,
      separatorBuilder: (context, index) => const Divider(
        height: OrderStyles.dividerHeight,
      ),
      itemBuilder: (context, index) => _buildOrderItem(orders[index]),
    );
  }

  Widget _buildOrderItem(OrderItem order) {
    return Row(
      children: [
        Container(
          width: OrderStyles.imageSize,
          height: OrderStyles.imageSize,
          decoration: OrderStyles.imageDecoration(order.image),
        ),
        const SizedBox(width: OrderStyles.spacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order# ${order.id}',
                    style: OrderStyles.orderIdStyle,
                  ),
                  Text(
                    '${order.date}, ${order.time}',
                    style: OrderStyles.dateTimeStyle,
                  ),
                ],
              ),
              const SizedBox(height: OrderStyles.smallSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.status,
                    style: OrderStyles.statusStyle,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Your Rating  ',
                        style: OrderStyles.ratingLabelStyle,
                      ),
                      ...List.generate(
                        5,
                        (index) => Icon(
                          index < order.rating ? Icons.star : Icons.star_border,
                          size: OrderStyles.starSize,
                          color: OrderStyles.ratingColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OrderItem {
  final String id;
  final String date;
  final String time;
  final String status;
  final int rating;
  final String image;

  OrderItem({
    required this.id,
    required this.date,
    required this.time,
    required this.status,
    required this.rating,
    required this.image,
  });
}
