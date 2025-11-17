import 'dart:io';
import 'package:dineswift_management/util/constants/colors.dart';
import 'package:dineswift_management/data/supabase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Menu {
  String id;
  String restaurantId;
  String name;
  String description;
  bool isActive;
  int version;
  String? imageUrl; // New field for menu image
  List<MenuItem> items;

  Menu({
    required this.id,
    required this.restaurantId,
    required this.name,
    this.description = '',
    this.isActive = true,
    this.version = 1,
    this.imageUrl,
    List<MenuItem>? items,
  }) : items = items ?? [];
}

class MenuItem {
  String id;
  String menuId;
  String itemName;
  String description;
  double salesPrice;
  int preparationTime;
  String department;
  bool isAvailable;
  int displayOrder;
  String? imageUrl; // New field for item image

  MenuItem({
    required this.id,
    required this.menuId,
    required this.itemName,
    this.description = '',
    required this.salesPrice,
    this.preparationTime = 0,
    this.department = 'Kitchen',
    this.isAvailable = true,
    this.displayOrder = 0,
    this.imageUrl,
  });
}

// --- Image Picker Service ---
class ImagePickerService {
  static final _picker = ImagePicker();

  static Future<String?> pickImage({ImageSource source = ImageSource.gallery}) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return null;
    
    if (kIsWeb) {
      return pickedFile.path;
    }
    return pickedFile.path;
  }
}

// --- The Main Screen Widget ---
class AddMenu extends StatefulWidget {
  final Menu? menu;
  const AddMenu({super.key, this.menu});
  final uuid = const Uuid();

  @override
  State<AddMenu> createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _menuNameController;
  late final TextEditingController _menuDescriptionController;
  late bool _isMenuActive;
  late List<MenuItem> _menuItems;
  String? _menuImageUrl;
  List<Map<String, dynamic>> _allMenus = [];

