# OKUMA DEDEKTİFİ — COMPLETE AI AGENT BUILD PROMPT
## Final System Specification · Pass This File to Any AI Coding Agent
**Villa Akademia | Ali Sağlam | April 2026**
**Document Status: FINAL — Do not modify without developer approval**

---

## HOW TO USE THIS DOCUMENT

You are an AI coding agent. Your job is to build the **Okuma Dedektifi** mobile application exactly as described in this document. Every architectural decision, technology choice, naming convention, file structure, database schema, and feature boundary is defined here. **Do not deviate** from what is written. If something is unclear, stop and ask before writing code. If two sections appear to conflict, the later section wins.

Read this entire document before writing a single line of code.

---

## PART 1 — WHAT WE ARE BUILDING

### Product Summary

**Okuma Dedektifi** (Reading Detective) is a Turkish-language mobile application for children aged 5–12 who have dyslexia, autism, speech delays, or general reading and language difficulties. It is also used by the special education specialists who treat these children and by their parents.

The application teaches **phonological awareness** — the scientifically validated core skill underlying reading ability. Every exercise module targets a specific, research-backed phonological skill. The app never uses the word "dyslexia" or frames activities as therapy. The child is a "reading detective" solving puzzles.

### Three Users

```
THE CHILD (5–12 years)
  Plays exercise modules, earns XP, customizes their character,
  listens to word pronunciations, uses microphone to say words aloud,
  completes homework assigned by their teacher.
  The app feels like a game, not a therapy tool.

THE PARENT
  Monitors the child's progress through weekly PDF reports.
  May link their child's account to a specialist.
  Controls notification preferences for the child.

THE SPECIALIST / TEACHER (role: admin)
  Manages multiple students, assigns targeted homework,
  creates milestone test templates, adds new words and categories,
  generates clinical-quality PDF reports with their own notes.
  Has full visibility into every student's progress.
```

### What Makes This App Different

- Built on the real curriculum of Ali Sağlam (Villa Akademia, Bursa, Turkey), a practicing special education specialist
- 402 Turkish words already designed and tested with real children
- 24 exercise modules, each with academic citations embedded
- Character avatar that grows with the child — central to motivation loop
- Teacher panel that extends clinic sessions into home practice
- Pronunciation evaluation using Whisper large-v3-turbo (best available model, no cost)
- Milestone tests auto-triggered at word count thresholds
- SOLID architecture so adding features never breaks existing ones

---

## PART 2 — CONFIRMED DECISIONS (non-negotiable)

These were explicitly decided by the developer. Do not suggest alternatives.

| Decision | Answer |
|---|---|
| App name | **Okuma Dedektifi** (package name: `com.villaakedemia.okumadedektifi`) |
| Frontend | React Native + Expo SDK (latest stable), TypeScript throughout |
| Navigation | Expo Router v3 (file-based) |
| Backend | Supabase only — no separate Node.js server |
| Backend logic | Supabase Edge Functions (Deno + TypeScript) |
| Database | PostgreSQL via Supabase with Row Level Security on every table |
| Speech recognition | Whisper large-v3-turbo self-hosted on HuggingFace ZeroGPU Space |
| Speech proxy | Supabase Edge Function (client never touches HF directly) |
| Subscriptions | RevenueCat (react-native-purchases) |
| Animations | React Native Animated + SVG (Lottie-ready architecture, no designer yet) |
| Character MVP | React Native Animated SVG fallback — fully Lottie-swappable later |
| Teacher access | Manual SQL role update for V1 (no invite code system needed in MVP) |
| Multi-child profiles | Phase 2 — single child per account for MVP launch |
| Offline | All modules work offline; mic feature requires internet |
| Language | Turkish only (V1) |
| Architecture | Clean Architecture + SOLID principles (see Part 5) |

---

## PART 3 — TECHNOLOGY STACK

### Frontend (React Native App)

```
Framework:          React Native + Expo SDK (latest stable)
Language:           TypeScript — zero .js files anywhere
Navigation:         Expo Router v3
State (global):     Zustand
State (server):     TanStack Query (React Query v5)
Animation:          React Native Animated (Lottie-ready, swap later)
SVG:                react-native-svg + SvgXml
Audio playback:     expo-av
Audio recording:    expo-av (recording mode)
PDF generation:     react-native-html-to-pdf
Offline KV store:   react-native-mmkv
Offline DB:         expo-sqlite
Push notifications: expo-notifications
Haptics:            expo-haptics
Fonts:              expo-google-fonts (Baloo2 + Nunito)
Icons:              expo-vector-icons (Ionicons set)
Validation:         zod
Subscriptions:      react-native-purchases (RevenueCat)
```

### Backend (Supabase Platform)

```
Database:           PostgreSQL (Supabase managed)
Auth:               Supabase Auth (email/password + email verification)
Storage:            Supabase Storage (audio files, PDFs, images)
Edge Functions:     Deno + TypeScript
Realtime:           Supabase Realtime (homework completion → teacher)
Security:           Row Level Security on every table (no exceptions)
```

### External Services

```
TTS audio:          Google Cloud Text-to-Speech API
                    Voice: tr-TR-Wavenet-B, rate: 0.85, pitch: +0.5
                    Called ONCE per word at creation time, result stored in Storage
                    Cost: effectively $0 for 402 words

Speech recognition: Whisper large-v3-turbo on HuggingFace ZeroGPU Space
                    Python stack: faster-whisper + FastAPI + Gradio
                    Proxied through Supabase Edge Function
                    Cost: $0 (ZeroGPU shared GPU, free tier)

Subscriptions:      RevenueCat
                    Handles iOS App Store + Google Play billing unified
                    Server-side receipt validation via Edge Function

Push:               Expo Push Notification Service (free, no limits)
```

### Dependencies NOT Allowed

```
❌ No Redux (use Zustand)
❌ No Firebase (use Supabase)
❌ No Segment / Amplitude / Mixpanel (no child tracking analytics)
❌ No axios (use fetch with typed wrappers)
❌ No moment.js (use date-fns)
❌ No lodash (use native TypeScript)
❌ No class-based React components (hooks only)
❌ No any type (use unknown or proper types)
```

---

## PART 4 — FILE STRUCTURE

Every file goes exactly here. No exceptions. No creative reorganization.

