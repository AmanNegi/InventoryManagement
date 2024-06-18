import "package:flutter/material.dart";
import "package:inv_mgmt_client/core/bill/presentation/bill_page.dart";
import "package:inv_mgmt_client/data/billing_state.dart";

class MultiTabBillPage extends StatefulWidget {
  const MultiTabBillPage({super.key});

  @override
  State<MultiTabBillPage> createState() => _MultiTabBillPageState();
}

class _MultiTabBillPageState extends State<MultiTabBillPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            _tabController.animateTo(index);
            currentIndex = index;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.one_k),
              label: "Bill 1",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.two_k),
              label: "Bill 2",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.three_k),
              label: "Bill 3",
            ),
          ]),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          BillPage(billingNotifiers[0]),
          BillPage(billingNotifiers[1]),
          BillPage(billingNotifiers[2]),
        ],
      ),
    );
  }
}
