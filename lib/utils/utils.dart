import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

double width(context) => MediaQuery.of(context).size.width;
double height(context) => MediaQuery.of(context).size.height;

Future<void> showSimpleDialog(
    BuildContext context, String repoUrl, String profile) async {
  await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                final uri = Uri.parse(repoUrl);
                await launchUrl(uri);
              },
              child: const Text('Go To Repository Url'),
            ),
            SimpleDialogOption(
              onPressed: () async {
                final uri = Uri.parse(profile);
                await launchUrl(uri);
              },
              child: const Text('Go To author Profile'),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      });
}
