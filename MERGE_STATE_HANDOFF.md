# Readora ← dev3 Merge — State Handoff Document

**Purpose of this document:** This is the authoritative, verified state of an in-progress Flutter project merge. A previous session ran out of usable context (long conversation, degraded reliability, streaming failures, repeated loops on simple fixes). This document replaces that conversation history. Treat everything in this document as verified fact, established by direct file inspection and command output during the previous session — not as an unverified claim.

You (the AI assistant reading this) are continuing this merge. Read this entire document before taking any action. Do not re-derive decisions already made here — apply them. Where this document says a step is "done," verify it with one quick command if you like, but do not redo the work.

---

## 1. Project Overview

- **Readora** (package name `library_app1`) — the production Flutter app, source of truth. Located at the project root you're working in.
- **dev3** (package name `dev3`) — a separate feature project. Its `lib/` folder contains 11 features being merged into Readora one at a time. dev3 itself is never run or kept as an app — only its Dart source is copied in, adapted, and merged.
- **Governing rules:** Readora's architecture, UI, theme, navigation structure, and existing features must not be changed except at specific, pre-approved integration seams (listed in Section 5). dev3 is adapted to fit Readora, never the reverse, unless truly unavoidable — and "truly unavoidable" requires stopping and asking, not deciding unilaterally.
- **Process discipline (critical, repeatedly violated and corrected in the prior session — do not repeat these mistakes):**
  1. Work one step at a time. After each step, stop and report: what changed, how to verify it, how to roll it back, and any risk — then wait for explicit approval before continuing.
  2. Never report a verification as "✅ Complete" without pasting the actual, raw command output. A conclusion without pasted evidence is not acceptable and was a repeated problem in the prior session.
  3. When fixing a bracket/parenthesis/brace mismatch error, do not guess-and-check repeatedly. Explicitly count opening vs. closing delimiters in the relevant block before editing, identify the exact missing/extra one, then make one precise edit. The prior session got stuck for hours in a guess-and-check loop on exactly this kind of error (twice) — do not repeat this. If you cannot resolve it in 1-2 targeted attempts, stop and describe the exact bracket structure you see, rather than continuing to retry blindly.
  4. Before wiring anything to a screen, confirm that screen is actually reachable via navigation (grep for where its class name is instantiated/navigated to). The prior session once tried to wire a stub button in a dead, unreferenced file (`book_details_screen.dart`) instead of the real, live file (`book_details_page.dart`) — see Section 6 for the correct file.
  5. Do not assume a dev3 feature's internal folder structure matches other features. Profile's original dev3 structure had bloc files under a flat `bloc/` folder (not `presentation/bloc/` like every other feature) — this was caught and fixed, see Section 4.

---

## 2. Git State (verified via `git log --oneline` and `git status`)

The repository is **10 commits ahead of `origin/main`** as of the end of the prior session. In order:

1. `fix: lower Dart SDK constraint to >=3.9.0 <4.0.0` — pubspec.yaml environment fix + Step 0.1 additions (google_fonts, font_awesome_flutter, shared_preferences bump). See Section 3 for why.
2. `feat: add dev3 core infrastructure (network_dev3, mock_dev3, theme_dev3)`
3. `feat: integrate dev3 Quotes feature`
4. `feat: integrate dev3 Interests feature`
5. `feat: integrate dev3 Wallet feature`
6. `feat: integrate dev3 Points feature`
7. `feat: integrate dev3 Wins feature`
8. `feat: integrate dev3 Settings feature`
9. `feat: integrate dev3 Library (personal reading list) feature`
10. `fix: manually correct bracket mismatch in edit_profile_screen and purchase_history_screen` — this commit also contains ALL of the Profile feature's files (they were untracked until this commit; the commit message undersells it — it's really "complete Profile feature integration, including the bracket fixes").

**Possible pending, unconfirmed step:** at the end of the prior session, `git status` showed `lib/main.dart` and four platform-generated plugin registrant files (`linux/`, `macos/`, `windows/`) as modified, plus `DEFERRED_INTEGRATIONS.md` as untracked — all uncommitted. The user was instructed to run:
```
git add lib/main.dart linux/ macos/ windows/ DEFERRED_INTEGRATIONS.md
git commit -m "feat: complete Profile integration - wire providers into main.dart"
```
**Verify with `git status` first.** If this commit exists, Profile is fully committed and closed. If not, do this commit before anything else.

