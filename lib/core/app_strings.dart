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
      'sleepStartHour': 'Sleep Start Hour',
      'sleepEndHour': 'Sleep End Hour',
      'sleepHours': 'Sleep Hours',
      'onlyAppliesSmartHourly': 'Only applies to Smart Hourly',
      'batteryOptimization': 'Battery Optimization',
      'batteryOptimizationSubtitle': 'Required for reliable reminders',
      'autoStartBackground': 'Auto Start & Background',
      'autoStartBackgroundSubtitle':
          'Enable auto start and background activity',
      'reminderReliabilityTips': 'Reminder Reliability Tips',
      'disableBatteryOptimization': 'Disable Battery Optimization',
      'disableBatteryOptimizationSubtitle':
          'Set StayHydro to Not Optimized for reliable reminders.',
      'enableAutoStart': 'Enable Auto Start',
      'enableAutoStartSubtitle':
          'Recommended for Oppo, Xiaomi, Vivo & Realme devices.',
      'allowBackgroundActivity': 'Allow Background Activity',
      'allowBackgroundActivitySubtitle':
          'Helps reminders continue while the app is closed.',
      'allowNotificationsExactAlarms': 'Allow Notifications & Exact Alarms',
      'allowNotificationsExactAlarmsSubtitle':
          'Required for accurate reminder delivery.',
      'restartReliability': 'Restart Reliability',
      'restartReliabilitySubtitle':
          'StayHydro restores reminders automatically after reboot.',
      'helpFeedback': 'Help & Feedback',
      'privacyTerms': 'Privacy & Terms',
      'aboutStayHydro': 'About StayHydro',
      'reminderSystemInfoMessage':
          'Smart Hourly uses automatic hourly reminders and follows your Sleep Hours.\n\n'
              'Custom Schedule lets you choose your own hydration reminder times.\n\n'
              'Special Reminders stay separate and work with both systems.',
      'customScheduleInfoMessage':
          'Custom Schedule lets you choose your own hydration reminder times.\n\n'
              'It follows your selected reminder sound and mode.\n\n'
              'Sleep Hours do not apply here because you control the exact reminder times.\n\n'
              'Fasting Mode will still pause hydration reminders.',
      'specialRemindersInfoMessage':
          '• Special reminders remain active even during Fasting Mode.\n\n'
              '• Each special reminder uses the sound and mode active at the time of saving.\n\n'
              '• To change a reminder\'s sound or mode, select the desired sound/mode and save the reminder again.\n\n'
              '• Special reminders also restore automatically after phone restart.',
      'sleepHoursInfoMessage':
          'Sleep Hours only apply to Smart Hourly reminders.\n\n'
              'Custom Schedule uses the exact times you choose, so Sleep Hours are not applied there.',
      'batteryOptimizationInfoMessage':
          'For reliable reminders, set StayHydro to Not Optimized in battery settings. This helps Android avoid delaying or stopping reminders.',
      'autoStartBackgroundInfoMessage':
          'Allow Auto Start and Background Activity for StayHydro, especially on Oppo, Realme, Vivo and Xiaomi phones. This helps reminders continue after restart and while the app is closed.',
      'helpFeedbackInfoMessage': 'Help & Feedback will be added before release.\n\n'
          'For now, this section is reserved for support email, bug reports and feature suggestions.',
      'privacyTermsInfoMessage':
          'Privacy Policy and Terms links will be added before Play Store release.',
      'aboutStayHydroInfoMessage':
          'StayHydro helps you build a healthy hydration routine with smart reminders, custom schedules and special reminders.\n\n'
              'Version: 1.0.0\n'
              'Developer: Slnova',
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
      'sleepStartHour': 'Hora de inicio del sueño',
      'sleepEndHour': 'Hora de fin del sueño',
      'sleepHours': 'Horas de sueño',
      'onlyAppliesSmartHourly': 'Solo se aplica a Smart Hourly',
      'batteryOptimization': 'Optimización de batería',
      'batteryOptimizationSubtitle': 'Necesario para recordatorios fiables',
      'autoStartBackground': 'Inicio automático y segundo plano',
      'autoStartBackgroundSubtitle':
          'Activa el inicio automático y la actividad en segundo plano',
      'reminderReliabilityTips': 'Consejos de fiabilidad',
      'disableBatteryOptimization': 'Desactivar optimización de batería',
      'disableBatteryOptimizationSubtitle':
          'Configura StayHydro como No optimizado para recordatorios fiables.',
      'enableAutoStart': 'Activar inicio automático',
      'enableAutoStartSubtitle':
          'Recomendado para dispositivos Oppo, Xiaomi, Vivo y Realme.',
      'allowBackgroundActivity': 'Permitir actividad en segundo plano',
      'allowBackgroundActivitySubtitle':
          'Ayuda a que los recordatorios continúen cuando la app esté cerrada.',
      'allowNotificationsExactAlarms':
          'Permitir notificaciones y alarmas exactas',
      'allowNotificationsExactAlarmsSubtitle':
          'Necesario para una entrega precisa de recordatorios.',
      'restartReliability': 'Fiabilidad tras reinicio',
      'restartReliabilitySubtitle':
          'StayHydro restaura automáticamente los recordatorios después de reiniciar.',
      'helpFeedback': 'Ayuda y comentarios',
      'privacyTerms': 'Privacidad y términos',
      'aboutStayHydro': 'Acerca de StayHydro',
      'reminderSystemInfoMessage':
          'Smart Hourly usa recordatorios automáticos cada hora y sigue tus horas de sueño.\n\n'
              'Horario personalizado te permite elegir tus propios horarios de recordatorio de hidratación.\n\n'
              'Los recordatorios especiales permanecen separados y funcionan con ambos sistemas.',
      'customScheduleInfoMessage':
          'Horario personalizado te permite elegir tus propios horarios de recordatorio de hidratación.\n\n'
              'Usa el sonido y el modo de recordatorio seleccionados.\n\n'
              'Las horas de sueño no se aplican aquí porque tú controlas los horarios exactos.\n\n'
              'El modo de ayuno seguirá pausando los recordatorios de hidratación.',
      'specialRemindersInfoMessage':
          '• Los recordatorios especiales permanecen activos incluso durante el modo de ayuno.\n\n'
              '• Cada recordatorio especial usa el sonido y el modo activos en el momento de guardarlo.\n\n'
              '• Para cambiar el sonido o modo, selecciona el nuevo sonido/modo y guarda el recordatorio otra vez.\n\n'
              '• Los recordatorios especiales también se restauran automáticamente después de reiniciar el teléfono.',
      'sleepHoursInfoMessage':
          'Las horas de sueño solo se aplican a Smart Hourly.\n\n'
              'Horario personalizado usa los horarios exactos que eliges, por eso las horas de sueño no se aplican allí.',
      'batteryOptimizationInfoMessage':
          'Para recordatorios fiables, configura StayHydro como No optimizado en los ajustes de batería. Esto ayuda a Android a no retrasar ni detener los recordatorios.',
      'autoStartBackgroundInfoMessage':
          'Permite el inicio automático y la actividad en segundo plano para StayHydro, especialmente en teléfonos Oppo, Realme, Vivo y Xiaomi. Esto ayuda a que los recordatorios continúen después de reiniciar y mientras la app está cerrada.',
      'helpFeedbackInfoMessage':
          'Ayuda y comentarios se añadirá antes del lanzamiento.\n\n'
              'Por ahora, esta sección está reservada para correo de soporte, reportes de errores y sugerencias de funciones.',
      'privacyTermsInfoMessage':
          'Los enlaces de Política de privacidad y Términos se añadirán antes del lanzamiento en Play Store.',
      'aboutStayHydroInfoMessage':
          'StayHydro te ayuda a crear una rutina saludable de hidratación con recordatorios inteligentes, horarios personalizados y recordatorios especiales.\n\n'
              'Versión: 1.0.0\n'
              'Desarrollador: Slnova',
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
      'sleepStartHour': 'وقت بداية النوم',
      'sleepEndHour': 'وقت نهاية النوم',
      'sleepHours': 'ساعات النوم',
      'onlyAppliesSmartHourly': 'ينطبق فقط على التذكير الذكي كل ساعة',
      'batteryOptimization': 'تحسين البطارية',
      'batteryOptimizationSubtitle': 'مطلوب لتذكيرات موثوقة',
      'autoStartBackground': 'التشغيل التلقائي والخلفية',
      'autoStartBackgroundSubtitle': 'فعّل التشغيل التلقائي والنشاط في الخلفية',
      'reminderReliabilityTips': 'نصائح موثوقية التذكيرات',
      'disableBatteryOptimization': 'تعطيل تحسين البطارية',
      'disableBatteryOptimizationSubtitle':
          'اضبط StayHydro على غير محسّن للحصول على تذكيرات موثوقة.',
      'enableAutoStart': 'تفعيل التشغيل التلقائي',
      'enableAutoStartSubtitle':
          'موصى به لأجهزة Oppo و Xiaomi و Vivo و Realme.',
      'allowBackgroundActivity': 'السماح بالنشاط في الخلفية',
      'allowBackgroundActivitySubtitle':
          'يساعد التذكيرات على الاستمرار عند إغلاق التطبيق.',
      'allowNotificationsExactAlarms': 'السماح بالإشعارات والتنبيهات الدقيقة',
      'allowNotificationsExactAlarmsSubtitle': 'مطلوب لوصول التذكيرات بدقة.',
      'restartReliability': 'الموثوقية بعد إعادة التشغيل',
      'restartReliabilitySubtitle':
          'يقوم StayHydro باستعادة التذكيرات تلقائيًا بعد إعادة التشغيل.',
      'helpFeedback': 'المساعدة والملاحظات',
      'privacyTerms': 'الخصوصية والشروط',
      'aboutStayHydro': 'حول StayHydro',
      'reminderSystemInfoMessage':
          'يستخدم Smart Hourly تذكيرات تلقائية كل ساعة ويتبع ساعات النوم الخاصة بك.\n\n'
              'يتيح لك الجدول المخصص اختيار أوقات تذكير شرب الماء بنفسك.\n\n'
              'تظل التذكيرات الخاصة منفصلة وتعمل مع كلا النظامين.',
      'customScheduleInfoMessage':
          'يتيح لك الجدول المخصص اختيار أوقات تذكير شرب الماء بنفسك.\n\n'
              'يتبع الصوت ووضع التذكير اللذين قمت باختيارهما.\n\n'
              'لا تنطبق ساعات النوم هنا لأنك تتحكم في الأوقات الدقيقة.\n\n'
              'سيظل وضع الصيام يوقف تذكيرات شرب الماء مؤقتًا.',
      'specialRemindersInfoMessage':
          '• تظل التذكيرات الخاصة نشطة حتى أثناء وضع الصيام.\n\n'
              '• يستخدم كل تذكير خاص الصوت والوضع النشطين وقت الحفظ.\n\n'
              '• لتغيير الصوت أو الوضع، اختر الصوت/الوضع المطلوب ثم احفظ التذكير مرة أخرى.\n\n'
              '• تتم أيضًا استعادة التذكيرات الخاصة تلقائيًا بعد إعادة تشغيل الهاتف.',
      'sleepHoursInfoMessage': 'تنطبق ساعات النوم فقط على Smart Hourly.\n\n'
          'يستخدم الجدول المخصص الأوقات الدقيقة التي تختارها، لذلك لا تنطبق ساعات النوم هناك.',
      'batteryOptimizationInfoMessage':
          'للحصول على تذكيرات موثوقة، اجعل StayHydro غير محسّن في إعدادات البطارية. يساعد ذلك Android على عدم تأخير التذكيرات أو إيقافها.',
      'autoStartBackgroundInfoMessage':
          'اسمح بالتشغيل التلقائي والنشاط في الخلفية لتطبيق StayHydro، خاصة على هواتف Oppo و Realme و Vivo و Xiaomi. يساعد ذلك التذكيرات على الاستمرار بعد إعادة التشغيل وأثناء إغلاق التطبيق.',
      'helpFeedbackInfoMessage': 'سيتم إضافة المساعدة والملاحظات قبل الإصدار.\n\n'
          'حاليًا، هذا القسم مخصص لبريد الدعم، وتقارير الأخطاء، واقتراحات الميزات.',
      'privacyTermsInfoMessage':
          'سيتم إضافة روابط سياسة الخصوصية والشروط قبل الإصدار على Play Store.',
      'aboutStayHydroInfoMessage':
          'يساعدك StayHydro على بناء روتين صحي لشرب الماء باستخدام تذكيرات ذكية وجداول مخصصة وتذكيرات خاصة.\n\n'
              'الإصدار: 1.0.0\n'
              'المطور: Slnova',
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
      'sleepStartHour': 'नींद शुरू होने का समय',
      'sleepEndHour': 'नींद खत्म होने का समय',
      'sleepHours': 'नींद के घंटे',
      'onlyAppliesSmartHourly': 'केवल स्मार्ट प्रति घंटा पर लागू',
      'batteryOptimization': 'बैटरी ऑप्टिमाइज़ेशन',
      'batteryOptimizationSubtitle': 'भरोसेमंद रिमाइंडर के लिए आवश्यक',
      'autoStartBackground': 'ऑटो स्टार्ट और बैकग्राउंड',
      'autoStartBackgroundSubtitle':
          'ऑटो स्टार्ट और बैकग्राउंड गतिविधि सक्षम करें',
      'reminderReliabilityTips': 'रिमाइंडर भरोसेमंदी सुझाव',
      'disableBatteryOptimization': 'बैटरी ऑप्टिमाइज़ेशन बंद करें',
      'disableBatteryOptimizationSubtitle':
          'विश्वसनीय रिमाइंडर के लिए StayHydro को Not Optimized पर सेट करें।',
      'enableAutoStart': 'ऑटो स्टार्ट सक्षम करें',
      'enableAutoStartSubtitle':
          'Oppo, Xiaomi, Vivo और Realme उपकरणों के लिए अनुशंसित।',
      'allowBackgroundActivity': 'बैकग्राउंड गतिविधि की अनुमति दें',
      'allowBackgroundActivitySubtitle':
          'ऐप बंद होने पर भी रिमाइंडर जारी रखने में मदद करता है।',
      'allowNotificationsExactAlarms':
          'नोटिफिकेशन और सटीक अलार्म की अनुमति दें',
      'allowNotificationsExactAlarmsSubtitle':
          'सटीक रिमाइंडर डिलीवरी के लिए आवश्यक।',
      'restartReliability': 'रीस्टार्ट के बाद विश्वसनीयता',
      'restartReliabilitySubtitle':
          'रीबूट के बाद StayHydro रिमाइंडर स्वतः पुनर्स्थापित करता है।',
      'helpFeedback': 'सहायता और प्रतिक्रिया',
      'privacyTerms': 'गोपनीयता और शर्तें',
      'aboutStayHydro': 'StayHydro के बारे में',
      'reminderSystemInfoMessage':
          'Smart Hourly अपने-आप हर घंटे रिमाइंडर देता है और आपके Sleep Hours का पालन करता है।\n\n'
              'Custom Schedule आपको अपने हाइड्रेशन रिमाइंडर समय खुद चुनने देता है।\n\n'
              'Special Reminders अलग रहते हैं और दोनों सिस्टम के साथ काम करते हैं।',
      'customScheduleInfoMessage':
          'Custom Schedule आपको अपने हाइड्रेशन रिमाइंडर समय खुद चुनने देता है।\n\n'
              'यह आपके चुने हुए रिमाइंडर साउंड और मोड का पालन करता है।\n\n'
              'Sleep Hours यहाँ लागू नहीं होते क्योंकि आप exact reminder times खुद चुनते हैं।\n\n'
              'Fasting Mode फिर भी hydration reminders को pause करेगा।',
      'specialRemindersInfoMessage':
          '• Special reminders Fasting Mode में भी active रहते हैं।\n\n'
              '• हर special reminder save करते समय active sound और mode इस्तेमाल करता है।\n\n'
              '• sound या mode बदलने के लिए, नया sound/mode चुनें और reminder दोबारा save करें।\n\n'
              '• phone restart के बाद special reminders अपने-आप restore हो जाते हैं।',
      'sleepHoursInfoMessage':
          'Sleep Hours केवल Smart Hourly reminders पर लागू होते हैं।\n\n'
              'Custom Schedule आपके चुने हुए exact times इस्तेमाल करता है, इसलिए वहाँ Sleep Hours लागू नहीं होते।',
      'batteryOptimizationInfoMessage':
          'विश्वसनीय reminders के लिए StayHydro को battery settings में Not Optimized पर सेट करें। इससे Android reminders को delay या stop करने से बचता है।',
      'autoStartBackgroundInfoMessage':
          'StayHydro के लिए Auto Start और Background Activity allow करें, खासकर Oppo, Realme, Vivo और Xiaomi phones पर। इससे restart के बाद और app बंद रहने पर भी reminders चलते रहते हैं।',
      'helpFeedbackInfoMessage': 'Help & Feedback release से पहले जोड़ा जाएगा।\n\n'
          'अभी यह section support email, bug reports और feature suggestions के लिए reserved है।',
      'privacyTermsInfoMessage':
          'Privacy Policy और Terms links Play Store release से पहले जोड़े जाएँगे।',
      'aboutStayHydroInfoMessage':
          'StayHydro smart reminders, custom schedules और special reminders के साथ healthy hydration routine बनाने में मदद करता है।\n\n'
              'Version: 1.0.0\n'
              'Developer: Slnova',
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
      'sleepStartHour': 'Jam mulai tidur',
      'sleepEndHour': 'Jam selesai tidur',
      'sleepHours': 'Jam tidur',
      'onlyAppliesSmartHourly': 'Hanya berlaku untuk Smart Hourly',
      'batteryOptimization': 'Optimasi baterai',
      'batteryOptimizationSubtitle': 'Diperlukan untuk pengingat yang andal',
      'autoStartBackground': 'Auto start & latar belakang',
      'autoStartBackgroundSubtitle':
          'Aktifkan auto start dan aktivitas latar belakang',
      'reminderReliabilityTips': 'Tips keandalan pengingat',
      'disableBatteryOptimization': 'Nonaktifkan optimasi baterai',
      'disableBatteryOptimizationSubtitle':
          'Atur StayHydro ke Tidak Dioptimalkan untuk pengingat yang andal.',
      'enableAutoStart': 'Aktifkan auto start',
      'enableAutoStartSubtitle':
          'Direkomendasikan untuk perangkat Oppo, Xiaomi, Vivo & Realme.',
      'allowBackgroundActivity': 'Izinkan aktivitas latar belakang',
      'allowBackgroundActivitySubtitle':
          'Membantu pengingat tetap berjalan saat aplikasi ditutup.',
      'allowNotificationsExactAlarms': 'Izinkan notifikasi & alarm tepat waktu',
      'allowNotificationsExactAlarmsSubtitle':
          'Diperlukan untuk pengiriman pengingat yang akurat.',
      'restartReliability': 'Keandalan setelah restart',
      'restartReliabilitySubtitle':
          'StayHydro memulihkan pengingat secara otomatis setelah perangkat dinyalakan ulang.',
      'helpFeedback': 'Bantuan & masukan',
      'privacyTerms': 'Privasi & ketentuan',
      'aboutStayHydro': 'Tentang StayHydro',
      'reminderSystemInfoMessage':
          'Smart Hourly menggunakan pengingat otomatis setiap jam dan mengikuti Jam Tidur Anda.\n\n'
              'Jadwal khusus memungkinkan Anda memilih waktu pengingat hidrasi sendiri.\n\n'
              'Pengingat khusus tetap terpisah dan bekerja dengan kedua sistem.',
      'customScheduleInfoMessage':
          'Jadwal khusus memungkinkan Anda memilih waktu pengingat hidrasi sendiri.\n\n'
              'Ini mengikuti suara dan mode pengingat yang Anda pilih.\n\n'
              'Jam Tidur tidak berlaku di sini karena Anda mengatur waktu pengingat secara tepat.\n\n'
              'Mode puasa tetap akan menjeda pengingat hidrasi.',
      'specialRemindersInfoMessage':
          '• Pengingat khusus tetap aktif bahkan saat Mode puasa.\n\n'
              '• Setiap pengingat khusus menggunakan suara dan mode yang aktif saat disimpan.\n\n'
              '• Untuk mengubah suara atau mode, pilih suara/mode yang diinginkan lalu simpan pengingat lagi.\n\n'
              '• Pengingat khusus juga dipulihkan otomatis setelah ponsel dinyalakan ulang.',
      'sleepHoursInfoMessage': 'Jam Tidur hanya berlaku untuk Smart Hourly.\n\n'
          'Jadwal khusus menggunakan waktu tepat yang Anda pilih, jadi Jam Tidur tidak diterapkan di sana.',
      'batteryOptimizationInfoMessage':
          'Untuk pengingat yang andal, atur StayHydro menjadi Tidak Dioptimalkan di pengaturan baterai. Ini membantu Android agar tidak menunda atau menghentikan pengingat.',
      'autoStartBackgroundInfoMessage':
          'Izinkan Auto Start dan Aktivitas Latar Belakang untuk StayHydro, terutama pada ponsel Oppo, Realme, Vivo, dan Xiaomi. Ini membantu pengingat tetap berjalan setelah restart dan saat aplikasi ditutup.',
      'helpFeedbackInfoMessage':
          'Bantuan & masukan akan ditambahkan sebelum rilis.\n\n'
              'Untuk saat ini, bagian ini disiapkan untuk email dukungan, laporan bug, dan saran fitur.',
      'privacyTermsInfoMessage':
          'Tautan Kebijakan Privasi dan Ketentuan akan ditambahkan sebelum rilis Play Store.',
      'aboutStayHydroInfoMessage':
          'StayHydro membantu Anda membangun rutinitas hidrasi sehat dengan pengingat pintar, jadwal khusus, dan pengingat khusus.\n\n'
              'Versi: 1.0.0\n'
              'Pengembang: Slnova',
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
  static const String aboutStayHydroSubtitle = 'Version 1.0.0 • Slnova';

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
      'Developer: Slnova';

  static const String fullTranslationsBeforeRelease =
      'Full translations will be added before release.';

  static const String currentlyActive = 'Currently active';

  static const String languageTranslationComingSoon =
      'translation will be added before release.\n\nFor now, English remains active.';
}
