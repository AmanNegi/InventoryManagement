import "package:flutter/material.dart";
import "package:inv_mgmt_client/colors.dart";
import "package:inv_mgmt_client/core/bill/presentation/multi-tab-bill-page.dart";
import 'package:inv_mgmt_client/core/inventory/presentation/inventory_page.dart';
import "package:inv_mgmt_client/core/settings/presentation/settings_page.dart";
import "package:inv_mgmt_client/core/transactions/presentation/transactions_page.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int currentPageIndex = 0;
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      length: 4,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          InventoryPage(),
          MultiTabBillPage(),
          TransactionsPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: lightColor,
        unselectedItemColor: cardColor,
        currentIndex: currentPageIndex,
        onTap: (index) {
          currentPageIndex = index;
          tabController.animateTo(index);
          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Bill",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Transactions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
