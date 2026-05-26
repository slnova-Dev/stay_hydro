// ==========================================
// [FILE: APP STRINGS]
// [PHASE 10.6-A1 LOCALIZATION FOUNDATION]
//
// اردو کمنٹ:
// ایپ کے visible text کو ایک جگہ جمع کرنے کے لیے foundation file
// ابھی default English strings استعمال ہوں گی
// بعد میں Spanish / Arabic / Hindi / Indonesian یہاں add ہوں گی
// ==========================================

class AppStrings {
  // ==========================================
  // [GENERAL]
  // ==========================================
  static const String appName = 'StayHydro';
  static const String settings = 'Settings';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String reset = 'Reset';
  static const String delete = 'Delete';
  static const String gotIt = 'Got it';
  static const String later = 'Later';
  static const String comingSoon = 'Coming soon';

  // ==========================================
  // [SETTINGS: SECTIONS]
  // ==========================================
  static const String appearancePersonalization =
      'Appearance & Personalization';
  static const String notificationSounds = 'Notification & Sounds';
  static const String reminderSystem = 'Reminder System';
  static const String customSchedule = 'Custom Schedule';
  static const String specialReminders = 'Special Reminders';
  static const String scheduleSystem = 'Schedule & System';
  static const String reminderReliabilityTips = 'Reminder Reliability Tips';
  static const String appSupport = 'App Support';

  // ==========================================
  // [SETTINGS: APPEARANCE]
  // ==========================================
  static const String darkTheme = 'Dark Theme';
  static const String appLanguage = 'App Language';
  static const String moreLanguagesComingSoon = 'More languages coming soon';
  static const String dailyGoal = 'Daily Goal';
  static const String selectDailyGoal = 'Select Daily Goal';

  // ==========================================
  // [SETTINGS: NOTIFICATIONS]
  // ==========================================
  static const String fastingMode = 'Fasting Mode';
  static const String pauseHydrationReminders = 'Pause hydration reminders';
  static const String reminderMode = 'Reminder Mode';
  static const String reminderSound = 'Reminder Sound';
  static const String selectReminderMode = 'Select Reminder Mode';
  static const String selectNotificationSound = 'Select Notification Sound';

  // ==========================================
  // [REMINDER MODE]
  // ==========================================
  static const String soundVibrate = 'Sound + Vibrate';
  static const String soundOnly = 'Sound only';
  static const String vibrateOnly = 'Vibrate only';
  static const String silent = 'Silent';

  // ==========================================
  // [REMINDER SYSTEM]
  // ==========================================
  static const String smartHourly = 'Smart Hourly';
  static const String customScheduleMode = 'Custom Schedule';
  static const String selectReminderSystem = 'Select Reminder System';
  static const String smartHourlySubtitle =
      'Automatic hourly reminders with sleep hours';
  static const String customScheduleSubtitle = 'Choose your own reminder times';

  // ==========================================
  // [CUSTOM SCHEDULE]
  // ==========================================
  static const String customReminderTimes = 'Custom Reminder Times';
  static const String customReminderTimesHelp =
      'Enable, disable or edit each hydration reminder time.';
  static const String onlyAvailableCustomSchedule =
      'Only available in Custom Schedule';
  static const String resetDefaults = 'Reset defaults';
  static const String addReminder = 'Add reminder';
  static const String noCustomRemindersYet = 'No custom reminders yet';
  static const String addCustomReminderHint =
      'Tap the + button above to add your own hydration reminder time.';
  static const String customHydrationReminder = 'Custom hydration reminder';
  static const String disabled = 'Disabled';
  static const String resetSchedule = 'Reset Schedule?';
  static const String resetScheduleMessage =
      'This will replace your current custom reminder times with the default StayHydro schedule.';
  static const String deleteReminder = 'Delete Reminder?';
  static const String deleteReminderMessage =
      'This custom reminder time will be removed permanently.';
  static const String maximumReached = 'Maximum Reached';
  static const String maxCustomReminderMessage =
      'You can create up to 20 custom reminder times.';

