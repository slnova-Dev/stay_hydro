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
  // [PHASE 10.6-A2: ACTIVE LANGUAGE FOUNDATION]
  //
  // اردو کمنٹ:
  // ابھی static strings چلتی رہیں گی
  // مگر selected language کو memory میں رکھنے کے لیے foundation add کر دی گئی ہے
  // اگلے steps میں maps کے ذریعے translations یہاں سے آئیں گی
  // ==========================================
  static String activeLanguage = 'English';

  static void setLanguage(String language) {
    activeLanguage = language;
  }

  static bool get isArabic => activeLanguage == 'Arabic';

  // ==========================================
  // [PHASE 10.6-A3: FIRST TRANSLATED STRINGS TEST]
  // اردو کمنٹ:
  // پہلے صرف چند strings کو selected language کے مطابق بدلنے کا test
  // ==========================================
  static String t(String key) {
    return _localized[activeLanguage]?[key] ?? _localized['English']![key]!;
  }

  static const Map<String, Map<String, String>> _localized = {
    // ===========
    // [ENGLISH]
    // ===========
    'English': {
      'settings': 'Settings',
      'darkTheme': 'Dark Theme',
      'appLanguage': 'App Language',
      'dailyGoal': 'Daily Goal',
      'notificationSounds': 'Notification & Sounds',
      'fastingMode': 'Fasting Mode',
      'reminderMode': 'Reminder Mode',
      'reminderSound': 'Reminder Sound',
      'reminderSystem': 'Reminder System',
      'customSchedule': 'Custom Schedule',
      'specialReminders': 'Special Reminders',
      'scheduleSystem': 'Schedule & System',
      'appSupport': 'App Support',
      'soundVibrate': 'Sound + Vibrate',
      'soundOnly': 'Sound only',
      'vibrateOnly': 'Vibrate only',
      'silent': 'Silent',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'reset': 'Reset',
      'gotIt': 'Got it',
      'comingSoon': 'Coming soon',
      'saveReminder': 'Save Reminder',
      'selectTime': 'Select Time',
      'healthReminderMessage': 'Health reminder message',
      'resetDefaults': 'Reset defaults',
      'addReminder': 'Add reminder',
      'deleteReminder': 'Delete Reminder?',
      'resetSchedule': 'Reset Schedule?',
      'noCustomRemindersYet': 'No custom reminders yet',
      'customReminderTimesHelp':
          'Enable, disable or edit each hydration reminder time.',
      'customHydrationReminder': 'Custom hydration reminder',
      'disabled': 'Disabled',
      'addCustomReminderHint':
          'Tap the + button above to add your own hydration reminder time.',
      'resetScheduleMessage':
          'This will replace your current custom reminder times with the default StayHydro schedule.',
      'deleteReminderMessage':
          'This custom reminder time will be removed permanently.',
      'maximumReached': 'Maximum Reached',
      'maxCustomReminderMessage':
          'You can create up to 20 custom reminder times.',
      'smartHourly': 'Smart Hourly',
      'customScheduleMode': 'Custom Schedule',
      'appearancePersonalization': 'Appearance & Personalization',
      'language': 'Language',
      'moreLanguagesComingSoon': 'More languages coming soon',
      'currentlyActive': 'Currently active',
      'fullTranslationsBeforeRelease':
          'Full translations will be added before release.',
      'pauseHydrationReminders': 'Pause hydration reminders',
      'selectDailyGoal': 'Select Daily Goal',
      'dailyGoalUpdated': 'Daily goal updated to',
      'ml': 'ml',
    },

    // ===========
    // [SPANISH]
    // ===========
    'Spanish': {
      'settings': 'Configuración',
      'darkTheme': 'Tema oscuro',
      'appLanguage': 'Idioma de la app',
      'dailyGoal': 'Objetivo diario',
      'notificationSounds': 'Notificaciones y sonidos',
      'fastingMode': 'Modo de ayuno',
      'reminderMode': 'Modo de recordatorio',
      'reminderSound': 'Sonido del recordatorio',
      'reminderSystem': 'Sistema de recordatorios',
      'customSchedule': 'Horario personalizado',
      'specialReminders': 'Recordatorios especiales',
      'scheduleSystem': 'Horario y sistema',
      'appSupport': 'Soporte de la app',
      'soundVibrate': 'Sonido + vibración',
      'soundOnly': 'Solo sonido',
      'vibrateOnly': 'Solo vibración',
      'silent': 'Silencioso',
      'save': 'Guardar',
      'cancel': 'Cancelar',
      'delete': 'Eliminar',
      'reset': 'Restablecer',
      'gotIt': 'Entendido',
      'comingSoon': 'Próximamente',
      'saveReminder': 'Guardar recordatorio',
      'selectTime': 'Seleccionar hora',
      'healthReminderMessage': 'Mensaje del recordatorio de salud',
      'resetDefaults': 'Restablecer valores',
      'addReminder': 'Añadir recordatorio',
      'deleteReminder': '¿Eliminar recordatorio?',
      'resetSchedule': '¿Restablecer horario?',
      'noCustomRemindersYet': 'Aún no hay recordatorios personalizados',
      'customReminderTimesHelp':
          'Activa, desactiva o edita cada hora de recordatorio de hidratación.',
      'customHydrationReminder': 'Recordatorio de hidratación personalizado',
      'disabled': 'Desactivado',
      'addCustomReminderHint':
          'Toca el botón + para añadir tu propia hora de recordatorio de hidratación.',
      'resetScheduleMessage':
          'Esto reemplazará tus horarios personalizados actuales por el horario predeterminado de StayHydro.',
      'deleteReminderMessage':
          'Este horario de recordatorio personalizado se eliminará permanentemente.',
      'maximumReached': 'Máximo alcanzado',
      'maxCustomReminderMessage':
          'Puedes crear hasta 20 horarios de recordatorio personalizados.',
      'smartHourly': 'Inteligente por hora',
      'appearancePersonalization': 'Apariencia y personalización',
      'language': 'Language',
      'moreLanguagesComingSoon': 'Más idiomas próximamente',
      'currentlyActive': 'Activo actualmente',
      'fullTranslationsBeforeRelease':
          'Las traducciones completas se añadirán antes del lanzamiento.',
      'pauseHydrationReminders': 'Pausar recordatorios de hidratación',
      'selectDailyGoal': 'Seleccionar objetivo diario',
      'dailyGoalUpdated': 'Objetivo diario actualizado a',
      'ml': 'ml',
    },

    // ===========
    // [ARABIC]
    // ===========
    'Arabic': {
      'settings': 'الإعدادات',
      'darkTheme': 'الوضع الداكن',
      'appLanguage': 'لغة التطبيق',
      'dailyGoal': 'الهدف اليومي',
      'notificationSounds': 'الإشعارات والأصوات',
      'fastingMode': 'وضع الصيام',
      'reminderMode': 'وضع التذكير',
      'reminderSound': 'صوت التذكير',
      'reminderSystem': 'نظام التذكيرات',
      'customSchedule': 'جدول مخصص',
      'specialReminders': 'تذكيرات خاصة',
      'scheduleSystem': 'الجدول والنظام',
      'appSupport': 'دعم التطبيق',
      'soundVibrate': 'صوت واهتزاز',
      'soundOnly': 'صوت فقط',
      'vibrateOnly': 'اهتزاز فقط',
      'silent': 'صامت',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'reset': 'إعادة تعيين',
      'gotIt': 'حسنًا',
      'comingSoon': 'قريبًا',
      'saveReminder': 'حفظ التذكير',
      'selectTime': 'اختيار الوقت',
      'healthReminderMessage': 'رسالة التذكير الصحي',
      'resetDefaults': 'استعادة الافتراضي',
      'addReminder': 'إضافة تذكير',
      'deleteReminder': 'حذف التذكير؟',
      'resetSchedule': 'إعادة تعيين الجدول؟',
      'noCustomRemindersYet': 'لا توجد تذكيرات مخصصة بعد',
      'customReminderTimesHelp':
          'قم بتفعيل أو تعطيل أو تعديل كل وقت تذكير بشرب الماء.',
      'customHydrationReminder': 'تذكير مخصص بشرب الماء',
      'disabled': 'معطل',
      'addCustomReminderHint':
          'اضغط على زر + لإضافة وقت تذكير خاص بك لشرب الماء.',
      'resetScheduleMessage':
          'سيؤدي هذا إلى استبدال أوقات التذكير المخصصة الحالية بجدول StayHydro الافتراضي.',
      'deleteReminderMessage': 'سيتم حذف وقت التذكير المخصص هذا نهائياً.',
      'maximumReached': 'تم الوصول إلى الحد الأقصى',
      'maxCustomReminderMessage': 'يمكنك إنشاء ما يصل إلى 20 وقت تذكير مخصص.',
      'smartHourly': 'ذكي كل ساعة',
      'appearancePersonalization': 'المظهر والتخصيص',
      'language': 'Language',
      'moreLanguagesComingSoon': 'المزيد من اللغات قريبًا',
      'currentlyActive': 'نشط حاليًا',
      'fullTranslationsBeforeRelease':
          'ستتم إضافة الترجمات الكاملة قبل الإصدار.',
      'pauseHydrationReminders': 'إيقاف تذكيرات شرب الماء مؤقتًا',
      'selectDailyGoal': 'اختيار الهدف اليومي',
      'dailyGoalUpdated': 'تم تحديث الهدف اليومي إلى',
      'ml': 'مل',
    },

    // ===========
    // [HINDI]
    // ===========
    'Hindi': {
      'settings': 'सेटिंग्स',
      'darkTheme': 'डार्क थीम',
      'appLanguage': 'ऐप भाषा',
      'dailyGoal': 'दैनिक लक्ष्य',
      'notificationSounds': 'नोटिफिकेशन और ध्वनियाँ',
      'fastingMode': 'उपवास मोड',
      'reminderMode': 'रिमाइंडर मोड',
      'reminderSound': 'रिमाइंडर ध्वनि',
      'reminderSystem': 'रिमाइंडर सिस्टम',
      'customSchedule': 'कस्टम शेड्यूल',
      'specialReminders': 'विशेष रिमाइंडर',
      'scheduleSystem': 'शेड्यूल और सिस्टम',
      'appSupport': 'ऐप सहायता',
      'soundVibrate': 'ध्वनि + कंपन',
      'soundOnly': 'केवल ध्वनि',
      'vibrateOnly': 'केवल कंपन',
      'silent': 'मौन',
      'save': 'सेव करें',
      'cancel': 'रद्द करें',
      'delete': 'हटाएँ',
      'reset': 'रीसेट',
      'gotIt': 'ठीक है',
      'comingSoon': 'जल्द आ रहा है',
      'saveReminder': 'रिमाइंडर सेव करें',
      'selectTime': 'समय चुनें',
      'healthReminderMessage': 'स्वास्थ्य रिमाइंडर संदेश',
      'resetDefaults': 'डिफ़ॉल्ट रीसेट करें',
      'addReminder': 'रिमाइंडर जोड़ें',
      'deleteReminder': 'रिमाइंडर हटाएँ?',
      'resetSchedule': 'शेड्यूल रीसेट करें?',
      'noCustomRemindersYet': 'अभी कोई कस्टम रिमाइंडर नहीं',
      'customReminderTimesHelp':
          'प्रत्येक हाइड्रेशन रिमाइंडर समय को सक्षम, अक्षम या संपादित करें।',
      'customHydrationReminder': 'कस्टम हाइड्रेशन रिमाइंडर',
      'disabled': 'अक्षम',
      'addCustomReminderHint':
          'अपना हाइड्रेशन रिमाइंडर समय जोड़ने के लिए ऊपर + बटन दबाएँ।',
      'resetScheduleMessage':
          'यह आपके वर्तमान कस्टम रिमाइंडर समय को डिफ़ॉल्ट StayHydro शेड्यूल से बदल देगा।',
      'deleteReminderMessage':
          'यह कस्टम रिमाइंडर समय स्थायी रूप से हटा दिया जाएगा।',
      'maximumReached': 'अधिकतम सीमा पूरी हुई',
      'maxCustomReminderMessage':
          'आप अधिकतम 20 कस्टम रिमाइंडर समय बना सकते हैं।',
      'smartHourly': 'स्मार्ट प्रति घंटा',
      'appearancePersonalization': 'दिखावट और निजीकरण',
      'language': 'Language',
      'moreLanguagesComingSoon': 'और भाषाएँ जल्द आएँगी',
      'currentlyActive': 'वर्तमान में सक्रिय',
      'fullTranslationsBeforeRelease':
          'पूरे अनुवाद रिलीज़ से पहले जोड़े जाएँगे.',
      'pauseHydrationReminders': 'हाइड्रेशन रिमाइंडर रोकें',
      'selectDailyGoal': 'दैनिक लक्ष्य चुनें',
      'dailyGoalUpdated': 'दैनिक लक्ष्य अपडेट किया गया',
      'ml': 'मि.ली.',
    },

    // =============
    // [INDONESIAN]
    // =============
    'Indonesian': {
      'settings': 'Pengaturan',
      'darkTheme': 'Tema gelap',
      'appLanguage': 'Bahasa aplikasi',
      'dailyGoal': 'Target harian',
      'notificationSounds': 'Notifikasi & suara',
      'fastingMode': 'Mode puasa',
      'reminderMode': 'Mode pengingat',
      'reminderSound': 'Suara pengingat',
      'reminderSystem': 'Sistem pengingat',
      'customSchedule': 'Jadwal khusus',
      'specialReminders': 'Pengingat khusus',
      'scheduleSystem': 'Jadwal & sistem',
      'appSupport': 'Dukungan aplikasi',
      'soundVibrate': 'Suara + getar',
      'soundOnly': 'Hanya suara',
      'vibrateOnly': 'Hanya getar',
      'silent': 'Senyap',
      'save': 'Simpan',
      'cancel': 'Batal',
      'delete': 'Hapus',
      'reset': 'Reset',
      'gotIt': 'Mengerti',
      'comingSoon': 'Segera hadir',
      'saveReminder': 'Simpan pengingat',
      'selectTime': 'Pilih waktu',
      'healthReminderMessage': 'Pesan pengingat kesehatan',
      'resetDefaults': 'Reset default',
      'addReminder': 'Tambah pengingat',
      'deleteReminder': 'Hapus pengingat?',
      'resetSchedule': 'Reset jadwal?',
      'noCustomRemindersYet': 'Belum ada pengingat khusus',
      'customReminderTimesHelp':
          'Aktifkan, nonaktifkan, atau ubah setiap waktu pengingat hidrasi.',
      'customHydrationReminder': 'Pengingat hidrasi khusus',
      'disabled': 'Dinonaktifkan',
      'addCustomReminderHint':
          'Ketuk tombol + di atas untuk menambahkan waktu pengingat hidrasi Anda sendiri.',
      'resetScheduleMessage':
          'Ini akan mengganti waktu pengingat khusus Anda saat ini dengan jadwal bawaan StayHydro.',
      'deleteReminderMessage':
          'Waktu pengingat khusus ini akan dihapus secara permanen.',
      'maximumReached': 'Batas maksimum tercapai',
      'maxCustomReminderMessage':
          'Anda dapat membuat hingga 20 waktu pengingat khusus.',
      'smartHourly': 'Pintar per jam',
      'appearancePersonalization': 'Tampilan & personalisasi',
      'language': 'Language',
      'moreLanguagesComingSoon': 'Bahasa lainnya segera hadir',
      'currentlyActive': 'Sedang aktif',
      'fullTranslationsBeforeRelease':
          'Terjemahan lengkap akan ditambahkan sebelum rilis.',
      'pauseHydrationReminders': 'Jeda pengingat hidrasi',
      'selectDailyGoal': 'Pilih target harian',
      'dailyGoalUpdated': 'Target harian diperbarui menjadi',
      'ml': 'ml',
    },
  };

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

  // ==========================================