```
okuma-dedektifi/
│
├── app/                                  # Expo Router — ALL screens live here
│   ├── _layout.tsx                       # Root layout: auth gate + providers
│   ├── (auth)/
│   │   ├── _layout.tsx
│   │   ├── login.tsx
│   │   ├── register.tsx
│   │   └── verify-email.tsx
│   ├── onboarding/
│   │   ├── welcome.tsx                   # First launch animation + CTA
│   │   └── create-profile.tsx            # Child name + avatar color picker
│   ├── (student)/                        # Student tab navigator
│   │   ├── _layout.tsx                   # Tab bar definition
│   │   ├── home.tsx                      # Character + XP + quick actions
│   │   ├── learn.tsx                     # Category picker for Learn Mode
│   │   ├── practice.tsx                  # All 24 modules grid
│   │   ├── progress.tsx                  # Charts + PDF export
│   │   └── rewards.tsx                   # Character dress-up + XP shop
│   ├── (teacher)/                        # Teacher tab navigator (admin role only)
│   │   ├── _layout.tsx
│   │   ├── dashboard.tsx
│   │   ├── students/
│   │   │   ├── index.tsx                 # Student list (my students + all users)
│   │   │   └── [studentId].tsx           # Student detail + progress + notes
│   │   ├── assignments/
│   │   │   ├── index.tsx                 # Assignment list
│   │   │   └── create.tsx                # Assignment creation form
│   │   ├── content/
│   │   │   ├── categories.tsx            # Category CRUD
│   │   │   └── words.tsx                 # Word CRUD + TTS generation
│   │   ├── tests/
│   │   │   ├── index.tsx                 # Test template list
│   │   │   └── create.tsx                # Test template creator
│   │   └── reports/
│   │       └── [studentId].tsx           # Teacher-version PDF generator
│   ├── session/
│   │   └── [moduleId].tsx                # Generic session router
│   │                                     # Reads MODULES_REGISTRY, renders correct UI
│   ├── result.tsx                        # Session result (5-star screen)
│   ├── milestone-test.tsx                # Milestone test screen
│   └── paywall.tsx                       # Premium upgrade screen
│
├── src/
│   ├── domain/                           # PURE business logic. ZERO external imports.
│   │   ├── types/
│   │   │   ├── word.types.ts
│   │   │   ├── module.types.ts
│   │   │   ├── session.types.ts
│   │   │   ├── character.types.ts
│   │   │   ├── user.types.ts
│   │   │   ├── assignment.types.ts
│   │   │   └── subscription.types.ts
│   │   ├── interfaces/                   # Contracts — never import implementations here
│   │   │   ├── speech-recognizer.interface.ts
│   │   │   ├── progress-repository.interface.ts
│   │   │   ├── character-repository.interface.ts
│   │   │   ├── assignment-repository.interface.ts
│   │   │   ├── teacher-repository.interface.ts
│   │   │   ├── notification-service.interface.ts
│   │   │   └── subscription-service.interface.ts
│   │   ├── modules.registry.ts           # THE single list of all 24 modules
│   │   ├── words.data.ts                 # All 402 words as TypeScript constant
│   │   ├── svg.data.ts                   # All 82 SVG strings as TypeScript constant
│   │   └── generators/                   # One file per module generator (pure functions)
│   │       ├── index.ts                  # Re-exports all generators
│   │       ├── gen-kelime-tani.ts
│   │       ├── gen-kategori.ts
│   │       ├── gen-harf-avcisi.ts
│   │       ├── gen-ayirt-etme.ts
│   │       ├── gen-hece-birlestir.ts
│   │       ├── gen-hece-sayaci.ts
│   │       ├── gen-hecele.ts
│   │       ├── gen-son-hece.ts
│   │       ├── gen-uzun-kelime.ts
│   │       ├── gen-kelime-dizisi.ts
│   │       ├── gen-sirali-hatirla.ts
│   │       ├── gen-harf-birlestir.ts
│   │       ├── gen-uyak.ts
│   │       ├── gen-ilk-ses.ts
│   │       ├── gen-son-ses.ts
│   │       ├── gen-tamamla.ts
│   │       ├── gen-tamamla-bastan.ts
│   │       ├── gen-uyak-uretim.ts
│   │       ├── gen-fonem-silme.ts
│   │       ├── gen-ilk-hece-silme.ts
│   │       ├── gen-son-hece-silme.ts
│   │       └── gen-ran.ts
│   │
│   ├── application/                      # Use cases. ONE function = ONE action.
│   │   ├── words/
│   │   │   ├── get-learn-queue.usecase.ts
│   │   │   ├── get-revision-queue.usecase.ts
│   │   │   └── complete-word.usecase.ts
│   │   ├── sessions/
│   │   │   ├── save-session.usecase.ts
│   │   │   └── check-milestone.usecase.ts
│   │   ├── character/
│   │   │   ├── award-xp.usecase.ts
│   │   │   └── equip-item.usecase.ts
│   │   ├── assignments/
│   │   │   ├── create-assignment.usecase.ts
│   │   │   └── complete-assignment.usecase.ts
│   │   └── reports/
│   │       ├── generate-student-report.usecase.ts
│   │       └── generate-teacher-report.usecase.ts
│   │
│   ├── infrastructure/                   # External service implementations
│   │   ├── container.ts                  # DI wiring — ONE place that wires everything
│   │   ├── supabase/
│   │   │   ├── client.ts                 # Supabase client singleton
│   │   │   ├── words.repository.ts       # implements IProgressRepository (word side)
│   │   │   ├── progress.repository.ts    # implements IProgressRepository
│   │   │   ├── character.repository.ts   # implements ICharacterRepository
│   │   │   ├── assignments.repository.ts # implements IAssignmentRepository
│   │   │   └── teacher.repository.ts     # implements ITeacherRepository
│   │   ├── audio/
│   │   │   ├── whisper-proxy.service.ts  # ISpeechRecognizer — calls Edge Function
│   │   │   ├── recorder.service.ts       # expo-av recording wrapper
│   │   │   └── audio-player.service.ts   # expo-av playback wrapper
│   │   ├── storage/
│   │   │   ├── mmkv.ts                   # Fast KV (session state, user prefs)
│   │   │   └── sqlite.ts                 # Offline session queue
│   │   ├── revenuecat/
│   │   │   └── subscription.service.ts   # ISubscriptionService implementation
│   │   └── notifications/
│   │       └── expo.service.ts           # INotificationService implementation
│   │
│   └── presentation/                     # Reusable UI — NO business logic here
│       ├── components/
│       │   ├── CharacterView.tsx          # Animated SVG character (Lottie-ready)
│       │   ├── WordCard.tsx               # Core word display unit
│       │   ├── SvgWord.tsx                # SVG or emoji fallback renderer
│       │   ├── AnswerButton.tsx           # Animated quiz answer option
│       │   ├── ProgressBar.tsx            # Animated XP / session progress bar
│       │   ├── XpBadge.tsx                # XP counter display
│       │   ├── ModuleCard.tsx             # Home screen module grid card
│       │   ├── StarRating.tsx             # 5-star result display
│       │   ├── PremiumGate.tsx            # Paywall overlay wrapper
│       │   ├── MicButton.tsx              # Recording UI with pulse animation
│       │   ├── SyllableTile.tsx           # Draggable tile for builder modules
│       │   ├── SessionHeader.tsx          # Back button + progress bar + score
│       │   └── TeacherNoteCard.tsx        # Note display in teacher panel
│       ├── screens/                       # Screen-level UI components (no routing)
│       │   ├── QuizSession.tsx            # Renders quiz-type modules
│       │   ├── BuilderSession.tsx         # Renders tile-builder modules
│       │   ├── PhonemeSession.tsx         # Renders keyboard-input modules
│       │   ├── MemorySession.tsx          # Renders adaptive memory modules
│       │   ├── VisualSession.tsx          # Renders visual perception grid
│       │   └── ExploreSession.tsx         # Renders Keşfet carousel
│       ├── hooks/
│       │   ├── useSession.ts              # Session state machine hook
│       │   ├── useWordProgress.ts         # Word learn/revision queries
│       │   ├── useCharacter.ts            # XP + items + animation triggers
│       │   ├── useSubscription.ts         # Entitlement checking
│       │   ├── useAudio.ts                # TTS playback
│       │   └── useMicrophone.ts           # Recording + pronunciation eval
│       └── animations/
│           ├── correct-burst.ts           # Star particle effect (correct answer)
│           ├── wrong-shake.ts             # Horizontal shake (wrong answer)
│           └── xp-float.ts               # XP number floats up and fades
│
├── supabase/
│   ├── migrations/
│   │   ├── 001_initial_schema.sql        # All tables + RLS policies
│   │   ├── 002_character_system.sql      # Character items + student_character
│   │   ├── 003_assignments.sql           # Assignments + test templates + milestones
│   │   └── 004_teacher_notes.sql         # Teacher notes for PDF reports
│   └── functions/
│       ├── generate-tts/
│       │   └── index.ts                  # Calls Google Cloud TTS, uploads to Storage
│       ├── evaluate-pronunciation/
│       │   └── index.ts                  # Proxies to HuggingFace Whisper Space
│       ├── check-milestone/
│       │   └── index.ts                  # Checks word count, triggers test
│       ├── send-notification/
│       │   └── index.ts                  # Sends Expo push notification
│       ├── validate-subscription/
│       │   └── index.ts                  # Calls RevenueCat, updates profile
│       └── generate-report/
│           └── index.ts                  # Assembles report data for PDF
│
├── assets/
│   ├── character/                        # SVG-based animated character (MVP)
│   │   ├── character-base.svg
│   │   ├── character-idle.tsx            # React Native Animated wrapper
│   │   ├── character-happy.tsx
│   │   ├── character-celebrate.tsx
│   │   ├── character-wrong.tsx
│   │   └── character-wave.tsx
│   ├── fonts/
│   │   ├── Baloo2-ExtraBold.ttf
│   │   ├── Nunito-Bold.ttf
│   │   ├── Nunito-SemiBold.ttf
│   │   └── Nunito-Medium.ttf
│   └── images/
│
├── docs/
│   └── AI_AGENT_PROMPT.md               # This file
│
├── .env                                  # Local dev secrets (NEVER commit)
├── .env.example                          # Template (commit this, no real values)
├── app.json                              # Expo config
├── eas.json                              # EAS build + submit config
├── tsconfig.json
└── package.json
```

---

## PART 5 — ARCHITECTURE & SOLID PRINCIPLES

### Clean Architecture — 4 Layers

Dependencies ONLY point inward. Outer layers know about inner layers. Inner layers know nothing about outer layers.

```
Presentation (app/, src/presentation/)
    ↓ depends on ↓
Application (src/application/)
    ↓ depends on ↓
Domain (src/domain/)
    ↑ implemented by ↑
Infrastructure (src/infrastructure/)
```

**Domain layer has ZERO imports from outside `src/domain/`. Verify this on every commit.**

### S — Single Responsibility

One file = one concern. If you need "and" to describe what a function does, split it.

```typescript
// ❌ WRONG
const WordCard = () => { /* fetches + plays audio + records + evaluates + saves */ }

// ✅ CORRECT
// WordCard.tsx     → displays word, delegates interactions upward
// useAudio.ts      → manages TTS playback
// useMicrophone.ts → manages recording + calls evaluation
// useSession.ts    → manages progression and state
// award-xp.usecase.ts → awards XP (separate use case)
```

### O — Open/Closed

The MODULES_REGISTRY is the central example. Adding a module = add one entry. Zero other files change.

```typescript
// src/domain/modules.registry.ts
// This is the ONLY place modules are registered.
// SessionScreen reads this at runtime. It never needs to change when you add modules.
export const MODULES_REGISTRY: ModuleDefinition[] = [
  {
    id: 'hecele',
    icon: '✂️',
    title: 'Hecele!',
    description: 'Doğru hecelemeyi seç',
    science: 'Doğru hece sınırlarını belirleme becerisi...',
    familyTip: 'Kitap okurken bilmediği uzun bir kelimeyi birlikte parçalara ayırın...',
    color: '#7c3aed',
    level: 2,
    screenType: 'quiz',      // routes to QuizSession screen
    generator: genHecele,    // pure function from generators/
    requiresPremium: true,
    isNew: false,
  },
  // ADD NEW MODULES HERE ONLY. Never touch app/session/[moduleId].tsx to add a module.
]
```

### L — Liskov Substitution

Every infrastructure implementation must be swappable without touching feature code.

```typescript
// src/domain/interfaces/speech-recognizer.interface.ts
export interface ISpeechRecognizer {
  initialize(): Promise<void>
  evaluate(audioUri: string, expectedWord: string): Promise<{
    correct: boolean
    transcript: string
    similarity: number
  }>
}

// src/infrastructure/audio/whisper-proxy.service.ts
export class WhisperProxyService implements ISpeechRecognizer {
  // Calls Supabase Edge Function → HuggingFace
}

// Future alternative (one-line swap in container.ts):
// export class WhisperLocalService implements ISpeechRecognizer { ... }
```

Apply this pattern to ALL infrastructure: progress repository, character repository, notification service, subscription service.

### I — Interface Segregation

Students and teachers never see each other's interfaces.

```typescript
// Students use:
interface IStudentProgressService {
  getLearnQueue(studentId: string): Promise<Word[]>
  getRevisionQueue(studentId: string): Promise<Word[]>
  completeWord(studentId: string, wordId: string): Promise<void>
  saveSession(result: SessionResult): Promise<void>
}

// Teachers use:
interface ITeacherService {
  getLinkedStudents(teacherId: string): Promise<StudentSummary[]>
  assignHomework(assignment: CreateAssignmentInput): Promise<void>
  getStudentProgress(studentId: string): Promise<DetailedProgress>
  addTeacherNote(note: TeacherNoteInput): Promise<void>
}
// Never merge these. Student components never receive ITeacherService.
```

