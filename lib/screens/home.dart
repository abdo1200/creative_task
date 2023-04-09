import 'package:creative_task/models/repository_model.dart';
import 'package:creative_task/providers/provider.dart';
import 'package:creative_task/screens/widgets/repository_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _controller = ScrollController();
  TextEditingController search = TextEditingController();
  bool loadingMore = false;
  bool enableSearch = false;
  bool showbtn = false;

  List<Repository> respositories = [];
  @override
  void initState() {
    super.initState();
    _controller.addListener(scrollListener);
    fetch();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isloading =
        Provider.of<CustomProvider>(context, listen: true).isloading;

    var provider = Provider.of<CustomProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await provider.refreshData();
            respositories = [];
            await fetch();
          },
          child: SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    onChanged: (value) {
                      if (value != '') {
                        setState(() {
                          enableSearch = true;
                        });
                      } else {
                        setState(() {
                          enableSearch = false;
                        });
                      }
                      fetch();
                    },
                    controller: search,
                    obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      hintText: 'Enter project name',
                    ),
                  ),
                ),
                isloading
                    ? const CircularProgressIndicator()
                    : ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: respositories.length,
                        itemBuilder: (context, index) {
                          Repository rep = respositories[index];
                          return RepositoryCard(rep: rep);
                        },
                      ),
                loadingMore & !isloading
                    ? const CircularProgressIndicator()
                    : const SizedBox()
              ],
            ),
          ),
        ),
        floatingActionButton: AnimatedOpacity(
          duration: Duration(milliseconds: 1000), //show/hide animation
          opacity: showbtn ? 1.0 : 0.0, //set obacity to 1 on visible, or hide
          child: FloatingActionButton(
            onPressed: () {
              _controller.animateTo(
                  //go to top of scroll
                  0, //scroll offset to go
                  duration: Duration(milliseconds: 500), //duration of scroll
                  curve: Curves.fastOutSlowIn //scroll type
                  );
            },
            child: Icon(Icons.arrow_upward),
            backgroundColor: Colors.redAccent,
          ),
        ),
      ),
    );
  }

  void scrollListener() async {
    final custom = Provider.of<CustomProvider>(context, listen: false);
    double showoffset = 20.0;

    if (_controller.offset > showoffset) {
      showbtn = true;
      setState(() {});
    } else {
      showbtn = false;
      setState(() {});
    }

    if (_controller.position.pixels == _controller.position.maxScrollExtent &&
        enableSearch == false) {
      custom.num = custom.num + 10;
      setState(() {});
      fetch();
    }
  }

  fetch() async {
    setState(() {
      loadingMore = true;
    });
    final custom = Provider.of<CustomProvider>(context, listen: false);
    if (enableSearch) {
      loadingMore = false;
      await custom.searchData(search.text).then((value) {
        setState(() {
          respositories = custom.filterdRepositories;
        });
        print(respositories.length);
      });
    } else {
      await custom.fetchData().then((value) {
        setState(() {
          respositories = custom.repositories;
          loadingMore = false;
        });
      });
    }
  }
}
