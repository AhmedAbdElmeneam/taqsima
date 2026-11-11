/// Every user-facing string in the app lives here (Arabic, Egyptian tone).
/// To add another language later, turn this into an ARB-based l10n class.
abstract final class S {
  // App
  static const appName = 'ميعادنا';
  static const appTagline = 'احجز ملعبك في دقيقة';
  static const currency = 'ج.م';
  static String price(int amount) => '$amount ${S.currency}';
  static String pricePerHour(int amount) => '$amount ${S.currency} / الساعة';

  // Common
  static const next = 'التالي';
  static const back = 'رجوع';
  static const save = 'حفظ';
  static const cancel = 'إلغاء';
  static const confirm = 'تأكيد';
  static const close = 'إغلاق';
  static const done = 'تمام';
  static const retry = 'حاول تاني';
  static const seeAll = 'عرض الكل';
  static const loading = 'جاري التحميل...';
  static const somethingWrong = 'حصلت مشكلة، حاول تاني';
  static const today = 'النهارده';
  static const tomorrow = 'بكره';
  static const minutes = 'دقيقة';
  static const hour = 'ساعة';
  static const optional = '(اختياري)';
  static const am = 'ص';
  static const pm = 'م';
  static const all = 'الكل';

  // Role choice / splash
  static const welcome = 'أهلاً بيك في ميعادنا';
  static const chooseRole = 'إنت مين؟';
  static const iAmPlayer = 'أنا لاعب';
  static const iAmPlayerHint = 'دوّر على ملعب واحجز ميعادك';
  static const iAmOwner = 'أنا صاحب ملعب';
  static const iAmOwnerHint = 'نظّم حجوزات ملعبك بسهولة';

  // Auth
  static const login = 'تسجيل الدخول';
  static const signup = 'حساب جديد';
  static const phoneNumber = 'رقم الموبايل';
  static const phoneHint = '01xxxxxxxxx';
  static const fullName = 'الاسم';
  static const fullNameHint = 'اكتب اسمك';
  static const sendCode = 'ابعتلي الكود';
  static const invalidPhone = 'اكتب رقم موبايل مصري صحيح (11 رقم يبدأ بـ 01)';
  static const nameRequired = 'اكتب اسمك';
  static const loginAsPlayer = 'دخول كلاعب';
  static const loginAsOwner = 'دخول كصاحب ملعب';
  static const otpTitle = 'اكتب الكود';
  static String otpSentTo(String phone) => 'بعتنا كود من 4 أرقام على\n$phone';
  static const otpDemoHint = 'للتجربة: أي 4 أرقام هتشتغل (مثلاً 1234)';
  static const verify = 'تأكيد الكود';
  static const resendCode = 'ابعت الكود تاني';
  static const codeResent = 'تم إرسال الكود تاني';
  static const otpIncomplete = 'اكتب الـ 4 أرقام';

  // Navigation
  static const navHome = 'الرئيسية';
  static const navSearch = 'البحث';
  static const navMyBookings = 'حجوزاتي';
  static const navProfile = 'حسابي';
  static const navToday = 'النهارده';
  static const navCalendar = 'الجدول';
  static const navRequests = 'الطلبات';

  // Player home
  static String hello(String name) => 'أهلاً يا $name';
  static const homeQuestion = 'هتلعب فين النهارده؟';
  static const searchHint = 'دوّر باسم الملعب أو المنطقة';
  static const nearbyPitches = 'ملاعب قريبة منك';
  static const filters = 'فلترة';
  static const area = 'المنطقة';
  static const date = 'اليوم';
  static const pitchType = 'نوع الملعب';
  static const maxPrice = 'أقصى سعر للساعة';
  static const anyPrice = 'أي سعر';
  static const applyFilters = 'اعرض النتايج';
  static const resetFilters = 'مسح الفلاتر';
  static const fiveASide = 'خماسي';
  static const sevenASide = 'سباعي';
  static const anyType = 'أي نوع';
  static const anyArea = 'كل المناطق';

  // Search results
  static const searchResults = 'نتايج البحث';
  static String resultsCount(int n) => n == 1 ? 'ملعب واحد' : '$n ملاعب';
  static const listView = 'قايمة';
  static const mapView = 'خريطة';
  static const noResults = 'مفيش ملاعب مطابقة';
  static const noResultsHint = 'جرّب تغيّر الفلاتر أو تدوّر في منطقة تانية';
  static const mapPlaceholderNote = 'الخريطة تجريبية — دوس على أي دبوس';

  // Pitch details
  static const pitchDetails = 'تفاصيل الملعب';
  static const location = 'المكان';
  static const amenities = 'المميزات';
  static const about = 'عن الملعب';
  static const book = 'احجز';
  static const bookNow = 'احجز دلوقتي';
  static const startingFrom = 'السعر';
  static const amenityTurf = 'نجيل صناعي';
  static const amenityLights = 'إضاءة ليلية';
  static const amenityToilets = 'حمامات';
  static const amenityParking = 'باركينج';