### D — Dependency Inversion

High-level modules never import from low-level modules. Both depend on abstractions.

```typescript
// src/infrastructure/container.ts
// ONE place that wires everything. Tests swap one line here, nothing else changes.
import { WhisperProxyService }         from './audio/whisper-proxy.service'
import { SupabaseProgressRepository }  from './supabase/progress.repository'
import { SupabaseCharacterRepository } from './supabase/character.repository'
import { RevenueCatService }           from './revenuecat/subscription.service'
import { ExpoNotificationService }     from './notifications/expo.service'

export const container = {
  speechRecognizer: new WhisperProxyService(),
  progressRepo:     new SupabaseProgressRepository(),
  characterRepo:    new SupabaseCharacterRepository(),
  subscriptionSvc:  new RevenueCatService(),
  notificationSvc:  new ExpoNotificationService(),
} as const

// container is provided to the React tree via Context in app/_layout.tsx
// Every hook receives its dependency from context, never imports from infrastructure
```

---

## PART 6 — DESIGN SYSTEM

Everything visual comes from `src/config/design-tokens.ts`. Nothing is hardcoded in components.

### Colors

```typescript
export const colors = {
  // Brand — warm amber (not typical EdTech purple-blue)
  primary:       '#F5A623',
  primaryDark:   '#D4861A',
  primaryLight:  '#FDE9C2',
  primaryXLight: '#FFF8ED',

  // Secondary — deep teal
  secondary:      '#1A7A6E',
  secondaryLight: '#C5EDE9',

  // Accent — coral (celebration, energy)
  accent:      '#FF5F5F',
  accentLight: '#FFD4D4',

  // Feedback
  success:      '#5AC94A',  // correct answer
  successLight: '#D4F5CE',
  warning:      '#FFBB30',  // caution
  error:        '#FF7575',  // wrong answer — SOFT, never clinical red
  errorLight:   '#FFDADA',

  // Backgrounds
  bg:          '#FFF9F0',  // warm off-white
  surface:     '#FFFFFF',
  surfaceWarm: '#FFFBF4',

  // Text — warm brown tones, not black
  textPrimary:  '#2C1810',
  textSecond:   '#6B4D3A',
  textMuted:    '#C4A882',

  // Level colors (module card accents)
  level0: '#E8F7F5',
  level1: '#FEF3DC',
  level2: '#EDE4FF',
  level3: '#FFE8E8',
  level5: '#E8F5E8',

  // XP / rewards
  xpGold:      '#FFB800',
  xpGoldLight: '#FFF3B0',
  starFull:    '#FFB800',
  starEmpty:   '#DDD0BB',
} as const
```

### Typography

```typescript
// Fonts: Baloo2_800ExtraBold (display) + Nunito family (body)
// Both loaded via expo-google-fonts
export const typeScale = {
  wordBig:  { fontSize: 42, fontFamily: 'Baloo2_800ExtraBold', letterSpacing: 6  },
  wordMed:  { fontSize: 28, fontFamily: 'Baloo2_800ExtraBold', letterSpacing: 4  },
  h1:       { fontSize: 26, fontFamily: 'Nunito_700Bold'                         },
  h2:       { fontSize: 20, fontFamily: 'Nunito_700Bold'                         },
  body:     { fontSize: 16, fontFamily: 'Nunito_600SemiBold', lineHeight: 24     },
  small:    { fontSize: 13, fontFamily: 'Nunito_500Medium',   lineHeight: 18     },
  letter:   { fontSize: 28, fontFamily: 'SpaceMono_700Bold',  letterSpacing: 3   },
  // letterSpacing on word displays is a deliberate dyslexia-friendly design choice
} as const
```

### Spacing & Radius

```typescript
export const spacing = { xs:4, sm:8, md:16, lg:24, xl:32, xxl:48 } as const
export const radius  = { xs:6, sm:12, md:20, lg:28, xl:40, card:24, full:9999 } as const
```

### Animation Rules (Every Developer Must Follow These)

```typescript
// Button press — always
onPressIn:  scale to 0.95, duration 80ms
onPressOut: spring back to 1.0, damping 15, stiffness 400

// Correct answer sequence:
1. Card border → colors.success (120ms)
2. Card scale: 1.0 → 1.06 → 1.0 (spring, 200ms)
3. Five yellow stars burst from card center, scatter upward, fade (400ms)
4. XP number (+10) floats up from card, fades (300ms)
5. Character triggers 'happy' animation
6. Haptics.notificationAsync(NotificationFeedbackType.Success)

// Wrong answer sequence:
1. Card border → colors.error (100ms)
2. Horizontal shake: translateX oscillates ±8px, 3 cycles, 80ms each
3. Border resets to neutral (500ms delay)
4. Random encouraging text appears (pick from array each time)
5. Character triggers 'wrong' animation
6. Haptics.impactAsync(ImpactFeedbackStyle.Light) — gentle, not jarring
7. NEVER show red color. Use colors.error (warm coral) only.

// Encouraging text options (pick randomly on each wrong answer):
const ENCOURAGEMENTS = [
  'Tekrar dene! 💪',
  'Neredeyse! 🌟',
  'Denemeye devam! ⭐',
  'Hemen öğreneceksin! 🎯',
  'Az kaldı! ✨',
]

// Session complete:
Stars fall from top of screen one by one, staggered 200ms each.
Character triggers 'wave' animation.

// XP level up:
Full-screen overlay with confetti.
Character triggers 'celebrate' animation.
New XP level displayed in large font with spring entrance.
```

### Touch Target Rules

```
ALL tappable elements: minimum 48×48pt
Answer buttons for children aged 5–8: minimum 80px height
Module cards: full card is tappable, minimum 80px height
Tab bar items: standard (Expo Router default is compliant)
```

---

## PART 7 — CHARACTER SYSTEM (MVP: Animated SVG, Lottie-Ready)

### Context

There is no Lottie designer yet. The character is built using React Native Animated + SVG so it works now. The architecture is Lottie-ready: when the designer delivers `.lottie` files, swapping is a one-file change in `CharacterView.tsx`.

### Character Concept

A small, round-headed, big-eyed child detective. Gender-neutral. Warm brown skin, large expressive eyes, always holding a magnifying glass. Classic chibi proportions (large head, small body). The character sits bottom-right of exercise screens (small, 80px) and takes center of home screen (large, 200px).

### Animation States

```typescript
// src/config/character-triggers.ts
export type CharacterTrigger =
  | 'idle'        // gentle bob — home screen default
  | 'happy'       // small jump — app open, item equipped
  | 'celebrate'   // full spin — level up, item unlocked
  | 'wrong'       // head scratch — wrong answer
  | 'wave'        // wave — session complete
  | 'run'         // running — loading states
  | 'sleep'       // drooping eyes — idle 30s+

export const CHARACTER_TRIGGER_MAP: Record<CharacterTrigger, string> = {
  idle:      'character-idle',
  happy:     'character-happy',
  celebrate: 'character-celebrate',
  wrong:     'character-wrong',
  wave:      'character-wave',
  run:       'character-run',
  sleep:     'character-sleep',
}

// When to trigger each:
// appOpen          → happy
// answerCorrect    → happy
// answerWrong      → wrong
// sessionComplete  → wave
// levelUp          → celebrate
// itemUnlocked     → celebrate
// homeScreenIdle   → idle (default)
// idleTimeout 30s  → sleep
// loadingScreen    → run
```

### CharacterView Component Interface

```typescript
// src/presentation/components/CharacterView.tsx
// MVP: React Native Animated SVG
// Phase 2: swap internal implementation for Lottie, interface stays identical

interface CharacterViewProps {
  trigger: CharacterTrigger
  size?: 'small' | 'medium' | 'large'   // 80 | 160 | 240 px
  equippedItems?: EquippedItems          // hat, shirt, shoes, acc, bg
  onAnimationFinish?: () => void
  loop?: boolean
}

// sizes:
// small (80px)  — bottom-right corner of exercise screens
// medium (160px) — practice screen header
// large (240px)  — home screen center
```

### XP Economy

```typescript
// src/config/xp-rules.ts
export const XP_RULES = {
  wordCorrect:           10,
  wordCorrectPronounce:  20,   // microphone correct answer
  sessionComplete:       30,
  sessionPerfect:        50,   // 100% score bonus
  assignmentComplete:    75,
  assignmentPerfect:    100,
  milestoneTest:         80,
  milestoneTestPerfect: 150,
  dailyLogin:            15,
  streak3Days:           30,
  streak7Days:          100,
  streak30Days:         300,
} as const
```

### Character Items (Seeded Data)

```typescript
// Seeded into character_items table on first migration
// Type: 'hat' | 'shirt' | 'shoes' | 'acc' | 'bg'

const SEED_ITEMS = [
  // HATs
  { id:'hat_detective',  type:'hat',   name:'Dedektif Şapkası',  unlockXp:0,    rarity:'common'    },
  { id:'hat_crown',      type:'hat',   name:'Altın Taç',         unlockXp:200,  rarity:'rare'      },
  { id:'hat_star',       type:'hat',   name:'Yıldız Kasketi',    unlockXp:500,  rarity:'rare'      },
  { id:'hat_astronaut',  type:'hat',   name:'Astronot Kaskı',    unlockXp:1200, rarity:'legendary' },
  // SHIRTs
  { id:'shirt_detective',type:'shirt', name:'Dedektif Ceketi',   unlockXp:0,    rarity:'common'    },
  { id:'shirt_cape',     type:'shirt', name:'Kahraman Pelerini', unlockXp:150,  rarity:'rare'      },
  { id:'shirt_rainbow',  type:'shirt', name:'Gökkuşağı Gömlek',  unlockXp:400,  rarity:'rare'      },
  { id:'shirt_galaxy',   type:'shirt', name:'Galaksi Zırhı',     unlockXp:1000, rarity:'legendary' },
  // SHOES
  { id:'shoes_basic',    type:'shoes', name:'Koşu Ayakkabısı',   unlockXp:0,    rarity:'common'    },
  { id:'shoes_rocket',   type:'shoes', name:'Roket Botu',        unlockXp:300,  rarity:'rare'      },
  { id:'shoes_cloud',    type:'shoes', name:'Bulut Terliği',     unlockXp:700,  rarity:'rare'      },
  // ACCESSORies
  { id:'acc_magnifier',  type:'acc',   name:'Büyüteç',           unlockXp:0,    rarity:'common'    },
  { id:'acc_wings',      type:'acc',   name:'Melek Kanatları',   unlockXp:600,  rarity:'legendary' },
  // BACKGROUNDs
  { id:'bg_classroom',   type:'bg',    name:'Sınıf',             unlockXp:0,    rarity:'common'    },
  { id:'bg_space',       type:'bg',    name:'Uzay',              unlockXp:800,  rarity:'rare'      },
  { id:'bg_underwater',  type:'bg',    name:'Su Altı',           unlockXp:1500, rarity:'legendary' },
]
```

