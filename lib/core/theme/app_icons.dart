import 'package:flutter/widgets.dart';

/// All icons in one place — Phosphor icon font (soft, rounded, consistent).
///
/// Declared as plain [IconData] so icons are NOT mirrored in Arabic (RTL):
/// a phone, ticket or clipboard must look the same in every language.
/// Only the arrow icons at the bottom mirror with the text direction.
///
/// To add an icon: find it on https://phosphoricons.com, then copy its code
/// point from `PhosphorIconsRegular.<name>` (or Fill / Bold) in the package.
abstract final class AppIcons {
  // Navigation
  static const IconData home = IconData(0xe2c2,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // house
  static const IconData homeFill =
      IconData(0xe2c2, fontFamily: 'PhosphorFill', fontPackage: _pkg); // house
  static const IconData search = IconData(0xe30c,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // magnifyingGlass
  static const IconData searchFill = IconData(0xe30c,
      fontFamily: 'PhosphorFill', fontPackage: _pkg); // magnifyingGlass
  static const IconData bookings = IconData(0xe490,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // ticket
  static const IconData bookingsFill =
      IconData(0xe490, fontFamily: 'PhosphorFill', fontPackage: _pkg); // ticket
  static const IconData profile = IconData(0xe4c2,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // user
  static const IconData profileFill =
      IconData(0xe4c2, fontFamily: 'PhosphorFill', fontPackage: _pkg); // user
  static const IconData today =
      IconData(0xe472, fontFamily: 'PhosphorRegular', fontPackage: _pkg); // sun
  static const IconData todayFill =
      IconData(0xe472, fontFamily: 'PhosphorFill', fontPackage: _pkg); // sun
  static const IconData week = IconData(0xe7b4,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // calendarDots
  static const IconData weekFill = IconData(0xe7b4,
      fontFamily: 'PhosphorFill', fontPackage: _pkg); // calendarDots
  static const IconData inbox = IconData(0xe4aa,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // tray
  static const IconData inboxFill =
      IconData(0xe4aa, fontFamily: 'PhosphorFill', fontPackage: _pkg); // tray
  static const IconData dropdown = IconData(0xe136,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // caretDown
  // Actions
  static const IconData close =
      IconData(0xe4f6, fontFamily: 'PhosphorRegular', fontPackage: _pkg); // x
  static const IconData check =
      IconData(0xe182, fontFamily: 'PhosphorBold', fontPackage: _pkg); // check
  static const IconData edit = IconData(0xe3b4,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // pencilSimple
  static const IconData delete = IconData(0xe4a6,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // trash
  static const IconData add = IconData(0xe3d4,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // plus
  static const IconData addPitch = IconData(0xe3d4,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // plus
  static const IconData addPhoto = IconData(0xec58,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // cameraPlus
  static const IconData send = IconData(0xe396,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // paperPlaneRight
  static const IconData filter = IconData(0xe434,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // slidersHorizontal
  static const IconData logout = IconData(0xe42a,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // signOut
  static const IconData call =
      IconData(0xe3b8, fontFamily: 'PhosphorFill', fontPackage: _pkg); // phone
  static const IconData directions = IconData(0xeade,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // navigationArrow
  static const IconData flag = IconData(0xe244,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // flag
  static const IconData tap = IconData(0xec90,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // handTap
  // Domain
  static const IconData ball = IconData(0xe716,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // soccerBall
  static const IconData pitch = IconData(0xe716,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // soccerBall
  static const IconData player = IconData(0xe730,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // personSimpleRun
  static const IconData owner = IconData(0xe470,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // storefront
  static const IconData team = IconData(0xe68e,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // usersThree
  static const IconData location = IconData(0xe316,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // mapPin
  static const IconData locationFill =
      IconData(0xe316, fontFamily: 'PhosphorFill', fontPackage: _pkg); // mapPin
  static const IconData distance = IconData(0xeade,
      fontFamily: 'PhosphorFill', fontPackage: _pkg); // navigationArrow
  static const IconData map = IconData(0xe31a,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // mapTrifold
  static const IconData list = IconData(0xe2f2,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // listBullets
  static const IconData money = IconData(0xe588,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // money
  static const IconData moneyFill =
      IconData(0xe588, fontFamily: 'PhosphorFill', fontPackage: _pkg); // money
  static const IconData clock = IconData(0xe19a,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // clock
  static const IconData duration = IconData(0xe492,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // timer
  static const IconData calendar = IconData(0xe10a,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // calendarBlank
  static const IconData calendarCheck = IconData(0xe712,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // calendarCheck
  static const IconData calendarX = IconData(0xe10c,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // calendarX
  static const IconData calendarPlus = IconData(0xe714,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // calendarPlus
  static const IconData ticket = IconData(0xe490,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // ticket
  static const IconData history = IconData(0xe1a0,
      fontFamily: 'PhosphorRegular',
      fontPackage: _pkg); // clockCounterClockwise
  static const IconData phone = IconData(0xe3b8,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // phone
  static const IconData mobile = IconData(0xe1e0,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // deviceMobile
  static const IconData sms = IconData(0xe16e,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // chatCircleText
  static const IconData lock = IconData(0xe308,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // lockSimple
  static const IconData lockOutline = IconData(0xe308,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // lockSimple
  static const IconData unlock = IconData(0xe30a,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // lockSimpleOpen
  static const IconData manual = IconData(0xe198,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // clipboardText
  static const IconData note = IconData(0xe348,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // note
  static const IconData closed = IconData(0xe61c,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // door
  static const IconData pending = IconData(0xe2b8,
      fontFamily: 'PhosphorFill', fontPackage: _pkg); // hourglassMedium
  static const IconData confirmed = IconData(0xe184,
      fontFamily: 'PhosphorFill', fontPackage: _pkg); // checkCircle
  static const IconData cancelled = IconData(0xe4f8,
      fontFamily: 'PhosphorFill', fontPackage: _pkg); // xCircle
  static const IconData verified = IconData(0xe606,
      fontFamily: 'PhosphorFill', fontPackage: _pkg); // sealCheck
  static const IconData bell = IconData(0xe0ce,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // bell
  static const IconData bellRinging = IconData(0xe5e8,
      fontFamily: 'PhosphorFill', fontPackage: _pkg); // bellRinging
  static const IconData info = IconData(0xe2ce,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // info
  static const IconData warning = IconData(0xe4e2,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // warningCircle
  static const IconData offline = IconData(0xe4f2,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // wifiSlash
  static const IconData policy = IconData(0xe40c,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // shieldCheck
  static const IconData language = IconData(0xe288,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // globe
  static const IconData support = IconData(0xe584,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // headset
  static const IconData terms = IconData(0xe23a,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // fileText
  static const IconData notFound = IconData(0xe30c,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // magnifyingGlass
  // Amenities
  static const IconData grass = IconData(0xebae,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // plant
  static const IconData lights = IconData(0xe2dc,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // lightbulb
  static const IconData toilets = IconData(0xe79a,
      fontFamily: 'PhosphorRegular', fontPackage: _pkg); // toilet
  static const IconData parking =
      IconData(0xe112, fontFamily: 'PhosphorRegular', fontPackage: _pkg); // car

  // Arrows — these DO mirror in RTL. Named in LTR terms: on an Arabic screen
  // "forward" points left and "back" points right.
  static const IconData forward = IconData(0xe13a,
      fontFamily: 'PhosphorRegular',
      fontPackage: _pkg,
      matchTextDirection: true); // caretRight
  static const IconData backward = IconData(0xe138,
      fontFamily: 'PhosphorRegular',
      fontPackage: _pkg,
      matchTextDirection: true); // caretLeft
  static const IconData back = IconData(0xe058,
      fontFamily: 'PhosphorRegular',
      fontPackage: _pkg,
      matchTextDirection: true); // arrowLeft

  static const _pkg = 'phosphor_flutter';
}
