import 'package:creative_task/models/repository_model.dart';
import 'package:creative_task/utils/utils.dart';
import 'package:flutter/material.dart';

class RepositoryCard extends StatelessWidget {
  final Repository rep;

  const RepositoryCard({
    super.key,
    required this.rep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onLongPress: () {
          showSimpleDialog(context, rep.htmlUrl, rep.owner.htmlUrl);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: rep.fork ? Colors.white : Colors.lightGreen,
              border: Border.all(
                color: Colors.black,
                width: 1,
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
                child: RichText(
                    overflow: TextOverflow.ellipsis,
                    strutStyle: const StrutStyle(fontSize: 12.0),
                    text: TextSpan(
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                        text: rep.name)),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
                child: RichText(
                    overflow: TextOverflow.ellipsis,
                    strutStyle: const StrutStyle(fontSize: 12.0),
                    text: TextSpan(
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                        text: rep.description ?? 'no description')),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
                child: RichText(
                    overflow: TextOverflow.ellipsis,
                    strutStyle: const StrutStyle(fontSize: 12.0),
                    text: TextSpan(
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                        text: rep.owner.login.name)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