---

## PART 8 — THE WORD BANK & MODULE SYSTEM

### Word Bank

402 Turkish words in `src/domain/words.data.ts`. Each word has this exact structure:

```typescript
interface Word {
  kat:   string    // category e.g. 'Hayvanlar'
  word:  string    // Turkish word e.g. 'kalem'
  emoji: string    // fallback emoji e.g. '✏️'
  syl:   string[]  // syllables e.g. ['ka','lem']
  n:     number    // syllable count e.g. 2
  first: string    // first letter/sound e.g. 'k'
  last:  string    // last letter/sound e.g. 'm'
  rk:    string | null  // rhyme group e.g. 'em' or null
}
```

22 categories: Hayvanlar (61), Ev (40), Doğa (35), Yiyecekler (33), Eğlence (26), Meyveler (22), Okul (20), Sebzeler (18), Araçlar (16), Giysiler (15), Duygular (14), Vücut (14), Meslekler (12), Mekanlar (10), Müzik (10), Rakamlar (10), Nesneler (10), Semboller (10), Renkler (9), Aile (7), İçecekler (6), Sağlık (4).

82 words have hand-drawn SVG illustrations in `src/domain/svg.data.ts`.

### Module Registry (All 24 Modules)

```typescript
// src/domain/modules.registry.ts
// screenType routes to the correct session screen component:
// 'quiz'     → QuizSession (multiple choice)
// 'builder'  → BuilderSession (tile ordering)
// 'phoneme'  → PhonemeSession (keyboard text input)
// 'memory'   → MemorySession (adaptive flash + recall)
// 'visual'   → VisualSession (3×3 tap grid)
// 'explore'  → ExploreSession (word card carousel)

// Level meanings:
// 0 = Hazırlık (preparation)
// 1 = Harf (letter awareness)
// 2 = Hece (syllable)
// 3 = Fonem (phoneme — advanced)
// 5 = Akıcılık (fluency — RAN)

const MODULES_REGISTRY: ModuleDefinition[] = [
  { id:'gorselAlgi',    level:0, screenType:'visual',  requiresPremium:false },
  { id:'kesfet',        level:0, screenType:'explore', requiresPremium:false },
  { id:'tani',          level:0, screenType:'quiz',    requiresPremium:false },
  { id:'kategori',      level:0, screenType:'quiz',    requiresPremium:false },
  { id:'harf',          level:1, screenType:'quiz',    requiresPremium:false },
  { id:'ayirtEtme',     level:1, screenType:'quiz',    requiresPremium:true  },
  { id:'heceBirlestir', level:2, screenType:'builder', requiresPremium:true  },
  { id:'heceC',         level:2, screenType:'quiz',    requiresPremium:true  },
  { id:'hecele',        level:2, screenType:'quiz',    requiresPremium:true  },
  { id:'sonHece',       level:2, screenType:'quiz',    requiresPremium:true  },
  { id:'uzunKelime',    level:2, screenType:'quiz',    requiresPremium:true  },
  { id:'kelimeDizisi',  level:2, screenType:'memory',  requiresPremium:true  },
  { id:'siraliHatirla', level:2, screenType:'memory',  requiresPremium:true  },
  { id:'harfBirlestir', level:3, screenType:'builder', requiresPremium:true  },
  { id:'uyak',          level:3, screenType:'quiz',    requiresPremium:true  },
  { id:'ilkSes',        level:3, screenType:'quiz',    requiresPremium:true  },
  { id:'sonSes',        level:3, screenType:'quiz',    requiresPremium:true  },
  { id:'tamamla',       level:3, screenType:'quiz',    requiresPremium:true  },
  { id:'tamamlaBastan', level:3, screenType:'quiz',    requiresPremium:true  },
  { id:'uyakUretim',    level:3, screenType:'quiz',    requiresPremium:true  },
  { id:'fonemSilme',    level:3, screenType:'phoneme', requiresPremium:true  },
  { id:'ilkHeceSilme',  level:3, screenType:'phoneme', requiresPremium:true  },
  { id:'sonHeceSilme',  level:3, screenType:'phoneme', requiresPremium:true  },
  { id:'ran',           level:5, screenType:'quiz',    requiresPremium:true  },
]
```

### Generator Function Rules

All generator functions in `src/domain/generators/` MUST:
- Be pure functions: `(words: Word[]) => Question[]`
- Import NOTHING from outside `src/domain/`
- Return at minimum 5 questions (filter or pad if needed)
- Filter out null/undefined before returning (`.filter(Boolean)`)
- Use the `shuffle` utility from `src/domain/generators/index.ts`
- Be unit-testable with Jest and zero mocking

---

## PART 9 — LEARNING SYSTEM

### Learn Mode

```
Student taps "Öğren" (Learn)
    ↓
fetch: words WHERE (status = 'unseen' OR no progress record exists)
       for this student, for selected category
    ↓
If 0 unseen words in category: show "Bu kategoriyi tamamladın! 🎉"
    ↓
Present words in random order via selected module
    ↓
Correct answer:
  → upsert student_word_progress: status='learned', learned_at=now()
  → award XP (wordCorrect or wordCorrectPronounce)
  → async: call check-milestone Edge Function (do NOT await — non-blocking)
  → word NEVER appears in Learn Mode again
    ↓
Wrong answer:
  → upsert student_word_progress: times_seen++
  → word re-queued to appear again in this session
    ↓
Session end: save session_log, show result screen
```

### Revision Mode

```
Student taps "Tekrar" (Revision)
    ↓
fetch: words WHERE status = 'learned' for this student
    ↓
If fewer than 5 learned words: show "Önce birkaç kelime öğren! 
                                     Şu an X kelimen var."
    ↓
Present in random order via selected module
    ↓
Correct/wrong: no status change — only session_log saved
Revision NEVER changes word status. Only records practice.
    ↓
Session end: save session_log, show result screen
```

### Milestone Tests

```
After every word marked 'learned', Edge Function check-milestone runs:
    ↓
COUNT(*) WHERE student_id = X AND status = 'learned'
    ↓
For each test_template WHERE is_active = true:
  Check: milestone_threshold <= learned_count
  AND no student_milestone exists for (student_id, test_template_id)
    ↓
If match found:
  INSERT student_milestone (status: 'pending', is_locked: true)
  Send push notification: "🎯 Test zamanı! X kelime öğrendin!"
    ↓
App checks on next launch / return to home:
  If pending milestone exists → show test modal before Learn Mode
  is_locked = true → Learn Mode button disabled with message:
  "Devam etmek için önce testini tamamla! 🎯"
  Teacher can set is_locked = false from student detail screen
```

---

## PART 10 — AUTHENTICATION SYSTEM

### Registration Flow (Exact Steps)

```
1. User fills: full_name, email, password (min 8 chars)
2. App calls supabase.auth.signUp({ email, password, options: { data: { full_name } } })
3. Database trigger fires:
   a. INSERT INTO profiles (id, full_name, role='student', subscription_status='trial')
   b. INSERT INTO student_character (student_id, total_xp=0)
4. Supabase sends verification email automatically (configured in dashboard)
5. App navigates to /auth/verify-email screen (cannot proceed)
6. User taps link in email → deep link: okuma-dedektifi://verify?token=X&type=email
7. App handles deep link: supabase.auth.verifyOtp({ token, type: 'email' })
8. On success → navigate to /onboarding/create-profile
9. On failure → show error with "Tekrar gönder" button
```

### Role Assignment

```
Default role: 'student' (set by DB trigger — NEVER by client)
Admin role:   SET MANUALLY via SQL:
              UPDATE profiles SET role = 'admin' WHERE id = 'uuid-here';
              No UI for this. No invite code. Direct SQL only.

RLS enforces: role column cannot be updated via Supabase client API.
```

### Deep Link Configuration

```javascript
// app.json
{
  "expo": {
    "scheme": "okuma-dedektifi",
    "ios": { "bundleIdentifier": "com.villaakedemia.okumadedektifi" },
    "android": { "package": "com.villaakedemia.okumadedektifi" }
  }
}

// Handled deep links:
// okuma-dedektifi://verify?token=X&type=email   → email verification
// okuma-dedektifi://homework/[id]               → open homework from notification
// okuma-dedektifi://reset-password?token=X      → password reset
```

### Role-Based Navigation

```typescript
// app/_layout.tsx
const session = useSession()
const { role, emailVerified } = useProfile()

useEffect(() => {
  if (!session)              return router.replace('/(auth)/login')
  if (!emailVerified)        return router.replace('/auth/verify-email')
  if (role === 'admin')      return router.replace('/(teacher)')
  /* else student */         return router.replace('/(student)')
}, [session, role, emailVerified])
```

---

## PART 11 — DATABASE SCHEMA (COMPLETE SQL)

Run these in order. ALL tables have RLS enabled.

