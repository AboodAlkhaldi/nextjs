#!/bin/bash

# =============================================================================
# COMPREHENSIVE GUIDE: C# PROGRAMMING LANGUAGE & .NET FRAMEWORK / PLATFORM
# =============================================================================
# File Type    : Shell Script (.sh) — purely educational, fully commented
# Purpose      : A complete reference guide covering C# and .NET from ground up
# Audience     : Beginners, intermediate developers, and those switching stacks
# Last Updated : 2025
# =============================================================================
# HOW TO USE THIS FILE:
#   - Every line starting with '#' is a comment — it is NOT executed
#   - This file is a knowledge document disguised as a shell script
#   - You can read it in any text editor, terminal, or IDE
#   - To view it in terminal: cat csharp_dotnet_guide.sh | less
# =============================================================================

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                         TABLE OF CONTENTS                                ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# PART 1  — HISTORY & ORIGINS
#   1.1  Who Created C# and Why
#   1.2  Timeline of C# Versions
#   1.3  Timeline of .NET Versions
#   1.4  The Naming Confusion: .NET Framework vs .NET Core vs .NET 5+

# PART 2  — WHAT IS C#?
#   2.1  Language Definition and Core Identity
#   2.2  Key Characteristics
#   2.3  C# vs Other Languages (Java, C++, Python, JavaScript)
#   2.4  What C# Is NOT

# PART 3  — WHAT IS .NET?
#   3.1  .NET as a Platform — Definition
#   3.2  CLR (Common Language Runtime)
#   3.3  BCL (Base Class Library)
#   3.4  CIL / MSIL (Intermediate Language)
#   3.5  JIT Compilation
#   3.6  AOT Compilation (Ahead of Time)
#   3.7  The Ecosystem: NuGet, MSBuild, SDK

# PART 4  — SETTING UP THE ENVIRONMENT
#   4.1  Installing .NET SDK
#   4.2  IDEs: Visual Studio, VS Code, Rider
#   4.3  Your First Project: Hello World
#   4.4  Project Structure Explained
#   4.5  .csproj File Deep Dive

# PART 5  — C# LANGUAGE FUNDAMENTALS
#   5.1  Data Types (Value vs Reference)
#   5.2  Variables, Constants, and Literals
#   5.3  Operators
#   5.4  Control Flow (if, switch, loops)
#   5.5  Methods and Parameters
#   5.6  Arrays and Collections
#   5.7  Strings and String Manipulation
#   5.8  Nullable Types
#   5.9  Type Casting and Conversion

# PART 6  — OBJECT-ORIENTED PROGRAMMING IN C#
#   6.1  Classes and Objects
#   6.2  Constructors
#   6.3  Properties and Fields
#   6.4  Encapsulation
#   6.5  Inheritance
#   6.6  Polymorphism
#   6.7  Abstraction and Abstract Classes
#   6.8  Interfaces
#   6.9  Static Classes and Members
#   6.10 Sealed Classes
#   6.11 Partial Classes
#   6.12 Records (C# 9+)

# PART 7  — ADVANCED C# FEATURES
#   7.1  Generics
#   7.2  Delegates and Events
#   7.3  Lambda Expressions
#   7.4  LINQ (Language Integrated Query)
#   7.5  Extension Methods
#   7.6  Anonymous Types
#   7.7  Dynamic Types
#   7.8  Tuples
#   7.9  Pattern Matching
#   7.10 Iterators and yield
#   7.11 Indexers
#   7.12 Operator Overloading

# PART 8  — ASYNC PROGRAMMING
#   8.1  Why Async Matters
#   8.2  async / await Keywords
#   8.3  Task and Task<T>
#   8.4  ValueTask
#   8.5  Cancellation Tokens
#   8.6  Parallel Programming (TPL)
#   8.7  Common Async Pitfalls

# PART 9  — MEMORY MANAGEMENT & PERFORMANCE
#   9.1  Garbage Collector (GC) — How It Works
#   9.2  Generations (Gen 0, 1, 2)
#   9.3  IDisposable and using Statement
#   9.4  Finalizers
#   9.5  Span<T> and Memory<T>
#   9.6  Unsafe Code and Pointers
#   9.7  Structs vs Classes for Performance
#   9.8  Boxing and Unboxing

# PART 10 — ERROR HANDLING
#   10.1 try / catch / finally
#   10.2 Exception Hierarchy
#   10.3 Custom Exceptions
#   10.4 When NOT to Use Exceptions
#   10.5 Result Pattern as Alternative

# PART 11 — .NET APPLICATION TYPES & USE CASES
#   11.1 Console Applications
#   11.2 ASP.NET Core — Web APIs
#   11.3 ASP.NET Core — MVC Web Apps
#   11.4 Blazor — WebAssembly & Server
#   11.5 WPF — Desktop (Windows)
#   11.6 WinForms — Legacy Desktop
#   11.7 MAUI — Cross-Platform Mobile & Desktop
#   11.8 Worker Services & Background Services
#   11.9 Azure Functions & Serverless
#   11.10 Unity Game Development
#   11.11 ML.NET — Machine Learning

# PART 12 — DATA ACCESS
#   12.1 ADO.NET (Raw Database Access)
#   12.2 Entity Framework Core (ORM)
#   12.3 Dapper (Micro ORM)
#   12.4 Repository Pattern
#   12.5 Working with JSON (System.Text.Json)
#   12.6 Working with XML

# PART 13 — DEPENDENCY INJECTION & ARCHITECTURE
#   13.1 What is DI and Why Use It
#   13.2 Built-in DI in .NET
#   13.3 Service Lifetimes (Singleton, Scoped, Transient)
#   13.4 Common Architecture Patterns
#   13.5 Clean Architecture in .NET
#   13.6 CQRS and MediatR

# PART 14 — TESTING
#   14.1 Unit Testing with xUnit / NUnit / MSTest
#   14.2 Mocking with Moq
#   14.3 Integration Testing
#   14.4 Test Driven Development (TDD)

# PART 15 — SECURITY
#   15.1 Authentication and Authorization in ASP.NET Core
#   15.2 JWT Tokens
#   15.3 HTTPS and Certificates
#   15.4 Input Validation and SQL Injection Prevention
#   15.5 Secret Management

# PART 16 — DEPLOYMENT & DEVOPS
#   16.1 Publishing .NET Apps
#   16.2 Docker and Containers
#   16.3 CI/CD with GitHub Actions
#   16.4 Azure Deployment
#   16.5 Self-Contained vs Framework-Dependent Deployment

# PART 17 — PROS AND CONS
#   17.1 Pros of C#
#   17.2 Cons of C#
#   17.3 Pros of .NET
#   17.4 Cons of .NET
#   17.5 When to Choose C# / .NET Over Alternatives

# PART 18 — WHAT NOT TO DO (ANTI-PATTERNS & COMMON MISTAKES)
#   18.1 C# Anti-Patterns
#   18.2 .NET Anti-Patterns
#   18.3 Beginner Mistakes

# PART 19 — CAREER & ECOSYSTEM
#   19.1 Job Market for C# Developers
#   19.2 Learning Path
#   19.3 Important Libraries to Know
#   19.4 Community Resources

# =============================================================================
# PART 1 — HISTORY & ORIGINS
# =============================================================================

# -----------------------------------------------------------------------------
# 1.1  WHO CREATED C# AND WHY
# -----------------------------------------------------------------------------

# C# (pronounced "C Sharp") was created by Microsoft.
# The primary architect was Anders Hejlsberg, who had previously designed
# Turbo Pascal and was the lead architect of Delphi.

# WHY was C# created?
#   - Microsoft needed a modern language for their new .NET platform (announced 2000)
#   - Java was popular but Sun Microsystems (now Oracle) owned it
#   - Microsoft had a falling-out with Sun over J++ (their Java variant)
#   - They needed full control over the language tied to Windows and .NET
#   - They wanted a language that combined the power of C++ with the simplicity of Java
#   - C# was designed to be "better Java" — learning from Java's mistakes

# C# was first announced in 2000 at PDC (Professional Developers Conference)
# C# 1.0 shipped with .NET Framework 1.0 in February 2002

# -----------------------------------------------------------------------------
# 1.2  TIMELINE OF C# VERSIONS
# -----------------------------------------------------------------------------

# C# 1.0  (2002) — Classes, structs, interfaces, delegates, generics (partial), exceptions
# C# 1.2  (2003) — Minor updates, foreach on IDisposable

# C# 2.0  (2005) — MAJOR RELEASE
#   - Generics (full support)
#   - Nullable types (int?)
#   - Anonymous methods
#   - Iterators (yield return)
#   - Partial classes
#   - Static classes

# C# 3.0  (2007) — MAJOR RELEASE (LINQ era)
#   - LINQ (Language Integrated Query) — revolutionary feature
#   - Lambda expressions (x => x * 2)
#   - Extension methods
#   - Anonymous types
#   - var keyword (type inference)
#   - Object and collection initializers
#   - Auto-implemented properties

# C# 4.0  (2010)
#   - Dynamic binding (dynamic keyword)
#   - Named and optional parameters
#   - Generic covariance and contravariance

# C# 5.0  (2012) — ASYNC ERA
#   - async and await keywords (game changer for async programming)
#   - Caller info attributes

# C# 6.0  (2015)
#   - Null-conditional operator (?.)
#   - String interpolation ($"Hello {name}")
#   - Expression-bodied members
#   - nameof operator
#   - Dictionary initializers

# C# 7.0  (2017)
#   - Tuples (named tuples)
#   - Pattern matching (is keyword enhanced)
#   - Local functions
#   - Out variables inline declaration
#   - Deconstruction

# C# 7.1, 7.2, 7.3 — Minor: async Main, default literals, Span<T>

# C# 8.0  (2019)
#   - Nullable reference types (opt-in null safety)
#   - Switch expressions
#   - Ranges and indices (^1, 1..4)
#   - Async streams (IAsyncEnumerable)
#   - Interface default implementations

# C# 9.0  (2020)
#   - Records (immutable reference types)
#   - Init-only setters
#   - Top-level statements (no class/Main boilerplate)
#   - Pattern matching improvements
#   - with expression for records

# C# 10.0 (2021)
#   - Global using directives
#   - File-scoped namespaces
#   - Record structs
#   - Constant interpolated strings

# C# 11.0 (2022)
#   - Raw string literals
#   - Generic attributes
#   - Required members
#   - List patterns

# C# 12.0 (2023)
#   - Primary constructors for all classes
#   - Collection expressions ([1, 2, 3])
#   - Inline arrays
#   - Default lambda parameters

# C# 13.0 (2024)
#   - params collections
#   - New lock type
#   - Implicit indexer access in object initializers

# -----------------------------------------------------------------------------
# 1.3  TIMELINE OF .NET VERSIONS
# -----------------------------------------------------------------------------

# .NET Framework (Windows only):
#   1.0  — 2002 (first release)
#   1.1  — 2003
#   2.0  — 2005 (Generics support in runtime)
#   3.0  — 2006 (WPF, WCF, WF, CardSpace added)
#   3.5  — 2007 (LINQ, Ajax extensions)
#   4.0  — 2010 (DLR, TPL, MEF)
#   4.5  — 2012 (async/await, HTTP client)
#   4.6  — 2015 (JIT improvements, TLS 1.2)
#   4.7  — 2017
#   4.8  — 2019 (FINAL version of .NET Framework — now in maintenance only)

# .NET Core (cross-platform, new era):
#   Core 1.0 — 2016 (first cross-platform .NET)
#   Core 1.1 — 2016
#   Core 2.0 — 2017 (huge BCL compatibility expansion)
#   Core 2.1 — 2018 (LTS — Long Term Support)
#   Core 2.2 — 2018
#   Core 3.0 — 2019 (WPF & WinForms on Core, Worker Services)
#   Core 3.1 — 2019 (LTS)

# .NET 5+ (unified platform — "Core" dropped from name):
#   .NET 5  — 2020 (unified .NET Framework + Core into one)
#   .NET 6  — 2021 (LTS — MAUI preview, minimal APIs)
#   .NET 7  — 2022 (performance, rate limiting, gRPC)
#   .NET 8  — 2023 (LTS — Native AOT, Blazor improvements)
#   .NET 9  — 2024 (performance, AI integrations)
#   .NET 10 — 2025 (LTS — in development)

# KEY RULE: New LTS versions every 2 years (.NET 6, 8, 10...)
# Non-LTS versions get 18 months of support only

# -----------------------------------------------------------------------------
# 1.4  THE NAMING CONFUSION EXPLAINED
# -----------------------------------------------------------------------------

# This confuses nearly every beginner. Here's the clear breakdown:

# ".NET Framework" — the ORIGINAL, Windows-only platform (2002–2019)
#   - Lives at C:\Windows\Microsoft.NET
#   - Cannot run on Linux or Mac
#   - Version 4.8 is the last — it will never get a version 5
#   - Still used in legacy enterprise applications
#   - Do NOT start new projects on this

# ".NET Core" — the cross-platform rewrite (2016–2020)
#   - Runs on Windows, Linux, macOS
#   - Open source
#   - Better performance than Framework
#   - Named "Core" to differentiate from old Framework

# ".NET 5 and beyond" — the unified, single platform (2020–present)
#   - Microsoft dropped "Core" from the name
#   - This is THE .NET going forward
#   - Replaces both .NET Framework and .NET Core
#   - When someone says ".NET" today, they usually mean this

# "Mono" — a third-party cross-platform .NET (used in Unity, Xamarin)
#   - Created before Microsoft made .NET open source
#   - Now largely absorbed into the official .NET runtime

# "Xamarin" — .NET for mobile (iOS/Android)
#   - Now replaced by .NET MAUI (Multi-platform App UI)

# BOTTOM LINE: If you're starting a new project today, use .NET 8 or .NET 9.

# =============================================================================
# PART 2 — WHAT IS C#?
# =============================================================================

# -----------------------------------------------------------------------------
# 2.1  LANGUAGE DEFINITION AND CORE IDENTITY
# -----------------------------------------------------------------------------

# C# is a:
#   - STATICALLY TYPED language (types are checked at compile time)
#   - STRONGLY TYPED language (no implicit dangerous conversions)
#   - OBJECT-ORIENTED language (built around classes and objects)
#   - COMPONENT-ORIENTED language (properties, events, attributes built in)
#   - GENERAL PURPOSE language (can be used for almost anything)
#   - COMPILED language (compiled to IL, then JIT compiled to native)
#   - MANAGED language (memory managed by the runtime/GC)
#   - MULTI-PARADIGM (OOP + Functional + Imperative)

# C# is part of the C family of languages:
#   C → C++ → Java → C# (influenced by all of these)

# C# is standardized by ECMA (ECMA-334) and ISO (ISO/IEC 23270)
# This means anyone can implement a C# compiler — it's not just Microsoft's

# -----------------------------------------------------------------------------
# 2.2  KEY CHARACTERISTICS
# -----------------------------------------------------------------------------

# 1. TYPE SAFETY
#    The compiler catches type errors before your program runs.
#    You cannot assign a string to an integer variable without explicit conversion.
#    Example:
#      int x = "hello";    ← COMPILE ERROR
#      int x = 42;         ← VALID

# 2. AUTOMATIC MEMORY MANAGEMENT
#    The Garbage Collector (GC) frees memory you no longer use.
#    You don't manually call malloc/free like in C/C++.
#    This eliminates most memory leaks and buffer overflows.

# 3. RICH STANDARD LIBRARY
#    .NET BCL provides thousands of classes for:
#    - File I/O, networking, cryptography, math, regex,
#      threading, collections, database access, JSON, XML, etc.

# 4. CROSS-PLATFORM (modern .NET)
#    Write once, run on Windows, Linux, macOS.
#    Docker containers, cloud, Raspberry Pi — all supported.

# 5. UNIFIED TYPE SYSTEM
#    Everything inherits from System.Object.
#    Even primitives like int are objects (int is alias for System.Int32).

# 6. VERSIONING SUPPORT
#    C# was designed with API versioning in mind.
#    Interface default implementations, assembly versioning help avoid
#    "DLL hell" (the problem .NET was partly designed to solve).

# 7. INTEROPERABILITY
#    Can call native C/C++ code via P/Invoke.
#    COM interop for Windows legacy APIs.
#    Can interop with other .NET languages (VB.NET, F#).

# 8. OPEN SOURCE
#    The entire .NET runtime and C# compiler (Roslyn) are open source.
#    Repository: https://github.com/dotnet/runtime
#    Repository: https://github.com/dotnet/roslyn

# -----------------------------------------------------------------------------
# 2.3  C# VS OTHER LANGUAGES
# -----------------------------------------------------------------------------

# C# vs JAVA:
#   Similarities:
#     - Both compiled to bytecode (JVM vs CIL)
#     - Both have GC, OOP, generics
#     - Similar syntax and concepts
#   C# advantages:
#     - Properties (get/set) are first-class language feature
#     - Events and delegates built in
#     - LINQ is more powerful than Java Streams
#     - async/await was pioneered in C# (Java got CompletableFuture later)
#     - Value types (structs) — Java only has object types + primitives
#     - Operator overloading supported
#     - Pattern matching more powerful
#     - Records are cleaner
#   Java advantages:
#     - Larger market share in enterprise backend
#     - More mature ecosystem for big data (Hadoop, Spark)
#     - Longer history of cross-platform support

# C# vs C++:
#   C# advantages:
#     - Automatic memory management (no memory leaks from forgetting delete)
#     - Faster to write (less boilerplate)
#     - Safer (no undefined behavior in managed code)
#     - Easier debugging
#   C++ advantages:
#     - Absolute performance control
#     - No GC pauses
#     - Direct hardware access
#     - Systems programming (OS, drivers, embedded)
#   C# has "unsafe" mode for pointer manipulation when needed

# C# vs PYTHON:
#   C# advantages:
#     - Much faster execution (compiled vs interpreted)
#     - Strong typing catches bugs at compile time
#     - Better for large codebases (refactoring is safer)
#     - Better multithreading (Python has the GIL problem)
#   Python advantages:
#     - Faster to prototype
#     - Better for data science/ML ecosystem (NumPy, pandas, PyTorch)
#     - Easier for beginners
#     - More concise for scripting

