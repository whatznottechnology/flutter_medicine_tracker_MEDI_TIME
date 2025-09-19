import '../models/medicine.dart';
import '../models/water_log.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class SeedDataService {
  static Future<void> addSampleData() async {
    try {
      // Check if data already exists
      final existingMedicines = DatabaseService.getAllMedicines();
      if (existingMedicines.isNotEmpty) {
        return; // Don't add sample data if medicines already exist
      }

      // Add sample medicine
      final sampleMedicine = Medicine(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Vitamin D',
        dose: '1 tablet',
        form: MedicineForm.tablet,
        relationToFood: FoodRelation.afterMeal,
        scheduleTimes: ['08:00', '20:00'],
        notes: 'Take with food for better absorption',
        createdAt: DateTime.now(),
      );

      await DatabaseService.addMedicine(sampleMedicine);
      await NotificationService.scheduleAllMedicineReminders(sampleMedicine);

      // Add sample water log for today
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      
      final sampleWaterLog = WaterLog(
        id: 'water_${today.year}_${today.month}_${today.day}',
        date: todayDate,
        glassesTaken: 3,
        target: 8,
        intakeTimes: [
          DateTime(today.year, today.month, today.day, 8, 0),
          DateTime(today.year, today.month, today.day, 12, 0),
          DateTime(today.year, today.month, today.day, 16, 0),
        ],
        createdAt: DateTime.now(),
      );

      await DatabaseService.addWaterLog(sampleWaterLog);

      print('Sample data added successfully');
    } catch (e) {
      print('Error adding sample data: $e');
    }
  }

  static Future<void> addAdditionalSampleMedicines() async {
    try {
      final medicines = [
        Medicine(
          id: '${DateTime.now().millisecondsSinceEpoch + 1}',
          name: 'Omega-3',
          dose: '2 capsules',
          form: MedicineForm.capsule,
          relationToFood: FoodRelation.withMeal,
          scheduleTimes: ['09:00', '21:00'],
          notes: 'Support heart and brain health',
          createdAt: DateTime.now(),
        ),
        Medicine(
          id: '${DateTime.now().millisecondsSinceEpoch + 2}',
          name: 'Aspirin',
          dose: '75mg',
          form: MedicineForm.tablet,
          relationToFood: FoodRelation.afterMeal,
          scheduleTimes: ['19:00'],
          notes: 'Blood thinner - take as prescribed',
          createdAt: DateTime.now(),
        ),
      ];

      for (final medicine in medicines) {
        await DatabaseService.addMedicine(medicine);
        await NotificationService.scheduleAllMedicineReminders(medicine);
      }

      print('Additional sample medicines added');
    } catch (e) {
      print('Error adding additional sample data: $e');
    }
  }
}