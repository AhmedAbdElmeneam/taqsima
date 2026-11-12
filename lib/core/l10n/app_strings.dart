/// Every user-facing string in the app lives here, in clear Modern Standard
/// Arabic. To add another language later, turn this into an ARB-based class.
abstract final class S {
  // App
  static const appName = 'تقسيمة';
  static const appTagline = 'احجز ملعبك وجهّز التقسيمة';
  static const currency = 'ج.م';
  static String price(int amount) => '$amount ${S.currency}';
  static String pricePerHour(int amount) => '$amount ${S.currency} / الساعة';

  // Common
  static const next = 'التالي';
  static const back = 'رجوع';
  static const save = 'حفظ';
  static const seeAll = 'عرض الكل';
  static const somethingWrong = 'حدث خطأ، يرجى المحاولة مرة أخرى';
  static const today = 'اليوم';
  static const tomorrow = 'غدًا';
  static const hour = 'ساعة';
  static const optional = '(اختياري)';
  static const am = 'ص';
  static const pm = 'م';
  static String km(String value) => '$value كم';

  // Role choice / splash
  static const welcome = 'مرحبًا بك في تقسيمة';
  static const chooseRole = 'كيف ستستخدم تقسيمة؟';
  static const iAmPlayer = 'أنا لاعب';
  static const iAmPlayerHint = 'ابحث عن ملعب واحجز موعدك';
  static const iAmOwner = 'أنا صاحب ملعب';
  static const iAmOwnerHint = 'نظّم حجوزات ملعبك بسهولة';

  // Auth
  static const login = 'تسجيل الدخول';
  static const signup = 'حساب جديد';
  static const phoneNumber = 'رقم الهاتف';
  static const phoneHint = '01xxxxxxxxx';
  static const fullName = 'الاسم';
  static const fullNameHint = 'أدخل اسمك';
  static const sendCode = 'إرسال رمز التحقق';
  static const invalidPhone =
      'أدخل رقم هاتف مصريًا صحيحًا (11 رقمًا يبدأ بـ 01)';
  static const nameRequired = 'يرجى إدخال الاسم';
  static const loginAsPlayer = 'الدخول كلاعب';
  static const loginAsOwner = 'الدخول كصاحب ملعب';
  static const otpTitle = 'أدخل رمز التحقق';
  static String otpSentTo(String phone) =>
      'أرسلنا رمزًا من 4 أرقام إلى\n$phone';
  static const otpDemoHint = 'للتجربة: يعمل أي رمز من 4 أرقام (مثل 1234)';
  static const verify = 'تحقق';
  static const resendCode = 'إعادة إرسال الرمز';
  static const codeResent = 'تمت إعادة إرسال الرمز';
  static const otpIncomplete = 'أدخل الأرقام الأربعة';

  // Navigation
  static const navHome = 'الرئيسية';
  static const navSearch = 'البحث';
  static const navMyBookings = 'حجوزاتي';
  static const navProfile = 'حسابي';
  static const navToday = 'اليوم';
  static const navCalendar = 'الجدول';
  static const navRequests = 'الطلبات';

  // Player home
  static const yourNextMatch = 'مباراتك القادمة';
  static const noUpcomingMatch = 'لا توجد مباريات قادمة — احجز ملعبك الآن';
  static const availableToday = 'متاح اليوم';
  static const bookAgain = 'احجز مرة أخرى';
  static const awaitingConfirmation = 'بانتظار تأكيد الملعب';
  static const homeQuestion = 'أين ستلعب اليوم؟';
  static const searchHint = 'ابحث باسم الملعب أو المنطقة';
  static const nearbyPitches = 'ملاعب قريبة منك';
  static const filters = 'تصفية النتائج';
  static const area = 'المنطقة';
  static const date = 'التاريخ';
  static const pitchType = 'نوع الملعب';
  static const maxPrice = 'أقصى سعر للساعة';
  static const anyPrice = 'أي سعر';
  static const applyFilters = 'عرض النتائج';
  static const resetFilters = 'مسح التصفية';
  static const fiveASide = 'خماسي';
  static const sevenASide = 'سباعي';
  static const anyType = 'أي نوع';
  static const anyArea = 'كل المناطق';

