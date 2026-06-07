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
    return _localized[activeLanguage]?[key] ??
        _localized['English']?[key] ??
        key;
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
      'helpFeedbackInfoMessage': 'Need help or want to share feedback?\n\n'
          'StayHydro Support\n'
          'hello.stayhydro@gmail.com\n\n'
          'Slnova Support\n'
          'hello.slnova@gmail.com\n\n'
          'We welcome bug reports, feature suggestions and general feedback.',
      'aboutStayHydroInfoMessage':
          'StayHydro helps you build a healthy hydration routine with smart reminders, custom schedules and special reminders.\n\n'
              'Version: 1.0.0\n'
              'Developer: Slnova',
      'medicineReminder': 'Medicine Reminder',
      'wellnessReminder': 'Wellness Reminder',
      'bedtimeWater': 'Bedtime Water',
      'healthReminder': 'Health Reminder',
      'lockedSoundMode': 'Locked sound & mode',
      'offTapHealthReminder': 'Off • Tap to set health reminder',
      'selectReminderSystem': 'Select Reminder System',
      'smartHourlySubtitle': 'Automatic hourly reminders with sleep hours',
      'customScheduleSubtitle': 'Choose your own reminder times',
      'customReminderTimes': 'Custom Reminder Times',
      'testNotification': 'Test Notification',
      'testNotificationSubtitle': 'Check if reminders are working',
      'testNotificationSent': 'Test notification sent!',
      'helpFeedbackSubtitle': 'Report a problem or suggest a feature',
      'aboutStayHydroSubtitle': 'Version 1.0.0 • Slnova',
      'selectNotificationSound': 'Select Notification Sound',
      'selectReminderMode': 'Select Reminder Mode',
      'digitalBell': 'Digital Chime',
      'softBell': 'Calm Bell',
      'softKnock': 'Soft Knock',
      'waterDrop': 'Water Drop',
      'waterPour': 'Water Pour',
      'reminderSlotsConfigured': 'reminder slots configured',
      'reminderSystemChanged': 'Reminder system set to',
      'sleepHoursUpdated': 'Sleep hours updated and reminders rescheduled',
      'firstLaunchWelcomeTitle': 'Welcome to StayHydro',
      'firstLaunchReliabilityMessage': 'Your daily hydration companion.\n\n'
          'For the most reliable reminders:\n\n'
          '✓ Allow notifications\n'
          '✓ Disable battery optimization\n'
          '✓ Enable auto start/background activity\n\n'
          'You can update these settings anytime from Settings.',
      'getStarted': 'Get Started',
      'dailyHydrationTip': 'Daily Hydration Tip',
      'nextHydrationGoal': 'Next Hydration Goal',
      'paused': 'Paused',
      'add': 'Add',
      'switchIntake': 'Switch Intake',
      'missedEntry': 'Missed Entry',
      'days': 'days',
      'goalCompleted': 'Goal completed! Streak:',
      'goalCompletedMissedEntry': 'Goal completed with missed entry! Streak:',
      'addMissedEntry': 'Add Missed Entry',
      'intakeTime': 'Intake Time',
      'selectAmount': 'Select Amount',
      'addEntry': 'Add Entry',
      'dailyIntakeLimitReached': 'Daily intake limit reached for today.',
      'waterIntake': 'Water Intake',
      'selectIntakeAmount': 'Select Intake Amount',
      'customAmountHint': 'Custom (50–1000 ml)',
      'enterNumber': 'Enter a number',
      'intakeRangeError': 'Between 50 and 1000 (steps of 50)',
      'home': 'Home',
      'history': 'History',
      'weeklyProgress': 'Weekly Progress',
      'average': 'Average',
      'done': 'Done',
      'best': 'Best',
      'todaysLogs': "TODAY'S LOGS",
      'noEntriesToday': 'No entries for today yet',
      'mon': 'Mon',
      'tue': 'Tue',
      'wed': 'Wed',
      'thu': 'Thu',
      'fri': 'Fri',
      'sat': 'Sat',
      'sun': 'Sun',
      'water': 'Water',
      'medicineReminderSubtitle': 'Off • Tap to set medicine reminder',
      'wellnessReminderSubtitle': 'Off • Tap to set wellness reminder',
      'bedtimeReminderSubtitle': 'Off • Tap to set bedtime water reminder',
      'reminderMessage': 'Reminder message',
      'usesCurrentSoundMode': 'Uses the current sound and mode when saved.',
      'copyStayHydroEmail': 'Copy StayHydro email',
      'copySlnovaEmail': 'Copy Slnova email',
      'emailCopied': 'Email copied to clipboard',
      'onlyAvailableInCustomSchedule': 'Only available in Custom Schedule',
      'privacyPolicy': 'Privacy Policy',
      'privacyPolicySubtitle': 'How StayHydro handles your data',
      'privacyPolicyInfoMessage': 'Privacy Policy\n\n'
          'StayHydro respects your privacy.\n\n'
          '• Your hydration logs, reminder settings and preferences are stored locally on your device.\n\n'
          '• StayHydro does not require an account and does not collect your name, phone number or email address.\n\n'
          '• Notifications are used only to deliver hydration reminders and special reminders that you configure.\n\n'
          '• StayHydro may use Google Firebase services for analytics, crash reporting and app reliability improvements.\n\n'
          '• We do not sell your personal information.\n\n'
          '• Future updates may introduce additional features such as advertising. If this happens, this policy will be updated before release.\n\n'
          'For support:\n'
          'hello.stayhydro@gmail.com\n'
          'hello.slnova@gmail.com',
      'termsConditions': 'Terms & Conditions',
      'termsConditionsSubtitle': 'Important usage information',
      'termsConditionsInfoMessage': 'Terms & Conditions\n\n'
          'By using StayHydro, you agree to use the app at your own discretion.\n\n'
          '• StayHydro provides hydration reminders for convenience and habit building.\n\n'
          '• The app does not provide medical advice, diagnosis or treatment.\n\n'
          '• Users are responsible for deciding how much water is appropriate for their individual health needs.\n\n'
          '• StayHydro is provided "as is" without warranties of any kind.\n\n'
          '• The developers are not responsible for any loss, damage or health issues resulting from the use of the app.\n\n'
          '• Features may change or improve in future updates.',
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
      'copyStayHydroEmail': 'Copiar email de StayHydro',
      'copySlnovaEmail': 'Copiar email de Slnova',
      'emailCopied': 'Email copiado al portapapeles',
      'helpFeedbackInfoMessage':
          '¿Necesitas ayuda o quieres compartir comentarios?\n\n'
              'Soporte de StayHydro\n'
              'hello.stayhydro@gmail.com\n\n'
              'Soporte de Slnova\n'
              'hello.slnova@gmail.com\n\n'
              'Agradecemos reportes de errores, sugerencias y comentarios generales.',
      'aboutStayHydroInfoMessage':
          'StayHydro te ayuda a crear una rutina saludable de hidratación con recordatorios inteligentes, horarios personalizados y recordatorios especiales.\n\n'
              'Versión: 1.0.0\n'
              'Desarrollador: Slnova',
      'medicineReminder': 'Recordatorio de medicina',
      'wellnessReminder': 'Recordatorio de bienestar',
      'bedtimeWater': 'Agua antes de dormir',
      'healthReminder': 'Recordatorio de salud',
      'lockedSoundMode': 'Sonido y modo bloqueados',
      'offTapHealthReminder': 'Desactivado • Toca para configurar',
      'selectReminderSystem': 'Seleccionar sistema de recordatorios',
      'smartHourlySubtitle':
          'Recordatorios automáticos cada hora con horas de sueño',
      'customScheduleSubtitle': 'Elige tus propios horarios',
      'customReminderTimes': 'Horarios personalizados',
      'testNotification': 'Notificación de prueba',
      'testNotificationSubtitle': 'Comprueba si los recordatorios funcionan',
      'testNotificationSent': '¡Notificación de prueba enviada!',
      'helpFeedbackSubtitle': 'Reporta un problema o sugiere una función',
      'aboutStayHydroSubtitle': 'Versión 1.0.0 • Slnova',
      'selectNotificationSound': 'Seleccionar sonido',
      'selectReminderMode': 'Seleccionar modo de recordatorio',
      'digitalBell': 'Campana digital',
      'softBell': 'Campana suave',
      'softKnock': 'Golpe suave',
      'waterDrop': 'Gota de agua',
      'waterPour': 'Vertido de agua',
      'reminderSlotsConfigured': 'horarios configurados',
      'firstLaunchWelcomeTitle': 'Bienvenido a StayHydro',
      'firstLaunchReliabilityMessage': 'Para recordatorios fiables:\n\n'
          '✓ Permite las notificaciones\n'
          '✓ Desactiva la optimización de batería\n'
          '✓ Activa el inicio automático/actividad en segundo plano',
      'getStarted': 'Comenzar',
      'dailyHydrationTip': 'Consejo diario de hidratación',
      'nextHydrationGoal': 'Próximo objetivo de hidratación',
      'paused': 'Pausado',
      'add': 'Añadir',
      'switchIntake': 'Cambiar cantidad',
      'missedEntry': 'Entrada omitida',
      'days': 'días',
      'goalCompleted': '¡Objetivo completado! Racha:',
      'goalCompletedMissedEntry':
          '¡Objetivo completado con entrada omitida! Racha:',
      'addMissedEntry': 'Añadir entrada omitida',
      'intakeTime': 'Hora de consumo',
      'selectAmount': 'Seleccionar cantidad',
      'addEntry': 'Añadir entrada',
      'dailyIntakeLimitReached':
          'Has alcanzado el límite diario de agua por hoy.',
      'reminderSystemChanged': 'Sistema de recordatorios cambiado a',
      'customScheduleMode': 'Horario personalizado',
      'waterIntake': 'Consumo de agua',
      'selectIntakeAmount': 'Seleccionar cantidad',
      'customAmountHint': 'Personalizado (50–1000 ml)',
      'enterNumber': 'Introduce un número',
      'intakeRangeError': 'Entre 50 y 1000 (pasos de 50)',
      'home': 'Inicio',
      'history': 'Historial',
      'weeklyProgress': 'Progreso semanal',
      'average': 'Promedio',
      'done': 'Completado',
      'best': 'Mejor',
      'todaysLogs': 'REGISTROS DE HOY',
      'noEntriesToday': 'Aún no hay entradas hoy',
      'mon': 'Lun',
      'tue': 'Mar',
      'wed': 'Mié',
      'thu': 'Jue',
      'fri': 'Vie',
      'sat': 'Sáb',
      'sun': 'Dom',
      'water': 'Agua',
      'medicineReminderSubtitle': 'Desactivado • Toca para configurar medicina',
      'wellnessReminderSubtitle':
          'Desactivado • Toca para configurar bienestar',
      'bedtimeReminderSubtitle':
          'Desactivado • Toca para configurar agua antes de dormir',
      'reminderMessage': 'Mensaje del recordatorio',
      'usesCurrentSoundMode': 'Usa el sonido y modo actuales al guardar.',
      'onlyAvailableInCustomSchedule':
          'Disponible solo en Horario personalizado',
      'privacyPolicy': 'Política de privacidad',
      'privacyPolicySubtitle': 'Cómo StayHydro maneja tus datos',
      'termsConditions': 'Términos y condiciones',
      'termsConditionsSubtitle': 'Información importante de uso',
      'sleepHoursUpdated':
          'Horas de sueño actualizadas y recordatorios reprogramados',
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
      'copyStayHydroEmail': 'نسخ بريد StayHydro',
      'copySlnovaEmail': 'نسخ بريد Slnova',
      'emailCopied': 'تم نسخ البريد الإلكتروني',
      'helpFeedbackInfoMessage':
          'هل تحتاج إلى مساعدة أو تريد إرسال ملاحظات؟\n\n'
              'دعم StayHydro\n'
              'hello.stayhydro@gmail.com\n\n'
              'دعم Slnova\n'
              'hello.slnova@gmail.com\n\n'
              'نرحب بتقارير الأخطاء والاقتراحات والملاحظات العامة.',
      'aboutStayHydroInfoMessage':
          'يساعدك StayHydro على بناء روتين صحي لشرب الماء باستخدام تذكيرات ذكية وجداول مخصصة وتذكيرات خاصة.\n\n'
              'الإصدار: 1.0.0\n'
              'المطور: Slnova',
      'medicineReminder': 'تذكير الدواء',
      'wellnessReminder': 'تذكير العافية',
      'bedtimeWater': 'ماء قبل النوم',
      'healthReminder': 'تذكير صحي',
      'lockedSoundMode': 'الصوت والوضع محفوظان',
      'offTapHealthReminder': 'متوقف • اضغط للإعداد',
      'selectReminderSystem': 'اختيار نظام التذكيرات',
      'smartHourlySubtitle': 'تذكيرات تلقائية كل ساعة مع ساعات النوم',
      'customScheduleSubtitle': 'اختر أوقات التذكير بنفسك',
      'customReminderTimes': 'أوقات التذكير المخصصة',
      'testNotification': 'إشعار تجريبي',
      'testNotificationSubtitle': 'تحقق من عمل التذكيرات',
      'testNotificationSent': 'تم إرسال الإشعار التجريبي!',
      'helpFeedbackSubtitle': 'أبلغ عن مشكلة أو اقترح ميزة',
      'aboutStayHydroSubtitle': 'الإصدار 1.0.0 • Slnova',
      'selectNotificationSound': 'اختيار صوت الإشعار',
      'selectReminderMode': 'اختيار وضع التذكير',
      'digitalBell': 'جرس رقمي',
      'softBell': 'جرس هادئ',
      'softKnock': 'طرق خفيف',
      'waterDrop': 'قطرة ماء',
      'waterPour': 'صب الماء',
      'reminderSlotsConfigured': 'أوقات تذكير مضبوطة',
      'firstLaunchWelcomeTitle': 'مرحبًا بك في StayHydro',
      'firstLaunchReliabilityMessage': 'للحصول على تذكيرات موثوقة:\n\n'
          '✓ اسمح بالإشعارات\n'
          '✓ عطّل تحسين البطارية\n'
          '✓ فعّل التشغيل التلقائي/النشاط في الخلفية',
      'getStarted': 'ابدأ',
      'dailyHydrationTip': 'نصيحة الترطيب اليومية',
      'nextHydrationGoal': 'موعد الترطيب التالي',
      'paused': 'متوقف',
      'add': 'أضف',
      'switchIntake': 'تغيير الكمية',
      'missedEntry': 'إدخال فائت',
      'days': 'أيام',
      'goalCompleted': 'تم إكمال الهدف! السلسلة:',
      'goalCompletedMissedEntry': 'تم إكمال الهدف مع إدخال فائت! السلسلة:',
      'addMissedEntry': 'إضافة إدخال فائت',
      'intakeTime': 'وقت الشرب',
      'selectAmount': 'اختر الكمية',
      'addEntry': 'إضافة',
      'dailyIntakeLimitReached': 'تم الوصول إلى حد شرب الماء لهذا اليوم.',
      'reminderSystemChanged': 'تم تغيير نظام التذكيرات إلى',
      'customScheduleMode': 'جدول مخصص',
      'waterIntake': 'كمية الماء',
      'selectIntakeAmount': 'اختر كمية الشرب',
      'customAmountHint': 'مخصص (50–1000 ml)',
      'enterNumber': 'أدخل رقمًا',
      'intakeRangeError': 'بين 50 و1000 (بفواصل 50)',
      'home': 'الرئيسية',
      'history': 'السجل',
      'weeklyProgress': 'التقدم الأسبوعي',
      'average': 'المتوسط',
      'done': 'مكتمل',
      'best': 'الأفضل',
      'todaysLogs': 'سجلات اليوم',
      'noEntriesToday': 'لا توجد إدخالات اليوم بعد',
      'mon': 'الإث',
      'tue': 'الث',
      'wed': 'الأر',
      'thu': 'الخ',
      'fri': 'الج',
      'sat': 'الس',
      'sun': 'الأح',
      'water': 'ماء',
      'medicineReminderSubtitle': 'متوقف • اضغط لضبط تذكير الدواء',
      'wellnessReminderSubtitle': 'متوقف • اضغط لضبط تذكير العافية',
      'bedtimeReminderSubtitle': 'متوقف • اضغط لضبط تذكير ماء قبل النوم',
      'reminderMessage': 'رسالة التذكير',
      'usesCurrentSoundMode': 'يستخدم الصوت والوضع الحاليين عند الحفظ.',
      'onlyAvailableInCustomSchedule': 'متاح فقط في الجدول المخصص',
      'privacyPolicy': 'سياسة الخصوصية',
      'privacyPolicySubtitle': 'كيف يتعامل StayHydro مع بياناتك',
      'termsConditions': 'الشروط والأحكام',
      'termsConditionsSubtitle': 'معلومات مهمة حول الاستخدام',
      'sleepHoursUpdated': 'تم تحديث ساعات النوم وإعادة جدولة التذكيرات',
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
      'copyStayHydroEmail': 'StayHydro ईमेल कॉपी करें',
      'copySlnovaEmail': 'Slnova ईमेल कॉपी करें',
      'emailCopied': 'ईमेल क्लिपबोर्ड पर कॉपी हो गया',
      'helpFeedbackInfoMessage': 'मदद चाहिए या feedback देना चाहते हैं?\n\n'
          'StayHydro Support\n'
          'hello.stayhydro@gmail.com\n\n'
          'Slnova Support\n'
          'hello.slnova@gmail.com\n\n'
          'हम bug reports, feature suggestions और general feedback का स्वागत करते हैं.',
      'aboutStayHydroInfoMessage':
          'StayHydro smart reminders, custom schedules और special reminders के साथ healthy hydration routine बनाने में मदद करता है।\n\n'
              'Version: 1.0.0\n'
              'Developer: Slnova',
      'medicineReminder': 'दवा रिमाइंडर',
      'wellnessReminder': 'वेलनेस रिमाइंडर',
      'bedtimeWater': 'सोने से पहले पानी',
      'healthReminder': 'स्वास्थ्य रिमाइंडर',
      'lockedSoundMode': 'साउंड और मोड लॉक',
      'offTapHealthReminder': 'बंद • सेट करने के लिए टैप करें',
      'selectReminderSystem': 'रिमाइंडर सिस्टम चुनें',
      'smartHourlySubtitle': 'नींद के घंटों के साथ हर घंटे अपने-आप रिमाइंडर',
      'customScheduleSubtitle': 'अपने रिमाइंडर समय खुद चुनें',
      'customReminderTimes': 'कस्टम रिमाइंडर समय',
      'testNotification': 'टेस्ट नोटिफिकेशन',
      'testNotificationSubtitle': 'जाँचें कि रिमाइंडर काम कर रहे हैं',
      'testNotificationSent': 'टेस्ट नोटिफिकेशन भेजा गया!',
      'helpFeedbackSubtitle': 'समस्या बताएँ या फीचर सुझाएँ',
      'aboutStayHydroSubtitle': 'वर्ज़न 1.0.0 • Slnova',
      'selectNotificationSound': 'नोटिफिकेशन साउंड चुनें',
      'selectReminderMode': 'रिमाइंडर मोड चुनें',
      'digitalBell': 'डिजिटल घंटी',
      'softBell': 'मुलायम घंटी',
      'softKnock': 'हल्की दस्तक',
      'waterDrop': 'पानी की बूंद',
      'waterPour': 'पानी डालना',
      'reminderSlotsConfigured': 'रिमाइंडर समय सेट',
      'firstLaunchWelcomeTitle': 'StayHydro में आपका स्वागत है',
      'firstLaunchReliabilityMessage': 'भरोसेमंद रिमाइंडर के लिए:\n\n'
          '✓ नोटिफिकेशन की अनुमति दें\n'
          '✓ बैटरी ऑप्टिमाइज़ेशन बंद करें\n'
          '✓ ऑटो स्टार्ट/बैकग्राउंड एक्टिविटी चालू करें',
      'getStarted': 'शुरू करें',
      'dailyHydrationTip': 'दैनिक हाइड्रेशन टिप',
      'nextHydrationGoal': 'अगला हाइड्रेशन लक्ष्य',
      'paused': 'रुका हुआ',
      'add': 'जोड़ें',
      'switchIntake': 'मात्रा बदलें',
      'missedEntry': 'छूटी हुई एंट्री',
      'days': 'दिन',
      'goalCompleted': 'लक्ष्य पूरा हुआ! स्ट्रीक:',
      'goalCompletedMissedEntry':
          'छूटी हुई एंट्री से लक्ष्य पूरा हुआ! स्ट्रीक:',
      'addMissedEntry': 'छूटी हुई एंट्री जोड़ें',
      'intakeTime': 'पीने का समय',
      'selectAmount': 'मात्रा चुनें',
      'addEntry': 'एंट्री जोड़ें',
      'dailyIntakeLimitReached': 'आज की दैनिक पानी सीमा पूरी हो गई है.',
      'reminderSystemChanged': 'रिमाइंडर सिस्टम बदलकर किया गया',
      'customScheduleMode': 'कस्टम शेड्यूल',
      'waterIntake': 'पानी की मात्रा',
      'selectIntakeAmount': 'पानी की मात्रा चुनें',
      'customAmountHint': 'कस्टम (50–1000 ml)',
      'enterNumber': 'कोई संख्या दर्ज करें',
      'intakeRangeError': '50 से 1000 के बीच (50 के अंतर से)',
      'home': 'होम',
      'history': 'इतिहास',
      'weeklyProgress': 'साप्ताहिक प्रगति',
      'average': 'औसत',
      'done': 'पूरा',
      'best': 'सर्वश्रेष्ठ',
      'todaysLogs': 'आज के लॉग',
      'noEntriesToday': 'आज अभी तक कोई एंट्री नहीं है',
      'mon': 'सोम',
      'tue': 'मंगल',
      'wed': 'बुध',
      'thu': 'गुरु',
      'fri': 'शुक्र',
      'sat': 'शनि',
      'sun': 'रवि',
      'water': 'पानी',
      'medicineReminderSubtitle': 'बंद • दवा रिमाइंडर सेट करने के लिए टैप करें',
      'wellnessReminderSubtitle':
          'बंद • वेलनेस रिमाइंडर सेट करने के लिए टैप करें',
      'bedtimeReminderSubtitle': 'बंद • सोने से पहले पानी रिमाइंडर सेट करें',
      'reminderMessage': 'रिमाइंडर संदेश',
      'usesCurrentSoundMode': 'सेव करते समय मौजूदा ध्वनि और मोड इस्तेमाल होगा.',
      'onlyAvailableInCustomSchedule': 'केवल कस्टम शेड्यूल में उपलब्ध',
      'privacyPolicy': 'गोपनीयता नीति',
      'privacyPolicySubtitle': 'StayHydro आपका डेटा कैसे संभालता है',
      'termsConditions': 'नियम और शर्तें',
      'termsConditionsSubtitle': 'उपयोग से जुड़ी महत्वपूर्ण जानकारी',
      'sleepHoursUpdated':
          'नींद का समय अपडेट हो गया और रिमाइंडर फिर से शेड्यूल हो गए',
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
      'copyStayHydroEmail': 'Salin email StayHydro',
      'copySlnovaEmail': 'Salin email Slnova',
      'emailCopied': 'Email disalin ke clipboard',
      'helpFeedbackInfoMessage': 'Butuh bantuan atau ingin memberi masukan?\n\n'
          'Dukungan StayHydro\n'
          'hello.stayhydro@gmail.com\n\n'
          'Dukungan Slnova\n'
          'hello.slnova@gmail.com\n\n'
          'Kami menerima laporan bug, saran fitur, dan masukan umum.',
      'aboutStayHydroInfoMessage':
          'StayHydro membantu Anda membangun rutinitas hidrasi sehat dengan pengingat pintar, jadwal khusus, dan pengingat khusus.\n\n'
              'Versi: 1.0.0\n'
              'Pengembang: Slnova',
      'medicineReminder': 'Pengingat obat',
      'wellnessReminder': 'Pengingat kesehatan',
      'bedtimeWater': 'Air sebelum tidur',
      'healthReminder': 'Pengingat sehat',
      'lockedSoundMode': 'Suara & mode terkunci',
      'offTapHealthReminder': 'Mati • Ketuk untuk mengatur',
      'selectReminderSystem': 'Pilih sistem pengingat',
      'smartHourlySubtitle': 'Pengingat otomatis tiap jam dengan jam tidur',
      'customScheduleSubtitle': 'Pilih waktu pengingat sendiri',
      'customReminderTimes': 'Waktu pengingat khusus',
      'testNotification': 'Notifikasi uji coba',
      'testNotificationSubtitle': 'Periksa apakah pengingat berfungsi',
      'testNotificationSent': 'Notifikasi uji coba terkirim!',
      'helpFeedbackSubtitle': 'Laporkan masalah atau sarankan fitur',
      'aboutStayHydroSubtitle': 'Versi 1.0.0 • Slnova',
      'selectNotificationSound': 'Pilih suara notifikasi',
      'selectReminderMode': 'Pilih mode pengingat',
      'digitalBell': 'Bel digital',
      'softBell': 'Bel lembut',
      'softKnock': 'Ketukan lembut',
      'waterDrop': 'Tetes air',
      'waterPour': 'Menuang air',
      'reminderSlotsConfigured': 'waktu pengingat diatur',
      'firstLaunchWelcomeTitle': 'Selamat datang di StayHydro',
      'firstLaunchReliabilityMessage': 'Agar pengingat berjalan andal:\n\n'
          '✓ Izinkan notifikasi\n'
          '✓ Nonaktifkan optimasi baterai\n'
          '✓ Aktifkan mulai otomatis/aktivitas latar belakang',
      'getStarted': 'Mulai',
      'dailyHydrationTip': 'Tips hidrasi harian',
      'nextHydrationGoal': 'Target hidrasi berikutnya',
      'paused': 'Dijeda',
      'add': 'Tambah',
      'switchIntake': 'Ganti jumlah',
      'missedEntry': 'Entri terlewat',
      'days': 'hari',
      'goalCompleted': 'Target tercapai! Rangkaian:',
      'goalCompletedMissedEntry':
          'Target tercapai dengan entri terlewat! Rangkaian:',
      'addMissedEntry': 'Tambah entri terlewat',
      'intakeTime': 'Waktu minum',
      'selectAmount': 'Pilih jumlah',
      'addEntry': 'Tambah entri',
      'dailyIntakeLimitReached':
          'Batas asupan air harian untuk hari ini tercapai.',
      'reminderSystemChanged': 'Sistem pengingat diubah ke',
      'customScheduleMode': 'Jadwal Kustom',
      'waterIntake': 'Asupan air',
      'selectIntakeAmount': 'Pilih jumlah minum',
      'customAmountHint': 'Khusus (50–1000 ml)',
      'enterNumber': 'Masukkan angka',
      'intakeRangeError': 'Antara 50 dan 1000 (kelipatan 50)',
      'home': 'Beranda',
      'history': 'Riwayat',
      'weeklyProgress': 'Progres mingguan',
      'average': 'Rata-rata',
      'done': 'Selesai',
      'best': 'Terbaik',
      'todaysLogs': 'LOG HARI INI',
      'noEntriesToday': 'Belum ada entri hari ini',
      'mon': 'Sen',
      'tue': 'Sel',
      'wed': 'Rab',
      'thu': 'Kam',
      'fri': 'Jum',
      'sat': 'Sab',
      'sun': 'Min',
      'water': 'Air',
      'medicineReminderSubtitle':
          'Nonaktif • Ketuk untuk mengatur pengingat obat',
      'wellnessReminderSubtitle':
          'Nonaktif • Ketuk untuk mengatur pengingat kesehatan',
      'bedtimeReminderSubtitle':
          'Nonaktif • Ketuk untuk mengatur pengingat air sebelum tidur',
      'reminderMessage': 'Pesan pengingat',
      'usesCurrentSoundMode':
          'Menggunakan suara dan mode saat ini saat disimpan.',
      'onlyAvailableInCustomSchedule': 'Hanya tersedia dalam Jadwal Kustom',
      'privacyPolicy': 'Kebijakan Privasi',
      'privacyPolicySubtitle': 'Cara StayHydro menangani data Anda',
      'termsConditions': 'Syarat & Ketentuan',
      'termsConditionsSubtitle': 'Informasi penggunaan penting',
      'sleepHoursUpdated':
          'Jam tidur diperbarui dan pengingat dijadwalkan ulang',
    },
  };

  // ==========================================
  // [GENERAL]
  // ==========================================
  static const String appName = 'StayHydro';
  static const String settings = 'settings';
  static const String cancel = 'cancel';
  static const String save = 'save';
  static const String reset = 'reset';
  static const String delete = 'delete';
  static const String gotIt = 'gotIt';
  static const String later = 'later';
  static const String comingSoon = 'comingSoon';
  static const String waterIntake = 'waterIntake';
  static const String home = 'home';
  static const String history = 'history';

  // Intake Selector Dialog file keys
  static const String selectIntakeAmount = 'selectIntakeAmount';
  static const String customAmountHint = 'customAmountHint';
  static const String enterNumber = 'enterNumber';
  static const String intakeRangeError = 'intakeRangeError';

  // Home Screen کی کیز

  static const String dailyHydrationTip = 'dailyHydrationTip';
  static const String nextHydrationGoal = 'nextHydrationGoal';
  static const String paused = 'paused';
  static const String add = 'add';
  static const String switchIntake = 'switchIntake';
  static const String missedEntry = 'missedEntry';
  static const String days = 'days';
  static const String goalCompleted = 'goalCompleted';
  static const String goalCompletedMissedEntry = 'goalCompletedMissedEntry';
  static const String dailyIntakeLimitReached = 'dailyIntakeLimitReached';

  // Missed Entry

  static const String addMissedEntry = 'addMissedEntry';
  static const String intakeTime = 'intakeTime';
  static const String selectAmount = 'selectAmount';
  static const String addEntry = 'addEntry';

  // History Screen

  static const String weeklyProgress = 'weeklyProgress';
  static const String average = 'average';
  static const String done = 'done';
  static const String best = 'best';
  static const String todaysLogs = 'todaysLogs';
  static const String noEntriesToday = 'noEntriesToday';
  static const String mon = 'mon';
  static const String tue = 'tue';
  static const String wed = 'wed';
  static const String thu = 'thu';
  static const String fri = 'fri';
  static const String sat = 'sat';
  static const String sun = 'sun';
  static const String water = 'water';

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
  static const String smartHourly = 'smartHourly';
  static const String customScheduleMode = 'customScheduleMode';
  static const String selectReminderSystem = 'Select Reminder System';
  static const String smartHourlySubtitle =
      'Automatic hourly reminders with sleep hours';
  static const String customScheduleSubtitle = 'Choose your own reminder times';

  // ==========================================
  // [CUSTOM SCHEDULE]
  // ==========================================
  static const String customReminderTimes = 'customReminderTimes';
  static const String customReminderTimesHelp =
      'Enable, disable or edit each hydration reminder time.';
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
  static const String medicineReminderSubtitle = 'medicineReminderSubtitle';
  static const String wellnessReminderSubtitle = 'wellnessReminderSubtitle';
  static const String bedtimeReminderSubtitle = 'bedtimeReminderSubtitle';
  static const String reminderMessage = 'reminderMessage';
  static const String usesCurrentSoundMode = 'usesCurrentSoundMode';

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
  static const String testNotification = 'testNotification';
  static const String testNotificationSubtitle = 'testNotificationSubtitle';
  static const String testNotificationSent = 'testNotificationSent';
  static const String helpFeedback = 'helpFeedback';
  static const String helpFeedbackSubtitle = 'helpFeedbackSubtitle';
  static const String privacyPolicy = 'privacyPolicy';
  static const String privacyPolicySubtitle = 'privacyPolicySubtitle';
  static const String privacyPolicyInfoMessage = 'privacyPolicyInfoMessage';

  static const String termsConditions = 'termsConditions';
  static const String termsConditionsSubtitle = 'termsConditionsSubtitle';
  static const String termsConditionsInfoMessage = 'termsConditionsInfoMessage';

  static const String aboutStayHydro = 'aboutStayHydro';
  static const String aboutStayHydroSubtitle = 'Version 1.0.0 • Slnova';
  static const String copyStayHydroEmail = 'copyStayHydroEmail';
  static const String copySlnovaEmail = 'copySlnovaEmail';
  static const String emailCopied = 'emailCopied';

  // ==========================================
