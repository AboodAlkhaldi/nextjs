# The Exhaustive React Native & Expo Developer Guide
## Architecture, Use Cases, Best Practices, Pitfalls, and Production Patterns

> **Version:** 2025 Edition | **React Native:** 0.73+ | **Expo SDK:** 50+  
> **Audience:** Junior to Senior developers building cross-platform mobile applications

---

## Table of Contents

1. [Introduction & Philosophy](#1-introduction--philosophy)
2. [What Is React Native?](#2-what-is-react-native)
3. [What Is Expo?](#3-what-is-expo)
4. [Architecture Deep Dive](#4-architecture-deep-dive)
5. [When to Use React Native](#5-when-to-use-react-native)
6. [When NOT to Use React Native](#6-when-not-to-use-react-native)
7. [When to Use Expo](#7-when-to-use-expo)
8. [When NOT to Use Expo](#8-when-not-to-use-expo)
9. [Core Components & APIs](#9-core-components--apis)
10. [Navigation](#10-navigation)
11. [State Management](#11-state-management)
12. [Styling in React Native](#12-styling-in-react-native)
13. [Networking & Data Fetching](#13-networking--data-fetching)
14. [Performance Optimization](#14-performance-optimization)
15. [Testing Strategy](#15-testing-strategy)
16. [Security Best Practices](#16-security-best-practices)
17. [Native Modules & Bridging](#17-native-modules--bridging)
18. [Expo-Specific Features](#18-expo-specific-features)
19. [Deployment & CI/CD](#19-deployment--cicd)
20. [Real-World Use Cases with Full Code](#20-real-world-use-cases-with-full-code)
21. [Common Pitfalls & How to Avoid Them](#21-common-pitfalls--how-to-avoid-them)
22. [Ecosystem & Library Recommendations](#22-ecosystem--library-recommendations)
23. [Migration Patterns](#23-migration-patterns)
24. [Accessibility](#24-accessibility)
25. [Internationalization & Localization](#25-internationalization--localization)
26. [Offline-First Architecture](#26-offline-first-architecture)
27. [Deep Linking & Universal Links](#27-deep-linking--universal-links)
28. [Push Notifications](#28-push-notifications)
29. [App Store Submission Checklist](#29-app-store-submission-checklist)
30. [Interview Questions & Conceptual Summary](#30-interview-questions--conceptual-summary)

---

## 1. Introduction & Philosophy

React Native was born from Facebook's need to build native mobile apps with the speed and iteration cycle of the web. Rather than building two separate codebases for iOS and Android, React Native allows teams to write JavaScript (or TypeScript) and compile to genuinely native UI components — not WebViews, not hybrid shells.

### The Core Promise

React Native's promise is **"learn once, write anywhere."** This is deliberately different from "write once, run anywhere" (Java's promise) because React Native acknowledges that iOS and Android have different design philosophies, interaction patterns, and user expectations. You learn React's component model and JavaScript, but you may write platform-specific code where it matters.

### Philosophy Principles

**1. Native by Default**  
React Native components map to real native views. A `<View>` becomes a `UIView` on iOS and an `android.view.View` on Android. This means you get access to accessibility APIs, animation frameworks, and platform semantics automatically.

**2. JavaScript for Logic, Native for Rendering**  
Business logic, state, network calls, and component trees all live in JavaScript. The rendering layer executes in the native thread, giving you 60fps animations and smooth scrolling.

**3. Gradual Adoption**  
You can embed React Native screens inside an existing native app. Major companies like Facebook, Instagram, and Shopify use React Native for specific features while keeping their native codebase for others.

**4. Open Source Ecosystem**  
React Native benefits from NPM's massive ecosystem. Any pure JavaScript library works directly. Many popular packages have React Native wrappers.

---

## 2. What Is React Native?

React Native is an open-source framework developed by Meta (formerly Facebook) that allows developers to build mobile applications using JavaScript and React. Released in 2015, it has become one of the most popular frameworks for cross-platform mobile development.

### Core Concepts

#### 2.1 The Bridge (Legacy Architecture)

In the original architecture, React Native operated through a **bridge** — a serialization layer that passed messages between the JavaScript thread and the native thread using JSON. While functional, this bridge was asynchronous and introduced latency for rapid, high-frequency operations.

```
┌─────────────────────────────────────────┐
│           JavaScript Thread             │
│  ┌─────────────────────────────────┐    │
│  │  React Component Tree           │    │
│  │  Business Logic                 │    │
│  │  State Management               │    │
│  └──────────────┬──────────────────┘    │
└─────────────────┼───────────────────────┘
                  │  JSON Serialization
                  │  (Async Bridge)
┌─────────────────┼───────────────────────┐
│  Native Thread  │                        │
│  ┌──────────────▼──────────────────┐    │
│  │  Native UI Components           │    │
│  │  UIKit (iOS) / Android Views    │    │
│  │  Platform APIs                  │    │
│  └─────────────────────────────────┘    │
└─────────────────────────────────────────┘
```

#### 2.2 The New Architecture (JSI + Fabric + TurboModules)

Starting with React Native 0.68 and becoming default in 0.73+, the **New Architecture** fundamentally changes how React Native works:

**JSI (JavaScript Interface):**  
JSI replaces the bridge with a C++ layer that allows JavaScript to hold references to native objects directly. No more serialization. No more asynchronous queues for simple calls.

```
┌──────────────────────────────────────────┐
│  JavaScript Engine (Hermes)               │
│  ┌────────────────────────────────────┐  │
│  │  React Component Tree              │  │
│  │  + Direct Native Object Refs (JSI) │  │
│  └──────────────────┬─────────────────┘  │
└─────────────────────┼────────────────────┘
                      │  C++ JSI (Synchronous)
┌─────────────────────┼────────────────────┐
│  ┌──────────────────▼─────────────────┐  │
│  │  Fabric Renderer                   │  │
│  │  TurboModules                      │  │
│  │  Native UI / APIs                  │  │
│  └────────────────────────────────────┘  │
└──────────────────────────────────────────┘
```

**Fabric:**  
Fabric is the new rendering system. It is synchronous, supports concurrent rendering (React 18 features like `useTransition` and `Suspense`), and can render on multiple threads.

**TurboModules:**  
TurboModules replace Native Modules. They are lazily loaded (only initialized when first called), reducing startup time, and they use JSI for synchronous communication.

**Codegen:**  
Static type checking tool that generates C++ glue code from TypeScript/Flow definitions, ensuring type safety at the native boundary.

#### 2.3 Hermes JavaScript Engine

Hermes is a JavaScript engine optimized for React Native, developed by Meta. Key advantages:

- **Ahead-of-time (AOT) compilation:** Hermes compiles JS to bytecode at build time, not at runtime
- **Faster startup:** No need to parse and compile JS on the device
- **Lower memory usage:** Optimized garbage collector
- **Better debugging:** Supports Chrome DevTools Protocol

```javascript
// Check if running on Hermes
const isHermes = () => !!global.HermesInternal;
console.log('Running on Hermes:', isHermes());
```

#### 2.4 Metro Bundler

Metro is React Native's JavaScript bundler. It:
- Resolves module dependencies
- Transforms JavaScript (Babel)
- Serves files during development via hot reloading
- Creates optimized bundles for production

```javascript
// metro.config.js - Custom configuration
const { getDefaultConfig } = require('expo/metro-config');

const config = getDefaultConfig(__dirname);

// Add custom file extensions
config.resolver.assetExts.push('lottie');
config.resolver.sourceExts.push('mjs');

// Add aliases
config.resolver.alias = {
  '@components': './src/components',
  '@screens': './src/screens',
  '@utils': './src/utils',
  '@hooks': './src/hooks',
  '@store': './src/store',
};

module.exports = config;
```

---

## 3. What Is Expo?

Expo is a platform and set of tools built on top of React Native that dramatically simplifies development, testing, and deployment of React Native applications.

### 3.1 Expo Ecosystem Components

**Expo SDK:**  
A collection of high-quality, well-maintained native modules covering camera, location, sensors, media, notifications, and much more. All modules work cross-platform and are tested with each Expo release.

**Expo Go:**  
A development client app available on the App Store and Google Play. During development, you scan a QR code and your app runs inside Expo Go without needing Xcode or Android Studio.

**EAS (Expo Application Services):**  
Cloud infrastructure for building, submitting, and updating your app:
- **EAS Build:** Cloud-based iOS and Android builds
- **EAS Submit:** Automated App Store and Google Play submission
- **EAS Update:** Over-the-air (OTA) JavaScript updates

**Expo Router:**  
File-based routing system (like Next.js) for React Native, supporting both native and web targets.

**Snack:**  
Browser-based playground for trying Expo apps without any local setup.

### 3.2 Expo Workflow Options

#### Managed Workflow
Expo manages all native code. You never touch `android/` or `ios/` directories. This is ideal for most apps.

```bash
# Start a managed workflow project
npx create-expo-app MyApp
cd MyApp
npx expo start
```

#### Bare Workflow  
You eject from the managed workflow and have full access to native code while still using Expo SDK modules.

```bash
# Create a bare workflow project
npx create-expo-app MyApp --template bare-minimum
```

#### Prebuild (Recommended Modern Approach)
Using `expo prebuild`, Expo generates the native `android/` and `ios/` directories from your `app.json` configuration. You can regenerate them at any time, keeping the configuration as the source of truth.

```bash
# Generate native directories
npx expo prebuild

# Regenerate (will overwrite customizations outside plugins)
npx expo prebuild --clean
```

### 3.3 app.json / app.config.js

The central configuration file for an Expo project:

```javascript
// app.config.js - Dynamic configuration (preferred over app.json)
export default ({ config }) => ({
  ...config,
  name: 'MyApp',
  slug: 'my-app',
  version: '1.0.0',
  orientation: 'portrait',
  icon: './assets/icon.png',
  userInterfaceStyle: 'automatic', // supports dark mode
  splash: {
    image: './assets/splash.png',
    resizeMode: 'contain',
    backgroundColor: '#ffffff',
  },
  updates: {
    fallbackToCacheTimeout: 0,
    url: 'https://u.expo.dev/your-project-id',
  },
  assetBundlePatterns: ['**/*'],
  ios: {
    supportsTablet: true,
    bundleIdentifier: 'com.yourcompany.myapp',
    buildNumber: '1',
    infoPlist: {
      NSCameraUsageDescription: 'This app uses the camera to scan QR codes.',
      NSLocationWhenInUseUsageDescription: 'This app uses your location to find nearby stores.',
    },
    associatedDomains: ['applinks:yourapp.com'],
    entitlements: {
      'com.apple.developer.nfc.readersession.formats': ['NDEF'],
    },
  },
  android: {
    package: 'com.yourcompany.myapp',
    versionCode: 1,
    adaptiveIcon: {
      foregroundImage: './assets/adaptive-icon.png',
      backgroundColor: '#FFFFFF',
    },
    permissions: [
      'CAMERA',
      'ACCESS_FINE_LOCATION',
      'VIBRATE',
    ],
    intentFilters: [
      {
        action: 'VIEW',
        autoVerify: true,
        data: [{ scheme: 'https', host: 'yourapp.com', pathPrefix: '/app' }],
        category: ['BROWSABLE', 'DEFAULT'],
      },
    ],
  },
  web: {
    favicon: './assets/favicon.png',
    bundler: 'metro',
  },
  plugins: [
    'expo-router',
    'expo-camera',
    [
      'expo-location',
      {
        locationAlwaysAndWhenInUsePermission: 'Allow $(PRODUCT_NAME) to use your location.',
      },
    ],
    [
      '@sentry/react-native/expo',
      {
        organization: 'your-org',
        project: 'your-project',
      },
    ],
  ],
  extra: {
    eas: {
      projectId: 'your-eas-project-id',
    },
    apiUrl: process.env.API_URL ?? 'https://api.yourapp.com',
  },
});
```

---

## 4. Architecture Deep Dive

### 4.1 Threading Model

React Native applications run on three main threads:

**1. JavaScript Thread**  
Runs the React component tree, business logic, and most of your code. Uses the Hermes engine. All `useEffect`, state updates, and component renders happen here.

**2. Native/Main Thread (UI Thread)**  
Handles native UI rendering, touch events, and animation frames. This must never be blocked. React Native's Fabric renderer and Animated API work here.

**3. Background Thread(s)**  
Native modules can do heavy work (file I/O, network in some cases, image processing) on background threads, then report results to the JS thread.

```
┌────────────────────────────────────────────────────┐
│                 React Native App                    │
│                                                    │
│  JavaScript Thread    Main/UI Thread   BG Threads  │
│  ┌──────────────┐    ┌─────────────┐  ┌─────────┐ │
│  │ React Tree   │    │ UIKit/Views │  │ Camera  │ │
│  │ State/Logic  │◄──►│ Animations  │  │ Network │ │
│  │ Data Fetching│    │ Gestures    │  │ Storage │ │
│  └──────────────┘    └─────────────┘  └─────────┘ │
└────────────────────────────────────────────────────┘
```

### 4.2 React Native New Architecture in Practice

Enabling the new architecture (for bare workflow):

```kotlin
// android/gradle.properties
newArchEnabled=true
```

```ruby
# ios/Podfile
ENV['RCT_NEW_ARCH_ENABLED'] = '1'
```

For Expo (managed workflow, SDK 50+, it is enabled by default):

```json
// app.json
{
  "expo": {
    "newArchEnabled": true
  }
}
```

### 4.3 Concurrent Features with New Architecture

With the new architecture, React Native supports React 18 concurrent features:

```javascript
import React, { useState, useTransition, Suspense } from 'react';
import { View, TextInput, ActivityIndicator } from 'react-native';

// useTransition — mark expensive state updates as non-urgent
function SearchScreen() {
  const [query, setQuery] = useState('');
  const [searchResults, setSearchResults] = useState([]);
  const [isPending, startTransition] = useTransition();

  const handleSearch = (text) => {
    setQuery(text); // Urgent — update input immediately
    startTransition(() => {
      // Non-urgent — can be interrupted by higher-priority updates
      const results = performExpensiveSearch(text);
      setSearchResults(results);
    });
  };

  return (
    <View>
      <TextInput value={query} onChangeText={handleSearch} />
      {isPending && <ActivityIndicator />}
      <Suspense fallback={<ActivityIndicator />}>
        <ResultsList results={searchResults} />
      </Suspense>
    </View>
  );
}
```

### 4.4 Component Lifecycle in React Native

```javascript
import React, { useState, useEffect, useRef, useCallback } from 'react';
import { AppState, AppStateStatus } from 'react-native';

function ComponentLifecycleExample() {
  const [count, setCount] = useState(0);
  const appState = useRef(AppState.currentState);

  // ComponentDidMount equivalent
  useEffect(() => {
    console.log('Component mounted');
    
    // Cleanup = ComponentWillUnmount
    return () => {
      console.log('Component unmounted');
    };
  }, []);

  // AppState — track foreground/background
  useEffect(() => {
    const subscription = AppState.addEventListener('change', (nextAppState: AppStateStatus) => {
      if (appState.current.match(/inactive|background/) && nextAppState === 'active') {
        console.log('App has come to the foreground!');
        // Refresh data, resume timers, etc.
      }
      if (nextAppState.match(/inactive|background/)) {
        console.log('App went to background');
        // Pause timers, save state, etc.
      }
      appState.current = nextAppState;
    });
    
    return () => subscription.remove();
  }, []);

  // Stable callback reference
  const handlePress = useCallback(() => {
    setCount(prev => prev + 1);
  }, []);

  return null; // Render UI
}
```

---

## 5. When to Use React Native

### 5.1 Ideal Use Cases

#### ✅ Consumer Apps with Large Teams

React Native allows web developers to contribute to mobile development without learning Swift/Kotlin. If your team has strong JavaScript/TypeScript skills, React Native dramatically expands your mobile development capacity.

**Example:** E-commerce apps, social media feeds, content consumption apps.

#### ✅ Apps Requiring Shared Logic Between Web and Mobile

If you have a web app built with React, you can share:
- Business logic (utilities, formatters, validators)
- API service layers (Axios, React Query configs)
- Custom hooks (authentication, permissions)
- Type definitions (TypeScript interfaces)
- Store logic (Redux reducers, Zustand stores)

```
/shared
  /hooks
    useAuth.ts          ← Works in React Native AND React Web
    usePermissions.ts
  /services
    api.ts              ← Same API calls, same error handling
    authService.ts
  /utils
    formatCurrency.ts   ← Identical formatting logic
    validation.ts
  /types
    User.ts             ← Shared TypeScript interfaces
    
/mobile (React Native)
  /screens
  /components
  
/web (React / Next.js)
  /pages
  /components
```

#### ✅ Rapid Prototyping and MVP Development

Getting an MVP to App Store and Google Play simultaneously in weeks instead of months. Expo's managed workflow makes this even faster.

**Timeline comparison:**

| Approach | Team Size | MVP Timeline |
|---|---|---|
| Native iOS + Android | 4+ devs | 6-12 months |
| React Native | 2 devs | 2-4 months |
| React Native + Expo | 1-2 devs | 1-2 months |

#### ✅ B2B / Enterprise Internal Tools

Enterprise apps used by employees typically do not need cutting-edge animations or deeply custom platform UI. React Native covers 95% of enterprise use cases while being far faster to develop than native.

**Examples:** Inventory management, field service apps, internal CRMs, employee dashboards.

#### ✅ Apps With Heavy Form-Based UI

CRUD applications, dashboards, settings screens — anywhere the UI is primarily text input, lists, and navigation — React Native excels because these components map cleanly to native equivalents.

#### ✅ Apps Needing OTA Updates

With Expo EAS Update or CodePush, you can push JavaScript/asset updates without going through App Store review. This is hugely valuable for fixing bugs quickly.

```javascript
// Using expo-updates for OTA updates
import * as Updates from 'expo-updates';

async function checkForUpdates() {
  if (!__DEV__) {
    try {
      const update = await Updates.checkForUpdateAsync();
      if (update.isAvailable) {
        await Updates.fetchUpdateAsync();
        await Updates.reloadAsync(); // Reload with new JS bundle
      }
    } catch (e) {
      console.error('Error checking for updates:', e);
    }
  }
}
```

#### ✅ Cross-Platform Consistency Requirements

When your product team requires pixel-perfect consistency between iOS and Android, React Native's single codebase ensures that a design change is applied everywhere simultaneously.

### 5.2 Industry-Specific Use Cases

#### Healthcare Apps (Non-Medical Device)
- Patient portals
- Appointment scheduling
- Medication reminders
- Telehealth video consultations (using WebRTC libraries)
- Mental health journaling

#### Fintech
- Banking dashboards
- Expense tracking
- Cryptocurrency portfolio viewers
- Payment flows (Stripe, Braintree SDKs available)
- Budget calculators

#### E-commerce
- Product catalogs
- Shopping carts
- Order tracking
- In-app purchases
- Augmented Reality try-on (using Expo's ARKit/ARCore support)

#### Social & Community
- Chat applications
- News feeds
- Event management
- User profiles

#### Logistics & Field Service
- Delivery tracking
- Route optimization
- Barcode/QR scanning
- Signature capture
- Photo documentation

---

## 6. When NOT to Use React Native

### 6.1 Hard Limits

#### ❌ Computationally Intensive Applications

Anything requiring heavy CPU work in a tight loop should be native:

- **3D Games:** Use Unity, Unreal Engine, or native Metal/Vulkan
- **Video/Audio Processing:** ffmpeg integrations exist but are complex; native is better
- **Machine Learning Inference:** Core ML (iOS) or ML Kit (Android) are far superior
- **Real-time Signal Processing:** Audio synthesis, DSP algorithms

```
// This kind of work should NOT be in React Native JS thread:
// - Real-time audio processing at 44.1kHz
// - Physics simulation with thousands of objects
// - Video encoding/decoding
// - Cryptographic operations on large datasets
```

#### ❌ Apps with Highly Custom Platform UI

If your app's core value proposition is deeply custom, platform-specific UI (e.g., a custom keyboard, a launcher app, a home screen widget app), React Native adds unnecessary complexity.

- **Custom Keyboards:** Must be native extensions
- **Home Screen Widgets:** Require native iOS Widget extensions or Android App Widgets
- **Live Activities (iOS 16+):** Require native Swift code
- **Dynamic Island integrations:** Native only

#### ❌ Apps Requiring Bluetooth Low Energy (BLE) at Scale

While BLE libraries exist (`react-native-ble-plx`), complex BLE peripherals (medical devices, industrial sensors) with custom GATT profiles and real-time data streaming are better handled natively due to lower latency requirements.

#### ❌ Background Processing Heavy Apps

iOS severely limits background execution. If your app needs to:
- Run continuously in the background
- Process data on a strict schedule
- Access sensors while backgrounded

React Native makes this harder, not easier. Consider native or a hybrid approach.

#### ❌ Apps Where Animation Is the Core Product

If your app is an animation tool, motion design showcase, or interaction-heavy product like a drawing app or a gesture-driven creative tool, React Native's animation layer (even with Reanimated 3) has limits compared to Core Animation or Android's Jetpack Compose animations.

### 6.2 Situational Warnings

#### ⚠️ Very Small Apps with Simple Needs

If you're building a single-purpose app (a flashlight, a simple calculator), the overhead of React Native (bundle size, runtime overhead) may not be worth it. Swift/Kotlin apps for these use cases are smaller and faster.

#### ⚠️ Team Has Zero JavaScript Experience

React Native does not eliminate the need to understand JavaScript, asynchronous programming, React patterns, and package management. A team of native developers with no JS experience will struggle more than a native-only team would.

#### ⚠️ Third-Party SDK Requires Deep Native Integration

Some SDKs are designed for native apps and require deep lifecycle integration. Examples include certain DRM solutions, specific payment SDKs for regional markets, and some enterprise MDM (Mobile Device Management) agents.

---

## 7. When to Use Expo

### 7.1 Strong Cases for Expo

#### ✅ New Projects Without Existing Native Code

Starting fresh? Use Expo. The setup time is minutes vs. hours for a bare React Native project. You get:
- Working camera, notifications, location, sensors out of the box
- No Xcode configuration for basic features
- Consistent SDK versions tested together
- Automatic managed dependency updates

```bash
# You're productive in under 5 minutes
npx create-expo-app MyApp --template tabs
cd MyApp
npx expo start
# Scan QR code → See your app
```

#### ✅ Solo Developers and Small Teams

When you don't have dedicated iOS and Android developers to manage native build configurations, Expo's managed workflow offloads that complexity to Expo's team. EAS Build handles CI/CD without requiring Mac infrastructure.

#### ✅ Rapid Prototyping

Expo Snack lets you share a live, runnable React Native app via a URL. No installation required for the reviewer.

```
https://snack.expo.dev/@username/my-prototype
```

#### ✅ Projects That Need OTA Updates

Expo's `expo-updates` module and EAS Update service provide the best OTA update experience available for React Native. Critical bug fixes can be deployed in minutes.

#### ✅ Apps That Don't Need Unpublished Native Modules

If your app's feature requirements are covered by Expo SDK (camera, location, sensors, notifications, auth, payments via in-app purchases, maps, etc.), the managed workflow gives you all of this without writing a line of native code.

### 7.2 Expo Use Case Matrix

| Use Case | Expo Managed | Expo Bare | Notes |
|---|---|---|---|
| Simple consumer app | ✅ | ✅ | Managed preferred |
| App with Stripe payments | ✅ | ✅ | Use `@stripe/stripe-react-native` |
| App with custom BLE | ❌ | ✅ | Need bare for `react-native-ble-plx` |
| App with custom native module | ❌ | ✅ | Need bare for custom native |
| App needing App Clips (iOS) | ❌ | ✅ | Complex native setup |
| App with camera features | ✅ | ✅ | `expo-camera` covers most cases |
| App with AR (ARKit/ARCore) | ⚠️ | ✅ | Limited managed support |
| App with video streaming | ✅ | ✅ | `expo-av` or `react-native-video` |
| App Store deployment | ✅ EAS | ✅ EAS | EAS handles both |

---

## 8. When NOT to Use Expo

### 8.1 Clear Disqualifiers

#### ❌ Custom Native Modules Required (Managed Workflow Only)

If you need a third-party SDK that has not built an Expo config plugin, the managed workflow cannot include it. You must either:
1. Switch to bare workflow
2. Build a config plugin yourself
3. Find an alternative Expo-compatible library

```bash
# Checking if a library has an Expo plugin
npx expo install some-library
# If it warns about "not yet supported" → bare workflow needed
```

#### ❌ Extremely Strict App Size Requirements

Expo managed apps are larger due to the included SDK modules. A bare React Native app with only what you need will be smaller.

- Expo managed: ~20-30MB minimum (iOS)
- Bare React Native: ~5-10MB minimum (iOS)

#### ❌ Complex CI/CD with On-Premise Infrastructure

EAS Build is cloud-based. If your company requires all builds to happen on internal servers (due to security policies, data residency requirements, or compliance), EAS is not an option. You would need to use bare workflow with your own CI (Fastlane, Bitrise on-prem, etc.).

#### ❌ Deep Apple/Google Service Integration

Certain integrations require very specific entitlements, background modes, or capabilities that Expo's config system doesn't cover cleanly. Examples:

- CarPlay / Android Auto integration
- HealthKit (read/write) — partial support
- SiriKit intent extensions
- Share extensions
- Notification Service Extensions (for end-to-end encrypted push)

#### ❌ Expo Go Limitations for Development

During development with Expo Go, you can only test code that Expo Go supports. If you rely on a library that requires custom native code, Expo Go won't work — you'd need a **development build**.

```bash
# Creating a development build (replaces Expo Go for complex projects)
npx expo install expo-dev-client
eas build --profile development --platform ios
```

---

## 9. Core Components & APIs

### 9.1 Fundamental Components

#### View
The most fundamental building block — equivalent to `div` in web development.

```javascript
import { View, StyleSheet } from 'react-native';

// ✅ Good — specific, purposeful layout
function Card({ children }) {
  return (
    <View style={styles.card}>
      <View style={styles.cardHeader}>
        {/* header content */}
      </View>
      <View style={styles.cardBody}>
        {children}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: '#fff',
    borderRadius: 12,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3, // Android
    margin: 16,
  },
  cardHeader: {
    padding: 16,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: '#e0e0e0',
  },
  cardBody: {
    padding: 16,
  },
});
```

#### Text
All text must be wrapped in `<Text>`. You cannot render bare strings in React Native.

```javascript
import { Text, StyleSheet, Platform } from 'react-native';

// ✅ Comprehensive Text usage with platform variants
function Typography() {
  return (
    <>
      {/* Nested Text for mixed styling */}
      <Text style={styles.body}>
        This is <Text style={styles.bold}>bold</Text> and{' '}
        <Text style={styles.italic}>italic</Text> in one line.
      </Text>
      
      {/* numberOfLines for truncation */}
      <Text style={styles.title} numberOfLines={2} ellipsizeMode="tail">
        This is a very long title that will be truncated after two lines of content
      </Text>
      
      {/* selectable text */}
      <Text selectable style={styles.code}>
        npm install expo
      </Text>
    </>
  );
}

const styles = StyleSheet.create({
  title: {
    fontSize: 24,
    fontWeight: '700',
    // Platform-specific fonts
    fontFamily: Platform.select({
      ios: 'SF Pro Display',
      android: 'Roboto',
      default: 'System',
    }),
    color: '#1a1a1a',
    lineHeight: 32,
  },
  body: {
    fontSize: 16,
    color: '#333',
    lineHeight: 24,
  },
  bold: {
    fontWeight: '700',
  },
  italic: {
    fontStyle: 'italic',
  },
  code: {
    fontFamily: Platform.select({
      ios: 'Menlo',
      android: 'monospace',
    }),
    backgroundColor: '#f5f5f5',
    paddingHorizontal: 4,
    borderRadius: 4,
    fontSize: 14,
  },
});
```

#### Image
React Native's Image component for static and network images.

```javascript
import { Image, StyleSheet, View } from 'react-native';
import { useState } from 'react';

// ✅ Production-ready image component with loading and error states
function NetworkImage({ uri, style }) {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  if (error) {
    return <View style={[styles.placeholder, style]} />;
  }

  return (
    <View style={[style, styles.container]}>
      <Image
        source={{ uri, cache: 'force-cache' }} // Cache aggressively
        style={[StyleSheet.absoluteFill, loading && styles.hidden]}
        onLoad={() => setLoading(false)}
        onError={() => setError(true)}
        resizeMode="cover"
        // Performance: hint for fast image decoding
        fadeDuration={300}
      />
      {loading && <View style={[StyleSheet.absoluteFill, styles.shimmer]} />}
    </View>
  );
}

// For better performance, use expo-image instead:
import { Image as ExpoImage } from 'expo-image';

function OptimizedImage({ uri, style }) {
  return (
    <ExpoImage
      source={uri}
      style={style}
      contentFit="cover"
      transition={300}
      cachePolicy="memory-disk" // Memory AND disk caching
      placeholder={require('./assets/blur-hash-placeholder.png')}
    />
  );
}
```

#### ScrollView vs FlatList vs SectionList

```javascript
import { ScrollView, FlatList, SectionList } from 'react-native';

// ScrollView — for content that fits in a few screens
// ❌ NEVER use ScrollView for long lists — all items render at once
function Settings() {
  return (
    <ScrollView contentContainerStyle={styles.container}>
      {/* Settings sections — limited items, complex layout */}
      <SettingSection title="Account" items={accountSettings} />
      <SettingSection title="Notifications" items={notificationSettings} />
      <SettingSection title="Privacy" items={privacySettings} />
    </ScrollView>
  );
}

// FlatList — for long lists with uniform items
// ✅ Virtualized — only renders visible items
function ProductList({ products }) {
  const renderItem = useCallback(({ item }) => (
    <ProductCard product={item} />
  ), []);

  const keyExtractor = useCallback((item) => item.id.toString(), []);

  const getItemLayout = useCallback((data, index) => ({
    length: ITEM_HEIGHT,
    offset: ITEM_HEIGHT * index,
    index,
  }), []);

  return (
    <FlatList
      data={products}
      renderItem={renderItem}
      keyExtractor={keyExtractor}
      getItemLayout={getItemLayout} // Enables instant scroll-to-index
      initialNumToRender={10}
      maxToRenderPerBatch={10}
      windowSize={10} // Render 10 screens worth of items
      removeClippedSubviews={true} // Android optimization
      onEndReached={loadMoreProducts}
      onEndReachedThreshold={0.5} // Load more when 50% from bottom
      ListEmptyComponent={<EmptyState />}
      ListHeaderComponent={<ListHeader />}
      ListFooterComponent={isLoading ? <ActivityIndicator /> : null}
    />
  );
}

// SectionList — for lists with section headers
function ContactList({ contacts }) {
  const sections = useMemo(() => 
    groupContactsByLetter(contacts), [contacts]);

  return (
    <SectionList
      sections={sections}
      keyExtractor={(item) => item.id}
      renderItem={({ item }) => <ContactRow contact={item} />}
      renderSectionHeader={({ section: { title } }) => (
        <Text style={styles.sectionHeader}>{title}</Text>
      )}
      stickySectionHeadersEnabled={true}
    />
  );
}
```

#### TextInput

```javascript
import { TextInput, View, Text, StyleSheet } from 'react-native';
import { useState, useRef, forwardRef } from 'react';

// ✅ Full-featured form input component
const FormInput = forwardRef(({
  label,
  error,
  secureTextEntry,
  onSubmitEditing,
  returnKeyType = 'next',
  ...props
}, ref) => {
  const [isFocused, setIsFocused] = useState(false);
  const [isSecure, setIsSecure] = useState(secureTextEntry);

  return (
    <View style={styles.inputWrapper}>
      <Text style={styles.label}>{label}</Text>
      <View style={[
        styles.inputContainer,
        isFocused && styles.inputFocused,
        error && styles.inputError,
      ]}>
        <TextInput
          ref={ref}
          style={styles.input}
          placeholderTextColor="#999"
          secureTextEntry={isSecure}
          returnKeyType={returnKeyType}
          onSubmitEditing={onSubmitEditing}
          onFocus={() => setIsFocused(true)}
          onBlur={() => setIsFocused(false)}
          autoCapitalize="none"
          autoCorrect={false}
          {...props}
        />
        {secureTextEntry && (
          <TouchableOpacity onPress={() => setIsSecure(!isSecure)}>
            <Text>{isSecure ? '👁' : '🙈'}</Text>
          </TouchableOpacity>
        )}
      </View>
      {error && <Text style={styles.errorText}>{error}</Text>}
    </View>
  );
});

// Usage in a login form with focus chain
function LoginForm() {
  const emailRef = useRef(null);
  const passwordRef = useRef(null);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  return (
    <View>
      <FormInput
        ref={emailRef}
        label="Email"
        value={email}
        onChangeText={setEmail}
        keyboardType="email-address"
        returnKeyType="next"
        onSubmitEditing={() => passwordRef.current?.focus()}
      />
      <FormInput
        ref={passwordRef}
        label="Password"
        value={password}
        onChangeText={setPassword}
        secureTextEntry
        returnKeyType="done"
        onSubmitEditing={handleLogin}
      />
    </View>
  );
}
```

#### Pressable vs TouchableOpacity vs TouchableHighlight

```javascript
// Modern approach: Pressable (React Native 0.64+)
import { Pressable, Text, StyleSheet } from 'react-native';

function Button({ onPress, label, variant = 'primary', disabled = false }) {
  return (
    <Pressable
      onPress={onPress}
      disabled={disabled}
      style={({ pressed }) => [
        styles.button,
        styles[variant],
        pressed && styles.pressed,
        disabled && styles.disabled,
      ]}
      // Accessibility
      accessibilityRole="button"
      accessibilityLabel={label}
      accessibilityState={{ disabled }}
      // Hit slop — expand touch area without expanding visual size
      hitSlop={{ top: 8, bottom: 8, left: 8, right: 8 }}
    >
      {({ pressed }) => (
        <Text style={[styles.label, pressed && styles.labelPressed]}>
          {label}
        </Text>
      )}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  button: {
    paddingVertical: 12,
    paddingHorizontal: 24,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: 48, // Accessibility: minimum touch target size
  },
  primary: {
    backgroundColor: '#007AFF',
  },
  secondary: {
    backgroundColor: 'transparent',
    borderWidth: 1,
    borderColor: '#007AFF',
  },
  pressed: {
    opacity: 0.8,
    transform: [{ scale: 0.98 }],
  },
  disabled: {
    opacity: 0.4,
  },
  label: {
    color: '#fff',
    fontWeight: '600',
    fontSize: 16,
  },
  labelPressed: {
    color: '#e0e0e0',
  },
});
```

### 9.2 Platform-Specific Code

```javascript
import { Platform, StyleSheet } from 'react-native';

// Method 1: Platform.select
const styles = StyleSheet.create({
  header: {
    paddingTop: Platform.select({
      ios: 50,
      android: 25,
      default: 20,
    }),
    backgroundColor: Platform.select({
      ios: '#F2F2F7',
      android: '#FFFFFF',
    }),
  },
});

// Method 2: Platform.OS checks
function PlatformSpecificBehavior() {
  const handlePress = () => {
    if (Platform.OS === 'ios') {
      // Use iOS-specific API
      ActionSheetIOS.showActionSheetWithOptions(
        { options: ['Cancel', 'Delete'], destructiveButtonIndex: 1 },
        (index) => { if (index === 1) deleteItem(); }
      );
    } else {
      // Android: use Alert
      Alert.alert('Confirm', 'Delete this item?', [
        { text: 'Cancel', style: 'cancel' },
        { text: 'Delete', style: 'destructive', onPress: deleteItem },
      ]);
    }
  };
}

// Method 3: Platform-specific files
// Button.ios.tsx  → used on iOS
// Button.android.tsx → used on Android
// Button.tsx → fallback
```

### 9.3 Modal and Alert

```javascript
import { Modal, Alert, ActionSheetIOS, View, Text, Pressable } from 'react-native';
import { useState } from 'react';

// Custom Modal (cross-platform)
function ConfirmationModal({ visible, onConfirm, onCancel, title, message }) {
  return (
    <Modal
      visible={visible}
      transparent
      animationType="fade"
      statusBarTranslucent
      onRequestClose={onCancel} // Android back button
    >
      <Pressable style={styles.overlay} onPress={onCancel}>
        <Pressable style={styles.modalContent} onPress={e => e.stopPropagation()}>
          <Text style={styles.modalTitle}>{title}</Text>
          <Text style={styles.modalMessage}>{message}</Text>
          <View style={styles.modalActions}>
            <Pressable onPress={onCancel} style={styles.cancelButton}>
              <Text>Cancel</Text>
            </Pressable>
            <Pressable onPress={onConfirm} style={styles.confirmButton}>
              <Text style={styles.confirmText}>Confirm</Text>
            </Pressable>
          </View>
        </Pressable>
      </Pressable>
    </Modal>
  );
}

// Alert API (simpler, uses native dialogs)
function showDeleteAlert(onDelete) {
  Alert.alert(
    'Delete Item',
    'Are you sure you want to delete this item? This cannot be undone.',
    [
      {
        text: 'Cancel',
        style: 'cancel',
        onPress: () => console.log('Cancel pressed'),
      },
      {
        text: 'Delete',
        style: 'destructive',
        onPress: onDelete,
      },
    ],
    { cancelable: true }
  );
}

// Prompt (iOS only)
Alert.prompt(
  'Enter your name',
  'This will be shown on your profile',
  (name) => updateProfile(name),
  'plain-text',
  '',
  'default'
);
```

---

## 10. Navigation

### 10.1 React Navigation (Stack Navigator)

React Navigation is the de-facto standard for navigation in React Native.

```bash
npm install @react-navigation/native
npm install @react-navigation/native-stack
npx expo install react-native-screens react-native-safe-area-context
```

```javascript
// App.tsx — Root navigation setup
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';

// Type-safe navigation with TypeScript
type RootStackParamList = {
  Auth: undefined;
  Main: undefined;
  ProductDetail: { productId: string; product?: Product };
  Checkout: { items: CartItem[] };
};

type MainTabParamList = {
  Home: undefined;
  Search: { query?: string };
  Cart: undefined;
  Profile: undefined;
};

const Stack = createNativeStackNavigator<RootStackParamList>();
const Tab = createBottomTabNavigator<MainTabParamList>();

function MainTabs() {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        tabBarIcon: ({ focused, color, size }) => {
          const iconName = getTabIcon(route.name, focused);
          return <TabIcon name={iconName} size={size} color={color} />;
        },
        tabBarActiveTintColor: '#007AFF',
        tabBarInactiveTintColor: '#8E8E93',
        headerShown: false,
      })}
    >
      <Tab.Screen name="Home" component={HomeScreen} />
      <Tab.Screen name="Search" component={SearchScreen} />
      <Tab.Screen 
        name="Cart" 
        component={CartScreen}
        options={{ 
          tabBarBadge: cartItemCount > 0 ? cartItemCount : undefined 
        }} 
      />
      <Tab.Screen name="Profile" component={ProfileScreen} />
    </Tab.Navigator>
  );
}

function RootNavigator() {
  const { isAuthenticated } = useAuth();

  return (
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      {isAuthenticated ? (
        <>
          <Stack.Screen name="Main" component={MainTabs} />
          <Stack.Screen
            name="ProductDetail"
            component={ProductDetailScreen}
            options={{
              headerShown: true,
              headerTitle: '',
              headerTransparent: true,
              presentation: 'card',
            }}
          />
          <Stack.Screen
            name="Checkout"
            component={CheckoutScreen}
            options={{
              presentation: 'modal',
              headerShown: true,
              headerTitle: 'Checkout',
            }}
          />
        </>
      ) : (
        <Stack.Screen name="Auth" component={AuthScreen} />
      )}
    </Stack.Navigator>
  );
}

export default function App() {
  return (
    <NavigationContainer
      linking={linkingConfig} // Deep link configuration
      fallback={<SplashScreen />}
    >
      <RootNavigator />
    </NavigationContainer>
  );
}
```

### 10.2 Using Navigation Hooks

```javascript
import { 
  useNavigation, 
  useRoute, 
  useFocusEffect,
  useIsFocused 
} from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { useCallback } from 'react';

type NavigationProp = NativeStackNavigationProp<RootStackParamList>;

function ProductDetailScreen() {
  const navigation = useNavigation<NavigationProp>();
  const route = useRoute<RouteProp<RootStackParamList, 'ProductDetail'>>();
  const { productId } = route.params;
  
  // Run effect when screen comes into focus
  useFocusEffect(
    useCallback(() => {
      // Track screen view
      analytics.trackScreen('ProductDetail', { productId });
      
      return () => {
        // Cleanup when screen loses focus
        cancelPendingRequests();
      };
    }, [productId])
  );

  const handleAddToCart = () => {
    navigation.navigate('Cart');
    // Or navigate with params:
    navigation.navigate('Checkout', { items: cartItems });
    // Or go back:
    navigation.goBack();
    // Or replace current screen:
    navigation.replace('Home');
    // Or push new screen (even same route):
    navigation.push('ProductDetail', { productId: '456' });
    // Or reset navigation stack:
    navigation.reset({ index: 0, routes: [{ name: 'Main' }] });
  };
}
```

### 10.3 Expo Router (File-Based Navigation)

Expo Router brings Next.js-style file-based routing to React Native:

```
app/
  _layout.tsx         ← Root layout (NavigationContainer)
  index.tsx           ← / (home screen)
  (tabs)/
    _layout.tsx       ← Tab navigator layout
    index.tsx         ← /  (home tab)
    explore.tsx       ← /explore
    profile.tsx       ← /profile
  product/
    [id].tsx          ← /product/:id (dynamic route)
  (auth)/
    _layout.tsx       ← Auth group layout
    login.tsx         ← /login
    register.tsx      ← /register
  +not-found.tsx      ← 404 screen
```

```javascript
// app/(tabs)/_layout.tsx
import { Tabs } from 'expo-router';
import { TabBarIcon } from '@/components/TabBarIcon';

export default function TabLayout() {
  return (
    <Tabs
      screenOptions={{
        tabBarActiveTintColor: '#007AFF',
        headerShown: false,
      }}
    >
      <Tabs.Screen
        name="index"
        options={{
          title: 'Home',
          tabBarIcon: ({ color }) => <TabBarIcon name="home" color={color} />,
        }}
      />
      <Tabs.Screen
        name="explore"
        options={{
          title: 'Explore',
          tabBarIcon: ({ color }) => <TabBarIcon name="compass" color={color} />,
        }}
      />
    </Tabs>
  );
}

// app/product/[id].tsx
import { useLocalSearchParams, Link, useRouter } from 'expo-router';

export default function ProductScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();

  return (
    <View>
      <Text>Product ID: {id}</Text>
      {/* Type-safe navigation */}
      <Link href="/profile">Go to Profile</Link>
      <Link href={`/product/${nextProductId}`}>Next Product</Link>
      <Link href={{ pathname: '/checkout', params: { productId: id } }}>
        Buy Now
      </Link>
      
      <Button onPress={() => router.back()} title="Go Back" />
      <Button onPress={() => router.push('/cart')} title="View Cart" />
      <Button onPress={() => router.replace('/home')} title="Home" />
    </View>
  );
}
```

---

## 11. State Management

### 11.1 Local State with useState and useReducer

```javascript
// Simple local state
const [count, setCount] = useState(0);
const [user, setUser] = useState<User | null>(null);
const [items, setItems] = useState<Item[]>([]);

// Complex state with useReducer
type CartState = {
  items: CartItem[];
  total: number;
  discountCode: string | null;
};

type CartAction =
  | { type: 'ADD_ITEM'; item: CartItem }
  | { type: 'REMOVE_ITEM'; itemId: string }
  | { type: 'UPDATE_QUANTITY'; itemId: string; quantity: number }
  | { type: 'APPLY_DISCOUNT'; code: string }
  | { type: 'CLEAR_CART' };

function cartReducer(state: CartState, action: CartAction): CartState {
  switch (action.type) {
    case 'ADD_ITEM': {
      const existingIndex = state.items.findIndex(i => i.id === action.item.id);
      if (existingIndex >= 0) {
        const newItems = [...state.items];
        newItems[existingIndex].quantity += 1;
        return { ...state, items: newItems, total: calculateTotal(newItems) };
      }
      const newItems = [...state.items, { ...action.item, quantity: 1 }];
      return { ...state, items: newItems, total: calculateTotal(newItems) };
    }
    case 'REMOVE_ITEM': {
      const newItems = state.items.filter(i => i.id !== action.itemId);
      return { ...state, items: newItems, total: calculateTotal(newItems) };
    }
    case 'CLEAR_CART':
      return { items: [], total: 0, discountCode: null };
    default:
      return state;
  }
}

function CartProvider({ children }) {
  const [state, dispatch] = useReducer(cartReducer, {
    items: [],
    total: 0,
    discountCode: null,
  });

  return (
    <CartContext.Provider value={{ state, dispatch }}>
      {children}
    </CartContext.Provider>
  );
}
```

### 11.2 Zustand (Recommended for Most Apps)

```bash
npm install zustand
```

```javascript
import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import AsyncStorage from '@react-native-async-storage/async-storage';

// Auth store with persistence
interface AuthStore {
  user: User | null;
  token: string | null;
  isLoading: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
  updateProfile: (updates: Partial<User>) => void;
}

const useAuthStore = create<AuthStore>()(
  persist(
    (set, get) => ({
      user: null,
      token: null,
      isLoading: false,

      login: async (email, password) => {
        set({ isLoading: true });
        try {
          const { user, token } = await authApi.login(email, password);
          set({ user, token, isLoading: false });
        } catch (error) {
          set({ isLoading: false });
          throw error;
        }
      },

      logout: () => {
        set({ user: null, token: null });
        // Clear other stores if needed
        useCartStore.getState().clear();
      },

      updateProfile: (updates) => {
        set(state => ({
          user: state.user ? { ...state.user, ...updates } : null,
        }));
      },
    }),
    {
      name: 'auth-store',
      storage: createJSONStorage(() => AsyncStorage), // Persist to device
      // Only persist specific fields
      partialize: (state) => ({ user: state.user, token: state.token }),
    }
  )
);

// Cart store
interface CartStore {
  items: CartItem[];
  addItem: (item: Product) => void;
  removeItem: (itemId: string) => void;
  clear: () => void;
  total: () => number;
}

const useCartStore = create<CartStore>((set, get) => ({
  items: [],
  
  addItem: (item) => set(state => {
    const existing = state.items.find(i => i.id === item.id);
    if (existing) {
      return {
        items: state.items.map(i =>
          i.id === item.id ? { ...i, quantity: i.quantity + 1 } : i
        ),
      };
    }
    return { items: [...state.items, { ...item, quantity: 1 }] };
  }),
  
  removeItem: (itemId) => set(state => ({
    items: state.items.filter(i => i.id !== itemId),
  })),
  
  clear: () => set({ items: [] }),
  
  // Computed value
  total: () => get().items.reduce((sum, item) => sum + item.price * item.quantity, 0),
}));

// Usage in components
function CartButton() {
  const itemCount = useCartStore(state => state.items.length);
  const addItem = useCartStore(state => state.addItem);
  
  // Only re-renders when itemCount changes (selector)
  return <Badge count={itemCount} />;
}
```

### 11.3 React Query / TanStack Query (Server State)

```bash
npm install @tanstack/react-query
```

```javascript
import { QueryClient, QueryClientProvider, useQuery, useMutation, useInfiniteQuery } from '@tanstack/react-query';
import { createAsyncStoragePersister } from '@tanstack/query-async-storage-persister';
import { PersistQueryClientProvider } from '@tanstack/react-query-persist-client';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5 minutes
      gcTime: 1000 * 60 * 10,   // 10 minutes
      retry: 3,
      retryDelay: attemptIndex => Math.min(1000 * 2 ** attemptIndex, 30000),
    },
  },
});

// Persister for offline support
const asyncStoragePersister = createAsyncStoragePersister({
  storage: AsyncStorage,
});

// Root setup
function App() {
  return (
    <PersistQueryClientProvider
      client={queryClient}
      persistOptions={{ persister: asyncStoragePersister }}
    >
      <NavigationContainer>
        <RootNavigator />
      </NavigationContainer>
    </PersistQueryClientProvider>
  );
}

// Query hooks
function useProducts(category?: string) {
  return useQuery({
    queryKey: ['products', category],
    queryFn: () => api.getProducts({ category }),
    select: (data) => data.products, // Transform/select data
  });
}

function useInfiniteProducts(category?: string) {
  return useInfiniteQuery({
    queryKey: ['products', 'infinite', category],
    queryFn: ({ pageParam = 1 }) => api.getProducts({ category, page: pageParam }),
    getNextPageParam: (lastPage) => lastPage.nextPage ?? undefined,
    initialPageParam: 1,
  });
}

function useCreateProduct() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (newProduct: CreateProductInput) => api.createProduct(newProduct),
    onSuccess: (newProduct) => {
      // Invalidate and refetch
      queryClient.invalidateQueries({ queryKey: ['products'] });
      // Or optimistically update
      queryClient.setQueryData(['products'], (old: Product[]) => [...old, newProduct]);
    },
    onError: (error) => {
      Alert.alert('Error', error.message);
    },
  });
}

// Usage in component
function ProductListScreen() {
  const { data: products, isLoading, error, refetch } = useProducts();
  const createProduct = useCreateProduct();

  if (isLoading) return <LoadingSpinner />;
  if (error) return <ErrorView error={error} onRetry={refetch} />;

  return (
    <FlatList
      data={products}
      renderItem={({ item }) => <ProductCard product={item} />}
      onRefresh={refetch}
      refreshing={isLoading}
    />
  );
}
```

### 11.4 Redux Toolkit (for Complex Enterprise Apps)

```bash
npm install @reduxjs/toolkit react-redux
```

```javascript
import { createSlice, createAsyncThunk, configureStore } from '@reduxjs/toolkit';
import { TypedUseSelectorHook, useDispatch, useSelector } from 'react-redux';

// Async thunk
export const fetchProducts = createAsyncThunk(
  'products/fetchAll',
  async (params: FetchProductsParams, { rejectWithValue }) => {
    try {
      const products = await api.getProducts(params);
      return products;
    } catch (error) {
      return rejectWithValue(error.message);
    }
  }
);

// Slice
const productsSlice = createSlice({
  name: 'products',
  initialState: {
    items: [] as Product[],
    status: 'idle' as 'idle' | 'loading' | 'succeeded' | 'failed',
    error: null as string | null,
  },
  reducers: {
    addProduct: (state, action) => {
      state.items.push(action.payload);
    },
    removeProduct: (state, action) => {
      state.items = state.items.filter(p => p.id !== action.payload);
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchProducts.pending, (state) => {
        state.status = 'loading';
      })
      .addCase(fetchProducts.fulfilled, (state, action) => {
        state.status = 'succeeded';
        state.items = action.payload;
      })
      .addCase(fetchProducts.rejected, (state, action) => {
        state.status = 'failed';
        state.error = action.payload as string;
      });
  },
});

const store = configureStore({
  reducer: {
    products: productsSlice.reducer,
    auth: authSlice.reducer,
    cart: cartSlice.reducer,
  },
});

// Typed hooks
type RootState = ReturnType<typeof store.getState>;
type AppDispatch = typeof store.dispatch;
export const useAppDispatch = () => useDispatch<AppDispatch>();
export const useAppSelector: TypedUseSelectorHook<RootState> = useSelector;
```

---

## 12. Styling in React Native

### 12.1 StyleSheet API

```javascript
import { StyleSheet, Dimensions, PixelRatio } from 'react-native';

const { width: SCREEN_WIDTH, height: SCREEN_HEIGHT } = Dimensions.get('window');

// Base unit for responsive design
const BASE_WIDTH = 375; // iPhone 14 width
const scale = (size: number) => (SCREEN_WIDTH / BASE_WIDTH) * size;
const normalize = (size: number) => {
  const newSize = scale(size);
  if (Platform.OS === 'ios') {
    return Math.round(PixelRatio.roundToNearestPixel(newSize));
  }
  return Math.round(PixelRatio.roundToNearestPixel(newSize)) - 2;
};

const styles = StyleSheet.create({
  // Layout
  container: {
    flex: 1,
    backgroundColor: '#F2F2F7',
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  centered: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  
  // Responsive sizing
  title: {
    fontSize: normalize(24),
    lineHeight: normalize(32),
  },
  
  // Absolute positioning
  overlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
  },
  
  // Shadows (iOS)
  shadow: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.12,
    shadowRadius: 8,
    elevation: 4, // Android
  },
  
  // Borders
  divider: {
    height: StyleSheet.hairlineWidth, // Thinnest possible line
    backgroundColor: '#E5E5EA',
  },
});
```

### 12.2 Theming with React Context

```javascript
import { createContext, useContext, useState } from 'react';
import { useColorScheme } from 'react-native';

const lightTheme = {
  colors: {
    primary: '#007AFF',
    background: '#F2F2F7',
    surface: '#FFFFFF',
    text: '#000000',
    textSecondary: '#6C6C70',
    border: '#C6C6C8',
    error: '#FF3B30',
    success: '#34C759',
    warning: '#FF9500',
  },
  spacing: {
    xs: 4, sm: 8, md: 16, lg: 24, xl: 32, xxl: 48,
  },
  typography: {
    h1: { fontSize: 34, fontWeight: '700', lineHeight: 41 },
    h2: { fontSize: 28, fontWeight: '700', lineHeight: 34 },
    h3: { fontSize: 22, fontWeight: '600', lineHeight: 28 },
    body: { fontSize: 17, lineHeight: 22 },
    caption: { fontSize: 12, lineHeight: 16 },
  },
  borderRadius: {
    sm: 4, md: 8, lg: 12, xl: 16, round: 9999,
  },
};

const darkTheme: typeof lightTheme = {
  ...lightTheme,
  colors: {
    ...lightTheme.colors,
    background: '#000000',
    surface: '#1C1C1E',
    text: '#FFFFFF',
    textSecondary: '#AEAEB2',
    border: '#38383A',
  },
};

type Theme = typeof lightTheme;
const ThemeContext = createContext<Theme>(lightTheme);

export function ThemeProvider({ children }) {
  const colorScheme = useColorScheme();
  const theme = colorScheme === 'dark' ? darkTheme : lightTheme;

  return (
    <ThemeContext.Provider value={theme}>
      {children}
    </ThemeContext.Provider>
  );
}

export const useTheme = () => useContext(ThemeContext);

// Usage
function ThemedButton({ label, onPress }) {
  const theme = useTheme();
  
  return (
    <Pressable
      onPress={onPress}
      style={{
        backgroundColor: theme.colors.primary,
        paddingVertical: theme.spacing.md,
        paddingHorizontal: theme.spacing.lg,
        borderRadius: theme.borderRadius.md,
      }}
    >
      <Text style={{ ...theme.typography.body, color: '#fff', fontWeight: '600' }}>
        {label}
      </Text>
    </Pressable>
  );
}
```

### 12.3 Animated API

```javascript
import { Animated, Easing, useAnimatedValue } from 'react-native';
import { useEffect, useRef } from 'react';

// Fade in animation
function FadeInView({ children, duration = 300 }) {
  const opacity = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    Animated.timing(opacity, {
      toValue: 1,
      duration,
      easing: Easing.out(Easing.ease),
      useNativeDriver: true, // ✅ Always use native driver for opacity/transform
    }).start();
  }, []);

  return (
    <Animated.View style={{ opacity }}>
      {children}
    </Animated.View>
  );
}

// Sequence of animations
function ComplexAnimation() {
  const translateY = useRef(new Animated.Value(100)).current;
  const opacity = useRef(new Animated.Value(0)).current;
  const scale = useRef(new Animated.Value(0.8)).current;

  const animate = () => {
    Animated.sequence([
      // Step 1: Fade in + slide up
      Animated.parallel([
        Animated.timing(opacity, { toValue: 1, duration: 300, useNativeDriver: true }),
        Animated.spring(translateY, {
          toValue: 0,
          tension: 80,
          friction: 8,
          useNativeDriver: true,
        }),
      ]),
      // Step 2: Scale up with bounce
      Animated.spring(scale, {
        toValue: 1,
        tension: 150,
        friction: 5,
        useNativeDriver: true,
      }),
    ]).start();
  };

  useEffect(() => { animate(); }, []);

  return (
    <Animated.View
      style={{
        opacity,
        transform: [{ translateY }, { scale }],
      }}
    >
      {/* Content */}
    </Animated.View>
  );
}

// Staggered list animation
function AnimatedList({ items }) {
  const animations = useRef(items.map(() => new Animated.Value(0))).current;

  useEffect(() => {
    Animated.stagger(
      50, // 50ms between each item
      animations.map(anim =>
        Animated.spring(anim, {
          toValue: 1,
          tension: 100,
          friction: 8,
          useNativeDriver: true,
        })
      )
    ).start();
  }, []);

  return (
    <>
      {items.map((item, index) => (
        <Animated.View
          key={item.id}
          style={{
            opacity: animations[index],
            transform: [{
              translateY: animations[index].interpolate({
                inputRange: [0, 1],
                outputRange: [20, 0],
              }),
            }],
          }}
        >
          <ItemCard item={item} />
        </Animated.View>
      ))}
    </>
  );
}
```

### 12.4 Reanimated 3 (Advanced Animations)

```bash
npm install react-native-reanimated
```

```javascript
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withSpring,
  withTiming,
  interpolate,
  Extrapolate,
  runOnJS,
  useAnimatedScrollHandler,
} from 'react-native-reanimated';
import { Gesture, GestureDetector } from 'react-native-gesture-handler';

// Draggable card with spring physics
function DraggableCard() {
  const translateX = useSharedValue(0);
  const translateY = useSharedValue(0);
  const scale = useSharedValue(1);

  const panGesture = Gesture.Pan()
    .onBegin(() => {
      scale.value = withSpring(1.05);
    })
    .onUpdate((event) => {
      translateX.value = event.translationX;
      translateY.value = event.translationY;
    })
    .onEnd(() => {
      translateX.value = withSpring(0, { damping: 20 });
      translateY.value = withSpring(0, { damping: 20 });
      scale.value = withSpring(1);
    });

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [
      { translateX: translateX.value },
      { translateY: translateY.value },
      { scale: scale.value },
    ],
  }));

  return (
    <GestureDetector gesture={panGesture}>
      <Animated.View style={[styles.card, animatedStyle]}>
        <Text>Drag me!</Text>
      </Animated.View>
    </GestureDetector>
  );
}

// Parallax scroll header
function ParallaxHeader({ headerHeight = 300 }) {
  const scrollY = useSharedValue(0);

  const scrollHandler = useAnimatedScrollHandler({
    onScroll: (event) => {
      scrollY.value = event.contentOffset.y;
    },
  });

  const headerStyle = useAnimatedStyle(() => ({
    transform: [
      {
        translateY: interpolate(
          scrollY.value,
          [-headerHeight, 0, headerHeight],
          [-headerHeight / 2, 0, headerHeight * 0.75],
          Extrapolate.CLAMP
        ),
      },
    ],
    opacity: interpolate(
      scrollY.value,
      [0, headerHeight * 0.5],
      [1, 0],
      Extrapolate.CLAMP
    ),
  }));

  return (
    <View style={{ flex: 1 }}>
      <Animated.View style={[styles.header, headerStyle]}>
        <Image source={{ uri: headerImage }} style={StyleSheet.absoluteFill} />
      </Animated.View>
      <Animated.ScrollView onScroll={scrollHandler} scrollEventThrottle={16}>
        <View style={{ height: headerHeight }} />
        {/* Content */}
      </Animated.ScrollView>
    </View>
  );
}
```

---

## 13. Networking & Data Fetching

### 13.1 Axios Setup with Interceptors

```javascript
// services/api.ts
import axios, { AxiosInstance, AxiosRequestConfig, AxiosError } from 'axios';
import { useAuthStore } from '@/store/authStore';

const BASE_URL = process.env.EXPO_PUBLIC_API_URL ?? 'https://api.yourapp.com';

function createApiClient(): AxiosInstance {
  const client = axios.create({
    baseURL: BASE_URL,
    timeout: 15000,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  });

  // Request interceptor: attach token
  client.interceptors.request.use(
    (config) => {
      const token = useAuthStore.getState().token;
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
      return config;
    },
    (error) => Promise.reject(error)
  );

  // Response interceptor: handle errors globally
  client.interceptors.response.use(
    (response) => response.data,
    async (error: AxiosError) => {
      if (error.response?.status === 401) {
        // Token expired — attempt refresh
        try {
          await refreshToken();
          return client(error.config!); // Retry original request
        } catch {
          useAuthStore.getState().logout();
          // Navigate to login
        }
      }

      if (error.response?.status === 429) {
        // Rate limited — wait and retry
        const retryAfter = error.response.headers['retry-after'] ?? 1;
        await new Promise(resolve => setTimeout(resolve, retryAfter * 1000));
        return client(error.config!);
      }

      // Log error
      if (__DEV__) {
        console.error('[API Error]', error.config?.url, error.response?.data);
      }

      return Promise.reject(error);
    }
  );

  return client;
}

export const api = createApiClient();

// Typed API functions
export const productsApi = {
  getAll: (params?: GetProductsParams) => 
    api.get<ProductsResponse>('/products', { params }),
  
  getById: (id: string) => 
    api.get<Product>(`/products/${id}`),
  
  create: (data: CreateProductInput) => 
    api.post<Product>('/products', data),
  
  update: (id: string, data: UpdateProductInput) => 
    api.patch<Product>(`/products/${id}`, data),
  
  delete: (id: string) => 
    api.delete(`/products/${id}`),
  
  uploadImage: (id: string, imageUri: string) => {
    const formData = new FormData();
    const filename = imageUri.split('/').pop();
    const type = `image/${filename?.split('.').pop()}`;
    
    formData.append('image', {
      uri: imageUri,
      name: filename,
      type,
    } as any);
    
    return api.post(`/products/${id}/image`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },
};
```

### 13.2 WebSocket Support

```javascript
// hooks/useWebSocket.ts
import { useEffect, useRef, useCallback, useState } from 'react';
import { AppState } from 'react-native';

interface WebSocketOptions {
  url: string;
  onMessage: (data: any) => void;
  onError?: (error: Event) => void;
  reconnectDelay?: number;
  maxReconnects?: number;
}

export function useWebSocket({
  url,
  onMessage,
  onError,
  reconnectDelay = 3000,
  maxReconnects = 5,
}: WebSocketOptions) {
  const ws = useRef<WebSocket | null>(null);
  const reconnectCount = useRef(0);
  const reconnectTimer = useRef<NodeJS.Timeout | null>(null);
  const [status, setStatus] = useState<'connecting' | 'connected' | 'disconnected'>('disconnected');

  const connect = useCallback(() => {
    if (ws.current?.readyState === WebSocket.OPEN) return;

    setStatus('connecting');
    ws.current = new WebSocket(url);

    ws.current.onopen = () => {
      setStatus('connected');
      reconnectCount.current = 0;
    };

    ws.current.onmessage = (event) => {
      try {
        const data = JSON.parse(event.data);
        onMessage(data);
      } catch {
        onMessage(event.data);
      }
    };

    ws.current.onclose = () => {
      setStatus('disconnected');
      if (reconnectCount.current < maxReconnects) {
        reconnectCount.current++;
        reconnectTimer.current = setTimeout(connect, reconnectDelay);
      }
    };

    ws.current.onerror = (error) => {
      onError?.(error);
    };
  }, [url, onMessage]);

  const send = useCallback((data: any) => {
    if (ws.current?.readyState === WebSocket.OPEN) {
      ws.current.send(typeof data === 'string' ? data : JSON.stringify(data));
    }
  }, []);

  const disconnect = useCallback(() => {
    if (reconnectTimer.current) clearTimeout(reconnectTimer.current);
    ws.current?.close();
  }, []);

  useEffect(() => {
    connect();

    // Reconnect when app comes to foreground
    const appStateSubscription = AppState.addEventListener('change', (state) => {
      if (state === 'active') connect();
      if (state === 'background') disconnect();
    });

    return () => {
      disconnect();
      appStateSubscription.remove();
    };
  }, [connect, disconnect]);

  return { status, send };
}

// Usage: Real-time chat
function ChatScreen({ roomId }) {
  const addMessage = useChatStore(state => state.addMessage);
  const { status, send } = useWebSocket({
    url: `wss://api.yourapp.com/chat/${roomId}`,
    onMessage: (data) => {
      if (data.type === 'message') addMessage(data.message);
    },
  });

  const sendMessage = (text) => {
    send({ type: 'message', content: text, roomId });
  };
}
```

---

## 14. Performance Optimization

### 14.1 Rendering Optimization

```javascript
import React, { memo, useMemo, useCallback, startTransition } from 'react';

// ✅ memo — prevent re-renders when props haven't changed
const ProductCard = memo(({ product, onPress, onAddToCart }) => {
  return (
    <Pressable onPress={() => onPress(product.id)}>
      <ExpoImage source={product.imageUrl} style={styles.image} />
      <Text>{product.name}</Text>
      <Text>${product.price}</Text>
      <Button onPress={() => onAddToCart(product)} title="Add to Cart" />
    </Pressable>
  );
}, (prevProps, nextProps) => {
  // Custom comparison — only re-render if product or handlers change
  return prevProps.product.id === nextProps.product.id &&
    prevProps.product.price === nextProps.product.price &&
    prevProps.onPress === nextProps.onPress &&
    prevProps.onAddToCart === nextProps.onAddToCart;
});

// ✅ useCallback — stable function references
function ProductList({ category }) {
  const navigation = useNavigation();
  const addToCart = useCartStore(state => state.addItem);

  const handlePress = useCallback((productId) => {
    navigation.navigate('ProductDetail', { productId });
  }, [navigation]);

  const handleAddToCart = useCallback((product) => {
    addToCart(product);
    // Show feedback without blocking the UI
    startTransition(() => {
      setShowConfirmation(true);
    });
  }, [addToCart]);

  // ✅ useMemo — expensive computations
  const sortedProducts = useMemo(() => 
    [...products].sort((a, b) => a.price - b.price),
    [products]
  );

  return (
    <FlatList
      data={sortedProducts}
      renderItem={({ item }) => (
        <ProductCard
          product={item}
          onPress={handlePress}
          onAddToCart={handleAddToCart}
        />
      )}
    />
  );
}
```

### 14.2 FlatList Performance

```javascript
const ITEM_HEIGHT = 120;

function OptimizedFlatList({ data }) {
  // ✅ Constant height items: use getItemLayout for O(1) scroll
  const getItemLayout = useCallback((_, index) => ({
    length: ITEM_HEIGHT,
    offset: ITEM_HEIGHT * index,
    index,
  }), []);

  // ✅ Stable key extractor
  const keyExtractor = useCallback((item) => item.id, []);

  // ✅ Memoized render function
  const renderItem = useCallback(({ item }) => (
    <ListItem item={item} />
  ), []);

  // ✅ Memoized empty state
  const ListEmpty = useMemo(() => <EmptyState />, []);

  return (
    <FlashList  // Consider FlashList from @shopify/flash-list for even better perf
      data={data}
      renderItem={renderItem}
      keyExtractor={keyExtractor}
      estimatedItemSize={ITEM_HEIGHT}
      getItemLayout={getItemLayout}
      
      // Virtualization settings
      initialNumToRender={15}
      maxToRenderPerBatch={10}
      updateCellsBatchingPeriod={50}
      windowSize={21} // 10 screens above + current + 10 below
      
      // Clipping
      removeClippedSubviews={Platform.OS === 'android'}
      
      // Infinite scroll
      onEndReached={loadMore}
      onEndReachedThreshold={0.3}
      
      ListEmptyComponent={ListEmpty}
    />
  );
}
```

### 14.3 Image Performance

```javascript
// expo-image is dramatically faster than built-in Image
import { Image } from 'expo-image';

// ✅ Always specify dimensions — prevents layout shifts
// ✅ Use contentFit instead of resizeMode
// ✅ Leverage blurhash for instant placeholder
// ✅ Disk + memory caching

const blurhash = 'L6PZfSi_.AyE_3t7t7R**0o#DgR4'; // Pre-computed blur hash

function ProductImage({ uri, width, height }) {
  return (
    <Image
      source={uri}
      style={{ width, height }}
      contentFit="cover"
      transition={{ duration: 300, effect: 'cross-dissolve' }}
      cachePolicy="memory-disk"
      placeholder={{ blurhash }}
      priority="normal"  // 'low' | 'normal' | 'high'
    />
  );
}

// Prefetch images before they're needed
import { Image } from 'expo-image';

async function prefetchNextPageImages(products) {
  await Image.prefetch(products.map(p => p.imageUrl));
}
```

### 14.4 Bundle Size Optimization

```javascript
// metro.config.js — Enable tree shaking
const config = getDefaultConfig(__dirname);

// Minification settings
config.transformer.minifierConfig = {
  keep_fnames: true,
  mangle: { keep_fnames: true },
};

// Avoid polyfills for modern APIs
config.resolver.resolveRequest = (context, moduleName, platform) => {
  if (moduleName === 'crypto') {
    return { type: 'empty' }; // Don't include node crypto polyfill
  }
  return context.resolveRequest(context, moduleName, platform);
};

// Dynamic imports for code splitting
const HeavyComponent = lazy(() => import('./HeavyComponent'));

// Analyze bundle
// npx expo export --dump-sourcemap
// npx source-map-explorer dist/bundle.js dist/bundle.js.map
```

### 14.5 Memory Management

```javascript
// ✅ Always clean up subscriptions and timers
useEffect(() => {
  const subscription = someEmitter.addListener('event', handler);
  const timer = setInterval(pollData, 5000);
  const animationFrame = requestAnimationFrame(animate);
  
  return () => {
    subscription.remove();
    clearInterval(timer);
    cancelAnimationFrame(animationFrame);
  };
}, []);

// ✅ Cancel pending requests on unmount
useEffect(() => {
  const controller = new AbortController();
  
  fetchData({ signal: controller.signal }).then(setData);
  
  return () => controller.abort();
}, []);

// ✅ Use weak references for caches
const imageCache = new WeakMap();

// ✅ Dispose of large objects explicitly
useEffect(() => {
  const buffer = new ArrayBuffer(10 * 1024 * 1024); // 10MB
  processData(buffer);
  
  return () => {
    // Allow GC to collect
    // buffer = null; // Can't reassign const, but going out of scope is enough
  };
}, []);
```

---

## 15. Testing Strategy

### 15.1 Unit Testing with Jest

```bash
npm install --save-dev jest @testing-library/react-native @testing-library/jest-native
```

```javascript
// __tests__/utils/formatCurrency.test.ts
import { formatCurrency } from '@/utils/formatCurrency';

describe('formatCurrency', () => {
  it('formats USD correctly', () => {
    expect(formatCurrency(1234.56, 'USD')).toBe('$1,234.56');
  });

  it('handles zero', () => {
    expect(formatCurrency(0, 'USD')).toBe('$0.00');
  });

  it('handles negative values', () => {
    expect(formatCurrency(-500, 'USD')).toBe('-$500.00');
  });
});

// __tests__/hooks/useCart.test.ts
import { renderHook, act } from '@testing-library/react-native';
import { useCartStore } from '@/store/cartStore';

describe('useCartStore', () => {
  beforeEach(() => {
    useCartStore.setState({ items: [] });
  });

  it('adds item to cart', () => {
    const { result } = renderHook(() => useCartStore());
    
    act(() => {
      result.current.addItem({ id: '1', name: 'Product', price: 9.99 });
    });

    expect(result.current.items).toHaveLength(1);
    expect(result.current.items[0].id).toBe('1');
  });

  it('increments quantity for duplicate item', () => {
    const { result } = renderHook(() => useCartStore());
    
    act(() => {
      result.current.addItem({ id: '1', name: 'Product', price: 9.99 });
      result.current.addItem({ id: '1', name: 'Product', price: 9.99 });
    });

    expect(result.current.items).toHaveLength(1);
    expect(result.current.items[0].quantity).toBe(2);
  });
});
```

### 15.2 Component Testing with React Testing Library

```javascript
// __tests__/components/ProductCard.test.tsx
import React from 'react';
import { render, fireEvent, waitFor, screen } from '@testing-library/react-native';
import { ProductCard } from '@/components/ProductCard';

const mockProduct = {
  id: '1',
  name: 'Test Product',
  price: 29.99,
  imageUrl: 'https://example.com/image.jpg',
  rating: 4.5,
};

describe('ProductCard', () => {
  it('renders product information', () => {
    render(<ProductCard product={mockProduct} onPress={jest.fn()} />);
    
    expect(screen.getByText('Test Product')).toBeOnTheScreen();
    expect(screen.getByText('$29.99')).toBeOnTheScreen();
    expect(screen.getByText('4.5')).toBeOnTheScreen();
  });

  it('calls onPress with product id when pressed', () => {
    const onPress = jest.fn();
    render(<ProductCard product={mockProduct} onPress={onPress} />);
    
    fireEvent.press(screen.getByTestId('product-card'));
    
    expect(onPress).toHaveBeenCalledWith('1');
  });

  it('shows loading state', async () => {
    render(<ProductCard product={mockProduct} onPress={jest.fn()} />);
    
    // Image placeholder should show initially
    expect(screen.getByTestId('image-placeholder')).toBeOnTheScreen();
    
    // After image loads...
    fireEvent(screen.getByRole('image'), 'load');
    await waitFor(() => {
      expect(screen.queryByTestId('image-placeholder')).not.toBeOnTheScreen();
    });
  });
});
```

### 15.3 E2E Testing with Detox

```bash
npm install --save-dev detox
detox init
```

```javascript
// e2e/login.test.ts
describe('Login Flow', () => {
  beforeAll(async () => {
    await device.launchApp({ newInstance: true });
  });

  beforeEach(async () => {
    await device.reloadReactNative();
  });

  it('should show login screen on launch', async () => {
    await expect(element(by.id('login-screen'))).toBeVisible();
    await expect(element(by.id('email-input'))).toBeVisible();
    await expect(element(by.id('password-input'))).toBeVisible();
  });

  it('should login successfully with valid credentials', async () => {
    await element(by.id('email-input')).typeText('test@example.com');
    await element(by.id('password-input')).typeText('Password123!');
    await element(by.id('login-button')).tap();
    
    // Wait for navigation to home screen
    await waitFor(element(by.id('home-screen')))
      .toBeVisible()
      .withTimeout(5000);
  });

  it('should show error message with invalid credentials', async () => {
    await element(by.id('email-input')).typeText('wrong@email.com');
    await element(by.id('password-input')).typeText('wrongpassword');
    await element(by.id('login-button')).tap();
    
    await waitFor(element(by.text('Invalid email or password')))
      .toBeVisible()
      .withTimeout(3000);
  });
});
```

---

## 16. Security Best Practices

### 16.1 Secure Storage

```javascript
// NEVER store sensitive data in AsyncStorage — it's unencrypted
// ❌ Bad
await AsyncStorage.setItem('authToken', token);

// ✅ Good — use expo-secure-store (uses Keychain on iOS, Keystore on Android)
import * as SecureStore from 'expo-secure-store';

const tokenStorage = {
  getItem: async (key: string) => {
    return await SecureStore.getItemAsync(key);
  },
  setItem: async (key: string, value: string) => {
    await SecureStore.setItemAsync(key, value, {
      keychainAccessible: SecureStore.WHEN_UNLOCKED_THIS_DEVICE_ONLY,
    });
  },
  removeItem: async (key: string) => {
    await SecureStore.deleteItemAsync(key);
  },
};

// Use with zustand persist
const useAuthStore = create<AuthStore>()(
  persist(
    (set) => ({ /* ... */ }),
    {
      name: 'auth',
      storage: createJSONStorage(() => tokenStorage),
    }
  )
);
```

### 16.2 Certificate Pinning

```javascript
// With react-native-ssl-pinning
import { fetch as sslFetch } from 'react-native-ssl-pinning';

const response = await sslFetch('https://api.yourapp.com/data', {
  method: 'GET',
  sslPinning: {
    certs: ['api.yourapp.com'], // Match against bundled cert
  },
  headers: { Authorization: `Bearer ${token}` },
  timeoutInterval: 10000,
});
```

### 16.3 Environment Variables

```javascript
// .env.local (never commit this file)
EXPO_PUBLIC_API_URL=https://api.yourapp.com
EXPO_PUBLIC_STRIPE_KEY=pk_live_xxxxx
SECRET_API_KEY=sk_live_xxxxx  # Not prefixed = server-side only in EAS

// app.config.js
export default {
  extra: {
    // EXPO_PUBLIC_ vars are automatically included
    // Never include secret keys here
    environment: process.env.APP_ENV ?? 'development',
  },
};

// Usage in code
const apiUrl = process.env.EXPO_PUBLIC_API_URL;

// ✅ Validate at startup
function validateEnvironment() {
  const required = ['EXPO_PUBLIC_API_URL', 'EXPO_PUBLIC_STRIPE_KEY'];
  const missing = required.filter(key => !process.env[key]);
  
  if (missing.length > 0) {
    throw new Error(`Missing required environment variables: ${missing.join(', ')}`);
  }
}
```

### 16.4 Jailbreak/Root Detection

```javascript
import JailMonkey from 'jail-monkey';

async function checkDeviceSecurity() {
  if (JailMonkey.isJailBroken()) {
    Alert.alert(
      'Security Warning',
      'This app cannot run on jailbroken or rooted devices.',
      [{ text: 'Exit', onPress: () => BackHandler.exitApp() }]
    );
    return false;
  }
  
  if (JailMonkey.hookDetected()) {
    // Frida or similar hooking detected
    return false;
  }
  
  return true;
}
```

### 16.5 Biometric Authentication

```javascript
import * as LocalAuthentication from 'expo-local-authentication';

async function authenticateWithBiometrics(): Promise<boolean> {
  const hasHardware = await LocalAuthentication.hasHardwareAsync();
  if (!hasHardware) return false;

  const isEnrolled = await LocalAuthentication.isEnrolledAsync();
  if (!isEnrolled) return false;

  const supportedTypes = await LocalAuthentication.supportedAuthenticationTypesAsync();
  const hasFaceID = supportedTypes.includes(
    LocalAuthentication.AuthenticationType.FACIAL_RECOGNITION
  );
  
  const result = await LocalAuthentication.authenticateAsync({
    promptMessage: hasFaceID ? 'Authenticate with Face ID' : 'Authenticate with Touch ID',
    fallbackLabel: 'Use passcode',
    cancelLabel: 'Cancel',
    disableDeviceFallback: false,
  });

  return result.success;
}
```

---

## 17. Native Modules & Bridging

### 17.1 Config Plugins (Expo)

Config plugins allow you to customize native code without manually editing native files:

```javascript
// plugins/withCustomPlist.js
const { withInfoPlist } = require('@expo/config-plugins');

module.exports = function withCustomPlist(config) {
  return withInfoPlist(config, (config) => {
    // Add custom iOS permissions
    config.modResults.NSMicrophoneUsageDescription = 
      'This app uses the microphone to record voice messages.';
    
    // Disable ATS for specific domains
    config.modResults.NSAppTransportSecurity = {
      NSExceptionDomains: {
        'api.yourapp.com': {
          NSExceptionAllowsInsecureHTTPLoads: false,
          NSRequiresCertificateTransparency: false,
        },
      },
    };
    
    return config;
  });
};

// app.config.js
export default {
  plugins: [
    './plugins/withCustomPlist',
    // ...
  ],
};
```

### 17.2 Writing a Custom Native Module (New Architecture)

**iOS (Swift):**
```swift
// NativeCalculator.swift
import Foundation

@objc(NativeCalculator)
class NativeCalculator: NSObject {
  
  @objc func add(_ a: Double, b: Double, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
    resolve(a + b)
  }
  
  @objc static func requiresMainQueueSetup() -> Bool {
    return false
  }
}
```

**JavaScript Bridge:**
```javascript
// NativeCalculator.ts
import { NativeModules } from 'react-native';

const { NativeCalculator } = NativeModules;

export const calculator = {
  add: (a: number, b: number): Promise<number> => 
    NativeCalculator.add(a, b),
};

// Usage
const result = await calculator.add(5, 3); // 8
```

### 17.3 JSI Native Module (TurboModule)

```typescript
// NativeCalculator.ts — TurboModule spec
import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  add(a: number, b: number): Promise<number>;
  multiply(a: number, b: number): number; // Can be synchronous with JSI!
}

export default TurboModuleRegistry.getEnforcing<Spec>('NativeCalculator');
```

---

## 18. Expo-Specific Features

### 18.1 Expo Camera

```javascript
import { CameraView, CameraType, useCameraPermissions, BarcodeScanningResult } from 'expo-camera';
import { useState, useRef } from 'react';

function CameraScreen() {
  const [facing, setFacing] = useState<CameraType>('back');
  const [permission, requestPermission] = useCameraPermissions();
  const cameraRef = useRef<CameraView>(null);

  if (!permission) return <View />;
  
  if (!permission.granted) {
    return (
      <View style={styles.container}>
        <Text>Camera access is required</Text>
        <Button onPress={requestPermission} title="Grant Permission" />
      </View>
    );
  }

  const takePicture = async () => {
    const photo = await cameraRef.current?.takePictureAsync({
      quality: 0.8,
      base64: false,
      skipProcessing: false,
    });
    
    if (photo) {
      await uploadPhoto(photo.uri);
    }
  };

  const handleBarcodeScan = (result: BarcodeScanningResult) => {
    console.log('Scanned:', result.type, result.data);
  };

  return (
    <CameraView
      ref={cameraRef}
      style={StyleSheet.absoluteFill}
      facing={facing}
      onBarcodeScanned={handleBarcodeScan}
      barcodeScannerSettings={{
        barcodeTypes: ['qr', 'pdf417', 'ean13'],
      }}
    >
      <View style={styles.controls}>
        <Pressable onPress={() => setFacing(f => f === 'back' ? 'front' : 'back')}>
          <Text>Flip</Text>
        </Pressable>
        <Pressable onPress={takePicture}>
          <View style={styles.captureButton} />
        </Pressable>
      </View>
    </CameraView>
  );
}
```

### 18.2 Expo Location

```javascript
import * as Location from 'expo-location';
import { useEffect, useState } from 'react';

function useLocation() {
  const [location, setLocation] = useState<Location.LocationObject | null>(null);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let subscription: Location.LocationSubscription | null = null;

    (async () => {
      const { status } = await Location.requestForegroundPermissionsAsync();
      if (status !== 'granted') {
        setErrorMsg('Permission denied');
        setLoading(false);
        return;
      }

      // One-time location
      const loc = await Location.getCurrentPositionAsync({
        accuracy: Location.Accuracy.Balanced,
      });
      setLocation(loc);
      setLoading(false);

      // Continuous watching
      subscription = await Location.watchPositionAsync(
        {
          accuracy: Location.Accuracy.High,
          timeInterval: 5000,       // Update every 5 seconds
          distanceInterval: 10,     // Or when moved 10 meters
        },
        (location) => setLocation(location)
      );
    })();

    return () => {
      subscription?.remove();
    };
  }, []);

  return { location, errorMsg, loading };
}

// Geocoding
async function getAddressFromCoordinates(latitude: number, longitude: number) {
  const results = await Location.reverseGeocodeAsync({ latitude, longitude });
  if (results.length > 0) {
    const address = results[0];
    return `${address.street}, ${address.city}, ${address.country}`;
  }
  return null;
}
```

### 18.3 Expo Notifications

```javascript
import * as Notifications from 'expo-notifications';
import * as Device from 'expo-device';
import Constants from 'expo-constants';

// Configure notification behavior
Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge: true,
  }),
});

async function registerForPushNotifications(): Promise<string | null> {
  if (!Device.isDevice) {
    console.warn('Push notifications only work on physical devices');
    return null;
  }

  const { status: existingStatus } = await Notifications.getPermissionsAsync();
  let finalStatus = existingStatus;

  if (existingStatus !== 'granted') {
    const { status } = await Notifications.requestPermissionsAsync();
    finalStatus = status;
  }

  if (finalStatus !== 'granted') return null;

  const token = await Notifications.getExpoPushTokenAsync({
    projectId: Constants.expoConfig?.extra?.eas?.projectId,
  });

  // Send token to your server
  await api.registerPushToken(token.data);

  return token.data;
}

// Schedule local notification
async function scheduleReminder(title: string, body: string, date: Date) {
  await Notifications.scheduleNotificationAsync({
    content: {
      title,
      body,
      data: { type: 'reminder' },
      sound: 'default',
      badge: 1,
    },
    trigger: {
      date,
    },
  });
}

// Handle notification responses
function NotificationHandler() {
  const navigation = useNavigation();

  useEffect(() => {
    // When user taps notification while app is open
    const responseListener = Notifications.addNotificationResponseReceivedListener(
      (response) => {
        const data = response.notification.request.content.data;
        if (data.type === 'order') {
          navigation.navigate('OrderDetail', { orderId: data.orderId });
        }
      }
    );

    // When notification received while app is in foreground
    const receivedListener = Notifications.addNotificationReceivedListener(
      (notification) => {
        console.log('Notification received:', notification);
      }
    );

    return () => {
      Notifications.removeNotificationSubscription(responseListener);
      Notifications.removeNotificationSubscription(receivedListener);
    };
  }, []);

  return null;
}
```

### 18.4 Expo FileSystem

```javascript
import * as FileSystem from 'expo-file-system';

// Download a file
async function downloadFile(url: string, filename: string): Promise<string> {
  const localUri = FileSystem.documentDirectory + filename;
  
  const { exists } = await FileSystem.getInfoAsync(localUri);
  if (exists) return localUri; // Return cached version
  
  const downloadResumable = FileSystem.createDownloadResumable(
    url,
    localUri,
    {},
    (downloadProgress) => {
      const progress = downloadProgress.totalBytesWritten / downloadProgress.totalBytesExpectedToWrite;
      setDownloadProgress(progress);
    }
  );

  const result = await downloadResumable.downloadAsync();
  return result?.uri ?? '';
}

// Read and write files
async function saveUserData(data: object) {
  const uri = FileSystem.documentDirectory + 'userData.json';
  await FileSystem.writeAsStringAsync(uri, JSON.stringify(data), {
    encoding: FileSystem.EncodingType.UTF8,
  });
}

async function loadUserData(): Promise<object | null> {
  const uri = FileSystem.documentDirectory + 'userData.json';
  const { exists } = await FileSystem.getInfoAsync(uri);
  if (!exists) return null;
  
  const content = await FileSystem.readAsStringAsync(uri);
  return JSON.parse(content);
}

// Cache management
async function clearCache() {
  await FileSystem.deleteAsync(FileSystem.cacheDirectory!, { idempotent: true });
}

async function getCacheSize(): Promise<number> {
  const info = await FileSystem.getInfoAsync(FileSystem.cacheDirectory!);
  return info.exists ? info.size : 0;
}
```

---

## 19. Deployment & CI/CD

### 19.1 EAS Build Configuration

```json
// eas.json
{
  "cli": {
    "version": ">= 5.9.1",
    "appVersionSource": "remote"
  },
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal",
      "ios": {
        "simulator": true
      },
      "android": {
        "buildType": "apk"
      },
      "env": {
        "EXPO_PUBLIC_API_URL": "http://localhost:3000",
        "APP_ENV": "development"
      }
    },
    "preview": {
      "distribution": "internal",
      "ios": {
        "resourceClass": "m-medium"
      },
      "android": {
        "buildType": "apk"
      },
      "env": {
        "EXPO_PUBLIC_API_URL": "https://staging-api.yourapp.com",
        "APP_ENV": "staging"
      }
    },
    "production": {
      "autoIncrement": true,
      "ios": {
        "resourceClass": "m-medium",
        "credentialsSource": "remote"
      },
      "android": {
        "buildType": "app-bundle",
        "credentialsSource": "remote"
      },
      "env": {
        "EXPO_PUBLIC_API_URL": "https://api.yourapp.com",
        "APP_ENV": "production"
      }
    }
  },
  "submit": {
    "production": {
      "ios": {
        "appleId": "your@apple.com",
        "ascAppId": "1234567890",
        "appleTeamId": "ABCDEF1234"
      },
      "android": {
        "serviceAccountKeyPath": "./google-service-account.json",
        "track": "internal"
      }
    }
  }
}
```

### 19.2 GitHub Actions CI/CD

```yaml
# .github/workflows/eas-build.yml
name: EAS Build

on:
  push:
    branches: [main, staging]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - run: npm ci
      - run: npm test -- --coverage --watchAll=false
      - run: npx tsc --noEmit

  build-preview:
    needs: test
    if: github.ref == 'refs/heads/staging'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - uses: expo/expo-github-action@v8
        with:
          expo-version: latest
          eas-version: latest
          token: ${{ secrets.EXPO_TOKEN }}
      - run: npm ci
      - run: eas build --platform all --profile preview --non-interactive

  build-production:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - uses: expo/expo-github-action@v8
        with:
          expo-version: latest
          eas-version: latest
          token: ${{ secrets.EXPO_TOKEN }}
      - run: npm ci
      - name: Build and submit
        run: |
          eas build --platform all --profile production --non-interactive --auto-submit
        env:
          EXPO_APPLE_APP_SPECIFIC_PASSWORD: ${{ secrets.APPLE_APP_SPECIFIC_PASSWORD }}
```

### 19.3 OTA Updates Strategy

```javascript
// Aggressive OTA update strategy
import * as Updates from 'expo-updates';

async function initializeApp() {
  if (!__DEV__) {
    try {
      const update = await Updates.checkForUpdateAsync();
      
      if (update.isAvailable) {
        // Critical update: force reload immediately
        if (update.manifest?.extra?.isCritical) {
          await Updates.fetchUpdateAsync();
          await Updates.reloadAsync();
          return; // New version loading
        }
        
        // Non-critical: download in background, apply on next launch
        await Updates.fetchUpdateAsync();
        
        // Ask user if they want to apply now
        Alert.alert(
          'Update Available',
          'A new version is ready. Restart now for the latest features?',
          [
            { text: 'Later', style: 'cancel' },
            { 
              text: 'Restart Now', 
              onPress: () => Updates.reloadAsync() 
            },
          ]
        );
      }
    } catch (error) {
      // Don't let update failures block app launch
      console.warn('Update check failed:', error);
    }
  }
}
```

---

## 20. Real-World Use Cases with Full Code

### 20.1 Use Case: E-Commerce App

**Scenario:** Building a full e-commerce app with product listing, cart, and checkout.

```javascript
// Complete shopping flow
// screens/ShopScreen.tsx
import { FlatList, View, Text, StyleSheet, Pressable } from 'react-native';
import { useInfiniteQuery } from '@tanstack/react-query';
import { Image } from 'expo-image';
import { useCartStore } from '@/store/cartStore';
import { useNavigation } from '@react-navigation/native';

export function ShopScreen() {
  const navigation = useNavigation();
  const addToCart = useCartStore(state => state.addItem);
  const cartCount = useCartStore(state => state.items.length);

  const {
    data,
    fetchNextPage,
    hasNextPage,
    isFetchingNextPage,
    isLoading,
  } = useInfiniteQuery({
    queryKey: ['products'],
    queryFn: ({ pageParam }) => api.products.getPage(pageParam),
    getNextPageParam: (last) => last.nextCursor,
    initialPageParam: null,
  });

  const products = data?.pages.flatMap(page => page.items) ?? [];

  useLayoutEffect(() => {
    navigation.setOptions({
      headerRight: () => (
        <Pressable onPress={() => navigation.navigate('Cart')}>
          <CartIcon count={cartCount} />
        </Pressable>
      ),
    });
  }, [cartCount, navigation]);

  const renderItem = useCallback(({ item }: { item: Product }) => (
    <ProductCard
      product={item}
      onPress={() => navigation.navigate('ProductDetail', { product: item })}
      onAddToCart={() => {
        addToCart(item);
        Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
      }}
    />
  ), [addToCart, navigation]);

  if (isLoading) return <ProductListSkeleton />;

  return (
    <FlatList
      data={products}
      renderItem={renderItem}
      keyExtractor={(item) => item.id}
      numColumns={2}
      columnWrapperStyle={styles.row}
      onEndReached={() => { if (hasNextPage) fetchNextPage(); }}
      onEndReachedThreshold={0.3}
      ListFooterComponent={isFetchingNextPage ? <LoadingFooter /> : null}
      contentContainerStyle={styles.list}
    />
  );
}

const styles = StyleSheet.create({
  row: { justifyContent: 'space-between', paddingHorizontal: 16 },
  list: { paddingTop: 8, paddingBottom: 100 },
});
```

### 20.2 Use Case: Real-Time Chat App

```javascript
// Complete chat implementation
// screens/ChatScreen.tsx
import { FlatList, TextInput, Pressable, KeyboardAvoidingView, Platform } from 'react-native';
import { useWebSocket } from '@/hooks/useWebSocket';
import { useChatStore } from '@/store/chatStore';

export function ChatScreen({ route }) {
  const { roomId, recipientName } = route.params;
  const { user } = useAuthStore();
  const messages = useChatStore(state => state.messages[roomId] ?? []);
  const addMessage = useChatStore(state => state.addMessage);
  const [inputText, setInputText] = useState('');
  const flatListRef = useRef<FlatList>(null);

  const { send, status } = useWebSocket({
    url: `wss://chat.yourapp.com/room/${roomId}`,
    onMessage: (data) => {
      if (data.type === 'message') {
        addMessage(roomId, data.message);
      }
      if (data.type === 'typing') {
        setTypingUsers(data.users);
      }
    },
  });

  const sendMessage = () => {
    if (!inputText.trim()) return;
    
    const message: Message = {
      id: generateId(),
      content: inputText.trim(),
      senderId: user.id,
      timestamp: new Date().toISOString(),
      status: 'sending',
    };

    // Optimistic update
    addMessage(roomId, message);
    setInputText('');

    send({
      type: 'message',
      content: message.content,
      tempId: message.id,
    });
  };

  const sendTypingIndicator = useDebouncedCallback(() => {
    send({ type: 'typing', isTyping: true });
  }, 500);

  useEffect(() => {
    if (messages.length > 0) {
      flatListRef.current?.scrollToEnd({ animated: true });
    }
  }, [messages.length]);

  const renderMessage = useCallback(({ item, index }) => {
    const isOwnMessage = item.senderId === user.id;
    const showAvatar = !isOwnMessage && 
      (index === 0 || messages[index - 1]?.senderId !== item.senderId);

    return (
      <MessageBubble
        message={item}
        isOwn={isOwnMessage}
        showAvatar={showAvatar}
      />
    );
  }, [user.id, messages]);

  return (
    <KeyboardAvoidingView
      style={{ flex: 1 }}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      keyboardVerticalOffset={Platform.OS === 'ios' ? 88 : 0}
    >
      <FlatList
        ref={flatListRef}
        data={messages}
        renderItem={renderMessage}
        keyExtractor={(item) => item.id}
        contentContainerStyle={{ padding: 16 }}
        inverted={false}
      />
      
      {typingUsers.length > 0 && (
        <TypingIndicator users={typingUsers} />
      )}
      
      <View style={styles.inputBar}>
        <TextInput
          style={styles.input}
          value={inputText}
          onChangeText={(text) => {
            setInputText(text);
            sendTypingIndicator();
          }}
          placeholder="Message..."
          multiline
          maxLength={1000}
          returnKeyType="default"
        />
        <Pressable
          onPress={sendMessage}
          disabled={!inputText.trim() || status !== 'connected'}
          style={[styles.sendButton, !inputText.trim() && styles.disabled]}
        >
          <SendIcon />
        </Pressable>
      </View>
    </KeyboardAvoidingView>
  );
}
```

### 20.3 Use Case: Healthcare Patient Portal

```javascript
// HIPAA-compliant patient portal patterns

// Secure session management
const SESSION_TIMEOUT = 5 * 60 * 1000; // 5 minutes

function useSecureSession() {
  const lastActivity = useRef(Date.now());
  const sessionTimer = useRef<NodeJS.Timeout | null>(null);
  const { logout } = useAuthStore();

  const resetTimer = useCallback(() => {
    lastActivity.current = Date.now();
    if (sessionTimer.current) clearTimeout(sessionTimer.current);
    sessionTimer.current = setTimeout(() => {
      logout();
      Alert.alert(
        'Session Expired',
        'Your session has expired for security. Please log in again.'
      );
    }, SESSION_TIMEOUT);
  }, [logout]);

  useEffect(() => {
    resetTimer();
    return () => {
      if (sessionTimer.current) clearTimeout(sessionTimer.current);
    };
  }, []);

  return { resetTimer };
}

// Medical records with encryption at rest
async function saveMedicalRecord(record: MedicalRecord) {
  const encrypted = await encryptData(JSON.stringify(record));
  await SecureStore.setItemAsync(`record_${record.id}`, encrypted);
}

// Appointment booking flow
function AppointmentBooking() {
  const [step, setStep] = useState<'specialty' | 'doctor' | 'time' | 'confirm'>('specialty');
  const [selection, setSelection] = useState<BookingSelection>({});

  const steps = {
    specialty: <SpecialtySelector onSelect={(specialty) => {
      setSelection(s => ({ ...s, specialty }));
      setStep('doctor');
    }} />,
    doctor: <DoctorList specialty={selection.specialty} onSelect={(doctor) => {
      setSelection(s => ({ ...s, doctor }));
      setStep('time');
    }} />,
    time: <TimeSlotPicker doctor={selection.doctor} onSelect={(slot) => {
      setSelection(s => ({ ...s, slot }));
      setStep('confirm');
    }} />,
    confirm: <BookingConfirmation selection={selection} onConfirm={confirmBooking} />,
  };

  return (
    <View style={{ flex: 1 }}>
      <ProgressBar steps={4} current={['specialty', 'doctor', 'time', 'confirm'].indexOf(step)} />
      {steps[step]}
    </View>
  );
}
```

### 20.4 Use Case: Field Service / Delivery App

```javascript
// Delivery driver app with offline support
function DeliveryDashboard() {
  const { location } = useLocation();
  const [deliveries, setDeliveries] = useState<Delivery[]>([]);
  const isConnected = useNetworkStatus();
  const pendingQueue = useRef<PendingAction[]>([]);

  // Sync when connection restored
  useEffect(() => {
    if (isConnected && pendingQueue.current.length > 0) {
      syncPendingActions();
    }
  }, [isConnected]);

  const markDelivered = async (deliveryId: string, signature: string, photo: string) => {
    const action = {
      type: 'MARK_DELIVERED',
      deliveryId,
      signature,
      photo,
      timestamp: new Date().toISOString(),
      location: location?.coords,
    };

    // Update local state immediately (optimistic)
    setDeliveries(prev => prev.map(d => 
      d.id === deliveryId ? { ...d, status: 'delivered' } : d
    ));

    if (isConnected) {
      await api.markDelivered(action);
    } else {
      // Queue for later sync
      pendingQueue.current.push(action);
      await AsyncStorage.setItem('pendingActions', JSON.stringify(pendingQueue.current));
    }
  };

  const captureSignature = async (deliveryId: string) => {
    // Navigate to signature capture screen
    navigation.navigate('SignatureCapture', {
      onCapture: async (signatureUri) => {
        const photo = await captureDeliveryPhoto();
        await markDelivered(deliveryId, signatureUri, photo);
      },
    });
  };

  return (
    <View style={{ flex: 1 }}>
      {!isConnected && (
        <Banner text="Offline Mode — Changes will sync when connected" type="warning" />
      )}
      
      <MapView
        style={{ height: 300 }}
        region={{
          latitude: location?.coords.latitude ?? 0,
          longitude: location?.coords.longitude ?? 0,
          latitudeDelta: 0.05,
          longitudeDelta: 0.05,
        }}
      >
        {deliveries.map(delivery => (
          <Marker
            key={delivery.id}
            coordinate={delivery.coordinates}
            pinColor={delivery.status === 'pending' ? 'red' : 'green'}
          />
        ))}
        <Marker coordinate={location?.coords} pinColor="blue" title="You" />
      </MapView>

      <FlatList
        data={deliveries.filter(d => d.status === 'pending')}
        renderItem={({ item }) => (
          <DeliveryCard
            delivery={item}
            onNavigate={() => openMapsNavigation(item.address)}
            onCapture={() => captureSignature(item.id)}
          />
        )}
        keyExtractor={(item) => item.id}
      />
    </View>
  );
}
```

---

## 21. Common Pitfalls & How to Avoid Them

### 21.1 The Keyboard Avoiding Problem

```javascript
// ❌ Wrong — keyboard covers input on Android
function LoginForm() {
  return (
    <View style={{ flex: 1 }}>
      <TextInput placeholder="Email" />
      <TextInput placeholder="Password" secureTextEntry />
      <Button title="Login" />
    </View>
  );
}

// ✅ Correct — keyboard avoids content
import { KeyboardAvoidingView, ScrollView, Platform } from 'react-native';

function LoginForm() {
  return (
    <KeyboardAvoidingView
      style={{ flex: 1 }}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <ScrollView
        contentContainerStyle={{ flexGrow: 1, justifyContent: 'center', padding: 20 }}
        keyboardShouldPersistTaps="handled" // Important for nested buttons
      >
        <TextInput placeholder="Email" />
        <TextInput placeholder="Password" secureTextEntry />
        <Button title="Login" />
      </ScrollView>
    </KeyboardAvoidingView>
  );
}
```

### 21.2 Memory Leaks

```javascript
// ❌ Memory leak — setInterval never cleared
useEffect(() => {
  setInterval(() => {
    fetchData();
  }, 5000);
}, []);

// ✅ Correct — cleanup on unmount
useEffect(() => {
  const interval = setInterval(fetchData, 5000);
  return () => clearInterval(interval);
}, [fetchData]);

// ❌ Memory leak — async function sets state after unmount
useEffect(() => {
  fetchUser().then(user => setUser(user)); // Might set state after unmount
}, []);

// ✅ Correct — check if still mounted
useEffect(() => {
  let isMounted = true;
  
  fetchUser().then(user => {
    if (isMounted) setUser(user);
  });
  
  return () => { isMounted = false; };
}, []);

// ✅ Better — use AbortController
useEffect(() => {
  const controller = new AbortController();
  
  fetch('/api/user', { signal: controller.signal })
    .then(res => res.json())
    .then(user => setUser(user))
    .catch(err => {
      if (err.name !== 'AbortError') console.error(err);
    });
  
  return () => controller.abort();
}, []);
```

### 21.3 FlatList Performance Mistakes

```javascript
// ❌ Wrong — inline functions create new references every render
<FlatList
  data={items}
  renderItem={({ item }) => <ItemComponent item={item} />} // New function each render
  keyExtractor={(item) => item.id} // New function each render
/>

// ✅ Correct — stable references
const renderItem = useCallback(({ item }) => <ItemComponent item={item} />, []);
const keyExtractor = useCallback((item) => item.id, []);

<FlatList
  data={items}
  renderItem={renderItem}
  keyExtractor={keyExtractor}
/>

// ❌ Wrong — mutating state directly
const addItem = () => {
  items.push(newItem); // Direct mutation
  setItems(items); // React won't detect this change
};

// ✅ Correct — immutable update
const addItem = () => {
  setItems(prev => [...prev, newItem]);
};
```

### 21.4 SafeAreaView Misuse

```javascript
// ❌ Wrong — content bleeds into status bar/notch
function Screen() {
  return (
    <View style={{ flex: 1 }}>
      <Header />
      <Content />
    </View>
  );
}

// ✅ Correct — respect safe areas
import { SafeAreaView } from 'react-native-safe-area-context';

function Screen() {
  return (
    <SafeAreaView style={{ flex: 1 }} edges={['top', 'bottom']}>
      <Header />
      <Content />
    </SafeAreaView>
  );
}

// For screens in navigation stacks — use useSafeAreaInsets for more control
import { useSafeAreaInsets } from 'react-native-safe-area-context';

function CustomHeader() {
  const insets = useSafeAreaInsets();
  
  return (
    <View style={{ paddingTop: insets.top, backgroundColor: '#007AFF' }}>
      <Text style={{ color: '#fff', padding: 16 }}>My Header</Text>
    </View>
  );
}
```

### 21.5 useEffect Dependency Mistakes

```javascript
// ❌ Missing dependency — stale closure
const [count, setCount] = useState(0);

useEffect(() => {
  const timer = setInterval(() => {
    setCount(count + 1); // Always uses initial count value (0)
  }, 1000);
  return () => clearInterval(timer);
}, []); // Missing 'count' dependency

// ✅ Correct — use functional update
useEffect(() => {
  const timer = setInterval(() => {
    setCount(prev => prev + 1); // No dependency on external count
  }, 1000);
  return () => clearInterval(timer);
}, []);

// ❌ Infinite loop — object dependency
const options = { limit: 10, offset: 0 }; // New object every render
useEffect(() => {
  fetchData(options);
}, [options]); // Triggers every render

// ✅ Correct — primitive dependencies or useMemo
const { limit, offset } = options;
useEffect(() => {
  fetchData({ limit, offset });
}, [limit, offset]);
```

### 21.6 Async useEffect Mistakes

```javascript
// ❌ Wrong — async function directly in useEffect
useEffect(async () => { // useEffect callback should not return a Promise
  const data = await fetchData();
  setData(data);
}, []);

// ✅ Correct — define async function inside
useEffect(() => {
  const loadData = async () => {
    const data = await fetchData();
    setData(data);
  };
  
  loadData();
}, []);
```

---

## 22. Ecosystem & Library Recommendations

### 22.1 Essential Libraries

| Category | Recommended Library | Notes |
|---|---|---|
| Navigation | `@react-navigation/native` + Expo Router | Expo Router for new projects |
| State (Server) | `@tanstack/react-query` | Best-in-class server state |
| State (Client) | `zustand` | Simple, powerful |
| HTTP | `axios` | Interceptors, cancellation |
| Images | `expo-image` | Best performance |
| Icons | `@expo/vector-icons` | Ionicons, Material, FontAwesome |
| Forms | `react-hook-form` + `zod` | Validation + TypeScript |
| Gestures | `react-native-gesture-handler` | Required for React Nav |
| Animations | `react-native-reanimated` | Runs on UI thread |
| Maps | `react-native-maps` | iOS + Android |
| Storage | `expo-secure-store` + `@react-native-async-storage/async-storage` | Sensitive + non-sensitive |
| Date | `date-fns` | Lightweight, tree-shakeable |
| Error Tracking | `@sentry/react-native` | Industry standard |
| Analytics | `@react-native-firebase/analytics` | Comprehensive |
| Lists | `@shopify/flash-list` | Faster than FlatList |
| Bottom Sheet | `@gorhom/bottom-sheet` | Smooth, feature-rich |
| Toast/Snackbar | `react-native-toast-message` | Customizable |

### 22.2 Libraries to Avoid

| Library | Why to Avoid | Alternative |
|---|---|---|
| `react-native-vector-icons` | Complex setup | `@expo/vector-icons` |
| `react-native-camera` (old) | Deprecated | `expo-camera` |
| `react-native-image-picker` | More complex | `expo-image-picker` |
| `moment.js` | 65KB, not tree-shaken | `date-fns` or `dayjs` |
| `react-native-linear-gradient` bare | Requires native setup | `expo-linear-gradient` |
| `styled-components` in RN | Performance issues | Themes + StyleSheet |
| `react-native-maps` without proper key | Google Maps billing | Set API key from day 1 |

---

## 23. Migration Patterns

### 23.1 Migrating from Class Components to Hooks

```javascript
// ❌ Old: Class Component
class ProductDetailScreen extends React.Component {
  state = { product: null, loading: true, error: null };

  async componentDidMount() {
    try {
      const product = await api.getProduct(this.props.route.params.productId);
      this.setState({ product, loading: false });
    } catch (error) {
      this.setState({ error, loading: false });
    }
  }

  componentWillUnmount() {
    this.subscription?.remove();
  }

  render() {
    if (this.state.loading) return <ActivityIndicator />;
    if (this.state.error) return <ErrorView error={this.state.error} />;
    return <ProductView product={this.state.product} />;
  }
}

// ✅ New: Functional Component with Hooks
function ProductDetailScreen() {
  const { productId } = useRoute<RouteProp<RootStackParamList, 'ProductDetail'>>().params;
  
  const { data: product, isLoading, error } = useQuery({
    queryKey: ['product', productId],
    queryFn: () => api.getProduct(productId),
  });

  if (isLoading) return <ActivityIndicator />;
  if (error) return <ErrorView error={error} />;
  return <ProductView product={product} />;
}
```

### 23.2 Migrating from Redux to Zustand

```javascript
// Old Redux action + reducer
const fetchProducts = () => async (dispatch) => {
  dispatch({ type: 'FETCH_PRODUCTS_START' });
  try {
    const products = await api.getProducts();
    dispatch({ type: 'FETCH_PRODUCTS_SUCCESS', payload: products });
  } catch (error) {
    dispatch({ type: 'FETCH_PRODUCTS_FAILURE', error: error.message });
  }
};

// New Zustand store
const useProductStore = create((set) => ({
  products: [],
  loading: false,
  error: null,
  
  fetchProducts: async () => {
    set({ loading: true, error: null });
    try {
      const products = await api.getProducts();
      set({ products, loading: false });
    } catch (error) {
      set({ error: error.message, loading: false });
    }
  },
}));
```

---

## 24. Accessibility

### 24.1 Core Accessibility Props

```javascript
import { AccessibilityInfo, View, Text, Pressable } from 'react-native';

// ✅ Full accessibility implementation
function AccessibleCard({ title, description, onPress, imageUrl }) {
  return (
    <Pressable
      onPress={onPress}
      accessible={true}
      accessibilityRole="button"
      accessibilityLabel={`${title}. ${description}`}
      accessibilityHint="Double tap to view details"
      accessibilityState={{ disabled: false }}
    >
      <Image
        source={{ uri: imageUrl }}
        accessibilityLabel={`Image of ${title}`}
        accessibilityRole="image"
      />
      <Text
        style={styles.title}
        accessibilityRole="header"
        accessibilityLevel={2}
      >
        {title}
      </Text>
      <Text>{description}</Text>
    </Pressable>
  );
}

// Screen reader announcements
async function announceForScreenReader(message: string) {
  await AccessibilityInfo.announceForAccessibility(message);
}

// Detect if screen reader is active
const [isScreenReaderEnabled, setIsScreenReaderEnabled] = useState(false);

useEffect(() => {
  AccessibilityInfo.isScreenReaderEnabled().then(setIsScreenReaderEnabled);
  
  const subscription = AccessibilityInfo.addEventListener(
    'screenReaderChanged',
    setIsScreenReaderEnabled
  );
  
  return () => subscription.remove();
}, []);

// Focus management
import { findNodeHandle } from 'react-native';

function AccessibleModal({ visible, title, children, onClose }) {
  const titleRef = useRef(null);

  useEffect(() => {
    if (visible) {
      // Move screen reader focus to modal title
      const node = findNodeHandle(titleRef.current);
      if (node) AccessibilityInfo.setAccessibilityFocus(node);
    }
  }, [visible]);

  return (
    <Modal visible={visible} onRequestClose={onClose}>
      <Text ref={titleRef} accessibilityRole="header">{title}</Text>
      {children}
    </Modal>
  );
}
```

### 24.2 Dynamic Type (Font Scaling)

```javascript
import { useWindowDimensions } from 'react-native';

function AccessibleText({ style, ...props }) {
  const { fontScale } = useWindowDimensions();
  
  return (
    <Text
      style={[
        style,
        // Allow up to 2x font scale, then cap it
        { fontSize: Math.min(style.fontSize * fontScale, style.fontSize * 2) },
      ]}
      allowFontScaling={true}
      maxFontSizeMultiplier={2}
      {...props}
    />
  );
}
```

---

## 25. Internationalization & Localization

### 25.1 i18n Setup with i18next

```bash
npm install i18next react-i18next @react-native-async-storage/async-storage
```

```javascript
// i18n/index.ts
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import * as Localization from 'expo-localization';

const resources = {
  en: {
    translation: {
      welcome: 'Welcome, {{name}}!',
      cart: {
        title: 'Shopping Cart',
        empty: 'Your cart is empty',
        items_one: '{{count}} item',
        items_other: '{{count}} items',
        total: 'Total: {{amount}}',
      },
      errors: {
        network: 'Network error. Please try again.',
        unknown: 'Something went wrong.',
      },
    },
  },
  tr: {
    translation: {
      welcome: 'Hoş geldin, {{name}}!',
      cart: {
        title: 'Alışveriş Sepeti',
        empty: 'Sepetiniz boş',
        items_one: '{{count}} ürün',
        items_other: '{{count}} ürün',
        total: 'Toplam: {{amount}}',
      },
    },
  },
};

i18n
  .use(initReactI18next)
  .init({
    resources,
    lng: Localization.locale.split('-')[0], // 'en-US' → 'en'
    fallbackLng: 'en',
    interpolation: { escapeValue: false },
  });

export default i18n;

// Usage
import { useTranslation } from 'react-i18next';

function CartScreen() {
  const { t } = useTranslation();
  const itemCount = useCartStore(state => state.items.length);

  return (
    <View>
      <Text>{t('cart.title')}</Text>
      <Text>{t('cart.items', { count: itemCount })}</Text>
      {itemCount === 0 && <Text>{t('cart.empty')}</Text>}
    </View>
  );
}
```

### 25.2 Number and Date Formatting

```javascript
// Locale-aware formatting
const { locale } = Localization;

// Numbers
const formatCurrency = (amount: number, currency = 'USD') => {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency,
  }).format(amount);
};

// Dates
const formatDate = (date: Date, format: 'short' | 'long' = 'short') => {
  return new Intl.DateTimeFormat(locale, {
    dateStyle: format,
    timeStyle: 'short',
  }).format(date);
};

// RTL support
import { I18nManager } from 'react-native';

const isRTL = I18nManager.isRTL;

const styles = StyleSheet.create({
  text: {
    textAlign: isRTL ? 'right' : 'left',
    writingDirection: isRTL ? 'rtl' : 'ltr',
  },
  row: {
    flexDirection: isRTL ? 'row-reverse' : 'row',
  },
});
```

---

## 26. Offline-First Architecture

### 26.1 Network Status Detection

```javascript
import NetInfo from '@react-native-community/netinfo';
import { useEffect, useState, useCallback } from 'react';

export function useNetworkStatus() {
  const [isConnected, setIsConnected] = useState<boolean | null>(null);
  const [connectionType, setConnectionType] = useState<string | null>(null);

  useEffect(() => {
    // Check initial state
    NetInfo.fetch().then(state => {
      setIsConnected(state.isConnected);
      setConnectionType(state.type);
    });

    // Subscribe to changes
    const unsubscribe = NetInfo.addEventListener(state => {
      setIsConnected(state.isConnected);
      setConnectionType(state.type);
    });

    return unsubscribe;
  }, []);

  return { isConnected, connectionType, isWifi: connectionType === 'wifi' };
}
```

### 26.2 Optimistic Updates with Sync Queue

```javascript
// Offline queue manager
class OfflineQueue {
  private queue: QueuedAction[] = [];
  private isProcessing = false;

  async enqueue(action: QueuedAction) {
    this.queue.push(action);
    await this.persist();
    
    if (NetInfo.isConnected) {
      await this.process();
    }
  }

  async process() {
    if (this.isProcessing || this.queue.length === 0) return;
    
    this.isProcessing = true;
    
    while (this.queue.length > 0) {
      const action = this.queue[0];
      
      try {
        await this.executeAction(action);
        this.queue.shift();
        await this.persist();
      } catch (error) {
        if (this.isRetryable(error)) {
          await sleep(2000);
        } else {
          this.queue.shift(); // Skip non-retryable errors
        }
        break;
      }
    }
    
    this.isProcessing = false;
  }

  private async persist() {
    await AsyncStorage.setItem('offlineQueue', JSON.stringify(this.queue));
  }

  private async executeAction(action: QueuedAction) {
    switch (action.type) {
      case 'CREATE_POST':
        return api.createPost(action.payload);
      case 'MARK_DELIVERED':
        return api.markDelivered(action.payload);
      default:
        throw new Error(`Unknown action type: ${action.type}`);
    }
  }
}

export const offlineQueue = new OfflineQueue();
```

---

## 27. Deep Linking & Universal Links

### 27.1 Configuration

```javascript
// app.config.js
export default {
  // ...
  ios: {
    associatedDomains: ['applinks:yourapp.com'],
  },
  android: {
    intentFilters: [{
      action: 'VIEW',
      autoVerify: true,
      data: [{
        scheme: 'https',
        host: 'yourapp.com',
        pathPrefix: '/app',
      }],
      category: ['BROWSABLE', 'DEFAULT'],
    }],
  },
};

// Linking configuration for React Navigation
const linking: LinkingOptions<RootStackParamList> = {
  prefixes: ['yourapp://', 'https://yourapp.com'],
  config: {
    screens: {
      Main: {
        screens: {
          Home: 'home',
          Profile: 'profile/:userId',
        },
      },
      ProductDetail: 'product/:productId',
      Checkout: 'checkout',
    },
  },
  // Custom URL parsing
  getStateFromPath: (path, config) => {
    const state = getStateFromPath(path, config);
    // Custom logic here
    return state;
  },
};

// Handle incoming links
useEffect(() => {
  const subscription = Linking.addEventListener('url', ({ url }) => {
    console.log('Incoming URL:', url);
  });

  return () => subscription.remove();
}, []);
```

---

## 28. Push Notifications

### 28.1 Complete Push Notification Setup

```javascript
// Full push notification implementation
// hooks/usePushNotifications.ts

export function usePushNotifications() {
  const [expoPushToken, setExpoPushToken] = useState<string | null>(null);
  const notificationListener = useRef<Subscription>();
  const responseListener = useRef<Subscription>();

  useEffect(() => {
    registerForPushNotifications().then(token => {
      setExpoPushToken(token);
    });

    // Notification received while app is in foreground
    notificationListener.current = Notifications.addNotificationReceivedListener(notification => {
      handleForegroundNotification(notification);
    });

    // User tapped on notification
    responseListener.current = Notifications.addNotificationResponseReceivedListener(response => {
      handleNotificationResponse(response);
    });

    return () => {
      notificationListener.current && Notifications.removeNotificationSubscription(notificationListener.current);
      responseListener.current && Notifications.removeNotificationSubscription(responseListener.current);
    };
  }, []);

  return expoPushToken;
}

// Sending push from server (Node.js)
const { Expo } = require('expo-server-sdk');
const expo = new Expo();

async function sendPushNotification(pushToken: string, title: string, body: string, data?: object) {
  if (!Expo.isExpoPushToken(pushToken)) {
    console.error(`Invalid token: ${pushToken}`);
    return;
  }

  const message = {
    to: pushToken,
    sound: 'default',
    title,
    body,
    data: data ?? {},
    badge: 1,
    priority: 'high',
    channelId: 'default', // Android notification channel
  };

  try {
    const ticket = await expo.sendPushNotificationsAsync([message]);
    return ticket;
  } catch (error) {
    console.error('Push notification error:', error);
  }
}
```

---

## 29. App Store Submission Checklist

### 29.1 Pre-Submission Checklist

**General:**
- [ ] App icon provided in all required sizes (1024x1024 source)
- [ ] Splash screen looks correct on all screen sizes
- [ ] App version and build number incremented
- [ ] Privacy policy URL configured in app.json
- [ ] App description, screenshots, and metadata prepared
- [ ] App works without internet connection (graceful degradation)
- [ ] All console.log calls removed or guarded by `__DEV__`

**iOS Specific:**
- [ ] All permission usage descriptions added to Info.plist (NSCameraUsageDescription, etc.)
- [ ] App tested on iPhone and iPad (if supporting tablet)
- [ ] Dark mode tested
- [ ] Dynamic Type tested (accessibility)
- [ ] App Store screenshot dimensions correct
- [ ] TestFlight build shared with testers

**Android Specific:**
- [ ] All required permissions declared in AndroidManifest.xml
- [ ] App tested on various Android API levels (21+)
- [ ] App Bundle (.aab) generated, not APK
- [ ] keystore file backed up securely
- [ ] Google Play target API level meets current requirements (33+)
- [ ] 64-bit libraries included

**Security:**
- [ ] API keys not hardcoded in source code
- [ ] Certificate pinning implemented for sensitive APIs
- [ ] Sensitive data stored in SecureStore, not AsyncStorage
- [ ] Network calls use HTTPS only
- [ ] User data collected per privacy policy

**Performance:**
- [ ] App launches in under 3 seconds on a mid-range device
- [ ] Scrolling is smooth at 60fps
- [ ] Large lists are virtualized (FlatList/FlashList)
- [ ] Images are optimized and cached
- [ ] No memory leaks (tested with Xcode Instruments / Android Profiler)

### 29.2 EAS Submit

```bash
# Submit to both stores simultaneously
eas submit --platform all --profile production

# iOS only
eas submit --platform ios

# Android only
eas submit --platform android
```

---

## 30. Interview Questions & Conceptual Summary

### 30.1 Common Interview Questions

**Q: What is the difference between React Native and Expo?**
A: React Native is the framework for building mobile apps with JavaScript and React. Expo is a platform built on top of React Native that provides additional tools, a managed SDK, and services (EAS Build, EAS Update). You can use React Native without Expo, but Expo always uses React Native.

**Q: How does React Native communicate with native code?**
A: In the legacy architecture, through the asynchronous Bridge that serializes messages to JSON. In the New Architecture (JSI), through a synchronous C++ interface that allows JavaScript to hold direct references to native objects, eliminating serialization overhead.

**Q: What is the difference between `useCallback` and `useMemo`?**
A: `useCallback` memoizes a function reference. `useMemo` memoizes a computed value. Both accept a dependency array and only recompute when dependencies change. Use `useCallback` for event handlers passed to child components; use `useMemo` for expensive calculations.

**Q: Why should you not use ScrollView for long lists?**
A: ScrollView renders all its children at once, causing high memory usage and poor performance for lists with many items. FlatList (and FlashList) use virtualization — only rendering items that are visible on screen.

**Q: What is Hermes and why should you use it?**
A: Hermes is a JavaScript engine optimized for React Native. It compiles JavaScript to bytecode at build time, reducing startup time, and has a lower memory footprint than V8/JavaScriptCore for React Native use cases.

**Q: How do you handle authentication token refresh?**
A: Using Axios interceptors: intercept 401 responses, attempt a token refresh, and retry the original request. If refresh fails, log the user out and redirect to the login screen.

**Q: Explain the difference between `useEffect` and `useFocusEffect`.**
A: `useEffect` runs after mount and on dependency changes. `useFocusEffect` (from React Navigation) runs when the screen comes into focus and cleans up when it loses focus — important for analytics tracking, data refreshing, and timer management in tabbed/stacked navigation.

**Q: What are TurboModules and how do they differ from Native Modules?**
A: TurboModules are the New Architecture replacement for Native Modules. They use JSI for direct communication (no bridge serialization), are lazily initialized (reducing startup time), support synchronous calls, and are type-safe via Codegen.

**Q: How do you implement offline support in React Native?**
A: Use `@react-native-community/netinfo` to detect connectivity. Cache data in AsyncStorage or SQLite (WatermelonDB). Use an offline queue to collect actions taken while offline and replay them when connectivity is restored. React Query's `persistQueryClient` can automatically cache server state.

**Q: What is `useNativeDriver: true` and when can't you use it?**
A: It moves animation computation to the native thread, avoiding the JS-native bridge and enabling 60fps animations even if the JavaScript thread is busy. You cannot use it with properties that require JS-side computation on each frame, such as width, height, top, left, or backgroundColor changes that affect layout.

---

## Appendix A: Quick Reference — Expo SDK Modules

| Module | Import | Purpose |
|---|---|---|
| Camera | `expo-camera` | Photo, video, barcode scanning |
| Image Picker | `expo-image-picker` | Gallery, camera selection |
| Image | `expo-image` | Optimized image rendering |
| Location | `expo-location` | GPS, geocoding |
| Notifications | `expo-notifications` | Push + local notifications |
| Secure Store | `expo-secure-store` | Encrypted key-value storage |
| File System | `expo-file-system` | File I/O |
| Audio | `expo-av` | Audio playback/recording |
| Video | `expo-av` | Video playback |
| Haptics | `expo-haptics` | Vibration feedback |
| Sensors | `expo-sensors` | Accelerometer, gyroscope |
| Barcode | `expo-barcode-scanner` | QR, barcodes |
| Face Detector | `expo-face-detector` | ML face detection |
| Font | `expo-font` | Custom font loading |
| Splash Screen | `expo-splash-screen` | Control splash display |
| Updates | `expo-updates` | OTA update management |
| Constants | `expo-constants` | Device, app constants |
| Device | `expo-device` | Device information |
| Battery | `expo-battery` | Battery status |
| Brightness | `expo-brightness` | Screen brightness |
| Clipboard | `expo-clipboard` | Copy/paste |
| Sharing | `expo-sharing` | Share files/content |
| Mail | `expo-mail-composer` | Email composition |
| SMS | `expo-sms` | SMS sending |
| Calendar | `expo-calendar` | Calendar access |
| Contacts | `expo-contacts` | Contacts access |
| MediaLibrary | `expo-media-library` | Photos/videos library |
| LocalAuth | `expo-local-authentication` | FaceID/TouchID |
| Crypto | `expo-crypto` | Cryptographic operations |
| StoreReview | `expo-store-review` | App review prompts |
| WebBrowser | `expo-web-browser` | In-app browser |
| Linking | `expo-linking` | Deep links, URLs |
| Network | `expo-network` | Network state |
| GLView | `expo-gl` | WebGL/OpenGL rendering |
| AR | `expo-three` | 3D/AR with Three.js |

---

## Appendix B: Performance Benchmarks

| Operation | Target | Warning Level |
|---|---|---|
| App cold start | < 2 seconds | > 4 seconds |
| Screen transition | < 300ms | > 500ms |
| List scroll | 60fps | < 45fps |
| Image load (cached) | < 100ms | > 500ms |
| API response (UI update) | < 200ms | > 1000ms |
| JS bundle size | < 3MB | > 8MB |
| Memory usage | < 150MB | > 300MB |
| App install size | < 30MB | > 80MB |

---

## Appendix C: Debugging Tools

```bash
# Flipper (native debugging)
# Enable in metro config and install Flipper desktop app

# React Native Debugger (standalone)
# brew install react-native-debugger
open "rndebugger://set-debugger-loc?host=localhost&port=8081"

# Chrome DevTools (for Hermes)
# Enable "Debug JS Remotely" in dev menu

# Expo specific
npx expo start --dev-client
# Press 'm' for menu, 'r' to reload, 'j' for debugger

# Profile JS performance
npx react-native --cpuprofile

# Profile Android
adb shell am profile start com.yourapp /sdcard/cpu.trace

# Analyze bundle
npx expo export --dump-sourcemap
npx source-map-explorer dist/bundle.js dist/bundle.js.map
```

---

*This guide covers React Native 0.73+ and Expo SDK 50+. Mobile development evolves rapidly — always consult the official React Native and Expo documentation for the most current APIs and best practices.*

*For deep-dive topics not covered here:*
- *React Native New Architecture: https://reactnative.dev/docs/the-new-architecture/landing-page*
- *Expo Documentation: https://docs.expo.dev*
- *React Navigation: https://reactnavigation.org*
- *Expo Router: https://expo.github.io/router*
- *TanStack Query: https://tanstack.com/query*
