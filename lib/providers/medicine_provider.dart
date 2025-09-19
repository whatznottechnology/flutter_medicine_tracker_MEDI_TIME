import 'package:flutter/foundation.dart';
import '../models/medicine.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class MedicineProvider extends ChangeNotifier {
  List<Medicine> _medicines = [];
  bool _isLoading = false;
  String? _error;

  List<Medicine> get medicines => _medicines;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Medicine> get activeMedicines => 
      _medicines.where((medicine) => medicine.isActive).toList();

  MedicineProvider() {
    _loadMedicines();
    _listenToChanges();
  }

  void _listenToChanges() {
    DatabaseService.medicinesListenable().addListener(_loadMedicines);
  }

  Future<void> _loadMedicines() async {
    try {
      _medicines = DatabaseService.getAllMedicines();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> addMedicine(Medicine medicine) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await DatabaseService.addMedicine(medicine);
      await NotificationService.scheduleAllMedicineReminders(medicine);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMedicine(Medicine medicine) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Cancel existing reminders
      await NotificationService.cancelMedicineReminders(medicine.id);
      
      // Update medicine
      await DatabaseService.updateMedicine(medicine);
      
      // Schedule new reminders if medicine is active
      if (medicine.isActive) {
        await NotificationService.scheduleAllMedicineReminders(medicine);
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMedicine(String medicineId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await NotificationService.cancelMedicineReminders(medicineId);
      await DatabaseService.deleteMedicine(medicineId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleMedicineStatus(String medicineId) async {
    final medicine = _medicines.firstWhere((m) => m.id == medicineId);
    final updatedMedicine = medicine.copyWith(isActive: !medicine.isActive);
    await updateMedicine(updatedMedicine);
  }

  Medicine? getMedicineById(String id) {
    try {
      return _medicines.firstWhere((medicine) => medicine.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Medicine> searchMedicines(String query) {
    if (query.isEmpty) return activeMedicines;
    
    return activeMedicines.where((medicine) =>
        medicine.name.toLowerCase().contains(query.toLowerCase()) ||
        medicine.dose.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    DatabaseService.medicinesListenable().removeListener(_loadMedicines);
    super.dispose();
  }
}