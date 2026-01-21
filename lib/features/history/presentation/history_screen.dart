import 'package:diato_ai/features/history/presentation/widgets/history_item.dart';
import 'package:flutter/material.dart';

import '../../scanner/data/models/scanned_item.dart';

class HistoryScreen extends StatefulWidget {
  static const String routeName = 'history';
  static const String routePath = '/history';
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? selectedFilter;

  // Dummy data
  final List<ScannedItem> allItems = [
    ScannedItem(
      id: '1',
      imageUrl: 'https://picsum.photos/seed/diatom1/400/300',
      type: 'Pennate',
      result: 'Navicula sp. - Common freshwater diatom',
      scanDate: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ScannedItem(
      id: '2',
      imageUrl: 'https://picsum.photos/seed/diatom2/400/300',
      type: 'Centric',
      result: 'Cyclotella sp. - Planktonic diatom',
      scanDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ScannedItem(
      id: '3',
      imageUrl: 'https://picsum.photos/seed/diatom3/400/300',
      type: 'Pennate',
      result: 'Pinnularia sp. - Large pennate diatom',
      scanDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ScannedItem(
      id: '4',
      imageUrl: 'https://picsum.photos/seed/diatom4/400/300',
      type: 'Centric',
      result: 'Aulacoseira sp. - Colonial centric diatom',
      scanDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ScannedItem(
      id: '5',
      imageUrl: 'https://picsum.photos/seed/diatom5/400/300',
      type: 'Pennate',
      result: 'Gomphonema sp. - Attached diatom',
      scanDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ScannedItem(
      id: '6',
      imageUrl: 'https://picsum.photos/seed/diatom6/400/300',
      type: 'Centric',
      result: 'Stephanodiscus sp. - Large centric diatom',
      scanDate: DateTime.now().subtract(const Duration(days: 7)),
    ),
    ScannedItem(
      id: '7',
      imageUrl: 'https://picsum.photos/seed/diatom7/400/300',
      type: 'Pennate',
      result: 'Nitzschia sp. - Needle-shaped diatom',
      scanDate: DateTime.now().subtract(const Duration(days: 10)),
    ),
    ScannedItem(
      id: '8',
      imageUrl: 'https://picsum.photos/seed/diatom8/400/300',
      type: 'Centric',
      result: 'Melosira sp. - Filamentous centric diatom',
      scanDate: DateTime.now().subtract(const Duration(days: 12)),
    ),
  ];

  List<ScannedItem> get filteredItems {
    if (selectedFilter == null) {
      return allItems;
    }
    return allItems.where((item) => item.type == selectedFilter).toList();
  }

  List<String> get availableTypes {
    return allItems.map((item) => item.type).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Diatom'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('Semua'),
                    selected: selectedFilter == null,
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ...availableTypes.map((type) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(type),
                        selected: selectedFilter == type,
                        onSelected: (selected) {
                          setState(() {
                            selectedFilter = selected ? type : null;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${filteredItems.length} hasil pemindaian',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          // List of scanned items
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada riwayat pemindaian',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return HistoryItem(item: item,);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}