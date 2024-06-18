import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inv_mgmt_client/core/inventory/application/inventory.dart';
import 'package:inv_mgmt_client/globals.dart';
import 'package:inv_mgmt_client/models/inventory_item.dart';
import 'package:inv_mgmt_client/utils/firebase_storage.dart';
import 'package:inv_mgmt_client/widgets/action_button.dart';
import 'package:inv_mgmt_client/widgets/loading_widget.dart';
import 'package:uuid/uuid.dart';

class AddInventoryItemPage extends ConsumerStatefulWidget {
  const AddInventoryItemPage({Key? key}) : super(key: key);

  @override
  AddInventoryItemPageState createState() => AddInventoryItemPageState();
}

class AddInventoryItemPageState extends ConsumerState<AddInventoryItemPage> {
  late double height, width;

  String name = "", description = "";
  double costPrice = 0.0;
  double sellingPrice = 0.0;
  double quantity = 1;
  String imageUrl = "";
  bool pickedImage = false;
  ItemType type = ItemType.packaged;

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return LoadingWidget(
      isLoading: isLoading,
      child: _getAddItemPage(context),
    );
  }

  Scaffold _getAddItemPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Add Product",
        ),
        actions: [
          IconButton(
            onPressed: () {
              type =
                  type == ItemType.loose ? ItemType.packaged : ItemType.loose;
              setState(() {});
              if (type == ItemType.loose) {
                showToast("Loose items are sold by weight");
              } else {
                showToast("Packaged items are sold by unit");
              }
            },
            icon: Icon(type == ItemType.loose
                ? Icons.shopping_bag_outlined
                : Icons.grain),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _getFloatingActionButton(context),
      body: _getBody(),
    );
  }

  _getFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 0,
      onPressed: () async {
        if (!InventoryManager.validateItem(
          title: name,
          quantity: quantity,
          costPrice: costPrice,
          sellingPrice: sellingPrice,
        )) {
          return;
        }

        bool serverUp = await isServerUp();
        if (!serverUp) {
          showToast("Server is down, contact admin.");
          return;
        }

        isLoading.value = true;

        String? url;

        if (pickedImage) {
          String itemId = const Uuid().v1();

          url = await storageManager.uploadItemImage(itemId, File(imageUrl));

          if (url.isEmpty) {
            isLoading.value = false;
            showToast("An error occurred while uploading image");
            return;
          }
        }

        if (!mounted) return;

        var manager = InventoryManager(ref, context);

        if (type == ItemType.packaged) {
          quantity = quantity.toInt().toDouble();
        }

        await manager.addItem(
          title: name,
          description: description.isEmpty ? "na" : description,
          imageUrl: url,
          costPrice: costPrice,
          sellingPrice: sellingPrice,
          quantity: quantity,
          type: getTypeFromEnum(type),
        );
        isLoading.value = false;
        if (mounted) {
          Navigator.pop(context);
        }
      },
      label: const Row(
        children: [
          Text("Continue"),
          SizedBox(width: 5),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
        ],
      ),
    );
  }

  _getBody() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        height: height,
        child: Column(
          children: [
            SizedBox(height: 0.02 * height),
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              reverseDuration: const Duration(seconds: 1),
              child: _getImageSelector(),
              layoutBuilder: (currentChild, previousChildren) =>
                  currentChild ?? Container(),
            ),
          ],
        ),
      ),
    );
  }

  _getImageSelector() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: SizedBox(
            height: 0.3 * height,
            width: double.infinity,
            child: pickedImage
                ? GestureDetector(
                    onTap: () {
                      pickAnImage();
                    },
                    child: Image.file(
                      File(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  )
                : ActionButton(
                    onPressed: () async {
                      await pickAnImage();
                    },
                    text: ("Pick an Image"),
                  ),
          ),
        ),
        Container(
          height: 0.025 * height,
        ),
        _getTextField("Name", ((e) => name = e), TextInputType.text, ""),
        _getTextField(
            "Description", ((e) => description = e), TextInputType.text, ""),
        _getTextField(
          "Selling Price",
          ((e) => sellingPrice = double.parse(e)),
          TextInputType.number,
          type == ItemType.loose ? "/kg" : "/unit",
        ),
        _getTextField(
          "Cost Price",
          ((e) => costPrice = double.parse(e)),
          TextInputType.number,
          type == ItemType.loose ? "/kg" : "/unit",
        ),
        _getTextField(
          "Quantity",
          ((e) => quantity = double.parse(e)),
          TextInputType.number,
          type == ItemType.loose ? "kgs" : "units",
        ),
      ],
    );
  }

  _getTextField(
    String hintText,
    Function onChange,
    TextInputType keyboardType,
    String suffix,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            spreadRadius: 1.0,
            blurRadius: 8.0,
          ),
        ],
      ),
      child: TextField(
        maxLines: null,
        keyboardType: keyboardType,
        onChanged: (value) {
          onChange(value);
          setState(() {});
        },
        decoration: InputDecoration(
          label: Text(hintText),
          // hintText: hintText,
          border: InputBorder.none,
          suffix: Text(suffix),
        ),
      ),
    );
  }

  Future<bool> pickAnImage() async {
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (file != null) {
      imageUrl = file.path;
      pickedImage = true;
      setState(() {});
      return true;
    }
    return false;
  }
}
