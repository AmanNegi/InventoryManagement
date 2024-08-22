import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:http/http.dart" as http;
import 'package:inv_mgmt_client/data/billing_state.dart';
import 'package:inv_mgmt_client/data/cache/app_cache.dart';

String API_URL = "http://localhost:3000";

String rupee = "₹";

bool isLooseItem(BillingItem item) {
  return item.item.type == "loose";
}

Future<bool> isServerUp() async {
  try {
    var res = await http.get(Uri.parse("${API_URL}/"));
    return res.statusCode == 200;
  } catch (e) {
    return false;
  }
}

Future goToPage(BuildContext context, Widget destination,
    {bool clearStack = false}) {
  if (clearStack) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => destination), (route) => false);
  }
  return Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => destination));
}

showToast(String message) {
  Fluttertoast.showToast(msg: message);
}

double getWidth(context) => MediaQuery.of(context).size.width;
double getHeight(context) => MediaQuery.of(context).size.height;

LinearGradient shimmerGradient = LinearGradient(colors: [
  Colors.grey.shade300,
  Colors.grey.shade100,
  Colors.grey.shade300,
]);
