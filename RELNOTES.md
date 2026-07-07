# DNSThemeObjects Release Notes

All notable changes to DNSThemeObjects are documented here. Versions follow [Semantic Versioning](https://semver.org/).

---

## 1.12.2 — 2026-07-07

**Release Type**
-   MAINTENANCE

**Issues Resolved**
-   XDNS-0012 — Aligned the AnimatedField dependency to 3.2.2 to match the version resolved by downstream apps. AnimatedField 3.1.1+ moved title/text-field setup into `format.didSet -> setupTitle()`; building and validating against 3.2.2 ensures the DNS style path (`AnimatedField+dnsApplyStyle.swift`) drives the field format correctly on the version apps actually ship. Supports the companion DNSForm field-cell visibility fix.

**New Features**
-   NONE

**Technical Improvements**
-   Bumped `AnimatedField` from `.upToNextMajor(from: "3.0.0")` to `.upToNextMajor(from: "3.2.2")` (transitively pulls `swift-mask-textfield` 1.2.0). No source changes; the existing `dnsApply` / `updateForState` style path already assigns `format` and requires no bridge.

**Known Problems**
-   The `DNSThemeObjectsTests` unit-test target does not compile under the Xcode 27 / iOS 27 SDK toolchain due to Swift 6 strict-concurrency (`@MainActor`) checking on UIKit and AnimatedField 3.2.2. This is test-only, pre-existing toolchain tech debt — the shippable library builds cleanly and consumers are unaffected. Tracked separately for Swift 6 test-suite readiness.

---