# C# vs JAVASCRIPT/TYPESCRIPT:
#   C# advantages:
#     - True static typing (TypeScript typing has escape hatches)
#     - Better performance for compute-heavy tasks
#     - No "this" confusion issues
#   JS advantages:
#     - Runs natively in browsers (C# needs Blazor/WASM)
#     - Huge ecosystem (npm)
#     - Full-stack (front + back in one language natively)

# -----------------------------------------------------------------------------
# 2.4  WHAT C# IS NOT
# -----------------------------------------------------------------------------

# C# is NOT:
#   - A scripting language (though .NET 6+ top-level statements feel scripty)
#   - A systems programming language (can't write OS kernels in normal C#)
#   - A functional-first language (F# is better for pure functional on .NET)
#   - A data science language (Python's ecosystem dominates there)
#   - Owned by Windows only (it's fully cross-platform now — this is an old myth)
#   - Dead or declining (huge enterprise adoption, growing game dev, cloud)
#   - The same as C or C++ (completely different despite similar syntax look)
#   - Only for Windows desktop apps (this was true in 2005, not 2025)

# =============================================================================
# PART 3 — WHAT IS .NET?
# =============================================================================

# -----------------------------------------------------------------------------
# 3.1  .NET AS A PLATFORM — DEFINITION
# -----------------------------------------------------------------------------

# .NET is a free, open-source, cross-platform developer PLATFORM for building
# all kinds of applications.

# It consists of:
#   1. A RUNTIME (CLR) — executes your code
#   2. A BASE CLASS LIBRARY (BCL) — pre-built code you can use
#   3. A COMPILER toolchain — converts your code to executable format
#   4. A BUILD SYSTEM (MSBuild) — compiles and packages your projects
#   5. A PACKAGE MANAGER (NuGet) — download third-party libraries
#   6. APPLICATION FRAMEWORKS — ASP.NET Core, MAUI, WPF, etc.
#   7. TOOLS — dotnet CLI, diagnostics, profilers

# Think of .NET like a car engine. C# is the language you use to tell the
# engine what to do. The engine (CLR) actually does the work.

# -----------------------------------------------------------------------------
# 3.2  CLR — COMMON LANGUAGE RUNTIME
# -----------------------------------------------------------------------------

# The CLR is the heart of .NET. It is a virtual machine that:

#   1. LOADS your compiled code (CIL/MSIL bytecode)
#   2. VERIFIES it is type-safe before running
#   3. JIT COMPILES it to native machine code
#   4. MANAGES MEMORY via the Garbage Collector
#   5. HANDLES EXCEPTIONS across your entire application
#   6. PROVIDES THREAD MANAGEMENT
#   7. ENFORCES CODE ACCESS SECURITY

# The CLR is what makes .NET "managed" code.
# Code that runs under the CLR is called "managed code."
# Code that doesn't (like C/C++) is called "unmanaged code."

# Key CLR components:
#   - Class Loader      : loads types and assemblies from disk
#   - JIT Compiler      : converts CIL to native CPU instructions
#   - GC                : garbage collector for memory management
#   - Exception Manager : structured exception handling
#   - Thread Support    : managed thread pool and synchronization
#   - Type System       : enforces the CTS (Common Type System)

# -----------------------------------------------------------------------------
# 3.3  BCL — BASE CLASS LIBRARY
# -----------------------------------------------------------------------------

# The BCL is the massive standard library that comes with .NET.
# It provides thousands of classes for common tasks.

# Key BCL Namespaces:
#   System               — fundamental types (Object, String, Int32, Exception...)
#   System.Collections   — ArrayList, Hashtable (non-generic, legacy)
#   System.Collections.Generic — List<T>, Dictionary<K,V>, Queue<T>...
#   System.IO            — File, Directory, Stream, StreamReader, StreamWriter
#   System.Net           — WebClient, HttpWebRequest
#   System.Net.Http      — HttpClient (modern HTTP)
#   System.Text          — StringBuilder, Encoding
#   System.Text.Json     — JSON serialization/deserialization
#   System.Threading     — Thread, Mutex, Semaphore, Monitor
#   System.Threading.Tasks — Task, Task<T>, Parallel, async support
#   System.Linq          — LINQ extension methods
#   System.Reflection    — inspect and manipulate types at runtime
#   System.Diagnostics   — Process, Debug, Trace, Stopwatch
#   System.Security      — cryptography, permissions
#   System.Xml           — XML reading/writing
#   System.Data          — ADO.NET for database access
#   System.Runtime       — low-level runtime access
#   System.Numerics      — BigInteger, Vector<T>, complex numbers
#   System.Globalization — CultureInfo, localization

# -----------------------------------------------------------------------------
# 3.4  CIL / MSIL — INTERMEDIATE LANGUAGE
# -----------------------------------------------------------------------------

# When you compile a C# program, it is NOT compiled directly to machine code.
# It is compiled to CIL (Common Intermediate Language), also called MSIL.

# CIL is:
#   - Stack-based bytecode (instructions operate on a virtual stack)
#   - CPU-architecture independent
#   - Language independent (VB.NET, F#, C# all compile to the same CIL)
#   - Stored in .dll or .exe files (called "assemblies")

# This is why .NET allows multiple languages:
#   C#    → CIL ↘
#   VB.NET → CIL → CLR → Native Machine Code
#   F#    → CIL ↗

# You can inspect CIL using:
#   - ildasm.exe (IL Disassembler, part of Windows SDK)
#   - dotnet-ildasm tool
#   - dnSpy (decompiler)
#   - SharpLab.io (online, shows C# → CIL)

# -----------------------------------------------------------------------------
# 3.5  JIT COMPILATION
# -----------------------------------------------------------------------------

# JIT = Just In Time compilation

# Process:
#   1. Your C# code is compiled to CIL by the C# compiler (csc / Roslyn)
#   2. When you run the app, the CLR starts
#   3. The JIT compiler converts CIL to native machine code ON DEMAND
#   4. Each method is compiled the first time it's called
#   5. Compiled native code is cached — not recompiled on next call

# Why JIT?
#   PRO: The JIT can optimize for the actual hardware it's running on
#   PRO: Target-specific optimizations (SIMD, CPU features)
#   PRO: Inlining, dead code elimination at runtime
#   CON: Startup time (code must be JIT compiled before first run)
#   CON: JIT compilation itself uses CPU and memory

# .NET has two JIT modes:
#   - "Quick JIT"  : fast compilation, less optimization (used first time)
#   - "Tiered JIT" : after a method is called often, re-JIT with full optimization
#   Tiered compilation is default since .NET Core 3.0

# -----------------------------------------------------------------------------
# 3.6  AOT COMPILATION — AHEAD OF TIME
# -----------------------------------------------------------------------------

# AOT compiles your entire application to native machine code BEFORE running.
# The output is a standalone native binary — no CLR needed at runtime.

# Types of AOT in .NET:
#   ReadyToRun (R2R): partial AOT — still needs CLR but starts faster
#   Native AOT:       full AOT — no CLR needed, single self-contained binary

# Native AOT (introduced stable in .NET 8):
#   PRO: Very fast startup (milliseconds vs seconds)
#   PRO: Lower memory footprint
#   PRO: Ideal for containers, serverless, CLI tools
#   CON: Longer build times
#   CON: No dynamic code loading (Reflection limited)
#   CON: Larger output binary in some cases
#   USE WHEN: Microservices, AWS Lambda, CLI tools, embedded

# -----------------------------------------------------------------------------
# 3.7  THE ECOSYSTEM: NuGet, MSBuild, SDK
# -----------------------------------------------------------------------------

# NuGet — Package Manager
#   - The official package manager for .NET
#   - Repository at: https://nuget.org
#   - Packages are .nupkg files (zips of DLLs + metadata)
#   - Add packages to project: dotnet add package PackageName
#   - Over 300,000 packages available
#   - Private NuGet feeds available for enterprise

# MSBuild — Build System
#   - XML-based build system from Microsoft
#   - The .csproj file IS an MSBuild project file
#   - Handles compilation, resource embedding, test running, packaging
#   - Can define custom build tasks and targets
#   - Supports incremental builds (only rebuilds changed files)

# dotnet CLI — Command Line Interface
#   - dotnet new          : create new projects from templates
#   - dotnet build        : compile the project
#   - dotnet run          : build and run
#   - dotnet test         : run tests
#   - dotnet publish      : prepare for deployment
#   - dotnet add package  : add NuGet package
#   - dotnet ef           : Entity Framework tools
#   - dotnet tool install : install global .NET tools

# SDK vs Runtime:
#   SDK     = includes compiler + build tools + runtime (for developers)
#   Runtime = only the CLR (for running apps on servers/end user machines)
#   Always install SDK on development machines
#   Install runtime only on servers that just need to run the app

# =============================================================================
# PART 4 — SETTING UP THE ENVIRONMENT
# =============================================================================

# -----------------------------------------------------------------------------
# 4.1  INSTALLING .NET SDK
# -----------------------------------------------------------------------------

# Official download: https://dotnet.microsoft.com/download

# Windows:
#   - Download installer from Microsoft
#   - Or use winget: winget install Microsoft.DotNet.SDK.8
#   - Or use Chocolatey: choco install dotnet-sdk

# macOS:
#   - Download PKG installer from Microsoft
#   - Or use Homebrew: brew install --cask dotnet-sdk

# Linux (Ubuntu/Debian):
#   sudo apt-get update
#   sudo apt-get install -y dotnet-sdk-8.0
#   (Microsoft provides official APT/RPM repos)

# Verify installation:
#   dotnet --version          → should print something like 8.0.xxx
#   dotnet --list-sdks        → shows all installed SDKs
#   dotnet --list-runtimes    → shows all installed runtimes

# -----------------------------------------------------------------------------
# 4.2  IDEs: VISUAL STUDIO, VS CODE, RIDER
# -----------------------------------------------------------------------------

# Visual Studio (Windows / macOS):
#   - Microsoft's full IDE, most feature-rich option
#   - Free Community edition available
#   - Professional and Enterprise are paid
#   - Includes: debugger, profiler, git integration, designer tools
#   - Best for: WPF, WinForms, large enterprise projects, beginners
#   - Community edition: https://visualstudio.microsoft.com/vs/community/

# Visual Studio Code (Windows / macOS / Linux):
#   - Lightweight code editor, free and open source
#   - Needs C# extension (C# Dev Kit from Microsoft)
#   - Extension: ms-dotnettools.csharp
#   - Good for: cross-platform dev, web APIs, quick edits
#   - NOT a full IDE by default but extensible
#   - Much lower memory usage than Visual Studio

# JetBrains Rider (Windows / macOS / Linux):
#   - Paid IDE from JetBrains (popular makers of IntelliJ, PyCharm)
#   - Often considered the best C# IDE by many developers
#   - Superior refactoring, code analysis, cross-platform
#   - Price: ~$70/year individual
#   - Free for students and open source developers

# For beginners: Start with Visual Studio Community (Windows)
# For cross-platform or Linux: VS Code with C# Dev Kit
# For professional use: Rider

# -----------------------------------------------------------------------------
# 4.3  YOUR FIRST PROJECT: HELLO WORLD
# -----------------------------------------------------------------------------

# Using the dotnet CLI (works on all platforms):

# Step 1: Create a new console app
#   dotnet new console -n HelloWorld
#   cd HelloWorld

# Step 2: The generated Program.cs (C# 10+ minimal style)
#   ──────────────────────────────────────────
#   Console.WriteLine("Hello, World!");
#   ──────────────────────────────────────────

# Traditional style (still valid):
#   ──────────────────────────────────────────
#   using System;
#
#   namespace HelloWorld
#   {
#       class Program
#       {
#           static void Main(string[] args)
#           {
#               Console.WriteLine("Hello, World!");
#           }
#       }
#   }
#   ──────────────────────────────────────────

# Step 3: Run it
#   dotnet run
#   → Output: Hello, World!

# Step 4: Build without running
#   dotnet build
#   → Creates bin/Debug/net8.0/HelloWorld.dll

# -----------------------------------------------------------------------------
# 4.4  PROJECT STRUCTURE EXPLAINED
# -----------------------------------------------------------------------------

# HelloWorld/                  ← project root folder
#   ├── HelloWorld.csproj      ← project file (MSBuild/NuGet config)
#   ├── Program.cs             ← main entry point (C# source file)
#   ├── obj/                   ← build temp files (do not edit, .gitignore this)
#   └── bin/                   ← compiled output (do not edit, .gitignore this)
#       └── Debug/
#           └── net8.0/
#               ├── HelloWorld.dll   ← your compiled code
#               ├── HelloWorld.exe   ← self-executing wrapper (Windows)
#               └── HelloWorld.pdb   ← debug symbols

# For multi-project solutions:
#   MySolution/
#     ├── MySolution.sln          ← solution file (groups projects)
#     ├── MyApp/                  ← web API project
#     │   └── MyApp.csproj
#     ├── MyApp.Core/             ← class library (business logic)
#     │   └── MyApp.Core.csproj
#     └── MyApp.Tests/            ← test project
#         └── MyApp.Tests.csproj

# -----------------------------------------------------------------------------
# 4.5  .CSPROJ FILE DEEP DIVE
# -----------------------------------------------------------------------------

# The .csproj file is XML and controls everything about your project.
# Example:
# ──────────────────────────────────────────────────────────────
# <Project Sdk="Microsoft.NET.Sdk">
#
#   <PropertyGroup>
#     <OutputType>Exe</OutputType>            ← Console app (vs Library)
#     <TargetFramework>net8.0</TargetFramework> ← .NET version
#     <Nullable>enable</Nullable>             ← nullable reference types ON
#     <ImplicitUsings>enable</ImplicitUsings> ← auto-adds common 'using' lines
#   </PropertyGroup>
#
#   <ItemGroup>
#     <PackageReference Include="Newtonsoft.Json" Version="13.0.3" />
#   </ItemGroup>
#
# </Project>
# ──────────────────────────────────────────────────────────────

# OutputType values:
#   Exe     = console application (has entry point)
#   Library = class library (.dll — no entry point, imported by others)
#   WinExe  = Windows GUI application (no console window)

# TargetFramework values:
#   net8.0         = .NET 8 (cross-platform)
#   net7.0         = .NET 7
#   net48          = .NET Framework 4.8 (Windows only, legacy)
#   net8.0-windows = .NET 8 with Windows-specific APIs

# =============================================================================
# PART 5 — C# LANGUAGE FUNDAMENTALS
# =============================================================================

# -----------------------------------------------------------------------------
# 5.1  DATA TYPES (VALUE VS REFERENCE)
# -----------------------------------------------------------------------------

# C# has two fundamental categories of types:

# VALUE TYPES — stored directly on the STACK (or inline in objects)
#   bool     : true or false
#   byte     : 0 to 255 (8-bit unsigned)
#   sbyte    : -128 to 127 (8-bit signed)
#   short    : -32,768 to 32,767 (16-bit signed)
#   ushort   : 0 to 65,535 (16-bit unsigned)
#   int      : -2,147,483,648 to 2,147,483,647 (32-bit signed) ← most used
#   uint     : 0 to 4,294,967,295 (32-bit unsigned)
#   long     : -9.2 quintillion to 9.2 quintillion (64-bit signed)
#   ulong    : 0 to 18.4 quintillion (64-bit unsigned)
#   float    : ±3.4×10^38 (32-bit, ~7 digits precision)
#   double   : ±1.7×10^308 (64-bit, ~15 digits precision) ← default for decimals
#   decimal  : high precision for money (128-bit, 28-29 digits) ← use for money
#   char     : single Unicode character ('A', '\n')
#   struct   : user-defined value type
#   enum     : named integer constants

# REFERENCE TYPES — stored on the HEAP; variable holds a reference (pointer)
#   string   : immutable sequence of characters
#   object   : root of all types (System.Object)
#   class    : user-defined reference type
#   interface: contract type (no instance)
#   delegate : reference to a method
#   array    : reference to a block of elements
#   dynamic  : bypasses compile-time type checking

# IMPORTANT DIFFERENCE:
#   int a = 5;
#   int b = a;    ← b gets a COPY of 5
#   b = 10;       ← a is still 5, b is now 10

#   Person p1 = new Person("Alice");
#   Person p2 = p1;     ← p2 points to SAME object as p1
#   p2.Name = "Bob";    ← p1.Name is now also "Bob" (same object!)

# -----------------------------------------------------------------------------
# 5.2  VARIABLES, CONSTANTS, AND LITERALS
# -----------------------------------------------------------------------------

# Variable declaration:
#   int age = 25;
#   string name = "Alice";
#   bool isActive = true;
#   double pi = 3.14159;

# Type inference with var:
#   var count = 10;          ← compiler infers int
#   var message = "Hello";   ← compiler infers string
#   var is NOT dynamic — the type is fixed at compile time

# Constants (compile-time fixed value):
#   const int MaxSize = 100;
#   const string AppName = "MyApp";
#   const cannot be changed after declaration

# readonly (set once, at runtime):
#   readonly int userId;
#   userId can be set in constructor, then never changed

# Static readonly (shared across all instances):
#   static readonly DateTime StartTime = DateTime.Now;

# Literal formats:
#   int million = 1_000_000;      ← underscores for readability (C# 7+)
#   int hex = 0xFF;               ← hexadecimal
#   int binary = 0b1010_0011;     ← binary literal
#   double sci = 1.5e10;          ← scientific notation
#   float f = 3.14f;              ← float suffix
#   decimal d = 9.99m;            ← decimal suffix (ALWAYS use m for money)
#   long l = 1000000000L;         ← long suffix

# -----------------------------------------------------------------------------
# 5.3  OPERATORS
# -----------------------------------------------------------------------------

# Arithmetic:
#   +   addition
#   -   subtraction
#   *   multiplication
#   /   division (integer division truncates: 7/2 = 3)
#   %   modulo (remainder: 7%2 = 1)
#   ++  increment (x++ or ++x)
#   --  decrement (x-- or --x)

# Comparison:
#   ==  equal to
#   !=  not equal to
#   <   less than
#   >   greater than
#   <=  less than or equal
#   >=  greater than or equal

# Logical:
#   &&  AND (short-circuit: stops if left is false)
#   ||  OR  (short-circuit: stops if left is true)
#   !   NOT
#   &   AND (non-short-circuit, evaluates both sides)
#   |   OR  (non-short-circuit)

# Assignment:
#   =    assign
#   +=   add and assign   (x += 5 is x = x + 5)
#   -=   subtract and assign
#   *=   multiply and assign
#   /=   divide and assign
#   %=   modulo and assign

