import 'package:dineswift_management/features/system_configuration/models/staff_member_model.dart';
import 'package:dineswift_management/features/system_configuration/screens/widgets/add_staff.dart';
import 'package:dineswift_management/util/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class UserManagementCard extends StatefulWidget {
  const UserManagementCard({super.key, required this.staff});

  final List<StaffMember> staff;

  @override
  State<UserManagementCard> createState() => _UserManagementCardState();
}

class _UserManagementCardState extends State<UserManagementCard> {
  bool _isStaffListExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Iconsax.people, color: Colors.green),
            title: Text(
              'User Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: DineSwiftColors.blackColor,
              ),
            ),
            trailing: Text(
              '${widget.staff.length}',
              style: TextStyle(
                fontSize: 14,
                color: DineSwiftColors.blackColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Staff Accounts',
                  style: TextStyle(
                    fontSize: 14,
                    color: DineSwiftColors.blackColor,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Iconsax.user_add, size: 16, color: DineSwiftColors.iconColor,),
                  label: const Text(
                    'Add Staff',
                    style: TextStyle(
                      fontSize: 14,
                      color: DineSwiftColors.iconColor,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: AddStaff(),
                        );
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: SingleChildScrollView(
              child: ExpansionPanelList(
                elevation: 0,
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _isStaffListExpanded = !isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    canTapOnHeader: true,
                    isExpanded: _isStaffListExpanded,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text('Staff List (${widget.staff.length})'),
                      );
                    },
                    body: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.staff.length,
                      itemBuilder: (context, index) {
                        final member = widget.staff[index];
                        return ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            radius: 16,
                            child: Text(member.name.substring(0, 1)), // Initial
                          ),
                          title: Text(member.name),
                          subtitle: Text(member.role),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Chip(
                                label: Text(
                                  member.isActive ? 'Active' : 'Inactive',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: member.isActive
                                        ? Colors.green.shade800
                                        : Colors.red.shade800,
                                  ),
                                ),
                                backgroundColor: member.isActive
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                side: BorderSide.none,
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                              ),
                              IconButton(
                                icon: const Icon(Iconsax.edit, size: 16),
                                onPressed: () {
                                  /* Edit Staff */
                                },
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                          onTap: () {
                            /* View Staff Details */
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, indent: 16, endIndent: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          // Link to Role Permissions
          ListTile(
            leading: const Icon(Iconsax.key_square, size: 20),
            title: const Text('Role Permissions'),
            subtitle: const Text('Manage what each role can access'),
            trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            onTap: () {
              /* Navigate to Role Permissions Screen */
            },
          ),
        ],
      ),
    );
  }
}
