import 'package:familyside/view/family/explorer/models/explorer_data.dart';
import 'package:familyside/view/family/explorer/models/explorer_map_item.dart';

class ExplorerMapScreenConfig {
  final List<ExplorerMapItem> items;
  final String initialCategory;

  const ExplorerMapScreenConfig({
    required this.items,
    this.initialCategory = 'All',
  });

  factory ExplorerMapScreenConfig.defaults() {
    return ExplorerMapScreenConfig(items: ExplorerData.mapItems);
  }

  List<String> get categories => ExplorerData.categoriesFromItems(items);
}