// [FIRST LAUNCH GUIDE]
// ==========================================
  static const String firstLaunchWelcomeTitle = 'firstLaunchWelcomeTitle';
  static const String firstLaunchReliabilityMessage =
      'firstLaunchReliabilityMessage';
  static const String getStarted = 'getStarted';

  // ==========================================
// [INFO / SNACKBARS / DIALOGS]
// ==========================================

  static const String languageComingSoonMessage =
      'Language options will be added in a future update.';

  static const String reminderSystemChanged = 'reminderSystemChanged';

  static const String sleepHoursUpdated = 'sleepHoursUpdated';

  static const String customScheduleInactive = 'Custom Schedule Inactive';

  static const String customScheduleInactiveMessage =
      'Select Custom Schedule from Reminder System to manage your custom reminder times.';

  // ==========================================
// [SETTINGS: REMAINING INFO MESSAGES]
// ==========================================

  static const String dailyGoalUpdated = 'Daily goal updated to';

  static const String reminderSlotsConfigured = 'reminder slots configured';

  static const String onlyAvailableInCustomSchedule =
      'onlyAvailableInCustomSchedule';

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
      'Need help or want to share feedback?\n\n'
      'StayHydro Support\n'
      'hello.stayhydro@gmail.com\n\n'
      'Slnova Support\n'
      'hello.slnova@gmail.com\n\n'
      'We welcome bug reports, feature suggestions and general feedback.';

  static const String aboutStayHydroInfoMessage =
      'StayHydro helps you build a healthy hydration routine with smart reminders, custom schedules and special reminders.\n\n'
      'More than a reminder. A hydration companion.\n\n'
      'Version: 1.0.0\n'
      'Developer: Slnova\n\n'
      'Stay consistent.\n'
      'Stay healthy.\n'
      'Stay hydrated.';

  static const String fullTranslationsBeforeRelease =
      'Full translations will be added before release.';

  static const String currentlyActive = 'Currently active';

  static const String languageTranslationComingSoon =
      'translation will be added before release.\n\nFor now, English remains active.';