  // ==========================================
  // [SPECIAL REMINDERS]
  // ==========================================
  static const String medicineReminder = 'Medicine Reminder';
  static const String wellnessReminder = 'Wellness Reminder';
  static const String bedtimeWater = 'Bedtime Water';
  static const String healthReminder = 'Health Reminder';
  static const String lockedSoundMode = 'Locked sound & mode';
  static const String offTapHealthReminder = 'Off • Tap to set health reminder';
  static const String selectTime = 'Select Time';
  static const String healthReminderMessage = 'Health reminder message';
  static const String saveReminder = 'Save Reminder';
  static const String specialReminder = 'Special Reminder';
  static const String specialReminderFallback = 'Special';

  // ==========================================
  // [SLEEP / SYSTEM]
  // ==========================================
  static const String sleepStartHour = 'Sleep Start Hour';
  static const String sleepEndHour = 'Sleep End Hour';
  static const String sleepHours = 'Sleep Hours';
  static const String onlyAppliesSmartHourly = 'Only applies to Smart Hourly';
  static const String batteryOptimization = 'Battery Optimization';
  static const String batteryOptimizationSubtitle =
      'Required for reliable reminders';
  static const String autoStartBackground = 'Auto Start & Background';
  static const String autoStartBackgroundSubtitle =
      'Enable auto start and background activity';

  // ==========================================
  // [RELIABILITY TIPS]
  // ==========================================
  static const String disableBatteryOptimization =
      'Disable Battery Optimization';
  static const String disableBatteryOptimizationSubtitle =
      'Set StayHydro to Not Optimized for reliable reminders.';
  static const String enableAutoStart = 'Enable Auto Start';
  static const String enableAutoStartSubtitle =
      'Recommended for Oppo, Xiaomi, Vivo & Realme devices.';
  static const String allowBackgroundActivity = 'Allow Background Activity';
  static const String allowBackgroundActivitySubtitle =
      'Helps reminders continue while the app is closed.';
  static const String allowNotificationsExactAlarms =
      'Allow Notifications & Exact Alarms';
  static const String allowNotificationsExactAlarmsSubtitle =
      'Required for accurate reminder delivery.';
  static const String restartReliability = 'Restart Reliability';
  static const String restartReliabilitySubtitle =
      'StayHydro restores reminders automatically after reboot.';

  // ==========================================
  // [APP SUPPORT]
  // ==========================================
  static const String testNotification = 'Test Notification';
  static const String testNotificationSubtitle =
      'Check if reminders are working';
  static const String testNotificationSent = 'Test notification sent!';
  static const String helpFeedback = 'Help & Feedback';
  static const String helpFeedbackSubtitle =
      'Report a problem or suggest a feature';
  static const String privacyTerms = 'Privacy & Terms';
  static const String privacyTermsSubtitle = 'Coming before Play Store release';
  static const String aboutStayHydro = 'About StayHydro';
  static const String aboutStayHydroSubtitle = 'Version 1.0.0 • SLNova';

  // ==========================================
  // [FIRST LAUNCH GUIDE]
  // ==========================================
  static const String keepRemindersReliable = 'Keep Reminders Reliable';
  static const String firstLaunchReliabilityMessage =
      'For best results, allow notifications and enable Battery Optimization / Auto Start settings for StayHydro.\n\n'
      'On Oppo, Realme, Vivo and Xiaomi phones, also allow background activity so reminders keep working after restart.';

  // ==========================================
// [INFO / SNACKBARS / DIALOGS]
// ==========================================

  static const String languageComingSoonMessage =
      'Language options will be added in a future update.';

  static const String reminderSystemChanged = 'Reminder system set to';

  static const String sleepHoursUpdated = 'Sleep hours updated & scheduled';

  static const String customScheduleInactive = 'Custom Schedule Inactive';

  static const String customScheduleInactiveMessage =
      'Select Custom Schedule from Reminder System to manage your custom reminder times.';
}