  // Search results
  static const searchResults = 'نتائج البحث';
  static String resultsCount(int n) => n == 1
      ? 'ملعب واحد'
      : n == 2
          ? 'ملعبان'
          : n <= 10
              ? '$n ملاعب'
              : '$n ملعبًا';
  static const listView = 'قائمة';
  static const mapView = 'خريطة';
  static const noResults = 'لا توجد ملاعب مطابقة';
  static const noResultsHint = 'جرّب تغيير التصفية أو البحث في منطقة أخرى';
  static const mapPlaceholderNote = 'خريطة تجريبية — اضغط على أي علامة';

  // Pitch details
  static const location = 'الموقع';
  static const amenities = 'المرافق';
  static const about = 'عن الملعب';
  static const book = 'احجز';
  static const startingFrom = 'السعر';
  static const amenityTurf = 'عشب صناعي';
  static const amenityLights = 'إضاءة ليلية';
  static const amenityToilets = 'دورات مياه';
  static const amenityParking = 'موقف سيارات';

  // Slot picker
  static const chooseTime = 'اختر الموعد';
  static const chooseDay = 'اختر اليوم';
  static const availableTimes = 'المواعيد';
  static const legendAvailable = 'متاح';
  static const legendBooked = 'محجوز';
  static const legendManual = 'حجز يدوي';
  static const legendBlocked = 'مغلق';
  static const closedThisDay = 'الملعب مغلق في هذا اليوم';
  static const closedThisDayHint = 'اختر يومًا آخر من الأعلى';
  static const noSlotsLeft = 'جميع المواعيد محجوزة';
  static const noSlotsLeftHint = 'جرّب يومًا آخر';
  static const selectSlotFirst = 'اختر موعدًا أولًا';
  static String slotDuration(int minutes) => minutes == 60
      ? 'ساعة'
      : minutes == 90
          ? 'ساعة ونصف'
          : '$minutes دقيقة';
  static const continueBtn = 'متابعة';

  // Confirmation
  static const confirmBooking = 'تأكيد الحجز';
  static const bookingSummary = 'ملخص الحجز';
  static const pitch = 'الملعب';
  static const time = 'الموعد';
  static const duration = 'المدة';
  static const total = 'الإجمالي';
  static const paymentAtPitch = 'الدفع نقدًا في الملعب';
  static const cancellationPolicy = 'سياسة الإلغاء';
  static const cancellationPolicyText =
      'يمكنك الإلغاء مجانًا قبل الموعد بست ساعات على الأقل، ولا يتاح الإلغاء من التطبيق بعد ذلك.';
  static const requestNote =
      'سيصل طلبك إلى صاحب الملعب، ويُؤكَّد الحجز فور موافقته.';
  static const sendBookingRequest = 'إرسال طلب الحجز';
  static const slotJustTaken = 'حُجز هذا الموعد للتو، يرجى اختيار موعد آخر';

  // Success
  static const bookingSent = 'تم إرسال طلب الحجز';
  static const bookingSentHint =
      'سنرسل إليك إشعارًا عند تأكيد صاحب الملعب للحجز.';
  static const viewBooking = 'عرض الحجز';
  static const backToHome = 'العودة إلى الرئيسية';

  // My bookings
  static const upcoming = 'القادمة';
  static const past = 'السابقة';
  static const noUpcoming = 'لا توجد حجوزات قادمة';
  static const noUpcomingHint = 'احجز ملعبًا وابدأ مباراتك';
  static const noPast = 'لا توجد حجوزات سابقة';
  static const findPitch = 'ابحث عن ملعب';

  // Booking status
  static const statusPending = 'بانتظار الموافقة';
  static const statusConfirmed = 'مؤكد';
  static const statusCancelled = 'ملغى';
  static const statusCompleted = 'مكتمل';