  bool get _isEditing => widget.menu != null;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _fetchAllMenus();
  }

  void _initializeData() {
    _menuNameController = TextEditingController(text: widget.menu?.name ?? '');
    _menuDescriptionController = TextEditingController(text: widget.menu?.description ?? '');
    _isMenuActive = widget.menu?.isActive ?? true;
    _menuImageUrl = widget.menu?.imageUrl;
    _menuItems = List<MenuItem>.from(widget.menu?.items ?? []);
  }

  Future<void> _fetchAllMenus() async {
    try {
      final menus = await SupabaseService.getRestaurantMenus('55c67be9-90c1-404c-a28b-8fac87dfb85c');
      if (mounted) setState(() => _allMenus = menus);
    } catch (e) {
      // Handle error fetching menus
    }
  }

  @override
  void dispose() {
    _menuNameController.dispose();
    _menuDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickMenuImage() async {
    if (kIsWeb) {
      final imageUrl = await ImagePickerService.pickImage(source: ImageSource.gallery);
      if (imageUrl != null) {
        setState(() {
          _menuImageUrl = imageUrl;
        });
      }
    } else {
      final source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Choose Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      );
      
      if (source != null) {
        final imageUrl = await ImagePickerService.pickImage(source: source);
        if (imageUrl != null) {
          setState(() {
            _menuImageUrl = imageUrl;
          });
        }
      }
    }
  }

  void _removeMenuImage() {
    setState(() {
      _menuImageUrl = null;
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final MenuItem item = _menuItems.removeAt(oldIndex);
      _menuItems.insert(newIndex, item);
      
      // Update displayOrder based on the new list index
      for (int i = 0; i < _menuItems.length; i++) {
        _menuItems[i].displayOrder = i;
      }
    });
  }

  void _deleteMenuItem(int index) {
    setState(() {
      _menuItems.removeAt(index);
      // Optional: update displayOrder for remaining items
      for (int i = 0; i < _menuItems.length; i++) {
        _menuItems[i].displayOrder = i;
      }
    });
  }

  void _showMenuItemModal({MenuItem? itemToEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => MenuItemEditorModal(
        item: itemToEdit,
        menus: _allMenus,
        onSave: (editedItem) {
          setState(() {
            if (itemToEdit == null) {
              editedItem.displayOrder = _menuItems.length;
              _menuItems.add(editedItem);
            } else {
              final index = _menuItems.indexWhere((item) => item.id == editedItem.id);
              if (index != -1) _menuItems[index] = editedItem;
            }
          });
          Navigator.pop(context);
        },
      ),
    );
  }
  
  Future<void> _saveMenu() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: DineSwiftColors.lightSuccessColor,
          duration: Duration(seconds: 30),
          content: Text(
            'Saving menu...',
            style: TextStyle(color: DineSwiftColors.successColor)
          ),
          showCloseIcon: true,
          closeIconColor: DineSwiftColors.successColor,
          dismissDirection: DismissDirection.up,
        ),
      );

      final menuData = {
        'id': _isEditing ? widget.menu!.id : widget.uuid.v4(),
        'restaurant_id': '55c67be9-90c1-404c-a28b-8fac87dfb85c', // Hardcoded restaurant ID
        'name': _menuNameController.text,
        'description': _menuDescriptionController.text,
        'is_active': _isMenuActive,
        'version': _isEditing ? widget.menu!.version + 1 : 1,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        if (_menuImageUrl != null) 'menu_image': _menuImageUrl,
      };

      final items = _menuItems.map((item) => {
        'id': item.id.startsWith('new-item-id-') ? widget.uuid.v4() : item.id,
        'menu_id': item.menuId,
        'item_name': item.itemName,
        'description': item.description,
        'sales_price': item.salesPrice,
        'preparation_time': item.preparationTime,
        'department': item.department,
        'is_available': item.isAvailable,
        'display_order': item.displayOrder,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        if (item.imageUrl != null) 'menu_item_image': item.imageUrl,
      }).toList();

      try {
        await SupabaseService.saveMenu(menuData, items);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Menu saved successfully!',
                style: TextStyle(color: DineSwiftColors.successColor)
              ),
              backgroundColor: DineSwiftColors.lightSuccessColor,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: DineSwiftColors.whiteColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:  Scaffold(
          appBar: AppBar(
            backgroundColor: DineSwiftColors.primaryColor,
            title: Text(
              _isEditing ? 'Edit: ${widget.menu!.name}' : 'Add New Menu',
              style: TextStyle(
                color: DineSwiftColors.whiteColor,
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 25,
                  color: DineSwiftColors.whiteColor,
                ),
                tooltip: 'Add New Item',
                onPressed: () => _showMenuItemModal(),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      // Section 1: Menu Details
                      _buildMenuDetailsSection(),

                      // Section 2: Menu Items
                      _buildMenuItemsHeader(),

                      // If empty, show a message, otherwise show the list
                      if (_menuItems.isEmpty) 
                        _buildEmptyItemsState()
                      else
                        MenuItemsList(
                          items: _menuItems,
                          onReorder: _onReorder,
                          onEdit: (item) => _showMenuItemModal(itemToEdit: item),
                          onDelete: _deleteMenuItem,
                        ),
                    ],
                  ),
                ),

                // Save Button
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      )
    );
  }

  SliverList _buildMenuDetailsSection() {
    return SliverList(
      delegate: SliverChildListDelegate([
        _buildSectionHeader('Menu Details'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Menu Image Section
              _buildMenuImageSection(),
              const SizedBox(height: 20),
              
              // Menu Form Fields
              _buildMenuFormFields(),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildMenuImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu Image',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 400,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _menuImageUrl == null
            ? _buildImagePlaceholder()
            : _buildImagePreview(),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return InkWell(
      onTap: _pickMenuImage,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.camera, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            'Tap to add menu image',
            style: TextStyle(color: DineSwiftColors.darkGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: _buildImageWidget(
            _menuImageUrl!,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              onPressed: _removeMenuImage,
            ),
          ),
        ),
      ],
    );
  }

  Column _buildMenuFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _menuNameController,
          decoration: const InputDecoration(
            labelText: 'Menu Name',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: DineSwiftColors.blackColor,
              fontSize: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: DineSwiftColors.darkGrey)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: DineSwiftColors.primaryColor,
                width: 2.0,
              ),
            ),
            prefixIcon: Icon(Iconsax.receipt),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _menuDescriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: DineSwiftColors.blackColor,
              fontSize: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: DineSwiftColors.darkGrey)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: DineSwiftColors.primaryColor,
                width: 2.0,
              ),
            ),
            prefixIcon: Icon(Iconsax.document),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 10),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Menu is Active'),
          subtitle: const Text('If active, the menu will be visible to customers.'),
          value: _isMenuActive,
          onChanged: (bool value) => setState(() => _isMenuActive = value),
        ),
        const Divider(height: 20),
      ],
    );
  }

  SliverList _buildMenuItemsHeader() {
    return SliverList(
      delegate: SliverChildListDelegate([
        _buildSectionHeader('Menu Items'),
      ]),
    );
  }

  SliverFillRemaining _buildEmptyItemsState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fastfood_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No items added yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add your first item',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: DineSwiftColors.blackColor,
          fontSize: 20
        )
      ),
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 200,
          child: ElevatedButton.icon(
            onPressed: _saveMenu,
            style: ElevatedButton.styleFrom(
              backgroundColor: DineSwiftColors.primaryColor,
            ),
            icon: const Icon(
              Iconsax.save_2,
              color: DineSwiftColors.whiteColor),
            label: const Text(
              'Save Item',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: DineSwiftColors.whiteColor
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget _buildImageWidget(String imagePath, {double? width, double? height, BoxFit? fit}) {
    if (imagePath.startsWith('http') || kIsWeb) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      );
    }
    return Image.file(
      File(imagePath),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  }
}

