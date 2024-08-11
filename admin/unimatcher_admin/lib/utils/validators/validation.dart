class UMValidators {
  static String? validateName(String value) {
    if (value.isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  static String? validateImageUrl(String value) {
    if (value.isEmpty) {
      return 'Image URL cannot be empty';
    }
    return null;
  }

  static String? validateRanking(String value) {
    if (value.isEmpty) {
      return 'Ranking cannot be empty';
    }
    return null;
  }

  static String? validateProvinceValue(String value) {
    if (value.isEmpty) {
      return 'Province value cannot be empty';
    }
    return null;
  }

  static String? validateSectorValue(String value) {
    if (value.isEmpty) {
      return 'Sector value cannot be empty';
    }
    return null;
  }

  static String? validateHostelValue(String value) {
    if (value.isEmpty) {
      return 'Hostel value cannot be empty';
    }
    return null;
  }

  static String? validateSportsValue(String value) {
    if (value.isEmpty) {
      return 'Sports value cannot be empty';
    }
    return null;
  }

  static String? validateCoEducationValue(String value) {
    if (value.isEmpty) {
      return 'Co-education value cannot be empty';
    }
    return null;
  }

  static String? validateScholarshipValue(String value) {
    if (value.isEmpty) {
      return 'Scholarship value cannot be empty';
    }
    return null;
  }

  static String? validateCityValues(List<String> values) {
    if (values.isEmpty) {
      return 'City values cannot be empty';
    }
    return null;
  }

  static String? validateTransportValue(String value) {
    if (value.isEmpty) {
      return 'Transport value cannot be empty';
    }
    return null;
  }

  static String? validateAdmissionCriteria(String value) {
    if (value.isEmpty) {
      return 'Admission criteria cannot be empty';
    }
    return null;
  }

  static String? validateWiFiValue(String value) {
    if (value.isEmpty) {
      return 'WiFi value cannot be empty';
    }
    return null;
  }

  static String? validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return 'Phone number cannot be empty';
    } else if (value.length != 11) {
      return 'Phone number must be 11 digits';
    }
    return null;
  }

  static String? validateApplyOnlineLink(String value) {
    if (value.isEmpty) {
      return 'Apply online link cannot be empty';
    }
    return null;
  }

  static String? validateDegreeValues(Map<String, String> values) {
    if (values.isEmpty) {
      return 'Degree values cannot be empty';
    }
    return null;
  }
}
