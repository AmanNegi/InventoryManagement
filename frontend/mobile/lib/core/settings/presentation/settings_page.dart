import "package:flutter/material.dart";
import "package:inv_mgmt_client/core/auth/presentation/auth_page.dart";
import "package:inv_mgmt_client/data/cache/app_cache.dart";
import "package:inv_mgmt_client/globals.dart";
import "package:inv_mgmt_client/widgets/action_button.dart";
import "package:inv_mgmt_client/widgets/custom_text_field.dart";

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController apiController = TextEditingController(text: API_URL);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          children: [
            TextField(
              controller: apiController,
              decoration: InputDecoration(
                isDense: true,
                border: const OutlineInputBorder(),
                hintText: "localhost:3000",
                label: const Text("API URL"),
                suffixIcon: IconButton(
                  onPressed: () {
                    apiController.clear();
                    // clear the field
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            if (appState.value.isLoggedIn)
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () {
                  appCache.clearAppCache();
                  goToPage(context, const AuthPage(), clearStack: true);
                },
              ),
            SizedBox(height: 0.01 * getHeight(context)),
            ActionButton(
                text: "Save Changes",
                onPressed: () {
                  API_URL = apiController.text;
                  setState(() {});
                  showToast("Settings updated successfully!");
                })
          ],
        ));
  }
}