// --- Menu Items List (Separate Widget for Better Organization) ---
class MenuItemsList extends StatelessWidget {
  final List<MenuItem> items;
  final Function(int, int) onReorder;
  final Function(MenuItem) onEdit;
  final Function(int) onDelete;

  const MenuItemsList({
    super.key,
    required this.items,
    required this.onReorder,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SliverReorderableList(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          key: ValueKey(item.id),
          color: DineSwiftColors.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: DineSwiftColors.primaryColor, width: 0.5),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: _buildItemLeading(item),
            title: Text(item.itemName, style: TextStyle(color: DineSwiftColors.iconColor, fontSize: 16, fontWeight: FontWeight.w600),),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UgX ${item.salesPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14, 
                    color: DineSwiftColors.blackColor
                  )
                ),
                if (item.description.isNotEmpty)
                  Text(
                    item.description,
                    style: TextStyle(fontSize: 12, color: DineSwiftColors.darkGrey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  hoverColor: DineSwiftColors.infoColor.withOpacity(0.1),
                  icon: const Icon(
                    Iconsax.edit, 
                    color: DineSwiftColors.infoColor,
                    size: 20,
                  ),
                  onPressed: () => onEdit(item),
                ),
                IconButton(
                  hoverColor: DineSwiftColors.errorColor.withOpacity(0.1),
                  icon: const Icon(
                    Iconsax.trash, 
                    color: DineSwiftColors.errorColor,
                    size: 20,
                  ),
                  onPressed: () => _showDeleteConfirmation(context, index),
                ),
              ],
            ),
          ),
        );
      },
      onReorder: onReorder,
    );
  }

  Widget _buildItemLeading(MenuItem item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item.imageUrl != null)
          CircleAvatar(
            radius: 20,
            child: CircleAvatar(
              child: _buildImageWidget(
                item.imageUrl!, 
                width: 40, 
                height: 40, 
                fit: BoxFit.cover
              ),
            ),
          )
        else
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 20,
            child: const Icon(Icons.fastfood, size: 20, color: Colors.grey),
          )
      ],
    );
  }

  Widget _buildImageWidget(String imagePath, {double? width, double? height, BoxFit? fit}) {
    if (imagePath.startsWith('http') || kIsWeb) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      );
    }
    return Image.file(
      File(imagePath),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DineSwiftColors.whiteColor,
        icon: const Icon(
          Iconsax.trash,
          color: DineSwiftColors.errorColor,
          size: 40,
        ),
        title: const Text(
          'Delete Item',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: DineSwiftColors.errorColor,
            fontSize: 20
          )
        ),
        content: const Text(
          'Are you sure you want to delete this menu item?',
          style: TextStyle(
            fontSize: 17,
            color: DineSwiftColors.blackColor
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: DineSwiftColors.softGrey.withOpacity(0.2),
              foregroundColor: DineSwiftColors.blackColor,
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: DineSwiftColors.blackColor)
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: DineSwiftColors.errorColor.withOpacity(0.1),
              foregroundColor: DineSwiftColors.errorColor,
            ),
            onPressed: () {
              onDelete(index);
              Navigator.pop(context);
            },
            child: const Text('Delete',
              style: TextStyle(color: DineSwiftColors.errorColor)
            ),
          ),
        ],
      ),
    );
  }
}

// --- The Modal Pop-up for Adding/Editing an Item ---
class MenuItemEditorModal extends StatefulWidget {
  final MenuItem? item;
  final Function(MenuItem) onSave;
  final List<Map<String, dynamic>> menus;
  const MenuItemEditorModal({super.key, this.item, required this.onSave, required this.menus});

  @override
  State<MenuItemEditorModal> createState() => _MenuItemEditorModalState();
}

