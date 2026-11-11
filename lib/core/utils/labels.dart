import 'package:flutter/material.dart';
import 'package:ma3adna/core/theme/app_icons.dart';

import '../../data/models/models.dart';
import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';

/// Maps domain enums to Arabic labels, icons and colors.
extension PitchTypeLabel on PitchType {
  String get label => switch (this) {
        PitchType.fiveASide => S.fiveASide,
        PitchType.sevenASide => S.sevenASide,
      };
}

extension AmenityLabel on Amenity {
  String get label => switch (this) {
        Amenity.artificialGrass => S.amenityTurf,
        Amenity.lighting => S.amenityLights,
        Amenity.toilets => S.amenityToilets,
        Amenity.parking => S.amenityParking,
      };

  IconData get icon => switch (this) {
        Amenity.artificialGrass => AppIcons.grass,
        Amenity.lighting => AppIcons.lights,
        Amenity.toilets => AppIcons.toilets,
        Amenity.parking => AppIcons.parking,
      };
}

extension BookingStatusLabel on BookingStatus {
  String get label => switch (this) {
        BookingStatus.pending => S.statusPending,
        BookingStatus.confirmed => S.statusConfirmed,
        BookingStatus.cancelled => S.statusCancelled,
        BookingStatus.completed => S.statusCompleted,
      };

  Color get color => switch (this) {
        BookingStatus.pending => AppColors.pending,
        BookingStatus.confirmed => AppColors.success,
        BookingStatus.cancelled => AppColors.error,
        BookingStatus.completed => AppColors.inkMuted,
      };

  Color get background => switch (this) {
        BookingStatus.pending => AppColors.warningLight,
        BookingStatus.confirmed => AppColors.successLight,
        BookingStatus.cancelled => AppColors.errorLight,
        BookingStatus.completed => AppColors.slotBlockedBg,
      };

  IconData get icon => switch (this) {
        BookingStatus.pending => AppIcons.pending,
        BookingStatus.confirmed => AppIcons.confirmed,
        BookingStatus.cancelled => AppIcons.cancelled,
        BookingStatus.completed => AppIcons.ball,
      };
}

extension SlotStateStyle on SlotState {
  String get label => switch (this) {
        SlotState.available => S.legendAvailable,
        SlotState.appBooked => S.legendBooked,
        SlotState.manualBooked => S.legendManual,
        SlotState.blocked => S.legendBlocked,
      };

  Color get color => switch (this) {
        SlotState.available => AppColors.slotAvailable,
        SlotState.appBooked => AppColors.slotApp,
        SlotState.manualBooked => AppColors.slotManual,
        SlotState.blocked => AppColors.slotBlocked,
      };

  Color get background => switch (this) {
        SlotState.available => AppColors.slotAvailableBg,
        SlotState.appBooked => AppColors.slotAppBg,
        SlotState.manualBooked => AppColors.slotManualBg,
        SlotState.blocked => AppColors.slotBlockedBg,
      };

  IconData get icon => switch (this) {
        SlotState.available => AppIcons.add,
        SlotState.appBooked => AppIcons.mobile,
        SlotState.manualBooked => AppIcons.manual,
        SlotState.blocked => AppIcons.lock,
      };
}