```sql
-- ================================================================
-- MIGRATION 001: INITIAL SCHEMA
-- ================================================================

-- PROFILES (extends Supabase auth.users)
CREATE TABLE profiles (
  id                   UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role                 TEXT NOT NULL DEFAULT 'student'
                         CHECK (role IN ('student', 'admin')),
  full_name            TEXT NOT NULL,
  display_name         TEXT,
  date_of_birth        DATE,
  avatar_url           TEXT,
  device_push_token    TEXT,
  subscription_status  TEXT NOT NULL DEFAULT 'trial'
                         CHECK (subscription_status IN ('free','trial','student','family','expert')),
  subscription_expires TIMESTAMPTZ,
  revenuecat_id        TEXT,
  email_verified       BOOLEAN DEFAULT false,
  created_at           TIMESTAMPTZ DEFAULT now(),
  updated_at           TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Auto-create profile + character on auth signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO profiles (id, full_name, subscription_status)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', 'Kullanıcı'),
    'trial'
  );
  -- student_character row created after that table exists (migration 002)
  RETURN NEW;
END;
$$;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- TEACHER-STUDENT RELATIONSHIPS
CREATE TABLE teacher_students (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  teacher_id       UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  student_id       UUID REFERENCES profiles(id) ON DELETE SET NULL,
  manual_name      TEXT,
  manual_email     TEXT,
  status           TEXT NOT NULL DEFAULT 'unregistered'
                     CHECK (status IN ('unregistered', 'linked')),
  notes            TEXT,
  linked_at        TIMESTAMPTZ,
  created_at       TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE teacher_students ENABLE ROW LEVEL SECURITY;

-- CATEGORIES
CREATE TABLE categories (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT NOT NULL UNIQUE,
  level       INTEGER NOT NULL DEFAULT 1,
  color_hex   TEXT NOT NULL DEFAULT '#F5A623',
  icon_url    TEXT,
  sort_order  INTEGER DEFAULT 0,
  created_by  UUID REFERENCES profiles(id),
  is_active   BOOLEAN DEFAULT true,
  is_seeded   BOOLEAN DEFAULT false,
  created_at  TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- WORDS
CREATE TABLE words (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id      UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  word_text        TEXT NOT NULL,
  syllables        JSONB NOT NULL DEFAULT '[]',
  syllable_count   INTEGER NOT NULL DEFAULT 1,
  first_sound      TEXT,
  last_sound       TEXT,
  rhyme_group      TEXT,
  svg_content      TEXT,
  image_url        TEXT,
  tts_audio_url    TEXT,
  tts_generated_at TIMESTAMPTZ,
  created_by       UUID REFERENCES profiles(id),
  is_active        BOOLEAN DEFAULT true,
  is_seeded        BOOLEAN DEFAULT false,
  sort_order       INTEGER DEFAULT 0,
  created_at       TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE words ENABLE ROW LEVEL SECURITY;

-- STUDENT WORD PROGRESS
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
ALTER TABLE student_word_progress ENABLE ROW LEVEL SECURITY;
CREATE INDEX idx_swp_student_status ON student_word_progress(student_id, status);

-- SESSION LOGS
CREATE TABLE session_logs (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id       UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  assignment_id    UUID,  -- FK added after assignments table created
  module_id        TEXT NOT NULL,
  module_name      TEXT NOT NULL,
  module_level     INTEGER NOT NULL,
  session_mode     TEXT NOT NULL
                     CHECK (session_mode IN ('free','learn','revision','homework','test')),
  correct_count    INTEGER DEFAULT 0,
  wrong_count      INTEGER DEFAULT 0,
  total_count      INTEGER DEFAULT 0,
  score_percent    INTEGER,
  avg_response_ms  INTEGER,
  max_memory_level INTEGER,
  xp_earned        INTEGER DEFAULT 0,
  duration_sec     INTEGER,
  session_date     DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at       TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE session_logs ENABLE ROW LEVEL SECURITY;
CREATE INDEX idx_sessions_student_date ON session_logs(student_id, session_date);

-- ================================================================
-- MIGRATION 002: CHARACTER SYSTEM
-- ================================================================

CREATE TABLE character_items (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  item_type   TEXT NOT NULL CHECK (item_type IN ('hat','shirt','shoes','acc','bg')),
  name        TEXT NOT NULL,
  lottie_url  TEXT,
  image_url   TEXT,
  unlock_xp   INTEGER NOT NULL DEFAULT 100,
  rarity      TEXT DEFAULT 'common' CHECK (rarity IN ('common','rare','legendary')),
  is_premium  BOOLEAN DEFAULT false,
  sort_order  INTEGER DEFAULT 0,
  is_active   BOOLEAN DEFAULT true
);
ALTER TABLE character_items ENABLE ROW LEVEL SECURITY;

CREATE TABLE student_character (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id     UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE UNIQUE,
  total_xp       INTEGER DEFAULT 0,
  level          INTEGER DEFAULT 1,
  unlocked_items JSONB DEFAULT '[]',
  equipped_hat   UUID REFERENCES character_items(id),
  equipped_shirt UUID REFERENCES character_items(id),
  equipped_shoes UUID REFERENCES character_items(id),
  equipped_acc   UUID REFERENCES character_items(id),
  equipped_bg    UUID REFERENCES character_items(id),
  updated_at     TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE student_character ENABLE ROW LEVEL SECURITY;

CREATE TABLE xp_transactions (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id   UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  amount       INTEGER NOT NULL,
  source       TEXT NOT NULL
                 CHECK (source IN (
                   'word_correct','word_correct_pronounce',
                   'session_complete','session_perfect',
                   'assignment_complete','assignment_perfect',
                   'milestone_test','milestone_test_perfect',
                   'daily_login','streak_3','streak_7','streak_30'
                 )),
  reference_id UUID,
  created_at   TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE xp_transactions ENABLE ROW LEVEL SECURITY;

-- Update trigger to also create student_character row
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO profiles (id, full_name, subscription_status)
  VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'full_name','Kullanıcı'), 'trial');

  INSERT INTO student_character (student_id, total_xp)
  VALUES (NEW.id, 0);

  RETURN NEW;
END;
$$;

-- ================================================================
-- MIGRATION 003: ASSIGNMENTS & TESTS
-- ================================================================

CREATE TABLE test_templates (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title               TEXT NOT NULL,
  description         TEXT,
  word_ids            JSONB NOT NULL DEFAULT '[]',
  word_count          INTEGER NOT NULL DEFAULT 15,
  milestone_threshold INTEGER NOT NULL DEFAULT 50,
  difficulty_level    INTEGER DEFAULT 1,
  is_active           BOOLEAN DEFAULT true,
  created_by          UUID NOT NULL REFERENCES profiles(id),
  created_at          TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE test_templates ENABLE ROW LEVEL SECURITY;

CREATE TABLE student_milestones (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id       UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  test_template_id UUID NOT NULL REFERENCES test_templates(id),
  triggered_at     TIMESTAMPTZ DEFAULT now(),
  status           TEXT DEFAULT 'pending'
                     CHECK (status IN ('pending','completed','skipped')),
  completed_at     TIMESTAMPTZ,
  score_percent    INTEGER,
  is_locked        BOOLEAN DEFAULT true,
  teacher_override BOOLEAN DEFAULT false
);
ALTER TABLE student_milestones ENABLE ROW LEVEL SECURITY;

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
ALTER TABLE assignments ENABLE ROW LEVEL SECURITY;

-- Add FK to session_logs
ALTER TABLE session_logs
  ADD CONSTRAINT fk_session_assignment
  FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE SET NULL;

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
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- ================================================================
-- MIGRATION 004: TEACHER NOTES
-- ================================================================

CREATE TABLE teacher_notes (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  teacher_id     UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  student_id     UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  note_date      DATE NOT NULL DEFAULT CURRENT_DATE,
  content        TEXT NOT NULL,
  include_report BOOLEAN DEFAULT false,
  note_type      TEXT DEFAULT 'general'
                   CHECK (note_type IN ('general','observation','recommendation','goal')),
  created_at     TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE teacher_notes ENABLE ROW LEVEL SECURITY;
CREATE INDEX idx_notes_teacher_student ON teacher_notes(teacher_id, student_id);

-- ================================================================
-- ROW LEVEL SECURITY POLICIES
-- ================================================================

-- profiles: users see own, admins see all
CREATE POLICY "profiles_own" ON profiles FOR ALL USING (auth.uid() = id);
CREATE POLICY "profiles_admin_read" ON profiles FOR SELECT
  USING (EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin'));

-- Role cannot be changed via API
CREATE POLICY "no_role_change" ON profiles FOR UPDATE
  USING (true)
  WITH CHECK (role = (SELECT role FROM profiles WHERE id = auth.uid()));

-- words: everyone reads active, only admin writes
CREATE POLICY "words_public_read" ON words FOR SELECT USING (is_active = true);
CREATE POLICY "words_admin_write" ON words FOR INSERT UPDATE DELETE
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

-- categories: same as words
CREATE POLICY "categories_public_read" ON categories FOR SELECT USING (is_active = true);
CREATE POLICY "categories_admin_write" ON categories FOR INSERT UPDATE DELETE
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

-- student_word_progress: own data only
CREATE POLICY "swp_own" ON student_word_progress FOR ALL USING (auth.uid() = student_id);

-- session_logs: own + teacher sees linked students
CREATE POLICY "sessions_own" ON session_logs FOR ALL USING (auth.uid() = student_id);
CREATE POLICY "sessions_teacher" ON session_logs FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM teacher_students
    WHERE teacher_id = auth.uid() AND student_id = session_logs.student_id AND status = 'linked'
  ));

-- student_character: own data only
CREATE POLICY "character_own" ON student_character FOR ALL USING (auth.uid() = student_id);

-- character_items: everyone reads
CREATE POLICY "items_public_read" ON character_items FOR SELECT USING (is_active = true);
CREATE POLICY "items_admin_write" ON character_items FOR INSERT UPDATE DELETE
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

-- xp_transactions: own data, append-only from client
CREATE POLICY "xp_own_read" ON xp_transactions FOR SELECT USING (auth.uid() = student_id);
-- INSERT only via service role (Edge Function) — no direct client insert

-- assignments: student sees own, teacher sees theirs
CREATE POLICY "assignments_student" ON assignments FOR SELECT USING (auth.uid() = student_id);
CREATE POLICY "assignments_teacher" ON assignments FOR ALL USING (auth.uid() = teacher_id);

-- teacher_students: teachers manage own
CREATE POLICY "ts_teacher" ON teacher_students FOR ALL USING (auth.uid() = teacher_id);

-- teacher_notes: teacher manages own, student cannot see
CREATE POLICY "notes_teacher" ON teacher_notes FOR ALL USING (auth.uid() = teacher_id);

-- notifications: own data
CREATE POLICY "notif_own" ON notifications FOR ALL USING (auth.uid() = recipient_id);

-- student_milestones: own
CREATE POLICY "milestones_own" ON student_milestones FOR SELECT USING (auth.uid() = student_id);
CREATE POLICY "milestones_teacher" ON student_milestones FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM teacher_students
    WHERE teacher_id = auth.uid() AND student_id = student_milestones.student_id
  ));

-- test_templates: admin creates, linked students can read (for their tests)
CREATE POLICY "tests_admin" ON test_templates FOR ALL
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));
CREATE POLICY "tests_student_read" ON test_templates FOR SELECT USING (is_active = true);
```