  // Booking details
  static const bookingDetails = 'تفاصيل الحجز';
  static const bookingNumber = 'رقم الحجز';
  static const directions = 'الاتجاهات';
  static const directionsMock = 'سيتم فتح الخريطة على موقع الملعب (تجريبي)';
  static const cancelBooking = 'إلغاء الحجز';
  static const cancelBookingQ = 'هل تريد إلغاء الحجز؟';
  static const yesCancel = 'نعم، إلغاء';
  static const noKeep = 'لا، الإبقاء عليه';
  static const bookingCancelled = 'تم إلغاء الحجز';
  static const cancelNotAllowed = 'الإلغاء متاح حتى ست ساعات قبل الموعد فقط';
  static const reportProblem = 'الإبلاغ عن مشكلة';
  static const reportProblemHint = 'صف المشكلة باختصار';
  static const send = 'إرسال';
  static const reportSent = 'وصلتنا رسالتك، وسنتواصل معك قريبًا';
  static const bookingNotFound = 'هذا الحجز غير موجود';

  // Profile
  static const profile = 'حسابي';
  static const editName = 'تعديل الاسم';
  static const notifications = 'الإشعارات';
  static const language = 'اللغة';
  static const arabic = 'العربية';
  static const appearance = 'المظهر';
  static const themeSystem = 'تلقائي';
  static const themeLight = 'فاتح';
  static const themeDark = 'داكن';
  static const helpCenter = 'المساعدة والدعم';
  static const terms = 'الشروط والأحكام';
  static const logout = 'تسجيل الخروج';
  static const logoutQ = 'هل تريد تسجيل الخروج؟';
  static String get appVersion =>
      'الإصدار ${String.fromCharCode(0x200E)}1.0.0 (نسخة تجريبية)';
  static const comingSoon = 'قريبًا';
  static const player = 'لاعب';
  static const owner = 'صاحب ملعب';

  // Owner dashboard
  static const occupancyToday = 'نسبة الإشغال اليوم';
  static String bookedOf(int booked, int total) => '$booked من $total مواعيد';
  static const goodMorning = 'صباح الخير';
  static const goodEvening = 'مساء الخير';
  static const nextBooking = 'الحجز القادم';
  static const playingNow = 'يُلعب الآن';
  static const noMoreBookingsToday = 'لا توجد حجوزات أخرى اليوم';
  static const ended = 'انتهى';
  static String inTime(int minutes) {
    if (minutes < 60) {
      return minutes <= 1
          ? 'بعد دقيقة'
          : minutes <= 10
              ? 'بعد $minutes دقائق'
              : 'بعد $minutes دقيقة';
    }
    final h = (minutes / 60).round();
    return h == 1
        ? 'بعد ساعة'
        : h == 2
            ? 'بعد ساعتين'
            : h <= 10
                ? 'بعد $h ساعات'
                : 'بعد $h ساعة';
  }

  static const todaysBookings = 'حجوزات اليوم';
  static const todaysRevenue = 'إيراد اليوم';
  static const bookingsCount = 'الحجوزات';
  static const freeSlots = 'متاح';
  static const edit = 'تعديل';
  static const hours = 'المواعيد';
  static String pendingRequestsBanner(int n) => n == 1
      ? 'لديك طلب حجز جديد'
      : n == 2
          ? 'لديك طلبا حجز جديدان'
          : 'لديك $n طلبات حجز جديدة';
  static const freeSlot = 'متاح';
  static const appBooking = 'حجز عبر التطبيق';
  static const manualBooking = 'حجز يدوي';
  static const blocked = 'مغلق';
  static const choosePitch = 'اختر الملعب';
  static const noPitchYet = 'لم تُضف ملعبًا بعد';
  static const noPitchYetHint = 'أضف ملعبك لتبدأ في استقبال الحجوزات';
  static const addPitch = 'إضافة ملعب';
  static const editPitch = 'تعديل الملعب';
  static const workingHours = 'ساعات العمل';
  static const tapFreeSlotHint =
      'اضغط على أي موعد متاح لإغلاقه أو تسجيل حجز يدوي';

