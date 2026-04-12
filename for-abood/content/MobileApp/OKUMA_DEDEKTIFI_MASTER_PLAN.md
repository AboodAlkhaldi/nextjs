# OKUMA DEDEKTİFİ — MASTER SYSTEM PLAN
## Complete Blueprint for Mobile Application Development
**Version 2.0 | Villa Akademia | Ali Sağlam | 2026**

---

> **How to use this document:**  
> This is the single source of truth for building the Okuma Dedektifi mobile application.  
> Every architectural decision, technology choice, feature boundary, and design rule is documented here.  
> For AI coding agents: read every section before writing code.  
> For developers: deviate only when technically necessary, and document why.

---

## TABLE OF CONTENTS

1. [What We Are Building](#1-what-we-are-building)
2. [The Existing Prototype — What We Inherit](#2-the-existing-prototype)
3. [Technology Stack](#3-technology-stack)
4. [Architecture Philosophy](#4-architecture-philosophy)
5. [File Structure](#5-file-structure)
6. [Design System & UI Language](#6-design-system--ui-language)
7. [The Avatar Character System](#7-the-avatar-character-system)
8. [Learning Journey & Pedagogy](#8-learning-journey--pedagogy)
9. [Feature Map — Free vs Premium](#9-feature-map--free-vs-premium)
10. [Monetization Strategy](#10-monetization-strategy)
11. [Module System — All 24 Modules](#11-module-system--all-24-modules)
12. [Database Schema](#12-database-schema)
13. [Authentication & Roles](#13-authentication--roles)
14. [Teacher Panel Features](#14-teacher-panel-features)
15. [Audio System](#15-audio-system)
16. [Notification System](#16-notification-system)
17. [PDF Report System](#17-pdf-report-system)
18. [Offline Behavior](#18-offline-behavior)
19. [MVP Scope](#19-mvp-scope)
20. [Extension Points — Open/Closed Principle](#20-extension-points)
21. [Coding Standards](#21-coding-standards)

---

## 1. WHAT WE ARE BUILDING

**Okuma Dedektifi** (Reading Detective) is a Turkish-language mobile application for children aged 5–12 who have dyslexia, autism, speech delays, or general reading difficulties. It is also used by special education specialists and supportive parents.

### The Core Mission

The app teaches phonological awareness — the ability to hear, identify, and manipulate sounds in words. This is the single most evidence-backed intervention for reading difficulties. Every module in the app targets a specific, scientifically defined phonological skill.

### What Makes This Different

- Built on the actual curriculum of a working special education professional (Ali Sağlam, Villa Akademia)
- The word "dyslexia" never appears in the UI — the app is for "reading detectives," not labeled children
- Game-first design: every session feels like play, not therapy
- The avatar character grows with the child — motivation is visual and continuous
- Teacher panel allows clinicians to assign targeted homework and track real progress
- Scientific references are embedded in the module descriptions for professional credibility

### Two User Types, One App

```
TEACHER / ADMIN
└── Manages students, assigns homework, tracks progress,
    adds new words and categories, generates reports

STUDENT (two subtypes)
├── Linked to Teacher → sees homework tab, teacher tracks them
└── Independent → full features, parent monitors via reports
```

### Revenue Model Summary

The app is free to download. Content is gated behind subscription plans. The teacher management panel is a separate subscription tier.

---

## 2. THE EXISTING PROTOTYPE

The teacher provided a complete working HTML prototype. Before writing any React Native code, understand what has already been built and validated with real children.

### What Exists (fonoloji-atolyesi.html + okuma-dedektifi.html)

**Word Bank:** 402 Turkish words across 22 categories. Each word has:
- `word`: Turkish text
- `kat`: category name
- `syl[]`: syllable array e.g. `["ka","lem"]`
- `n`: syllable count
- `first`: first letter/sound
- `last`: last letter/sound
- `rk`: rhyme group (null if not part of a rhyme group)
- `emoji`: fallback emoji if no SVG exists

**SVG Library:** 82 hand-drawn SVG illustrations for common words (objects, places with Turkish labels). All SVGs are embedded as inline strings in a JSON object.

**24 Modules:** Each module has:
- `id`: routing key
- `icon`: emoji
- `baslik`: Turkish title
- `aciklama`: short description
- `bilim`: scientific justification with academic references
- `aile`: home support suggestion for parents
- `renk`: hex color for theming
- `level`: 0–5 pedagogical level
- `tip`: screen type (`quiz`, `yapim`, `kesfet`, `gorsel`, `bellek`, `fonemSilme`)
- `gen`: generator function `(words) => questions[]`

**localStorage Key:** `okuma_dedektifi_log` — session records, max 500, FIFO

**Progress Report:** Built-in weekly/all-time report with module filter, RAN speed tracking, level breakdown, PDF print.

### What to Carry Forward As-Is

| HTML Prototype | React Native Equivalent | Notes |
|---|---|---|
| WORDS array | Direct import as TypeScript constant | 402 words, unchanged |
| MODULLER array | Direct import, add new fields | Add `isNew`, `requiresPremium` |
| SVG JSON | `<SvgXml>` from react-native-svg | `dangerouslySetInnerHTML` → `xml={}` |
| Generator functions | Direct import (pure JS/TS) | `shuffle`, `genUyak`, etc. unchanged |
| localStorage log | AsyncStorage with same key structure | Keep same field names |
| `yanlisSplitler()` | Direct import | Turkish syllable error logic |
| Adaptive difficulty (Bellek) | Direct port | Min 2, Max 7, 3-correct threshold |

### What to Build New (Not in Prototype)

- Avatar character system (dress-up, XP, animation)
- Authentication (Supabase Auth with email verification)
- Teacher panel (student management, homework assignment)
- Audio TTS per word (Google Cloud TTS)
- Microphone pronunciation evaluation (Whisper API)
- Push notifications (Expo Notifications)
- In-app subscription (RevenueCat)
- Cloud progress sync (Supabase)
- Offline caching (expo-sqlite + MMKV)
- Two learning modes: Learn (never repeat) + Revision (only learned words)
- Milestone tests (every 50 learned words)
- Multi-profile support (multiple children per device)

---

## 3. TECHNOLOGY STACK

### Mobile Framework

```
React Native + Expo SDK (latest stable)
Language: TypeScript — no .js files anywhere
Navigation: Expo Router (file-based, v3+)
```

**Why Expo over bare React Native:** Expo handles iOS/Android build complexity, provides managed audio/camera/notification APIs, and allows OTA updates without App Store review cycles. The trade-off (slightly larger bundle) is acceptable for this use case.

### Backend

```
Supabase
├── PostgreSQL database
├── Auth (email/password + email verification)
├── Storage (audio files, avatars)
├── Edge Functions (Deno, TypeScript)
└── Realtime (homework completion notifications)
```

### Key Libraries

```
State:          Zustand + TanStack Query (React Query)
Animation:      Reanimated 3 (UI) + Lottie (character)
Audio playback: expo-av
Audio recording: expo-av (recording mode)
SVG:            react-native-svg + SvgXml
TTS:            Google Cloud Text-to-Speech API (tr-TR-Wavenet-B)
Speech eval:    OpenAI Whisper API (via Edge Function only)
Subscriptions:  RevenueCat (react-native-purchases)
Push notifs:    Expo Notifications
PDF:            react-native-html-to-pdf
Offline KV:     react-native-mmkv
Offline DB:     expo-sqlite
Fonts:          expo-google-fonts (Nunito + Fredoka One)
Icons:          expo-vector-icons (Ionicons)
Haptics:        expo-haptics
```

### Why These Choices

**RevenueCat** — handles iOS App Store and Google Play billing with one unified API. Managing StoreKit and Google Billing directly is a months-long project. RevenueCat reduces it to hours.

**Zustand over Redux** — simpler API, less boilerplate, works well with TanStack Query for server state. No need for Redux's overhead for this app's state complexity.

**Lottie** — the only way to ship smooth 60fps character animations on both iOS and Android without a game engine. Animators export `.lottie` files; developers just play them.

**TanStack Query** — handles caching, background refetch, loading states, and error states for all Supabase data fetching. Eliminates 80% of data-fetching boilerplate.

---

## 4. ARCHITECTURE PHILOSOPHY

### Open/Closed Principle (Your Core Requirement)

The system must be **open for extension, closed for modification.** This means:

- Adding a new exercise module requires zero changes to existing screen code
- Adding a new word category requires zero code changes
- Adding a new avatar item requires zero code changes
- Adding a new subscription tier requires zero code changes in the app

This is achieved through **data-driven design**: modules, items, and categories are records in the database or entries in a typed configuration object. The screens are generic renderers, not module-specific code.

### Architecture Layers

```
┌─────────────────────────────────────────────────────┐
│                 PRESENTATION LAYER                  │
│  Screens, Components, Hooks (React Native + Expo)   │
│  Knows nothing about Supabase directly              │
├─────────────────────────────────────────────────────┤
│                 APPLICATION LAYER                   │
│  Use Cases: completeWord(), submitHomework(),        │
│  generateTest(), awardXP()                          │
│  Orchestrates domain logic                          │
├─────────────────────────────────────────────────────┤
│                   DOMAIN LAYER                      │
│  Types, interfaces, pure business rules             │
│  Word, Student, Module, XPTransaction               │
│  Zero external dependencies                         │
├─────────────────────────────────────────────────────┤
│               INFRASTRUCTURE LAYER                  │
│  Supabase client, AsyncStorage, MMKV,               │
│  RevenueCat, TTS API, Whisper API                   │
│  Implements domain interfaces                       │
└─────────────────────────────────────────────────────┘
```

**The rule:** Dependencies point inward. Domain never imports from Infrastructure. Presentation never calls Supabase directly.

### Module Registration Pattern

Every exercise module is registered in a single `MODULES_REGISTRY` object. To add a new module:

1. Write the generator function in `src/domain/generators/`
2. Add one entry to `MODULES_REGISTRY` in `src/domain/modules.registry.ts`
3. Done. The home screen, progress tracking, and teacher panel all pick it up automatically.

```typescript
// src/domain/modules.registry.ts
export const MODULES_REGISTRY: ModuleDefinition[] = [
  {
    id: 'hecele',
    icon: '✂️',
    title: 'Hecele!',
    description: 'Doğru hecelemeyi seç',
    science: '...',
    familyTip: '...',
    color: '#7c3aed',
    level: 2,
    screenType: 'quiz',
    generator: genHecele,
    requiresPremium: false,
    isNew: false,
  },
  // Add new modules here — nothing else needs to change
];
```

---

## 5. FILE STRUCTURE

```
okuma-dedektifi/
├── app/                          # Expo Router screens
│   ├── _layout.tsx               # Root layout, auth gate
│   ├── (auth)/
│   │   ├── login.tsx
│   │   ├── register.tsx
│   │   └── verify-email.tsx
│   ├── (student)/                # Student tab layout
│   │   ├── _layout.tsx
│   │   ├── home.tsx              # Character + XP + homework preview
│   │   ├── learn.tsx             # Learn mode (category picker)
│   │   ├── practice.tsx          # All modules grid
│   │   ├── progress.tsx          # Charts + PDF export
│   │   └── rewards.tsx           # Character dress-up + shop
│   ├── (teacher)/                # Teacher tab layout
│   │   ├── _layout.tsx
│   │   ├── dashboard.tsx
│   │   ├── students/
│   │   │   ├── index.tsx         # Student list
│   │   │   └── [id].tsx          # Student detail
│   │   ├── assignments/
│   │   │   ├── index.tsx
│   │   │   └── create.tsx
│   │   └── content/
│   │       ├── categories.tsx
│   │       └── words.tsx
│   ├── session/
│   │   ├── quiz.tsx              # Generic quiz screen
│   │   ├── builder.tsx           # Tile-drag builder (hece/harf birlestir)
│   │   ├── phoneme.tsx           # Keyboard input (fonem silme)
│   │   ├── memory.tsx            # Adaptive memory screens
│   │   ├── visual.tsx            # Visual perception grid
│   │   └── explore.tsx           # Kesfet carousel
│   └── result.tsx                # Session result screen
│
├── src/
│   ├── domain/                   # Pure business logic — NO external imports
│   │   ├── types.ts              # Word, Module, Student, XPTransaction etc.
│   │   ├── modules.registry.ts   # THE single list of all modules
│   │   ├── words.data.ts         # The 402-word bank (TypeScript)
│   │   ├── svg.data.ts           # The 82 SVG strings
│   │   └── generators/           # One file per module generator
│   │       ├── index.ts          # Re-exports all generators
│   │       ├── gen-kelime-tani.ts
│   │       ├── gen-hecele.ts
│   │       ├── gen-uyak.ts
│   │       ├── gen-ran.ts
│   │       ├── gen-fonem-silme.ts
│   │       └── ... (one file per module)
│   │
│   ├── application/              # Use cases — one function = one action
│   │   ├── words/
│   │   │   ├── complete-word.ts
│   │   │   ├── get-learn-queue.ts
│   │   │   └── get-revision-queue.ts
│   │   ├── sessions/
│   │   │   ├── save-session.ts
│   │   │   └── check-milestone.ts
│   │   ├── character/
│   │   │   ├── award-xp.ts
│   │   │   └── unlock-item.ts
│   │   ├── assignments/
│   │   │   ├── complete-assignment.ts
│   │   │   └── create-assignment.ts
│   │   └── reports/
│   │       └── generate-weekly-report.ts
│   │
│   ├── infrastructure/           # All external service calls
│   │   ├── supabase/
│   │   │   ├── client.ts         # Supabase client singleton
│   │   │   ├── words.repo.ts
│   │   │   ├── progress.repo.ts
│   │   │   ├── character.repo.ts
│   │   │   └── assignments.repo.ts
│   │   ├── audio/
│   │   │   ├── tts.service.ts    # Google TTS
│   │   │   ├── recorder.service.ts
│   │   │   └── whisper.service.ts
│   │   ├── revenuecat/
│   │   │   └── subscription.service.ts
│   │   └── storage/
│   │       ├── async-storage.ts
│   │       └── mmkv.ts
│   │
│   ├── presentation/             # Reusable UI components
│   │   ├── components/
│   │   │   ├── WordCard.tsx      # The core word display unit
│   │   │   ├── SvgWord.tsx       # SVG or emoji fallback
│   │   │   ├── ProgressBar.tsx
│   │   │   ├── XpBadge.tsx
│   │   │   ├── ModuleCard.tsx    # Home screen grid card
│   │   │   ├── StarRating.tsx    # 5-star result display
│   │   │   ├── CharacterView.tsx # Animated Lottie character
│   │   │   └── PremiumGate.tsx   # Paywall overlay
│   │   ├── hooks/
│   │   │   ├── useSession.ts     # Session state machine
│   │   │   ├── useProgress.ts    # Word progress queries
│   │   │   ├── useCharacter.ts   # XP + items
│   │   │   ├── useSubscription.ts
│   │   │   └── useAudio.ts
│   │   └── animations/
│   │       ├── spring-configs.ts  # Reanimated spring presets
│   │       ├── correct-answer.ts  # Star burst animation
│   │       └── wrong-answer.ts    # Shake animation
│   │
│   └── config/
│       ├── design-tokens.ts      # Colors, fonts, spacing (THE single source)
│       ├── subscription-tiers.ts # What each plan unlocks
│       └── xp-rules.ts           # XP amounts per action
│
├── supabase/
│   ├── migrations/               # SQL migration files (numbered)
│   │   ├── 001_initial_schema.sql
│   │   ├── 002_character_system.sql
│   │   └── 003_assignments.sql
│   └── functions/               # Edge Functions
│       ├── generate-tts/
│       ├── evaluate-pronunciation/
│       ├── check-milestone/
│       ├── send-notification/
│       ├── generate-report/
│       └── validate-subscription/
│
├── assets/
│   ├── lottie/                  # Character animation files
│   │   ├── character-idle.lottie
│   │   ├── character-happy.lottie
│   │   ├── character-celebrate.lottie
│   │   └── items/               # Equippable items (hat, shirt, shoes)
│   ├── fonts/
│   └── images/
│
└── docs/
    └── MASTER_PLAN.md           # This file
```

---

## 6. DESIGN SYSTEM & UI LANGUAGE

The entire app uses one design token file. Nothing is hardcoded in components.

### Color Palette

```typescript
// src/config/design-tokens.ts
export const colors = {
  // Primary brand
  primary:     '#6C63FF',  // soft purple — curiosity, imagination
  primaryDark: '#4A44CC',
  primaryLight:'#EDE9FF',

  // Actions & CTAs
  action:      '#FF8C69',  // warm orange — energy, fun

  // Feedback
  success:     '#52D68A',  // green — correct answers
  warning:     '#FFD166',  // golden — caution, streak
  error:       '#FF6B8A',  // soft pink-red — NEVER harsh red for children
  // Note: wrong answers use error, not red. Children with learning differences
  // have strong negative responses to red. This is a pedagogical decision.

  // Backgrounds
  background:  '#F7F3FF',  // very light purple tint
  surface:     '#FFFFFF',
  surfaceAlt:  '#F0ECFF',

  // Text
  textPrimary: '#2D2B55',  // dark purple-tinted
  textSecond:  '#6B6890',
  textMuted:   '#B0ACCC',

  // XP & rewards
  xpGold:      '#FFD700',
  xpGoldLight: '#FFF3B0',
  starFull:    '#F59E0B',
  starEmpty:   '#374151',

  // Levels (module card backgrounds)
  level0:      '#E0F2FE',  // sky blue
  level1:      '#DCFCE7',  // mint
  level2:      '#EDE9FE',  // lavender
  level3:      '#FEF3C7',  // cream
  level5:      '#FFF7ED',  // peach (RAN/fluency)
} as const;

export const spacing = {
  xs:  4,
  sm:  8,
  md:  16,
  lg:  24,
  xl:  32,
  xxl: 48,
} as const;

export const borderRadius = {
  sm:   8,
  md:   16,
  lg:   24,
  xl:   32,
  full: 9999,
} as const;

export const typography = {
  // Fredoka One for headings (friendly, round, child-readable)
  // Nunito for body (warm, rounded, excellent for dyslexia)
  childDisplay:  { fontSize: 32, fontFamily: 'FredokaOne', lineHeight: 40 },
  childHeading:  { fontSize: 22, fontFamily: 'FredokaOne', lineHeight: 28 },
  childBody:     { fontSize: 18, fontFamily: 'Nunito_700Bold', lineHeight: 26 },
  childSmall:    { fontSize: 14, fontFamily: 'Nunito_600SemiBold', lineHeight: 20 },
  wordDisplay:   { fontSize: 36, fontFamily: 'FredokaOne', letterSpacing: 4 },
  // letterSpacing: 4 helps dyslexic readers separate individual letters
} as const;

export const shadows = {
  card:    { shadowColor: '#2D2B55', shadowOffset: {width:0,height:4}, shadowOpacity:0.08, shadowRadius:12, elevation:4 },
  button:  { shadowColor: '#6C63FF', shadowOffset: {width:0,height:6}, shadowOpacity:0.25, shadowRadius:16, elevation:6 },
  none:    {},
} as const;
```

### Animation Rules (Non-Negotiable)

Every interactive element follows these rules. They are not optional.

**Button press:** Scale to 0.95 on press-in, spring back to 1.0 on release. Duration 100ms. Use `withSpring` from Reanimated 3.

**Correct answer:** 
1. Card border turns `colors.success` (120ms)
2. Scale to 1.08 then spring to 1.0 (200ms)
3. Star burst particles (5 stars, scatter upward, fade out, 400ms)
4. XP number floats up from card and fades (300ms)
5. Haptic feedback: `Haptics.notificationAsync(NotificationFeedbackType.Success)`

**Wrong answer:**
1. Card border turns `colors.error` (100ms)
2. Horizontal shake: 3 oscillations × 8px × 80ms each
3. Card resets to white border (500ms)
4. Encouraging text appears: randomly pick from ["Tekrar dene! 💪", "Neredeyse! 🌟", "Denemeye devam! ⭐"]
5. Haptic feedback: `Haptics.impactAsync(ImpactFeedbackStyle.Light)` — gentle, not jarring
6. NEVER show red. Use `colors.error` (soft pink-red)

**Screen transitions:** Slide from right on push, slide to right on back. Tab bar: fade cross-dissolve.

**Character reaction:** Every user interaction triggers a character reaction (see Section 7).

### Touch Target Rules

All tappable elements must be minimum 48×48pt. For children aged 5–8, option buttons should be minimum 80px height. This is both accessibility compliance and practical UX for small fingers.

---

## 7. THE AVATAR CHARACTER SYSTEM

The character is the emotional core of the app. It is always visible on the home screen and reacts to everything. This is the primary motivation loop for children.

### Character Concept

A friendly, genderless child-like character (similar energy to Subway Surfers runner but warmer and less urban). The character has:
- Body (base, never changes)
- 5 equipment slots: Hat, Shirt, Shoes, Accessory, Background
- Multiple animation states

### Animation States (Lottie files)

```
character-idle.lottie          — gentle breathing, slight head bob
character-happy.lottie         — small jump, arms raise
character-correct.lottie       — celebrates: spins, pumps fist
character-wrong.lottie         — head scratch, thinking pose
character-levelup.lottie       — full celebration: confetti, jumps
character-wave.lottie          — session complete, waves at screen
character-sleep.lottie         — idle for 30+ seconds: yawning, sleepy eyes
character-run.lottie           — used during loading screens
character-think.lottie         — during quiz before answer selected
```

### Trigger Map

```typescript
// src/config/character-triggers.ts
export const CHARACTER_TRIGGERS = {
  appOpen:          'character-happy',
  answerCorrect:    'character-correct',
  answerWrong:      'character-wrong',
  sessionComplete:  'character-wave',
  levelUp:          'character-levelup',
  itemUnlocked:     'character-levelup',
  homescreenIdle:   'character-idle',
  idleTimeout:      'character-sleep',   // after 30s of no interaction
  loadingScreen:    'character-run',
  thinkingTime:     'character-think',   // plays while question is displayed
} as const;
```

### XP System

```typescript
// src/config/xp-rules.ts
export const XP_RULES = {
  wordCorrect:           10,
  wordCorrectPronounce:  20,  // microphone correct
  sessionComplete:       30,
  sessionPerfect:        50,  // 100% score bonus
  assignmentComplete:    75,
  assignmentPerfect:     100,
  dailyLogin:            15,
  streak3Days:           30,
  streak7Days:           100,
  streak30Days:          300,
  milestoneTest:         80,
  milestoneTestPerfect:  150,
} as const;
```

### Unlock Thresholds

```typescript
// src/config/character-items.ts
// This is seeded data — also stored in Supabase for admin management
export const CHARACTER_ITEMS: CharacterItem[] = [
  // HATS
  { id: 'hat_detective',   type: 'hat',   name: 'Dedektif Şapkası',  unlockXp: 0,    rarity: 'common'    },
  { id: 'hat_crown',       type: 'hat',   name: 'Altın Taç',         unlockXp: 200,  rarity: 'rare'      },
  { id: 'hat_star',        type: 'hat',   name: 'Yıldız Kasketi',    unlockXp: 500,  rarity: 'rare'      },
  { id: 'hat_astronaut',   type: 'hat',   name: 'Astronot Kaskı',    unlockXp: 1200, rarity: 'legendary' },

  // SHIRTS
  { id: 'shirt_basic',     type: 'shirt', name: 'Dedektif Ceketi',   unlockXp: 0,    rarity: 'common'    },
  { id: 'shirt_cape',      type: 'shirt', name: 'Kahraman Pelerini', unlockXp: 150,  rarity: 'rare'      },
  { id: 'shirt_rainbow',   type: 'shirt', name: 'Gökkuşağı Gömlek',  unlockXp: 400,  rarity: 'rare'      },
  { id: 'shirt_galaxy',    type: 'shirt', name: 'Galaksi Zırhı',     unlockXp: 1000, rarity: 'legendary' },

  // SHOES
  { id: 'shoes_basic',     type: 'shoes', name: 'Koşu Ayakkabısı',   unlockXp: 0,    rarity: 'common'    },
  { id: 'shoes_rocket',    type: 'shoes', name: 'Roket Botu',        unlockXp: 300,  rarity: 'rare'      },
  { id: 'shoes_cloud',     type: 'shoes', name: 'Bulut Terliği',     unlockXp: 700,  rarity: 'rare'      },

  // ACCESSORIES
  { id: 'acc_magnifier',   type: 'acc',   name: 'Büyüteç',           unlockXp: 0,    rarity: 'common'    },
  { id: 'acc_wings',       type: 'acc',   name: 'Melek Kanatları',   unlockXp: 600,  rarity: 'legendary' },

  // BACKGROUNDS
  { id: 'bg_classroom',    type: 'bg',    name: 'Sınıf',             unlockXp: 0,    rarity: 'common'    },
  { id: 'bg_space',        type: 'bg',    name: 'Uzay',              unlockXp: 800,  rarity: 'rare'      },
  { id: 'bg_underwater',   type: 'bg',    name: 'Su Altı',           unlockXp: 1500, rarity: 'legendary' },
];
```

### Character Screen Layout

The character is displayed full-body (center screen) using a Lottie component. Four equipment slot buttons sit below it (Hat, Shirt, Shoes, Accessory). Tapping a slot opens a bottom sheet showing a grid of items. Unlocked items are full color and tappable. Locked items are grayscale with a lock icon and XP count. Equipping triggers `character-happy` animation + confetti.

---

## 8. LEARNING JOURNEY & PEDAGOGY

### The Two Learning Modes

**Learn Mode (Öğren)**

The student works through words they have never seen before. When they answer correctly, that word is marked `learned` and never appears in Learn Mode again. This is tracked per-student in `student_word_progress`.

```
student opens Learn Mode
    → fetch words WHERE status = 'unseen' (or null)
    → present in random order
    → correct answer → mark 'learned', award XP, check milestone
    → wrong answer → queue word to appear again before session ends
    → session ends when student exits or finishes all available words
```

**Revision Mode (Tekrar)**

The student practices only words they have already learned. Words appear randomly. Completing revision does not change word status — it only logs a session. Revision is always available and never blocked.

```
student opens Revision Mode
    → fetch words WHERE status = 'learned'
    → if fewer than 5 learned words: show message "Önce birkaç kelime öğren!"
    → present in random order, no status changes
    → logs session to session_logs
```

### Milestone Tests

Every 50 learned words triggers a test (configurable by admin). Tests are created by the teacher in the admin panel.

```
after marking a word as 'learned':
    count = SELECT COUNT(*) WHERE student_id = X AND status = 'learned'
    check: does any test_template have milestone_threshold <= count
            AND no student_milestone exists for this student+template?
    if yes → insert student_milestone (status: 'pending')
           → show notification: "🎯 Test zamanı! 50 kelime öğrendin!"
           → student cannot enter Learn Mode until test is completed
             (teacher can override this lock from admin panel)
```

### Pedagogical Level Sequence

Children should progress through levels in order, but free exploration is allowed.

```
Level 0 — Preparation
├── Visual Perception (Görsel Algı)
├── Explore (Keşfet)
├── Word Recognition (Kelime Tanıma)
└── Categorize (Kategorize Etme)

Level 1 — Letters
├── Letter Hunter (Harf Avcısı)
└── Sound Distinction (Sesleri Ayırt Et)
    — Pairs: b/d, b/p, d/t, k/g, ç/c, m/n, a/e, ı/i, o/u, ö/ü

Level 2 — Syllables & Memory
├── Syllable Builder (Hece Birleştir)
├── Syllable Counter (Hece Sayacı)
├── Syllabify! (Hecele!)
├── Find Last Syllable (Son Heceyi Bul)
├── Longest Word (En Uzun Kelime)
├── Word Sequence - B (Kelime Dizisi)   ← visual-verbal bridge
└── Sequential Memory - A (Sıralı Hatırla) ← visual working memory

Level 3 — Phonemes & Advanced
├── Letter Builder (Harf Birleştir)
├── Rhyme Game (Uyak Oyunu)
├── First Sound (İlk Ses)
├── Last Sound (Son Ses)
├── Complete the Word (Kelimeyi Tamamla)   ← complete ending
├── Start the Word (Kelimeyi Başlat)       ← complete beginning
├── Rhyme Production (Uyak Üretimi)
├── Phoneme Deletion (Fonem Silme)         ← keyboard input
├── Remove First Syllable (İlk Heceyi Eksilt) ← keyboard input
└── Remove Last Syllable (Son Heceyi Eksilt)  ← keyboard input

Level 5 — Fluency
└── Rapid Naming (Hızlı İsimlendirme / RAN)
    — ms-precise timing, the strongest predictor of reading speed
```

### Motivation Loop Design

The core loop for a child session:
```
open app → see character (idle, happy to see you) 
         → check homework (if any, priority) or choose free play
         → answer questions → hear audio + see animation per answer
         → session ends → 5-star result screen → XP awarded
         → character animates based on score
         → check if new item unlocked → dress up if yes
         → see daily streak update
         → repeat tomorrow for streak bonus
```

The loop never ends. There is always something to do: more words to learn, revision to do, a test pending, a new item close to unlock, a streak to protect.

---

## 9. FEATURE MAP — FREE VS PREMIUM

### Free Plan (İncele — "Explore")

The free plan must be genuinely useful — not a demo. Children and parents must get real value and see real progress. The paywall should feel like an upgrade, not a fix for something broken.

```
FREE INCLUDES:
├── First 3 categories fully accessible (Hayvanlar, Meyveler, Renkler)
├── All Level 0 modules (Keşfet, Kelime Tanıma, Kategorize, Görsel Algı)
├── Level 1: Harf Avcısı only
├── Character system: base character + 3 starter items
├── Progress tracking: last 14 days
├── 1 language: Turkish
├── Basic PDF report (student version, 1 week)
└── Session history: last 20 sessions

FREE EXCLUDES:
├── All categories beyond the first 3
├── Levels 2, 3, 5 modules (syllable, phoneme, RAN work)
├── Audio pronunciation (TTS play button)
├── Microphone pronunciation evaluation
├── Full character item shop (all rare + legendary items)
├── Learn Mode tracking (words are not marked as 'learned' in DB)
├── Revision Mode
├── Milestone tests
├── Full progress history
├── Teacher linking (cannot link to a teacher account)
└── PDF export (teacher version)
```

### Premium — Öğrenci Paketi (Student Plan)

```
Monthly:  49 TRY / month
Yearly:  349 TRY / year (saves 240 TRY — show this clearly: "2 ay bedava!")
Family:  79 TRY / month (up to 3 child profiles on one account)

INCLUDES:
├── All 22 categories and 402 words
├── All 24 modules (all levels)
├── Learn Mode with full progress tracking
├── Revision Mode
├── Milestone tests
├── Audio TTS for every word (speaker button)
├── Microphone pronunciation evaluation
├── Full character system (all items)
├── Full progress history (unlimited)
├── PDF student report export
├── Multi-profile: up to 2 children (Family plan: 3)
└── Priority content updates (new word packs added by admin appear here first)
```

### Premium — Uzman Paketi (Expert/Teacher Plan)

```
Monthly: 149 TRY / month
Yearly:  999 TRY / year

INCLUDES everything in Student Plan PLUS:
├── Teacher dashboard
├── Unlimited student management
├── Homework assignment system
├── Student progress monitoring (real-time)
├── Push notifications (homework completion alerts)
├── Teacher-version PDF reports (with notes + recommendations)
├── Word and category management (add new content)
├── Test template creation
├── Milestone configuration
└── Batch student import (CSV)
```

### Free Trial

All new accounts receive a 7-day full-premium trial with no credit card required. After trial, downgraded to free plan unless subscribed. Trial shown prominently during onboarding.

### Paywall UX Rules

- Show the paywall as an upgrade opportunity, never as a rejection
- Always show what the child will unlock (character items work well here)
- Never interrupt a session mid-way — show paywall before starting a locked module
- Show a preview/demo of locked modules when tapped (first 3 questions, then gate)
- Pricing in Turkish Lira, formatted correctly: "₺49/ay" not "49 TRY/month"

---

## 10. MONETIZATION STRATEGY

### Why This Model

Pure paid app (one-time purchase) earns once per user and provides no revenue for ongoing development, API costs, or new content. Subscription aligns the app's success with the user's success: we earn more when users stick around longer.

### App Store Pricing

- List as Free on Google Play and App Store
- In-app purchase (subscription) managed entirely by RevenueCat
- RevenueCat provides unified billing, receipt validation, analytics, and webhook support
- Store takes 30% (15% after first year for small businesses)

### Revenue Projections Basis

Target: Turkey-based families with children in special education. Turkey has approximately 1.2 million students receiving special education support (MEB, 2023). Market penetration of even 0.1% = 1,200 paying families.

At 349 TRY/year × 1,200 = ~419,000 TRY/year gross (~12,000 USD at current rates). Teacher plan at 999 TRY × 100 specialists = ~100,000 TRY additional.

### Growth Levers

1. **Referral from teachers to parents** — every teacher user brings 5–15 parent users
2. **Word pack add-ons** (future) — admin sells curated category packs (e.g., "Hayvan Çiftliği Paketi")
3. **School licensing** — bulk subscriptions for special education departments
4. **Arabic/English expansion** (future) — same architecture, new word bank

---

## 11. MODULE SYSTEM — ALL 24 MODULES

Each module entry in the registry includes all fields needed for the home screen card, the session screen, progress tracking, and the teacher panel.

### Module Type → Screen Mapping

```typescript
type ScreenType = 'quiz' | 'builder' | 'phoneme' | 'memory' | 'visual' | 'explore';

// quiz     → app/session/quiz.tsx      (multiple choice, 4 options)
// builder  → app/session/builder.tsx   (drag tiles into order)
// phoneme  → app/session/phoneme.tsx   (keyboard text input)
// memory   → app/session/memory.tsx    (adaptive flash + recall)
// visual   → app/session/visual.tsx    (3×3 tap grid)
// explore  → app/session/explore.tsx   (word card carousel)
```

### Complete Module Registry

| ID | Level | Screen | Premium | Notes |
|---|---|---|---|---|
| gorselAlgi | 0 | visual | No | 3×3 grid, 700ms interval, 15 targets |
| kesfet | 0 | explore | No | Category carousel with SVG + audio |
| tani | 0 | quiz | No | 4-option word recognition |
| kategori | 0 | quiz | No | 4-option categorization |
| harf | 1 | quiz | No | VAR/YOK binary + letter highlight |
| ayirtEtme | 1 | quiz | Yes | Confusable pairs: b/d, a/e etc. |
| heceBirlestir | 2 | builder | Yes | Tile ordering, syllable level |
| heceC | 2 | quiz | Yes | 4-option syllable count (1/2/3/4+) |
| hecele | 2 | quiz | Yes | 3-option correct syllabification |
| sonHece | 2 | quiz | Yes | 4-option last syllable |
| uzunKelime | 2 | quiz | Yes | 3-image longest word |
| kelimeDizisi | 2 | memory | Yes | Flash images, recall from text options |
| siraliHatirla | 2 | memory | Yes | Flash images, recall in order from images |
| harfBirlestir | 3 | builder | Yes | Tile ordering, letter level |
| uyak | 3 | quiz | Yes | 3-image rhyme match |
| ilkSes | 3 | quiz | Yes | 2-letter first sound |
| sonSes | 3 | quiz | Yes | 2-letter last sound |
| tamamla | 3 | quiz | Yes | 2-option complete ending syllable |
| tamamlaBastan | 3 | quiz | Yes | 2-option complete beginning syllable |
| uyakUretim | 3 | quiz | Yes | 4-option A/B/C/D rhyme production |
| fonemSilme | 3 | phoneme | Yes | Keyboard input, remove first/last letter |
| ilkHeceSilme | 3 | phoneme | Yes | Keyboard input, remove first syllable |
| sonHeceSilme | 3 | phoneme | Yes | Keyboard input, remove last syllable |
| ran | 5 | quiz | Yes | ms-precise timing, 4-option fast naming |

---

## 12. DATABASE SCHEMA

All tables have RLS enabled. All UUIDs use `gen_random_uuid()`. All timestamps are `timestamptz`.

```sql
-- =====================================================
-- CORE USER TABLE
-- =====================================================
CREATE TABLE profiles (
  id                     UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role                   TEXT NOT NULL DEFAULT 'student'
                           CHECK (role IN ('student', 'admin')),
  full_name              TEXT NOT NULL,
  display_name           TEXT,                     -- child's nickname
  date_of_birth          DATE,
  avatar_url             TEXT,
  device_push_token      TEXT,
  subscription_status    TEXT NOT NULL DEFAULT 'trial'
                           CHECK (subscription_status IN ('free','trial','student','family','expert')),
  subscription_expires   TIMESTAMPTZ,
  revenuecat_id          TEXT,
  email_verified         BOOLEAN DEFAULT false,
  created_at             TIMESTAMPTZ DEFAULT now(),
  updated_at             TIMESTAMPTZ DEFAULT now()
);

-- Auto-create profile on auth signup
CREATE OR REPLACE FUNCTION handle_new_user() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, full_name, subscription_status)
  VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'full_name', 'Kullanıcı'), 'trial');
  INSERT INTO student_character (student_id, total_xp)
  VALUES (NEW.id, 0);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users FOR EACH ROW
  EXECUTE FUNCTION handle_new_user();

-- =====================================================
-- CHILD PROFILES (multiple children per parent account)
-- =====================================================
CREATE TABLE child_profiles (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id     UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  name          TEXT NOT NULL,
  avatar_index  INTEGER DEFAULT 0,    -- which preset avatar
  date_of_birth DATE,
  created_at    TIMESTAMPTZ DEFAULT now()
);
-- Family plan supports up to 3 child profiles

-- =====================================================
-- TEACHER-STUDENT RELATIONSHIPS
-- =====================================================
CREATE TABLE teacher_students (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  teacher_id           UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  student_id           UUID REFERENCES profiles(id) ON DELETE SET NULL,
  manual_name          TEXT,       -- when student has no account yet
  manual_email         TEXT,       -- to auto-link when they register
  status               TEXT NOT NULL DEFAULT 'unregistered'
                         CHECK (status IN ('unregistered', 'linked')),
  notes                TEXT,       -- teacher's private notes
  linked_at            TIMESTAMPTZ,
  created_at           TIMESTAMPTZ DEFAULT now()
);

-- =====================================================
-- CONTENT: CATEGORIES
-- =====================================================
CREATE TABLE categories (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT NOT NULL UNIQUE,
  level       INTEGER NOT NULL DEFAULT 1,
  color_hex   TEXT NOT NULL DEFAULT '#6C63FF',
  icon_url    TEXT,
  sort_order  INTEGER DEFAULT 0,
  created_by  UUID REFERENCES profiles(id),
  is_active   BOOLEAN DEFAULT true,
  is_default  BOOLEAN DEFAULT false,  -- seeded categories cannot be deleted
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- =====================================================
-- CONTENT: WORDS
-- =====================================================
CREATE TABLE words (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id      UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  word_text        TEXT NOT NULL,
  syllables        JSONB NOT NULL DEFAULT '[]',
  syllable_count   INTEGER NOT NULL DEFAULT 1,
  first_sound      TEXT,
  last_sound       TEXT,
  rhyme_group      TEXT,
  svg_content      TEXT,         -- inline SVG string
  image_url        TEXT,         -- Supabase Storage URL (alternative)
  tts_audio_url    TEXT,         -- generated audio in Storage
  tts_generated_at TIMESTAMPTZ,
  created_by       UUID REFERENCES profiles(id),
  is_active        BOOLEAN DEFAULT true,
  is_seeded        BOOLEAN DEFAULT false,  -- initial 402 words, cannot delete
  created_at       TIMESTAMPTZ DEFAULT now()
);

-- =====================================================
-- STUDENT WORD PROGRESS (the learn/revision engine)
-- =====================================================
CREATE TABLE student_word_progress (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id    UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  word_id       UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  status        TEXT NOT NULL DEFAULT 'unseen'
                  CHECK (status IN ('unseen', 'learned', 'needs_review')),
  times_seen    INTEGER DEFAULT 0,
  times_correct INTEGER DEFAULT 0,
  learned_at    TIMESTAMPTZ,
  last_seen_at  TIMESTAMPTZ,
  UNIQUE (student_id, word_id)
);
CREATE INDEX idx_swp_student_status ON student_word_progress(student_id, status);
CREATE INDEX idx_swp_student_word   ON student_word_progress(student_id, word_id);

-- =====================================================
-- SESSION LOGS
-- =====================================================
CREATE TABLE session_logs (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id      UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  assignment_id   UUID REFERENCES assignments(id) ON DELETE SET NULL,
  module_id       TEXT NOT NULL,
  module_name     TEXT NOT NULL,
  module_level    INTEGER NOT NULL,
  session_mode    TEXT NOT NULL CHECK (session_mode IN ('free','learn','revision','homework','test')),
  correct_count   INTEGER DEFAULT 0,
  wrong_count     INTEGER DEFAULT 0,
  total_count     INTEGER DEFAULT 0,
  score_percent   INTEGER,
  avg_response_ms INTEGER,        -- RAN timing
  max_memory_level INTEGER,       -- adaptive memory peak
  xp_earned       INTEGER DEFAULT 0,
  duration_sec    INTEGER,
  session_date    DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at      TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_sessions_student ON session_logs(student_id, session_date);

-- =====================================================
-- TEST TEMPLATES (admin creates)
-- =====================================================
CREATE TABLE test_templates (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title                TEXT NOT NULL,
  description          TEXT,
  word_ids             JSONB NOT NULL DEFAULT '[]',
  word_count           INTEGER NOT NULL DEFAULT 15,
  milestone_threshold  INTEGER NOT NULL DEFAULT 50,
  difficulty_level     INTEGER DEFAULT 1,
  is_active            BOOLEAN DEFAULT true,
  created_by           UUID NOT NULL REFERENCES profiles(id),
  created_at           TIMESTAMPTZ DEFAULT now()
);

-- =====================================================
-- STUDENT MILESTONES (triggered by check-milestone fn)
-- =====================================================
CREATE TABLE student_milestones (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id       UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  test_template_id UUID NOT NULL REFERENCES test_templates(id),
  triggered_at     TIMESTAMPTZ DEFAULT now(),
  status           TEXT DEFAULT 'pending'
                     CHECK (status IN ('pending','completed','skipped')),
  completed_at     TIMESTAMPTZ,
  score_percent    INTEGER,
  is_locked        BOOLEAN DEFAULT true  -- blocks Learn Mode until completed
);

-- =====================================================
-- ASSIGNMENTS (teacher → student homework)
-- =====================================================
CREATE TABLE assignments (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  teacher_id    UUID NOT NULL REFERENCES profiles(id),
  student_id    UUID NOT NULL REFERENCES profiles(id),
  title         TEXT NOT NULL,
  instructions  TEXT,
  module_id     TEXT NOT NULL,
  word_ids      JSONB DEFAULT '[]',
  category_ids  JSONB DEFAULT '[]',
  due_date      TIMESTAMPTZ,
  status        TEXT DEFAULT 'pending'
                  CHECK (status IN ('pending','completed','overdue')),
  created_at    TIMESTAMPTZ DEFAULT now(),
  completed_at  TIMESTAMPTZ
);

-- =====================================================
-- CHARACTER ITEMS (seeded + admin-manageable)
-- =====================================================
CREATE TABLE character_items (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  item_type   TEXT NOT NULL CHECK (item_type IN ('hat','shirt','shoes','acc','bg')),
  name        TEXT NOT NULL,
  lottie_url  TEXT,      -- Supabase Storage
  image_url   TEXT,      -- static fallback
  unlock_xp   INTEGER NOT NULL DEFAULT 100,
  rarity      TEXT DEFAULT 'common' CHECK (rarity IN ('common','rare','legendary')),
  is_premium  BOOLEAN DEFAULT false,  -- premium-only items
  sort_order  INTEGER DEFAULT 0,
  is_active   BOOLEAN DEFAULT true
);

-- =====================================================
-- STUDENT CHARACTER STATE
-- =====================================================
CREATE TABLE student_character (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id      UUID NOT NULL REFERENCES profiles(id) UNIQUE ON DELETE CASCADE,
  total_xp        INTEGER DEFAULT 0,
  level           INTEGER DEFAULT 1,
  unlocked_items  JSONB DEFAULT '[]',   -- array of item IDs
  equipped_hat    UUID REFERENCES character_items(id),
  equipped_shirt  UUID REFERENCES character_items(id),
  equipped_shoes  UUID REFERENCES character_items(id),
  equipped_acc    UUID REFERENCES character_items(id),
  equipped_bg     UUID REFERENCES character_items(id),
  updated_at      TIMESTAMPTZ DEFAULT now()
);

-- =====================================================
-- XP AUDIT LOG
-- =====================================================
CREATE TABLE xp_transactions (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id   UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  amount       INTEGER NOT NULL,
  source       TEXT NOT NULL,
  reference_id UUID,
  created_at   TIMESTAMPTZ DEFAULT now()
);

-- =====================================================
-- NOTIFICATIONS
-- =====================================================
CREATE TABLE notifications (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  recipient_id      UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  sender_id         UUID REFERENCES profiles(id),
  notification_type TEXT NOT NULL,
  title             TEXT NOT NULL,
  body              TEXT NOT NULL,
  reference_id      UUID,
  is_read           BOOLEAN DEFAULT false,
  sent_at           TIMESTAMPTZ DEFAULT now()
);

-- =====================================================
-- TEACHER NOTES (for PDF reports)
-- =====================================================
CREATE TABLE teacher_notes (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  teacher_id     UUID NOT NULL REFERENCES profiles(id),
  student_id     UUID NOT NULL REFERENCES profiles(id),
  note_date      DATE NOT NULL DEFAULT CURRENT_DATE,
  content        TEXT NOT NULL,
  include_report BOOLEAN DEFAULT false,
  created_at     TIMESTAMPTZ DEFAULT now()
);
```

---

## 13. AUTHENTICATION & ROLES

### Registration Flow

1. User fills name, email, password on `/auth/register`
2. App calls `supabase.auth.signUp()` with `full_name` in metadata
3. Database trigger creates `profiles` row (role: 'student', status: 'trial')
4. Database trigger creates `student_character` row (total_xp: 0)
5. Supabase sends verification email automatically
6. User sees "Check your email" screen — cannot proceed
7. User taps link in email → deep link `okuma-dedektifi://verify?token=X`
8. App calls `supabase.auth.verifyOtp({token, type:'email'})`
9. Success → navigate to onboarding → home screen

### Deep Link Setup

```
Scheme: okuma-dedektifi://
Paths:
  /verify?token=X      — email verification
  /homework/[id]       — open specific homework (from push notification)
  /share/progress      — parent shares child's weekly progress
```

### Role System

```
Default role: 'student' (set by database trigger — never by client)
Admin role:   SET MANUALLY via SQL: UPDATE profiles SET role='admin' WHERE id='...'
```

No UI exists to change roles. This is intentional for V1. Future: admin panel for role management.

### Role-Based Navigation

```typescript
// app/_layout.tsx
const { role } = useProfile();
useEffect(() => {
  if (!session) router.replace('/(auth)/login');
  else if (!emailVerified) router.replace('/(auth)/verify-email');
  else if (role === 'admin') router.replace('/(teacher)');
  else router.replace('/(student)');
}, [session, role, emailVerified]);
```

### Row Level Security (Critical Rules)

```sql
-- Students see only their own data
CREATE POLICY "student_own_progress" ON student_word_progress
  FOR ALL USING (auth.uid() = student_id);

-- Teachers see their linked students' data
CREATE POLICY "teacher_sees_linked_students" ON session_logs
  FOR SELECT USING (
    auth.uid() = student_id OR
    EXISTS (
      SELECT 1 FROM teacher_students
      WHERE teacher_id = auth.uid() AND student_id = session_logs.student_id
    )
  );

-- Words and categories are globally readable
CREATE POLICY "words_public_read" ON words FOR SELECT USING (is_active = true);

-- Only admins can insert/update/delete words
CREATE POLICY "words_admin_write" ON words
  FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Role column cannot be updated from client
CREATE POLICY "no_role_update" ON profiles
  FOR UPDATE USING (true) WITH CHECK (
    (SELECT role FROM profiles WHERE id = auth.uid()) = role
  );
```

---

## 14. TEACHER PANEL FEATURES

### Dashboard

- Active students today (logged in within 24h)
- Pending assignments count
- Overdue assignments count (red badge)
- Recent notifications feed (last 10)
- Quick stats: this week's total sessions across all students

### Student Management

**My Students tab:**
- List of all students (unregistered + linked)
- Status badge: "Uygulama Yok" (gray), "Bağlı" (green)
- Search and filter
- Tap → student detail page

**All App Users tab:**
- Users with subscription_status != 'free' who are not linked to this teacher
- Shows: first name only, registration date, last active date
- "Öğrencime Ekle" button → creates teacher_students link
- KVKK compliant: no sensitive data shown

**Student Detail:**
- Progress summary: total learned words, this week's sessions
- Weekly activity chart
- Module breakdown (which modules used, scores)
- Assignment history
- Teacher notes section (private, for report)
- "Ödev Ver" quick action button
- Status toggle: "Uygulama Yok → Bağlı" (when student registers with same email)

### Assignment Creation

```
Teacher selects:
  1. Student (or multiple)
  2. Module type (from MODULES_REGISTRY)
  3. Words to practice (or whole category)
  4. Due date
  5. Instructions text (optional)
  
Preview shows exactly what student will see.
Save → Supabase → push notification to student.
```

### Word & Category Management

**Add Word form:**
- Word text (required)
- Category (required, dropdown)
- Syllable breakdown (auto-suggested, manually overridable)
- Image upload (to Supabase Storage) OR paste SVG
- On save: Edge Function `generate-tts` is called automatically
- Loading indicator while TTS generates
- Preview card shown before saving

**Category management:**
- Add / Edit / Delete / Reorder
- Set level (affects which subscription plan can access)
- Color picker for category card
- Cannot delete default (seeded) categories

---

## 15. AUDIO SYSTEM

### TTS — Words Speak to the Child

```
WHEN: Admin saves new word (or clicks "Generate Audio")
WHERE: Supabase Edge Function `generate-tts`

FLOW:
word_text = "kalem"
    ↓
POST https://texttospeech.googleapis.com/v1/text:synthesize
    body: {
      input: { text: "kalem" },
      voice: {
        languageCode: "tr-TR",
        name: "tr-TR-Wavenet-B",   // warm, natural Turkish voice
        ssmlGender: "NEUTRAL"
      },
      audioConfig: {
        audioEncoding: "MP3",
        speakingRate: 0.85,         // slightly slower for learning
        pitch: 0.5                  // slightly higher, more child-friendly
      }
    }
    ↓
Returns base64 MP3
    ↓
Upload to Supabase Storage: /audio/words/{word_id}.mp3
    ↓
UPDATE words SET tts_audio_url = '...', tts_generated_at = now()
    ↓
Child taps speaker icon → expo-av plays from URL (cached locally)
```

**Cost:** Google Cloud TTS Wavenet = $0.016 per 1 million characters. For 402 words × avg 6 chars = 2,412 chars = $0.00004. Effectively free.

**Caching:** Audio files download to device on first play. Stored in Expo FileSystem cache. Subsequent plays are instant, offline-capable.

### Microphone — Child Speaks, App Evaluates

```
WHEN: Student taps mic button in 'Sesli Söyle' module

FLOW:
    3-2-1 countdown animation
    ↓
expo-av starts recording (max 6 seconds, auto-stops)
    ↓
recording.stopAndUnloadAsync()
    ↓
Read file as base64
    ↓
POST to Supabase Edge Function `evaluate-pronunciation`
    body: { audioBase64, expectedWord: "kalem", studentId }
    ↓
Edge Function:
    Upload audio to temp Storage path
    POST to OpenAI Whisper API:
        model: "whisper-1"
        language: "tr"
        prompt: "Tek Türkçe kelime"  (improves single-word accuracy)
    Delete temp audio file
    Compare transcript to expectedWord (fuzzy match for vowel harmony variants)
    Return: { correct: boolean, transcript: string, similarity: number }
    ↓
App shows result animation:
    correct → celebration + XP
    wrong   → gentle encouragement + show correct pronunciation + replay audio
```

**Whisper cost:** $0.006 per minute of audio. 6-second clip = $0.0006. At 100 evaluations/day = $0.06/day = ~$22/year. Manageable; add rate limiting (max 20 evaluations per session).

**Offline fallback:** If no internet, mic button shows "İnternet bağlantısı gerekli 📶" and disables. Session continues with other question types.

---

## 16. NOTIFICATION SYSTEM

### Types

```typescript
type NotificationType =
  | 'assignment_complete'    // teacher ← student
  | 'assignment_due_soon'    // student ← system (24h before due)
  | 'assignment_overdue'     // teacher ← system
  | 'milestone_reached'      // student ← system (50 words!)
  | 'test_available'         // student ← system
  | 'new_item_unlocked'      // student ← system
  | 'streak_reminder'        // student ← system (2 days no practice)
  | 'weekly_summary'         // teacher ← system (Sunday)
  | 'welcome'                // student ← system (after registration)
```

### Push Notification Flow

```
homework completed by student
    ↓
session_logs INSERT
assignment status UPDATE to 'completed'
    ↓
Supabase Trigger → Edge Function `send-notification`
    ↓
Fetch teacher's device_push_token from profiles
    ↓
POST https://exp.host/--/api/v2/push/send
    body: {
      to: teacher.device_push_token,
      title: "🎉 Ödev Tamamlandı!",
      body: "Ahmet 'Hece Birleştir' ödevini tamamladı. Başarı: %87",
      data: { type: 'assignment_complete', assignmentId, studentId }
    }
    ↓
Teacher taps notification → app opens to student detail page
```

### Streak Reminder Logic

```
Daily cron (Supabase pg_cron or Edge Function with schedule):
    Find students with last_session_date = 2 days ago
    AND notification preference enabled
    AND subscription_status != 'free'
    Send: "⭐ Dedektif, seni bekliyoruz! Karakterin özledi..."
```

---

## 17. PDF REPORT SYSTEM

Reports are generated as HTML on-device then converted to PDF with `react-native-html-to-pdf`. The HTML template is TypeScript — it receives data and returns an HTML string.

### Student Report Contents

```
Header: Logo, student name, week range
Summary: Sessions this week, XP earned, words learned
Words Learned: List of new words with category
Test Results: Any tests taken this week
Progress Chart: Horizontal bar per module (correct %)
Character: Current character with equipped items (fun visual)
Strong Areas: Modules above 80%
Needs Practice: Modules below 60%
Footer: Date, app name
```

### Teacher Report (Superset)

```
Everything above PLUS:
Clinical Notes: teacher_notes WHERE include_report = true
Parent Recommendations: Free text field the teacher fills
Weak Areas Detail: Specific word lists where errors occurred
Week-over-Week: % change in accuracy vs previous week
RAN Progress: Speed trend graph
Signature Line: Teacher name + date
```

### PDF Generation

```typescript
// src/application/reports/generate-weekly-report.ts
export async function generateWeeklyReport(
  studentId: string,
  teacherId?: string,    // if provided, generates teacher version
  weekStart?: Date
): Promise<string> {     // returns file URI

  const data = await fetchReportData(studentId, weekStart);
  const teacherNotes = teacherId 
    ? await fetchTeacherNotes(teacherId, studentId)
    : null;
  
  const html = renderReportHTML(data, teacherNotes);
  
  const { filePath } = await RNHTMLtoPDF.convert({
    html,
    fileName: `okuma-dedektifi-rapor-${data.studentName}-${weekStart}`,
    directory: 'Documents',
  });
  
  return filePath;
}
```

---

## 18. OFFLINE BEHAVIOR

### What Downloads on First Login

```
Priority 1 (immediate, sync):
├── User profile and subscription status
├── All active categories (< 10KB)
├── All active words metadata (< 200KB, no audio)
├── SVG library (< 500KB)
└── Student's word progress (status per word)

Priority 2 (background, after first screen loads):
├── Audio files for first 3 categories
└── Character items metadata

Priority 3 (on-demand):
└── Audio files for other categories (download when category opened)
```

### Offline-Capable Features

```
✅ WORKS OFFLINE:
├── Learn Mode (all non-audio interactions)
├── Revision Mode
├── All modules except 'Sesli Söyle' (mic)
├── Character dress-up
├── Progress view (cached data)
└── Session results

❌ REQUIRES INTERNET:
├── Microphone pronunciation evaluation
├── Syncing progress to cloud
├── Push notifications
├── PDF generation (if fetching teacher notes)
└── New word/category updates
```

### Offline Session Sync

```typescript
// When offline, sessions saved to SQLite
// On reconnect, sync queue processes:
const unsyncedSessions = await db.getUnsyncedSessions();
for (const session of unsyncedSessions) {
  await supabase.from('session_logs').insert(session);
  await db.markSynced(session.id);
}
```

---

## 19. MVP SCOPE

The MVP (Minimum Viable Product) ships with everything needed to charge for a subscription and provide real value. Nothing less, nothing more.

### MVP Includes

```
Authentication:
├── Email registration + verification
├── Login / logout
└── Email forgot password

Student Experience:
├── All 24 modules (functional, tested)
├── Learn Mode + Revision Mode
├── Session result screen (5-star rating)
├── Basic character (idle + celebrate animations)
├── XP system (award + display)
├── 3 starter character items
├── Progress screen (14-day view)
└── Basic PDF student report

Teacher Experience:
├── Dashboard
├── Student management (add, view, link)
├── Assignment creation + list
├── Student detail with progress
└── Push notifications (assignment complete)

Content:
├── 402 words (all seeded)
├── 22 categories
├── 82 SVGs
└── TTS audio for all 402 words (generated at launch)

Monetization:
├── RevenueCat integration
├── Free / Student / Expert plans
├── 7-day trial
└── Paywall screens

Infrastructure:
├── Supabase full setup (DB + Auth + Storage + Edge Functions)
├── Offline basics (session saving, word caching)
└── Email verification flow
```

### MVP Excludes (Phase 2+)

```
Phase 2:
├── Microphone pronunciation evaluation
├── Full character item shop (10+ items)
├── Multi-child profiles (Family plan)
├── Milestone tests (admin creates)
├── Word manager in teacher panel
└── Teacher-version PDF reports

Phase 3:
├── Teacher notes in PDF
├── Arabic/English support
├── Batch student import
├── Word pack add-ons (purchasable)
└── School licensing portal
```

---

## 20. EXTENSION POINTS

The system is explicitly designed so future features are added by extension, not modification.

### Adding a New Module

```
1. Create src/domain/generators/gen-my-new-module.ts
   → export function genMyNewModule(words: Word[]): Question[] { ... }

2. Add entry to src/domain/modules.registry.ts:
   { id: 'myNewModule', screenType: 'quiz', generator: genMyNewModule, ... }

3. If it needs a new screen type, add app/session/my-new-screen.tsx
   and add the case to app/session/_layout.tsx routing.

Result: Home screen shows it, teacher can assign it, progress tracks it,
        reports include it. Zero other files changed.
```

### Adding a New Category

```
Teacher does this from the admin panel UI.
No code changes needed.
New words appear in all modules automatically.
```

### Adding a New Character Item

```
1. Add Lottie/image file to Supabase Storage
2. Insert row into character_items table (via admin panel or SQL)
Result: Item appears in shop for all users who meet XP threshold.
No code changes needed.
```

### Adding a New Subscription Tier

```
1. Configure product in App Store Connect + Google Play Console
2. Configure entitlement in RevenueCat dashboard
3. Add tier to src/config/subscription-tiers.ts:
   { id: 'school', entitlements: ['premium', 'teacher', 'multi_school'], ... }
4. Add gate checks in PremiumGate component for new entitlements.
```

### Adding a New Language

```
1. Create new word bank: src/domain/words.{language}.data.ts
2. Add language selector to settings
3. All generators work unchanged (they receive the word array as parameter)
4. Generate TTS audio for new language words
Note: SVGs are language-agnostic (visual only)
```

---

## 21. CODING STANDARDS

### TypeScript Rules

```typescript
// NO 'any' — ever. Use 'unknown' if type is truly unknown.
// NO implicit return types on functions that return values.
// ALL exported functions have JSDoc comments.
// ALL domain types in src/domain/types.ts

// Example correct pattern:
/**
 * Awards XP to a student and checks for item unlocks.
 * @returns Updated character state
 */
export async function awardXP(
  studentId: string,
  amount: number,
  source: XPSource,
): Promise<StudentCharacter> {
  // implementation
}
```

### Component Rules

```typescript
// Each screen/component in its own file.
// No inline styles — use StyleSheet.create() or design tokens.
// No hardcoded strings — use constants or i18n keys (future).
// Loading states: every async operation has a loading UI.
// Error states: every async operation has an error UI.
// Empty states: every list has an empty state UI.

// Correct component structure:
const MyComponent: React.FC<Props> = ({ prop1, prop2 }) => {
  // 1. Hooks
  // 2. Derived state
  // 3. Event handlers
  // 4. Render
};
```

### Generator Function Rules

All generator functions must:
- Be pure functions (same input → same output structure, randomness is acceptable)
- Accept `(words: Word[]) => Question[]`
- Never return fewer than 5 questions
- Filter out null/undefined before returning
- Be unit-testable without any React dependency

### Session State Machine

The session (quiz/builder/etc) follows a strict state machine. Never use ad-hoc boolean flags.

```typescript
type SessionState =
  | { phase: 'loading' }
  | { phase: 'question'; questionIndex: number; question: Question }
  | { phase: 'feedback'; result: 'correct' | 'wrong'; question: Question }
  | { phase: 'complete'; results: SessionResults };
```

### Commit Message Format

```
feat: add milestone test system
fix: correct rhyme group matching for ü/ü pairs
chore: update Supabase schema for character items
docs: add generator function JSDoc
test: add unit tests for genUyak
```

---

## APPENDIX: WORD BANK STATISTICS

```
Total words: 402
Categories: 22
Words with SVG: 82
Words with rhyme groups (rk): ~200
Max syllables in one word: 5 (uğurböceği, atlıkarınca, patlamış mısır)
Min syllables: 1 (at, ay, el, göl, dağ, dal, kar, kaz...)

Category distribution:
Hayvanlar:  61 words
Eğlence:    26 words
Ev:         40 words
Doğa:       35 words
Yiyecekler: 33 words
Meyveler:   22 words
Okul:       20 words
Sebzeler:   18 words
Araçlar:    16 words
Giysiler:   15 words
Duygular:   14 words
Vücut:      14 words
Meslekler:  12 words
Mekanlar:   10 words
Müzik:      10 words
Rakamlar:   10 words
Nesneler:   10 words
Semboller:  10 words
Renkler:     9 words
Aile:        7 words
İçecekler:   6 words
Sağlık:      4 words
```

---

## APPENDIX: SCIENTIFIC REFERENCES

All module descriptions cite these sources (already embedded in the MODULLER array):

- Adams, M.J. (1990). Beginning to Read: Thinking and Learning About Print.
- Bryant, P., Bradley, L., Maclean, M., & Crossland, J. (1990). Rhyme and alliteration, phoneme detection, and learning to read.
- Ehri, L.C. (2005). Learning to Read Words: Theory, Findings, and Issues.
- Gathercole, S.E. & Pickering, S.J. (2000). Working Memory Deficits in Children with Low Achievements in the National Curriculum at 7 and 8 Years of Age.
- Hatcher, P., Hulme, C., & Ellis, A. (1994). Ameliorating Early Reading Failure by Integrating Reading and Phonological Skills.
- LaBerge, D. & Samuels, S.J. (1974). Toward a Theory of Automatic Information Processing in Reading.
- Liberman, I.Y., Shankweiler, D., Fischer, F.W., & Carter, B. (1974). Explicit syllable and phoneme segmentation in the young child.
- Nation, K. & Snowling, M.J. (2004). Beyond Phonological Skills: Broader Language Skills Contribute to the Development of Reading.
- Öney, B. & Goldman, S.R. (1984). Decoding and comprehension skills in Turkish and English.
- Scarborough, H.S. (1998). Early identification of children at risk for reading disabilities.
- Share, D.L. (1995). Phonological recoding and self-teaching: Sine qua non of reading acquisition.
- Stanovich, K.E. (1980). Toward an Interactive-Compensatory Model of Individual Differences in the Development of Reading Fluency.
- Treiman, R. (1992). The role of intrasyllabic units in learning to read and spell.
- Wagner, R.K. & Torgesen, J.K. (1987). The nature of phonological processing and its causal role in the acquisition of reading skills.
- Wolf, M. & Bowers, P.G. (1999). The double-deficit hypothesis for the developmental dyslexias.

---

*Document version: 2.0*  
*System: Okuma Dedektifi — Villa Akademia*  
*Prepared by: Development Team*  
*Date: April 2026*
