import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

// --- Data Models (Using models from CustomerCommunications) ---
enum ChatPriority { normal, urgent, critical }
enum ChatStatus { active, resolved, closed }

class ChatConversation {
  final String id;
  final String customer;
  final String table;
  final String lastMessage;
  final String time; // Simplified time string
  final ChatStatus status;
  final ChatPriority priority;
  final String assignedTo; // Staff name or empty
  final int unreadCount;

  const ChatConversation({
    required this.id,
    required this.customer,
    required this.table,
    required this.lastMessage,
    required this.time,
    required this.status,
    required this.priority,
    required this.assignedTo,
    required this.unreadCount,
  });
}

enum FeedbackSentiment { positive, neutral, negative }

class CustomerFeedback {
  final String customer;
  final String table;
  final int rating; // Using int 1-5 rating
  final String comment;
  final String date; // Simplified date string
  final FeedbackSentiment sentiment;
  final bool responded;
  final String followUp; // Follow-up action description

  const CustomerFeedback({
    required this.customer,
    required this.table,
    required this.rating,
    required this.comment,
    required this.date,
    required this.sentiment,
    required this.responded,
    required this.followUp,
  });
}

enum StaffStatus { onDuty, breakTime, offDuty }

class StaffPerformance {
  final String name;
  final String role;
  final String responseTime; // Simplified time string
  final double satisfaction; // Avg satisfaction rating
  final int chatsHandled;
  final double avgRating; // Avg feedback rating associated with staff
  final StaffStatus status;

  const StaffPerformance({
    required this.name,
    required this.role,
    required this.responseTime,
    required this.satisfaction,
    required this.chatsHandled,
    required this.avgRating,
    required this.status,
  });
}

// --- Main Customer Communications Screen ---

class CustomerCommunication extends StatefulWidget {
  const CustomerCommunication({super.key});

  @override
  State<CustomerCommunication> createState() => _CustomerCommunicationsState();
}

