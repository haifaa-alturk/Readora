# Deferred Integrations Tracking

This document tracks all cross-feature references, commented-out code, TODOs, and deferred functionality that must be addressed in future integration phases.

---

## 1. Library → Individual Challenge (Explicitly Deferred)

**File:** `lib/features/library/presentation/screens/library_screen.dart`

| Line(s) | Current State | Functionality | Required Step |
|---------|--------------|---------------|---------------|
| 8 | `// import 'package:library_app1/features/individual_challenge/presentation/individual_challenge_entry.dart'; // TODO: uncomment when Individual Challenge is integrated` | Import for Individual Challenge entry point | Phase 3.2 (Individual Challenge integration) |
| 313-318 | Commented-out `TextButton.icon` with `onPressed: () => openIndividualChallengeFlow(context, bookId: book.id, bookTitle: book.title)` | "Take the Challenge" button for completed books | Phase 3.2 (Individual Challenge integration) |

**Status:** ✅ RESOLVED as of commit 766ef25 (Individual Challenge integration). The import on line 8 and the TextButton.icon call (previously lines 313-318) in library_screen.dart have been uncommented and are now active.

---

## 2. Library → Individual Challenge (Data Source)

**File:** `lib/features/library/data/datasources/library_remote_datasource.dart`

| Line(s) | Current State | Functionality | Required Step |
|---------|--------------|---------------|---------------|
| 22 | `// TODO: confirm real library endpoint with backend team` | Mock data fallback comment | When real backend is available |

---

## 3. Interests → Backend Endpoints

**File:** `lib/features/interests/data/datasources/interests_remote_datasource.dart`

| Line(s) | Current State | Functionality | Required Step |
|---------|--------------|---------------|---------------|
| 23 | `// TODO: confirm real interests endpoints with backend team` | Mock data fallback comment | When real backend is available |
| 47 | `// TODO: confirm real interests endpoints with backend team` | Mock data fallback comment | When real backend is available |

---

## 4. Wallet → Backend Endpoints

**File:** `lib/features/wallet/data/datasources/wallet_remote_datasource.dart`

| Line(s) | Current State | Functionality | Required Step |
|---------|--------------|---------------|---------------|
| 23 | `// TODO: confirm real wallet endpoints with backend team` | Mock data fallback comment | When real backend is available |
| 35 | `// TODO: confirm real wallet endpoints with backend team` | Mock data fallback comment | When real backend is available |

---

## 5. Wallet Model

**File:** `lib/features/wallet/data/models/wallet_model.dart`

| Line(s) | Current State | Functionality | Required Step |
|---------|--------------|---------------|---------------|
| 11 | `balance: (json['balance'] as num?)?.toDouble() ?? 0.0,` | Parse balance with fallback | Ensure backend returns correct type |

---

## 6. Points → Backend Endpoints

**File:** `lib/features/points/data/datasources/points_remote_datasource.dart`

| Line(s) | Current State | Functionality | Required Step |
|---------|--------------|---------------|---------------|
| 32 | `// TODO: confirm real points endpoints with backend team` | Mock data fallback comment | When real backend is available |

---

## 7. Points Entity (Source Types)

**File:** `lib/features/points/domain/entities/points_history_entry_entity.dart`

| Line(s) | Current State | Functionality | Required Step |
|---------|--------------|---------------|---------------|
| 3 | `/// Currently valid sources: 'Quiz', 'Reward', and 'Challenge'` | Source type enum/documentation | Confirm with backend when Challenge source is implemented |

---

## 8. Wins → Backend Endpoints

**File:** `lib/features/wins/data/datasources/wins_remote_datasource.dart`

| Line(s) | Current State | Functionality | Required Step |
|---------|--------------|---------------|---------------|
| 34 | `// import 'package:dev3/core/network/endpoints.dart' shows Endpoints.wins` | Commented endpoint reference | When real backend is available |

---

## 8. Settings → Backend Endpoints

**File:** `lib/features/settings/data/datasources/settings_remote_datasource.dart`

| Line(s) | Current State | Functionality | Required Step |
|---------|--------------|---------------|---------------|
| 25 | `// TODO: confirm real settings endpoints with backend team` | Mock data fallback comment | When real backend is available |
| 39 | `// TODO: confirm real settings endpoints with backend team` | Mock data fallback comment | When real backend is available |

---

## 9. Settings Screen → Dark Mode & Language

**File:** `lib/features/settings/presentation/screens/settings_screen.dart`

| Line(s) | Current State | Functionality | Required Step |
|---------|--------------|---------------|---------------|
| 257-265 | `_buildRowTile` for "Dark Mode" with subtitle "Coming soon" — not implemented | Dark mode toggle | When theming supports dark mode switching |
| 263-265 | `_buildRowTile` for "Language" with subtitle "English" — not changeable | Language picker | When multi-language support is implemented |

---

## 10. Profile Model

**File:** `lib/features/profile/data/models/profile_model.dart`

| Line(s) | Current State | Functionality | Required Step |
|---------|--------------|---------------|---------------|
| 21 | `if (imagePath != null) 'image_path': imagePath,` | Conditional image path serialization | Ensure backend handles optional field |

---

## 11. Purchase History Model

**File:** `lib/features/profile/data/models/purchase_history_model.dart`

| Line(s) | Current State | Functionality | Required Step |
|---------|--------------|---------------|---------------|
| 17 | `purchaseDate: json['purchase_date'] != null ? DateTime.parse(json['purchase_date'] as String) : DateTime.now(),` | Fallback date parsing | Ensure backend returns valid dates |

---

## 12. Library → Individual Challenge (Data Source)

**File:** `lib/features/library/data/datasources/library_remote_datasource.dart`

| Line(s) | Current State | Functionality | Required Step |
|---------|--------------|---------------|---------------|
| 22 | `// TODO: confirm real library endpoint with backend team` | Mock data fallback comment | When real backend is available |

---

## Summary of Deferred Items by Category

| Category | Count | Details |
|----------|-------|---------|
| **Explicit Cross-Feature Dependencies (commented out)** | 1 | Library → Individual Challenge (import + call site) |
| **Backend Endpoint TODOs** | 9 | Interests (2), Wallet (2), Points (1), Wins (1), Settings (2), Library (1) |
| **UI Placeholders (Coming Soon)** | 2 | Settings: Dark Mode, Language |
| **Documentation/Source Type Notes** | 2 | Points source types, Profile image path |
| **Model Fallback Parsing** | 1 | Purchase History date fallback |

**Total Deferred Items: 15**

---

## Priority Order for Resolution

1. **High** — Library → Individual Challenge (blocked on Phase 3.2)
2. **High** — Settings Dark Mode & Language (user-facing features)
3. **Medium** — Backend Endpoint TODOs (blocked on backend team)
4. **Low** — Documentation notes & fallback parsing (cleanup items)

---

*Last Updated: $(Get-Date -Format "yyyy-MM-dd")*
*Generated during Readora ← dev3 integration*