class StaffMember {
  final String id;
  final String name;
  final String role; // e.g., 'Manager', 'Waiter', 'Kitchen'
  bool isActive;

  StaffMember({
    required this.id,
    required this.name,
    required this.role,
    this.isActive = true,
  });
}