  // Pitch form
  static const stepInfo = 'البيانات';
  static const stepPhotos = 'الصور';
  static const stepLocation = 'الموقع';
  static const stepPrice = 'السعر';
  static const pitchName = 'اسم الملعب';
  static const pitchNameHint = 'مثال: ملعب النصر';
  static const description = 'وصف الملعب';
  static const descriptionHint = 'اكتب ما يميّز ملعبك';
  static const chooseArea = 'اختر المنطقة';
  static const addPhoto = 'إضافة صورة';
  static const photosHint =
      'أضف صورًا واضحة للملعب (تجريبي — ستُضاف صورة نموذجية)';
  static const tapMapToPin = 'اضغط على الخريطة لتحديد موقع الملعب';
  static const locationSet = 'تم تحديد الموقع';
  static const priceHint = 'السعر بالجنيه للساعة';
  static const priceLabel = 'سعر الساعة (ج.م)';
  static const pitchSaved = 'تم حفظ الملعب';
  static const pitchSubmitted = 'تم إرسال الملعب للمراجعة';
  static const fieldRequired = 'هذا الحقل مطلوب';
  static const invalidPrice = 'أدخل سعرًا صحيحًا';
  static const finish = 'حفظ الملعب';
  static String stepOf(int step, int total) => 'الخطوة $step من $total';

  // Working hours
  static const from = 'من';
  static const to = 'إلى';
  static const closed = 'مغلق';
  static const open = 'مفتوح';
  static const slotDurationLabel = 'مدة الحجز';
  static const hoursSaved = 'تم حفظ ساعات العمل';
  static const nextDay = '(اليوم التالي)';
  static const workingHoursHint = 'حدّد الأيام والساعات التي يعمل فيها الملعب';

  // Calendar
  static const weeklyCalendar = 'جدول الأسبوع';
  static const slotActions = 'ماذا تريد أن تفعل؟';
  static const blockSlot = 'إغلاق هذا الموعد';
  static const blockSlotHint = 'لن يتمكن أحد من حجزه عبر التطبيق';
  static const addManualBooking = 'تسجيل حجز يدوي';
  static const addManualBookingHint = 'حجز تم بالهاتف أو في الملعب';
  static const customerName = 'اسم العميل';
  static const customerNameHint = 'اسم العميل (اختياري)';
  static const blockReason = 'السبب';
  static const blockReasonHint = 'مثال: صيانة (اختياري)';
  static const slotBlocked = 'تم إغلاق الموعد';
  static const manualBookingAdded = 'تم تسجيل الحجز';
  static const unblock = 'فتح الموعد';
  static const slotUnblocked = 'تم فتح الموعد';
  static const removeManualBooking = 'حذف الحجز اليدوي';
  static const manualBookingRemoved = 'تم حذف الحجز';
  static const viewDetails = 'عرض التفاصيل';
  static const noName = 'بدون اسم';
  static const filterAll = 'الكل';
  static String filterCount(String label, int n) => '$label ($n)';

  // Requests
  static const bookingRequests = 'طلبات الحجز';
  static const searchRequestsHint = 'ابحث باسم اللاعب أو الملعب';
  static const noSearchResults = 'لا توجد طلبات مطابقة';
  static const noSearchResultsHint = 'تأكد من الاسم وحاول مرة أخرى';
  static const accept = 'قبول';
  static const reject = 'رفض';
  static const accepted = 'تم تأكيد الحجز';
  static const rejected = 'تم رفض الطلب';
  static const noRequests = 'لا توجد طلبات جديدة';
  static const noRequestsHint = 'ستظهر هنا طلبات الحجز الجديدة';
  static const rejectQ = 'هل تريد رفض هذا الطلب؟';

  // Owner booking details
  static const playerName = 'اسم اللاعب';
  static const playerPhone = 'هاتف اللاعب';
  static const phoneHiddenUntilConfirm = 'يظهر بعد تأكيد الحجز';
  static const call = 'اتصال';
  static const callMock = 'سيتم الاتصال بالرقم (تجريبي)';
  static const source = 'المصدر';
  static const sourceApp = 'التطبيق';
  static const sourceManual = 'يدوي';

  // Owner profile
  static const myPitches = 'ملاعبي';
  static const pitchStatus = 'حالة الملعب';
  static const underReview = 'قيد المراجعة';
  static const active = 'نشط';
  static const underReviewHint =
      'يراجع فريقنا بيانات الملعب، وسيظهر للاعبين بعد الموافقة.';

  // Days (index = dayOfWeek, 0 = Sunday)
  static const weekdays = [
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  ];
  static const weekdaysShort = [
    'أحد',
    'اثنين',
    'ثلاثاء',
    'أربعاء',
    'خميس',
    'جمعة',
    'سبت',
  ];
  static const months = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];
}