# Null-related (C# specific):
#   ??   null-coalescing: returns left if not null, else right
#        string s = name ?? "default";
#   ??=  null-coalescing assignment: assigns only if null
#        name ??= "Guest";
#   ?.   null-conditional: returns null if left is null, else accesses member
#        int? len = name?.Length;

# Type operators:
#   is   type check: if (obj is string) { }
#   as   safe cast: var s = obj as string;  → null if fails
#   (T)  hard cast: var s = (string)obj;   → throws if fails

# Ternary:
#   condition ? valueIfTrue : valueIfFalse
#   int max = a > b ? a : b;

# -----------------------------------------------------------------------------
# 5.4  CONTROL FLOW
# -----------------------------------------------------------------------------

# IF / ELSE IF / ELSE:
#   if (age >= 18)
#   {
#       Console.WriteLine("Adult");
#   }
#   else if (age >= 13)
#   {
#       Console.WriteLine("Teenager");
#   }
#   else
#   {
#       Console.WriteLine("Child");
#   }

# SWITCH STATEMENT (classic):
#   switch (day)
#   {
#       case "Monday":
#           Console.WriteLine("Start of work week");
#           break;
#       case "Friday":
#           Console.WriteLine("End of work week");
#           break;
#       default:
#           Console.WriteLine("Midweek");
#           break;
#   }

# SWITCH EXPRESSION (C# 8+, more concise):
#   string result = day switch
#   {
#       "Monday" => "Start of work week",
#       "Friday" => "End of work week",
#       _        => "Midweek"             ← _ is the default/discard
#   };

# FOR LOOP:
#   for (int i = 0; i < 10; i++)
#   {
#       Console.WriteLine(i);
#   }

# WHILE LOOP:
#   while (condition)
#   {
#       // runs while condition is true
#   }

# DO-WHILE LOOP (always runs at least once):
#   do
#   {
#       // runs first, then checks condition
#   } while (condition);

# FOREACH LOOP (iterates collections):
#   foreach (var item in collection)
#   {
#       Console.WriteLine(item);
#   }

# BREAK and CONTINUE:
#   break    → exits the current loop immediately
#   continue → skips to next iteration

# GOTO (avoid this — use sparingly only for escaping nested loops):
#   goto labelName;
#   labelName:

# -----------------------------------------------------------------------------
# 5.5  METHODS AND PARAMETERS
# -----------------------------------------------------------------------------

# Basic method:
#   static int Add(int a, int b)
#   {
#       return a + b;
#   }

# Void method (no return value):
#   static void PrintHello()
#   {
#       Console.WriteLine("Hello");
#   }

# Expression-bodied method (single expression, C# 6+):
#   static int Add(int a, int b) => a + b;
#   static void PrintHello() => Console.WriteLine("Hello");

# Optional parameters (must have default value, must be last):
#   static void Greet(string name, string greeting = "Hello")
#   {
#       Console.WriteLine($"{greeting}, {name}!");
#   }
#   Greet("Alice");             → Hello, Alice!
#   Greet("Alice", "Hi");       → Hi, Alice!

# Named parameters:
#   Greet(greeting: "Hey", name: "Bob");

# ref parameter (pass by reference — caller value is modified):
#   static void Double(ref int x) { x *= 2; }
#   int n = 5;
#   Double(ref n);  → n is now 10

# out parameter (caller doesn't need to initialize it):
#   static bool TryParse(string s, out int result)
#   {
#       return int.TryParse(s, out result);
#   }
#   int parsed;
#   if (TryParse("42", out parsed)) { ... }
#   Or inline: if (TryParse("42", out int parsed)) { ... }

# params (variable number of arguments):
#   static int Sum(params int[] numbers)
#   {
#       int total = 0;
#       foreach (var n in numbers) total += n;
#       return total;
#   }
#   Sum(1, 2, 3, 4, 5);   → 15

# Local functions (functions inside functions, C# 7+):
#   int result = Calculate(10);
#   int Calculate(int x)
#   {
#       return Helper(x) * 2;
#       int Helper(int n) => n + 5;  ← local function
#   }

# -----------------------------------------------------------------------------
# 5.6  ARRAYS AND COLLECTIONS
# -----------------------------------------------------------------------------

# ARRAYS (fixed size, 0-indexed):
#   int[] numbers = new int[5];           ← 5 zeros
#   int[] primes = { 2, 3, 5, 7, 11 };   ← initialization
#   int[] primes = new int[] { 2, 3, 5 };
#   primes[0] is 2, primes[4] is 11
#   primes.Length gives 5

# Multi-dimensional array:
#   int[,] matrix = new int[3, 3];
#   matrix[0, 0] = 1;

# Jagged array (array of arrays):
#   int[][] jagged = new int[3][];
#   jagged[0] = new int[] { 1, 2 };
#   jagged[1] = new int[] { 3, 4, 5 };

# LIST<T> (dynamic size array, most commonly used):
#   var list = new List<int>();
#   list.Add(1);
#   list.Add(2);
#   list.Remove(1);
#   list.Count     → number of elements
#   list[0]        → access by index
#   list.Contains(2) → true/false
#   list.Sort();

# DICTIONARY<K,V> (key-value pairs, fast lookup):
#   var dict = new Dictionary<string, int>();
#   dict["Alice"] = 30;
#   dict["Bob"] = 25;
#   int age = dict["Alice"];
#   bool exists = dict.ContainsKey("Alice");
#   dict.TryGetValue("Charlie", out int val);  ← safe get

# HASHSET<T> (unique values, fast contains check):
#   var set = new HashSet<int> { 1, 2, 3 };
#   set.Add(4);
#   set.Contains(3);   → true
#   set.Add(2);        → false (already exists, no duplicate)

# QUEUE<T> (FIFO — First In First Out):
#   var queue = new Queue<string>();
#   queue.Enqueue("first");
#   queue.Enqueue("second");
#   string item = queue.Dequeue();   → "first"

# STACK<T> (LIFO — Last In First Out):
#   var stack = new Stack<int>();
#   stack.Push(1);
#   stack.Push(2);
#   int top = stack.Pop();   → 2

# LINKEDLIST<T>:
#   Doubly linked list — good for frequent inserts/deletes
#   var ll = new LinkedList<int>();
#   ll.AddFirst(1);
#   ll.AddLast(2);

# SORTEDLIST<K,V>:
#   Maintains sorted order by key
#   var sorted = new SortedList<string, int>();

# CONCURRENTDICTIONARY<K,V>:
#   Thread-safe dictionary (for multi-threaded access)

# -----------------------------------------------------------------------------
# 5.7  STRINGS AND STRING MANIPULATION
# -----------------------------------------------------------------------------

# Strings are IMMUTABLE reference types in C#
# Every modification creates a NEW string in memory

# Creation:
#   string s1 = "Hello";
#   string s2 = "World";

# Concatenation:
#   string s3 = s1 + " " + s2;   → "Hello World"
#   (BAD for loops — creates many intermediate strings)

# String interpolation (preferred):
#   string msg = $"My name is {name} and I am {age} years old";

# String methods:
#   s.Length             → number of characters
#   s.ToUpper()          → "HELLO"
#   s.ToLower()          → "hello"
#   s.Trim()             → removes whitespace from both ends
#   s.TrimStart()        → removes from start only
#   s.TrimEnd()          → removes from end only
#   s.Contains("ell")    → true/false
#   s.StartsWith("He")   → true/false
#   s.EndsWith("lo")     → true/false
#   s.Replace("l","r")   → "Herro"
#   s.Split(",")         → string[] split by comma
#   s.Substring(1, 3)    → chars from index 1, length 3
#   s.IndexOf("e")       → index of first 'e', or -1
#   s.PadLeft(10)        → right-align in 10-char field
#   s.PadRight(10,'0')   → left-align, pad with zeros

# String comparison:
#   s1 == s2                                    → value equality (preferred)
#   s1.Equals(s2)                               → value equality
#   string.Compare(s1, s2)                      → -1/0/1
#   s1.Equals(s2, StringComparison.OrdinalIgnoreCase) → case-insensitive

# Null/empty checks:
#   string.IsNullOrEmpty(s)        → true if null or ""
#   string.IsNullOrWhiteSpace(s)   → true if null, "", or only spaces

# String joining:
#   string.Join(", ", array)       → "a, b, c"
#   string.Concat(s1, s2, s3)      → concatenation without separator

# StringBuilder (for building strings in loops — much more efficient):
#   var sb = new StringBuilder();
#   for (int i = 0; i < 100; i++)
#   {
#       sb.Append("line " + i + "\n");
#   }
#   string result = sb.ToString();

# Verbatim string (@ prefix — backslashes are literal):
#   string path = @"C:\Users\Alice\Documents";   ← no need to escape \
#   string multiline = @"Line 1
#   Line 2
#   Line 3";

# Raw string literal (C# 11+, no escaping needed):
#   string json = """
#       {
#           "name": "Alice"
#       }
#       """;

# -----------------------------------------------------------------------------
# 5.8  NULLABLE TYPES
# -----------------------------------------------------------------------------

# Value types (like int) cannot normally be null.
# Nullable<T> (or shorthand T?) allows value types to hold null.

# Nullable value types:
#   int? age = null;
#   double? price = null;
#   bool? isAdmin = null;

#   age.HasValue     → false (when null)
#   age.Value        → throws if null — always check first!
#   age.GetValueOrDefault()       → 0 if null
#   age.GetValueOrDefault(-1)     → -1 if null

# Nullable reference types (C# 8+, opt-in):
#   Enable in .csproj: <Nullable>enable</Nullable>
#   string name = null;   → COMPILER WARNING (non-nullable string is null)
#   string? name = null;  → OK (explicitly nullable string)
#
#   This forces you to think about null and handle it,
#   reducing NullReferenceException at runtime.

# Null-handling patterns:
#   var length = name?.Length;           ← null-conditional
#   var display = name ?? "Unknown";     ← null-coalescing
#   name ??= "Default";                  ← assign only if null

# -----------------------------------------------------------------------------
# 5.9  TYPE CASTING AND CONVERSION
# -----------------------------------------------------------------------------

# Implicit conversion (safe, no data loss):
#   int x = 10;
#   double d = x;   ← implicit: int → double (safe)

# Explicit cast (may throw or truncate):
#   double d = 3.99;
#   int x = (int)d;   ← truncates to 3 (not rounded)

# Safe cast using 'as' (returns null if fails):
#   object obj = "Hello";
#   string s = obj as string;   ← s is "Hello"
#   object num = 42;
#   string s2 = num as string;  ← s2 is null (no exception)

# Type check with 'is':
#   if (obj is string str)   ← C# 7+ pattern: if true, str is already cast
#   {
#       Console.WriteLine(str.Length);
#   }

# Convert class (for string/number conversions):
#   int.Parse("42")         → 42 (throws if invalid)
#   int.TryParse("abc", out int n) → false, n = 0 (safe version)
#   Convert.ToInt32("42")   → 42
#   Convert.ToString(42)    → "42"
#   42.ToString()           → "42"
#   42.ToString("C")        → "$42.00" (currency format)
#   42.ToString("D5")       → "00042" (zero-padded)
#   3.14.ToString("F2")     → "3.14" (2 decimal places)

# =============================================================================
# PART 6 — OBJECT-ORIENTED PROGRAMMING IN C#
# =============================================================================

# -----------------------------------------------------------------------------
# 6.1  CLASSES AND OBJECTS
# -----------------------------------------------------------------------------

# A class is a blueprint. An object is an instance of a class.

# Class definition:
#   public class Person
#   {
#       public string Name;     ← field (direct access — less preferred)
#       public int Age;
#   }

# Object creation:
#   Person alice = new Person();
#   alice.Name = "Alice";
#   alice.Age = 30;

# Object initializer syntax (C# 3+):
#   Person alice = new Person { Name = "Alice", Age = 30 };

# Target-typed new (C# 9+):
#   Person alice = new() { Name = "Alice", Age = 30 };

# Access modifiers:
#   public    — accessible from anywhere
#   private   — only within the same class (default for fields/methods)
#   protected — within class and derived classes
#   internal  — within the same assembly (.dll / .exe)
#   protected internal — within assembly OR derived class
#   private protected  — within class and derived classes in SAME assembly

# -----------------------------------------------------------------------------
# 6.2  CONSTRUCTORS
# -----------------------------------------------------------------------------

# Default constructor (auto-provided if you write none):
#   public Person() { }

# Parameterized constructor:
#   public Person(string name, int age)
#   {
#       Name = name;
#       Age = age;
#   }
#   Person bob = new Person("Bob", 25);

# Constructor chaining (calling another constructor with this()):
#   public Person(string name) : this(name, 0) { }
#   public Person(string name, int age)
#   {
#       Name = name;
#       Age = age;
#   }

# Static constructor (runs once when class is first used):
#   static Person()
#   {
#       Console.WriteLine("Person type initialized");
#   }

# Primary constructors (C# 12):
#   public class Person(string name, int age)
#   {
#       public string Name { get; } = name;
#       public int Age { get; } = age;
#   }

# -----------------------------------------------------------------------------
# 6.3  PROPERTIES AND FIELDS
# -----------------------------------------------------------------------------

# Fields (direct data storage — typically private):
#   private string _name;

# Properties (controlled access via get/set):
#   public string Name
#   {
#       get { return _name; }
#       set { _name = value; }   ← 'value' is the incoming value
#   }

# Auto-implemented property (compiler generates backing field):
#   public string Name { get; set; }

# Read-only property:
#   public string Name { get; }   ← can only be set in constructor

# Init-only property (C# 9+ — set in initializer, then immutable):
#   public string Name { get; init; }
#   Person p = new Person { Name = "Alice" };   ← OK
#   p.Name = "Bob";   ← COMPILE ERROR after creation

# Computed property:
#   public string FullName => $"{FirstName} {LastName}";

# Property with validation:
#   private int _age;
#   public int Age
#   {
#       get => _age;
#       set
#       {
#           if (value < 0) throw new ArgumentException("Age cannot be negative");
#           _age = value;
#       }
#   }

# Property access modifiers:
#   public string Name { get; private set; }   ← public get, private set

# -----------------------------------------------------------------------------
# 6.4  ENCAPSULATION
# -----------------------------------------------------------------------------

# Encapsulation = hiding internal data and exposing only what's needed.

# WHY: Protects data from invalid states. You control HOW data is set.
#      Implementation details can change without affecting outside code.

# BAD (no encapsulation):
#   public int Age;   ← anyone can set age to -100 or 999

# GOOD (encapsulated):
#   private int _age;
#   public int Age
#   {
#       get => _age;
#       set => _age = value >= 0 && value < 150 ? value
#              : throw new ArgumentOutOfRangeException();
#   }

# Convention: private fields use _camelCase prefix
# Convention: properties and public methods use PascalCase

# -----------------------------------------------------------------------------
# 6.5  INHERITANCE
# -----------------------------------------------------------------------------

# A class can inherit from ONE base class.
# It inherits all public and protected members.

#   public class Animal
#   {
#       public string Name { get; set; }
#       public void Eat() => Console.WriteLine($"{Name} is eating");
#   }
#
#   public class Dog : Animal   ← Dog inherits from Animal
#   {
#       public void Bark() => Console.WriteLine("Woof!");
#   }
#
#   Dog dog = new Dog { Name = "Rex" };
#   dog.Eat();    ← inherited from Animal
#   dog.Bark();   ← defined in Dog

# base keyword:
#   Calls the parent class constructor or method
#   public Dog(string name) : base() { Name = name; }
#   public override string ToString() => base.ToString() + " (Dog)";

# Object is the root of all inheritance:
#   Every class implicitly inherits from System.Object
#   Object provides: ToString(), Equals(), GetHashCode(), GetType()

# -----------------------------------------------------------------------------
# 6.6  POLYMORPHISM
# -----------------------------------------------------------------------------

# Polymorphism = "many forms" — same method name, different behavior.

# Method overriding (runtime polymorphism):
#   Base class marks method as virtual:
#   public class Animal
#   {
#       public virtual string Speak() => "...";
#   }
#
#   Derived class overrides it:
#   public class Cat : Animal
#   {
#       public override string Speak() => "Meow";
#   }
#
#   public class Dog : Animal
#   {
#       public override string Speak() => "Woof";
#   }
#
#   Animal a = new Cat();
#   a.Speak();   → "Meow"  (determined at RUNTIME)
#
#   Animal b = new Dog();
#   b.Speak();   → "Woof"  (determined at RUNTIME)

# The new keyword (hides, not overrides — usually a mistake):
#   public new string Speak() => "...";  ← HIDES base, not polymorphic

# Upcasting and downcasting:
#   Dog d = new Dog();
#   Animal a = d;          ← upcast (safe, implicit)
#   Dog d2 = (Dog)a;       ← downcast (explicit, throws if wrong type)
#   Dog d3 = a as Dog;     ← safe downcast (null if wrong)

# -----------------------------------------------------------------------------
# 6.7  ABSTRACTION AND ABSTRACT CLASSES
# -----------------------------------------------------------------------------

# Abstract class = cannot be instantiated, must be subclassed
# Abstract method = no implementation, subclass MUST override it

#   public abstract class Shape
#   {
#       public abstract double Area();         ← no body, must be overridden
#       public virtual string Describe()
#       {
#           return $"This shape has area {Area():F2}";
#       }
#   }
#
#   public class Circle : Shape
#   {
#       public double Radius { get; set; }
#       public override double Area() => Math.PI * Radius * Radius;
#   }
#
#   public class Rectangle : Shape
#   {
#       public double Width { get; set; }
#       public double Height { get; set; }
#       public override double Area() => Width * Height;
#   }
#
#   Shape s = new Circle { Radius = 5 };
#   s.Describe();   → "This shape has area 78.54"

# Abstract class CAN have:
#   - Constructors
#   - Non-abstract (concrete) methods
#   - Fields
#   - Properties
#   - State

# Abstract class CANNOT:
#   - Be instantiated directly (new Shape() → compile error)

# -----------------------------------------------------------------------------
# 6.8  INTERFACES
# -----------------------------------------------------------------------------

# Interface = pure contract — defines WHAT a class can do, not HOW.
# A class can implement MULTIPLE interfaces (unlike inheritance).

