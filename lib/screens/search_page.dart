import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/widgets/navigation_bar.dart';
import '/controllers/scroll_monitor.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  SelectedTab _selectedTab = SelectedTab.search;
  final List<String> _allItems = [
    'Apple', 'Banana', 'Cherry', 'Date', 'Elderberry', 'Fig', 'Grape', 'Honeydew'
  ];
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _allItems;
      } else {
        _filteredItems = _allItems
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _handleIndexChanged(int index) {
    setState(() {
      _selectedTab = SelectedTab.values[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScrollMonitor(),
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: const Text('Search Page'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _filterItems,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_filteredItems[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
            Consumer<ScrollMonitor>(
              builder: (context, scrollMonitor, child) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  bottom: scrollMonitor.isNavBarVisible ? 0 : -130,
                  left: 0,
                  right: 0,
                  child: BlurredNavigationBar(
                    selectedTab: _selectedTab,
                    onIndexChanged: _handleIndexChanged,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}