// [SETTINGS: REMAINING INFO MESSAGES]
// ==========================================

  static const String dailyGoalUpdated = 'Daily goal updated to';

  static const String reminderSlotsConfigured = 'reminder slots configured';

  static const String onlyAvailableInCustomSchedule =
      'Only available in Custom Schedule';

  static const String reminderSystemInfoMessage =
      'Smart Hourly uses automatic hourly reminders and follows your Sleep Hours.\n\n'
      'Custom Schedule lets you choose your own hydration reminder times.\n\n'
      'Special Reminders stay separate and work with both systems.';

  static const String customScheduleInfoMessage =
      'Custom Schedule lets you choose your own hydration reminder times.\n\n'
      'It follows your selected reminder sound and mode.\n\n'
      'Sleep Hours do not apply here because you control the exact reminder times.\n\n'
      'Fasting Mode will still pause hydration reminders.';

  static const String specialRemindersInfoMessage =
      '• Special reminders remain active even during Fasting Mode.\n\n'
      '• Each special reminder uses the sound and mode active at the time of saving.\n\n'
      '• To change a reminder\'s sound or mode, select the desired sound/mode and save the reminder again.\n\n'
      '• Special reminders also restore automatically after phone restart.';

  static const String sleepHoursInfoMessage =
      'Sleep Hours only apply to Smart Hourly reminders.\n\n'
      'Custom Schedule uses the exact times you choose, so Sleep Hours are not applied there.';

  static const String batteryOptimizationInfoMessage =
      'For reliable reminders, set StayHydro to Not Optimized in battery settings. This helps Android avoid delaying or stopping reminders.';

  static const String autoStartBackgroundInfoMessage =
      'Allow Auto Start and Background Activity for StayHydro, especially on Oppo, Realme, Vivo and Xiaomi phones. This helps reminders continue after restart and while the app is closed.';

  static const String helpFeedbackInfoMessage =
      'Help & Feedback will be added before release.\n\n'
      'For now, this section is reserved for support email, bug reports and feature suggestions.';

  static const String privacyTermsInfoMessage =
      'Privacy Policy and Terms links will be added before Play Store release.';

  static const String aboutStayHydroInfoMessage =
      'StayHydro helps you build a healthy hydration routine with smart reminders, custom schedules and special reminders.\n\n'
      'Version: 1.0.0\n'
      'Developer: SLNova';

  static const String fullTranslationsBeforeRelease =
      'Full translations will be added before release.';

  static const String currentlyActive = 'Currently active';

  static const String languageTranslationComingSoon =
      'translation will be added before release.\n\nFor now, English remains active.';
}