#   public interface IFlyable
#   {
#       void Fly();
#       string Wings { get; }
#   }
#
#   public interface ISwimmable
#   {
#       void Swim();
#   }
#
#   public class Duck : Animal, IFlyable, ISwimmable
#   {
#       public void Fly() => Console.WriteLine("Duck is flying");
#       public void Swim() => Console.WriteLine("Duck is swimming");
#       public string Wings => "feathered";
#   }

# Interface naming convention: always prefix with I (IDisposable, IEnumerable)

# Interface default implementations (C# 8+):
#   public interface ILogger
#   {
#       void Log(string message);
#       void LogError(string msg) => Log($"ERROR: {msg}");   ← default impl
#   }

# Common .NET Interfaces to know:
#   IEnumerable<T>  — can be iterated (foreach)
#   ICollection<T>  — has Count, Add, Remove
#   IList<T>        — indexed access (ICollection + indexer)
#   IDictionary<K,V> — key-value pairs
#   IDisposable     — has Dispose() method (resource cleanup)
#   IComparable<T>  — can be compared (for sorting)
#   IEquatable<T>   — has typed Equals method
#   ICloneable      — has Clone() method
#   INotifyPropertyChanged — for data binding (WPF/MAUI)

# -----------------------------------------------------------------------------
# 6.9  STATIC CLASSES AND MEMBERS
# -----------------------------------------------------------------------------

# Static members belong to the TYPE, not instances.

#   public class Counter
#   {
#       private static int _count = 0;   ← shared across all instances
#       public static int Count => _count;
#       public static void Increment() => _count++;
#   }
#
#   Counter.Increment();
#   Console.WriteLine(Counter.Count);   → 1

# Static class (all members must be static — cannot instantiate):
#   public static class MathHelper
#   {
#       public static double CircleArea(double r) => Math.PI * r * r;
#   }
#   MathHelper.CircleArea(5);   → 78.54

# Use static for:
#   - Utility/helper classes (no state needed per instance)
#   - Factory methods
#   - Constants and configuration
#   - Extension methods (must be in static class)

# -----------------------------------------------------------------------------
# 6.10 SEALED CLASSES
# -----------------------------------------------------------------------------

# sealed prevents further inheritance.

#   public sealed class FinalClass { }
#   public class Attempt : FinalClass { }   ← COMPILE ERROR

# Use sealed when:
#   - Security (prevent override of critical behavior)
#   - Performance (sealed virtual calls can be devirtualized by JIT)
#   - Design intent (this class is complete, not meant to be extended)

# String is sealed in .NET — you cannot inherit from string.

# -----------------------------------------------------------------------------
# 6.11 PARTIAL CLASSES
# -----------------------------------------------------------------------------

# A class split across multiple files — merged at compile time.

#   // File 1: Person.cs
#   public partial class Person
#   {
#       public string Name { get; set; }
#   }
#
#   // File 2: Person.Validation.cs
#   public partial class Person
#   {
#       public bool IsValid() => !string.IsNullOrEmpty(Name);
#   }

# Use partial classes:
#   - Generated code + your code (auto-generated UI code vs logic)
#   - Separating large classes by concern
#   - NOT as a substitute for poor design

# -----------------------------------------------------------------------------
# 6.12 RECORDS (C# 9+)
# -----------------------------------------------------------------------------

# Records are immutable, value-equality reference types.
# Designed for data transfer objects and immutable models.

#   public record Person(string Name, int Age);
#
#   Person alice = new Person("Alice", 30);
#   Console.WriteLine(alice.Name);   → Alice
#   Console.WriteLine(alice);        → Person { Name = Alice, Age = 30 }
#
#   Person alice2 = new Person("Alice", 30);
#   Console.WriteLine(alice == alice2);   → TRUE (value equality)
#
#   Person older = alice with { Age = 31 };   ← creates new record, copies rest

# Records provide automatically:
#   - Value-based equality (two records are equal if fields are equal)
#   - ToString() with property listing
#   - Deconstruction
#   - with expression for non-destructive mutation

# Record struct (C# 10+) — value type version:
#   public record struct Point(int X, int Y);

# Use records for:
#   - DTOs (Data Transfer Objects)
#   - Configuration objects
#   - Value objects in domain-driven design
#   - Immutable data

# =============================================================================
# PART 7 — ADVANCED C# FEATURES
# =============================================================================

# -----------------------------------------------------------------------------
# 7.1  GENERICS
# -----------------------------------------------------------------------------

# Generics allow types and methods to work with ANY type while maintaining
# type safety. The type is specified when you use the class/method.

# Generic class:
#   public class Box<T>
#   {
#       public T Value { get; set; }
#       public Box(T value) { Value = value; }
#   }
#
#   Box<int> intBox = new Box<int>(42);
#   Box<string> strBox = new Box<string>("Hello");

# Generic method:
#   public T GetFirst<T>(T[] array) => array[0];
#   int first = GetFirst(new int[] { 1, 2, 3 });     → 1
#   string word = GetFirst(new string[] { "a", "b" }); → "a"

# Generic constraints:
#   where T : class         → T must be a reference type
#   where T : struct        → T must be a value type
#   where T : new()         → T must have a default constructor
#   where T : SomeClass     → T must inherit from SomeClass
#   where T : ISomeInterface → T must implement interface
#   where T : notnull       → T cannot be null

# Example with constraint:
#   public class Repository<T> where T : class, new()
#   {
#       public T Create() => new T();
#   }

# Multiple constraints:
#   public void Process<T>(T item) where T : class, IComparable<T>, new()
#   { ... }

# WHY generics?
#   - Type safety (no casting)
#   - Performance (no boxing for value types)
#   - Code reuse (one implementation for all types)
#   - Before generics (C# 1.x), ArrayList held objects → required casting

# -----------------------------------------------------------------------------
# 7.2  DELEGATES AND EVENTS
# -----------------------------------------------------------------------------

# A delegate is a TYPE that references a METHOD.
# It is a "function pointer" — but type-safe and object-oriented.

# Custom delegate:
#   public delegate int MathOperation(int a, int b);
#   MathOperation add = (a, b) => a + b;
#   MathOperation multiply = (a, b) => a * b;
#   int result = add(3, 4);        → 7
#   int result2 = multiply(3, 4);  → 12

# Built-in delegate types (use these, not custom ones, when possible):
#   Action          — takes no args, returns void
#   Action<T>       — takes 1 arg, returns void
#   Action<T1,T2>   — takes 2 args, returns void (up to 16 type params)
#   Func<T>         — returns T, no args
#   Func<T,TResult> — takes T, returns TResult
#   Func<T1,T2,TResult> — takes 2 args, returns TResult
#   Predicate<T>    — takes T, returns bool (Func<T, bool>)

# Multicast delegates (calling multiple methods with one call):
#   Action greet = () => Console.Write("Hello");
#   greet += () => Console.Write(" World");
#   greet();   → Hello World

# Events (used for the Observer/Publisher-Subscriber pattern):
#   public class Button
#   {
#       public event EventHandler Click;   ← event declaration
#       public void OnClick()
#       {
#           Click?.Invoke(this, EventArgs.Empty);   ← raise the event
#       }
#   }
#
#   Button btn = new Button();
#   btn.Click += (sender, args) => Console.WriteLine("Button clicked!");
#   btn.OnClick();   → Button clicked!

# Events vs delegates:
#   - Events can only be raised by the class that declares them
#   - Subscribers can only += or -= (cannot = directly, preventing overwrite)
#   - Events are the safe, encapsulated form of multicast delegates

# -----------------------------------------------------------------------------
# 7.3  LAMBDA EXPRESSIONS
# -----------------------------------------------------------------------------

# A lambda is an anonymous (unnamed) function, written inline.
# Syntax: (parameters) => expression
#       : (parameters) => { statements; }

# Examples:
#   Func<int, int> square = x => x * x;
#   square(5)   → 25
#
#   Func<int, int, int> add = (a, b) => a + b;
#   add(3, 4)   → 7
#
#   Action<string> print = msg => Console.WriteLine(msg);
#   print("Hello");
#
#   Predicate<int> isEven = n => n % 2 == 0;
#   isEven(4)   → true

# Lambda with block body:
#   Func<int, int> factorial = n =>
#   {
#       int result = 1;
#       for (int i = 2; i <= n; i++) result *= i;
#       return result;
#   };

# Closures (lambdas can capture outer variables):
#   int multiplier = 3;
#   Func<int, int> triple = x => x * multiplier;
#   triple(5)   → 15
#   (The lambda "closes over" the variable multiplier)

# -----------------------------------------------------------------------------
# 7.4  LINQ — LANGUAGE INTEGRATED QUERY
# -----------------------------------------------------------------------------

# LINQ lets you query collections, databases, XML, and more with a
# unified, readable syntax. It's one of C#'s killer features.

# Two syntax styles:

# QUERY SYNTAX (SQL-like):
#   var results = from n in numbers
#                 where n > 5
#                 orderby n descending
#                 select n * 2;

# METHOD SYNTAX (lambda-based — preferred by most developers):
#   var results = numbers
#       .Where(n => n > 5)
#       .OrderByDescending(n => n)
#       .Select(n => n * 2);

# LINQ is LAZY: queries are not executed until enumerated (foreach, ToList(), etc.)

# Common LINQ methods:
#   .Where(predicate)         — filter elements
#   .Select(transform)        — project/transform elements
#   .OrderBy(keySelector)     — sort ascending
#   .OrderByDescending(key)   — sort descending
#   .ThenBy(key)              — secondary sort
#   .FirstOrDefault(pred)     — first match or null
#   .LastOrDefault(pred)      — last match or null
#   .Single(pred)             — exactly one match (throws if 0 or 2+)
#   .Any(pred)                — true if any match
#   .All(pred)                — true if all match
#   .Count(pred)              — count matches
#   .Sum(selector)            — sum of values
#   .Average(selector)        — average
#   .Min(selector)            — minimum
#   .Max(selector)            — maximum
#   .GroupBy(keySelector)     — group elements
#   .Join(other, ...)         — join two sequences (like SQL JOIN)
#   .Distinct()               — remove duplicates
#   .Take(n)                  — first n elements
#   .Skip(n)                  — skip first n elements
#   .ToList()                 — execute and return List<T>
#   .ToArray()                — execute and return T[]
#   .ToDictionary(key, val)   — execute and return Dictionary
#   .Aggregate(func)          — fold/reduce (like Sum but custom)
#   .SelectMany(selector)     — flatten nested collections
#   .Zip(other, selector)     — pair up two sequences

# Example:
#   var students = new List<Student>
#   {
#       new Student { Name = "Alice", Grade = 90, Age = 20 },
#       new Student { Name = "Bob",   Grade = 75, Age = 22 },
#       new Student { Name = "Carol", Grade = 88, Age = 21 },
#   };
#
#   var honorStudents = students
#       .Where(s => s.Grade >= 85)
#       .OrderBy(s => s.Name)
#       .Select(s => s.Name)
#       .ToList();
#   → ["Alice", "Carol"]
#
#   double avgGrade = students.Average(s => s.Grade);  → 84.33

# LINQ providers:
#   LINQ to Objects   — in-memory collections (IEnumerable<T>)
#   LINQ to SQL       — query SQL databases (translated to SQL)
#   LINQ to Entities  — Entity Framework (IQueryable<T>)
#   LINQ to XML       — query XML documents
#   LINQ to JSON      — (via libraries like Newtonsoft)

# IMPORTANT: IEnumerable vs IQueryable
#   IEnumerable<T>: runs in memory (LINQ to Objects)
#   IQueryable<T>:  builds expression tree, translated to SQL by EF Core
#   If you use .AsEnumerable() on a database query, the rest runs in memory!

# -----------------------------------------------------------------------------
# 7.5  EXTENSION METHODS
# -----------------------------------------------------------------------------

# Extension methods add new methods to EXISTING types without modifying them.
# Must be in a static class; method must be static with 'this' as first param.

#   public static class StringExtensions
#   {
#       public static bool IsEmail(this string s)
#       {
#           return s.Contains("@") && s.Contains(".");
#       }
#
#       public static string Repeat(this string s, int times)
#       {
#           return string.Concat(Enumerable.Repeat(s, times));
#       }
#   }
#
#   "user@example.com".IsEmail()   → true
#   "ha".Repeat(3)                  → "hahaha"

# LINQ itself is implemented as extension methods on IEnumerable<T>!
# When you call .Where(), .Select(), etc., you're calling extension methods.

# -----------------------------------------------------------------------------
# 7.6  ANONYMOUS TYPES
# -----------------------------------------------------------------------------

# A type with no name, inferred by the compiler from the initializer.

#   var person = new { Name = "Alice", Age = 30 };
#   Console.WriteLine(person.Name);   → Alice
#   person.Age = 31;   ← COMPILE ERROR — anonymous types are read-only

# Common use: LINQ projections
#   var projections = students.Select(s => new { s.Name, GradeLabel = s.Grade >= 90 ? "A" : "B" });

# Limitation: cannot pass anonymous type out of its scope
# For that use: records, tuples, or named classes/structs

# -----------------------------------------------------------------------------
# 7.7  DYNAMIC TYPES
# -----------------------------------------------------------------------------

# 'dynamic' bypasses static type checking — type resolved at RUNTIME.
# Uses the DLR (Dynamic Language Runtime) under the hood.

#   dynamic x = 10;
#   Console.WriteLine(x + 5);   → 15
#   x = "Hello";
#   Console.WriteLine(x.Length);  → 5   (resolved at runtime)
#   x.FakeMethod();  → RuntimeException (not a compile error!)

# USE DYNAMIC WHEN:
#   - Interoperating with COM (Office automation)
#   - Working with weakly-typed external APIs
#   - Python/Ruby interop via IronPython/IronRuby

# AVOID DYNAMIC when:
#   - You can use generics or interfaces instead (much safer)
#   - Performance matters (dynamic is significantly slower)

# -----------------------------------------------------------------------------
# 7.8  TUPLES
# -----------------------------------------------------------------------------

# Tuples group multiple values without defining a class.

# ValueTuple (C# 7+) — stack-allocated, named fields:
#   var point = (X: 3, Y: 7);
#   Console.WriteLine(point.X);   → 3
#
#   (string Name, int Age) person = ("Alice", 30);
#   Console.WriteLine(person.Name);

# Returning multiple values from a method:
#   public (int Min, int Max) GetRange(int[] numbers)
#   {
#       return (numbers.Min(), numbers.Max());
#   }
#   var range = GetRange(new[] { 3, 1, 4, 1, 5, 9 });
#   Console.WriteLine(range.Min);   → 1
#   Console.WriteLine(range.Max);   → 9

# Deconstruction:
#   var (min, max) = GetRange(numbers);
#   Console.WriteLine(min);   → 1

# Discard with _:
#   var (_, max) = GetRange(numbers);   ← discard min

# -----------------------------------------------------------------------------
# 7.9  PATTERN MATCHING
# -----------------------------------------------------------------------------

# C# has grown increasingly powerful pattern matching since C# 7.

# Type pattern:
#   if (obj is string s) { Console.WriteLine(s.Length); }

# Switch expression with patterns:
#   string Classify(object o) => o switch
#   {
#       int n when n < 0   => "negative integer",
#       int n              => $"positive integer {n}",
#       string s           => $"string of length {s.Length}",
#       null               => "null",
#       _                  => "something else"
#   };

# Property pattern (C# 8+):
#   string GetLabel(Person p) => p switch
#   {
#       { Age: < 13 }          => "child",
#       { Age: < 18 }          => "teenager",
#       { Age: >= 18, Name: var name } => $"adult: {name}"
#   };

# Positional pattern:
#   string DescribePoint((int x, int y) p) => p switch
#   {
#       (0, 0) => "origin",
#       (_, 0) => "on x-axis",
#       (0, _) => "on y-axis",
#       var (x, y) => $"({x}, {y})"
#   };

# List pattern (C# 11+):
#   int[] arr = { 1, 2, 3 };
#   bool match = arr is [1, 2, 3];   → true
#   bool match2 = arr is [1, ..];    → starts with 1

# -----------------------------------------------------------------------------
# 7.10 ITERATORS AND YIELD
# -----------------------------------------------------------------------------

# yield return creates an iterator without building a full collection.
# The method pauses and resumes — values are generated on demand.

#   public IEnumerable<int> GetNumbers(int max)
#   {
#       for (int i = 0; i < max; i++)
#       {
#           yield return i;   ← pauses here, returns i, resumes on next iteration
#       }
#   }
#
#   foreach (int n in GetNumbers(5))
#       Console.Write(n + " ");   → 0 1 2 3 4

# Infinite sequence (possible because it's lazy):
#   public IEnumerable<int> InfiniteCounter()
#   {
#       int i = 0;
#       while (true) yield return i++;
#   }
#   var first10 = InfiniteCounter().Take(10).ToList();

# yield break — ends the iteration early:
#   if (someCondition) yield break;

# -----------------------------------------------------------------------------
# 7.11 INDEXERS
# -----------------------------------------------------------------------------

# Indexers let you use [] syntax on custom classes.

#   public class WordCollection
#   {
#       private List<string> _words = new();
#
#       public string this[int index]   ← indexer
#       {
#           get => _words[index];
#           set => _words[index] = value;
#       }
#
#       public void Add(string word) => _words.Add(word);
#   }
#
#   var wc = new WordCollection();
#   wc.Add("hello");
#   Console.WriteLine(wc[0]);   → hello

# -----------------------------------------------------------------------------
# 7.12 OPERATOR OVERLOADING
# -----------------------------------------------------------------------------

# You can define custom behavior for operators on your types.

#   public struct Vector2D
#   {
#       public double X, Y;
#       public Vector2D(double x, double y) { X = x; Y = y; }
#
#       public static Vector2D operator +(Vector2D a, Vector2D b)
#           => new Vector2D(a.X + b.X, a.Y + b.Y);
#
#       public static bool operator ==(Vector2D a, Vector2D b)
#           => a.X == b.X && a.Y == b.Y;
#
#       public static bool operator !=(Vector2D a, Vector2D b)
#           => !(a == b);
#   }
#
#   var v1 = new Vector2D(1, 2);
#   var v2 = new Vector2D(3, 4);
#   var v3 = v1 + v2;   → Vector2D { X = 4, Y = 6 }

# Overloadable operators:
#   +, -, *, /, %, &, |, ^, <<, >>, ==, !=, <, >, <=, >=, !, ~, ++, --
# Cannot overload: =, &&, ||, ?:, ??, .