  // Slot picker
  static const chooseTime = 'اختار الميعاد';
  static const chooseDay = 'اختار اليوم';
  static const availableTimes = 'المواعيد';
  static const legendAvailable = 'متاح';
  static const legendBooked = 'محجوز';
  static const legendManual = 'حجز يدوي';
  static const legendBlocked = 'مقفول';
  static const closedThisDay = 'الملعب مقفول اليوم ده';
  static const closedThisDayHint = 'اختار يوم تاني من فوق';
  static const noSlotsLeft = 'كل المواعيد اتحجزت';
  static const noSlotsLeftHint = 'جرّب يوم تاني';
  static const selectSlotFirst = 'اختار ميعاد الأول';
  static String slotDuration(int minutes) =>
      minutes == 60 ? 'ساعة' : minutes == 90 ? 'ساعة ونص' : '$minutes دقيقة';
  static const continueBtn = 'كمّل';

  // Confirmation
  static const confirmBooking = 'تأكيد الحجز';
  static const bookingSummary = 'ملخص الحجز';
  static const pitch = 'الملعب';
  static const time = 'الميعاد';
  static const duration = 'المدة';
  static const total = 'الإجمالي';
  static const paymentAtPitch = 'الدفع كاش في الملعب';
  static const cancellationPolicy = 'سياسة الإلغاء';
  static const cancellationPolicyText =
      'تقدر تلغي مجاناً قبل الميعاد بـ 6 ساعات على الأقل. بعد كده الإلغاء مش متاح من التطبيق.';
  static const requestNote =
      'هيوصل طلبك لصاحب الملعب، وهيتأكد الحجز أول ما يوافق.';
  static const sendBookingRequest = 'ابعت طلب الحجز';
  static const slotJustTaken = 'الميعاد ده اتحجز لسه، اختار ميعاد تاني';

  // Success
  static const bookingSent = 'تم إرسال طلب الحجز!';
  static const bookingSentHint =
      'هنبعتلك إشعار أول ما صاحب الملعب يأكّد الحجز.';
  static const viewBooking = 'شوف الحجز';
  static const backToHome = 'رجوع للرئيسية';

  // My bookings
  static const upcoming = 'الجاية';
  static const past = 'اللي فاتت';
  static const noUpcoming = 'مفيش حجوزات جاية';
  static const noUpcomingHint = 'احجز ملعب وخلّي الماتش يبدأ!';
  static const noPast = 'مفيش حجوزات قديمة';
  static const findPitch = 'دوّر على ملعب';

  // Booking status
  static const statusPending = 'مستني موافقة';
  static const statusConfirmed = 'مؤكد';
  static const statusCancelled = 'ملغي';
  static const statusCompleted = 'خلص';

  // Booking details
  static const bookingDetails = 'تفاصيل الحجز';
  static const bookingNumber = 'رقم الحجز';
  static const directions = 'الاتجاهات';
  static const directionsMock = 'هيفتح الخريطة على مكان الملعب (تجريبي)';
  static const cancelBooking = 'إلغاء الحجز';
  static const cancelBookingQ = 'متأكد إنك عايز تلغي الحجز؟';
  static const yesCancel = 'أيوه، الغي';
  static const noKeep = 'لا، خليه';
  static const bookingCancelled = 'تم إلغاء الحجز';
  static const cancelNotAllowed = 'الإلغاء متاح لحد 6 ساعات قبل الميعاد بس';
  static const reportProblem = 'بلّغ مشكلة';
  static const reportProblemHint = 'اكتب المشكلة باختصار';
  static const send = 'ابعت';
  static const reportSent = 'وصلتنا رسالتك، هنتواصل معاك قريب';
  static const bookingNotFound = 'الحجز ده مش موجود';

  // Profile
  static const profile = 'حسابي';
  static const editName = 'تعديل الاسم';
  static const notifications = 'الإشعارات';
  static const language = 'اللغة';
  static const arabic = 'العربية';
  static const helpCenter = 'المساعدة والدعم';
  static const terms = 'الشروط والأحكام';
  static const logout = 'تسجيل الخروج';
  static const logoutQ = 'عايز تخرج من حسابك؟';
  static const appVersion = 'الإصدار 1.0.0 (نسخة تجريبية)';
  static const comingSoon = 'قريباً';
  static const player = 'لاعب';
  static const owner = 'صاحب ملعب';

  // Owner dashboard
  static const todaysBookings = 'حجوزات النهارده';
  static const todaysRevenue = 'إيراد النهارده';
  static const bookingsCount = 'عدد الحجوزات';
  static const freeSlots = 'مواعيد فاضية';
  static const pendingRequests = 'طلبات مستنية';
  static String pendingRequestsBanner(int n) =>
      n == 1 ? 'عندك طلب حجز جديد' : 'عندك $n طلبات حجز جديدة';
  static const review = 'راجعها';
  static const noBookingsToday = 'مفيش حجوزات النهارده لسه';
  static const noBookingsTodayHint = 'المواعيد الفاضية هتظهر هنا.';
  static const freeSlot = 'فاضي';
  static const appBooking = 'حجز من التطبيق';
  static const manualBooking = 'حجز يدوي';
  static const blocked = 'مقفول';
  static const choosePitch = 'اختار الملعب';
  static const noPitchYet = 'لسه مضفتش ملعب';
  static const noPitchYetHint = 'ضيف ملعبك عشان تبدأ تستقبل حجوزات';
  static const addPitch = 'ضيف ملعب';
  static const editPitch = 'تعديل الملعب';
  static const workingHours = 'مواعيد العمل';
  static const quickActions = 'اختصارات';
  static const tapFreeSlotHint = 'دوس على أي ميعاد فاضي عشان تقفله أو تسجّل حجز';

