import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/widgets/widgets.dart';

/// Step 4: price per hour, typed or picked from common values.
class PriceStep extends StatelessWidget {
  const PriceStep({
    super.key,
    required this.formKey,
    required this.price,
    required this.onChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController price;

  /// Called after the price changes (typed or picked) so the chips refresh.
  final VoidCallback onChanged;

  static const _quickPrices = [250, 300, 350, 400, 500, 600];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppTextField(
            label: S.priceLabel,
            hint: S.priceHint,
            controller: price,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            prefixIcon: AppIcons.money,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(5),
            ],
            onChanged: (_) => onChanged(),
            validator: (v) {
              final n = int.tryParse(v ?? '');
              return n == null || n <= 0 ? S.invalidPrice : null;
            },
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in _quickPrices)
                ChoiceChip(
                  label: Text(S.price(p)),
                  selected: price.text == '$p',
                  showCheckmark: false,
                  onSelected: (_) {
                    price.text = '$p';
                    onChanged();
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