# =============================================================================
# PART 8 — ASYNC PROGRAMMING
# =============================================================================

# -----------------------------------------------------------------------------
# 8.1  WHY ASYNC MATTERS
# -----------------------------------------------------------------------------

# SYNCHRONOUS code: When you call a method, your thread WAITS until it finishes.
# For I/O operations (database, HTTP, file), your thread is BLOCKED and doing
# nothing while waiting for the response. This wastes CPU time and limits
# how many requests a server can handle.

# ASYNCHRONOUS code: Your thread is FREED while waiting for I/O.
# When the I/O completes, a thread resumes your work.
# This allows a server with 8 threads to handle thousands of concurrent requests!

# Example problem (BLOCKING):
#   var data = httpClient.GetString("https://api.example.com");  ← BLOCKED
#   // Thread is stuck here waiting for HTTP response
#   Process(data);

# Example fix (ASYNC):
#   var data = await httpClient.GetStringAsync("https://api.example.com");
#   // Thread is FREE here — can handle other requests
#   Process(data);

# -----------------------------------------------------------------------------
# 8.2  ASYNC / AWAIT KEYWORDS
# -----------------------------------------------------------------------------

# async marks a method as asynchronous (it may contain await expressions)
# await suspends the method until the awaited task completes

# Rules:
#   - async method must return Task, Task<T>, ValueTask, or void (avoid void!)
#   - Any method with await must be marked async
#   - await can only be used inside async methods

# Simple example:
#   public async Task<string> GetDataAsync()
#   {
#       await Task.Delay(1000);   ← simulates 1-second wait (non-blocking)
#       return "Data";
#   }
#
#   string data = await GetDataAsync();

# Async Main (C# 7.1+):
#   static async Task Main(string[] args)
#   {
#       await DoWorkAsync();
#   }

# Multiple awaits:
#   public async Task ProcessAsync()
#   {
#       var result1 = await GetFirstAsync();
#       var result2 = await GetSecondAsync();
#       Combine(result1, result2);
#   }
#   Note: result2 waits for result1. If independent, run in parallel (see below).

# Run two tasks in parallel:
#   var task1 = GetFirstAsync();   ← starts immediately
#   var task2 = GetSecondAsync();  ← starts immediately
#   var r1 = await task1;
#   var r2 = await task2;          ← both run concurrently

# Or use Task.WhenAll:
#   var (r1, r2) = await (Task.WhenAll(GetFirstAsync(), GetSecondAsync()));
#   var results = await Task.WhenAll(new[] { task1, task2, task3 });

# -----------------------------------------------------------------------------
# 8.3  TASK AND TASK<T>
# -----------------------------------------------------------------------------

# Task represents an ongoing asynchronous operation.
# Task<T> represents an operation that returns a value T when complete.

# Creating tasks:
#   Task.Run(() => DoWork());           ← run on thread pool
#   Task.FromResult(42);                ← already-completed task
#   Task.CompletedTask;                 ← completed void task
#   Task.Delay(1000);                   ← timer task (non-blocking sleep)

# Checking task state:
#   task.IsCompleted
#   task.IsFaulted
#   task.IsCanceled
#   task.Exception   ← AggregateException containing inner exception

# Waiting synchronously (AVOID if possible — can cause deadlocks):
#   task.Wait();       ← blocks current thread
#   task.Result;       ← blocks and gets value

# -----------------------------------------------------------------------------
# 8.4  VALUETASK
# -----------------------------------------------------------------------------

# ValueTask<T> is an optimization for async methods that often complete
# synchronously (cache hit, simple computation).

# Task<T>:    always allocates a heap object
# ValueTask<T>: stack-allocated if synchronous, heap only if truly async

# Use ValueTask when:
#   - Method is very frequently called
#   - It often returns synchronously
#   - Reducing allocations matters (hot path)

# Do NOT use ValueTask if:
#   - You await it multiple times
#   - You store it in a field for later use

# -----------------------------------------------------------------------------
# 8.5  CANCELLATION TOKENS
# -----------------------------------------------------------------------------

# CancellationToken allows you to cancel an async operation.

# Creating a cancellation token:
#   var cts = new CancellationTokenSource();
#   cts.CancelAfter(TimeSpan.FromSeconds(5));  ← auto-cancel after 5s
#   CancellationToken token = cts.Token;

# Passing to async methods:
#   await httpClient.GetStringAsync(url, token);

# Checking for cancellation:
#   token.ThrowIfCancellationRequested();   ← throws OperationCanceledException

# Handling cancellation:
#   try
#   {
#       await LongOperationAsync(token);
#   }
#   catch (OperationCanceledException)
#   {
#       Console.WriteLine("Operation was cancelled");
#   }
#   finally
#   {
#       cts.Dispose();
#   }

# -----------------------------------------------------------------------------
# 8.6  PARALLEL PROGRAMMING (TPL)
# -----------------------------------------------------------------------------

# TPL = Task Parallel Library (for CPU-bound work, not I/O)

# Parallel.For:
#   Parallel.For(0, 1000, i =>
#   {
#       DoExpensiveWork(i);
#   });

# Parallel.ForEach:
#   Parallel.ForEach(items, item =>
#   {
#       Process(item);
#   });

# PLINQ (Parallel LINQ):
#   var results = numbers.AsParallel()
#                        .Where(n => n > 5)
#                        .Select(n => Compute(n))
#                        .ToList();

# Thread-safe collections:
#   ConcurrentBag<T>
#   ConcurrentQueue<T>
#   ConcurrentStack<T>
#   ConcurrentDictionary<K,V>
#   BlockingCollection<T>

# -----------------------------------------------------------------------------
# 8.7  COMMON ASYNC PITFALLS
# -----------------------------------------------------------------------------

# 1. ASYNC VOID (avoid — exceptions cannot be caught):
#    WRONG:  public async void DoWork() { ... }
#    RIGHT:  public async Task DoWork() { ... }
#    EXCEPTION: event handlers (async void is OK there)

# 2. DEADLOCK with .Result or .Wait() in non-async context:
#    In ASP.NET or WPF, calling task.Result can deadlock.
#    SOLUTION: use await all the way up (async all the way)

# 3. NOT awaiting a task:
#    DoSomethingAsync();   ← fire and forget (error is swallowed)
#    await DoSomethingAsync();   ← proper

# 4. Sequential awaits when parallel would be faster:
#    SLOW:  await Task1(); await Task2();        (sequential)
#    FAST:  await Task.WhenAll(Task1(), Task2()); (parallel)

# 5. Capturing context unnecessarily:
#    In library code, use: await task.ConfigureAwait(false)
#    This avoids capturing the synchronization context (better perf)

# =============================================================================
# PART 9 — MEMORY MANAGEMENT & PERFORMANCE
# =============================================================================

# -----------------------------------------------------------------------------
# 9.1  GARBAGE COLLECTOR (GC) — HOW IT WORKS
# -----------------------------------------------------------------------------

# .NET's GC automatically frees memory that is no longer referenced.
# You allocate objects with 'new' — you never call free/delete.

# GC process:
#   1. Application allocates objects on the managed heap
#   2. When heap is full (or GC decides), a collection runs
#   3. GC identifies "root" references (stack variables, static fields, etc.)
#   4. GC traces all reachable objects from roots
#   5. Objects NOT reachable = garbage, their memory is freed
#   6. Live objects are compacted (moved together, reducing fragmentation)

# -----------------------------------------------------------------------------
# 9.2  GENERATIONS (GEN 0, 1, 2)
# -----------------------------------------------------------------------------

# .NET GC uses a generational model for efficiency.

# Gen 0 (youngest, small):
#   - New objects go here
#   - Collected most frequently and fastest
#   - Most objects die young (short-lived temporaries)

# Gen 1 (middle):
#   - Objects that survived Gen 0 collection
#   - Buffer between short-lived and long-lived

# Gen 2 (oldest, large):
#   - Long-lived objects (static data, caches)
#   - Collected infrequently
#   - Collection is expensive

# Large Object Heap (LOH):
#   - Objects > 85,000 bytes go here
#   - Not compacted by default (too expensive to move)
#   - Can cause fragmentation — be careful with large arrays

# GC.Collect() — forces a collection:
#   DO NOT call this in production normally!
#   The GC is smarter than you and calling it manually hurts performance.
#   Only call in test code or specific situations (e.g., after loading large data).

# -----------------------------------------------------------------------------
# 9.3  IDISPOSABLE AND USING STATEMENT
# -----------------------------------------------------------------------------

# IDisposable is for DETERMINISTIC cleanup of UNMANAGED resources:
#   - File handles, database connections, network sockets, etc.
#   - These are not managed by the GC — you MUST free them explicitly.

# Implementing IDisposable:
#   public class DatabaseConnection : IDisposable
#   {
#       private SqlConnection _connection;
#       public DatabaseConnection(string connString)
#       {
#           _connection = new SqlConnection(connString);
#           _connection.Open();
#       }
#       public void Dispose()
#       {
#           _connection?.Dispose();
#       }
#   }

# using statement (auto-calls Dispose when block exits):
#   using (var conn = new DatabaseConnection(connString))
#   {
#       // use conn
#   }   ← Dispose() called here, even if exception occurs

# using declaration (C# 8+, simpler):
#   using var conn = new DatabaseConnection(connString);
#   // conn.Dispose() called when it goes out of scope

# RULE: Always use using with IDisposable objects (HttpClient is an exception)
# HttpClient should be reused, not created per request!

# -----------------------------------------------------------------------------
# 9.4  FINALIZERS
# -----------------------------------------------------------------------------

# Finalizers (destructors) are called by the GC before object is freed.
# They provide a LAST RESORT to clean up unmanaged resources.

#   public class ResourceHolder
#   {
#       ~ResourceHolder()   ← finalizer syntax
#       {
#           // cleanup code
#       }
#   }

# Finalizers are:
#   - NOT deterministic (you don't know WHEN they'll run)
#   - Expensive (objects with finalizers need 2 GC cycles to collect)
#   - Should be avoided if possible — prefer IDisposable with using

# Full Dispose pattern (when you have both managed and unmanaged resources):
#   public class MyClass : IDisposable
#   {
#       private bool _disposed = false;
#       protected virtual void Dispose(bool disposing)
#       {
#           if (!_disposed)
#           {
#               if (disposing)
#               {
#                   // Free managed resources
#               }
#               // Free unmanaged resources
#               _disposed = true;
#           }
#       }
#       public void Dispose()
#       {
#           Dispose(true);
#           GC.SuppressFinalize(this);   ← tells GC no need to call finalizer
#       }
#       ~MyClass() => Dispose(false);
#   }

# -----------------------------------------------------------------------------
# 9.5  SPAN<T> AND MEMORY<T>
# -----------------------------------------------------------------------------

# Span<T> — a view into a contiguous region of memory (no allocation)
# Added in .NET Core 2.1 / C# 7.2 as a major performance tool.

# Why Span<T>?
#   String.Substring() allocates a NEW string.
#   span.Slice() creates a VIEW — zero allocation.

#   ReadOnlySpan<char> span = "Hello World".AsSpan();
#   ReadOnlySpan<char> hello = span.Slice(0, 5);   ← "Hello", no allocation

# Works with arrays too:
#   int[] arr = { 1, 2, 3, 4, 5 };
#   Span<int> middle = arr.AsSpan(1, 3);   ← view of [2,3,4]
#   middle[0] = 99;   ← modifies original array!

# Memory<T> — like Span<T> but can be stored in fields, used with async

# When to use:
#   - High-performance parsing (JSON, binary protocols)
#   - Avoiding allocations in hot paths
#   - Buffer processing without copying

# -----------------------------------------------------------------------------
# 9.6  UNSAFE CODE AND POINTERS
# -----------------------------------------------------------------------------

# C# allows unsafe code (pointer manipulation) inside unsafe blocks.
# Must compile with /unsafe flag or <AllowUnsafeBlocks>true</AllowUnsafeBlocks>

#   unsafe
#   {
#       int x = 42;
#       int* ptr = &x;
#       Console.WriteLine(*ptr);   → 42
#       *ptr = 100;
#       Console.WriteLine(x);      → 100
#   }

# Use unsafe for:
#   - Interop with native code
#   - Extreme performance-critical sections
#   - Image processing, binary manipulation

# Avoid unsafe in:
#   - General business logic (defeats memory safety)
#   - Any code that could be exploited via input

# -----------------------------------------------------------------------------
# 9.7  STRUCTS VS CLASSES FOR PERFORMANCE
# -----------------------------------------------------------------------------

# Structs are VALUE TYPES (stack/inline in objects) — no heap allocation.
# Classes are REFERENCE TYPES (heap) — heap allocation, GC pressure.

# When to use struct:
#   - Small data (rule of thumb: under ~16 bytes)
#   - Logically a single value (Point, Color, Vector)
#   - Short-lived or used in hot loops
#   - No inheritance needed

# When NOT to use struct:
#   - Large data (expensive to copy)
#   - Needs inheritance
#   - Contains many reference type fields
#   - Mutability is important (mutable structs are confusing)

# Performance rules:
#   - Passing large struct to method = COPY (expensive)
#   - Pass struct by ref to avoid copying: void Method(ref MyStruct s)
#   - ref struct: can only exist on stack (cannot be boxed, cannot be in List<T>)
#     Example: Span<T> is a ref struct

# -----------------------------------------------------------------------------
# 9.8  BOXING AND UNBOXING
# -----------------------------------------------------------------------------

# BOXING: converting a value type to object (heap allocation)
# UNBOXING: extracting value type back from object (requires cast)

# Example:
#   int x = 42;
#   object boxed = x;        ← BOXING (heap allocation!)
#   int unboxed = (int)boxed; ← UNBOXING (requires explicit cast)

# Boxing is expensive:
#   - Allocates heap memory
#   - Copies the value
#   - Adds GC pressure

# When boxing occurs:
#   - Assigning value type to object
#   - Using non-generic collections (ArrayList, Hashtable) — use generics instead
#   - Calling interface method on value type
#   - Passing value type where object is expected

# SOLUTION: Use generics (List<int> instead of ArrayList)
#   ArrayList list = new ArrayList();
#   list.Add(42);   ← BOXING occurs
#
#   List<int> list = new List<int>();
#   list.Add(42);   ← NO boxing

# =============================================================================
# PART 10 — ERROR HANDLING
# =============================================================================

# -----------------------------------------------------------------------------
# 10.1 TRY / CATCH / FINALLY
# -----------------------------------------------------------------------------

#   try
#   {
#       int result = Divide(10, 0);
#   }
#   catch (DivideByZeroException ex)
#   {
#       Console.WriteLine($"Cannot divide by zero: {ex.Message}");
#   }
#   catch (ArgumentException ex) when (ex.ParamName == "divisor")
#   {
#       // exception filter with 'when' keyword
#   }
#   catch (Exception ex)
#   {
#       // catch-all — log and rethrow or handle
#       Console.WriteLine($"Unexpected: {ex}");
#       throw;   ← rethrows preserving original stack trace (NOT 'throw ex')
#   }
#   finally
#   {
#       // ALWAYS runs, whether exception or not
#       // Use for cleanup
#   }

# Multiple catch: order from most specific to least specific

# -----------------------------------------------------------------------------
# 10.2 EXCEPTION HIERARCHY
# -----------------------------------------------------------------------------

# System.Exception (base)
#   ├── System.SystemException (runtime errors)
#   │   ├── NullReferenceException   — accessing member on null
#   │   ├── IndexOutOfRangeException — array index out of bounds
#   │   ├── InvalidCastException     — invalid type cast
#   │   ├── StackOverflowException   — infinite recursion
#   │   ├── OutOfMemoryException     — heap exhausted
#   │   ├── DivideByZeroException    — division by zero
#   │   ├── OverflowException        — arithmetic overflow (checked context)
#   │   ├── InvalidOperationException — object state invalid for operation
#   │   ├── NotImplementedException  — method not implemented
#   │   ├── NotSupportedException    — operation not supported
#   │   ├── ArgumentException        — bad argument
#   │   │   ├── ArgumentNullException  — argument is null
#   │   │   └── ArgumentOutOfRangeException — argument out of range
#   │   └── IOException (System.IO)
#   │       ├── FileNotFoundException
#   │       ├── DirectoryNotFoundException
#   │       └── EndOfStreamException
#   └── System.ApplicationException (user-defined, though now less used)

# IMPORTANT: Do NOT catch Exception and swallow it (empty catch block).
# Always log or handle properly.

# -----------------------------------------------------------------------------
# 10.3 CUSTOM EXCEPTIONS
# -----------------------------------------------------------------------------

#   public class InsufficientFundsException : Exception
#   {
#       public decimal Amount { get; }
#       public InsufficientFundsException(decimal amount)
#           : base($"Insufficient funds: needed {amount:C}")
#       {
#           Amount = amount;
#       }
#       public InsufficientFundsException(decimal amount, Exception innerException)
#           : base($"Insufficient funds: needed {amount:C}", innerException)
#       {
#           Amount = amount;
#       }
#   }
#
#   throw new InsufficientFundsException(100.00m);

# Always:
#   - Include a message
#   - Include an innerException constructor overload
#   - Name with "Exception" suffix

# -----------------------------------------------------------------------------
# 10.4 WHEN NOT TO USE EXCEPTIONS
# -----------------------------------------------------------------------------

# EXCEPTIONS ARE EXPENSIVE. Do not use them for normal control flow.

# BAD (exceptions as control flow):
#   try
#   {
#       int.Parse(userInput);   ← throws if not a number
#   }
#   catch (FormatException) { }

# GOOD:
#   if (int.TryParse(userInput, out int n)) { }

# Use TryXxx pattern for expected failures (TryParse, TryGetValue, etc.)
# Use exceptions for UNEXPECTED, EXCEPTIONAL conditions

# -----------------------------------------------------------------------------
# 10.5 RESULT PATTERN AS ALTERNATIVE
# -----------------------------------------------------------------------------

# The Result Pattern avoids exceptions for expected failure cases.
# Popular in functional programming style.