  // Pitch form
  static const stepInfo = 'البيانات';
  static const stepPhotos = 'الصور';
  static const stepLocation = 'المكان';
  static const stepPrice = 'السعر';
  static const pitchName = 'اسم الملعب';
  static const pitchNameHint = 'مثلاً: ملعب النصر';
  static const description = 'وصف الملعب';
  static const descriptionHint = 'اكتب حاجة تميّز ملعبك';
  static const chooseArea = 'اختار المنطقة';
  static const addPhoto = 'ضيف صورة';
  static const photosHint = 'ضيف صور واضحة للملعب (تجريبي — هتتضاف صورة نموذجية)';
  static const tapMapToPin = 'دوس على الخريطة عشان تحدد مكان الملعب';
  static const locationSet = 'تم تحديد المكان';
  static const priceHint = 'السعر بالجنيه للساعة';
  static const pitchSaved = 'تم حفظ الملعب';
  static const pitchSubmitted = 'تم إرسال الملعب للمراجعة';
  static const fieldRequired = 'الخانة دي مطلوبة';
  static const invalidPrice = 'اكتب سعر صحيح';
  static const finish = 'حفظ الملعب';
  static String stepOf(int step, int total) => 'خطوة $step من $total';

  // Working hours
  static const from = 'من';
  static const to = 'لحد';
  static const closed = 'مقفول';
  static const open = 'مفتوح';
  static const slotDurationLabel = 'مدة الحجز الواحد';
  static const hoursSaved = 'تم حفظ المواعيد';
  static const nextDay = '(اليوم اللي بعده)';
  static const workingHoursHint = 'حدد الأيام والساعات اللي الملعب شغال فيها';

  // Calendar
  static const weeklyCalendar = 'جدول الأسبوع';
  static const slotActions = 'إيه اللي عايز تعمله؟';
  static const blockSlot = 'اقفل الميعاد ده';
  static const blockSlotHint = 'مش هيقدر حد يحجزه من التطبيق';
  static const addManualBooking = 'سجّل حجز يدوي';
  static const addManualBookingHint = 'حد حجز بالتليفون أو في الملعب';
  static const customerName = 'اسم الزبون';
  static const customerNameHint = 'اسم الزبون (اختياري)';
  static const blockReason = 'السبب';
  static const blockReasonHint = 'مثلاً: صيانة (اختياري)';
  static const slotBlocked = 'تم قفل الميعاد';
  static const manualBookingAdded = 'تم تسجيل الحجز';
  static const unblock = 'افتح الميعاد';
  static const slotUnblocked = 'تم فتح الميعاد';
  static const removeManualBooking = 'امسح الحجز اليدوي';
  static const manualBookingRemoved = 'تم مسح الحجز';
  static const viewDetails = 'شوف التفاصيل';
  static const noName = 'بدون اسم';

  // Requests
  static const bookingRequests = 'طلبات الحجز';
  static const accept = 'موافقة';
  static const reject = 'رفض';
  static const accepted = 'تم تأكيد الحجز';
  static const rejected = 'تم رفض الطلب';
  static const noRequests = 'مفيش طلبات جديدة';
  static const noRequestsHint = 'أول ما لاعب يطلب حجز هيظهر هنا';
  static const rejectQ = 'متأكد إنك عايز ترفض الطلب ده؟';

  // Owner booking details
  static const playerName = 'اسم اللاعب';
  static const playerPhone = 'موبايل اللاعب';
  static const phoneHiddenUntilConfirm = 'هيظهر بعد تأكيد الحجز';
  static const call = 'اتصل';
  static const callMock = 'هيتصل بالرقم (تجريبي)';
  static const source = 'المصدر';
  static const sourceApp = 'التطبيق';
  static const sourceManual = 'يدوي';

  // Owner profile
  static const myPitches = 'ملاعبي';
  static const pitchStatus = 'حالة الملعب';
  static const underReview = 'تحت المراجعة';
  static const active = 'شغّال';
  static const underReviewHint = 'فريقنا بيراجع بيانات الملعب، وهيظهر للاعبين بعد الموافقة.';

  // Days (index = dayOfWeek, 0 = Sunday)
  static const weekdays = [
    'الأحد',
    'الاتنين',
    'التلات',
    'الأربع',
    'الخميس',
    'الجمعة',
    'السبت',
  ];
  static const weekdaysShort = [
    'أحد',
    'اتنين',
    'تلات',
    'أربع',
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
