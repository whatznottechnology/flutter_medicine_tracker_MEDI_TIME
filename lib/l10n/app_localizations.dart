import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Medi Time'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Medi Time'**
  String get welcome;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Your personal medicine and health companion'**
  String get welcomeDescription;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Never Miss a Dose'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Set personalized reminders for all your medications and stay on track with your health routine.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Track Your Health'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Monitor your medicine intake, water consumption, and build healthy habits effortlessly.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Stay Organized'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Manage your medicine stock, get low stock alerts, and keep all your health data in one place.'**
  String get onboardingDesc3;

  /// No description provided for @personalizeExperience.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Personalize Your Experience'**
  String get personalizeExperience;

  /// No description provided for @personalizeDescription.
  ///
  /// In en, this message translates to:
  /// **'Tell us a bit about yourself to get the most out of Medi Time'**
  String get personalizeDescription;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @bengali.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get bengali;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @notificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Get timely reminders for your medicines'**
  String get notificationsDescription;

  /// No description provided for @waterReminders.
  ///
  /// In en, this message translates to:
  /// **'Water Reminders'**
  String get waterReminders;

  /// No description provided for @enableWaterReminders.
  ///
  /// In en, this message translates to:
  /// **'Enable Water Reminders'**
  String get enableWaterReminders;

  /// No description provided for @waterRemindersDescription.
  ///
  /// In en, this message translates to:
  /// **'Stay hydrated with regular water reminders'**
  String get waterRemindersDescription;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @medicines.
  ///
  /// In en, this message translates to:
  /// **'medicines'**
  String get medicines;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @goodNight.
  ///
  /// In en, this message translates to:
  /// **'Good Night'**
  String get goodNight;

  /// No description provided for @upcomingMedicines.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Medicines'**
  String get upcomingMedicines;

  /// No description provided for @waterProgress.
  ///
  /// In en, this message translates to:
  /// **'Water Progress'**
  String get waterProgress;

  /// No description provided for @adherenceRate.
  ///
  /// In en, this message translates to:
  /// **'Adherence Rate'**
  String get adherenceRate;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @addMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add Medicine'**
  String get addMedicine;

  /// No description provided for @logWater.
  ///
  /// In en, this message translates to:
  /// **'Log Water'**
  String get logWater;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @medicineName.
  ///
  /// In en, this message translates to:
  /// **'Medicine Name'**
  String get medicineName;

  /// No description provided for @dose.
  ///
  /// In en, this message translates to:
  /// **'Dose'**
  String get dose;

  /// No description provided for @medicineType.
  ///
  /// In en, this message translates to:
  /// **'Medicine Type'**
  String get medicineType;

  /// No description provided for @timing.
  ///
  /// In en, this message translates to:
  /// **'Timing'**
  String get timing;

  /// No description provided for @beforeMeal.
  ///
  /// In en, this message translates to:
  /// **'Before Meal'**
  String get beforeMeal;

  /// No description provided for @afterMeal.
  ///
  /// In en, this message translates to:
  /// **'After Meal'**
  String get afterMeal;

  /// No description provided for @withMeal.
  ///
  /// In en, this message translates to:
  /// **'With Meal'**
  String get withMeal;

  /// No description provided for @independent.
  ///
  /// In en, this message translates to:
  /// **'Anytime'**
  String get independent;

  /// No description provided for @currentStock.
  ///
  /// In en, this message translates to:
  /// **'Current Stock'**
  String get currentStock;

  /// No description provided for @lowStockThreshold.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Threshold'**
  String get lowStockThreshold;

  /// No description provided for @enableAlerts.
  ///
  /// In en, this message translates to:
  /// **'Enable Alerts'**
  String get enableAlerts;

  /// No description provided for @enableLowStockAlerts.
  ///
  /// In en, this message translates to:
  /// **'Enable Low Stock Alerts'**
  String get enableLowStockAlerts;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @tablet.
  ///
  /// In en, this message translates to:
  /// **'Tablet'**
  String get tablet;

  /// No description provided for @capsule.
  ///
  /// In en, this message translates to:
  /// **'Capsule'**
  String get capsule;

  /// No description provided for @liquid.
  ///
  /// In en, this message translates to:
  /// **'Liquid (ml)'**
  String get liquid;

  /// No description provided for @injection.
  ///
  /// In en, this message translates to:
  /// **'Injection'**
  String get injection;

  /// No description provided for @drops.
  ///
  /// In en, this message translates to:
  /// **'Drops'**
  String get drops;

  /// No description provided for @cream.
  ///
  /// In en, this message translates to:
  /// **'Cream/Gel'**
  String get cream;

  /// No description provided for @spray.
  ///
  /// In en, this message translates to:
  /// **'Spray'**
  String get spray;

  /// No description provided for @powder.
  ///
  /// In en, this message translates to:
  /// **'Powder (g)'**
  String get powder;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @taken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get taken;

  /// No description provided for @missed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missed;

  /// No description provided for @skipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get skipped;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @lowStockAlert.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Alert'**
  String get lowStockAlert;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStock;

  /// No description provided for @refillReminder.
  ///
  /// In en, this message translates to:
  /// **'Please refill your medicine'**
  String get refillReminder;

  /// No description provided for @noUpcomingMedicines.
  ///
  /// In en, this message translates to:
  /// **'No upcoming medicines'**
  String get noUpcomingMedicines;

  /// No description provided for @addFirstMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add your first medicine to get started with tracking'**
  String get addFirstMedicine;

  /// No description provided for @medicineMarkedTaken.
  ///
  /// In en, this message translates to:
  /// **'Medicine marked as taken'**
  String get medicineMarkedTaken;

  /// No description provided for @medicineMarkedSkipped.
  ///
  /// In en, this message translates to:
  /// **'Medicine marked as skipped'**
  String get medicineMarkedSkipped;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'UNDO'**
  String get undo;

  /// No description provided for @markTaken.
  ///
  /// In en, this message translates to:
  /// **'Mark Taken'**
  String get markTaken;

  /// No description provided for @skipDose.
  ///
  /// In en, this message translates to:
  /// **'Skip Dose'**
  String get skipDose;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @snoozed.
  ///
  /// In en, this message translates to:
  /// **'Snoozed'**
  String get snoozed;

  /// No description provided for @lowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get lowStock;

  /// No description provided for @todayIs.
  ///
  /// In en, this message translates to:
  /// **'Today is'**
  String get todayIs;

  /// No description provided for @stayHealthy.
  ///
  /// In en, this message translates to:
  /// **'Stay healthy and take your medicines on time!'**
  String get stayHealthy;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @noMedicinesAdded.
  ///
  /// In en, this message translates to:
  /// **'No medicines added'**
  String get noMedicinesAdded;

  /// No description provided for @addYourFirstMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add your first medicine and start tracking'**
  String get addYourFirstMedicine;

  /// No description provided for @skipMedicine.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipMedicine;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @am.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pm;

  /// No description provided for @setMealTimes.
  ///
  /// In en, this message translates to:
  /// **'Meal Times & Alerts'**
  String get setMealTimes;

  /// No description provided for @setMealTimesDescription.
  ///
  /// In en, this message translates to:
  /// **'Set your meal times for medicine reminders'**
  String get setMealTimesDescription;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @startTracking.
  ///
  /// In en, this message translates to:
  /// **'Start Tracking'**
  String get startTracking;

  /// No description provided for @editMedicine.
  ///
  /// In en, this message translates to:
  /// **'Edit Medicine'**
  String get editMedicine;

  /// No description provided for @updateMedicine.
  ///
  /// In en, this message translates to:
  /// **'Update Medicine'**
  String get updateMedicine;

  /// No description provided for @medicineForm.
  ///
  /// In en, this message translates to:
  /// **'Medicine Form'**
  String get medicineForm;

  /// No description provided for @relationToFood.
  ///
  /// In en, this message translates to:
  /// **'Relation to Food'**
  String get relationToFood;

  /// No description provided for @addAtLeastOneTime.
  ///
  /// In en, this message translates to:
  /// **'Add at least one reminder time'**
  String get addAtLeastOneTime;

  /// No description provided for @addTime.
  ///
  /// In en, this message translates to:
  /// **'Add Time'**
  String get addTime;

  /// No description provided for @pleaseEnterMedicineName.
  ///
  /// In en, this message translates to:
  /// **'Please enter medicine name'**
  String get pleaseEnterMedicineName;

  /// No description provided for @pleaseEnterDose.
  ///
  /// In en, this message translates to:
  /// **'Please enter dose information'**
  String get pleaseEnterDose;

  /// No description provided for @pleaseAddScheduleTime.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one schedule time'**
  String get pleaseAddScheduleTime;

  /// No description provided for @medicineUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Medicine updated successfully'**
  String get medicineUpdatedSuccessfully;

  /// No description provided for @medicineAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Medicine added successfully'**
  String get medicineAddedSuccessfully;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// No description provided for @tapToAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to add photo'**
  String get tapToAddPhoto;

  /// No description provided for @enterValidStockAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter valid stock amount'**
  String get enterValidStockAmount;

  /// No description provided for @enterValidThreshold.
  ///
  /// In en, this message translates to:
  /// **'Enter valid threshold'**
  String get enterValidThreshold;

  /// No description provided for @alertSettings.
  ///
  /// In en, this message translates to:
  /// **'Alert Settings'**
  String get alertSettings;

  /// No description provided for @medicineAlerts.
  ///
  /// In en, this message translates to:
  /// **'Medicine Alerts'**
  String get medicineAlerts;

  /// No description provided for @getMedicineReminders.
  ///
  /// In en, this message translates to:
  /// **'Get reminders for this medicine'**
  String get getMedicineReminders;

  /// No description provided for @lowStockAlerts.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Alerts'**
  String get lowStockAlerts;

  /// No description provided for @getNotifiedLowStock.
  ///
  /// In en, this message translates to:
  /// **'Get notified when stock is low'**
  String get getNotifiedLowStock;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @deleteMedicine.
  ///
  /// In en, this message translates to:
  /// **'Delete Medicine'**
  String get deleteMedicine;

  /// No description provided for @waterIntake.
  ///
  /// In en, this message translates to:
  /// **'Water Intake'**
  String get waterIntake;

  /// No description provided for @addGlass.
  ///
  /// In en, this message translates to:
  /// **'Add Glass'**
  String get addGlass;

  /// No description provided for @removedOneGlass.
  ///
  /// In en, this message translates to:
  /// **'Removed one glass'**
  String get removedOneGlass;

  /// No description provided for @removeLastGlass.
  ///
  /// In en, this message translates to:
  /// **'Remove last glass'**
  String get removeLastGlass;

  /// No description provided for @adherenceOverview.
  ///
  /// In en, this message translates to:
  /// **'Adherence Overview'**
  String get adherenceOverview;

  /// No description provided for @medicineAdherence.
  ///
  /// In en, this message translates to:
  /// **'Medicine Adherence'**
  String get medicineAdherence;

  /// No description provided for @waterGoalAchievement.
  ///
  /// In en, this message translates to:
  /// **'Water Goal Achievement'**
  String get waterGoalAchievement;

  /// No description provided for @waterGoalStreak.
  ///
  /// In en, this message translates to:
  /// **'Water Goal Streak'**
  String get waterGoalStreak;

  /// No description provided for @startStreakToday.
  ///
  /// In en, this message translates to:
  /// **'Start your streak today'**
  String get startStreakToday;

  /// No description provided for @medicineWaterReminders.
  ///
  /// In en, this message translates to:
  /// **'Medicine and water reminders'**
  String get medicineWaterReminders;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @playSoundNotifications.
  ///
  /// In en, this message translates to:
  /// **'Play sound for notifications'**
  String get playSoundNotifications;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @vibrateNotifications.
  ///
  /// In en, this message translates to:
  /// **'Vibrate for notifications'**
  String get vibrateNotifications;

  /// No description provided for @snoozeDuration.
  ///
  /// In en, this message translates to:
  /// **'Snooze Duration'**
  String get snoozeDuration;

  /// No description provided for @waterTracking.
  ///
  /// In en, this message translates to:
  /// **'Water Tracking'**
  String get waterTracking;

  /// No description provided for @dailyTarget.
  ///
  /// In en, this message translates to:
  /// **'Daily Target'**
  String get dailyTarget;

  /// No description provided for @regularHydrationReminders.
  ///
  /// In en, this message translates to:
  /// **'Regular hydration reminders'**
  String get regularHydrationReminders;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @downloadDataAsJSON.
  ///
  /// In en, this message translates to:
  /// **'Download your data as JSON'**
  String get downloadDataAsJSON;

  /// No description provided for @resetSettings.
  ///
  /// In en, this message translates to:
  /// **'Reset Settings'**
  String get resetSettings;

  /// No description provided for @restoreDefaultSettings.
  ///
  /// In en, this message translates to:
  /// **'Restore default settings'**
  String get restoreDefaultSettings;

  /// No description provided for @clearAllData.
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get clearAllData;

  /// No description provided for @deleteAllMedicinesHistory.
  ///
  /// In en, this message translates to:
  /// **'Delete all medicines and history'**
  String get deleteAllMedicinesHistory;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @glassesPerDay.
  ///
  /// In en, this message translates to:
  /// **'Glasses per day'**
  String get glassesPerDay;

  /// No description provided for @glasses.
  ///
  /// In en, this message translates to:
  /// **'glasses'**
  String get glasses;

  /// No description provided for @settingsResetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Settings reset to default'**
  String get settingsResetToDefault;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @allDataCleared.
  ///
  /// In en, this message translates to:
  /// **'All data cleared'**
  String get allDataCleared;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get last7Days;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30Days;

  /// No description provided for @last90Days.
  ///
  /// In en, this message translates to:
  /// **'Last 90 days'**
  String get last90Days;

  /// No description provided for @waterHistory.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get waterHistory;

  /// No description provided for @medicineHistory.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicineHistory;

  /// No description provided for @noHistoryData.
  ///
  /// In en, this message translates to:
  /// **'No history data'**
  String get noHistoryData;

  /// No description provided for @noMedicineHistory.
  ///
  /// In en, this message translates to:
  /// **'No medicine history for this period'**
  String get noMedicineHistory;

  /// No description provided for @noWaterHistory.
  ///
  /// In en, this message translates to:
  /// **'No water history for this period'**
  String get noWaterHistory;

  /// No description provided for @totalGlasses.
  ///
  /// In en, this message translates to:
  /// **'Total glasses'**
  String get totalGlasses;

  /// No description provided for @medicineNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Medicine Name *'**
  String get medicineNameLabel;

  /// No description provided for @medicineNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Aspirin, Vitamin D'**
  String get medicineNameHint;

  /// No description provided for @doseLabel.
  ///
  /// In en, this message translates to:
  /// **'Dose:'**
  String get doseLabel;

  /// No description provided for @doseHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 1 tablet, 5 ml, 500mg'**
  String get doseHint;

  /// No description provided for @medicineFormLabel.
  ///
  /// In en, this message translates to:
  /// **'Medicine Form'**
  String get medicineFormLabel;

  /// No description provided for @relationToFoodLabel.
  ///
  /// In en, this message translates to:
  /// **'Relation to Food'**
  String get relationToFoodLabel;

  /// No description provided for @scheduleTimesLabel.
  ///
  /// In en, this message translates to:
  /// **'Schedule Times *'**
  String get scheduleTimesLabel;

  /// No description provided for @addAtLeastOneTimeHint.
  ///
  /// In en, this message translates to:
  /// **'Add at least one reminder time'**
  String get addAtLeastOneTimeHint;

  /// No description provided for @addTimeButton.
  ///
  /// In en, this message translates to:
  /// **'Add Time'**
  String get addTimeButton;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesLabel;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Any additional information...'**
  String get notesHint;

  /// No description provided for @medicinePhotoOptional.
  ///
  /// In en, this message translates to:
  /// **'Medicine Photo (Optional)'**
  String get medicinePhotoOptional;

  /// No description provided for @stockManagementOptional.
  ///
  /// In en, this message translates to:
  /// **'Stock Management (Optional)'**
  String get stockManagementOptional;

  /// No description provided for @currentStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Stock'**
  String get currentStockLabel;

  /// No description provided for @currentStockHint.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get currentStockHint;

  /// No description provided for @lowStockAlertLabel.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Alert'**
  String get lowStockAlertLabel;

  /// No description provided for @lowStockAlertHint.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get lowStockAlertHint;

  /// No description provided for @alertSettingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Alert Settings'**
  String get alertSettingsLabel;

  /// No description provided for @medicineAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Medicine Alerts'**
  String get medicineAlertsTitle;

  /// No description provided for @medicineAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get reminders for this medicine'**
  String get medicineAlertsSubtitle;

  /// No description provided for @lowStockAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Alerts'**
  String get lowStockAlertsTitle;

  /// No description provided for @lowStockAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified when stock is low'**
  String get lowStockAlertsSubtitle;

  /// No description provided for @updateMedicineButton.
  ///
  /// In en, this message translates to:
  /// **'Update Medicine'**
  String get updateMedicineButton;

  /// No description provided for @addMedicineButton.
  ///
  /// In en, this message translates to:
  /// **'Add Medicine'**
  String get addMedicineButton;

  /// No description provided for @errorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'Error picking image:'**
  String get errorPickingImage;

  /// No description provided for @changePhotoButton.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhotoButton;

  /// No description provided for @removePhotoButton.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhotoButton;

  /// No description provided for @tapToAddPhotoText.
  ///
  /// In en, this message translates to:
  /// **'Tap to add photo'**
  String get tapToAddPhotoText;

  /// No description provided for @scheduledLabel.
  ///
  /// In en, this message translates to:
  /// **'Scheduled:'**
  String get scheduledLabel;

  /// No description provided for @actualLabel.
  ///
  /// In en, this message translates to:
  /// **'Actual:'**
  String get actualLabel;

  /// No description provided for @unknownMedicine.
  ///
  /// In en, this message translates to:
  /// **'Unknown Medicine'**
  String get unknownMedicine;

  /// No description provided for @unknownDose.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownDose;

  /// No description provided for @ofGlasses.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofGlasses;

  /// No description provided for @glassesText.
  ///
  /// In en, this message translates to:
  /// **'glasses'**
  String get glassesText;

  /// No description provided for @targetReached.
  ///
  /// In en, this message translates to:
  /// **'Target reached'**
  String get targetReached;

  /// No description provided for @targetNotReached.
  ///
  /// In en, this message translates to:
  /// **'Target not reached'**
  String get targetNotReached;

  /// No description provided for @waterTracker.
  ///
  /// In en, this message translates to:
  /// **'Water Tracker'**
  String get waterTracker;

  /// No description provided for @quickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActionsTitle;

  /// No description provided for @addGlassButton.
  ///
  /// In en, this message translates to:
  /// **'Add Glass'**
  String get addGlassButton;

  /// No description provided for @removeButton.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeButton;

  /// No description provided for @changeTargetButton.
  ///
  /// In en, this message translates to:
  /// **'Change Target'**
  String get changeTargetButton;

  /// No description provided for @glassAdded.
  ///
  /// In en, this message translates to:
  /// **'Glass added!'**
  String get glassAdded;

  /// No description provided for @glassRemoved.
  ///
  /// In en, this message translates to:
  /// **'Glass removed!'**
  String get glassRemoved;

  /// No description provided for @setWaterTarget.
  ///
  /// In en, this message translates to:
  /// **'Set Water Target'**
  String get setWaterTarget;

  /// No description provided for @glassesPerDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Glasses per day'**
  String get glassesPerDayLabel;

  /// No description provided for @glassesUnit.
  ///
  /// In en, this message translates to:
  /// **'glasses'**
  String get glassesUnit;

  /// No description provided for @waterLogged.
  ///
  /// In en, this message translates to:
  /// **'Water logged!'**
  String get waterLogged;

  /// No description provided for @adherenceOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Adherence Overview'**
  String get adherenceOverviewTitle;

  /// No description provided for @medicineAdherenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Medicine Adherence'**
  String get medicineAdherenceTitle;

  /// No description provided for @waterGoalAchievementTitle.
  ///
  /// In en, this message translates to:
  /// **'Water Goal Achievement'**
  String get waterGoalAchievementTitle;

  /// No description provided for @waterGoalStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Water Goal Streak'**
  String get waterGoalStreakTitle;

  /// No description provided for @consecutiveDays.
  ///
  /// In en, this message translates to:
  /// **'consecutive days!'**
  String get consecutiveDays;

  /// No description provided for @startStreakTodayText.
  ///
  /// In en, this message translates to:
  /// **'Start your streak today'**
  String get startStreakTodayText;

  /// No description provided for @noMedicineHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No medicine history yet'**
  String get noMedicineHistoryYet;

  /// No description provided for @noWaterHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No water history yet'**
  String get noWaterHistoryYet;

  /// No description provided for @selectImageSource.
  ///
  /// In en, this message translates to:
  /// **'Select Image Source'**
  String get selectImageSource;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @ofTarget.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofTarget;

  /// No description provided for @percentOfDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'% of daily goal'**
  String get percentOfDailyGoal;

  /// No description provided for @goalAchieved.
  ///
  /// In en, this message translates to:
  /// **'Goal achieved!'**
  String get goalAchieved;

  /// No description provided for @nextDosesDue.
  ///
  /// In en, this message translates to:
  /// **'Next doses due'**
  String get nextDosesDue;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up!'**
  String get allCaughtUp;

  /// No description provided for @medicine.
  ///
  /// In en, this message translates to:
  /// **'medicine'**
  String get medicine;

  /// No description provided for @medicineSkipped.
  ///
  /// In en, this message translates to:
  /// **'Medicine skipped'**
  String get medicineSkipped;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
