import 'package:flutter/material.dart';
import '../../theme.dart';

class ShippingForm extends StatefulWidget {
  final void Function(Map<String, String>) onSaved;
  const ShippingForm({super.key, required this.onSaved});

  @override
  State<ShippingForm> createState() => _ShippingFormState();
}

class _ShippingFormState extends State<ShippingForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalController = TextEditingController();
  String? _selectedProvince;
  String? _selectedCity;
  final List<String> _provinces = [
    'Punjab',
    'Sindh',
    'KPK',
    'Balochistan',
    'Gilgit-Baltistan',
    'Islamabad',
  ];
  final Map<String, List<String>> _cities = {
    'Punjab': ['Lahore', 'Faisalabad', 'Rawalpindi'],
    'Sindh': ['Karachi', 'Hyderabad'],
    'KPK': ['Peshawar', 'Abbottabad'],
    'Balochistan': ['Quetta'],
    'Gilgit-Baltistan': ['Gilgit'],
    'Islamabad': ['Islamabad'],
  };

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Full Name'),
          _textField(
            _nameController,
            'Enter fullname',
            (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 18),
          _label('Mobile Number'),
          _textField(
            _phoneController,
            'Enter phone',
            (v) => v!.isEmpty ? 'Required' : null,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 18),
          _label('Province'),
          DropdownButtonFormField<String>(
            value: _selectedProvince,
            items:
                _provinces
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged:
                (v) => setState(() {
                  _selectedProvince = v;
                  _selectedCity = null;
                }),
            validator: (v) => v == null ? 'Required' : null,
            decoration: _inputDecoration('Select Province'),
          ),
          const SizedBox(height: 18),
          _label('City'),
          DropdownButtonFormField<String>(
            value: _selectedCity,
            items:
                (_selectedProvince == null ? [] : _cities[_selectedProvince!]!)
                    .map<DropdownMenuItem<String>>(
                      (e) => DropdownMenuItem<String>(value: e, child: Text(e)),
                    )
                    .toList(),
            onChanged: (v) => setState(() => _selectedCity = v),
            validator: (v) => v == null ? 'Required' : null,
            decoration: _inputDecoration('Select City'),
          ),
          const SizedBox(height: 18),
          _label('Street Address'),
          _textField(
            _addressController,
            'Enter address',
            (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 18),
          _label('Postal Code'),
          _textField(
            _postalController,
            'Enter postal code',
            (v) => v!.isEmpty ? 'Required' : null,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Cyan,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSaved({
                    'fullName': _nameController.text,
                    'phoneNumber': _phoneController.text,
                    'province': _selectedProvince!,
                    'city': _selectedCity!,
                    'streetAddress': _addressController.text,
                    'postalCode': _postalController.text,
                  });
                }
              },
              child: Text(
                'Save',
                style: primaryTextStyle.copyWith(
                  color: Black,
                  fontWeight: bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Text(
          text,
          style: primaryTextStyle.copyWith(fontWeight: semibold, fontSize: 14),
        ),
        const SizedBox(width: 2),
        Text('*', style: TextStyle(color: Red, fontSize: 14)),
      ],
    ),
  );

  Widget _textField(
    TextEditingController c,
    String hint,
    String? Function(String?) validator, {
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: c,
      style: primaryTextStyle.copyWith(color: White),
      keyboardType: keyboardType,
      decoration: _inputDecoration(hint),
      validator: validator,
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: secondaryTextStyle.copyWith(color: Grey100),
    filled: true,
    fillColor: Grey50,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Grey100.withOpacity(0.2)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Grey100.withOpacity(0.2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Cyan, width: 1.5),
    ),
  );
}