#   public class Result<T>
#   {
#       public bool IsSuccess { get; }
#       public T Value { get; }
#       public string Error { get; }
#
#       private Result(T value) { IsSuccess = true; Value = value; }
#       private Result(string error) { IsSuccess = false; Error = error; }
#
#       public static Result<T> Ok(T value) => new(value);
#       public static Result<T> Fail(string error) => new(error);
#   }
#
#   public Result<User> FindUser(int id)
#   {
#       var user = _db.Find(id);
#       if (user == null) return Result<User>.Fail("User not found");
#       return Result<User>.Ok(user);
#   }
#
#   var result = FindUser(42);
#   if (result.IsSuccess) Process(result.Value);
#   else LogError(result.Error);

# Libraries: ErrorOr, FluentResults, OneOf — popular Result pattern libraries

# =============================================================================
# PART 11 — .NET APPLICATION TYPES & USE CASES
# =============================================================================

# -----------------------------------------------------------------------------
# 11.1 CONSOLE APPLICATIONS
# -----------------------------------------------------------------------------

# WHAT: Text-based applications that run in a terminal/command prompt.
# USE WHEN:
#   - CLI tools, automation scripts, background jobs
#   - Learning and prototyping
#   - Server-side batch processing
#   - DevOps tooling

# PROS:
#   - Simple to create and debug
#   - Cross-platform
#   - Low overhead

# CONS:
#   - No GUI
#   - Not suitable for end-user applications

# Template: dotnet new console

# -----------------------------------------------------------------------------
# 11.2 ASP.NET CORE — WEB APIS
# -----------------------------------------------------------------------------

# WHAT: HTTP-based APIs (REST, gRPC, GraphQL) for web, mobile, and IoT clients.
# USE WHEN:
#   - Building a backend for React/Angular/mobile app
#   - Microservices
#   - Integration points between systems
#   - Public or private APIs

# PROS:
#   - Extremely high performance (one of fastest web frameworks globally)
#   - Built-in DI, logging, configuration, middleware
#   - Minimal API style (very concise for small APIs)
#   - Full OpenAPI/Swagger support

# CONS:
#   - More setup than frameworks like FastAPI (Python)
#   - Learning DI and middleware pipeline required

# Template: dotnet new webapi

# Minimal API example (C# 6+ style):
#   var app = WebApplication.Create(args);
#   app.MapGet("/hello", () => "Hello, World!");
#   app.Run();

# Controller-based API (for larger projects):
#   [ApiController]
#   [Route("api/[controller]")]
#   public class UsersController : ControllerBase
#   {
#       [HttpGet("{id}")]
#       public async Task<ActionResult<User>> GetUser(int id)
#       {
#           var user = await _userService.GetByIdAsync(id);
#           return user == null ? NotFound() : Ok(user);
#       }
#   }

# -----------------------------------------------------------------------------
# 11.3 ASP.NET CORE — MVC WEB APPS
# -----------------------------------------------------------------------------

# WHAT: Server-rendered HTML web applications with MVC pattern.
# USE WHEN:
#   - Traditional web apps that need server-side rendering
#   - SEO-critical content
#   - Progressive enhancement (works without JS)

# Model-View-Controller:
#   Model      — your data and business logic
#   View       — Razor (.cshtml) templates for HTML rendering
#   Controller — handles HTTP requests, coordinates Model and View

# Razor Pages:
#   Simpler alternative to MVC for page-focused scenarios.
#   Each page has one .cshtml file + one .cshtml.cs file.

# Template: dotnet new mvc  or  dotnet new webapp (Razor Pages)

# -----------------------------------------------------------------------------
# 11.4 BLAZOR — WEBASSEMBLY & SERVER
# -----------------------------------------------------------------------------

# WHAT: Build web UIs using C# instead of JavaScript.
# Two hosting models:

# Blazor Server:
#   - C# code runs on SERVER
#   - UI updates sent over SignalR (WebSocket)
#   - Full .NET access
#   - Requires constant connection
#   - Fast initial load

# Blazor WebAssembly:
#   - C# code compiled to WebAssembly, runs in BROWSER
#   - No server needed after initial load
#   - Can be hosted statically (CDN)
#   - Larger initial download (~10MB runtime)

# Blazor United (.NET 8+ — "Blazor Web App"):
#   - Mix of server-side and client-side rendering
#   - Best of both worlds

# USE WHEN:
#   - .NET team wants to build web UI without JavaScript
#   - Internal tools, business dashboards
#   - Progressive web apps

# Template: dotnet new blazorserver  or  dotnet new blazorwasm

# -----------------------------------------------------------------------------
# 11.5 WPF — WINDOWS PRESENTATION FOUNDATION
# -----------------------------------------------------------------------------

# WHAT: Rich desktop GUI framework for Windows.
# Uses XAML (XML-based markup) for UI definition.

# USE WHEN:
#   - Windows-only desktop applications
#   - Complex, rich UI (data grids, charts, animations)
#   - LOB (Line of Business) internal tools

# PROS:
#   - Powerful data binding
#   - Styles and templates
#   - Hardware-accelerated rendering (DirectX)

# CONS:
#   - Windows only
#   - Steep learning curve (XAML)
#   - No mobile support

# Template: dotnet new wpf (only on Windows)

# -----------------------------------------------------------------------------
# 11.6 WINFORMS — LEGACY DESKTOP
# -----------------------------------------------------------------------------

# WHAT: Older Windows GUI framework, simpler than WPF.
# Drag-and-drop designer in Visual Studio.

# USE WHEN:
#   - Simple internal tools
#   - Maintaining legacy applications
#   - Quick prototypes

# PROS: Easy to learn, quick to build simple forms
# CONS: Limited styling, old look and feel, Windows only

# Template: dotnet new winforms

# -----------------------------------------------------------------------------
# 11.7 MAUI — MULTI-PLATFORM APP UI
# -----------------------------------------------------------------------------

# WHAT: Cross-platform UI framework for iOS, Android, macOS, Windows.
# Successor to Xamarin.Forms.

# Write once, deploy everywhere:
#   Android → native Android app
#   iOS     → native iOS app
#   macOS   → native macOS app
#   Windows → native Windows app (WinUI 3)

# USE WHEN:
#   - Mobile apps for iOS and Android
#   - Companies who want one codebase for mobile + desktop

# PROS:
#   - Single codebase
#   - Native UI controls on each platform
#   - Full .NET access

# CONS:
#   - Larger app size than native
#   - Performance below fully native (getting better)
#   - Younger ecosystem

# Template: dotnet new maui

# -----------------------------------------------------------------------------
# 11.8 WORKER SERVICES & BACKGROUND SERVICES
# -----------------------------------------------------------------------------

# WHAT: Long-running background processes (not HTTP-based).
# Built on IHostedService.

# USE WHEN:
#   - Processing message queues (RabbitMQ, Azure Service Bus)
#   - Scheduled jobs and periodic tasks
#   - Windows/Linux services
#   - Event processing pipelines

# Template: dotnet new worker

# Example:
#   public class DataProcessingService : BackgroundService
#   {
#       protected override async Task ExecuteAsync(CancellationToken stoppingToken)
#       {
#           while (!stoppingToken.IsCancellationRequested)
#           {
#               await ProcessBatchAsync();
#               await Task.Delay(TimeSpan.FromMinutes(1), stoppingToken);
#           }
#       }
#   }

# -----------------------------------------------------------------------------
# 11.9 AZURE FUNCTIONS & SERVERLESS
# -----------------------------------------------------------------------------

# WHAT: Event-driven serverless functions hosted on Azure (or locally).
# You pay only when functions run.

# Triggers:
#   HTTP request, Timer, Queue message, Blob upload, Cosmos DB change, etc.

# USE WHEN:
#   - Event-driven processing
#   - APIs with variable load
#   - Automation and integrations
#   - Very cheap for low-traffic workloads

# PROS:
#   - No server management
#   - Scales automatically
#   - Pay per execution

# CONS:
#   - Cold start latency (mitigated with Premium plan or AOT)
#   - Stateless (state needs external storage)
#   - Harder to test locally

# -----------------------------------------------------------------------------
# 11.10 UNITY GAME DEVELOPMENT
# -----------------------------------------------------------------------------

# WHAT: Unity game engine uses a modified version of C# (Mono-based).
# Most popular 2D/3D game engine in the world.

# C# in Unity:
#   - MonoBehaviour is the base class for scripts
#   - Start(), Update(), OnCollision() are Unity callbacks
#   - No standard .NET BCL for some things (Unity has its own APIs)

# USE WHEN:
#   - 2D/3D games for PC, console, mobile, VR/AR
#   - Game prototypes
#   - Interactive experiences

# NOTE: Unity still uses an older .NET runtime and C# version.
# Unity is migrating to .NET 8 based CoreCLR but it's gradual (2023–2025).

# -----------------------------------------------------------------------------
# 11.11 ML.NET — MACHINE LEARNING
# -----------------------------------------------------------------------------

# WHAT: Microsoft's ML library for .NET developers.
# Train and deploy ML models using C#, no Python required.

# Supported tasks:
#   - Binary and multi-class classification
#   - Regression
#   - Recommendation
#   - Anomaly detection
#   - Object detection (ONNX models)
#   - Time series forecasting

# USE WHEN:
#   - .NET team wants to add ML without switching to Python
#   - Deploying ONNX models from PyTorch/TensorFlow in C# apps

# PROS: Integrates directly into .NET apps
# CONS: Smaller community and ecosystem than Python ML tools

# =============================================================================
# PART 12 — DATA ACCESS
# =============================================================================

# -----------------------------------------------------------------------------
# 12.1 ADO.NET (RAW DATABASE ACCESS)
# -----------------------------------------------------------------------------

# The lowest-level data access in .NET. Direct SQL execution.

#   using var conn = new SqlConnection(connectionString);
#   conn.Open();
#   using var cmd = new SqlCommand("SELECT * FROM Users WHERE Id = @id", conn);
#   cmd.Parameters.AddWithValue("@id", userId);
#   using var reader = cmd.ExecuteReader();
#   while (reader.Read())
#   {
#       Console.WriteLine(reader["Name"]);
#   }

# PROS:
#   - Maximum control and performance
#   - No abstraction overhead

# CONS:
#   - Verbose and repetitive
#   - Manual parameter handling
#   - No object mapping

# USE WHEN:
#   - Performance-critical queries
#   - Legacy code
#   - Complex queries that ORMs generate poorly

# -----------------------------------------------------------------------------
# 12.2 ENTITY FRAMEWORK CORE (ORM)
# -----------------------------------------------------------------------------

# EF Core is the official .NET ORM (Object-Relational Mapper).
# Maps C# classes (entities) to database tables.

# Setup:
#   NuGet: Microsoft.EntityFrameworkCore.SqlServer (or Npgsql for PostgreSQL)
#
#   public class User
#   {
#       public int Id { get; set; }
#       public string Name { get; set; }
#       public string Email { get; set; }
#   }
#
#   public class AppDbContext : DbContext
#   {
#       public DbSet<User> Users { get; set; }
#       protected override void OnConfiguring(DbContextOptionsBuilder options)
#           => options.UseSqlServer(connectionString);
#   }

# CRUD operations:
#   // Create
#   ctx.Users.Add(new User { Name = "Alice", Email = "a@b.com" });
#   await ctx.SaveChangesAsync();
#
#   // Read
#   var user = await ctx.Users.FindAsync(1);
#   var users = await ctx.Users.Where(u => u.Name.StartsWith("A")).ToListAsync();
#
#   // Update
#   user.Email = "new@email.com";
#   await ctx.SaveChangesAsync();
#
#   // Delete
#   ctx.Users.Remove(user);
#   await ctx.SaveChangesAsync();

# Migrations (manage schema changes):
#   dotnet ef migrations add InitialCreate
#   dotnet ef database update

# PROS:
#   - Rapid development
#   - No SQL for basic CRUD
#   - Schema migrations
#   - LINQ for queries

# CONS:
#   - Generated SQL can be suboptimal
#   - N+1 query problem if not careful (use Include() for eager loading)
#   - Learning curve for complex scenarios

# -----------------------------------------------------------------------------
# 12.3 DAPPER (MICRO ORM)
# -----------------------------------------------------------------------------

# Dapper extends IDbConnection with helper methods for mapping SQL to objects.
# Written by the Stack Overflow team.

# NuGet: Dapper

#   using var conn = new SqlConnection(connectionString);
#   var users = await conn.QueryAsync<User>("SELECT * FROM Users WHERE Age > @age",
#               new { age = 18 });

# PROS:
#   - Very fast (thin layer over ADO.NET)
#   - Write your own SQL (full control)
#   - Simple and easy to learn

# CONS:
#   - No migrations
#   - No change tracking
#   - More SQL to write

# USE WHEN:
#   - Performance matters
#   - Complex queries needed
#   - Stored procedures heavy workflow

# -----------------------------------------------------------------------------
# 12.4 REPOSITORY PATTERN
# -----------------------------------------------------------------------------

# Abstract data access behind an interface.

#   public interface IUserRepository
#   {
#       Task<User?> GetByIdAsync(int id);
#       Task<IEnumerable<User>> GetAllAsync();
#       Task AddAsync(User user);
#       Task UpdateAsync(User user);
#       Task DeleteAsync(int id);
#   }

# Benefits:
#   - Swap implementation (EF → Dapper → Mock) without changing business logic
#   - Easier to unit test (mock the repository)
#   - Separates concerns

# -----------------------------------------------------------------------------
# 12.5 WORKING WITH JSON (System.Text.Json)
# -----------------------------------------------------------------------------

# System.Text.Json — Microsoft's built-in JSON library (.NET Core 3+)
# Fast, low-allocation, but fewer features than Newtonsoft.Json

#   // Serialize:
#   string json = JsonSerializer.Serialize(myObject);
#
#   // Deserialize:
#   var obj = JsonSerializer.Deserialize<MyClass>(json);
#
#   // Options:
#   var options = new JsonSerializerOptions
#   {
#       PropertyNamingPolicy = JsonNamingPolicy.CamelCase,  ← camelCase properties
#       WriteIndented = true
#   };
#   string pretty = JsonSerializer.Serialize(myObject, options);

# Newtonsoft.Json (Json.NET) — NuGet: Newtonsoft.Json
# More features, mature, slower than System.Text.Json but more flexible:
#   string json = JsonConvert.SerializeObject(myObject);
#   var obj = JsonConvert.DeserializeObject<MyClass>(json);

# Use System.Text.Json for new projects.
# Use Newtonsoft.Json if you need advanced features or are maintaining old code.

# =============================================================================
# PART 13 — DEPENDENCY INJECTION & ARCHITECTURE
# =============================================================================

# -----------------------------------------------------------------------------
# 13.1 WHAT IS DI AND WHY USE IT
# -----------------------------------------------------------------------------

# Dependency Injection (DI) is a pattern where objects receive their
# dependencies (collaborators) instead of creating them internally.

# WITHOUT DI (hard coupling):
#   public class OrderService
#   {
#       private EmailService _email = new EmailService();   ← hard dependency
#   }

# WITH DI (loose coupling):
#   public class OrderService
#   {
#       private readonly IEmailService _email;
#       public OrderService(IEmailService email)   ← injected
#       {
#           _email = email;
#       }
#   }

# Why use DI?
#   - Easier to unit test (inject mocks)
#   - Loosely coupled code
#   - Easier to swap implementations
#   - Manages object lifetimes automatically

# -----------------------------------------------------------------------------
# 13.2 BUILT-IN DI IN .NET
# -----------------------------------------------------------------------------

# .NET has a built-in DI container. Configure services in startup.

#   // In Program.cs (or Startup.cs):
#   builder.Services.AddScoped<IUserRepository, UserRepository>();
#   builder.Services.AddSingleton<ILogger, FileLogger>();
#   builder.Services.AddTransient<IEmailService, SmtpEmailService>();
#
#   // Then in any class, inject via constructor:
#   public class UserController
#   {
#       private readonly IUserRepository _repo;
#       public UserController(IUserRepository repo)  ← auto-injected by DI
#       {
#           _repo = repo;
#       }
#   }

# Third-party containers: Autofac, Ninject, Castle Windsor (more features)

# -----------------------------------------------------------------------------
# 13.3 SERVICE LIFETIMES
# -----------------------------------------------------------------------------

# TRANSIENT:
#   - New instance created EVERY TIME it's requested
#   - Use for: stateless, lightweight services
#   - Example: email formatters, calculators

# SCOPED:
#   - New instance per HTTP REQUEST (in web apps)
#   - Same instance within a request
#   - Use for: database contexts (DbContext), unit of work
#   - Example: EF Core DbContext is always Scoped

# SINGLETON:
#   - Single instance for the ENTIRE application lifetime
#   - Use for: configuration, logging, caches, connection pools
#   - WARNING: cannot inject Scoped service into Singleton (captive dependency)

# -----------------------------------------------------------------------------
# 13.4 COMMON ARCHITECTURE PATTERNS
# -----------------------------------------------------------------------------

# LAYERED / N-TIER ARCHITECTURE:
#   Presentation Layer   (Controllers, Razor Pages, Blazor)
#   Application Layer    (Services, Use Cases)
#   Domain Layer         (Entities, Business Rules)
#   Infrastructure Layer (Repositories, Database, External APIs)

# CLEAN ARCHITECTURE (Robert C. Martin):
#   Concentric rings. Inner rings don't know about outer rings.
#   Center: Domain (pure business logic, no framework dependencies)
#   Ring 2: Application (use cases, orchestration)
#   Ring 3: Infrastructure (EF Core, HTTP clients, etc.)
#   Ring 4: Presentation (ASP.NET, UI)

# DOMAIN-DRIVEN DESIGN (DDD):
#   Focuses on the domain model.
#   Key concepts: Entities, Value Objects, Aggregates, Domain Events,
#   Repositories, Domain Services, Bounded Contexts

# MICROSERVICES:
#   Small, independently deployable services, each with its own database.
#   Communicate via HTTP/gRPC or message queues.
#   .NET is excellent for microservices (small Docker images, fast startup).

# -----------------------------------------------------------------------------
# 13.5 CLEAN ARCHITECTURE IN .NET
# -----------------------------------------------------------------------------

# Project structure for clean architecture:
#   src/
#     MyApp.Domain/           ← Entities, Value Objects, Domain Events
#     MyApp.Application/      ← Use Cases, DTOs, Interfaces
#     MyApp.Infrastructure/   ← EF Core, external APIs, implementations
#     MyApp.API/              ← ASP.NET Core controllers, Program.cs
#   tests/
#     MyApp.UnitTests/
#     MyApp.IntegrationTests/

