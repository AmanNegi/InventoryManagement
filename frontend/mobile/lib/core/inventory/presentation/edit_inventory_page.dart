import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inv_mgmt_client/core/home/presentation/home_page.dart';
import 'package:inv_mgmt_client/core/inventory/application/inventory.dart';
import 'package:inv_mgmt_client/globals.dart';
import 'package:inv_mgmt_client/models/inventory_item.dart';
import 'package:inv_mgmt_client/utils/firebase_storage.dart';
import 'package:inv_mgmt_client/widgets/action_button.dart';
import 'package:inv_mgmt_client/widgets/cached_image_view.dart';
import 'package:inv_mgmt_client/widgets/loading_widget.dart';
import 'package:uuid/uuid.dart';

class EditInventoryItemPage extends ConsumerStatefulWidget {
  final InventoryItem item;
  const EditInventoryItemPage({Key? key, required this.item}) : super(key: key);

  @override
  AddInventoryItemPageState createState() => AddInventoryItemPageState();
}

class AddInventoryItemPageState extends ConsumerState<EditInventoryItemPage> {
  late double height, width;

  String imageUrl = "";
  bool networkImage = false;

  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var costPriceController = TextEditingController();
  var sellingPriceController = TextEditingController();
  var quantityController = TextEditingController();

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void initState() {
    nameController.text = widget.item.title;
    descriptionController.text = widget.item.description;
    costPriceController.text = widget.item.costPrice.toString();
    sellingPriceController.text = widget.item.sellingPrice.toString();
    quantityController.text = widget.item.quantity.toString();

    imageUrl = widget.item.images.isNotEmpty ? widget.item.images[0] : "";
    if (imageUrl.isNotEmpty) {
      networkImage = true;
    }
    super.initState();
  }

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
        String name = nameController.text.trim();
        String description = descriptionController.text.trim();
        double costPrice = double.parse(costPriceController.text.trim());
        double sellingPrice = double.parse(sellingPriceController.text.trim());
        double quantity = double.parse(quantityController.text.trim());

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
        } else {
          print("Server is up, proceeding to upload if required...");
        }

        isLoading.value = true;

        String url = imageUrl;

        if (!networkImage && imageUrl.isNotEmpty) {
          String itemId = const Uuid().v1();

          url = await storageManager.uploadItemImage(itemId, File(imageUrl));

          if (url.isEmpty) {
            isLoading.value = false;
            showToast("An error occurred while uploading image");
            return;
          }
          print("Uploading complete... $url");
        } else {
          print("Not uploading any image...");
        }

        if (widget.item.type != "loose") {
          quantity = quantity.toInt().toDouble();
        }

        var manager = InventoryManager(ref, context);
        await manager.updateItem(widget.item.copyWith(
          title: name,
          description: description,
          costPrice: costPrice,
          sellingPrice: sellingPrice,
          quantity: quantity,
          images: (!networkImage && url.isEmpty) ? [] : [url],
        ));
        isLoading.value = false;
        if (mounted) {
          goToPage(context, const HomePage(), clearStack: true);
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
            child: imageUrl.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      pickAnImage();
                    },
                    child: networkImage
                        ? CachedImageView(
                            imageUrl,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
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
        _getTextField("Name", nameController, TextInputType.text, ""),
        _getTextField(
            "Description", descriptionController, TextInputType.text, ""),
        _getTextField(
          "Selling Price",
          sellingPriceController,
          TextInputType.number,
          widget.item.type == "loose" ? "/kg" : "/unit",
        ),
        _getTextField(
          "Cost Price",
          costPriceController,
          TextInputType.number,
          widget.item.type == "loose" ? "/kg" : "/unit",
        ),
        _getTextField(
          "Quantity",
          quantityController,
          TextInputType.number,
          widget.item.type == "loose" ? "kgs" : "units",
        ),
      ],
    );
  }

  _getTextField(
    String hintText,
    TextEditingController controller,
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
        controller: controller,
        maxLines: null,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
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
      networkImage = false;
      setState(() {});
      return true;
    }
    return false;
  }
}
