import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/services/change_language.dart';
import 'package:multi_vendor/translator/app-translations.dart';

class LanguageDialog extends StatelessWidget {
  LanguageDialog({super.key});

  ChangeLanguage _languageService = ChangeLanguage();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Language".tr),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Visibility(
          visible: false,
          child: ListTile(
            title: Text("English"),
            onTap: () async {
              await _languageService.changeLanguage(lang: 'en');
              Navigator.pop(context);
            },
            leading: Icon(Icons.language),
          ),
        ),
        ListTile(
          title: Text("Francais"),
          onTap: () async {
            await _languageService.changeLanguage(lang: 'fr');
            var d = await _languageService.getLanguage();

            Navigator.pop(context);
          },
          leading: Icon(Icons.language),
        ),
        ListTile(
          title: Text("العربية"),
          onTap: () async {
            await _languageService.changeLanguage(lang: 'ar');

            var d = _languageService.getLanguage();
            Navigator.pop(context);
          },
          leading: Icon(Icons.language),
        ),
      ]),
    );
  }
}