# Domain project has NO external dependencies
# Application depends only on Domain
# Infrastructure depends on Application and Domain
# API depends on Infrastructure and Application

# -----------------------------------------------------------------------------
# 13.6 CQRS AND MEDIATR
# -----------------------------------------------------------------------------

# CQRS = Command Query Responsibility Segregation
# Separate read operations (queries) from write operations (commands).

# MediatR — popular .NET library implementing Mediator pattern.
# NuGet: MediatR

# Command (write):
#   public record CreateUserCommand(string Name, string Email) : IRequest<int>;
#   public class CreateUserHandler : IRequestHandler<CreateUserCommand, int>
#   {
#       public async Task<int> Handle(CreateUserCommand request, CancellationToken ct)
#       {
#           var user = new User { Name = request.Name, Email = request.Email };
#           await _repo.AddAsync(user);
#           return user.Id;
#       }
#   }
#
#   // In controller:
#   int newId = await _mediator.Send(new CreateUserCommand("Alice", "a@b.com"));

# Query (read):
#   public record GetUserQuery(int Id) : IRequest<UserDto>;
#   public class GetUserHandler : IRequestHandler<GetUserQuery, UserDto>
#   {
#       public async Task<UserDto> Handle(GetUserQuery request, CancellationToken ct)
#       {
#           return await _repo.GetDtoAsync(request.Id);
#       }
#   }

# Benefits: Decoupled, each handler has single responsibility, easy to test

# =============================================================================
# PART 14 — TESTING
# =============================================================================

# -----------------------------------------------------------------------------
# 14.1 UNIT TESTING WITH xUnit / NUnit / MSTest
# -----------------------------------------------------------------------------

# THREE main test frameworks for .NET:

# xUnit (recommended — modern, created by NUnit author):
#   [Fact]                         ← single test
#   [Theory]                       ← parameterized test
#   [InlineData(...)]              ← data for theory

# NUnit (mature, feature-rich):
#   [Test], [TestCase], [TestFixture]

# MSTest (Microsoft's own):
#   [TestMethod], [TestClass]

# xUnit example:
#   public class CalculatorTests
#   {
#       [Fact]
#       public void Add_ReturnsSum()
#       {
#           var calc = new Calculator();
#           int result = calc.Add(3, 4);
#           Assert.Equal(7, result);
#       }
#
#       [Theory]
#       [InlineData(2, 2, 4)]
#       [InlineData(0, 5, 5)]
#       [InlineData(-3, 3, 0)]
#       public void Add_MultipleCases(int a, int b, int expected)
#       {
#           Assert.Equal(expected, new Calculator().Add(a, b));
#       }
#   }

# AAA Pattern (Arrange, Act, Assert):
#   [Fact]
#   public void GetUserById_ReturnsCorrectUser()
#   {
#       // Arrange
#       var mockRepo = new Mock<IUserRepository>();
#       mockRepo.Setup(r => r.GetByIdAsync(1)).ReturnsAsync(new User { Id = 1, Name = "Alice" });
#       var service = new UserService(mockRepo.Object);
#
#       // Act
#       var user = await service.GetUserAsync(1);
#
#       // Assert
#       Assert.Equal("Alice", user.Name);
#   }

# -----------------------------------------------------------------------------
# 14.2 MOCKING WITH MOQ
# -----------------------------------------------------------------------------

# Moq is the most popular mocking library for .NET.
# NuGet: Moq

#   var mock = new Mock<IEmailService>();
#   mock.Setup(s => s.SendAsync(It.IsAny<string>(), It.IsAny<string>()))
#       .ReturnsAsync(true);
#   mock.Verify(s => s.SendAsync("user@test.com", It.IsAny<string>()), Times.Once);

# Other mocking libraries: NSubstitute (simpler), FakeItEasy

# -----------------------------------------------------------------------------
# 14.3 INTEGRATION TESTING
# -----------------------------------------------------------------------------

# Tests that check multiple components together, including database/HTTP.

# ASP.NET Core Integration Tests using WebApplicationFactory:
#   NuGet: Microsoft.AspNetCore.Mvc.Testing
#
#   public class ApiTests : IClassFixture<WebApplicationFactory<Program>>
#   {
#       private readonly HttpClient _client;
#       public ApiTests(WebApplicationFactory<Program> factory)
#       {
#           _client = factory.CreateClient();
#       }
#
#       [Fact]
#       public async Task GetUsers_ReturnsOk()
#       {
#           var response = await _client.GetAsync("/api/users");
#           response.EnsureSuccessStatusCode();
#       }
#   }

# Database testing: Use an in-memory SQLite database or Testcontainers.
# Testcontainers: spins up real database in Docker for tests.

# -----------------------------------------------------------------------------
# 14.4 TEST DRIVEN DEVELOPMENT (TDD)
# -----------------------------------------------------------------------------

# TDD cycle: RED → GREEN → REFACTOR

# 1. RED:    Write a failing test for the feature you want
# 2. GREEN:  Write just enough code to make the test pass
# 3. REFACTOR: Clean up the code, tests still pass

# Benefits:
#   - Forces thinking about design before coding
#   - Always have tests
#   - Prevents over-engineering
#   - Documents behavior

# WHEN to use TDD:
#   - Core business logic
#   - Algorithms
#   - When requirements are clear

# WHEN TDD is harder:
#   - UI code
#   - Exploratory development
#   - Integration-heavy code

# =============================================================================
# PART 15 — SECURITY
# =============================================================================

# -----------------------------------------------------------------------------
# 15.1 AUTHENTICATION AND AUTHORIZATION IN ASP.NET CORE
# -----------------------------------------------------------------------------

# Authentication — "Who are you?"
# Authorization  — "What are you allowed to do?"

# ASP.NET Core Identity:
#   Full user management system: login, registration, password hashing,
#   roles, claims, 2FA, account confirmation.
#   NuGet: Microsoft.AspNetCore.Identity.EntityFrameworkCore

# Cookie authentication (for web apps):
#   builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
#       .AddCookie();

# JWT authentication (for APIs):
#   builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
#       .AddJwtBearer(options => { ... });

# Authorization with [Authorize] attribute:
#   [Authorize]                         ← any authenticated user
#   [Authorize(Roles = "Admin")]        ← specific role
#   [Authorize(Policy = "CanEdit")]     ← policy-based
#   [AllowAnonymous]                    ← override Authorize

# Role-based authorization:
#   builder.Services.AddAuthorization(options =>
#   {
#       options.AddPolicy("AdminOnly", policy => policy.RequireRole("Admin"));
#   });

# -----------------------------------------------------------------------------
# 15.2 JWT TOKENS
# -----------------------------------------------------------------------------

# JWT = JSON Web Token — stateless authentication for APIs.
# Three parts: Header.Payload.Signature (Base64 encoded)

# NuGet: System.IdentityModel.Tokens.Jwt or Microsoft.AspNetCore.Authentication.JwtBearer

# Creating a JWT:
#   var claims = new[]
#   {
#       new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
#       new Claim(ClaimTypes.Name, user.Email),
#       new Claim(ClaimTypes.Role, "User")
#   };
#   var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));
#   var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
#   var token = new JwtSecurityToken(
#       issuer: "myapp.com",
#       audience: "myapp.com",
#       claims: claims,
#       expires: DateTime.UtcNow.AddHours(1),
#       signingCredentials: creds
#   );
#   return new JwtSecurityTokenHandler().WriteToken(token);

# -----------------------------------------------------------------------------
# 15.3 HTTPS AND CERTIFICATES
# -----------------------------------------------------------------------------

# Always use HTTPS in production. ASP.NET Core redirects HTTP to HTTPS by default.

#   app.UseHttpsRedirection();  ← redirects HTTP to HTTPS
#   app.UseHsts();              ← HTTP Strict Transport Security header

# Dev certificates:
#   dotnet dev-certs https --trust

# Production: Use Let's Encrypt (free), Azure certificates, or your CA.

# -----------------------------------------------------------------------------
# 15.4 INPUT VALIDATION AND SQL INJECTION PREVENTION
# -----------------------------------------------------------------------------

# SQL Injection prevention:
#   WRONG (vulnerable):
#   cmd.CommandText = $"SELECT * FROM Users WHERE Name = '{userName}'";
#   ATTACKER: userName = "'; DROP TABLE Users; --"
#
#   RIGHT (parameterized queries):
#   cmd.CommandText = "SELECT * FROM Users WHERE Name = @name";
#   cmd.Parameters.AddWithValue("@name", userName);
#
#   EF Core and Dapper parameterize automatically when you use their APIs.

# Input validation in ASP.NET Core:
#   Data annotations on model:
#   [Required]
#   [StringLength(100)]
#   [EmailAddress]
#   [Range(0, 150)]
#   public string Email { get; set; }
#
#   Validate in controller: ModelState.IsValid
#   Or use FluentValidation NuGet for complex rules.

# XSS Prevention:
#   ASP.NET Core Razor auto-encodes HTML output by default.
#   Never use @Html.Raw() with user input.

# CSRF Protection:
#   [ValidateAntiForgeryToken] on POST actions.
#   ASP.NET Core MVC adds anti-forgery tokens automatically.

# -----------------------------------------------------------------------------
# 15.5 SECRET MANAGEMENT
# -----------------------------------------------------------------------------

# NEVER put secrets in source code or appsettings.json committed to git!

# Development: User Secrets
#   dotnet user-secrets set "ConnectionStrings:Default" "your-connection-string"
#   Stored in: ~/.microsoft/usersecrets/ (not in project folder)
#   Access: builder.Configuration["ConnectionStrings:Default"]

# Production: Environment Variables or Azure Key Vault
#   Environment variable: set CONNECTIONSTRINGS__DEFAULT=...
#   ASP.NET Core reads environment variables automatically.
#
#   Azure Key Vault:
#   NuGet: Azure.Extensions.AspNetCore.Configuration.Secrets
#   builder.Configuration.AddAzureKeyVault(vaultUri, new DefaultAzureCredential());

# =============================================================================
# PART 16 — DEPLOYMENT & DEVOPS
# =============================================================================

# -----------------------------------------------------------------------------
# 16.1 PUBLISHING .NET APPS
# -----------------------------------------------------------------------------

# Basic publish:
#   dotnet publish -c Release

# Output: bin/Release/net8.0/publish/

# Self-contained deployment (no .NET runtime needed on target):
#   dotnet publish -c Release --self-contained -r win-x64
#   dotnet publish -c Release --self-contained -r linux-x64
#   dotnet publish -c Release --self-contained -r osx-x64

# Framework-dependent deployment (requires .NET runtime installed):
#   dotnet publish -c Release --no-self-contained

# Single-file app:
#   dotnet publish -c Release -r linux-x64 --self-contained -p:PublishSingleFile=true

# AOT:
#   dotnet publish -c Release -r linux-x64 -p:PublishAot=true

# Runtime Identifiers (RID):
#   win-x64, win-x86, win-arm64
#   linux-x64, linux-arm, linux-arm64
#   osx-x64, osx-arm64 (Apple Silicon)

# -----------------------------------------------------------------------------
# 16.2 DOCKER AND CONTAINERS
# -----------------------------------------------------------------------------

# Example Dockerfile for ASP.NET Core API:
# ──────────────────────────────────────────
# FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
# WORKDIR /app
# EXPOSE 80
#
# FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# WORKDIR /src
# COPY ["MyApp/MyApp.csproj", "MyApp/"]
# RUN dotnet restore "MyApp/MyApp.csproj"
# COPY . .
# WORKDIR "/src/MyApp"
# RUN dotnet build -c Release -o /app/build
#
# FROM build AS publish
# RUN dotnet publish -c Release -o /app/publish
#
# FROM base AS final
# WORKDIR /app
# COPY --from=publish /app/publish .
# ENTRYPOINT ["dotnet", "MyApp.dll"]
# ──────────────────────────────────────────

# Build and run:
#   docker build -t myapp .
#   docker run -p 8080:80 myapp

# Microsoft provides official .NET Docker images at mcr.microsoft.com/dotnet/

# -----------------------------------------------------------------------------
# 16.3 CI/CD WITH GITHUB ACTIONS
# -----------------------------------------------------------------------------

# Example .github/workflows/dotnet.yml:
# ──────────────────────────────────────────
# name: .NET CI
#
# on: [push, pull_request]
#
# jobs:
#   build:
#     runs-on: ubuntu-latest
#     steps:
#     - uses: actions/checkout@v4
#     - name: Setup .NET
#       uses: actions/setup-dotnet@v4
#       with:
#         dotnet-version: '8.0.x'
#     - name: Restore
#       run: dotnet restore
#     - name: Build
#       run: dotnet build --no-restore -c Release
#     - name: Test
#       run: dotnet test --no-build -c Release
#     - name: Publish
#       run: dotnet publish -c Release -o ./publish
# ──────────────────────────────────────────

# -----------------------------------------------------------------------------
# 16.4 AZURE DEPLOYMENT
# -----------------------------------------------------------------------------

# Azure App Service (easiest for web apps):
#   - Right-click publish in Visual Studio
#   - Or: az webapp deploy --name myapp --resource-group myRG --src-path publish.zip
#   - GitHub Actions deployment is also straightforward

# Azure Container Apps (for Docker-based microservices):
#   - Managed Kubernetes-like environment
#   - Scale to zero

# Azure Kubernetes Service (AKS):
#   - Full Kubernetes for complex microservices

# Azure SQL / CosmosDB / Table Storage for data

# Azure Key Vault for secrets

# -----------------------------------------------------------------------------
# 16.5 SELF-CONTAINED VS FRAMEWORK-DEPENDENT DEPLOYMENT
# -----------------------------------------------------------------------------

# FRAMEWORK-DEPENDENT:
#   - Requires .NET runtime on the target machine
#   - Smaller deployment size (~MB)
#   - Multiple apps can share the runtime
#   - Good for: servers where you control the environment, updates shared

# SELF-CONTAINED:
#   - Includes the .NET runtime in the output
#   - Larger size (~50-70MB for simple app)
#   - No .NET installation needed on target
#   - Good for: end-user apps, environments you don't control

# NATIVE AOT (self-contained + no JIT):
#   - Smallest and fastest startup
#   - No runtime included (native executable)
#   - Good for: CLI tools, Lambda functions, microservices

# =============================================================================
# PART 17 — PROS AND CONS
# =============================================================================

# -----------------------------------------------------------------------------
# 17.1 PROS OF C#
# -----------------------------------------------------------------------------

# 1. EXCELLENT TOOLING
#    Visual Studio is arguably the best IDE in the industry.
#    Roslyn compiler provides real-time error analysis, refactoring, code fixes.
#    IntelliSense is extremely accurate and fast.

# 2. STRONG TYPING WITH MODERN ERGONOMICS
#    Type safety catches bugs at compile time.
#    Modern features (nullable refs, pattern matching, records) reduce verbosity.
#    var inference prevents repetition without losing safety.

# 3. PERFORMANCE
#    .NET 8/9 is among the top-performing web frameworks globally.
#    Techempower benchmarks consistently place ASP.NET Core in top tiers.
#    Span<T>, Native AOT, tiered JIT all contribute to excellent perf.

# 4. ASYNC/AWAIT — INDUSTRY LEADING
#    C# pioneered async/await (2012) before Python, JavaScript, Rust.
#    The async model in .NET is mature, well-understood, and high-performance.

# 5. RICH ECOSYSTEM AND BCL
#    Thousands of NuGet packages.
#    The BCL covers nearly every common programming task.
#    Azure SDK, AWS SDK, Google Cloud SDK all have .NET support.

# 6. CROSS-PLATFORM
#    Runs on Windows, Linux, macOS, Android, iOS, WebAssembly.
#    Docker support is first-class.

# 7. BACKWARDS COMPATIBILITY
#    Microsoft is very careful about breaking changes.
#    Code from 2010 mostly still compiles and runs on modern .NET.

# 8. OPEN SOURCE AND COMMUNITY
#    GitHub: https://github.com/dotnet
#    Contributions from the community accepted.
#    Transparent development, RFCs published publicly.

# 9. LANGUAGE EVOLUTION
#    C# improves significantly every year.
#    Features are well-designed, not rushed.
#    The language design team is transparent about decisions.

# 10. ENTERPRISE-READY
#    Built-in DI, logging, configuration, health checks.
#    Long-term support versions guaranteed for 3 years.
#    Used by large companies: Microsoft, Stack Overflow, Stripe, Siemens, etc.

# -----------------------------------------------------------------------------
# 17.2 CONS OF C#
# -----------------------------------------------------------------------------

# 1. PRIMARILY TIED TO MICROSOFT ECOSYSTEM
#    Best when deployed to Azure or Windows.
#    Not as natural for AWS-first or Google Cloud-first shops.

# 2. VERBOSITY (compared to Python, Ruby, JavaScript)
#    Even with modern C# improvements, still more boilerplate than Python.
#    Simple scripts are more painful than Python or bash.

# 3. WINDOWS DESKTOP TOOLS ARE WINDOWS-ONLY
#    WPF and WinForms only work on Windows.
#    MAUI is cross-platform but newer and less mature.

# 4. STARTUP TIME (framework-dependent)
#    Cold start can be slower than native apps (without AOT).
#    Azure Functions cold start is a known pain point (improving with AOT).

# 5. GAME DEVELOPMENT LIMITATIONS
#    Unity's C# is behind modern C# in some areas.
#    Garbage collector pauses in Unity can cause frame drops.
#    Unity's rendering API sometimes conflicts with .NET idioms.

# 6. LEARNING CURVE FOR BEGINNERS
#    Object-oriented, statically typed, with lots of concepts.
#    Steeper curve than Python for complete beginners.
#    DI, async, generics all add to the learning path.

# 7. NOT A SCRIPTING LANGUAGE
#    Writing quick one-off scripts is awkward compared to Python/bash.
#    dotnet-script helps but not mainstream.

# 8. WEB FRONT-END REQUIRES BLAZOR OR JS INTEROP
#    If you want to write .NET for front-end, you need Blazor.
#    Blazor WASM has larger initial download than React/Vue apps.
#    React/Angular ecosystems are more mature for UI components.

# -----------------------------------------------------------------------------
# 17.3 PROS OF .NET
# -----------------------------------------------------------------------------

# 1. UNIFIED PLATFORM
#    One framework for web, desktop, mobile, cloud, AI, games.
#    Shared knowledge, libraries, and tooling across all app types.

