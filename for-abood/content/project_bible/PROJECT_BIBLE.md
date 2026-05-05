# Okuma Dedektifi — Project Bible

**Owner:** Ali Sağlam / Villa Akademia, Bursa, Turkey  
**Stack:** Expo SDK 55 · React Native 0.83 · Supabase · TypeScript  
**App:** Turkish phonological awareness for kids 5–12 (dyslexia / autism / speech delays)

This document is the single source of truth for understanding, editing, debugging, and shipping this project — written so you can move without anyone's help.

---

## Table of Contents

1. [What This App Actually Does](#1-what-this-app-actually-does)
2. [How the Code Is Organized](#2-how-the-code-is-organized)
3. [How Data Flows](#3-how-data-flows)
4. [The Database — Every Table Explained](#4-the-database)
5. [The Three Roles and What They Can Do](#5-the-three-roles)
6. [The Module System — How Sessions Work](#6-the-module-system)
7. [The Auth System — How Login Works](#7-the-auth-system)
8. [The Freemium System — Who Can Do What](#8-the-freemium-system)
9. [The Character System](#9-the-character-system)
10. [How to Edit Common Things](#10-how-to-edit-common-things)
11. [How to Debug Common Errors](#11-how-to-debug-common-errors)
12. [Technical Decisions and Why](#12-technical-decisions-and-why)
13. [Things I Know Are Wrong or Incomplete](#13-things-i-know-are-wrong-or-incomplete)
14. [What to Improve Next](#14-what-to-improve-next)
15. [Environment Variables and Secrets](#15-environment-variables-and-secrets)
16. [Deployment Checklist](#16-deployment-checklist)

---

## 1. What This App Actually Does

A Turkish child opens the app and plays vocabulary games. Each game is called a **module**. A module is a question type — "pick the rhyming word," "tap the syllables," "say the word into the mic," etc. Each session is 10–20 questions pulled from a word bank of 393+ Turkish words across 22 categories.

The child earns XP, levels up, dresses a character, and builds a streak. A teacher can assign sessions, monitor progress, and generate a PDF report. An admin manages the word bank, categories, and character assets.

That is the whole app. Everything else is infrastructure to support this.

---

## 2. How the Code Is Organized

```
Reading-Detective/
├── app/                    ← Every screen file (Expo Router)
│   ├── _layout.tsx         ← Root — boot, auth routing, role decisions
│   ├── (auth)/             ← Login, register, role choice, teacher signup
│   ├── (onboarding)/       ← Student age + avatar picker (first time)
│   ├── (tabs)/             ← Student app: Home / Learn / Character / Profile
│   ├── teacher/            ← Teacher app: Students / Preview / Settings
│   ├── admin/              ← Admin app: Dashboard / Content / Analytics etc.
│   ├── session/            ← Quiz play screen + result screen
│   ├── learn/              ← Category detail screen
│   └── paywall/            ← Subscription screen
│
├── src/
│   ├── store/              ← Zustand global state
│   │   ├── auth.ts         ← Who is logged in + profile + role
│   │   └── session.ts      ← Current quiz session state machine
│   ├── domain/             ← Business logic (no UI, no network)
│   │   ├── modules/        ← All 24 module definitions + question generators
│   │   ├── repositories/   ← Content repository (words + categories)
│   │   └── types.ts        ← Word, Category, Question, ModuleDefinition etc.
│   ├── lib/
│   │   ├── supabase.ts     ← The Supabase client (one instance)
│   │   ├── access-tier.ts  ← Freemium logic (who can access what)
│   │   ├── purchases.ts    ← RevenueCat wrapper
│   │   ├── notifications.ts← Push token registration
│   │   └── offline-cache.ts← AsyncStorage cache for words/categories
│   ├── components/         ← Reusable UI
│   │   ├── session/        ← Question components (MultipleChoice, Builder, Mic)
│   │   ├── character/      ← Character renderer
│   │   ├── common/         ← AdminPreviewBanner, shared UI
│   │   └── teacher/        ← WordEditor (shared between teacher+admin)
│   ├── audio/              ← TTS playback + mic recording
│   └── i18n/               ← Turkish strings (t() function)
│
└── supabase/
    ├── migrations/         ← SQL files 001–011 (run in order)
    └── functions/          ← Edge Functions (Deno/TypeScript, run on server)
        ├── generate-tts/   ← Calls Google TTS, saves mp3 to Storage
        ├── evaluate-pronunciation/ ← Calls Whisper, returns similarity
        ├── generate-pdf-report/    ← Returns HTML for client to convert
        ├── send-push/      ← Sends Expo push notification
        └── validate-subscription/ ← Syncs RevenueCat status to DB
```

**The alias `@/` maps to `src/`.** So `import { supabase } from '@/lib/supabase'` reads `src/lib/supabase.ts`. This is set in `tsconfig.json`.

---

## 3. How Data Flows

### When the app launches

```
app/_layout.tsx
  → useAuth.initialize()
    → supabase.auth.getSession()         (reads stored JWT from device)
    → if session: fetch profiles row     (get role, subscription_status, etc.)
    → set status (loading → authenticated / needsRoleChoice / etc.)
  → useProtectedRoute()                  (redirect to right screen based on status)
```

### When a student plays a session

```
User taps "Play" on a module
  → router.push('/session/tani')
    → app/session/[moduleId].tsx mounts
      → useSession.start('tani', { categoryId })
        → checks access tier (can they play this module?)
        → generateSession('tani', opts)   ← PURE function in src/domain
          → contentRepository.getAllWords()
            → checks AsyncStorage cache first
            → if miss: fetches from Supabase (words table)
          → module's generator function picks questions
          → returns Question[]
        → set state: status='ready', questions=[...]

User taps an answer
  → useSession.answer(chosen)
    → compares to question.correct
    → sets status='revealed', lastVerdict='correct'|'wrong'

User taps "Devam" (continue)
  → useSession.next()
    → if last question: status='finished'
    → else: status='ready', index++

Session finishes
  → router.replace('/session/result')
    → useSession.finish()
      → INSERT session_logs row
      → RPC award_xp(amount, reason, session_id)
      → RPC update_streak()
```

### When admin adds a new word

```
Admin fills WordEditor form → taps "Kaydet"
  → supabase.from('words').insert(payload)
  → fetch('/functions/v1/generate-tts', { word_id })   ← Edge Function
    → Edge Function: calls Google Cloud TTS API
    → uploads mp3 to Supabase Storage (bucket: 'word-audio')
    → updates words.audio_url with the public URL
  → contentRepository.invalidate()                     ← clears cache
```

### What is NOT in real-time

Everything pulls on demand. The app does not use Supabase Realtime for any live updates. When a teacher sends a notification, the student sees it as a push notification (if their device token is registered) and as an entry in the `notifications` table (next time they load). The student's session results appear in the teacher's student detail screen on next pull-to-refresh.

---

## 4. The Database

All migrations live in `supabase/migrations/`. Run them in numerical order. They are all idempotent (`CREATE TABLE IF NOT EXISTS`, `ON CONFLICT DO NOTHING`).

### profiles
One row per user. The master user table.

| Column | Type | Notes |
|---|---|---|
| id | uuid | FK to auth.users |
| email | text | |
| full_name | text | |
| role | text | `student` / `teacher` / `admin`. Locked by trigger after first set. |
| role_locked_at | timestamptz | When role was first chosen. Cannot change after this. |
| child_age | int | Students only |
| child_avatar_emoji | text | Students only, e.g. `🦁` |
| school_name | text | Teachers only |
| planned_students | int | Teachers only |
| subscription_status | text | `free` / `trial` / `active` / `student` / `expert` |
| subscription_expires | timestamptz | When trial ends |
| device_push_token | text | Expo push token, saved on login |

**Important:** `role` cannot be changed after `role_locked_at` is set. There is a DB trigger `lock_role_on_set` that enforces this. If you try to change someone's role via SQL, the trigger will let you ONLY IF `role_locked_at` is NULL. After that, it throws. To change an admin's role (emergency), you must drop the trigger first, make the change, then recreate it.

### categories
22 categories: animals, foods, household items, etc.

| Column | Type | Notes |
|---|---|---|
| id | uuid | |
| name | text | Turkish name |
| emoji | text | Display emoji |
| level | int | 0 = free, 1+ = premium |
| display_order | int | Sequence in UI |
| is_active | boolean | Soft delete |

### words
393+ Turkish words, each linked to one category.

| Column | Type | Notes |
|---|---|---|
| id | uuid | |
| category_id | uuid | FK to categories |
| word_text | text | e.g. `kalem` |
| emoji | text | Visual representation |
| syllables | text[] | e.g. `['ka','lem']` |
| syllable_count | int | |
| first_letter | text | For filtering |
| last_letter | text | For rhyme groups |
| rhyme_group | text | Last syllable, for rhyme modules |
| audio_url | text | Public URL to mp3 in Supabase Storage |
| is_active | boolean | Soft delete |

**Note on audio_url:** When null, the SpeakerButton component hides itself. After running `generate-tts` for a word, this column gets filled automatically.

### session_logs
One row per completed session.

| Column | Type | Notes |
|---|---|---|
| id | uuid | |
| student_id | uuid | FK to profiles |
| module_id | text | e.g. `tani` |
| questions_total | int | |
| questions_correct | int | |
| duration_seconds | int | |
| xp_earned | int | |
| word_ids | uuid[] | Which words appeared |
| assignment_id | uuid | Nullable, if session was from an assignment |

### student_character
One row per student. Tracks XP, level, streak, and equipped items.

| Column | Type | Notes |
|---|---|---|
| student_id | uuid | PK |
| total_xp | int | Never decreases |
| level | int | Computed from total_xp by `award_xp` RPC |
| current_streak | int | Days in a row |
| longest_streak | int | All-time best |
| last_active_date | date | Last day they completed a session |
| base_character_id | text | FK to characters_base |
| equipped_hat | text | FK to character_extras |
| equipped_shirt | text | FK to character_extras |
| equipped_shoes | text | FK to character_extras |
| equipped_acc | text | FK to character_extras |
| equipped_bg | text | FK to character_extras |

### characters_base
The 10 base animal characters. Currently all placeholders.

| Column | Type | Notes |
|---|---|---|
| id | text | e.g. `leo` (primary key, not uuid) |
| name | text | e.g. `Leo` |
| asset_url | text | `placeholder://leo` until admin uploads real art |
| asset_type | text | `svg` / `png` / `lottie` |
| unlock_xp | int | 0 = free from start |

### character_extra_categories
5 rows only: `hat`, `shirt`, `shoes`, `acc`, `bg`. These never change unless you add a new slot type.

### character_extras
Individual unlockable items per category. Currently empty — admin uploads via the Characters section.

### teacher_students
Many-to-many. Links teachers to their students.

| Column | Type |
|---|---|
| teacher_id | uuid |
| student_id | uuid |

### teacher_invites
Tracks invite-by-email attempts.

### teacher_preview_log
Tracks how many minutes each teacher has used "student preview mode" today. Trial teachers are capped at 20 min/day.

### assignments
Assignments from teacher to student.

| Column | Type | Notes |
|---|---|---|
| teacher_id | uuid | |
| student_id | uuid | |
| title | text | |
| module_ids | text[] | Which modules |
| word_ids | uuid[] | Which words |
| status | text | `assigned` / `completed` |

### notification_templates
7 prebuilt Turkish templates teachers pick from when sending a notification.

### notifications
In-app notification log. One row per sent notification.

### xp_ledger
Every XP transaction. Written by the `award_xp` RPC. Never manually insert here.

---

## 5. The Three Roles

### How the app decides which UI to show

```
app/_layout.tsx → useProtectedRoute()
  profile.role === 'admin'   → route to /admin  (6-tab layout)
  profile.role === 'teacher' → route to /teacher (3-tab layout)
  profile.role === 'student' → route to /(tabs)  (4-tab layout)
```

These are three completely separate apps sharing the same codebase.

### Student
- 4 tabs: Home / Learn / Character / Profile
- Can play sessions, earn XP, equip characters
- Profile shows subscription status + linked teacher
- Free tier: 5 modules, 8 words/category
- Trial (7 days): same as subscribed
- Subscribed: all modules

### Teacher
- 3 tabs: Students / Student Preview / Settings
- Can see their own students (only those linked via `teacher_students`)
- Can invite students by their registered email (calls `invite_student` RPC)
- Trial teachers: 1 student max, 20 min/day of student preview
- Student preview: enters student app with yellow "preview mode" banner at top
- Can assign homework, send push notifications (from 7 templates), generate PDF reports

### Admin
- 6 tabs: Dashboard / Teacher View / Student View / Content / Analytics / Settings
- Set via SQL: `UPDATE profiles SET role = 'admin' WHERE email = 'your@email.com';` (only works before `role_locked_at` is set, or before the lock trigger was added in migration 008)
- Can see ALL students and ALL teachers
- Can enter teacher view or student view (no time limits, full access)
- Cannot nest: entering teacher view does NOT let admin enter student view from there
- Content: full CRUD on words, categories, characters
- Analytics: chart of daily signups, sessions, subscription breakdown

### Admin preview mode (impersonation)

When admin enters teacher or student view, `useAuth.startImpersonation('teacher')` is called. This sets `impersonating` in the auth store. The root layout then routes them into the teacher/student screens. The `AdminPreviewBanner` component reads `impersonating` and shows the yellow bar. When they tap "Çık", `stopImpersonation()` is called, the banner disappears, and routing sends them back to `/admin`.

Critically: `setAdminPreviewTier('subscribed')` is called while impersonating. This overrides the freemium tier check so admins see the full app.

---

## 6. The Module System

This is the heart of the app. A **module** is a named question format. There are 24 total. All are defined in `src/domain/modules/modules.registry.ts`.

### Each module has:

```typescript
{
  id:              'tani',          // unique string ID, camelCase
  icon:            '🔍',
  title:           'Tanı',          // Turkish display name
  description:     '...',
  level:           1,               // 1–5 difficulty
  screenType:      'quiz',          // determines WHICH component renders questions
  generator:       genTani,         // function that creates Question[]
  requiresPremium: false,
}
```

### screenType values

| screenType | Component used | Description |
|---|---|---|
| `quiz` | `MultipleChoiceQuestion` | 4-tile multiple choice, most modules use this |
| `builder` | `BuilderQuestion` | Tap syllables to build a word |
| `pronunciation` | `PronunciationQuestion` | Hold mic, say the word |
| `memory` | ⚠️ not built yet | Memory grid game |
| `phoneme` | ⚠️ not built yet | Phoneme deletion/manipulation |

### How a question is generated

Each module has a `generator` function in `src/domain/modules/generators/`. These are **pure functions** — no network calls, no side effects. They take a word list and return `Question[]`.

```typescript
// Example: Tanı generator
function genTani(words: Word[], maxQ: number): Question[] {
  // Pick maxQ words randomly
  // For each word: make 3 distractor words (wrong answers)
  // Return { id, word, options: [correct, d1, d2, d3], correct }
}
```

### The session machine (src/store/session.ts)

```
idle
  ↓ start(moduleId, opts)
loading   ← generateSession() runs here (async fetch from contentRepository)
  ↓
ready     ← user sees a question
  ↓ answer(chosen)
revealed  ← user sees feedback (green/red), "Devam" button visible
  ↓ next()
ready     ← next question (loops back)
  ↓ (when last question answered)
finished  ← triggers router.replace('/session/result')
```

The result screen calls `finish()` once on mount which:
1. Inserts into `session_logs`
2. Calls `award_xp` RPC (XP = 10/correct + 20/session + 50 if perfect)
3. Calls `update_streak` RPC
4. If assignment: marks it completed

### How to add a new module (quiz type)

1. Write a generator in `src/domain/modules/generators/`
2. Add an entry to `MODULES_REGISTRY` in `modules.registry.ts`
3. Add its ID to `FREE_MODULE_IDS` in `src/lib/access-tier.ts` if it should be free
4. It will show up automatically in the category detail screen

### How to add a new module (new screen type)

1. Do all steps above
2. Also create a new component in `src/components/session/`
3. Add a new case to the `screenType` switch in `app/session/[moduleId].tsx`

---

## 7. The Auth System

### Status machine

The auth store (`src/store/auth.ts`) has these statuses:

```
loading
  ↓
unauthenticated       → /(auth)/welcome
awaitingEmailVerify   → /(auth)/verify-email
needsRoleChoice       → /(auth)/role-choice       ← NEW in Stage 12
needsTeacherSignup    → /(auth)/teacher-signup     ← NEW in Stage 12
needsOnboarding       → /(onboarding)/child-age   ← student only
authenticated         → role-based routing
```

### What "needs role choice" means

After a user verifies their email for the first time, `profiles.role` is NULL. The app catches this and sends them to the role choice screen. They pick student or teacher. The `chooseRole()` function updates `profiles.role` and sets `role_locked_at`. After that, the DB trigger prevents any future role change.

### Supabase auth setup

Supabase handles all the complexity:
- JWTs stored on device via `SecureStore` (the Supabase client manages this automatically)
- Email verification link → user returns to app → session resumes
- On every app launch: `getSession()` reads the stored JWT, auto-refreshes if expired

### If you need to manually set someone as admin

```sql
-- Only works if role_locked_at is NULL (user just registered)
UPDATE profiles SET role = 'admin' WHERE email = 'person@example.com';

-- If role_locked_at is already set, you must temporarily bypass the trigger:
ALTER TABLE profiles DISABLE TRIGGER trg_lock_role;
UPDATE profiles SET role = 'admin' WHERE email = 'person@example.com';
ALTER TABLE profiles ENABLE TRIGGER trg_lock_role;
```

---

## 8. The Freemium System

All access logic lives in one file: `src/lib/access-tier.ts`. Change it there and it applies everywhere.

### Tiers

| Tier | Who has it | Module access | Words/session |
|---|---|---|---|
| `admin` | Admin role, or impersonating | Everything | Unlimited |
| `subscribed` | Active subscription | All 24 modules | Unlimited |
| `trial` | Within 7-day trial window | All 24 modules | Unlimited |
| `free` | Trial expired OR never subscribed | 5 modules only | 8 words/category |

### The 5 free modules

Defined as `FREE_MODULE_IDS` in `access-tier.ts`:
- `tani` (recognize)
- `tamamla` (complete)
- `kategori` (category match)
- `uyak` (rhyme)
- `heceBirlestir` (syllable merge)

To change which modules are free, edit this set.

### How locking works in the UI

- **Learn tab:** categories with `level > 0` show a 🔒 badge. Tap → paywall
- **Category detail:** modules that `isModuleLocked(tier, module)` returns true for show a 🔒 badge. Tap → paywall
- **Session start:** `useSession.start()` checks `canPlayModule(tier, moduleId)`. If locked, sets `status='locked'`. The screen should handle this (currently shows an error message — could show a paywall redirect instead)

### RevenueCat + subscription syncing

RevenueCat handles the App Store / Play Store billing. After a purchase:
1. Client calls `purchasePackage(pkg)` from RevenueCat SDK
2. On success, client calls the `validate-subscription` Edge Function
3. Edge Function verifies the receipt with RevenueCat's server API
4. Updates `profiles.subscription_status` to `active` / `student` / `expert`

Until RevenueCat products are set up in App Store Connect / Play Console, the paywall shows a "Yakında" placeholder with a contact email. The button does NOT silently fail anymore.

---

## 9. The Character System

### How it works

Three tables:
1. `characters_base` — 10 animals (leo, mia, rex, etc.). Student picks ONE as their base.
2. `character_extra_categories` — 5 slots: hat, shirt, shoes, acc, bg.
3. `character_extras` — Unlockable items per category. Student can equip one per slot.

### Math

10 base characters × (5 slot combinations) = unlimited visual combinations, all rendered at runtime. You do NOT pre-generate images. The `CharacterRenderer` component layers the base PNG/SVG + up to 5 extra PNGs/SVGs on top of each other using absolute positioning.

### The placeholder problem

All 10 base characters currently have `asset_url = 'placeholder://leo'` etc. The renderer detects URLs starting with `placeholder://` and shows an emoji circle instead. To replace with real art:

1. Go to Admin → Content → Characters
2. Tap a character → "PNG/SVG dosyası seç" → pick your file → "Kaydet"
3. File uploads to Supabase Storage bucket `characters/`
4. `asset_url` in `characters_base` gets updated to the public URL
5. All instances of that character now show the real art

### XP unlock thresholds

| Character | XP needed |
|---|---|
| Leo, Mia | 0 (free from start) |
| Rex | 100 |
| Luna | 200 |
| Kai | 400 |
| Zoe | 700 |
| Finn | 1000 |
| Iris | 1500 |
| Blaze | 2500 |
| Yıldız | 5000 |

Change these in migration 010 or directly in the DB.

---

## 10. How to Edit Common Things

### Add a new word to the database

**Via Admin panel:** Admin → Content → Words → + Yeni Kelime → fill form → Kaydet. TTS audio generates automatically in the background.

**Via SQL directly:**
```sql
INSERT INTO words (category_id, word_text, emoji, syllables, syllable_count, first_letter, last_letter, rhyme_group, is_active)
VALUES (
  (SELECT id FROM categories WHERE name = 'Hayvanlar'),
  'kaplumbağa',
  '🐢',
  ARRAY['kap','lum','ba','ğa'],
  4,
  'k',
  'a',
  'ğa',
  true
);
-- Then manually trigger TTS:
-- Call generate-tts Edge Function with the new word's ID
```

### Change the trial period (7 days)

In Supabase SQL Editor — find where `subscription_expires` is set on new user creation. It's in the `handle_new_user` trigger function (migration 001 or 002). Change the interval there.

Or just update specific users:
```sql
UPDATE profiles
SET subscription_expires = now() + interval '14 days'
WHERE subscription_status = 'trial';
```

### Change XP rewards

In `src/store/session.ts`, find these constants at the top:
```typescript
const XP_PER_CORRECT      = 10;
const XP_PERFECT_BONUS    = 50;
const XP_SESSION_COMPLETE = 20;
```

### Change session length by age

In `src/store/session.ts`:
```typescript
const SESSION_LENGTH_BY_AGE = (age: number | null): number => {
  if (age == null) return 15;
  if (age <= 7)    return 10;   // ← change these
  if (age <= 10)   return 15;
  return 20;
};
```

### Add a notification template

In Supabase SQL Editor:
```sql
INSERT INTO notification_templates (id, title, body, display_order)
VALUES ('new_template', 'Başlık', 'Bildirim metni', 8);
```

Or via Admin → Content (not yet built — add to backlog).

### Change which modules are free

In `src/lib/access-tier.ts`:
```typescript
export const FREE_MODULE_IDS = new Set([
  'tani', 'tamamla', 'kategori', 'uyak', 'heceBirlestir',
  // add more IDs here
]);
```

### Update the paywall pricing display

The prices shown in the paywall come from RevenueCat's product configuration. They are NOT hardcoded. The `pkg.product.priceString` is what RevenueCat returns for the user's locale and currency. The ₺ prices in the teacher signup screen are just display estimates — not the actual charge amounts.

### Change app colors / fonts

In `src/theme/index.ts` (or wherever your theme file is from Stage 0). The colors are design tokens used throughout all components.

---

## 11. How to Debug Common Errors

### "Route is missing the required default export"

**Cause:** Metro bundled a file that crashed on import before it could export a component. The real error is earlier in the log.  
**Fix:** Look at the FIRST error in the log, not the "missing default export" warnings. Those are symptoms.

### MMKV TurboModules error

**Cause:** `react-native-mmkv@3.x` requires New Architecture (TurboModules), which Expo Go doesn't support.  
**Fix:** Replace `src/lib/offline-cache.ts` with the AsyncStorage version (see the fix file from Stage 5 bugfix session). The MMKV import at the module level crashes the entire module graph.

### "expo-notifications: Android Push removed from Expo Go"

**Cause:** Since Expo SDK 53, push notifications don't work in Expo Go on Android.  
**Fix:** Already fixed. `src/lib/notifications.ts` now checks `Constants.appOwnership === 'expo'` and skips registration in Expo Go. For real push testing, use a development build (`eas build --profile development`).

### Foreign key violation on migration 010

**Cause:** `student_character` was being updated to reference `characters_base.id = 'leo'` before `characters_base` had any rows.  
**Fix:** Already fixed. The seed insert now comes BEFORE the `UPDATE student_character` line.

### Supabase type errors (`never` type on table queries)

**Cause:** `@supabase/supabase-js` version 2.65+ breaks Expo's type resolution for RN.  
**Pin:** `"@supabase/supabase-js": "~2.55.0"` in package.json. Do NOT upgrade without running `npx tsc --noEmit` first.

### "Failed to evaluate pronunciation" error

**Cause:** The Whisper HuggingFace Space is cold-starting. Free tier spaces sleep after ~1 hour idle.  
**Fix:** First call after idle takes 10–30 seconds. Show a loading indicator ("Mikrofon ısınıyor..."). The `pronunciation.service.ts` doesn't retry — add a retry with a 30-second timeout if this is a frequent complaint.

### Paywall opens but shows nothing / crashes

**Cause:** RevenueCat is not initialized because API keys aren't set in `.env`.  
**Fix:** The paywall now shows a "Yakında" placeholder gracefully. To get real products: set `EXPO_PUBLIC_REVENUECAT_IOS` and `EXPO_PUBLIC_REVENUECAT_ANDROID` in your environment, and create the matching products in App Store Connect / Play Console.

### Student can't see teacher's assignments

**Cause:** The assignments table exists but there is no screen in the student app to view assignments. This is a known gap.  
**Fix:** Build a student assignments tab or a section in the home screen that queries `assignments WHERE student_id = current_user AND status = 'assigned'`.

### Nested VirtualizedList warning

**Cause:** A FlatList inside a ScrollView (React Native forbids this).  
**Fixed in:** `app/(tabs)/learn.tsx` and `app/admin/index.tsx` — both now use FlatList with `ListHeaderComponent` instead of a parent ScrollView.  
**If you see it again:** Find where you have `<ScrollView>...<FlatList>` and convert to `<FlatList ListHeaderComponent={<YourHeader />} data={...} />`.

---

## 12. Technical Decisions and Why

### Why Supabase and not a custom Node.js server

Supabase gives you PostgreSQL + auth + file storage + serverless functions + row-level security. For this app's scale, a custom Node.js server would mean paying for a server 24/7, managing TLS, writing auth from scratch, and handling database connections. Supabase's free tier covers the entire MVP. The only tradeoff is vendor lock-in — but the business logic lives in the app's `domain/` layer, not in Supabase. Migrating the backend would require rewriting the Edge Functions but nothing else.

### Why Expo Router (file-based routing) instead of React Navigation

Expo Router gives us typed routes, automatic deep linking, and convention-based navigation without boilerplate. The tradeoff is less control over transition animations and some edge cases with nested layouts. For this app it was the right call.

### Why Zustand instead of Redux

Zustand is 1KB, has no boilerplate, and is easy to read. Redux would have been overkill. The session machine and auth machine are the only complex states, and Zustand handles both cleanly.

### Why AsyncStorage for offline cache instead of SQLite or MMKV

MMKV requires New Architecture which Expo Go doesn't support. SQLite is heavy for ~500KB of JSON data. AsyncStorage is slow but only called once per session (cache-hit returns data synchronously from memory; AsyncStorage is just the persistence layer). For a future version with thousands of words, MMKV in a dev build would be worth it.

### Why RevenueCat instead of direct StoreKit/Billing

RevenueCat abstracts iOS + Android billing into one API. The alternative (implementing StoreKit 2 + Google Play Billing directly) is 2–3 weeks of work and requires testing on real devices with real accounts. RevenueCat's free tier covers up to $2,500 monthly tracked revenue which is plenty for launch.

### Why the session machine is Zustand (not server state)

Session state is local to the current play session. It doesn't need to be persisted, shared, or synchronized. Zustand with in-memory state is the right tool. Only when the session finishes does data go to the server (session_logs insert).

### Why questions are generated client-side

The word list is ~500KB of JSON. The generators are pure functions. Running them on-device means zero latency between tapping "Play" and seeing the first question. Server-side generation would add 300–1000ms per session start for no benefit.

### Why TTS is server-side (Edge Function)

The Google TTS API key must never be on the client. If it were in the app, anyone could extract the bundle and find the key. The Edge Function keeps the key secret and runs only when admin saves a new word.

### Why pronunciation scoring is server-side

Same reason — the Whisper model runs on HuggingFace (your private Space with a secret token). The secret token must not be in the app bundle.

### Why PDF is HTML-on-server, convert-on-client

Running headless Chromium in a Supabase Edge Function would exceed the memory limit and timeout. The Edge Function generates clean HTML, sends it to the client, and the client uses `expo-print` to convert it to PDF natively. This is fast and reliable. The downside: you can't store the PDF on the server (no URL to share). If that becomes a need, the alternative is a third-party HTML-to-PDF API like PDFShift.

---

## 13. Things I Know Are Wrong or Incomplete

Being honest here — these are real issues.

### 1. No student assignments screen
Teachers can create assignments and they get stored in the DB. But students have no UI to see or launch their assignments. The data is there — the screen is missing.

### 2. 7 novel module screens not built
Modules with `screenType: 'memory'`, `'phoneme'` show in the category list but produce an error when launched (the session screen falls through to a blank state). These include: `kelimeDizisi`, `siraliHatirla`, `fonemSilme`, `ilkHeceSilme`, `sonHeceSilme`. Build them in Stage 16.

### 3. Pronunciation module cold-start problem
First mic press after ~1 hour idle triggers a 10–30 second wait while HuggingFace warms up the Whisper container. There's no loading indicator for this. The user just sees a spinning wheel.

### 4. Trial expiry is not enforced in real-time
When a trial expires at midnight, the client doesn't know until next launch. A user mid-session when their trial expires can finish that session. This is intentional (we chose not to interrupt) but worth noting.

### 5. Teacher can only see their own students
This is correct by design (RLS policy). But if a teacher adds a student, then that student unlinks (`unlink_student` RPC), the teacher's student list just disappears them. There's no "pending" state or notification. The teacher has to re-invite.

### 6. PDF has no stored URL
PDF reports are generated, printed to a file on the device, and shared. They are not stored anywhere. If the teacher wants to send the PDF to a parent, they share it manually. There's no "PDF history" in the app.

### 7. Character art is all placeholders
All 10 characters show emoji circles. No real SVG/PNG art has been uploaded. The system is fully wired — it just needs the actual files.

### 8. Admin can't add notification templates from the UI
Templates are hardcoded in migration 011. To add more, you need to run SQL. A simple CRUD screen for templates is missing.

### 9. TypeScript paths inconsistency
Some files use `@/lib/supabase`, some use relative imports like `../../lib/supabase`. This causes confusion. The `tsconfig.json` paths should be `@/` → `src/`. Run `npx tsc --noEmit` to find and fix mismatches.

### 10. No Apple Sign-In
Apple requires that if you offer any social/third-party sign-in, you must also offer Sign in with Apple. We only have email/password, so we're okay for now. But if you ever add Google Sign-In, you must add Apple Sign-In at the same time.

### 11. The `test_templates` column in the database
This column exists from an early spec but was never used. It was meant for assignment templates teachers could save and reuse. The `assignments` table does not reference it. You can safely drop it:
```sql
ALTER TABLE profiles DROP COLUMN IF EXISTS test_templates;
```
Or leave it — it causes no harm.

---

## 14. What to Improve Next

In priority order:

### P0 — Must have before launch

**1. Build the student assignments screen**  
Query: `SELECT * FROM assignments WHERE student_id = $me AND status = 'assigned'`  
Show as cards on the home tab. Tapping one launches a session with `assignmentId` in the session options.

**2. Build the 7 missing module screens**  
`memory`, `phoneme`. Each needs a new React component and a case in `[moduleId].tsx`. Request Stage 16 to get these.

**3. Upload real character art**  
Log in as admin → Content → Characters → upload 10 base characters and at least some extras. Without this, the character tab looks bad.

**4. Set up RevenueCat**  
Create products in App Store Connect / Play Console → configure RevenueCat → add API keys to `.env`. Without this, the paywall shows "Yakında" forever.

**5. Write Privacy Policy + Terms of Service**  
Required by both stores. Must mention: email collection, child age collection, voice recording (for pronunciation), data deletion request process.

### P1 — Important before growing

**6. Apple Sign-In**  
If you add any social login, Apple requires Apple Sign-In. For now, email-only is fine.

**7. Real-time assignment notification**  
When teacher assigns homework → student gets a push notification and sees it in-app. The push infrastructure is built. You just need to call `send-push` from the assignment creation flow.

**8. Analytics improvements**  
The admin analytics screen shows basic stats. A teacher-specific analytics screen (per-student progress over time, accuracy per module) would be valuable. The data is all in `session_logs`.

**9. Offline mode**  
Currently the app fails gracefully when offline (shows cached data or empty states). Sessions cannot be completed offline because `session_logs` is inserted on finish. A write queue (Zustand persist + AsyncStorage) would allow offline sessions that sync when connectivity returns.

**10. Performance — word list caching**  
The word list (393 words) is fetched from Supabase and cached in AsyncStorage for 24 hours. This is fine for now. If the word bank grows to 2000+ words, consider paginating by category instead of fetching everything upfront.

---

## 15. Environment Variables and Secrets

### Client-side (safe to expose, prefix with EXPO_PUBLIC_)

```bash
EXPO_PUBLIC_SUPABASE_URL=https://xxxx.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=eyJ...    # The anon key, NOT the service role key
EXPO_PUBLIC_REVENUECAT_IOS=appl_xxx
EXPO_PUBLIC_REVENUECAT_ANDROID=goog_xxx
```

These go in `.env` in the project root. Expo injects them at build time. They are visible in the app bundle — that's okay because they're designed to be public. Security comes from Supabase RLS and RevenueCat's receipt validation, not from hiding these keys.

### Server-side (NEVER in .env, set as Supabase Edge Function secrets)

In Supabase Dashboard → Edge Functions → Manage Secrets:

```
SUPABASE_SERVICE_ROLE_KEY    ← admin database access for Edge Functions
GOOGLE_TTS_API_KEY           ← Google Cloud TTS
WHISPER_HF_ENDPOINT          ← Your HuggingFace Space URL for Whisper
WHISPER_SECRET_TOKEN         ← Your Space's secret token
REVENUECAT_SECRET_KEY        ← RevenueCat server secret
```

If any of these leak, rotate them immediately. The service role key bypasses all RLS — it's essentially root access to your database.

---

## 16. Deployment Checklist

### Before every build

- [ ] `npx tsc --noEmit` — no TypeScript errors
- [ ] Test on real device (not Expo Go) for push notifications and audio
- [ ] Check that `.env` has all `EXPO_PUBLIC_` variables
- [ ] Verify Supabase Edge Function secrets are set

### First-time store setup (one time each)

**Apple:**
1. Apple Developer account ($99/year) at developer.apple.com
2. App Store Connect → New App → Bundle ID: `com.villaakademia.okumadedektifi`
3. Create 4 in-app purchases: `okuma_student_monthly`, `okuma_student_yearly`, `okuma_expert_monthly`, `okuma_expert_yearly`
4. Submit for "Designed for Kids" review — this adds extra review questions about COPPA

**Google:**
1. Google Play Console ($25 one-time) at play.google.com/console
2. Create app → Package: `com.villaakademia.okumadedektifi`
3. Set up "Family" content rating (for children's app)
4. Create matching in-app products

### EAS Build commands

```bash
# Development build (for testing push + audio on real device)
eas build --profile development --platform ios
eas build --profile development --platform android

# Preview build (for sharing with testers)
eas build --profile preview --platform ios    # → TestFlight
eas build --profile preview --platform android # → APK

# Production build (for store submission)
eas build --profile production --platform all

# Submit after building
eas submit --profile production --platform ios
eas submit --profile production --platform android
```

### Post-launch

- Monitor crash logs (Expo has basic crash reporting; for production add Sentry: `expo install sentry-expo`)
- Check Supabase dashboard for Edge Function errors (Dashboard → Edge Functions → Logs)
- Watch for "quota exceeded" on Google TTS API if many words are added in a short period

---

## Final Notes

This codebase was built in stages over several sessions. The architecture is sound, but some rough edges exist at the boundaries between stages (for example, some files still import from old paths, and the module system has gaps for novel screen types). The best way to navigate it is:

- **For data questions:** Start from the Supabase table.
- **For UI questions:** Start from the screen file in `app/`.
- **For business logic questions:** Start from `src/domain/`.
- **For access control questions:** Start from `src/lib/access-tier.ts`.
- **For auth flow questions:** Start from `src/store/auth.ts`.

The project is closer to launch than it might feel. The core learning loop (play sessions, earn XP, dress character) works end-to-end. The teacher-student system works. The admin content management works. What remains is art, store setup, and the 7 missing module screens.

Good luck.
