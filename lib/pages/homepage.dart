import 'package:app_dev/components/my_current_location.dart';
import 'package:app_dev/pages/person_page.dart';
import 'package:flutter/material.dart';
import 'package:app_dev/components/silver_app_bar.dart';
import 'package:provider/provider.dart';
import '../components/if_drawer.dart';
import '../components/my_lance_tile.dart';
import '../components/my_tab_bar.dart';
import '../models/organization.dart';
import '../models/people.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: PromoCategories.values.length, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  List<Person> _filterMenuByCategory(PromoCategories category, List<Person> fullMenu) {
    return fullMenu.where((Person) => Person.category == category).toList();
  }

  List<Widget> getPersonInThisCategory(List<Person> fullMenu) {
    return PromoCategories.values.map((category) {
      List<Person> categoryMenu = _filterMenuByCategory(category, fullMenu);

      return ListView.builder(
        itemCount: categoryMenu.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
      itemBuilder: (context, index) {
      final freelance = categoryMenu[index];
      return lanceTile(
      lance: freelance,
      onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
      builder: (context) => PersonPage(person: freelance),
      ),
      ),
      );
      });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: IfDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) =>
        [
          MySilverAppBar(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children:[
                //current location
                Divider(
                  indent: 25,
                  endIndent: 25,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const MyCurrentLocation(),
              ],
            ),
            title: MyTabBar(tabController: _tabController,),
          ),
        ],
        body:Consumer<Org>(builder: (context, Org, child) =>TabBarView(
            controller: _tabController,
        children:getPersonInThisCategory(Org.serv)),
        )
        ),
      );
  }
}