# 2. OUTSTANDING PERFORMANCE
#    .NET 8 is dramatically faster than .NET Framework.
#    Benchmark improvements of 20-40x vs .NET Framework 4.8 in some areas.
#    Competitive with Go and Rust in HTTP throughput benchmarks.

# 3. CROSS-PLATFORM
#    Run on Windows, Linux, macOS.
#    ARM64 support (Apple Silicon, AWS Graviton, Raspberry Pi).

# 4. RICH STANDARD LIBRARY
#    BCL provides a massive amount out-of-the-box.
#    No need to add 50 packages for basic tasks.

# 5. LONG-TERM SUPPORT
#    LTS versions (3 years) for production stability.
#    Microsoft has strong incentives to maintain .NET.

# 6. FREE AND OPEN SOURCE
#    MIT licensed.
#    No cost to use, even commercially.

# 7. CLOUD-NATIVE FEATURES
#    Health checks, distributed tracing, metrics, containers all built-in.
#    OpenTelemetry support.
#    Excellent Docker and Kubernetes support.

# 8. NATIVE AOT
#    Produce tiny, fast, no-runtime native binaries.
#    Great for containers and serverless.

# -----------------------------------------------------------------------------
# 17.4 CONS OF .NET
# -----------------------------------------------------------------------------

# 1. MICROSOFT DEPENDENCY
#    Platform governed by Microsoft.
#    Future direction may change based on Microsoft's business interests.
#    Though MIT licensed, ecosystem is heavily Microsoft-shaped.

# 2. WINDOWS LEGACY WEIGHT
#    Some APIs still Windows-specific.
#    .NET Framework legacy code often needs migration effort.

# 3. PACKAGE ECOSYSTEM SIZE
#    NuGet has ~300k packages vs npm's ~2M.
#    Some niche areas have fewer options than JavaScript/Python ecosystems.

# 4. DATA SCIENCE ECOSYSTEM IS WEAK RELATIVE TO PYTHON
#    ML.NET exists but NumPy, pandas, PyTorch, TensorFlow are Python-first.
#    For data science work, Python is still dominant.

# 5. CERTAIN LINUX SERVERS DON'T INCLUDE .NET
#    Unlike Java (ubiquitous) or Python (usually pre-installed),
#    .NET runtime must often be separately installed.

# 6. MOBILE SUPPORT STILL MATURING
#    MAUI is good but younger than React Native or Flutter.
#    Quirks and rough edges still exist.

# -----------------------------------------------------------------------------
# 17.5 WHEN TO CHOOSE C# / .NET OVER ALTERNATIVES
# -----------------------------------------------------------------------------

# CHOOSE C# / .NET WHEN:
#   ✓ Building enterprise backend APIs (REST, gRPC)
#   ✓ Your team already knows C#
#   ✓ Microsoft/Azure ecosystem
#   ✓ Windows desktop applications
#   ✓ Cross-platform mobile apps (Xamarin/MAUI)
#   ✓ Performance is critical (web APIs, microservices)
#   ✓ Large team, long-lived codebase (static typing helps)
#   ✓ Unity game development
#   ✓ Building complex business software
#   ✓ Need strong IDE tooling and refactoring support

# CONSIDER ALTERNATIVES WHEN:
#   ✗ Data science / machine learning → Python
#   ✗ System programming (OS, drivers) → C, C++, Rust
#   ✗ Quick scripting → Python, bash
#   ✗ Browser-native front-end → JavaScript, TypeScript
#   ✗ Large data pipelines → Python, Java (Spark)
#   ✗ Functional programming emphasis → F# (on .NET), Haskell, Erlang
#   ✗ Web front-end heavy team → TypeScript + React/Vue/Angular

# =============================================================================
# PART 18 — WHAT NOT TO DO (ANTI-PATTERNS & COMMON MISTAKES)
# =============================================================================

# -----------------------------------------------------------------------------
# 18.1 C# ANTI-PATTERNS
# -----------------------------------------------------------------------------

# 1. HUNGARIAN NOTATION (strName, intAge, boolFlag)
#    WRONG: string strName = "Alice";
#    RIGHT: string name = "Alice";
#    Modern IDEs show types. Don't encode type in name.

# 2. MAGIC NUMBERS AND STRINGS
#    WRONG: if (status == 3) { ... }
#    RIGHT: if (status == OrderStatus.Shipped) { ... }
#    Use enums and constants for all "magic" values.

# 3. EMPTY CATCH BLOCKS (swallowing exceptions)
#    WRONG: try { ... } catch (Exception) { }
#    RIGHT: At minimum, log the exception. Ideally handle it.

# 4. CATCHING BASE Exception UNNECESSARILY
#    WRONG: catch (Exception ex) { ... }   ← catches OutOfMemoryException too!
#    RIGHT: catch (SqlException ex) { ... }  ← catch specific type

# 5. USING EXCEPTIONS FOR CONTROL FLOW
#    WRONG: try { int.Parse(s); } catch (FormatException) { ... }
#    RIGHT: int.TryParse(s, out int n)

# 6. PUBLIC FIELDS (instead of properties)
#    WRONG: public string Name;
#    RIGHT: public string Name { get; set; }
#    Properties allow validation, data binding, and future change.

# 7. GOD CLASS (one class does everything)
#    A class with hundreds of methods and properties.
#    Split by Single Responsibility Principle (SRP).

# 8. MUTABLE STATIC STATE (global state)
#    Hard to test, causes race conditions.
#    Use DI and inject dependencies instead.

# 9. NOT DISPOSING IDISPOSABLE OBJECTS
#    WRONG: var conn = new SqlConnection(cs); conn.Open();
#    RIGHT: using var conn = new SqlConnection(cs); conn.Open();

# 10. USING ASYNC VOID
#    WRONG: public async void HandleClick() { ... }
#    RIGHT: public async Task HandleClickAsync() { ... }
#    async void cannot be awaited, exceptions are unobservable.

# 11. BLOCKING ON ASYNC CODE (.Wait() or .Result)
#    WRONG: var data = GetDataAsync().Result;
#    RIGHT: var data = await GetDataAsync();
#    .Result can deadlock in certain synchronization contexts.

# 12. NOT USING CANCELLATION TOKENS
#    Long async operations should accept CancellationToken.
#    Allows graceful shutdown and timeout.

# 13. STRING CONCATENATION IN LOOPS
#    WRONG: string result = ""; for (var s in items) result += s;
#    RIGHT: var sb = new StringBuilder(); for (var s in items) sb.Append(s);

# 14. LINQ MISUSE — UNNECESSARY MATERIALIZATION
#    WRONG: var list = ctx.Users.ToList().Where(u => u.Age > 18);
#    RIGHT: var list = ctx.Users.Where(u => u.Age > 18).ToList();
#    First version loads ALL users into memory, then filters.
#    Second version filters in the database.

# -----------------------------------------------------------------------------
# 18.2 .NET ANTI-PATTERNS
# -----------------------------------------------------------------------------

# 1. SINGLETON DB CONTEXT (EF Core DbContext)
#    DbContext is NOT thread-safe. Register as Scoped, not Singleton.
#    WRONG: services.AddSingleton<AppDbContext>();
#    RIGHT: services.AddDbContext<AppDbContext>();   ← registers as Scoped

# 2. CREATING HTTPCLIENT PER REQUEST
#    WRONG: new HttpClient() inside a method called many times
#    This exhausts socket connections (socket exhaustion).
#    RIGHT: Use IHttpClientFactory (registered as Singleton, rotates handlers)
#    services.AddHttpClient<MyService>();

# 3. EXPOSING DBCONTEXT TO PRESENTATION LAYER
#    DbContext should not be used directly in controllers.
#    Use repositories or services as intermediaries.

# 4. OVER-USING STATIC METHODS
#    Statics are hard to mock and test.
#    Use DI and instance methods for testable code.
#    Math.Sqrt() is fine as static. Your business logic is not.

# 5. NOT USING CONFIGURATION SYSTEM
#    WRONG: string connString = "Server=...";  ← hardcoded in code
#    RIGHT: string connString = config["ConnectionStrings:Default"];

# 6. RETURNING NULL FROM COLLECTIONS
#    WRONG: public List<User> GetUsers() { ... return null; }
#    RIGHT: return new List<User>();  ← or return Enumerable.Empty<User>()
#    Null collections cause NullReferenceException at foreach.

# 7. CATCH AND RETHROW WITHOUT PRESERVING STACK TRACE
#    WRONG: catch (Exception ex) { throw ex; }  ← LOSES original stack trace
#    RIGHT: catch (Exception ex) { throw; }     ← preserves stack trace

# 8. OVER-ENGINEERING (premature CQRS/microservices for simple apps)
#    Start simple. Apply CQRS, microservices when you have proven need.
#    "Don't start with microservices" — Martin Fowler

# -----------------------------------------------------------------------------
# 18.3 BEGINNER MISTAKES
# -----------------------------------------------------------------------------

# 1. CONFUSING VALUE TYPES AND REFERENCE TYPES
#    Especially with structs: assignment copies, not references.

# 2. FORGETTING TO AWAIT ASYNC METHODS
#    Task t = GetDataAsync();  ← not awaited, result ignored
#    var data = await GetDataAsync();  ← correct

# 3. NULL REFERENCE EXCEPTIONS
#    Enable nullable reference types (<Nullable>enable</Nullable>)
#    Always null-check before using references.
#    Use ?. and ?? operators liberally.

# 4. USING == TO COMPARE STRINGS (mostly fine but be aware of culture):
#    == works for value equality.
#    StringComparer.OrdinalIgnoreCase for case-insensitive comparison.

# 5. NOT UNDERSTANDING LINQ'S LAZY EVALUATION
#    var query = list.Where(x => x > 5);  ← NOT executed yet
#    foreach (var x in query) { }          ← executed HERE
#    If list changes between definition and execution, results change.

# 6. MODIFYING COLLECTION WHILE ITERATING
#    foreach (var item in list)
#    {
#        list.Remove(item);   ← THROWS InvalidOperationException
#    }
#    RIGHT: list.RemoveAll(item => condition);
#    Or iterate over a copy: foreach (var item in list.ToList())

# 7. NOT USING USING STATEMENT FOR STREAMS AND CONNECTIONS
#    File streams, database connections must always be wrapped in using.

# 8. IGNORING COMPILER WARNINGS
#    C# compiler warnings often point to real bugs.
#    Treat warnings as errors in production code:
#    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>

# 9. CONFUSION BETWEEN INT DIVISION AND DOUBLE DIVISION
#    int a = 7, b = 2;
#    int result = a / b;       → 3  (integer division, truncates)
#    double result = (double)a / b;  → 3.5  (floating point division)

# 10. USING FLOAT FOR MONEY
#    float and double are BINARY floating point — imprecise for money.
#    float price = 0.1f + 0.2f;   → 0.30000001 (NOT 0.3!)
#    ALWAYS use decimal for monetary values.
#    decimal price = 0.1m + 0.2m;  → 0.3 exactly

# =============================================================================
# PART 19 — CAREER & ECOSYSTEM
# =============================================================================

# -----------------------------------------------------------------------------
# 19.1 JOB MARKET FOR C# DEVELOPERS
# -----------------------------------------------------------------------------

# C# consistently ranks in top 5-10 most used programming languages.
# Stack Overflow Developer Survey typically shows C# at 25-30% usage.

# Industries that heavily use C#:
#   - Finance (banking, insurance, trading systems)
#   - Healthcare (hospital systems, medical devices)
#   - Government and defense
#   - Enterprise SaaS companies
#   - Game development (Unity studios)
#   - Manufacturing (industrial software, SCADA systems)
#   - Consulting (Microsoft stack shops)

# Typical roles:
#   - Backend developer (.NET, ASP.NET Core)
#   - Full-stack developer (Blazor or React + .NET API)
#   - Desktop developer (WPF, WinForms, MAUI)
#   - Game developer (Unity)
#   - DevOps / Cloud engineer (Azure-focused)
#   - Solutions architect

# Salaries:
#   Strong demand. Senior C# developers command competitive salaries.
#   Particularly well-compensated in finance and enterprise software.

# -----------------------------------------------------------------------------
# 19.2 LEARNING PATH
# -----------------------------------------------------------------------------

# BEGINNER (0-3 months):
#   1. C# syntax basics (types, operators, control flow)
#   2. OOP fundamentals (classes, inheritance, interfaces)
#   3. Collections (List, Dictionary)
#   4. Exception handling
#   5. File I/O
#   Resources:
#     - Microsoft Learn: https://learn.microsoft.com/en-us/dotnet/csharp/
#     - C# Yellow Book (free PDF) by Rob Miles
#     - CS50 Introduction to Programming with C#

# INTERMEDIATE (3-12 months):
#   1. LINQ
#   2. async/await
#   3. Generics
#   4. Entity Framework Core
#   5. ASP.NET Core Web API basics
#   6. Dependency Injection
#   7. Unit testing with xUnit/Moq
#   Resources:
#     - "C# in Depth" by Jon Skeet
#     - "Pro ASP.NET Core" by Adam Freeman
#     - Pluralsight C# path

# ADVANCED (12+ months):
#   1. Performance optimization (Span<T>, AOT, profiling)
#   2. Advanced patterns (CQRS, Event Sourcing, DDD)
#   3. Microservices (Docker, Kubernetes, message queues)
#   4. Security (JWT, OAuth, identity)
#   5. Distributed systems
#   Resources:
#     - "CLR via C#" by Jeffrey Richter (deep CLR internals)
#     - "Domain-Driven Design" by Eric Evans
#     - .NET Blog: https://devblogs.microsoft.com/dotnet/

# -----------------------------------------------------------------------------
# 19.3 IMPORTANT LIBRARIES TO KNOW
# -----------------------------------------------------------------------------

# WEB / API:
#   Serilog / NLog / Microsoft.Extensions.Logging  — structured logging
#   AutoMapper / Mapster                            — object-to-object mapping
#   FluentValidation                                — input validation
#   MediatR                                         — CQRS/mediator pattern
#   FastEndpoints                                   — alternative to minimal APIs
#   Carter                                          — minimal API module system
#   Refit                                           — typed HTTP clients
#   Polly                                           — resilience/retry policies

# DATABASE:
#   Entity Framework Core                           — primary ORM
#   Dapper                                          — micro ORM for raw SQL
#   NHibernate                                      — mature alternative ORM
#   Marten                                          — PostgreSQL document DB

# TESTING:
#   xUnit / NUnit / MSTest                          — test frameworks
#   Moq / NSubstitute / FakeItEasy                  — mocking
#   FluentAssertions                                — expressive assertions
#   Bogus                                           — fake data generation
#   WireMock.NET                                    — HTTP API mocking
#   Testcontainers                                  — Docker-based integration tests

# MESSAGING:
#   MassTransit                                     — message bus abstraction
#   RabbitMQ.Client                                 — RabbitMQ client
#   Azure.Messaging.ServiceBus                      — Azure Service Bus
#   Confluent.Kafka                                 — Kafka client
#   NServiceBus                                     — enterprise service bus

# CLOUD (Azure):
#   Azure.Identity                                  — Azure authentication
#   Azure.Storage.Blobs                             — Azure Blob Storage
#   Azure.Cosmos                                    — CosmosDB client
#   Microsoft.Azure.Functions.Worker                — Azure Functions

# UTILITIES:
#   Newtonsoft.Json                                 — mature JSON library
#   CsvHelper                                       — CSV reading/writing
#   iTextSharp / QuestPDF                           — PDF generation
#   ClosedXML                                       — Excel file manipulation
#   HangFire                                        — background jobs
#   Quartz.NET                                      — job scheduling
#   BenchmarkDotNet                                 — micro-benchmarking

# SECURITY:
#   BCrypt.Net                                      — password hashing
#   Microsoft.AspNetCore.Identity                   — full identity system
#   System.IdentityModel.Tokens.Jwt                 — JWT handling
#   IdentityServer / Duende IdentityServer          — OAuth2/OpenID Connect server

# -----------------------------------------------------------------------------
# 19.4 COMMUNITY RESOURCES
# -----------------------------------------------------------------------------

# Official Documentation:
#   https://docs.microsoft.com/en-us/dotnet/
#   https://docs.microsoft.com/en-us/dotnet/csharp/

# Blogs:
#   https://devblogs.microsoft.com/dotnet/         (official .NET blog)
#   https://andrewlock.net/                        (Andrew Lock — deep dives)
#   https://ardalis.com/blog                       (Steve Smith — patterns)
#   https://www.stevejgordon.co.uk/                (Steve Gordon — perf/internals)
#   https://haacked.com/                           (Phil Haack)
#   https://nickchapsas.com/                       (Nick Chapsas — YouTube)

# YouTube Channels:
#   Nick Chapsas                    — modern C# features, best practices
#   Tim Corey                       — practical tutorials
#   Raw Coding                      — advanced topics
#   IAmTimCorey                     — enterprise patterns

# Communities:
#   Reddit: r/csharp, r/dotnet
#   Stack Overflow: [c#] tag
#   Discord: C# Discord server
#   .NET Foundation: https://dotnetfoundation.org

# Conferences:
#   .NET Conf (free, online, November each year)
#   NDC Oslo / London
#   dotnet days

# Useful Online Tools:
#   SharpLab.io      — C# to CIL/decompiled output
#   LINQPad          — C# scripting and LINQ playground
#   dotnetfiddle.net — online C# runner
#   BenchmarkDotNet  — micro-benchmarking

# =============================================================================
# END OF GUIDE
# =============================================================================

# SUMMARY:
# ─────────────────────────────────────────────────────────────────────────────
# C# is a mature, performant, type-safe, multi-paradigm programming language.
# .NET is the unified, cross-platform, open-source runtime and BCL.
# Together they form one of the most complete and productive development
# platforms for building web APIs, desktop apps, mobile apps, games,
# cloud services, and more — all with world-class tooling and performance.
#
# Key strengths: strong typing, LINQ, async/await, performance, ecosystem
# Key weaknesses: verbose for scripts, Microsoft-centric, weaker in data science
#
# Best suited for: enterprise backends, APIs, desktop, Unity games
# Not the best for: pure data science, system programming, front-end
# ─────────────────────────────────────────────────────────────────────────────

echo "This is a documentation file — not meant to be executed."
echo "Read the comments for comprehensive C# and .NET guidance."