---

## 3. The SDK Fix (why it exists, don't revert it)

Readora's committed `pubspec.yaml` (predating any dev3 work) had `environment: sdk: ^3.10.7`, which the installed Flutter (3.35.1, bundling Dart 3.9.0) could not satisfy — this blocked `flutter analyze`/`flutter pub get` entirely and had nothing to do with dev3. It was fixed by lowering the constraint to `sdk: ">=3.9.0 <4.0.0"`. Confirmed `flutter_lints ^6.0.0` (added for dev3 integration) only requires Dart 3.8+, so no dependency conflict. This fix is correct and permanent — do not raise the SDK constraint again unless a genuine new dependency requires it, and if so, stop and confirm before changing it.

---

## 4. The Four Genuine Conflicts — Resolutions Already Applied (do not re-decide these)

1. **Package name mismatch:** every `package:dev3/...` import string is replaced with `package:library_app1/...` as files are copied in. Purely mechanical, already applied to all 8 integrated features.
2. **ApiClient shape mismatch:** dev3's ApiClient was brought in as its own separate class (`Dev3ApiClient`) under `lib/core/network_dev3/api_client.dart`, alongside `lib/core/network_dev3/endpoints.dart`. Readora's own `lib/core/api/api_client.dart` is untouched and still used by Readora's original features (Home, Library catalog, Book Details, Auth). Both ApiClient classes coexist permanently — this is correct, not a temporary hack.
3. **flutter_bloc version mismatch:** unified on Readora's `flutter_bloc: ^9.1.1` / `bloc: ^9.2.0`. dev3's original `^8.1.3` constraint was dropped. Verified working via `flutter analyze` across all integrated features.
4. **Parallel "Library" feature implementations (class-name collision):** dev3's personal reading-list Library feature was copied to `lib/features/library/` (its original name, NOT renamed). Readora's own catalog Library lives at `lib/features/home/presentation/bloc/Library_Bloc/` and `lib/features/home/presentation/pages/Library_view.dart` — different path, so no folder collision. Where a single file needs both, import aliasing is used: `as personal_library` / `as catalog_library`. Neither implementation was renamed at its source.

**Provider placement rule (mandatory, applies to every feature):** All dev3 Blocs and Repositories are added to Readora's **root** provider tree in `lib/main.dart` (wrapping `MyApp`), alongside the pre-existing `AuthBloc`, `HomeBloc`, `BookDetailsBloc`. Never scope a dev3 provider narrowly to a single tab or screen — several dev3 screens use `Navigator.push` + `BlocProvider.value(value: context.read<XBloc>(), ...)`, which requires the Bloc to be an ancestor of the app's single shared Navigator (i.e., provided at root).

---

## 5. Confirmed Cross-Feature Dependencies (verified via direct import inspection — do not re-derive)

