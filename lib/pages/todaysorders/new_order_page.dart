import 'package:cloudcommerce/pages/todaysorders/new_order_styles.dart';
import 'package:cloudcommerce/pages/todaysorders/orders_styles.dart';
import 'package:cloudcommerce/services/new_order_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:cloudcommerce/pages/todaysorders/product_listing_page.dart'; // Add this import

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({Key? key}) : super(key: key);

  @override
  _NewOrderPageState createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _newOrderService = NewOrderService();
  final TextEditingController _buyerNameController = TextEditingController();
  final TextEditingController _accAddressController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();

  bool _isLoading = false;
  String _selectedPartyId = '';
  List<Map<String, dynamic>> _partyList = [];

  bool _isLoadingLocation = false;
  String _locationStatus = '';
  Position? _currentPosition;
  Map<String, dynamic>? _locationDetails;

  @override
  void dispose() {
    _buyerNameController.dispose();
    _accAddressController.dispose();
    _remarksController.dispose();
    _deliveryDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: OrderStyles.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _deliveryDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationStatus = 'Getting location...';
    });

    try {
      final position = await _newOrderService.getCurrentLocation();
      if (position != null) {
        _currentPosition = position;
        _locationDetails = await _newOrderService.fetchLocationDetails(
          position.latitude,
          position.longitude,
        );
        setState(() {
          _locationStatus = 'Location acquired';
        });
      }
    } catch (e) {
      setState(() {
        _locationStatus =
            'Error: ${e.toString().replaceAll('Exception: ', '')}';
      });
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      print('Debug: Form validation failed');
      return;
    }
    if (_selectedPartyId.isEmpty) {
      print('Debug: No party selected');
      _showError('Please select a party');
      return;
    }

    if (_currentPosition == null) {
      print('Debug: No location data, attempting to get location');
      await _getCurrentLocation();
      if (_currentPosition == null) {
        print('Debug: Still unable to get location');
        _showError('Unable to get location. Please try again');
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      print('Debug: Submitting order with:');
      print('PartyID: $_selectedPartyId');
      print('Remarks: ${_remarksController.text}');
      print('Delivery Date: ${_deliveryDateController.text}');
      print(
          'Position: ${_currentPosition?.latitude},${_currentPosition?.longitude}');
      print('Location Details: $_locationDetails');

      final orderId = await _newOrderService.submitOrder(
        partyId: _selectedPartyId,
        remarks: _remarksController.text,
        deliveryDate: _deliveryDateController.text,
        position: _currentPosition,
        locationDetails: _locationDetails,
      );

      if (!mounted) return;
      _showSuccess('Order created successfully');

      // Replace the pop with navigation to ProductListingPage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ProductListingPage(
            orderId: orderId,
            userName: 'sadmin', // Add required userName parameter
          ),
        ),
        (route) => false, // Remove all previous routes
      );
    } catch (e) {
      if (mounted) {
        _showError(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showPartyListDialog() async {
    setState(() => _isLoading = true);
    try {
      final parties = await _newOrderService.fetchPartyList();
      if (!mounted) return;

      setState(() => _partyList = parties);
      _showPartySelectionDialog();
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showPartySelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: NewOrderStyles.dialogDecoration,
          padding: NewOrderStyles.dialogPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select Party',
                  style: NewOrderStyles.dialogTitleStyle),
              const SizedBox(height: 16),
              SizedBox(
                height: NewOrderStyles.dialogMaxHeight,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _partyList.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final party = _partyList[index];
                    return ListTile(
                      title: Text(
                        party['Byr_nam'] ?? '',
                        style: NewOrderStyles.listTileTitleStyle,
                      ),
                      subtitle: Text(
                        party['AccAddress'] ?? '',
                        style: NewOrderStyles.listTileSubtitleStyle,
                      ),
                      onTap: () => _selectParty(party),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectParty(Map<String, dynamic> party) {
    setState(() {
      _buyerNameController.text = party['Byr_nam'] ?? '';
      _accAddressController.text = party['AccAddress'] ?? '';
      _selectedPartyId = party['PartyID'] ?? '';
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrderStyles.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(OrderStyles.appBarHeight),
        child: Container(
          decoration: OrderStyles.appBarDecoration,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Create Order', style: NewOrderStyles.titleStyle),
            centerTitle: true,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: NewOrderStyles.screenPadding,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _locationStatus.startsWith('Error')
                            ? Colors.red[100]
                            : Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isLoadingLocation
                                ? Icons.location_searching
                                : _locationStatus.startsWith('Error')
                                    ? Icons.location_off
                                    : Icons.location_on,
                            color: _locationStatus.startsWith('Error')
                                ? Colors.red
                                : Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(_locationStatus),
                          ),
                          if (_locationStatus.startsWith('Error'))
                            TextButton(
                              onPressed: _getCurrentLocation,
                              child: const Text('Retry'),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: NewOrderStyles.verticalSpacing),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _buyerNameController,
                            decoration: NewOrderStyles.getInputDecoration(
                              label: 'Buyer Name',
                              readOnly: true,
                            ),
                            style: NewOrderStyles.inputStyle,
                            validator: (value) => value?.isEmpty == true
                                ? 'Please select a buyer'
                                : null,
                            readOnly: true,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _showPartyListDialog,
                          color: OrderStyles.primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: NewOrderStyles.verticalSpacing),
                    TextFormField(
                      controller: _accAddressController,
                      decoration: NewOrderStyles.getInputDecoration(
                        label: 'Address',
                        readOnly: true,
                      ),
                      style: NewOrderStyles.inputStyle,
                      maxLines: 2,
                      readOnly: true,
                    ),
                    const SizedBox(height: NewOrderStyles.verticalSpacing),
                    TextFormField(
                      controller: _remarksController,
                      decoration: NewOrderStyles.getInputDecoration(
                        label: 'Remarks',
                      ),
                      style: NewOrderStyles.inputStyle,
                      maxLines: 3,
                    ),
                    const SizedBox(height: NewOrderStyles.verticalSpacing),
                    TextFormField(
                      controller: _deliveryDateController,
                      decoration: NewOrderStyles.getInputDecoration(
                        label: 'Delivery Date',
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      style: NewOrderStyles.inputStyle,
                      readOnly: true,
                      onTap: _selectDate,
                      validator: (value) => value?.isEmpty == true
                          ? 'Please select delivery date'
                          : null,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: NewOrderStyles.submitButtonStyle,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Submit Order',
                              style: NewOrderStyles.titleStyle,
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
