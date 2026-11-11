import 'package:flutter/widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// All icons in one place (Phosphor — soft, rounded, consistent).
/// `R` = regular (outline), `F` = fill (selected / emphasis).
abstract final class AppIcons {
  // Navigation
  static const IconData home = PhosphorIconsRegular.house;
  static const IconData homeFill = PhosphorIconsFill.house;
  static const IconData search = PhosphorIconsRegular.magnifyingGlass;
  static const IconData searchFill = PhosphorIconsFill.magnifyingGlass;
  static const IconData bookings = PhosphorIconsRegular.ticket;
  static const IconData bookingsFill = PhosphorIconsFill.ticket;
  static const IconData profile = PhosphorIconsRegular.user;
  static const IconData profileFill = PhosphorIconsFill.user;
  static const IconData today = PhosphorIconsRegular.sun;
  static const IconData todayFill = PhosphorIconsFill.sun;
  static const IconData week = PhosphorIconsRegular.calendarDots;
  static const IconData weekFill = PhosphorIconsFill.calendarDots;
  static const IconData inbox = PhosphorIconsRegular.tray;
  static const IconData inboxFill = PhosphorIconsFill.tray;

  // Arrows. Phosphor icons mirror automatically in RTL, so these use LTR
  // names: "forward" is drawn pointing left on screen.
  static const IconData forward = PhosphorIconsRegular.caretRight;
  static const IconData backward = PhosphorIconsRegular.caretLeft;
  static const IconData back = PhosphorIconsRegular.arrowLeft;
  static const IconData dropdown = PhosphorIconsRegular.caretDown;

  // Actions
  static const IconData close = PhosphorIconsRegular.x;
  static const IconData check = PhosphorIconsBold.check;
  static const IconData edit = PhosphorIconsRegular.pencilSimple;
  static const IconData delete = PhosphorIconsRegular.trash;
  static const IconData add = PhosphorIconsRegular.plusCircle;
  static const IconData addPitch = PhosphorIconsRegular.plus;
  static const IconData addPhoto = PhosphorIconsRegular.cameraPlus;
  static const IconData send = PhosphorIconsRegular.paperPlaneRight;
  static const IconData filter = PhosphorIconsRegular.slidersHorizontal;
  static const IconData logout = PhosphorIconsRegular.signOut;
  static const IconData call = PhosphorIconsFill.phone;
  static const IconData directions = PhosphorIconsRegular.navigationArrow;
  static const IconData flag = PhosphorIconsRegular.flag;
  static const IconData tap = PhosphorIconsRegular.handTap;

  // Domain
  static const IconData ball = PhosphorIconsRegular.soccerBall;
  static const IconData pitch = PhosphorIconsRegular.soccerBall;
  static const IconData player = PhosphorIconsRegular.personSimpleRun;
  static const IconData owner = PhosphorIconsRegular.storefront;
  static const IconData team = PhosphorIconsRegular.usersThree;
  static const IconData location = PhosphorIconsRegular.mapPin;
  static const IconData locationFill = PhosphorIconsFill.mapPin;
  static const IconData distance = PhosphorIconsFill.navigationArrow;
  static const IconData map = PhosphorIconsRegular.mapTrifold;
  static const IconData list = PhosphorIconsRegular.listBullets;
  static const IconData money = PhosphorIconsRegular.money;
  static const IconData moneyFill = PhosphorIconsFill.money;
  static const IconData clock = PhosphorIconsRegular.clock;
  static const IconData duration = PhosphorIconsRegular.timer;
  static const IconData calendar = PhosphorIconsRegular.calendarBlank;
  static const IconData calendarCheck = PhosphorIconsRegular.calendarCheck;
  static const IconData calendarX = PhosphorIconsRegular.calendarX;
  static const IconData calendarPlus = PhosphorIconsRegular.calendarPlus;
  static const IconData ticket = PhosphorIconsRegular.ticket;
  static const IconData history = PhosphorIconsRegular.clockCounterClockwise;
  static const IconData phone = PhosphorIconsRegular.phone;
  static const IconData mobile = PhosphorIconsRegular.deviceMobile;
  static const IconData sms = PhosphorIconsRegular.chatCircleText;
  static const IconData lock = PhosphorIconsFill.lock;
  static const IconData lockOutline = PhosphorIconsRegular.lock;
  static const IconData unlock = PhosphorIconsRegular.lockOpen;
  static const IconData manual = PhosphorIconsRegular.notePencil;
  static const IconData note = PhosphorIconsRegular.note;
  static const IconData closed = PhosphorIconsRegular.door;
  static const IconData pending = PhosphorIconsFill.hourglassMedium;
  static const IconData confirmed = PhosphorIconsFill.checkCircle;
  static const IconData cancelled = PhosphorIconsFill.xCircle;
  static const IconData verified = PhosphorIconsFill.sealCheck;
  static const IconData bell = PhosphorIconsRegular.bell;
  static const IconData bellRinging = PhosphorIconsFill.bellRinging;
  static const IconData info = PhosphorIconsRegular.info;
  static const IconData warning = PhosphorIconsRegular.warningCircle;
  static const IconData offline = PhosphorIconsRegular.wifiSlash;
  static const IconData policy = PhosphorIconsRegular.shieldCheck;
  static const IconData language = PhosphorIconsRegular.globe;
  static const IconData support = PhosphorIconsRegular.headset;
  static const IconData terms = PhosphorIconsRegular.fileText;
  static const IconData notFound = PhosphorIconsRegular.magnifyingGlass;

  // Amenities
  static const IconData grass = PhosphorIconsRegular.plant;
  static const IconData lights = PhosphorIconsRegular.lightbulb;
  static const IconData toilets = PhosphorIconsRegular.toilet;
  static const IconData parking = PhosphorIconsRegular.car;
}
