import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/inventory_adjustments/model/inventory_adjustments_model.dart';
import 'package:custom_books/features/inventory_adjustments/model/line_item_model.dart';
import 'package:custom_books/features/inventory_adjustments/view/add_line_item_page.dart';
import 'package:flutter/material.dart';

class NewAdjustmentPage extends StatefulWidget {
  const NewAdjustmentPage({super.key});

  @override
  State<NewAdjustmentPage> createState() => _NewAdjustmentPageState();
}

class _NewAdjustmentPageState extends State<NewAdjustmentPage> {
  final _referenceController = TextEditingController();
  final _descriptionController = TextEditingController();

  ModeOfAdjustment _mode = ModeOfAdjustment.quantity;
  DateTime _date = DateTime.now();
  String? _account = 'Cost of Goods Sold';
  String? _reason;

  final List<String> _accounts = const [
    'Cost of Goods Sold',
    'Inventory Asset',
    'Inventory Shrinkage',
    'Other Expense',
  ];

  final List<String> _reasons = const [
    'Damaged goods',
    'Stock count correction',
    'Warehouse transfer shortfall',
    'Expired stock',
    'Theft or loss',
    'Others',
  ];

  final List<LineItem> _lineItems = [];

  @override
  void dispose() {
    _referenceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  double get _totalQuantity =>
      _lineItems.fold(0.0, (sum, item) => sum + item.quantityAdjusted);

  double get _totalValue =>
      _lineItems.fold(0.0, (sum, item) => sum + item.valueChange);

  bool get _isValid =>
      _account != null && _reason != null && _lineItems.isNotEmpty;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _addLineItem() async {
    final result = await Navigator.push<LineItem>(
      context,
      MaterialPageRoute(builder: (_) => const AddLineItemPage()),
    );
    if (result != null) setState(() => _lineItems.add(result));
  }

  Future<void> _editLineItem(LineItem item) async {
    final result = await Navigator.push<LineItem>(
      context,
      MaterialPageRoute(builder: (_) => AddLineItemPage(initial: item)),
    );
    if (result != null) {
      setState(() {
        final index = _lineItems.indexWhere((i) => i.id == item.id);
        if (index != -1) _lineItems[index] = result;
      });
    }
  }

  void _removeLineItem(String id) {
    setState(() => _lineItems.removeWhere((i) => i.id == id));
  }

  void _save() {
    if (!_isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill Account, Reason, and add at least one line item.',
          ),
        ),
      );
      return;
    }
    final now = DateTime.now();
    final adjustment = InventoryAdjustment(
      id: now.millisecondsSinceEpoch.toString(),
      reason: _reason!,
      date: _date,
      createdBy: 'You',
      quantityChange: _totalQuantity.round(),
      value: _totalValue,
      status: AdjustmentStatus.draft,
      createdAt: now,
      lastModifiedAt: now,
    );
    Navigator.pop(context, adjustment);
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  TextStyle _label() => TextStyle(
    fontSize: Dimensions.font16 * 0.8,
    fontWeight: FontWeight.w600,
    color: Appcolors.primary,
  );

  TextStyle _value() => TextStyle(
    fontSize: Dimensions.font16 * 0.9,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF0F172A),
  );

  Widget _divider() => Padding(
    padding: EdgeInsets.symmetric(vertical: Dimensions.height10 / 2),
    child: const Divider(height: 1, color: Color(0xFFE2E8F0)),
  );

  Widget _card(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _requiredLabel(String text) => Text.rich(
    TextSpan(
      text: '$text ',
      style: _label(),
      children: [
        TextSpan(
          text: '*',
          style: TextStyle(color: Colors.red.shade400),
        ),
      ],
    ),
  );

  Widget _radioOption(String label, ModeOfAdjustment value) {
    final selected = _mode == value;
    return InkWell(
      onTap: () => setState(() => _mode = value),
      borderRadius: BorderRadius.circular(20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_off_rounded,
            color: selected ? Appcolors.primary : Colors.black26,
            size: Dimensions.iconSize24 - 2,
          ),
          SizedBox(width: Dimensions.width10 / 2),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addLineItemButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: _addLineItem,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: Appcolors.primary.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_rounded,
              color: Appcolors.primary,
              size: Dimensions.iconSize24 - 2,
            ),
            SizedBox(width: Dimensions.width10 / 2),
            Text(
              'Add Line Item',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                fontWeight: FontWeight.w700,
                color: Appcolors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lineItemCard(LineItem item) {
    final qtyColor = item.quantityAdjusted < 0
        ? Colors.red.shade600
        : Colors.green.shade600;
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.height10),
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        onTap: () => _editLineItem(item),
        child: Container(
          padding: EdgeInsets.all(Dimensions.width20 * 0.8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                width: Dimensions.height45 * 0.8,
                height: Dimensions.height45 * 0.8,
                decoration: BoxDecoration(
                  color: Appcolors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Dimensions.radius15 - 4),
                  image: item.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(item.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: item.imageUrl == null
                    ? Icon(
                        Icons.inventory_2_outlined,
                        color: Appcolors.primary,
                        size: Dimensions.iconSize24 - 6,
                      )
                    : null,
              ),
              SizedBox(width: Dimensions.width10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.itemName,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Dimensions.font16 * 0.85,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 / 4),
                    Text(
                      '${item.quantityAdjusted > 0 ? '+' : ''}${item.quantityAdjusted.toStringAsFixed(2)} qty  •  AED ${item.valueChange.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.7,
                        color: qtyColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  size: Dimensions.iconSize24 - 6,
                  color: Colors.black38,
                ),
                onPressed: () => _removeLineItem(item.id),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Scaffold(
      backgroundColor: Appcolors.background,
      appBar: AppBar(
        backgroundColor: Appcolors.background,
        surfaceTintColor: Appcolors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Adjustment',
          style: TextStyle(
            fontSize: Dimensions.font26 * 0.7,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              'SAVE',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.8,
                fontWeight: FontWeight.w700,
                color: Appcolors.primary,
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: Colors.black54,
              size: Dimensions.iconSize24 - 4,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            onSelected: (value) {
              if (value == 'discard') Navigator.pop(context);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'discard', child: Text('Discard')),
            ],
          ),
          SizedBox(width: Dimensions.width10),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height15,
          ),
          physics: const BouncingScrollPhysics(),
          children: [
            _card([
              Text('Mode of adjustment', style: _label()),
              SizedBox(height: Dimensions.height10 / 2),
              Row(
                children: [
                  _radioOption('Quantity', ModeOfAdjustment.quantity),
                  SizedBox(width: Dimensions.width20),
                  _radioOption('Value', ModeOfAdjustment.value),
                ],
              ),
            ]),
            SizedBox(height: Dimensions.height15),
            _card([
              Text('Reference#', style: _label()),
              TextField(
                controller: _referenceController,
                style: _value(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
              _divider(),
              SizedBox(height: Dimensions.height15),
              _requiredLabel('Date'),
              SizedBox(height: Dimensions.height10 / 2),
              InkWell(
                onTap: _pickDate,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDate(_date), style: _value()),
                    Icon(
                      Icons.calendar_today_outlined,
                      size: Dimensions.iconSize24 - 6,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              _divider(),
              SizedBox(height: Dimensions.height15),
              _requiredLabel('Account'),
              SizedBox(height: Dimensions.height10 / 2),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _account,
                  isExpanded: true,
                  style: _value(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black45,
                  ),
                  items: _accounts
                      .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                      .toList(),
                  onChanged: (v) => setState(() => _account = v),
                ),
              ),
              _divider(),
              SizedBox(height: Dimensions.height15),
              _requiredLabel('Reason'),
              SizedBox(height: Dimensions.height10 / 2),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _reason,
                  isExpanded: true,
                  hint: Text(
                    'Select a reason',
                    style: TextStyle(
                      color: Colors.black26,
                      fontSize: Dimensions.font16 * 0.85,
                    ),
                  ),
                  style: _value(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black45,
                  ),
                  items: _reasons
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) => setState(() => _reason = v),
                ),
              ),
              _divider(),
              SizedBox(height: Dimensions.height15),
              Text('Description', style: _label()),
              TextField(
                controller: _descriptionController,
                maxLength: 500,
                maxLines: 3,
                style: _value(),
                decoration: const InputDecoration(
                  hintText: 'Max 500 Characters',
                  hintStyle: TextStyle(color: Colors.black26),
                  border: InputBorder.none,
                  isDense: true,
                  counterText: '',
                ),
              ),
            ]),
            SizedBox(height: Dimensions.height15),
            if (_lineItems.isNotEmpty) ...[
              ..._lineItems.map(_lineItemCard),
              SizedBox(height: Dimensions.height10 / 2),
            ],
            _addLineItemButton(),
            SizedBox(height: Dimensions.height15),
            _card([
              Text('Attachments', style: _label()),
              SizedBox(height: Dimensions.height10),
              InkWell(
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                onTap: () {
                  // TODO: wire up a real file/image picker (e.g. file_picker
                  // or image_picker) and store the result on the adjustment.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('File upload coming soon')),
                  );
                },
                child: _DashedBorder(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.height15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          color: Colors.black45,
                          size: Dimensions.iconSize24 - 4,
                        ),
                        SizedBox(width: Dimensions.width10),
                        Text(
                          'Upload File',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.85,
                            color: const Color(0xFF0F172A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
            SizedBox(height: Dimensions.height30),
          ],
        ),
      ),
    );
  }
}

/// Simple dashed-rounded-rectangle border, used for the Attachments
/// "Upload File" drop zone (no external package dependency needed).
class _DashedBorder extends StatelessWidget {
  final Widget child;
  const _DashedBorder({required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _DashedBorderPainter(), child: child);
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(14),
    );
    final path = Path()..addRRect(rrect);
    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      const dashWidth = 6.0;
      const dashSpace = 4.0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
