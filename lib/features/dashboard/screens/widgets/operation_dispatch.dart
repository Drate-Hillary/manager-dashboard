import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class OperationsDispatch extends StatefulWidget {
  const OperationsDispatch({super.key});

  @override
  State<OperationsDispatch> createState() => _OperationsDispatchState();
}

class _OperationsDispatchState extends State<OperationsDispatch> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabTitles = ['Live Operations', 'Order Board', 'Staff Dispatch', 'Chat Feed'];

  // Mock data
  final List<RestaurantTable> tables = [
    RestaurantTable(id: 'T01', capacity: 2, status: TableStatus.available, position: const Offset(0.2, 0.2)),
    RestaurantTable(id: 'T02', capacity: 4, status: TableStatus.occupied, order: 'Order #123', position: const Offset(0.5, 0.2)),
    RestaurantTable(id: 'T03', capacity: 6, status: TableStatus.reserved, reservation: '7:30 PM', position: const Offset(0.8, 0.2)),
    RestaurantTable(id: 'T04', capacity: 2, status: TableStatus.occupied, order: 'Order #124', position: const Offset(0.2, 0.5)),
    RestaurantTable(id: 'T05', capacity: 4, status: TableStatus.available, position: const Offset(0.5, 0.5)),
    RestaurantTable(id: 'T06', capacity: 8, status: TableStatus.cleaning, position: const Offset(0.8, 0.5)),
    RestaurantTable(id: 'T07', capacity: 4, status: TableStatus.occupied, order: 'Order #125', position: const Offset(0.2, 0.8)),
    RestaurantTable(id: 'T08', capacity: 2, status: TableStatus.reserved, reservation: '8:00 PM', position: const Offset(0.5, 0.8)),
  ];

  final List<Order> orders = [
    Order(id: 'ORD-001', table: 'T02', items: '2x Burger, Fries', status: OrderStatus.preparing, timeElapsed: '12 min'),
    Order(id: 'ORD-002', table: 'T04', items: 'Pasta, Salad', status: OrderStatus.newOrder, timeElapsed: '5 min'),
    Order(id: 'ORD-003', table: 'T07', items: 'Steak, Wine', status: OrderStatus.ready, timeElapsed: '18 min'),
    Order(id: 'ORD-004', table: 'T09', items: 'Pizza, Beer', status: OrderStatus.preparing, timeElapsed: '8 min'),
  ];

  final List<Waiter> waiters = [
    Waiter(name: 'John Smith', status: WaiterStatus.idle, currentBatch: '', tables: []),
    Waiter(name: 'Sarah Johnson', status: WaiterStatus.delivering, currentBatch: 'B-007', tables: ['T02', 'T04']),
    Waiter(name: 'Mike Davis', status: WaiterStatus.assigned, currentBatch: 'B-008', tables: ['T07']),
    Waiter(name: 'Emily Wilson', status: WaiterStatus.idle, currentBatch: '', tables: []),
  ];

  final List<ChatMessage> chatMessages = [
    ChatMessage(customer: 'John Smith', table: 'T02', message: 'Can we get some extra napkins?', time: '2 min ago', isRead: true),
    ChatMessage(customer: 'Sarah Miller', table: 'T04', message: 'Is our food almost ready?', time: '1 min ago', isRead: false),
    ChatMessage(customer: 'Mike Davis', table: 'T07', message: 'This steak is perfect, thank you!', time: 'Just now', isRead: false),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Operations & Dispatch'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLiveOperations(),
          _buildOrderBoard(),
          _buildStaffDispatch(),
          _buildChatFeed(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _showQuickActions,
      child: const Icon(Iconsax.flash),
      tooltip: 'Quick Actions',
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.refresh),
              title: const Text('Refresh All Data'),
              onTap: () {
                Navigator.pop(context);
                _refreshData();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.additem),
              title: const Text('Create Manual Order'),
              onTap: () {
                Navigator.pop(context);
                _createManualOrder();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.user_add),
              title: const Text('Add Walk-in Customer'),
              onTap: () {
                Navigator.pop(context);
                _addWalkInCustomer();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.setting),
              title: const Text('Floor Plan Settings'),
              onTap: () {
                Navigator.pop(context);
                _editFloorPlan();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Live Operations Tab - Table Layout
  Widget _buildLiveOperations() {
    return Column(
      children: [
        // Stats Overview
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOperationStat('Available', '3', Colors.green),
              _buildOperationStat('Occupied', '3', Colors.orange),
              _buildOperationStat('Reserved', '2', Colors.blue),
              _buildOperationStat('Cleaning', '1', Colors.red),
            ],
          ),
        ),
        
        // Table Layout
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Stack(
                children: [
                  // Restaurant background (simplified)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.grey[100]!, Colors.grey[200]!],
                      ),
                    ),
                  ),
                  
                  // Tables
                  ...tables.map((table) => _buildTableWidget(table)),
                  
                  // Legend
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _buildTableLegend(),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Efficiency Analytics
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              _buildEfficiencyMetric('Avg. Prep Time', '15 min', Iconsax.clock),
              const SizedBox(width: 16),
              _buildEfficiencyMetric('Orders/Hour', '24', Iconsax.trend_up),
              const SizedBox(width: 16),
              _buildEfficiencyMetric('Table Turnover', '45 min', Iconsax.refresh),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableWidget(RestaurantTable table) {
    Color getTableColor(TableStatus status) {
      switch (status) {
        case TableStatus.available:
          return Colors.green;
        case TableStatus.occupied:
          return Colors.orange;
        case TableStatus.reserved:
          return Colors.blue;
        case TableStatus.cleaning:
          return Colors.red;
      }
    }

    String getTableStatusText(TableStatus status) {
      switch (status) {
        case TableStatus.available:
          return 'Available';
        case TableStatus.occupied:
          return 'Occupied';
        case TableStatus.reserved:
          return 'Reserved';
        case TableStatus.cleaning:
          return 'Cleaning';
      }
    }

    return Positioned(
      left: table.position.dx * 300,
      top: table.position.dy * 300,
      child: GestureDetector(
        onTap: () => _showTableDetails(table),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: getTableColor(table.status).withOpacity(0.2),
            border: Border.all(color: getTableColor(table.status), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                table.id,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: getTableColor(table.status),
                ),
              ),
              Text(
                '${table.capacity}p',
                style: TextStyle(
                  fontSize: 10,
                  color: getTableColor(table.status),
                ),
              ),
              if (table.status == TableStatus.occupied)
                Icon(Iconsax.shopping_bag, size: 12, color: getTableColor(table.status)),
              if (table.status == TableStatus.reserved)
                Icon(Iconsax.clock, size: 12, color: getTableColor(table.status)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableLegend() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegendItem('Available', Colors.green),
            _buildLegendItem('Occupied', Colors.orange),
            _buildLegendItem('Reserved', Colors.blue),
            _buildLegendItem('Cleaning', Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildOperationStat(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildEfficiencyMetric(String label, String value, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Icon(icon, size: 16, color: Colors.blue),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  // Order Board Tab - Kanban Style
  Widget _buildOrderBoard() {
    final newOrders = orders.where((order) => order.status == OrderStatus.newOrder).toList();
    final preparingOrders = orders.where((order) => order.status == OrderStatus.preparing).toList();
    final readyOrders = orders.where((order) => order.status == OrderStatus.ready).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderColumn('New Orders', newOrders, Colors.blue, Iconsax.add_circle),
          const SizedBox(width: 12),
          _buildOrderColumn('Preparing', preparingOrders, Colors.orange, Iconsax.clock),
          const SizedBox(width: 12),
          _buildOrderColumn('Ready', readyOrders, Colors.green, Iconsax.tick_circle),
        ],
      ),
    );
  }

  Widget _buildOrderColumn(String title, List<Order> orders, Color color, IconData icon) {
    return Expanded(
      child: Card(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 16),
                  const SizedBox(width: 8),
                  Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      orders.length.toString(),
                      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            
            // Orders
            Expanded(
              child: orders.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.box, size: 32, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('No orders', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: orders.length,
                      itemBuilder: (context, index) => _buildOrderCard(orders[index], color),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: color.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.id,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    order.timeElapsed,
                    style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Table ${order.table}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 4),
            Text(order.items, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 8),
            if (order.status == OrderStatus.ready)
              FilledButton.tonal(
                onPressed: () => _assignToWaiter(order),
                child: const Text('Assign Waiter'),
              )
            else if (order.status == OrderStatus.newOrder)
              FilledButton.tonal(
                onPressed: () => _startPreparation(order),
                child: const Text('Start Prep'),
              )
            else if (order.status == OrderStatus.preparing)
              FilledButton.tonal(
                onPressed: () => _markAsReady(order),
                child: const Text('Mark Ready'),
              ),
          ],
        ),
      ),
    );
  }

  // Staff Dispatch Tab
  Widget _buildStaffDispatch() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Waiter Availability Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWaiterStat('Available', waiters.where((w) => w.status == WaiterStatus.idle).length, Colors.green),
                  _buildWaiterStat('Busy', waiters.where((w) => w.status == WaiterStatus.delivering).length, Colors.orange),
                  _buildWaiterStat('Assigned', waiters.where((w) => w.status == WaiterStatus.assigned).length, Colors.blue),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Waiter List
          Expanded(
            child: ListView.builder(
              itemCount: waiters.length,
              itemBuilder: (context, index) => _buildWaiterCard(waiters[index]),
            ),
          ),
          
          // Batch Assignments
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Active Deliveries', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _buildActiveDelivery('B-007', 'Sarah Johnson', ['T02', 'T04'], 'En Route'),
                  _buildActiveDelivery('B-008', 'Mike Davis', ['T07'], 'Preparing'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaiterCard(Waiter waiter) {
    Color getStatusColor(WaiterStatus status) {
      switch (status) {
        case WaiterStatus.idle:
          return Colors.green;
        case WaiterStatus.assigned:
          return Colors.blue;
        case WaiterStatus.delivering:
          return Colors.orange;
      }
    }

    String getStatusText(WaiterStatus status) {
      switch (status) {
        case WaiterStatus.idle:
          return 'Available';
        case WaiterStatus.assigned:
          return 'Assigned';
        case WaiterStatus.delivering:
          return 'Delivering';
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: getStatusColor(waiter.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Iconsax.profile_circle, color: getStatusColor(waiter.status)),
        ),
        title: Text(waiter.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getStatusText(waiter.status)),
            if (waiter.currentBatch.isNotEmpty)
              Text('Batch: ${waiter.currentBatch}', style: const TextStyle(fontSize: 12)),
            if (waiter.tables.isNotEmpty)
              Text('Tables: ${waiter.tables.join(', ')}', style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (waiter.status == WaiterStatus.idle)
              IconButton(
                icon: const Icon(Iconsax.add_circle, size: 16),
                onPressed: () => _assignOrderToWaiter(waiter),
                tooltip: 'Assign Order',
              ),
            IconButton(
              icon: const Icon(Iconsax.message, size: 16),
              onPressed: () => _messageWaiter(waiter),
              tooltip: 'Send Message',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaiterStat(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(count.toString(), style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildActiveDelivery(String batchId, String waiter, List<String> tables, String status) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.blue.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Iconsax.box, size: 16, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(batchId, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('Waiter: $waiter', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  Text('Tables: ${tables.join(', ')}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Chat Feed Tab
  Widget _buildChatFeed() {
    return Column(
      children: [
        // Chat Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              const Icon(Iconsax.message_text, color: Colors.blue),
              const SizedBox(width: 8),
              const Text('Customer Messages', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Badge(
                label: Text(chatMessages.where((m) => !m.isRead).length.toString()),
                backgroundColor: Colors.red,
              ),
            ],
          ),
        ),
        
        // Messages List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: chatMessages.length,
            itemBuilder: (context, index) => _buildChatMessage(chatMessages[index]),
          ),
        ),
        
        // Quick Response Buttons
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickResponseButton('On the way!'),
              _buildQuickResponseButton('5 more minutes'),
              _buildQuickResponseButton('Coming right up!'),
              _buildQuickResponseButton('Need anything else?'),
            ],
          ),
        ),
        
        // Message Input
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Iconsax.send_2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatMessage(ChatMessage message) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: message.isRead ? Colors.white : Colors.blue.withOpacity(0.05),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Iconsax.profile_circle, color: Colors.blue),
        ),
        title: Row(
          children: [
            Text(message.customer, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Table ${message.table}',
                style: const TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ),
            if (!message.isRead)
              Container(
                margin: const EdgeInsets.only(left: 4),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.message),
            const SizedBox(height: 4),
            Text(message.time, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Iconsax.arrow_right, size: 16),
          onPressed: () => _replyToMessage(message),
        ),
      ),
    );
  }

  Widget _buildQuickResponseButton(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () => _sendQuickResponse(text),
      backgroundColor: Colors.blue.withOpacity(0.1),
      labelStyle: const TextStyle(color: Colors.blue),
    );
  }

  // Action methods
  void _refreshData() {}
  void _createManualOrder() {}
  void _addWalkInCustomer() {}
  void _editFloorPlan() {}
  void _showTableDetails(RestaurantTable table) {}
  void _assignToWaiter(Order order) {}
  void _startPreparation(Order order) {}
  void _markAsReady(Order order) {}
  void _assignOrderToWaiter(Waiter waiter) {}
  void _messageWaiter(Waiter waiter) {}
  void _replyToMessage(ChatMessage message) {}
  void _sendQuickResponse(String text) {}
}

// Data Models
enum TableStatus { available, occupied, reserved, cleaning }

class RestaurantTable {
  final String id;
  final int capacity;
  final TableStatus status;
  final String? order;
  final String? reservation;
  final Offset position;

  const RestaurantTable({
    required this.id,
    required this.capacity,
    required this.status,
    this.order,
    this.reservation,
    required this.position,
  });
}

enum OrderStatus { newOrder, preparing, ready }

class Order {
  final String id;
  final String table;
  final String items;
  final OrderStatus status;
  final String timeElapsed;

  const Order({
    required this.id,
    required this.table,
    required this.items,
    required this.status,
    required this.timeElapsed,
  });
}

enum WaiterStatus { idle, assigned, delivering }

class Waiter {
  final String name;
  final WaiterStatus status;
  final String currentBatch;
  final List<String> tables;

  const Waiter({
    required this.name,
    required this.status,
    required this.currentBatch,
    required this.tables,
  });
}

class ChatMessage {
  final String customer;
  final String table;
  final String message;
  final String time;
  final bool isRead;

  const ChatMessage({
    required this.customer,
    required this.table,
    required this.message,
    required this.time,
    required this.isRead,
  });
}