---

## PART 12 — SECURITY ARCHITECTURE

### Security Layers (All Required)

**Layer 1 — Database:** RLS on every table. No exceptions. Even if someone has a valid JWT and queries Supabase directly, they cannot read another user's data. This is the most important layer.

**Layer 2 — API keys:** `SUPABASE_ANON_KEY` is safe to expose (RLS protects data). `SUPABASE_SERVICE_ROLE_KEY`, `GOOGLE_TTS_KEY`, `WHISPER_SECRET_TOKEN`, `REVENUECAT_SECRET_KEY` — NEVER in client code, only in Edge Functions.

**Layer 3 — Input validation:** All user input validated with Zod before touching DB.

```typescript
// Example validation in use case:
import { z } from 'zod'
const SessionResultSchema = z.object({
  moduleId:     z.string().min(1).max(50),
  correctCount: z.number().int().min(0).max(100),
  wrongCount:   z.number().int().min(0).max(100),
  durationSec:  z.number().int().min(0).max(3600),
})
export async function saveSession(raw: unknown) {
  const result = SessionResultSchema.parse(raw)  // throws ZodError if invalid
  await progressRepo.saveSession(result)
}
```

**Layer 4 — Subscription:** Never trust client-reported subscription status. Always verify against DB. DB value is set by Edge Function calling RevenueCat server-to-server.

**Layer 5 — Child privacy (KVKK/COPPA):**
- No third-party analytics SDKs that track children
- Voice recordings deleted immediately after evaluation (never stored)
- Teacher access limited to non-sensitive progress data
- Account deletion cascades to all child data (CASCADE in DB schema above)
- Privacy policy URL displayed in app settings

**Layer 6 — Error messages:** Never expose raw errors or stack traces to users.

```typescript
const ERROR_MESSAGES: Record<string, string> = {
  network_error:          'İnternet bağlantısı yok.',
  auth_invalid:           'E-posta veya şifre hatalı.',
  subscription_expired:   'Aboneliğin sona erdi.',
  whisper_not_ready:      'Ses özelliği şu an kullanılamıyor.',
  generic:                'Bir şeyler ters gitti. Tekrar dene.',
}
```

---

## PART 13 — SPEECH RECOGNITION SYSTEM

### Architecture

```
React Native app (records audio)
        ↓  base64 audio + expected word
Supabase Edge Function: evaluate-pronunciation
        ↓  audio + secret token
HuggingFace ZeroGPU Space (runs Whisper large-v3-turbo)
        ↓  { transcript, similarity, correct }
Edge Function returns result to app
        ↓
Audio is NEVER stored. Deleted from memory after processing.
```

### HuggingFace Space (Python — you deploy this separately)

```python
# app.py — Deploy on HuggingFace Spaces, ZeroGPU hardware
# Stack: faster-whisper + FastAPI + @spaces.GPU decorator
import spaces, base64, os, tempfile
from fastapi import FastAPI, HTTPException, Header
from pydantic import BaseModel
from faster_whisper import WhisperModel

app = FastAPI()
model = WhisperModel("large-v3-turbo", device="cuda", compute_type="float16")
SECRET_TOKEN = os.environ["WHISPER_SECRET_TOKEN"]

class TranscribeRequest(BaseModel):
    audio_base64: str
    language: str = "tr"
    expected_word: str = ""

@app.post("/transcribe")
@spaces.GPU
async def transcribe(req: TranscribeRequest, x_token: str = Header(None)):
    if x_token != SECRET_TOKEN:
        raise HTTPException(status_code=401)

    audio_bytes = base64.b64decode(req.audio_base64)
    with tempfile.NamedTemporaryFile(suffix=".wav", delete=True) as tmp:
        tmp.write(audio_bytes)
        tmp.flush()
        segments, _ = model.transcribe(
            tmp.name, language=req.language,
            beam_size=1, vad_filter=True,
            initial_prompt="Tek Türkçe kelime:"
        )

    transcript = " ".join(s.text for s in segments).strip().lower()
    similarity = levenshtein_similarity(transcript, req.expected_word.lower())

    return { "transcript": transcript, "similarity": round(similarity, 3),
             "correct": similarity >= 0.80 }

def levenshtein_similarity(a: str, b: str) -> float:
    if not a or not b: return 0.0
    dp = list(range(len(b) + 1))
    for i, c1 in enumerate(a):
        prev, dp[0] = dp[0], i + 1
        for j, c2 in enumerate(b):
            prev, dp[j+1] = dp[j+1], prev if c1==c2 else 1+min(prev, dp[j], dp[j+1])
    return 1 - dp[len(b)] / max(len(a), len(b))
```

### Supabase Edge Function (TypeScript Proxy)

```typescript
// supabase/functions/evaluate-pronunciation/index.ts
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'

const WHISPER_URL   = Deno.env.get('WHISPER_HF_ENDPOINT')!   // set in Supabase secrets
const WHISPER_TOKEN = Deno.env.get('WHISPER_SECRET_TOKEN')!   // set in Supabase secrets

serve(async (req) => {
  const { audioBase64, expectedWord } = await req.json()

  const response = await fetch(`${WHISPER_URL}/transcribe`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'X-Token': WHISPER_TOKEN },
    body: JSON.stringify({ audio_base64: audioBase64, language: 'tr', expected_word: expectedWord }),
  })

  if (!response.ok) {
    return new Response(JSON.stringify({ error: 'Speech service unavailable' }), { status: 503 })
  }

  const result = await response.json()
  // Audio never stored — return result only
  return new Response(JSON.stringify({
    correct:    result.correct,
    transcript: result.transcript,
    similarity: result.similarity,
  }), { headers: { 'Content-Type': 'application/json' } })
})
```

### React Native Mic Flow

```typescript
// src/presentation/hooks/useMicrophone.ts
// 1. Request permission (expo-av)
// 2. Show 3-second countdown animation
// 3. Start recording (max 5 seconds, auto-stop on silence)
// 4. Convert recording to base64
// 5. Call supabase.functions.invoke('evaluate-pronunciation', { body: {...} })
// 6. Show result animation
// 7. Max 3 attempts per word before showing correct answer

// Offline handling:
// If network unavailable → show "İnternet gerekli 📶" toast
// Skip this question or show next without penalty
```

---

## PART 14 — TTS AUDIO SYSTEM

### When Audio is Generated

Audio is generated ONCE when admin saves a new word. It is never regenerated unless admin clicks "Sesi Yenile" button.

```typescript
// supabase/functions/generate-tts/index.ts
// Called by: teacher panel when saving a new word
// Calls: Google Cloud TTS API
// Stores: MP3 in Supabase Storage at /audio/words/{word_id}.mp3
// Updates: words.tts_audio_url + words.tts_generated_at

const TTS_CONFIG = {
  voice: {
    languageCode: 'tr-TR',
    name: 'tr-TR-Wavenet-B',  // warm, natural Turkish
    ssmlGender: 'NEUTRAL',
  },
  audioConfig: {
    audioEncoding: 'MP3',
    speakingRate: 0.85,   // slightly slower for learning
    pitch: 0.5,           // slightly higher, child-friendly
  },
}
```

### Seeding Audio for 402 Words

On first deploy, run a seed script that calls the Edge Function for each of the 402 words. Estimated cost: < $0.01 total.

---

## PART 15 — SUBSCRIPTION SYSTEM

### Plans

```
FREE (forever, after 7-day trial expires)
├── First 3 categories: Hayvanlar, Meyveler, Renkler
├── Level 0 modules only (gorselAlgi, kesfet, tani, kategori)
├── harf module (Level 1) — shows value, encourages upgrade
├── Base character + 3 starter items
├── Progress: last 7 days
└── 1 PDF report/month

STUDENT PREMIUM (₺49/month or ₺349/year)
├── All 22 categories, all 402 words
├── All 24 modules
├── Learn Mode + Revision Mode tracking
├── Milestone tests
├── TTS audio for all words
├── Microphone pronunciation
├── Full character system
├── Unlimited progress history
└── Unlimited PDF reports

EXPERT (₺149/month or ₺999/year)
├── Everything in Student Premium
├── Teacher dashboard
├── Student management
├── Homework assignment
├── Test template creation
├── Teacher-version PDF reports
├── Push notifications (homework alerts)
└── Word and category management
```

### Paywall UX Rules

```
- Show paywall BEFORE starting a locked module (never interrupt mid-session)
- Show a preview: first 3 questions of locked module, then paywall
- Display yearly as "2 ay bedava!" next to the price (highest converting copy)
- Character visible on paywall, wearing a cool locked item ("Bunu kazanmak ister misin?")
- Never use word "premium" in child-facing UI — use "tam erişim" or "tüm özellikler"
- Paywall price in Turkish Lira: ₺49/ay format
```

### Entitlement Checking

```typescript
// src/presentation/components/PremiumGate.tsx
// Reads from Supabase profile.subscription_status (server-verified, never client-trusted)
// Wraps any component that requires a paid plan
// Shows PaywallScreen when access is denied

const PremiumGate: React.FC<{ feature: EntitlementKey; children: ReactNode }> = ({
  feature, children
}) => {
  const { hasAccess } = useSubscription()
  if (hasAccess(feature)) return <>{children}</>
  return <PaywallScreen feature={feature} />
}
```