class _CustomerCommunicationsState extends State<CustomerCommunication>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabTitles = [
    'Live Chat',
    'Feedback & Reviews',
    'Staff Performance'
  ];

  // --- Mock Data (Using data from CustomerCommunications) ---
  final List<ChatConversation> activeConversations = [
    ChatConversation(
      id: 'CHAT-001',
      customer: 'John Smith',
      table: 'T02',
      lastMessage: 'Can we get some extra napkins?',
      time: '2 min ago',
      status: ChatStatus.active,
      priority: ChatPriority.normal,
      assignedTo: 'Sarah Johnson',
      unreadCount: 0, // Mark as read for demo
    ),
    ChatConversation(
      id: 'CHAT-002',
      customer: 'Emily Wilson',
      table: 'T04',
      lastMessage: 'Is our food almost ready?',
      time: '5 min ago',
      status: ChatStatus.active,
      priority: ChatPriority.urgent,
      assignedTo: '', // Unassigned
      unreadCount: 1,
    ),
    ChatConversation(
      id: 'CHAT-003',
      customer: 'Mike Davis',
      table: 'T07',
      lastMessage: 'This steak is perfect, thank you!',
      time: '8 min ago',
      status: ChatStatus.active,
      priority: ChatPriority.normal,
      assignedTo: 'Mike Davis',
      unreadCount: 0,
    ),
    ChatConversation(
      id: 'CHAT-004',
      customer: 'Sarah Miller',
      table: 'T05',
      lastMessage: 'We have a food allergy at our table',
      time: '1 min ago',
      status: ChatStatus.active,
      priority: ChatPriority.critical, // Critical priority
      assignedTo: '', // Unassigned
      unreadCount: 1, // Marked as unread
    ),
  ];

  final List<CustomerFeedback> feedbackList = [
    CustomerFeedback(
      customer: 'John Smith',
      table: 'T02',
      rating: 5,
      comment: 'Excellent service and amazing food! The staff was very attentive.',
      date: '2024-01-15',
      sentiment: FeedbackSentiment.positive,
      responded: true,
      followUp: 'Sent thank you note',
    ),
    CustomerFeedback(
      customer: 'Emily Wilson',
      table: 'T04',
      rating: 3,
      comment: 'Food was good but wait time was longer than expected.',
      date: '2024-01-14',
      sentiment: FeedbackSentiment.neutral,
      responded: false, // Needs response
      followUp: '',
    ),
    CustomerFeedback(
      customer: 'Mike Davis',
      table: 'T07',
      rating: 1,
      comment: 'Very disappointed with the service. Our orders were mixed up.',
      date: '2024-01-14',
      sentiment: FeedbackSentiment.negative,
      responded: true,
      followUp: 'Offered complimentary dessert',
    ),
    CustomerFeedback(
      customer: 'Sarah Miller',
      table: 'T05',
      rating: 4,
      comment: 'Great atmosphere and friendly staff. Will come back again!',
      date: '2024-01-13',
      sentiment: FeedbackSentiment.positive,
      responded: false, // Needs response
      followUp: '',
    ),
  ];

  final List<StaffPerformance> staffPerformance = [
    StaffPerformance(
      name: 'Sarah Johnson',
      role: 'Head Waiter',
      responseTime: '2.3 min',
      satisfaction: 4.8,
      chatsHandled: 24,
      avgRating: 4.7,
      status: StaffStatus.onDuty,
    ),
    StaffPerformance(
      name: 'Mike Davis',
      role: 'Waiter',
      responseTime: '3.1 min',
      satisfaction: 4.5,
      chatsHandled: 18,
      avgRating: 4.4,
      status: StaffStatus.onDuty,
    ),
    StaffPerformance(
      name: 'Emily Wilson',
      role: 'Waiter',
      responseTime: '4.2 min',
      satisfaction: 4.2,
      chatsHandled: 15,
      avgRating: 4.1,
      status: StaffStatus.breakTime,
    ),
    StaffPerformance(
      name: 'John Smith',
      role: 'Trainee',
      responseTime: '5.8 min',
      satisfaction: 3.9,
      chatsHandled: 8,
      avgRating: 3.8,
      status: StaffStatus.onDuty,
    ),
  ];
  // --- End Mock Data ---


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
        title: const Text('Customer Communications'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true, // Allow scrolling if tabs don't fit
          tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLiveChatManagement(),
          _buildFeedbackReviews(),
          _buildStaffPerformance(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    // FAB from CustomerCommunications
    return FloatingActionButton(
      onPressed: _showQuickActions,
      child: const Icon(Iconsax.message_add),
      tooltip: 'Quick Actions',
    );
  }

  void _showQuickActions() {
    // Quick Actions from CustomerCommunications
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.message),
              title: const Text('Broadcast Message'),
              onTap: () {
                Navigator.pop(context);
                _sendBroadcastMessage();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.chart),
              title: const Text('Generate Report'),
              onTap: () {
                Navigator.pop(context);
                _generateReport();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.setting),
              title: const Text('Communication Settings'),
              onTap: () {
                Navigator.pop(context);
                _openSettings();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.export),
              title: const Text('Export Conversations'),
              onTap: () {
                Navigator.pop(context);
                _exportData();
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Tab Content Build Methods ---

  /// **Live Chat Management Tab**
  Widget _buildLiveChatManagement() {
    // Separate lists based on priority and read status
    final criticalConversations = activeConversations
        .where((c) => c.priority == ChatPriority.critical && c.unreadCount > 0)
        .toList();
     final urgentConversations = activeConversations
        .where((c) => c.priority == ChatPriority.urgent && c.unreadCount > 0)
        .toList();
    final normalUnreadConversations = activeConversations
        .where((c) => c.priority == ChatPriority.normal && c.unreadCount > 0)
        .toList();
    final assignedReadConversations = activeConversations
        .where((c) => c.unreadCount == 0 && c.assignedTo.isNotEmpty)
        .toList();

     // Calculate stats
     int unassignedCount = activeConversations.where((c) => c.assignedTo.isEmpty && c.unreadCount > 0).length;


    return Column(
      children: [
        // Stats Overview
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildChatStat('Active', activeConversations.length.toString(),
                  Iconsax.messages_2, Colors.blue),
              _buildChatStat(
                  'Urgent/Crit', (urgentConversations.length + criticalConversations.length).toString(), Iconsax.danger, Colors.red), // Combined Urgent/Critical
              _buildChatStat('Unassigned', unassignedCount.toString(),
                  Iconsax.user_remove, Colors.orange), // Unassigned and Unread
               _buildChatStat('Avg. Wait', '1.5 min', // Example Static data
                  Iconsax.clock, Colors.green),
            ],
          ),
        ),

        // Lists of Chats (Using Expanded for scrolling)
        Expanded(
          child: ListView(
             padding: const EdgeInsets.only(top: 8.0), // Add padding above list
            children: [
              if (criticalConversations.isNotEmpty) ...[
                _buildSectionHeader('Critical Requests', Iconsax.danger, Colors.red, isFirstSection: true),
                ...criticalConversations.map((convo) => _buildChatConversationCard(convo)),
                const SizedBox(height: 8), // Space after section
              ],
              if (urgentConversations.isNotEmpty) ...[
                _buildSectionHeader('Urgent Requests', Iconsax.info_circle, Colors.orange),
                ...urgentConversations.map((convo) => _buildChatConversationCard(convo)),
                const SizedBox(height: 8),
              ],
               if (normalUnreadConversations.isNotEmpty) ...[
                _buildSectionHeader('New Messages', Iconsax.message_add_1, Colors.blue),
                ...normalUnreadConversations.map((convo) => _buildChatConversationCard(convo)),
                const SizedBox(height: 8),
              ],
              if (assignedReadConversations.isNotEmpty) ...[
                _buildSectionHeader('Ongoing Conversations', Iconsax.message_text_1, Colors.grey),
                ...assignedReadConversations.map((convo) => _buildChatConversationCard(convo)),
                 const SizedBox(height: 8),
              ],
               // Add a message if all lists are empty
              if (criticalConversations.isEmpty && urgentConversations.isEmpty && normalUnreadConversations.isEmpty && assignedReadConversations.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.message_search, size: 48, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No active conversations', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// **Feedback & Reviews Tab**
  Widget _buildFeedbackReviews() {
    final positiveFeedback = feedbackList
        .where((f) => f.sentiment == FeedbackSentiment.positive)
        .toList();
    final negativeFeedback = feedbackList
        .where((f) => f.sentiment == FeedbackSentiment.negative)
        .toList();
    final neutralFeedback = feedbackList
        .where((f) => f.sentiment == FeedbackSentiment.neutral)
        .toList();
     final needsResponseFeedback = feedbackList.where((f) => !f.responded).toList();

     // Calculate stats
     double avgRating = feedbackList.isNotEmpty
        ? feedbackList.map((f) => f.rating).reduce((a, b) => a + b) / feedbackList.length
        : 0.0;
      double responseRate = feedbackList.isNotEmpty
        ? feedbackList.where((f) => f.responded).length / feedbackList.length * 100
        : 0.0;


    return Column(
      children: [
        // Rating Overview
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRatingStat('Avg. Rating', avgRating.toStringAsFixed(1), Iconsax.star, Colors.orange),
              _buildRatingStat('Total Reviews', feedbackList.length.toString(),
                  Iconsax.messages, Colors.blue), // Reusing from Chat Stats section
               _buildRatingStat('Needs Response', needsResponseFeedback.length.toString(),
                  Iconsax.message_edit, Colors.red),
              _buildRatingStat('Response Rate', '${responseRate.toStringAsFixed(0)}%',
                  Iconsax.tick_circle, Colors.green),
            ],
          ),
        ),

        // Optional: Sentiment Tabs/Filters could go here if desired

        // Feedback List (Scrollable)
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0), // Add padding around the list
             children: [
               if (needsResponseFeedback.isNotEmpty) ...[
                _buildSectionHeader('Needs Response', Iconsax.message_edit, Colors.red, isFirstSection: true),
                ...needsResponseFeedback.map((f) => _buildFeedbackCard(f)),
                const SizedBox(height: 16), // Space after section
               ],
               // Optionally show other feedback sections or just all history
                _buildSectionHeader('Feedback History', Iconsax.receipt_search, Colors.grey),
                ...feedbackList.where((f) => f.responded).map((f) => _buildFeedbackCard(f)), // Show responded items
                const SizedBox(height: 16),
             ],
          )

        ),
      ],
    );
  }

  /// **Staff Performance Tab**
  Widget _buildStaffPerformance() {
      // Calculate overall stats
      double overallAvgSatisfaction = staffPerformance.isNotEmpty
        ? staffPerformance.map((s) => s.satisfaction).reduce((a, b) => a + b) / staffPerformance.length
        : 0.0;
     int activeStaffCount = staffPerformance.where((s) => s.status == StaffStatus.onDuty).length;
     // Note: Avg response time needs proper Duration calculation, mock string used here for simplicity

    return Column(
      children: [
        // Performance Overview
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPerformanceStat('Avg. Response', '3.2 min', Iconsax.clock, Colors.blue), // Example static
              _buildPerformanceStat('Avg. Satisfaction', overallAvgSatisfaction.toStringAsFixed(1), Iconsax.like_1, Colors.green),
              _buildPerformanceStat('Chats Handled (Today)', '65', Iconsax.message_text, Colors.orange), // Example static
              _buildPerformanceStat('Active Staff', activeStaffCount.toString(), Iconsax.profile_2user, Colors.purple),
            ],
          ),
        ),

        // Staff List (Scrollable)
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16), // Add padding around the list
            itemCount: staffPerformance.length,
            itemBuilder: (context, index) =>
                _buildStaffPerformanceCard(staffPerformance[index]),
          ),
        ),

        // Team Performance Metrics Section (Optional bottom section)
        // Container(
        //   padding: const EdgeInsets.all(16),
        //   color: Colors.white,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //        Text('Team Performance Targets', style: Theme.of(context).textTheme.titleMedium),
        //        const SizedBox(height: 12),
        //       _buildPerformanceMetric('Response Time Target', '< 3.0 min', '3.2 min', Colors.red), // Example: Target missed
        //       _buildPerformanceMetric('Satisfaction Target', '> 4.5', '4.4', Colors.orange), // Example: Target nearly missed
        //       // _buildPerformanceMetric('Resolution Rate', '> 95%', '92%', Colors.blue),
        //     ],
        //   ),
        // ),
      ],
    );
  }


  // --- Helper Widgets ---

  /// Builds a card for a chat conversation in the list.
  Widget _buildChatConversationCard(ChatConversation conversation) {
    Color getPriorityColor(ChatPriority priority) {
      switch (priority) {
        case ChatPriority.critical: return Colors.red;
        case ChatPriority.urgent: return Colors.orange;
        case ChatPriority.normal: return Colors.blue;
      }
    }
    IconData getPriorityIcon(ChatPriority priority) {
       switch (priority) {
        case ChatPriority.critical: return Iconsax.danger5; // More severe icon
        case ChatPriority.urgent: return Iconsax.warning_25; // Warning icon
        case ChatPriority.normal: return Iconsax.message_text_1;
      }
    }
    bool isUnread = conversation.unreadCount > 0;

    return Card(
      elevation: isUnread ? 2 : 0.5,
      margin: const EdgeInsets.only(bottom: 8),
      color: conversation.priority == ChatPriority.critical
          ? Colors.red.withOpacity(0.05)
          : (isUnread ? Colors.blue.withOpacity(0.05) : Colors.white),
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(12),
         side: isUnread ? BorderSide(color: getPriorityColor(conversation.priority).withOpacity(0.5)) : BorderSide(color: Colors.grey.shade200)
       ),
      child: ListTile(
         dense: true,
        leading: Stack(
          clipBehavior: Clip.none, // Allow badge to overflow
          children: [
            Container(
              padding: const EdgeInsets.all(10), // Increased padding
              decoration: BoxDecoration(
                color: getPriorityColor(conversation.priority).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(getPriorityIcon(conversation.priority),
                  color: getPriorityColor(conversation.priority), size: 20), // Increased size
            ),
            if (isUnread)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                   padding: const EdgeInsets.all(4), // Slightly larger badge
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                     border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1)), // White border
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16), // Ensure min size
                  child: Text(
                    conversation.unreadCount.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9, // Slightly larger font
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Text(conversation.customer, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Table ${conversation.table}',
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ),
             if (conversation.priority == ChatPriority.critical)
               Padding(
                 padding: const EdgeInsets.only(left: 4.0),
                 child: Icon(Iconsax.danger5, size: 14, color: Colors.red),
               ),
              if (conversation.priority == ChatPriority.urgent)
               Padding(
                 padding: const EdgeInsets.only(left: 4.0),
                 child: Icon(Iconsax.warning_25, size: 14, color: Colors.orange),
               ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(conversation.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis), // Limit lines
            const SizedBox(height: 4),
            Row(
              children: [
                Text(conversation.time, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                const Spacer(), // Pushes assigned staff to the right
                if (conversation.assignedTo.isNotEmpty) ...[
                   Icon(Iconsax.user_tick, size: 12, color: Colors.green.shade700), // User assigned icon
                   const SizedBox(width: 4),
                   Text(conversation.assignedTo, style: TextStyle(fontSize: 10, color: Colors.green.shade700)),
                 ] else if (isUnread) ...[ // Only show unassigned if it's unread
                   Icon(Iconsax.user_remove, size: 12, color: Colors.orange.shade700), // User unassigned icon
                   const SizedBox(width: 4),
                   Text('Unassigned', style: TextStyle(fontSize: 10, color: Colors.orange.shade700)),
                 ]

              ],
            ),
          ],
        ),
        trailing: IconButton( // Use trailing for the main action
             icon: const Icon(Iconsax.arrow_right_3, size: 18), // Arrow to open
             onPressed: () => _openChat(conversation),
             tooltip: 'Open Chat',
             visualDensity: VisualDensity.compact,
           ),
         onTap: () => _openChat(conversation), // Allow tapping anywhere
      ),
    );
  }

  /// Builds a stat widget for the chat overview header.
  Widget _buildChatStat(String label, String value, IconData icon, Color color) {
    return Column(
       mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10), // Adjusted size
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Icon(icon, color: color, size: 20), // Adjusted size
        ),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)), // Adjusted size
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)), // Adjusted size
      ],
    );
  }

   /// Builds a card for displaying customer feedback.
  Widget _buildFeedbackCard(CustomerFeedback feedback) {
    Color getSentimentColor(FeedbackSentiment sentiment) {
      switch (sentiment) {
        case FeedbackSentiment.positive: return Colors.green;
        case FeedbackSentiment.neutral: return Colors.orange;
        case FeedbackSentiment.negative: return Colors.red;
      }
    }
    IconData getSentimentIcon(FeedbackSentiment sentiment) {
      switch (sentiment) {
        case FeedbackSentiment.positive: return Iconsax.like_1;
        case FeedbackSentiment.neutral: return Iconsax.info_circle;
        case FeedbackSentiment.negative: return Iconsax.dislike;
      }
    }
     bool needsResponse = !feedback.responded;

    return Card(
      elevation: needsResponse ? 2 : 0.5,
      margin: const EdgeInsets.only(bottom: 12),
       color: needsResponse ? Colors.orange.withOpacity(0.05) : Colors.white,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(12),
         side: needsResponse ? BorderSide(color: Colors.orange.shade200) : BorderSide(color: Colors.grey.shade200)
       ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8), // Icon background
                  decoration: BoxDecoration(
                    color: getSentimentColor(feedback.sentiment).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(getSentimentIcon(feedback.sentiment),
                      color: getSentimentColor(feedback.sentiment), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(feedback.customer, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('Table ${feedback.table} • ${feedback.date}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                _buildRatingStars(feedback.rating), // Star rating
              ],
            ),
            const SizedBox(height: 12),

            // Comment
            Text(
              feedback.comment,
              style: const TextStyle(fontSize: 14),
              maxLines: 3, // Limit comment lines initially
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Follow-up Info (if responded)
            if (feedback.responded && feedback.followUp.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                     Icon(Iconsax.tick_circle, size: 14, color: Colors.green.shade700),
                     const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Follow-up: ${feedback.followUp}',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade900,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),

             if (feedback.responded && feedback.followUp.isEmpty) // Show responded chip if no follow-up text
                Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                     avatar: Icon(Iconsax.tick_circle, size: 14, color: Colors.green.shade700),
                     label: Text('Responded', style: TextStyle(fontSize: 11, color: Colors.green.shade700)),
                     backgroundColor: Colors.green.withOpacity(0.1),
                      visualDensity: VisualDensity.compact,
                       padding: const EdgeInsets.symmetric(horizontal: 4),
                   ),
                ),


            // Actions
            if (needsResponse) ...[
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                     TextButton.icon(
                      icon: const Icon(Iconsax.message_edit, size: 16),
                      label: const Text('Respond'),
                      onPressed: () => _respondToFeedback(feedback),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        foregroundColor: Colors.orange.shade800
                      ),
                    ),
                    const SizedBox(width: 8),
                     TextButton.icon(
                      icon: const Icon(Iconsax.tick_square, size: 16),
                      label: const Text('Mark Responded'),
                      onPressed: () => _markFeedbackResponded(feedback),
                      style: TextButton.styleFrom(
                         visualDensity: VisualDensity.compact,
                         foregroundColor: Colors.grey.shade600
                      ),
                    ),
                  ],
                ),
            ] else // Show different action if already responded
               Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                   IconButton(
                    icon: const Icon(Iconsax.more, size: 18),
                    onPressed: () => _showFeedbackActions(feedback),
                    tooltip: 'More Actions',
                     visualDensity: VisualDensity.compact,
                   ),
                 ],
               ),
          ],
        ),
      ),
    );
  }

  /// Helper for Star Rating Display.
  Widget _buildRatingStars(int rating) {
    return Row(
       mainAxisSize: MainAxisSize.min, // Keep compact
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Iconsax.star1 : Iconsax.star, // Filled vs Outline
          size: 18, // Slightly larger stars
          color: index < rating ? Colors.amber.shade600 : Colors.grey.shade300,
        );
      }),
    );
  }


   /// Builds a stat widget for the feedback overview header.
  Widget _buildRatingStat(String label, String value, IconData icon, Color color) {
    // Similar to _buildChatStat but potentially different styling if needed
    return Column(
       mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
      ],
    );
  }


   /// Builds a card displaying performance metrics for a staff member.
  Widget _buildStaffPerformanceCard(StaffPerformance staff) {
    Color getStatusColor(StaffStatus status) {
      switch (status) {
        case StaffStatus.onDuty: return Colors.green;
        case StaffStatus.breakTime: return Colors.orange;
        case StaffStatus.offDuty: return Colors.grey;
      }
    }
    String getStatusText(StaffStatus status) {
       switch (status) {
        case StaffStatus.onDuty: return 'On Duty';
        case StaffStatus.breakTime: return 'On Break';
        case StaffStatus.offDuty: return 'Off Duty';
      }
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Iconsax.profile_circle, color: Colors.blue, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(staff.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      Text(staff.role, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                 Chip( // Status Chip
                   avatar: CircleAvatar(backgroundColor: getStatusColor(staff.status), radius: 4),
                   label: Text(getStatusText(staff.status), style: TextStyle(fontSize: 10, color: getStatusColor(staff.status))),
                   backgroundColor: getStatusColor(staff.status).withOpacity(0.1),
                   side: BorderSide.none,
                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                   visualDensity: VisualDensity.compact,
                 ),
              ],
            ),
            const Divider(height: 20), // Use Divider

            // Performance Metrics Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStaffMetric('Avg. Response', staff.responseTime, Iconsax.clock),
                _buildStaffMetric('Satisfaction', staff.satisfaction.toStringAsFixed(1), Iconsax.like_1), // Changed icon
                _buildStaffMetric('Chats Handled', staff.chatsHandled.toString(), Iconsax.message_text), // Changed icon
                _buildStaffMetric('Avg. Rating', staff.avgRating.toStringAsFixed(1), Iconsax.star_1), // Changed icon
              ],
            ),
            const SizedBox(height: 12),

            // Actions Row
            Row(
               mainAxisAlignment: MainAxisAlignment.end, // Align buttons to end
              children: [
                 TextButton.icon(
                  icon: const Icon(Iconsax.chart_2, size: 16), // Analytics icon
                  label: const Text('Analytics'),
                  onPressed: () => _viewStaffAnalytics(staff),
                   style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  icon: const Icon(Iconsax.message, size: 16),
                  label: const Text('Message'),
                  onPressed: () => _messageStaff(staff),
                   style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                ),
                 const SizedBox(width: 8),
                 TextButton.icon(
                  icon: const Icon(Iconsax.eye, size: 16),
                  label: const Text('Details'),
                  onPressed: () => _viewStaffDetails(staff),
                  style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper for individual staff metrics within the card.
  Widget _buildStaffMetric(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.blue.shade700),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), // Larger value
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)), // Smaller label
      ],
    );
  }

  /// Builds a stat widget for the performance overview header.
  Widget _buildPerformanceStat(
      String label, String value, IconData icon, Color color) {
    // Similar to _buildChatStat but potentially different styling
     return Column(
       mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
      ],
    );
  }


   /// Helper for displaying team performance metrics vs targets.
  Widget _buildPerformanceMetric(String label, String target, String actual, Color color) {
    // Basic comparison logic (improve if target/actual formats vary)
    bool isMeetingTarget = false; // Add your comparison logic here
    Color actualColor = Colors.grey; // Default color
    IconData statusIcon = Iconsax.minus;

    // Example comparison (adapt as needed)
    try {
       double actualValue = double.parse(actual.replaceAll(RegExp(r'[^\d.]'),''));
       double targetValue = double.parse(target.replaceAll(RegExp(r'[^\d.]'),''));
       // Assuming lower is better for time, higher is better for ratings/percentages
       if (label.toLowerCase().contains('time')) {
           isMeetingTarget = actualValue <= targetValue;
       } else {
           isMeetingTarget = actualValue >= targetValue;
       }
       actualColor = isMeetingTarget ? Colors.green.shade700 : Colors.red.shade700;
       statusIcon = isMeetingTarget ? Iconsax.tick_circle : Iconsax.close_circle;
    } catch (_) {
      // Handle cases where parsing fails
      actualColor = Colors.grey;
       statusIcon = Iconsax.info_circle;
    }


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
          Text(actual, style: TextStyle(
            color: actualColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          )),
          Text(' / $target', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)), // Target value in grey
          const SizedBox(width: 8),
          Icon(
            statusIcon,
            size: 14, // Smaller icon
            color: actualColor,
          ),
        ],
      ),
    );
  }


  /// **Section Header Helper**
  Widget _buildSectionHeader(String title, IconData icon, Color color, {bool isFirstSection = false}) {
     // Apply margin only if it's not the first section in a list
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: isFirstSection ? 0 : 16.0),
      child: Row(
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
            style: Theme.of(context).textTheme.titleMedium, // Use text theme
          ),
        ],
      ),
    );
  }

  // --- Action Methods (Placeholders - Needs Implementation) ---
  void _sendBroadcastMessage() {}
  void _generateReport() {}
  void _openSettings() {}
  void _exportData() {}
  void _assignConversation(ChatConversation conversation) {}
  void _openChat(ChatConversation conversation) {}
  void _respondToFeedback(CustomerFeedback feedback) {}
  void _markFeedbackResponded(CustomerFeedback feedback) {
    print("Marking feedback from ${feedback.customer} as responded");
    // Add logic to update feedback state
    // setState(() { ... });
  }
  void _showFeedbackActions(CustomerFeedback feedback) {}
  // void _filterBySentiment(int tabIndex) {} // No sentiment tabs implemented in this version
  void _viewStaffDetails(StaffPerformance staff) {}
  void _messageStaff(StaffPerformance staff) {}
  void _viewStaffAnalytics(StaffPerformance staff) {}
}