// Home Screen Daily Tips Method

  static List<String> dailyTips() {
    return _dailyTips[activeLanguage] ?? _dailyTips['English']!;
  }

  static const Map<String, List<String>> _dailyTips = {
    'English': [
      'Drink water right after you wake up.',
      'Sip water slowly instead of chugging.',
      'Keep a bottle within arm’s reach.',
      'Drink a glass before each meal.',
      'Add lemon slices for fresh flavor.',
      'Set simple water checkpoints through the day.',
      'Take a few sips every hour.',
      'Drink water after every bathroom break.',
      'Pair water with your coffee or tea.',
      'Drink before you feel thirsty.',
      'Refill your bottle whenever it’s half empty.',
      'Have water with every snack.',
      'Keep a glass of water on your desk.',
      'Choose water first when you eat out.',
      'Drink a small glass before workouts.',
      'Rehydrate after exercise right away.',
      'Add cucumber for a crisp taste.',
      'Take a water break between tasks.',
      'Keep chilled and room-temp options ready.',
      'Start meetings with a quick sip.',
      'Drink water after salty foods.',
      'Track your intake to stay motivated.',
      'Take a sip whenever you check your phone.',
      'Drink water before sugary drinks.',
      'Bring water in the car for short trips.',
      'Refill your bottle before leaving home.',
      'Take water breaks during screen time.',
      'Add mint leaves for variety.',
      'Drink a glass while waiting for meals.',
      'Celebrate each time you hit a mini goal.',
      'Keep water by your bedside at night.',
      'Make hydration part of your morning routine.',
      'Proper hydration improves brain focus.',
      'Feeling tired? Try a glass of water first.',
      'Water helps your kidneys clear toxins from your blood.',
      'Drinking water can help prevent headaches caused by dehydration.',
      'Hydration is key for maintaining healthy, glowing skin.',
      'Drinking water boosts your physical performance during exercise.',
      'Water helps maintain normal bowel function and prevents constipation.',
      'Being well-hydrated helps regulate your body temperature.',
      'Drinking water before meals can aid in healthy weight management.',
      'Hydration keeps your joints lubricated and cushioned.',
      'Water is essential for the production of saliva and digestive juices.',
      'Even mild dehydration can drain your energy and make you tired.',
      'Drinking enough water helps your heart pump blood more easily.',
      'Hydration supports the health of your mucus membranes and lungs.',
      'Water carries nutrients and oxygen to all cells in your body.',
      'A glass of water can help curb late-night snack cravings.',
      'Optimal hydration helps your brain stay alert and focused.',
      'Drinking water helps flush out waste products through sweat and urine.',
    ],
    'Spanish': [
      'Bebe agua justo después de despertarte.',
      'Toma agua poco a poco en lugar de beberla de golpe.',
      'Mantén una botella al alcance de la mano.',
      'Bebe un vaso antes de cada comida.',
      'Añade rodajas de limón para un sabor fresco.',
      'Marca pequeños puntos de hidratación durante el día.',
      'Toma unos sorbos cada hora.',
      'Bebe agua después de cada visita al baño.',
      'Acompaña tu café o té con agua.',
      'Bebe antes de sentir sed.',
      'Rellena tu botella cuando esté medio vacía.',
      'Toma agua con cada snack.',
      'Mantén un vaso de agua en tu escritorio.',
      'Elige agua primero cuando comas fuera.',
      'Bebe un vaso pequeño antes de entrenar.',
      'Rehidrátate justo después del ejercicio.',
      'Añade pepino para un sabor refrescante.',
      'Haz una pausa para tomar agua entre tareas.',
      'Ten opciones frías y a temperatura ambiente.',
      'Empieza las reuniones con un sorbo rápido.',
      'Bebe agua después de comidas saladas.',
      'Registra tu consumo para mantener la motivación.',
      'Toma un sorbo cada vez que revises el teléfono.',
      'Bebe agua antes de bebidas azucaradas.',
      'Lleva agua en el coche para trayectos cortos.',
      'Rellena tu botella antes de salir de casa.',
      'Haz pausas de agua durante el tiempo frente a pantallas.',
      'Añade hojas de menta para variar.',
      'Bebe un vaso mientras esperas la comida.',
      'Celebra cada mini objetivo alcanzado.',
      'Mantén agua junto a la cama por la noche.',
      'Haz de la hidratación parte de tu rutina matutina.',
      'Una buena hidratación mejora la concentración.',
      '¿Te sientes cansado? Prueba primero con un vaso de agua.',
      'El agua ayuda a tus riñones a limpiar toxinas de la sangre.',
      'Beber agua puede ayudar a prevenir dolores de cabeza por deshidratación.',
      'La hidratación es clave para una piel sana y luminosa.',
      'Beber agua mejora tu rendimiento físico durante el ejercicio.',
      'El agua ayuda a mantener una función intestinal normal.',
      'Estar bien hidratado ayuda a regular la temperatura corporal.',
      'Beber agua antes de comer puede apoyar el control saludable del peso.',
      'La hidratación mantiene tus articulaciones lubricadas y protegidas.',
      'El agua es esencial para producir saliva y jugos digestivos.',
      'Incluso una deshidratación leve puede quitarte energía.',
      'Beber suficiente agua ayuda al corazón a bombear sangre con más facilidad.',
      'La hidratación apoya la salud de las mucosas y los pulmones.',
      'El agua transporta nutrientes y oxígeno a las células.',
      'Un vaso de agua puede ayudar a reducir antojos nocturnos.',
      'Una hidratación óptima ayuda a tu cerebro a mantenerse alerta.',
      'Beber agua ayuda a eliminar desechos mediante sudor y orina.',
    ],
    'Arabic': [
      'اشرب الماء بعد الاستيقاظ مباشرة.',
      'اشرب الماء ببطء بدلًا من شربه دفعة واحدة.',
      'احتفظ بزجاجة ماء قريبة منك.',
      'اشرب كوبًا قبل كل وجبة.',
      'أضف شرائح الليمون لنكهة منعشة.',
      'ضع نقاط تذكير بسيطة للماء خلال اليوم.',
      'خذ بضع رشفات كل ساعة.',
      'اشرب الماء بعد كل دخول للحمام.',
      'اشرب الماء مع القهوة أو الشاي.',
      'اشرب قبل أن تشعر بالعطش.',
      'املأ زجاجتك عندما تصبح نصف فارغة.',
      'اشرب الماء مع كل وجبة خفيفة.',
      'احتفظ بكوب ماء على مكتبك.',
      'اختر الماء أولًا عند تناول الطعام خارج المنزل.',
      'اشرب كوبًا صغيرًا قبل التمرين.',
      'عوّض السوائل بعد التمرين مباشرة.',
      'أضف الخيار لطعم منعش.',
      'خذ استراحة ماء بين المهام.',
      'جهّز ماءً باردًا وآخر بدرجة حرارة الغرفة.',
      'ابدأ الاجتماعات برشفة سريعة.',
      'اشرب الماء بعد الأطعمة المالحة.',
      'تابع كمية الماء لتحافظ على حماسك.',
      'خذ رشفة كلما تفقدت هاتفك.',
      'اشرب الماء قبل المشروبات السكرية.',
      'خذ ماءً معك في السيارة للرحلات القصيرة.',
      'املأ زجاجتك قبل مغادرة المنزل.',
      'خذ فواصل ماء أثناء استخدام الشاشة.',
      'أضف أوراق النعناع للتغيير.',
      'اشرب كوبًا أثناء انتظار الطعام.',
      'احتفل عند تحقيق كل هدف صغير.',
      'احتفظ بالماء قرب سريرك ليلًا.',
      'اجعل الترطيب جزءًا من روتينك الصباحي.',
      'الترطيب الجيد يساعد على تحسين التركيز.',
      'تشعر بالتعب؟ جرّب كوب ماء أولًا.',
      'يساعد الماء الكليتين على تنقية السموم من الدم.',
      'شرب الماء قد يساعد في منع الصداع الناتج عن الجفاف.',
      'الترطيب مهم لبشرة صحية ومشرقة.',
      'شرب الماء يعزز الأداء البدني أثناء التمرين.',
      'يساعد الماء على الحفاظ على وظيفة الأمعاء الطبيعية.',
      'الترطيب الجيد يساعد على تنظيم حرارة الجسم.',
      'شرب الماء قبل الوجبات قد يدعم التحكم الصحي في الوزن.',
      'الترطيب يحافظ على تليين المفاصل وحمايتها.',
      'الماء ضروري لإنتاج اللعاب والعصارات الهضمية.',
      'حتى الجفاف الخفيف قد يقلل طاقتك ويجعلك متعبًا.',
      'شرب كمية كافية من الماء يساعد القلب على ضخ الدم بسهولة.',
      'الترطيب يدعم صحة الأغشية المخاطية والرئتين.',
      'ينقل الماء المغذيات والأكسجين إلى خلايا الجسم.',
      'كوب ماء قد يساعد على تقليل الرغبة في وجبات الليل.',
      'الترطيب المثالي يساعد دماغك على البقاء يقظًا ومركزًا.',
      'شرب الماء يساعد على التخلص من الفضلات عبر العرق والبول.',
    ],
    'Hindi': [
      'जागने के तुरंत बाद पानी पिएँ।',
      'एक साथ बहुत पानी पीने के बजाय धीरे-धीरे घूँट लें।',
      'पानी की बोतल हमेशा पास रखें।',
      'हर भोजन से पहले एक गिलास पानी पिएँ।',
      'ताज़े स्वाद के लिए नींबू के स्लाइस डालें।',
      'दिन भर के लिए छोटे पानी पीने के लक्ष्य रखें।',
      'हर घंटे कुछ घूँट पानी पिएँ।',
      'हर बार बाथरूम जाने के बाद पानी पिएँ।',
      'कॉफी या चाय के साथ पानी भी पिएँ।',
      'प्यास लगने से पहले पानी पिएँ।',
      'बोतल आधी खाली हो तो फिर से भर लें।',
      'हर स्नैक के साथ पानी लें।',
      'अपनी डेस्क पर पानी का गिलास रखें।',
      'बाहर खाना खाते समय पहले पानी चुनें।',
      'वर्कआउट से पहले छोटा गिलास पानी पिएँ।',
      'व्यायाम के बाद तुरंत पानी की कमी पूरी करें।',
      'ताज़गी के लिए खीरा डालें।',
      'कामों के बीच पानी का छोटा ब्रेक लें।',
      'ठंडा और सामान्य तापमान वाला पानी तैयार रखें।',
      'मीटिंग शुरू करने से पहले एक घूँट पानी लें।',
      'नमकीन खाने के बाद पानी पिएँ।',
      'प्रेरित रहने के लिए अपना पानी रिकॉर्ड करें।',
      'फोन चेक करते समय एक घूँट पानी लें।',
      'मीठे पेय से पहले पानी पिएँ।',
      'छोटी यात्राओं के लिए कार में पानी रखें।',
      'घर से निकलने से पहले बोतल भर लें।',
      'स्क्रीन टाइम के दौरान पानी के ब्रेक लें।',
      'स्वाद बदलने के लिए पुदीने की पत्तियाँ डालें।',
      'खाने का इंतज़ार करते समय एक गिलास पानी पिएँ।',
      'हर छोटा लक्ष्य पूरा होने पर खुशी मनाएँ।',
      'रात में अपने बिस्तर के पास पानी रखें।',
      'पानी पीना अपनी सुबह की दिनचर्या का हिस्सा बनाएँ।',
      'अच्छी हाइड्रेशन दिमागी ध्यान बेहतर करती है।',
      'थकान महसूस हो रही है? पहले एक गिलास पानी पिएँ।',
      'पानी किडनी को खून से विषैले पदार्थ निकालने में मदद करता है।',
      'पानी पीना डिहाइड्रेशन से होने वाले सिरदर्द को रोकने में मदद कर सकता है।',
      'हाइड्रेशन स्वस्थ और चमकदार त्वचा के लिए ज़रूरी है।',
      'पानी पीना व्यायाम के दौरान शारीरिक प्रदर्शन बढ़ाता है।',
      'पानी सामान्य पाचन और कब्ज से बचाव में मदद करता है।',
      'अच्छी हाइड्रेशन शरीर का तापमान नियंत्रित रखने में मदद करती है।',
      'भोजन से पहले पानी पीना स्वस्थ वजन प्रबंधन में मदद कर सकता है।',
      'हाइड्रेशन जोड़ों को चिकना और सुरक्षित रखती है।',
      'लार और पाचक रस बनाने के लिए पानी ज़रूरी है।',
      'हल्की डिहाइड्रेशन भी ऊर्जा कम कर सकती है।',
      'पर्याप्त पानी दिल को खून आसानी से पंप करने में मदद करता है।',
      'हाइड्रेशन म्यूकस मेम्ब्रेन और फेफड़ों की सेहत को सहारा देती है।',
      'पानी पोषक तत्व और ऑक्सीजन शरीर की कोशिकाओं तक पहुँचाता है।',
      'एक गिलास पानी देर रात की भूख कम करने में मदद कर सकता है।',
      'बेहतर हाइड्रेशन दिमाग को सतर्क और केंद्रित रखती है।',
      'पानी पसीने और पेशाब के जरिए अपशिष्ट पदार्थ निकालने में मदद करता है।',
    ],
    'Indonesian': [
      'Minum air segera setelah bangun tidur.',
      'Minum perlahan, jangan langsung banyak sekaligus.',
      'Simpan botol air dalam jangkauan tangan.',
      'Minum segelas air sebelum setiap makan.',
      'Tambahkan irisan lemon untuk rasa segar.',
      'Buat titik pengingat minum air sepanjang hari.',
      'Minum beberapa teguk setiap jam.',
      'Minum air setelah setiap kali ke kamar mandi.',
      'Dampingi kopi atau teh dengan air putih.',
      'Minum sebelum merasa haus.',
      'Isi ulang botol saat sudah setengah kosong.',
      'Minum air bersama setiap camilan.',
      'Simpan segelas air di meja kerja.',
      'Pilih air putih dulu saat makan di luar.',
      'Minum segelas kecil sebelum berolahraga.',
      'Segera rehidrasi setelah olahraga.',
      'Tambahkan mentimun untuk rasa segar.',
      'Ambil jeda minum air di antara tugas.',
      'Siapkan pilihan air dingin dan suhu ruang.',
      'Mulai rapat dengan satu teguk cepat.',
      'Minum air setelah makanan asin.',
      'Catat asupan air agar tetap termotivasi.',
      'Minum satu teguk setiap kali mengecek ponsel.',
      'Minum air sebelum minuman manis.',
      'Bawa air di mobil untuk perjalanan singkat.',
      'Isi ulang botol sebelum keluar rumah.',
      'Ambil jeda minum saat menatap layar.',
      'Tambahkan daun mint untuk variasi.',
      'Minum segelas air sambil menunggu makanan.',
      'Rayakan setiap kali mencapai target kecil.',
      'Simpan air di samping tempat tidur pada malam hari.',
      'Jadikan hidrasi bagian dari rutinitas pagi.',
      'Hidrasi yang baik membantu fokus otak.',
      'Merasa lelah? Coba minum segelas air dulu.',
      'Air membantu ginjal membersihkan racun dari darah.',
      'Minum air dapat membantu mencegah sakit kepala akibat dehidrasi.',
      'Hidrasi penting untuk kulit yang sehat dan bercahaya.',
      'Minum air meningkatkan performa fisik saat olahraga.',
      'Air membantu menjaga fungsi usus normal dan mencegah sembelit.',
      'Hidrasi yang baik membantu mengatur suhu tubuh.',
      'Minum air sebelum makan dapat membantu pengelolaan berat badan sehat.',
      'Hidrasi menjaga sendi tetap terlumasi dan terlindungi.',
      'Air penting untuk produksi air liur dan cairan pencernaan.',
      'Dehidrasi ringan saja dapat menguras energi.',
      'Minum cukup air membantu jantung memompa darah lebih mudah.',
      'Hidrasi mendukung kesehatan selaput lendir dan paru-paru.',
      'Air membawa nutrisi dan oksigen ke sel-sel tubuh.',
      'Segelas air dapat membantu mengurangi keinginan ngemil malam.',
      'Hidrasi optimal membantu otak tetap waspada dan fokus.',
      'Minum air membantu membuang sisa metabolisme lewat keringat dan urine.',
    ],
  };
}