---

## PART 16 — DEPLOYMENT

### Supabase (Backend)

```
Region:  eu-central-1 (Frankfurt) — closest to Turkey, GDPR compliant
Project: Create on supabase.com
Cost:    Free tier covers MVP (500MB DB, 1GB storage, 50k MAU)
         Upgrade to Pro ($25/mo) when storage or MAU exceeded

Environment variables (set in Supabase dashboard secrets):
  GOOGLE_TTS_API_KEY       = [Google Cloud API key]
  WHISPER_HF_ENDPOINT      = https://[your-hf-username]-whisper-tr.hf.space
  WHISPER_SECRET_TOKEN     = [generate: openssl rand -base64 32]
  REVENUECAT_SECRET_KEY    = [from RevenueCat dashboard]
  EXPO_PUSH_ACCESS_TOKEN   = [from Expo dashboard]
```

### HuggingFace Space (Whisper Server)

```
Account: Free HuggingFace account
Space:   Create new Space → SDK: Docker or Gradio → Hardware: ZeroGPU (free)
Name:    [your-username]/whisper-tr
Deploy:  Upload app.py + requirements.txt
Secrets: Set WHISPER_SECRET_TOKEN (same value as in Supabase)
Cost:    $0 (ZeroGPU free tier — shared GPU, queued)

requirements.txt:
  faster-whisper
  fastapi
  uvicorn
  python-multipart
  spaces
```

### React Native App (Expo)

```
Build:   Expo EAS Build
  eas build --platform android   → .aab for Google Play
  eas build --platform ios       → .ipa for App Store

Submit:  eas submit               → submits to both stores

OTA updates: expo publish         → JS changes without store review

Environment variables (.env, NEVER commit):
  EXPO_PUBLIC_SUPABASE_URL      = https://[project-ref].supabase.co
  EXPO_PUBLIC_SUPABASE_ANON_KEY = [from Supabase dashboard]
  EXPO_PUBLIC_REVENUECAT_IOS    = [RevenueCat iOS API key]
  EXPO_PUBLIC_REVENUECAT_ANDROID= [RevenueCat Android API key]
  # Note: EXPO_PUBLIC_ prefix makes variables available to client bundle
  # Service role keys go in Supabase Edge Function secrets only
```

---

## PART 17 — TEACHER PANEL COMPLETE SPEC

### Teacher Dashboard Screen

```
Header: "Merhaba, [teacher name] 👋"
Cards row:
  - Aktif Öğrenci: [count today]
  - Bekleyen Ödev: [pending assignments count]
  - Geciken Ödev: [overdue — red badge if > 0]
Recent notifications list (last 10, tap → navigate to relevant screen)
Quick action: "Ödev Ver" button → create assignment
```

### My Students Screen

```
Two-tab layout: "Öğrencilerim" | "Tüm Kullanıcılar"

ÖĞRENCILERIM tab:
  Search bar
  Filter: Tümü | Bağlı | Kayıtsız
  Each student card:
    - Display name
    - Status badge (Bağlı: green / Kayıtsız: gray)
    - Last active date
    - Accuracy this week (if linked)
  Add Student button → modal:
    Option A: Enter name + email (manual, no app needed — Status A)
    Option B: Search existing users by email (link existing account — Status C)

TÜM KULLANICILAR tab:
  Shows app users NOT linked to this teacher
  Shown: first name only, registration date, last active
  NOT shown: email, full name, any sensitive data
  "Öğrencime Ekle" button per row
```

### Student Detail Screen

```
Header: student name + avatar + status badge
Progress summary cards: total learned, this week, accuracy
Weekly activity chart (bar chart, sessions per day)
Module breakdown: each module the student has used, with accuracy %
Assignment section: list of assigned homework + status
Teacher notes section:
  + Add Note button
  Note types: Genel | Gözlem | Öneri | Hedef
  Include in report: toggle (appears in PDF if enabled)
Bottom actions:
  "Ödev Ver" | "Test Ata" | "Raporu İndir"
Teacher unlock: if milestone is_locked = true, show "Kilidi Kaldır" button
```

### Word Management Screen

```
Words list: search, filter by category, sort by date/alpha
Each row: word text, category badge, TTS status indicator, active toggle

Add Word form:
  - Word text (required) — real-time syllable auto-suggestion shown below
  - Category (dropdown, required)
  - Syllable breakdown (auto-suggested, tap to override)
  - First/last sound (auto-derived, editable)
  - Rhyme group (optional)
  - Image: upload photo OR paste SVG code
  - Preview card: shows exactly what child will see
  - Save button: triggers TTS generation + shows progress indicator
  - TTS generated: green checkmark appears on word row

Cannot delete seeded words (is_seeded = true). Admin can deactivate.
```

### Test Template Creator

```
Form:
  Title (required)
  Description (optional)
  Milestone threshold: 50 / 100 / 150 / [custom input]
  Words: word picker with search + category filter
    - Minimum 10, recommended 15, maximum 20
    - Each word shows SVG preview + category
  Lock Learn Mode: toggle (default: ON)
    - "Öğrenci bu testi bitirene kadar yeni kelime öğrenemez"

Save → test_template INSERT
  → All linked students will be checked against this threshold
  → Students who already crossed threshold immediately get milestone inserted
```

---

## PART 18 — PDF REPORTS

Both versions generated in Phase 1 (MVP).

### Student Report

```
Generated by: student (progress tab) or teacher (student detail)
Contents:
  Header:    Villa Akademia logo + student name + week range
  Summary:   sessions, XP earned, words learned this week
  Words:     list of new words learned with category labels
  Modules:   accuracy per module (horizontal bar chart, SVG inline)
  Character: current character with equipped items (fun, motivating)
  Stars:     "Bu hafta X yıldız kazandın! ⭐⭐⭐"
  Footer:    Okuma Dedektifi + date
Style: colorful, child-friendly, A4
```

### Teacher Report (Superset)

```
Generated by: teacher only (student detail screen)
Additional contents:
  Clinical Notes: teacher_notes WHERE include_report = true
                  Grouped by note_type (Gözlem | Öneri | Hedef)
  Parent Recommendations: free text section teacher fills before export
  Week-over-week: accuracy % change from previous week
  Weak areas: specific word list where error rate > 40%
  RAN speed: if student has RAN sessions, show avg ms trend
  Signature: "Uzman: [teacher name] · Tarih: [date]" + blank line for handwritten signature
Style: clinical, clean, printable, A4
```

---

## PART 19 — PUSH NOTIFICATIONS

### Types and Triggers

```typescript
// Triggered by Edge Function send-notification

type NotificationType =
  | 'assignment_complete'    // student finishes homework → teacher notified
  | 'assignment_due_soon'    // 24h before due date → student notified
  | 'assignment_overdue'     // due date passed → teacher notified
  | 'milestone_reached'      // 50 words learned → student notified
  | 'test_available'         // milestone test triggered → student notified
  | 'item_unlocked'          // new XP threshold crossed → student notified
  | 'streak_reminder'        // 2 days no activity → student notified (opt-in only)
  | 'weekly_summary'         // every Sunday → teacher (summary of all students)
```

### Notification Content

```
assignment_complete:
  To: teacher
  Title: "🎉 Ödev Tamamlandı!"
  Body:  "{student_name} '{module_name}' ödevini tamamladı. Başarı: %{score}"
  Tap action: open student detail screen

milestone_reached:
  To: student
  Title: "🏆 Süpersin!"
  Body:  "{count} kelime öğrendin! Şimdi test zamanı 🎯"
  Tap action: open milestone test

item_unlocked:
  To: student
  Title: "🎁 Yeni ödül!"
  Body:  "'{item_name}' kilidi açıldı! Hemen giy!"
  Tap action: open rewards screen
```

---

## PART 20 — OFFLINE BEHAVIOR

### What is Cached on First Login

```
Immediate (blocks navigation until ready):
  - User profile + subscription status
  - All categories metadata
  - All words (text + SVG, no audio)
  - Student word progress (status per word)

Background (after home screen loads):
  - TTS audio for first 3 categories
  - Character items metadata

On-demand:
  - TTS audio for other categories (cached when category first opened)
```

### Offline-Capable Features

```
✅ All 24 exercise modules (except mic/pronunciation)
✅ Learn Mode (uses cached words, queues progress sync)
✅ Revision Mode
✅ Character dress-up
✅ Progress screen (shows cached data with "Son güncelleme: X dakika önce")

❌ Microphone pronunciation evaluation (shows "İnternet gerekli 📶" instead)
❌ Push notifications (received when reconnected)
❌ PDF report generation with teacher notes (needs live DB)
```

### Offline Sync Queue

```typescript
// When offline:
// Session results → saved to expo-sqlite (local queue)
// Word progress updates → saved to expo-sqlite

// On reconnect (app foreground or background sync):
const unsyncedSessions = await sqlite.getUnsyncedSessions()
for (const session of unsyncedSessions) {
  await supabase.from('session_logs').insert(session)
  await sqlite.markSynced(session.id)
}
```

---

## PART 21 — BUILD ORDER (WEEK BY WEEK)

Follow this order exactly. Later steps depend on earlier ones being complete and tested.

