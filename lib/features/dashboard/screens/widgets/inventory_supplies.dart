import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class InventorySupplies extends StatefulWidget {
  const InventorySupplies({super.key});

  @override
  State<InventorySupplies> createState() => _InventorySuppliersState();
}

class _InventorySuppliersState extends State<InventorySupplies>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabTitles = [
    'Stock Monitoring',
    'Supplier Management',
    'Receiving & Quality',
    'Payment Reconciliation'
  ];

  // Mock data
  final List<StockItem> stockItems = [
    StockItem(
        name: 'Chicken Breast',
        currentStock: 8,
        minStock: 15,
        unit: 'kg',
        category: 'Proteins'),
    StockItem(
        name: 'Tomatoes',
        currentStock: 12,
        minStock: 20,
        unit: 'kg',
        category: 'Vegetables'),
    StockItem(
        name: 'Olive Oil',
        currentStock: 5,
        minStock: 10,
        unit: 'L',
        category: 'Oils'),
    StockItem(
        name: 'Pasta',
        currentStock: 25,
        minStock: 15,
        unit: 'kg',
        category: 'Grains'),
    StockItem(
        name: 'Mozzarella',
        currentStock: 6,
        minStock: 12,
        unit: 'kg',
        category: 'Dairy'),
  ];

  final List<Supplier> suppliers = [
    Supplier(
        name: 'Fresh Foods Co.',
        contact: 'John Smith',
        phone: '+1-555-0123',
        rating: 4.5,
        status: 'Active'),
    Supplier(
        name: 'Quality Meats Ltd.',
        contact: 'Sarah Johnson',
        phone: '+1-555-0124',
        rating: 4.2,
        status: 'Active'),
    Supplier(
        name: 'Organic Produce Inc.',
        contact: 'Mike Davis',
        phone: '+1-555-0125',
        rating: 4.8,
        status: 'Active'),
  ];

  final List<PurchaseOrder> pendingOrders = [
    PurchaseOrder(
        id: 'PO-001',
        supplier: 'Fresh Foods Co.',
        items: 8,
        total: 245.67,
        status: 'Pending',
        date: '2024-01-15'),
    PurchaseOrder(
        id: 'PO-002',
        supplier: 'Quality Meats Ltd.',
        items: 5,
        total: 189.99,
        status: 'Confirmed',
        date: '2024-01-14'),
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
        title: const Text('Inventory & Suppliers'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStockMonitoring(),
          _buildSupplierManagement(),
          _buildReceivingQuality(),
          _buildPaymentReconciliation(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _showQuickActions,
      child: const Icon(Iconsax.add),
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
              leading: const Icon(Iconsax.shopping_cart),
              title: const Text('Create Purchase Order'),
              onTap: () {
                Navigator.pop(context);
                _createPurchaseOrder();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.box_add),
              title: const Text('Receive Delivery'),
              onTap: () {
                Navigator.pop(context);
                _receiveDelivery();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.user_add),
              title: const Text('Add New Supplier'),
              onTap: () {
                Navigator.pop(context);
                _addNewSupplier();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Stock Monitoring Tab
  Widget _buildStockMonitoring() {
    final lowStockItems =
        stockItems.where((item) => item.currentStock < item.minStock).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stock Summary Cards
          Row(
            children: [
              _buildSummaryCard('Total Items', stockItems.length.toString(),
                  Iconsax.box, Colors.blue),
              const SizedBox(width: 12),
              _buildSummaryCard('Low Stock', lowStockItems.length.toString(),
                  Iconsax.danger, Colors.orange),
              const SizedBox(width: 12),
              _buildSummaryCard(
                  'Out of Stock', '0', Iconsax.close_circle, Colors.red),
            ],
          ),
          const SizedBox(height: 24),

          // Low Stock Alerts
          if (lowStockItems.isNotEmpty) ...[
            _buildSectionHeader('Low Stock Alerts', Iconsax.danger, Colors.orange),
            const SizedBox(height: 12),
            ...lowStockItems.map((item) => _buildLowStockAlert(item)),
            const SizedBox(height: 24),
          ],

          // Current Stock Levels
          _buildSectionHeader('Current Stock Levels', Iconsax.box, Colors.blue),
          const SizedBox(height: 12),
          ...stockItems.map((item) => _buildStockItem(item)),
          const SizedBox(height: 16),

          // Stock Movement History
          _buildSectionHeader(
              'Recent Stock Movements', Iconsax.activity, Colors.purple),
          const SizedBox(height: 12),
          _buildStockMovementHistory(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(height: 8),
              Text(value,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text(title,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLowStockAlert(StockItem item) {
    return Card(
      color: Colors.orange.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Iconsax.danger, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                      'Current: ${item.currentStock}${item.unit} • Minimum: ${item.minStock}${item.unit}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: () => _createPurchaseOrderForItem(item),
              child: const Text('Reorder'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockItem(StockItem item) {
    final isLowStock = item.currentStock < item.minStock;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Iconsax.box, size: 20),
        ),
        title: Text(item.name),
        subtitle: Text('${item.category} • ${item.currentStock}${item.unit}'),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Min: ${item.minStock}${item.unit}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            if (isLowStock)
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('LOW',
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        onTap: () => _viewStockDetails(item),
      ),
    );
  }

  Widget _buildStockMovementHistory() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMovementItem(
                'Chicken Breast', 'Delivery Received', '+10 kg', 'Today, 09:30 AM'),
            _buildMovementItem(
                'Tomatoes', 'Order Consumption', '-5 kg', 'Today, 08:15 AM'),
            _buildMovementItem(
                'Olive Oil', 'Delivery Received', '+20 L', 'Yesterday, 02:45 PM'),
            _buildMovementItem(
                'Pasta', 'Order Consumption', '-3 kg', 'Yesterday, 01:20 PM'),
          ],
        ),
      ),
    );
  }

  Widget _buildMovementItem(
      String item, String type, String quantity, String time) {
    final isPositive = quantity.startsWith('+');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isPositive
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              isPositive ? Iconsax.add : Iconsax.minus,
              size: 16,
              color: isPositive ? Colors.green : Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(type,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(quantity,
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                  )),
              Text(time, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
            ],
          ),
        ],
      ),
    );
  }

  // Supplier Management Tab
  Widget _buildSupplierManagement() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Supplier Directory
          _buildSectionHeader('Supplier Directory', Iconsax.people, Colors.green),
          const SizedBox(height: 12),
          ...suppliers.map((supplier) => _buildSupplierCard(supplier)),
          const SizedBox(height: 24),

          // Active Purchase Orders
          _buildSectionHeader(
              'Active Purchase Orders', Iconsax.shopping_cart, Colors.blue),
          const SizedBox(height: 12),
          ...pendingOrders.map((order) => _buildPurchaseOrderCard(order)),
          const SizedBox(height: 16),

          // Quick Actions
          _buildSectionHeader('Quick Actions', Iconsax.flash, Colors.purple),
          const SizedBox(height: 12),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            children: [
              _buildQuickActionCard('Create PO', Iconsax.add_circle, Colors.blue,
                  _createPurchaseOrder),
              _buildQuickActionCard('Supplier List', Iconsax.people,
                  Colors.green, _viewAllSuppliers),
              _buildQuickActionCard('Order History', Iconsax.document,
                  Colors.orange, _viewOrderHistory),
              _buildQuickActionCard('Track Shipments', Iconsax.truck,
                  Colors.purple, _trackShipments),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierCard(Supplier supplier) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Iconsax.people, size: 20),
        ),
        title: Text(supplier.name),
        subtitle: Text('${supplier.contact} • ${supplier.phone}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.star, size: 16, color: Colors.orange),
            const SizedBox(width: 4),
            Text(supplier.rating.toString()),
          ],
        ),
        onTap: () => _viewSupplierDetails(supplier),
      ),
    );
  }

  Widget _buildPurchaseOrderCard(PurchaseOrder order) {
    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'pending':
          return Colors.orange;
        case 'confirmed':
          return Colors.blue;
        case 'shipped':
          return Colors.purple;
        case 'delivered':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Iconsax.shopping_cart, size: 20),
        ),
        title: Text('${order.id} - ${order.supplier}'),
        subtitle: Text('${order.items} items • \$${order.total} • ${order.date}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: getStatusColor(order.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            order.status,
            style: TextStyle(
              color: getStatusColor(order.status),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () => _viewOrderDetails(order),
      ),
    );
  }

  Widget _buildQuickActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  // Receiving & Quality Tab
  Widget _buildReceivingQuality() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pending Receivals
          _buildSectionHeader(
              'Pending Receivals', Iconsax.truck_tick, Colors.blue),
          const SizedBox(height: 12),
          _buildPendingReceivalCard(
              'PO-001 - Fresh Foods Co.', 'Expected: Today, 2:00 PM', 8),
          _buildPendingReceivalCard(
              'PO-002 - Quality Meats Ltd.', 'Expected: Tomorrow, 10:00 AM', 5),
          const SizedBox(height: 24),

          // Recent Receivals
          _buildSectionHeader(
              'Recent Receivals', Iconsax.box_tick, Colors.green),
          const SizedBox(height: 12),
          _buildReceivalHistoryItem(
              'PO-003 - Organic Produce', 'Completed', 'Today, 09:30 AM'),
          _buildReceivalHistoryItem(
              'PO-004 - Dairy Farms Inc.', 'Completed', 'Yesterday, 03:15 PM'),
          const SizedBox(height: 24),

          // Quality Inspections
          _buildSectionHeader(
              'Quality Inspections', Iconsax.verify, Colors.orange),
          const SizedBox(height: 12),
          _buildInspectionItem(
              'Chicken Breast - Fresh Foods Co.', 'Passed', 'Today, 09:45 AM'),
          _buildInspectionItem(
              'Tomatoes - Organic Produce', 'Minor Issues', 'Today, 09:35 AM'),
          const SizedBox(height: 24),

          // Item Rejection Log
          _buildSectionHeader(
              'Rejection Log', Iconsax.close_circle, Colors.red),
          const SizedBox(height: 12),
          _buildRejectionItem(
              'Damaged Packaging - Olive Oil', 'PO-003', 'Today, 09:40 AM'),
        ],
      ),
    );
  }

  Widget _buildPendingReceivalCard(String title, String subtitle, int items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Iconsax.truck, size: 20),
        ),
        title: Text(title),
        subtitle: Text('$subtitle • $items items'),
        trailing: FilledButton(
          onPressed: () => _receiveDelivery(),
          child: const Text('Receive'),
        ),
      ),
    );
  }

  Widget _buildReceivalHistoryItem(String title, String status, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Iconsax.box_tick, size: 20),
        ),
        title: Text(title),
        subtitle: Text(time),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: const TextStyle(
                color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildInspectionItem(String item, String result, String time) {
    final isPassed = result.toLowerCase() == 'passed';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isPassed
                ? Colors.green.withOpacity(0.1)
                : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isPassed ? Iconsax.tick_circle : Iconsax.info_circle,
            size: 20,
            color: isPassed ? Colors.green : Colors.orange,
          ),
        ),
        title: Text(item),
        subtitle: Text(time),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isPassed
                ? Colors.green.withOpacity(0.1)
                : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            result,
            style: TextStyle(
              color: isPassed ? Colors.green : Colors.orange,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRejectionItem(String reason, String poNumber, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.red.withOpacity(0.05),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Iconsax.close_circle, size: 20, color: Colors.red),
        ),
        title: Text(reason),
        subtitle: Text('$poNumber • $time'),
        trailing: IconButton(
          icon: const Icon(Iconsax.eye),
          onPressed: () => _viewRejectionDetails(reason),
        ),
      ),
    );
  }

  // Payment Reconciliation Tab
  Widget _buildPaymentReconciliation() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pending Payments
          _buildSectionHeader('Pending Payments', Iconsax.clock, Colors.orange),
          const SizedBox(height: 12),
          _buildPaymentCard(
              'Fresh Foods Co.', '\$245.67', 'Due: Jan 20, 2024', 'PO-001'),
          _buildPaymentCard(
              'Quality Meats Ltd.', '\$189.99', 'Due: Jan 25, 2024', 'PO-002'),
          const SizedBox(height: 24),

          // Payment History
          _buildSectionHeader('Recent Payments', Iconsax.receipt, Colors.green),
          const SizedBox(height: 12),
          _buildPaymentHistoryItem(
              'Organic Produce Inc.', '\$156.23', 'Paid', 'Jan 10, 2024'),
          _buildPaymentHistoryItem(
              'Dairy Farms Inc.', '\$89.45', 'Paid', 'Jan 5, 2024'),
          const SizedBox(height: 24),

          // Supplier Performance
          _buildSectionHeader(
              'Supplier Performance', Iconsax.chart, Colors.purple),
          const SizedBox(height: 12),
          _buildSupplierPerformanceCard('Fresh Foods Co.', 4.5, 98, 2),
          _buildSupplierPerformanceCard('Organic Produce Inc.', 4.8, 99, 1),
          _buildSupplierPerformanceCard('Quality Meats Ltd.', 4.2, 95, 3),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(
      String supplier, String amount, String dueDate, String poNumber) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Iconsax.clock, size: 20),
        ),
        title: Text(supplier),
        subtitle: Text('$poNumber • $dueDate'),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            FilledButton.tonal(
              onPressed: () => _processPayment(supplier, amount),
              child: const Text('Pay'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentHistoryItem(
      String supplier, String amount, String status, String date) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Iconsax.receipt, size: 20),
        ),
        title: Text(supplier),
        subtitle: Text(date),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount, style: TextStyle(fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierPerformanceCard(
      String supplier, double rating, int fulfillment, int deliveries) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(supplier,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Iconsax.star, size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(rating.toString()),
                      const SizedBox(width: 12),
                      const Icon(Iconsax.tick_circle,
                          size: 14, color: Colors.green),
                      const SizedBox(width: 4),
                      Text('$fulfillment%'),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getPerformanceColor(rating).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getPerformanceText(rating),
                style: TextStyle(
                  color: _getPerformanceColor(rating),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPerformanceColor(double rating) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 4.0) return Colors.blue;
    if (rating >= 3.5) return Colors.orange;
    return Colors.red;
  }

  String _getPerformanceText(double rating) {
    if (rating >= 4.5) return 'Excellent';
    if (rating >= 4.0) return 'Good';
    if (rating >= 3.5) return 'Average';
    return 'Poor';
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // Action methods (to be implemented)
  void _createPurchaseOrder() {
    // Logic to navigate to a new PO screen
  }
  void _receiveDelivery() {
    // Logic to show a delivery receiving modal/screen
  }
  void _addNewSupplier() {
    // Logic to show an "Add Supplier" form
  }
  void _createPurchaseOrderForItem(StockItem item) {
    // Logic to pre-fill a new PO with this item
  }
  void _viewStockDetails(StockItem item) {
    // Logic to navigate to an item detail screen
  }
  void _viewSupplierDetails(Supplier supplier) {
    // Logic to navigate to a supplier detail screen
  }
  void _viewOrderDetails(PurchaseOrder order) {
    // Logic to navigate to a PO detail screen
  }
  void _viewAllSuppliers() {
    // Logic to navigate to the full supplier list
  }
  void _viewOrderHistory() {
    // Logic to navigate to PO history
  }
  void _trackShipments() {
    // Logic to show a shipment tracking interface
  }
  void _viewRejectionDetails(String reason) {
    // Logic to show details of a rejection
  }
  void _processPayment(String supplier, String amount) {
    // Logic to show a payment confirmation dialog
  }
}

// Data Models
class StockItem {
  final String name;
  final int currentStock;
  final int minStock;
  final String unit;
  final String category;

  const StockItem({
    required this.name,
    required this.currentStock,
    required this.minStock,
    required this.unit,
    required this.category,
  });
}

class Supplier {
  final String name;
  final String contact;
  final String phone;
  final double rating;
  final String status;

  const Supplier({
    required this.name,
    required this.contact,
    required this.phone,
    required this.rating,
    required this.status,
  });
}

class PurchaseOrder {
  final String id;
  final String supplier;
  final int items;
  final double total;
  final String status;
  final String date;

  const PurchaseOrder({
    required this.id,
    required this.supplier,
    required this.items,
    required this.total,
    required this.status,
    required this.date,
  });
}