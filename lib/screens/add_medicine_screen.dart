import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medicine_provider.dart';
import '../models/medicine.dart';
import '../services/image_service.dart';
import '../l10n/app_localizations.dart';
import 'dart:io';

class AddMedicineScreen extends StatefulWidget {
  final Medicine? medicine; // For editing existing medicine

  const AddMedicineScreen({super.key, this.medicine});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _doseController = TextEditingController();
  final _notesController = TextEditingController();
  final _currentStockController = TextEditingController();
  final _lowStockThresholdController = TextEditingController();
  
  MedicineForm _selectedForm = MedicineForm.tablet;
  FoodRelation _selectedFoodRelation = FoodRelation.independent;
  List<String> _scheduleTimes = [];
  String? _imagePath;
  bool _alertsEnabled = true;
  bool _lowStockAlertsEnabled = true;

  bool get _isEditing => widget.medicine != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _populateFields();
    }
  }

  void _populateFields() {
    final medicine = widget.medicine!;
    _nameController.text = medicine.name;
    _doseController.text = medicine.dose;
    _notesController.text = medicine.notes ?? '';
    _currentStockController.text = medicine.currentStock?.toString() ?? '';
    _lowStockThresholdController.text = medicine.lowStockThreshold?.toString() ?? '';
    _selectedForm = medicine.form;
    _selectedFoodRelation = medicine.relationToFood;
    _scheduleTimes = List.from(medicine.scheduleTimes);
    _imagePath = medicine.imagePath;
    _alertsEnabled = medicine.alertsEnabled;
    _lowStockAlertsEnabled = medicine.lowStockAlertsEnabled;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    _notesController.dispose();
    _currentStockController.dispose();
    _lowStockThresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editMedicine : l10n.addMedicine),
        actions: [
          TextButton(
            onPressed: _saveMedicine,
            child: Text(l10n.save),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNameField(),
              const SizedBox(height: 16),
              _buildDoseField(),
              const SizedBox(height: 16),
              _buildFormDropdown(),
              const SizedBox(height: 16),
              _buildFoodRelationDropdown(),
              const SizedBox(height: 24),
              _buildScheduleSection(),
              const SizedBox(height: 24),
              _buildNotesField(),
              const SizedBox(height: 24),
              _buildImageUploadSection(),
              const SizedBox(height: 24),
              _buildStockManagementSection(),
              const SizedBox(height: 24),
              _buildAlertsSection(),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: l10n.medicineNameLabel,
        hintText: l10n.medicineNameHint,
        prefixIcon: const Icon(Icons.medication),
      ),
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.pleaseEnterMedicineName;
        }
        return null;
      },
    );
  }

  Widget _buildDoseField() {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: _doseController,
      decoration: InputDecoration(
        labelText: l10n.doseLabel,
        hintText: l10n.doseHint,
        prefixIcon: const Icon(Icons.medical_information),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.pleaseEnterDose;
        }
        return null;
      },
    );
  }

  Widget _buildFormDropdown() {
    final l10n = AppLocalizations.of(context)!;
    return DropdownButtonFormField<MedicineForm>(
      value: _selectedForm,
      decoration: InputDecoration(
        labelText: l10n.medicineFormLabel,
        prefixIcon: const Icon(Icons.category),
      ),
      items: MedicineForm.values.map((form) {
        return DropdownMenuItem(
          value: form,
          child: Text(form.displayName(context)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedForm = value;
          });
        }
      },
    );
  }

  Widget _buildFoodRelationDropdown() {
    final l10n = AppLocalizations.of(context)!;
    return DropdownButtonFormField<FoodRelation>(
      value: _selectedFoodRelation,
      decoration: InputDecoration(
        labelText: l10n.relationToFoodLabel,
        prefixIcon: const Icon(Icons.restaurant),
      ),
      items: FoodRelation.values.map((relation) {
        return DropdownMenuItem(
          value: relation,
          child: Text(relation.displayName(context)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedFoodRelation = value;
          });
        }
      },
    );
  }

  Widget _buildScheduleSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.scheduleTimesLabel,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (_scheduleTimes.isEmpty) ...[
          Text(
            l10n.addAtLeastOneTimeHint,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),
        ] else ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _scheduleTimes.asMap().entries.map((entry) {
              final index = entry.key;
              final time = entry.value;
              return Chip(
                label: Text(time),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  setState(() {
                    _scheduleTimes.removeAt(index);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],
        OutlinedButton.icon(
          onPressed: _addScheduleTime,
          icon: const Icon(Icons.add),
          label: Text(l10n.addTimeButton),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: _notesController,
      decoration: InputDecoration(
        labelText: l10n.notesLabel,
        hintText: l10n.notesHint,
        prefixIcon: const Icon(Icons.note),
      ),
      maxLines: 3,
    );
  }

  Widget _buildSaveButton() {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: Consumer<MedicineProvider>(
        builder: (context, medicineProvider, child) {
          return ElevatedButton(
            onPressed: medicineProvider.isLoading ? null : _saveMedicine,
            child: medicineProvider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_isEditing ? l10n.updateMedicineButton : l10n.addMedicineButton),
          );
        },
      ),
    );
  }

  Future<void> _addScheduleTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final timeString = _formatTime(picked);
      if (!_scheduleTimes.contains(timeString)) {
        setState(() {
          _scheduleTimes.add(timeString);
          _scheduleTimes.sort(); // Keep times in chronological order
        });
      }
    }
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _saveMedicine() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_scheduleTimes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseAddScheduleTime),
        ),
      );
      return;
    }

    final medicineProvider = Provider.of<MedicineProvider>(context, listen: false);

    try {
      final medicine = Medicine(
        id: _isEditing ? widget.medicine!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        dose: _doseController.text.trim(),
        form: _selectedForm,
        relationToFood: _selectedFoodRelation,
        scheduleTimes: _scheduleTimes,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        createdAt: _isEditing ? widget.medicine!.createdAt : DateTime.now(),
        imagePath: _imagePath,
        currentStock: _currentStockController.text.trim().isEmpty ? null : int.tryParse(_currentStockController.text.trim())?.toDouble(),
        lowStockThreshold: _lowStockThresholdController.text.trim().isEmpty ? null : int.tryParse(_lowStockThresholdController.text.trim())?.toDouble(),
        alertsEnabled: _alertsEnabled,
        lowStockAlertsEnabled: _lowStockAlertsEnabled,
      );

      if (_isEditing) {
        await medicineProvider.updateMedicine(medicine);
      } else {
        await medicineProvider.addMedicine(medicine);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing 
                ? l10n.medicineUpdatedSuccessfully 
                : l10n.medicineAddedSuccessfully),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorPickingImage} $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildImageUploadSection() {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.camera_alt, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.medicinePhotoOptional,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_imagePath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(_imagePath!),
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.edit),
                    label: Text(l10n.changePhotoButton),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => _imagePath = null),
                    icon: const Icon(Icons.delete),
                    label: Text(l10n.removePhotoButton),
                  ),
                ],
              ),
            ] else ...[
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.tapToAddPhotoText,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStockManagementSection() {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.inventory, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.stockManagementOptional,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _currentStockController,
                    decoration: InputDecoration(
                      labelText: l10n.currentStockLabel,
                      hintText: l10n.currentStockHint,
                      suffixText: _selectedForm.unitName,
                      prefixIcon: const Icon(Icons.storage),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final stock = double.tryParse(value);
                        if (stock == null || stock < 0) {
                          return l10n.enterValidStockAmount;
                        }
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _lowStockThresholdController,
                    decoration: InputDecoration(
                      labelText: l10n.lowStockAlertLabel,
                      hintText: l10n.lowStockAlertHint,
                      suffixText: _selectedForm.unitName,
                      prefixIcon: const Icon(Icons.warning_amber),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final threshold = double.tryParse(value);
                        if (threshold == null || threshold < 0) {
                          return l10n.enterValidThreshold;
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsSection() {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notifications, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.alertSettingsLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: Text(l10n.medicineAlertsTitle),
              subtitle: Text(l10n.medicineAlertsSubtitle),
              value: _alertsEnabled,
              onChanged: (value) => setState(() => _alertsEnabled = value),
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              title: Text(l10n.lowStockAlertsTitle),
              subtitle: Text(l10n.lowStockAlertsSubtitle),
              value: _lowStockAlertsEnabled,
              onChanged: (value) => setState(() => _lowStockAlertsEnabled = value),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final imagePath = await ImageService.showImagePickerDialog(context);
      if (imagePath != null) {
        setState(() {
          _imagePath = imagePath;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorPickingImage} $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}