- **Independent** (no cross-feature bloc reads): Quotes, Interests, Wallet, Points, Wins, Settings, Library. All 7 are integrated and committed (Section 2).
- **Profile:** independent at the Bloc level, but its main screen (`ProfileMainScreen`) navigates to all of the above via `BlocProvider.value`, so all of their Blocs must already be at root before Profile is wired in. Integrated and committed.
- **Group Challenge** (not yet integrated — this is the next step): its presentation layer reads `ProfileBloc`, `PointsBloc`, and `WinsBloc`. All three are already integrated, so Group Challenge can proceed now.
- **Individual Challenge** (not yet integrated): its entry-point flow (`openIndividualChallengeFlow`, in `individual_challenge_entry.dart`) reads `WinsBloc`, `PointsBloc`, and `GroupChallengeBloc`. Must be integrated **after** Group Challenge.
- **Known forward reference:** `lib/features/library/presentation/screens/library_screen.dart` (already integrated) contains a commented-out import of `individual_challenge_entry.dart` and a commented-out call to `openIndividualChallengeFlow` (originally around line 8 and lines 313-318 in dev3's source). This was intentionally commented out because Individual Challenge doesn't exist yet in Readora. **This must be uncommented once Individual Challenge is integrated** — it's tracked in `DEFERRED_INTEGRATIONS.md` at the project root. Don't forget this step; it's easy to miss since it's just a comment sitting in an already-committed file.

---

## 6. Navigation Wiring Plan (Phase 4 — not started yet, do not do this until Group Challenge and Individual Challenge are both integrated and verified)

- Readora's bottom nav (`lib/features/home/presentation/pages/main_screen.dart`) has 5 tabs: Home(0), Favorites(1), Library catalog(2), **Account(3) — currently a placeholder `Center(child: Text("حسابي"))`**, **Events(4) — currently a placeholder `Center(child: Text("مسابقات"))`**.
- Account tab body → replace with `ProfileMainScreen()`.
- Events tab body → replace with the Group Challenge screen (once integrated).
- Do NOT change tab count, order, icons, or labels.
- **Book Details integration point — IMPORTANT, a past mistake to not repeat:** there are TWO similarly-named files in Readora:
  - `lib/features/book_details/presentation/pages/book_details_screen.dart` — this is **dead code**, a `StatelessWidget`, never navigated to anywhere in the app, has zero Bloc usage. **Do not touch this file for navigation wiring.**
  - `lib/features/home/presentation/pages/book_details_page.dart`, class `BookDetailsPage` — this is the **real, live screen**, a `StatefulWidget`, reached from `lib/features/home/presentation/widgets/book_card.dart` (which navigates to `BookDetailsPage(bookId: book.id, ...)`), already wired to `BookDetailsBloc` via `BlocBuilder`. It has an existing empty "Read Preview" button (`onPressed: () {}`) inside the `if (state is BookDetailsLoaded)` block, where a local variable `book` (type `BookDetails`, with a `.bookName` field) is already in scope. **This is the correct file to wire** `openIndividualChallengeFlow(context, bookId: widget.bookId, bookTitle: book.bookName)` into, once Individual Challenge is integrated.

---

## 7. Remaining Work, In Order

1. **Group Challenge** (Phase 3.1) — next step. Copy `dev3/lib/features/group_challenge/` → `lib/features/group_challenge/`. Check first whether its bloc files are under `presentation/bloc/` or a flat `bloc/` folder in dev3's original source (don't assume — Profile was the exception, not the rule, but verify anyway). Add `BlocProvider<GroupChallengeBloc>` to root in `main.dart`. Verify with `flutter analyze lib/features/group_challenge/` — paste full raw output. Do not wire it into the Events tab yet.
2. **Individual Challenge** (Phase 3.2) — after Group Challenge is verified. Only a `RepositoryProvider<IndividualChallengeRepositoryInterface>` goes at root — there is no root-level `IndividualChallengeBloc`; it's created locally per-quiz-session inside `individual_challenge_entry.dart`. Once integrated, uncomment the reference in `library_screen.dart` (Section 5).
3. **Navigation wiring** (Phase 4) — Account tab, Events tab, and the `book_details_page.dart` "Read Preview" button (Section 6). Only after steps 1-2 are fully verified.
4. **Final cleanup phase** (separate, explicitly requested later, not yet started) — remove dev3's own `main.dart`, `bottom_nav_test_shell.dart`, `pubspec.yaml`, and native folders. These live only in the original dev3 project folder and were never copied into Readora — nothing to delete from Readora itself, this is just about the source dev3 folder once everything is confirmed working.

---

## 8. Reference Files to Check When Resuming

- `DEFERRED_INTEGRATIONS.md` (project root) — list of intentionally-deferred items, including the Library → Individual Challenge reference (Section 5) and various "confirm real endpoint with backend team" TODOs left over from dev3's original source (harmless, they're inside `if (!useMockData)` branches that never execute since `useMockData` stays `true`).
- `flutter analyze` at HEAD (full project) should show **0 errors**, roughly 88 issues total, all `info`/`warning` — a mix of pre-existing Readora lint issues (unrelated to this merge) and minor lint issues in the newly integrated dev3 code (unused imports, deprecated `withOpacity`, etc.). None of these are blocking; they don't need to be fixed as part of this merge unless you're asked to do a lint cleanup pass separately.

---

## 9. First Action for This New Session

1. Run `git log --oneline -15` and `git status` and confirm they match Section 2.
2. Run `flutter analyze` and confirm 0 errors, output roughly matching Section 8.
3. Report both results back before doing anything else — do not start Group Challenge until this baseline is confirmed to still match.