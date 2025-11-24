import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LoyaltyProgram extends StatefulWidget {
  const LoyaltyProgram({super.key});

  @override
  State<LoyaltyProgram> createState() => _LoyaltyProgramState();
}

class _LoyaltyProgramState extends State<LoyaltyProgram>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabTitles = [
    'Program Setup',
    'Customer Management',
    'Redemptions & Rewards'
  ];

  // Mock data
  final List<LoyaltyTier> tiers = [
    LoyaltyTier(
        name: 'Bronze',
        minSpend: 0,
        pointsMultiplier: 1.0,
        color: Colors.orange,
        members: 450),
    LoyaltyTier(
        name: 'Silver',
        minSpend: 500,
        pointsMultiplier: 1.2,
        color: Colors.grey,
        members: 120),
    LoyaltyTier(
        name: 'Gold',
        minSpend: 1000,
        pointsMultiplier: 1.5,
        color: Colors.yellow,
        members: 65),
    LoyaltyTier(
        name: 'Platinum',
        minSpend: 2500,
        pointsMultiplier: 2.0,
        color: Colors.blue,
        members: 28),
  ];

  final List<Reward> rewards = [
    Reward(
        name: 'Free Appetizer',
        pointsCost: 500,
        tier: 'All',
        stock: 25,
        redeemed: 12),
    Reward(
        name: '10% Discount',
        pointsCost: 750,
        tier: 'Silver+',
        stock: -1,
        redeemed: 45),
    Reward(
        name: 'Free Main Course',
        pointsCost: 1500,
        tier: 'Gold+',
        stock: 15,
        redeemed: 8),
    Reward(
        name: 'VIP Dining Experience',
        pointsCost: 5000,
        tier: 'Platinum',
        stock: 5,
        redeemed: 2),
  ];

  final List<LoyaltyMember> members = [
    LoyaltyMember(
        name: 'John Smith',
        email: 'john@email.com',
        tier: 'Gold',
        points: 1250,
        totalSpent: 1567.89,
        lastVisit: '2024-01-15'),
    LoyaltyMember(
        name: 'Sarah Johnson',
        email: 'sarah@email.com',
        tier: 'Silver',
        points: 680,
        totalSpent: 789.45,
        lastVisit: '2024-01-14'),
    LoyaltyMember(
        name: 'Mike Davis',
        email: 'mike@email.com',
        tier: 'Platinum',
        points: 3420,
        totalSpent: 2890.12,
        lastVisit: '2024-01-13'),
    LoyaltyMember(
        name: 'Emily Wilson',
        email: 'emily@email.com',
        tier: 'Bronze',
        points: 250,
        totalSpent: 345.67,
        lastVisit: '2024-01-12'),
  ];

  final List<Redemption> pendingRedemptions = [
    Redemption(
        member: 'John Smith',
        reward: 'Free Main Course',
        points: 1500,
        date: '2024-01-15',
        status: 'Pending'),
    Redemption(
        member: 'Sarah Johnson',
        reward: '10% Discount',
        points: 750,
        date: '2024-01-14',
        status: 'Pending'),
  ];

  final List<Redemption> recentRedemptions = [
    Redemption(
        member: 'Mike Davis',
        reward: 'VIP Dining Experience',
        points: 5000,
        date: '2024-01-10',
        status: 'Fulfilled'),
    Redemption(
        member: 'Emily Wilson',
        reward: 'Free Appetizer',
        points: 500,
        date: '2024-01-08',
        status: 'Fulfilled'),
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
        title: const Text('Loyalty Program'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProgramSetup(),
          _buildCustomerManagement(),
          _buildRedemptionsRewards(),
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
              leading: const Icon(Iconsax.crown),
              title: const Text('Add New Tier'),
              onTap: () {
                Navigator.pop(context);
                _addNewTier();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.gift),
              title: const Text('Create New Reward'),
              onTap: () {
                Navigator.pop(context);
                _createNewReward();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.user_add),
              title: const Text('Add Member Manually'),
              onTap: () {
                Navigator.pop(context);
                _addMemberManually();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.discount_shape),
              title: const Text('Apply Manual Discount'),
              onTap: () {
                Navigator.pop(context);
                _applyManualDiscount();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Program Setup Tab
  Widget _buildProgramSetup() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Program Overview Cards
          Row(
            children: [
              _buildOverviewCard(
                  'Total Members', '663', Iconsax.people, Colors.blue),
              const SizedBox(width: 12),
              _buildOverviewCard(
                  'Active Tiers', '4', Iconsax.crown, Colors.orange),
              const SizedBox(width: 12),
              _buildOverviewCard(
                  'Available Rewards', '8', Iconsax.gift, Colors.purple),
            ],
          ),
          const SizedBox(height: 24),

          // Tier Configuration
          _buildSectionHeader('Tier Configuration', Iconsax.crown, Colors.orange),
          const SizedBox(height: 12),
          ...tiers.map((tier) => _buildTierCard(tier)),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: _addNewTier,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.add, size: 16),
                SizedBox(width: 4),
                Text('Add New Tier'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Rewards Catalog
          _buildSectionHeader('Rewards Catalog', Iconsax.gift, Colors.purple),
          const SizedBox(height: 12),
          ...rewards.map((reward) => _buildRewardCard(reward)),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: _createNewReward,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.add, size: 16),
                SizedBox(width: 4),
                Text('Add New Reward'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Points Rules
          _buildSectionHeader('Points Rules', Iconsax.calculator, Colors.green),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPointsRule('Base Points Rate', '1 point per \$1 spent',
                      Iconsax.dollar_circle),
                  _buildPointsRule(
                      'Tier Multipliers',
                      'Silver 1.2x • Gold 1.5x • Platinum 2.0x',
                      Iconsax.crown),
                  _buildPointsRule(
                      'Bonus Points Events', 'Double points on weekends', Iconsax.flash),
                  _buildPointsRule('Points Expiration',
                      'Points expire after 12 months', Iconsax.calendar),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: _editPointsRules,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.edit, size: 16),
                SizedBox(width: 4),
                Text('Edit Points Rules'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(
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

  Widget _buildTierCard(LoyaltyTier tier) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: tier.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Iconsax.crown, color: tier.color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tier.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  Text('\$${tier.minSpend}+ • ${tier.pointsMultiplier}x points',
                      style: TextStyle(color: Colors.grey[600])),
                  Text('${tier.members} members',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Iconsax.edit, size: 16),
                  onPressed: () => _editTier(tier),
                ),
                IconButton(
                  icon: const Icon(Iconsax.trash, size: 16),
                  onPressed: () => _deleteTier(tier),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardCard(Reward reward) {
    final isUnlimited = reward.stock == -1;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Iconsax.gift, color: Colors.purple, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reward.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  Text('${reward.pointsCost} points • ${reward.tier}',
                      style: TextStyle(color: Colors.grey[600])),
                  if (!isUnlimited)
                    Text('${reward.stock - reward.redeemed} available',
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 12)),
                  if (isUnlimited)
                    const Text('Unlimited stock',
                        style: TextStyle(color: Colors.green, fontSize: 12)),
                ],
              ),
            ),
            Row(
              children: [
                if (!isUnlimited && (reward.stock - reward.redeemed) < 5)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('LOW STOCK',
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Iconsax.edit, size: 16),
                  onPressed: () => _editReward(reward),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsRule(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: Colors.green, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Customer Management Tab
  Widget _buildCustomerManagement() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search and Filters
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search members...',
                      prefixIcon: const Icon(Iconsax.search_normal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilterChip(
                        label: const Text('All Tiers'),
                        selected: true,
                        onSelected: (_) {},
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Bronze'),
                        onSelected: (_) {},
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Silver'),
                        onSelected: (_) {},
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Gold+'),
                        onSelected: (_) {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Loyalty Members
          _buildSectionHeader('Loyalty Members', Iconsax.people, Colors.blue),
          const SizedBox(height: 12),
          ...members.map((member) => _buildMemberCard(member)),
          const SizedBox(height: 16),

          // Tier Progression
          _buildSectionHeader(
              'Tier Progression Analytics', Iconsax.chart, Colors.orange),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTierProgress('Bronze', 450, 663, Colors.orange),
                  _buildTierProgress('Silver', 120, 663, Colors.grey),
                  _buildTierProgress('Gold', 65, 663, Colors.yellow),
                  _buildTierProgress('Platinum', 28, 663, Colors.blue),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Points Balance Summary
          _buildSectionHeader(
              'Points Distribution', Iconsax.calculator, Colors.green),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPointsSummary(
                      'Total Points Issued', '1,245,800', Iconsax.trend_up),
                  _buildPointsSummary(
                      'Points Redeemed', '456,300', Iconsax.gift),
                  _buildPointsSummary(
                      'Active Points Balance', '789,500', Iconsax.wallet),
                  _buildPointsSummary(
                      'Avg. Points per Member', '1,189', Iconsax.user),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(LoyaltyMember member) {
    Color getTierColor(String tier) {
      switch (tier.toLowerCase()) {
        case 'platinum':
          return Colors.blue;
        case 'gold':
          return Colors.yellow;
        case 'silver':
          return Colors.grey;
        case 'bronze':
          return Colors.orange;
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
            color: getTierColor(member.tier).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child:
              Icon(Iconsax.profile_circle, color: getTierColor(member.tier)),
        ),
        title: Text(member.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(member.email),
            Text('Last visit: ${member.lastVisit}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: getTierColor(member.tier).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                member.tier,
                style: TextStyle(
                  color: getTierColor(member.tier),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text('${member.points} pts',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('\$${member.totalSpent}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        onTap: () => _viewMemberDetails(member),
      ),
    );
  }

  Widget _buildTierProgress(String tier, int count, int total, Color color) {
    final percentage = (count / total * 100).toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(tier, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Text('$count members', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(width: 8),
          Text('$percentage%',
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildPointsSummary(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: Colors.green, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // Redemptions & Rewards Tab
  Widget _buildRedemptionsRewards() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pending Redemptions
          _buildSectionHeader(
              'Pending Redemptions', Iconsax.clock, Colors.orange),
          const SizedBox(height: 12),
          if (pendingRedemptions.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Iconsax.tick_circle, size: 48, color: Colors.green),
                    SizedBox(height: 8),
                    Text('No Pending Redemptions',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('All redemptions are processed',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            )
          else
            ...pendingRedemptions
                .map((redemption) => _buildRedemptionCard(redemption, true)),
          const SizedBox(height: 24),

          // Recent Redemptions
          _buildSectionHeader(
              'Recent Redemptions', Iconsax.receipt, Colors.green),
          const SizedBox(height: 12),
          ...recentRedemptions
              .map((redemption) => _buildRedemptionCard(redemption, false)),
          const SizedBox(height: 24),

          // Reward Fulfillment Stats
          _buildSectionHeader(
              'Fulfillment Statistics', Iconsax.chart, Colors.purple),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildFulfillmentStat(
                      'Redemptions This Month', '24', Iconsax.gift),
                  _buildFulfillmentStat(
                      'Avg. Fulfillment Time', '2.3 days', Iconsax.clock),
                  _buildFulfillmentStat(
                      'Success Rate', '98.5%', Iconsax.tick_circle),
                  _buildFulfillmentStat('Pending Actions', '2', Iconsax.clock),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Discount Applications
          _buildSectionHeader(
              'Recent Discount Applications', Iconsax.discount_shape, Colors.blue),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDiscountApplication('John Smith',
                      '10% Loyalty Discount', '\$15.67', 'Today, 2:30 PM'),
                  _buildDiscountApplication('Sarah Johnson',
                      'Tier Bonus Discount', '\$12.50', 'Today, 1:15 PM'),
                  _buildDiscountApplication('Mike Davis', 'Points Redemption',
                      '\$25.00', 'Yesterday, 7:45 PM'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedemptionCard(Redemption redemption, bool isPending) {
    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'pending':
          return Colors.orange;
        case 'fulfilled':
          return Colors.green;
        case 'cancelled':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: getStatusColor(redemption.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isPending ? Iconsax.clock : Iconsax.tick_circle,
                color: getStatusColor(redemption.status),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(redemption.member,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(redemption.reward,
                      style: TextStyle(color: Colors.grey[600])),
                  Text('${redemption.points} points • ${redemption.date}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
            if (isPending)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Iconsax.tick_circle, size: 16),
                    onPressed: () => _fulfillRedemption(redemption),
                    tooltip: 'Mark as Fulfilled',
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.close_circle, size: 16),
                    onPressed: () => _cancelRedemption(redemption),
                    tooltip: 'Cancel Redemption',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFulfillmentStat(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: Colors.purple, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildDiscountApplication(
      String customer, String discount, String amount, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Iconsax.discount_shape, color: Colors.blue, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(discount,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.green)),
              Text(time,
                  style: TextStyle(color: Colors.grey[500], fontSize: 10)),
            ],
          ),
        ],
      ),
    );
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
  void _addNewTier() {}
  void _createNewReward() {}
  void _addMemberManually() {}
  void _applyManualDiscount() {}
  void _editPointsRules() {}
  void _editTier(LoyaltyTier tier) {}
  void _deleteTier(LoyaltyTier tier) {}
  void _editReward(Reward reward) {}
  void _viewMemberDetails(LoyaltyMember member) {}
  void _fulfillRedemption(Redemption redemption) {}
  void _cancelRedemption(Redemption redemption) {}
}

// Data Models
class LoyaltyTier {
  final String name;
  final double minSpend;
  final double pointsMultiplier;
  final Color color;
  final int members;

  const LoyaltyTier({
    required this.name,
    required this.minSpend,
    required this.pointsMultiplier,
    required this.color,
    required this.members,
  });
}

class Reward {
  final String name;
  final int pointsCost;
  final String tier;
  final int stock; // -1 for unlimited
  final int redeemed;

  const Reward({
    required this.name,
    required this.pointsCost,
    required this.tier,
    required this.stock,
    required this.redeemed,
  });
}

class LoyaltyMember {
  final String name;
  final String email;
  final String tier;
  final int points;
  final double totalSpent;
  final String lastVisit;

  const LoyaltyMember({
    required this.name,
    required this.email,
    required this.tier,
    required this.points,
    required this.totalSpent,
    required this.lastVisit,
  });
}

class Redemption {
  final String member;
  final String reward;
  final int points;
  final String date;
  final String status;

  const Redemption({
    required this.member,
    required this.reward,
    required this.points,
    required this.date,
    required this.status,
  });
}