class _MenuItemEditorModalState extends State<MenuItemEditorModal> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _prepTimeController;
  late final TextEditingController _departmentController;
  late bool _isAvailable;
  String? _itemImageUrl;
  String? _selectedMenuId;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _nameController = TextEditingController(text: widget.item?.itemName ?? '');
    _descriptionController = TextEditingController(text: widget.item?.description ?? '');
    _priceController = TextEditingController(text: widget.item?.salesPrice.toString() ?? '');
    _prepTimeController = TextEditingController(text: widget.item?.preparationTime.toString() ?? '');
    _departmentController = TextEditingController(text: widget.item?.department ?? 'Kitchen');
    _isAvailable = widget.item?.isAvailable ?? true;
    _itemImageUrl = widget.item?.imageUrl;
    _selectedMenuId = widget.item?.menuId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _prepTimeController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  Future<void> _pickItemImage() async {
    if (kIsWeb) {
      final imageUrl = await ImagePickerService.pickImage(source: ImageSource.gallery);
      if (imageUrl != null) {
        setState(() {
          _itemImageUrl = imageUrl;
        });
      }
    } else {
      final source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Choose Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      );
      
      if (source != null) {
        final imageUrl = await ImagePickerService.pickImage(source: source);
        if (imageUrl != null) {
          setState(() {
            _itemImageUrl = imageUrl;
          });
        }
      }
    }
  }

  void _removeItemImage() {
    setState(() {
      _itemImageUrl = null;
    });
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final newItem = MenuItem(
        id: widget.item?.id ?? 'new-item-id-${DateTime.now().millisecondsSinceEpoch}',
        menuId: _selectedMenuId ?? '',
        itemName: _nameController.text,
        description: _descriptionController.text,
        salesPrice: double.tryParse(_priceController.text) ?? 0.0,
        preparationTime: int.tryParse(_prepTimeController.text) ?? 0,
        department: _departmentController.text,
        isAvailable: _isAvailable,
        displayOrder: widget.item?.displayOrder ?? 0,
        imageUrl: _itemImageUrl,
      );
      widget.onSave(newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: DineSwiftColors.whiteColor,
      ),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Icon(_isEditing ? Iconsax.pen_add : Iconsax.add, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    _isEditing ? 'Edit Item' : 'Add New Item',
                    style: TextStyle(
                      color: DineSwiftColors.blackColor,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Item Image
              _buildItemImageSection(),
              const SizedBox(height: 20),

              // Form Fields
              _buildFormFields(),
              const SizedBox(height: 16),

              // Save Button
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton.icon(
                    onPressed: _saveItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DineSwiftColors.primaryColor,
                    ),
                    icon: const Icon(
                      Iconsax.save_2,
                      color: DineSwiftColors.whiteColor),
                    label: const Text(
                      'Save Item',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: DineSwiftColors.whiteColor
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item Image',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: DineSwiftColors.blackColor
          ),
        ),
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _itemImageUrl == null
            ? _buildItemImagePlaceholder()
            : _buildItemImagePreview(),
        ),
      ],
    );
  }

  Widget _buildItemImagePlaceholder() {
    return InkWell(
      onTap: _pickItemImage,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.image4, size: 32, color: Colors.grey.shade400),
          const SizedBox(height: 2),
          Text(
            'Add Photo',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildItemImagePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: _buildImageWidget(
            _itemImageUrl!,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: const Icon(Icons.close, size: 12, color: DineSwiftColors.whiteColor),
              onPressed: _removeItemImage,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageWidget(String imagePath, {double? width, double? height, BoxFit? fit}) {
    if (imagePath.startsWith('http') || kIsWeb) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      );
    }
    return Image.file(
      File(imagePath),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  }

  Column _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Item Name',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: DineSwiftColors.blackColor,
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: DineSwiftColors.infoColor,
                width: 2.0,
              ),
            ),
            prefixIcon: Icon(Icons.fastfood_outlined),
          ),
          validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Item Description',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: DineSwiftColors.blackColor,
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))
            ),
            prefixIcon: Icon(Iconsax.document_text),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: DineSwiftColors.infoColor,
                width: 2.0,
              ),
            ),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: DineSwiftColors.blackColor,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))
                  ),
                  prefixIcon: Icon(Iconsax.money),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: DineSwiftColors.infoColor,
                      width: 2.0,
                    ),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _prepTimeController,
                decoration: const InputDecoration(
                  labelText: 'Prep Time',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: DineSwiftColors.blackColor,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))
                  ),
                  suffixText: 'min',
                  prefixIcon: Icon(Iconsax.clock),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: DineSwiftColors.infoColor,
                      width: 2.0,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _departmentController,
          decoration: const InputDecoration(
            labelText: 'Department',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: DineSwiftColors.blackColor,
              fontSize: 14,
            ),
            hintText: 'e.g., Grill, Bar',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))
            ),
            prefixIcon: Icon(Iconsax.card),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: DineSwiftColors.infoColor,
                width: 2.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: DineSwiftColors.softGrey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SwitchListTile(
            thumbColor: MaterialStateProperty.all(DineSwiftColors.primaryColor),
            activeTrackColor: DineSwiftColors.primaryColor.withOpacity(0.2),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            title: const Text(
              'Is Available',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: DineSwiftColors.blackColor,
                fontSize: 16,
              ),
            ),
            value: _isAvailable,
            onChanged: (value) => setState(() => _isAvailable = value),
          ),
        ),
      ],
    );
  }
}