import 'dart:io';
import 'package:dineswift_management/util/constants/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;

// --- Data Models (based on your schema) ---
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
    if (kIsWeb) {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();
      
      await uploadInput.onChange.first;
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        await reader.onLoad.first;
        return reader.result as String?;
      }
      return null;
    }
    final pickedFile = await _picker.pickImage(source: source);
    return pickedFile?.path;
  }
}

// --- The Main Screen Widget ---
class AddMenu extends StatefulWidget {
  final Menu? menu;
  const AddMenu({super.key, this.menu});

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

  bool get _isEditing => widget.menu != null;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _menuNameController = TextEditingController(text: widget.menu?.name ?? '');
    _menuDescriptionController = TextEditingController(text: widget.menu?.description ?? '');
    _isMenuActive = widget.menu?.isActive ?? true;
    _menuImageUrl = widget.menu?.imageUrl;
    _menuItems = List<MenuItem>.from(widget.menu?.items ?? []);
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
  
  void _saveMenu() {
    if (_formKey.currentState!.validate()) {
      final Menu savedMenu = Menu(
        id: widget.menu?.id ?? 'new-menu-id-${DateTime.now().millisecondsSinceEpoch}',
        restaurantId: 'your-restaurant-id',
        name: _menuNameController.text,
        description: _menuDescriptionController.text,
        isActive: _isMenuActive,
        imageUrl: _menuImageUrl,
        items: _menuItems,
      );
      
      // Send to backend
      print('--- SAVING MENU ---');
      print('Menu Name: ${savedMenu.name}');
      print('Is Active: ${savedMenu.isActive}');
      print('Image URL: ${savedMenu.imageUrl}');
      print('Items: ${savedMenu.items.length}');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menu saved successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12)
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
          fontSize: 22
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
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: _buildItemLeading(item),
            title: Text(item.itemName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('\$${item.salesPrice.toStringAsFixed(2)}'),
                if (item.description.isNotEmpty)
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => onEdit(item),
                ),
                IconButton(
                  icon: const Icon(Iconsax.trash, color: Colors.red),
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
        ReorderableDragStartListener(
          index: items.indexWhere((i) => i.id == item.id),
          child: const Icon(Icons.drag_handle, color: Colors.grey),
        ),
        const SizedBox(width: 8),
        if (item.imageUrl != null)
          CircleAvatar(
            child: ClipOval(
              child: _buildImageWidget(item.imageUrl!, width: 40, height: 40, fit: BoxFit.cover),
            ),
            radius: 20,
          )
        else
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 20,
            child: const Icon(Icons.fastfood, size: 20, color: Colors.grey),
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

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this menu item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onDelete(index);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
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
  const MenuItemEditorModal({super.key, this.item, required this.onSave});

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
        menuId: widget.item?.menuId ?? '',
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
                  border: OutlineInputBorder(),
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
            border: OutlineInputBorder(),
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