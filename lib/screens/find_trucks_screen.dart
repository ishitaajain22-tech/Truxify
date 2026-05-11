import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../data/mock_data.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_page_route.dart';
import '../widgets/common_widgets.dart';
import 'truck_results_screen.dart';

class FindTrucksScreen extends StatefulWidget {
  const FindTrucksScreen({super.key});

  @override
  State<FindTrucksScreen> createState() => _FindTrucksScreenState();
}

class _FindTrucksScreenState extends State<FindTrucksScreen> {
  late final TextEditingController _pickupController;
  late final TextEditingController _dropController;
  late final TextEditingController _weightController;
  late final TextEditingController _lengthController;
  late final TextEditingController _widthController;
  late final TextEditingController _heightController;
  late final TextEditingController _dateController;
  String _goodsType = 'Textile';
  bool _stacked = true;
  bool _fragile = false;
  final Set<String> _requirements = <String>{'Temperature control', 'Loading help needed'};

  static const _goodsTypes = <String>['Textile', 'Electronics', 'Food', 'Machinery', 'Furniture', 'Other'];
  static const _requirementsOptions = <String>['Temperature control', 'Waterproof cover', 'Loading help needed'];

  @override
  void initState() {
    super.initState();
    _setupFromDraft(mockDefaultRouteDraft);
  }

  void _setupFromDraft(RouteDraft draft) {
    _pickupController = TextEditingController(text: draft.pickup);
    _dropController = TextEditingController(text: draft.drop);
    _weightController = TextEditingController(text: draft.weightTonnes);
    _lengthController = TextEditingController(text: draft.dimensions.split(' × ').first);
    _widthController = TextEditingController(text: draft.dimensions.split(' × ')[1]);
    _heightController = TextEditingController(text: draft.dimensions.split(' × ')[2]);
    _dateController = TextEditingController(text: draft.dateLabel);
    _goodsType = draft.goodsType;
    _stacked = draft.stacked;
    _fragile = draft.fragile;
    _requirements
      ..clear()
      ..addAll(draft.requirements);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = FreightFairScope.of(context);
    final draft = controller.consumePendingRouteDraft();
    if (draft != null) {
      _pickupController.text = draft.pickup;
      _dropController.text = draft.drop;
      _weightController.text = draft.weightTonnes;
      final parts = draft.dimensions.split(' × ');
      if (parts.length == 3) {
        _lengthController.text = parts[0];
        _widthController.text = parts[1];
        _heightController.text = parts[2];
      }
      _dateController.text = draft.dateLabel;
      _goodsType = draft.goodsType;
      _stacked = draft.stacked;
      _fragile = draft.fragile;
      _requirements
        ..clear()
        ..addAll(draft.requirements);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _dropController.dispose();
    _weightController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  RouteDraft _buildDraft() {
    return RouteDraft(
      pickup: _pickupController.text,
      drop: _dropController.text,
      dateLabel: _dateController.text,
      goodsType: _goodsType,
      weightTonnes: _weightController.text,
      dimensions: '${_lengthController.text} × ${_widthController.text} × ${_heightController.text}',
      stacked: _stacked,
      fragile: _fragile,
      requirements: _requirements.toList(),
    );
  }

  void _swapLocations() {
    final pickup = _pickupController.text;
    _pickupController.text = _dropController.text;
    _dropController.text = pickup;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Find Trucks', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list_rounded)),
              ],
            ),
            const SizedBox(height: 18),
            InfoCard(
              child: Column(
                children: [
                  TextField(controller: _pickupController, decoration: const InputDecoration(labelText: 'Pickup Location')),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: _dropController, decoration: const InputDecoration(labelText: 'Drop Location'))),
                      const SizedBox(width: 12),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: FreightFairColors.accentLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: FreightFairColors.border),
                        ),
                        child: IconButton(
                          onPressed: _swapLocations,
                          icon: const Icon(Icons.swap_vert_rounded, color: FreightFairColors.accentDark),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Date / Time'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _goodsType,
                    items: _goodsTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                    onChanged: (value) => setState(() => _goodsType = value ?? _goodsType),
                    decoration: const InputDecoration(labelText: 'Goods Type'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Weight (tonnes)'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: _lengthController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'L'))),
                      const SizedBox(width: 8),
                      Expanded(child: TextField(controller: _widthController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'W'))),
                      const SizedBox(width: 8),
                      Expanded(child: TextField(controller: _heightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'H'))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _ToggleRow(
                    label: 'Can goods be stacked?',
                    selectedValue: _stacked,
                    yesLabel: 'Yes',
                    noLabel: 'No',
                    onChanged: (value) => setState(() => _stacked = value),
                  ),
                  const SizedBox(height: 12),
                  _ToggleRow(
                    label: 'Fragile?',
                    selectedValue: _fragile,
                    yesLabel: 'Yes',
                    noLabel: 'No',
                    onChanged: (value) => setState(() => _fragile = value),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Special requirements', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _requirementsOptions.map((item) {
                      final selected = _requirements.contains(item);
                      return FilterChip(
                        selected: selected,
                        label: Text(item),
                        onSelected: (value) {
                          setState(() {
                            if (value) {
                              _requirements.add(item);
                            } else {
                              _requirements.remove(item);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            InfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Estimated Price Range', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text('₹6,200 — ₹7,800', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: FreightFairColors.accentDark)),
                  const SizedBox(height: 6),
                  Text('Based on current demand', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: FreightFairColors.secondaryText)),
                  const SizedBox(height: 6),
                  const Text('Prices stable this week ✅'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Find Trucks',
              onPressed: () {
                Navigator.of(context).push(
                  AppPageRoute(builder: (_) => TruckResultsScreen(draft: _buildDraft())),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.selectedValue,
    required this.yesLabel,
    required this.noLabel,
    required this.onChanged,
  });

  final String label;
  final bool selectedValue;
  final String yesLabel;
  final String noLabel;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
        ),
        ToggleButtons(
          isSelected: [selectedValue, !selectedValue],
          onPressed: (index) => onChanged(index == 0),
          borderRadius: BorderRadius.circular(12),
          selectedColor: FreightFairColors.accentDark,
          fillColor: FreightFairColors.accentLight,
          constraints: const BoxConstraints(minHeight: 40, minWidth: 58),
          children: [Text(yesLabel), Text(noLabel)],
        ),
      ],
    );
  }
}
