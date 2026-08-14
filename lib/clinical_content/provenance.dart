// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

enum SignOffDecision { approved, rejected, superseded }

class ClinicalSource {
  const ClinicalSource({
    required this.id,
    required this.title,
    required this.publisher,
    required this.version,
    required this.url,
    required this.publishedOn,
    required this.accessedOn,
  });

  final String id;
  final String title;
  final String publisher;
  final String version;
  final Uri url;
  final DateTime publishedOn;
  final DateTime accessedOn;
}

class ClinicalSignOff {
  const ClinicalSignOff({
    required this.reviewer,
    required this.role,
    required this.decision,
    required this.signedOn,
  });

  final String reviewer;
  final String role;
  final SignOffDecision decision;
  final DateTime signedOn;
}

class ReviewWindow {
  const ReviewWindow({required this.reviewedOn, required this.reviewDueOn});

  final DateTime reviewedOn;
  final DateTime reviewDueOn;

  bool isCurrentOn(DateTime date) => !date.isAfter(reviewDueOn);
}

class ClinicalApplicability {
  const ClinicalApplicability({
    required this.population,
    required this.intendedUsers,
    required this.careSetting,
    required this.exclusions,
  });

  final String population;
  final String intendedUsers;
  final String careSetting;
  final List<String> exclusions;
}