```
Week 1–2:  Supabase setup
           - Create project (eu-central-1)
           - Run all 4 migration files
           - Verify RLS policies with test queries
           - Seed 22 categories + 402 words + character items
           - Configure email verification template (Turkish)
           - Set up Storage buckets (audio/, images/)

Week 3–4:  Expo project setup + auth flow
           - Initialize Expo project with TypeScript
           - Install all dependencies from Part 3
           - Configure app.json (deep links, bundle IDs)
           - Build auth screens (login, register, verify-email)
           - Build root layout with role-based routing
           - Build onboarding screens

Week 5–6:  Domain layer + infrastructure
           - Port all 402 words to words.data.ts
           - Port all 82 SVGs to svg.data.ts
           - Write all 23 generator functions (one per module except gorselAlgi)
           - Build MODULES_REGISTRY with all metadata
           - Implement container.ts with all interfaces
           - Implement Supabase repositories

Week 7–8:  Core student screens (no audio yet)
           - Home screen (character placeholder, XP bar, quick actions)
           - Learn Mode (category picker + all session screens)
           - All 5 session screen types (quiz, builder, phoneme, memory, visual, explore)
           - Result screen (5-star animation)
           - Practice screen (module grid)

Week 9:    Audio system
           - TTS Edge Function
           - Audio playback hook (expo-av)
           - Speaker button on word cards
           - Seed all 402 word audio files via Edge Function

Week 10:   Microphone system
           - Deploy HuggingFace Whisper Space
           - Edge Function proxy
           - Recording hook (expo-av recording mode)
           - MicButton component with pulse animation
           - Pronunciation evaluation UX

Week 11:   Character system
           - CharacterView component (Animated SVG)
           - All 7 animation states
           - XP award use case
           - Character equipment system
           - Rewards screen (dress-up)

Week 12–13: Teacher panel
           - Dashboard screen
           - Student list (my students + all users)
           - Student detail screen
           - Assignment creation form
           - Assignment list
           - Word management (add + TTS generation UI)
           - Category management
           - Test template creator

Week 14:   Milestone tests + notifications
           - check-milestone Edge Function
           - student_milestones table + UI blocking
           - Milestone test screen
           - Push notification Edge Function
           - All notification types wired up

Week 15:   PDF reports
           - Student report template (HTML → PDF)
           - Teacher report template (HTML → PDF)
           - Export button in student progress screen
           - Export button in teacher student detail

Week 16:   Subscriptions
           - RevenueCat integration
           - PremiumGate component
           - Paywall screen with pricing display
           - validate-subscription Edge Function
           - Free tier enforcement on all gated features

Week 17:   Offline mode
           - expo-sqlite session queue
           - MMKV word progress cache
           - Audio file caching (Expo FileSystem)
           - Sync-on-reconnect logic
           - Offline indicators in UI

Week 18:   Testing + hardening
           - Unit tests for all generator functions
           - Unit tests for all use cases
           - RLS policy tests (attempt cross-user data access, verify denial)
           - Subscription gate tests
           - End-to-end: register → verify → learn 3 words → see XP

Week 19–20: Polish + store preparation
           - App icon + splash screen
           - Privacy policy screen (required for App Store)
           - Store screenshots (Turkish, both platforms)
           - TestFlight (iOS) + Internal testing track (Android)
           - Beta test with real children (minimum 5 sessions)
           - Fix issues from beta

Week 21:   Submission
           - eas submit for both platforms
           - App Store review (expect 1–3 days)
           - Google Play review (expect 1–3 days)
           - Prepare launch announcement

Week 22:   Launch 🚀
```

---

## PART 22 — CODING STANDARDS

### TypeScript Rules

```typescript
// Zero 'any' — use 'unknown' if type is truly unknown
// All exported functions have return type annotations
// All exported functions have JSDoc comments

/**
 * Awards XP to student and checks for item unlocks.
 * Handles level-up if threshold crossed.
 */
export async function awardXP(
  studentId: string,
  amount: number,
  source: XPSource,
  referenceId?: string,
): Promise<StudentCharacter> { ... }
```

### No Magic Numbers

```typescript
// src/config/constants.ts — ALL magic numbers live here
export const PRONUNCIATION_THRESHOLD = 0.80   // min similarity for "correct"
export const MILESTONE_DEFAULT       = 50     // words before first test
export const MAX_MIC_ATTEMPTS        = 3      // before showing correct answer
export const IDLE_SLEEP_TIMEOUT_MS   = 30_000 // before character sleeps
export const SESSION_QUESTION_COUNT  = 20     // questions per session
export const MAX_SESSION_LOG_STORED  = 500    // localStorage/AsyncStorage limit
export const MAX_OFFLINE_QUEUE       = 100    // SQLite sessions before forced sync
```

### File Structure Enforcement

```
src/domain/      → zero imports from outside src/domain/
src/application/ → imports only from src/domain/
src/infrastructure/ → imports from src/domain/ + external packages
src/presentation/  → imports from src/application/ + src/domain/ + src/infrastructure/container.ts
```

### Error Handling Pattern

```typescript
// Every async operation: try/catch with user-friendly Turkish message
// Never show raw errors to users
// Log errors to console in development, suppress in production

try {
  await progressRepo.saveSession(result)
} catch (error) {
  console.error('[saveSession] failed:', error)
  showToast(ERROR_MESSAGES.generic)
  // Don't re-throw unless caller needs to know
}
```

### Component Pattern

```typescript
// Functional components only — no class components
// Props interface defined above component
// Hooks at top, derived state next, handlers next, return last
// StyleSheet.create() for all styles — no inline style objects in JSX

interface WordCardProps {
  word: Word
  onPress?: () => void
  showAudio?: boolean
}

const WordCard: React.FC<WordCardProps> = ({ word, onPress, showAudio = true }) => {
  // 1. Hooks
  const { playAudio } = useAudio()
  const animatedScale = useSharedValue(1)

  // 2. Derived state
  const svgContent = SVG_DATA[word.word] ?? null

  // 3. Handlers
  const handlePress = () => {
    animatedScale.value = withSpring(0.95, springConfigs.press, () => {
      animatedScale.value = withSpring(1)
    })
    onPress?.()
  }

  // 4. Render
  return (
    <Animated.View style={[styles.card, animatedStyle]}>
      {/* ... */}
    </Animated.View>
  )
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: colors.surface,
    borderRadius: radius.card,
    padding: spacing.lg,
    ...shadows.card,
  },
})
```

---

## PART 23 — ENVIRONMENT VARIABLES REFERENCE

```bash
# .env.example — commit this file, not .env

# Supabase (client-safe, prefixed EXPO_PUBLIC_)
EXPO_PUBLIC_SUPABASE_URL=https://[project-ref].supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=[anon key from Supabase dashboard]

# RevenueCat (client-safe, different keys per platform)
EXPO_PUBLIC_REVENUECAT_IOS=[iOS public API key]
EXPO_PUBLIC_REVENUECAT_ANDROID=[Android public API key]

# --- NEVER put these in .env — they go in Supabase Edge Function secrets ---
# SUPABASE_SERVICE_ROLE_KEY=[service role key]
# GOOGLE_TTS_API_KEY=[Google Cloud API key]
# WHISPER_HF_ENDPOINT=https://[hf-username]-whisper-tr.hf.space
# WHISPER_SECRET_TOKEN=[generate with: openssl rand -base64 32]
# REVENUECAT_SECRET_KEY=[RevenueCat server secret]
```

---

## PART 24 — WHAT TO BUILD FIRST

Start with Week 1 from Part 21. The first deliverable is:

1. Supabase project created in eu-central-1
2. All 4 migration SQL files executed successfully
3. RLS policies verified (test by querying as a non-owner user)
4. 22 categories seeded from the word bank
5. All 402 words seeded into the `words` table
6. 17 character items seeded into `character_items`
7. Supabase Storage buckets created: `audio` (public), `images` (public), `reports` (private)
8. `generate-tts` Edge Function deployed and tested with one word
9. `validate-subscription` Edge Function scaffolded (RevenueCat not configured yet — stub returning trial status)
10. `.env.example` committed with correct variable names

**Do not start the React Native app until the database is running, seeded, and verified.**

---

## APPENDIX A — PEDAGOGICAL MODULE DESCRIPTIONS

Each module in MODULES_REGISTRY includes `science` and `familyTip` fields. These are displayed to teachers (via the ℹ button on module cards) and in the onboarding guide. They are based on real academic research and must not be paraphrased or removed.

Full text for all 24 modules is already embedded in the teacher's HTML prototype file (`fonoloji-atolyesi.html`) in the `MODULLER` JavaScript array, fields `bilim` and `aile`. Port these verbatim to the TypeScript registry.

---

## APPENDIX B — ADAPTIVE DIFFICULTY SYSTEM (Memory Modules)

Modules `kelimeDizisi` and `siraliHatirla` use an adaptive difficulty system. This logic is already implemented and tested in the HTML prototype. Port it exactly.

```
State:
  level:       integer (current word count shown), starts at 3
  ardisik:     integer (consecutive correct answers), starts at 0
  hataSonrasi: boolean (in post-error mode), starts at false
  maxLevel:    integer (highest level reached), starts at 3
  totalCount:  integer (total rounds played), starts at 0

Rules:
  Normal mode:
    3 consecutive correct → level+1 (max 7), ardisik resets to 0
    1 wrong              → level-1 (min 2), ardisik resets to 0, hataSonrasi=true

  hataSonrasi mode (post-error recovery):
    2 consecutive correct → level+1, ardisik resets, hataSonrasi=false
    1 wrong              → level-1 (min 2), ardisik resets (stay in hataSonrasi)

  Session ends after 30 total rounds.
  maxLevel shown on result screen: "En yüksek seviye: X birim 🏆"
```

---

## APPENDIX C — QUICK REFERENCE: RAN MODULE TIMING

The RAN (Rapid Automatic Naming) module measures response speed in milliseconds. This is a clinical diagnostic tool — accuracy of timing matters.

```typescript
// In QuizSession when module is RAN:
const questionStartTime = Date.now()

// On answer:
const responseTimeMs = Date.now() - questionStartTime

// Store in session_log.avg_response_ms (average across all correct answers)
// Display on result screen: "Ortalama: X.X saniye/kelime"
// Color coding:
//   < 1500ms: colors.success  (fast — strong fluency)
//   1500-3000ms: colors.warning (moderate)
//   > 3000ms: colors.error    (slow — intervention needed)

// Progress tracking: compare avg_response_ms week over week
// Improvement (lower ms) = positive indicator in teacher PDF report
```

---

*Document version: FINAL*
*App: Okuma Dedektifi*
*Package: com.villaakedemia.okumadedektifi*
*Developer: Ali Sağlam / Villa Akademia*
*Last updated: April 2026*
*Pass this entire file to the AI coding agent before any code is written.*