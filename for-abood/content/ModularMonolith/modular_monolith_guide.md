# The Complete Guide to Modular Monolith Architecture

> Written for .NET Backend Engineers — From Zero to Production-Ready
>
> Real-World Example: Multi-Vendor E-Commerce Platform

==                                                                         ==
==        THE COMPLETE GUIDE TO MODULAR MONOLITH ARCHITECTURE             ==
==                                                                         ==
==   Written for .NET Backend Engineers — From Zero to Production-Ready   ==
==                                                                         ==
==   Real-World Example: Multi-Vendor E-Commerce Platform                 ==
==                                                                         ==


Author note: This guide assumes you are a .NET backend engineer who already
understands C#, ASP.NET Core, Entity Framework Core, dependency injection,
REST APIs, and has at least touched concepts like Clean Architecture or
Domain-Driven Design (DDD). Everything here is written from that perspective.

The goal is to give you a deep, honest, and complete understanding of what
a Modular Monolith is, when to use it, how to build it, and how it plays out
in a real-world Multi-Vendor E-Commerce system — from database design to
module communication to deployment.

If you've been told "just go microservices from day one", this guide will
challenge that idea seriously. If you're already on microservices and feeling
the pain, this guide will make you think.


## TABLE OF CONTENTS


  PART 1 — FOUNDATIONS
    1.1  What Is a Monolith?
    1.2  Why Monoliths Got a Bad Reputation
    1.3  What Is a Modular Monolith?
    1.4  The Spectrum: Monolith → Modular Monolith → Microservices
    1.5  The Big Three Architectures Compared in Detail

  PART 2 — CORE CONCEPTS AND THEORY
```
    2.1  What Is a Module? (The Real Definition)
    2.2  Bounded Contexts and Why They Matter Here
    2.3  Module Cohesion and Coupling
    2.4  Public vs Internal API of a Module
    2.5  The Dependency Rule in Modular Systems
    2.6  What is Module Autonomy?

```

  PART 3 — WHEN TO USE WHAT
    3.1  When to Choose a Traditional Monolith
    3.2  When to Choose a Modular Monolith
    3.3  When to Choose Microservices
    3.4  The Migration Path — How to Evolve
    3.5  Red Flags That Tell You Which to Pick

  PART 4 — BUILDING A MODULAR MONOLITH IN .NET
    4.1  Solution Structure — Folders vs Projects
```
    4.2  The Host Project (Startup / Composition Root)
    4.3  Module Structure — The Internal Layers
    4.4  Module Registration Pattern
    4.5  The Shared Kernel — What Goes There and What Doesn't
    4.6  Cross-Module Communication — In-Process Messaging
    4.7  Domain Events vs Integration Events
    4.8  The Internal Event Bus
    4.9  Database Strategy — Shared vs Separate Schemas
    4.10 Entity Framework Core in a Modular Setup
    4.11 Migrations Per Module
    4.12 The API Layer — One Entry Point, Many Modules
    4.13 Authentication and Authorization Per Module
    4.14 Background Jobs in a Modular System
    4.15 Logging, Observability, and Tracing

```

  PART 5 — THE MULTI-VENDOR E-COMMERCE SYSTEM (FULL EXAMPLE)
    5.1  Why This System and What It Covers
```
    5.2  Identifying the Bounded Contexts (Modules)
    5.3  Module: Identity & Access (IAM)
    5.4  Module: Catalog
    5.5  Module: Inventory
    5.6  Module: Ordering
    5.7  Module: Payment
    5.8  Module: Vendors
    5.9  Module: Reviews & Ratings
    5.10 Module: Notifications
    5.11 Module: Analytics
    5.12 The Shared Kernel in This System
    5.13 How Modules Talk to Each Other (Real Flows)
    5.14 The Database Design Per Module
    5.15 The Full Request Flow — Placing an Order
    5.16 The Full Request Flow — Vendor Onboarding

```

  PART 6 — ADVANCED PATTERNS
    6.1  CQRS Inside a Module
    6.2  The Outbox Pattern for Reliable Events
    6.3  Saga / Process Manager for Long-Running Flows
    6.4  Feature Flags Per Module
    6.5  Module Health Checks
    6.6  Rate Limiting and Throttling at the Module Level
    6.7  Caching Strategy Per Module

  PART 7 — TESTING A MODULAR MONOLITH
    7.1  Unit Testing Modules in Isolation
    7.2  Integration Testing With the Real Database
    7.3  Architecture Tests — Enforcing Module Boundaries
    7.4  Contract Tests Between Modules

  PART 8 — MIGRATION AND OPERATIONS
    8.1  Starting Greenfield — The Right Way
    8.2  Migrating a Big Ball of Mud to Modular
```
    8.3  Migrating from Modular Monolith to Microservices (When Ready)
    8.4  Deployment — Docker, Kubernetes, and Everything Else
    8.5  Scaling a Modular Monolith
    8.6  Zero Downtime Deployments

```

  PART 9 — WHAT NOT TO DO
    9.1  Common Mistakes When Building a Modular Monolith
    9.2  Anti-Patterns to Avoid Completely
    9.3  The Things That Make It Collapse

  PART 10 — SUMMARY AND DECISION FRAMEWORKS
    10.1 The Decision Checklist
    10.2 The Honest Tradeoffs Table
    10.3 Final Words


## PART 1 — FOUNDATIONS


### 1.1 WHAT IS A MONOLITH?


A monolith is a single deployable unit. Everything — all the features, all
the business logic, all the data access — is compiled and deployed together
as one artifact.

In .NET terms, imagine a single ASP.NET Core Web API project. You have:
- Controllers for Products, Orders, Users, Vendors, Payments all in one place
- One DbContext touching all the tables
- Services referencing other services freely
- One Program.cs wiring everything up
- One deployment pipeline producing one DLL / one Docker image

This is a monolith. It is NOT inherently bad. Thousands of massive, successful
systems run as monoliths. GitHub was a monolith for most of its life.
Shopify still runs on a modular monolith. Stack Overflow runs essentially as
a monolith. The problem is not "monolith" — the problem is "unstructured monolith."

The unstructured monolith (also called a "Big Ball of Mud") is the thing that
deserves its bad reputation. It's where:
- No clear separation of concerns exists
- Business logic is inside controllers or worse, inside EF queries
- Every service depends on every other service
- Adding a feature in Orders breaks something in Products
- Nobody knows where anything is
- The database is one giant schema with 300 tables nobody can map mentally

So the problem was never "single deployment." The problem was "no structure."

### 1.2 WHY MONOLITHS GOT A BAD REPUTATION


The hate for monoliths came from real pain — but that pain was caused by
bad practices, not the deployment model itself. Let's be precise here.

The real problems that caused the hatred:

(a) TIGHT COUPLING
    When every class references every other class, changing one thing
    breaks ten other things. This is a design failure, not a monolith failure.
    You can have the same problem in microservices too — it's called
    "distributed coupling" and it's much worse to debug.

(b) SHARED MUTABLE STATE
    When all features write to the same database tables, with no clear
    ownership, data gets corrupted, business rules get violated, and
    nobody knows which service "owns" a piece of data.

(c) LACK OF TEAM BOUNDARIES
    When 50 engineers are all changing the same codebase with no logical
    boundaries, merge conflicts are constant, deployments are scary, and
    you break each other's work daily.

(d) INABILITY TO SCALE INDEPENDENTLY
    When your Payment processing uses 10x more CPU than your Product browsing,
    but they're deployed together, you have to over-provision the whole thing.

(e) TECHNOLOGY LOCK-IN
    If you want to rewrite the Recommendation engine in Python with ML, you
    can't do it when it's baked into your C# monolith with no clear boundary.

Now — here is the critical insight:
Problems (a), (b), and (c) are solved by the MODULAR MONOLITH.
Problems (d) and (e) are solved by MICROSERVICES.

Most teams have problems (a), (b), and (c). Very few at early/mid stage
have problem (d) or (e) at a scale that justifies microservices.
This is why modular monolith is almost always the right starting point.

### 1.3 WHAT IS A MODULAR MONOLITH?


A Modular Monolith is a single deployable unit — like a traditional monolith —
but organized into strongly isolated modules with well-defined boundaries,
explicit public contracts, and enforced rules about inter-module communication.

The key properties are:

(1) SINGLE DEPLOYMENT
    Still one application, one Docker image, one deployment pipeline.
    No network hops between modules. No distributed system complexity.

(2) STRONG MODULE ISOLATION
    Each module owns its own:
      - Business logic (Domain layer)
      - Data access (its own DbContext or schema)
      - API endpoints (its own controllers)
      - Configuration
      - Tests
    No module reaches into another module's internals. Ever.

(3) EXPLICIT PUBLIC CONTRACTS
    If Module A needs something from Module B, it can only access it through
```
    Module B's explicitly defined public interface — an interface, a contract,
    a Facade — never by importing Module B's internal classes directly.

```

(4) IN-PROCESS COMMUNICATION
```
    Modules talk to each other through in-process events (no HTTP, no queues
    — just method calls or an in-memory event bus). This is fast, simple,
    and doesn't require distributed transaction management.

```

(5) INDEPENDENT EVOLVABILITY
    Because modules are isolated, a team can work on the Orders module
    without touching the Catalog module. They can change internal
```
    implementation details freely as long as the public contract stays stable.

```

In .NET terms, this usually means:
- One Solution (.sln file)
- Multiple C# Projects — one per module (or a folder-based approach)
- Each module has its own classes folder structure: Domain, Application,
    Infrastructure, and a thin API/Endpoints layer
- Each module registers its own services in DI
- Each module has its own EF Core DbContext and its own database schema
- Modules communicate via an in-memory mediator or event bus
- Architecture tests enforce that no module imports another module's internals

### 1.4 THE SPECTRUM: MONOLITH → MODULAR MONOLITH → MICROSERVICES


Think of this as a dial, not an on/off switch.

 [Traditional Monolith] ────── [Modular Monolith] ────── [Microservices]

  One codebase,               One codebase,              Many codebases,
  no boundaries,              strong internal             separate deploys,
  tightly coupled             boundaries,                 network comms,
                              in-process comms            independent scaling

  Team Size: 1-10             Team Size: 5-80             Team Size: 50-500+
  Complexity: Low             Complexity: Medium          Complexity: High
  Ops Overhead: Very Low      Ops Overhead: Low           Ops Overhead: Very High
  Performance: Highest        Performance: High           Performance: Network cost
  Development Speed: Fast     Dev Speed: Fast-Medium      Dev Speed: Slow initially

The critical thing to understand is that a well-built Modular Monolith is
designed so that individual modules CAN be extracted into microservices later
— if and when you actually need to. This is not a trap, it's the exit ramp.

The Modular Monolith is the most practical sweet spot for the majority of
business applications in the real world.

### 1.5 THE BIG THREE ARCHITECTURES COMPARED IN DETAIL


Let's be really specific and compare all three for someone building a
multi-vendor e-commerce platform.

┌─────────────────────┬──────────────────┬──────────────────┬────────────────────┐
│ DIMENSION           │ TRAD. MONOLITH   │ MODULAR MONOLITH │ MICROSERVICES      │
├─────────────────────┼──────────────────┼──────────────────┼────────────────────┤
│ Deployment Unit     │ 1 application    │ 1 application    │ 10+ applications   │
│ Network Calls       │ None internal    │ None internal    │ Many internal      │
│ Data Isolation      │ None             │ Schema per module│ DB per service     │
│ Team Independence   │ Very Low         │ Medium-High      │ Very High          │
│ Testing Complexity  │ Low              │ Medium           │ Very High          │
│ Ops Complexity      │ Very Low         │ Low              │ Very High          │
│ Distributed Tracing │ Not needed       │ Not needed       │ Required           │
│ Service Mesh        │ Not needed       │ Not needed       │ Often needed       │
│ Module Extraction   │ Very Hard        │ Straightforward  │ Already done       │
│ Transaction Safety  │ Easy (1 DB)      │ Easy (schemas)   │ Hard (Saga needed) │
│ Shared Code        │ Easy, no rules   │ Shared Kernel    │ Shared libs (risky)│
│ Deployment Time    │ Fast             │ Fast             │ Slow (many pipelines)│
│ Local Dev Setup    │ Trivial          │ Trivial          │ Docker Compose hell │
│ Debugging          │ Trivial          │ Easy             │ Distributed logs   │
│ Scaling            │ Scale whole app  │ Scale whole app  │ Scale per service  │
│ Tech Heterogeneity │ No               │ No (same process)│ Yes (per service)  │
│ Latency            │ Zero (in-process)│ Zero (in-process)│ Network latency    │
└─────────────────────┴──────────────────┴──────────────────┴────────────────────┘

For a multi-vendor e-commerce platform starting out, the Modular Monolith
gives you most of the benefits of microservices (team isolation, clear
boundaries, independent module evolution) without the enormous operational
overhead. You pay for microservices complexity with engineer time and
infrastructure cost — time that could be spent building features.

## PART 2 — CORE CONCEPTS AND THEORY


### 2.1 WHAT IS A MODULE? (THE REAL DEFINITION)


This is the question most guides get wrong. They say "a module is a feature"
or "a module is a layer" — both of which are incorrect.

A MODULE is a cohesive unit of business capability. It contains everything
needed to fulfill one specific business concern, end-to-end.

A module is NOT:
- A layer (not "the data access layer" or "the service layer")
- A technical grouping (not "all the authentication code" in one folder)
- A feature (not "the search feature")

A module IS:
- A complete vertical slice of a bounded context
- Self-contained with its own domain model, data, logic, and API
- Identifiable by a business name that a non-technical stakeholder would recognize

Examples of CORRECT module definitions for our e-commerce system:
- Catalog     (everything about product listings, categories, product data)
- Ordering    (everything about creating, modifying, canceling orders)
- Payment     (everything about charging, refunding, payment methods)
- Vendors     (everything about vendor accounts, their products, their earnings)
- Inventory   (everything about stock levels, reservations, warehouse locations)
- Identity    (everything about users, login, permissions, sessions)
- Reviews     (everything about ratings, reviews, moderation)
- Notifications (everything about emails, SMS, push notifications)

Each of these is a world unto itself. A business analyst who knows e-commerce
would instantly understand what belongs in each one.

How to identify your module boundaries:
  Ask: "If I had a dedicated team of 3-5 engineers, what would they own?"
  Ask: "What changes together? What changes independently?"
  Ask: "What would break if I deployed this independently?"
  Ask: "Where do business rules live that are only relevant to one area?"

Conway's Law: Your modules will mirror your team structure.
If you have a Catalog team and an Orders team, you'll naturally have a
Catalog module and an Orders module. Lean into this.

### 2.2 BOUNDED CONTEXTS AND WHY THEY MATTER HERE


This term comes from Domain-Driven Design (DDD). A Bounded Context is a
boundary within which a particular domain model applies and is consistent.

The classic example: What is a "Product"?

In the CATALOG context: A product has a name, description, images, categories,
SEO metadata, vendor information, pricing tiers, and specifications.

In the INVENTORY context: A product is just a SKU with a quantity, a warehouse
location, a reorder threshold, and a reservation count. The description doesn't matter.

In the ORDERING context: A product is a line item with a price at time of order,
a quantity ordered, and a reference ID. The categories don't matter.

In the PAYMENT context: A product doesn't really exist at all. Payment cares
about money amounts, payment methods, and transaction IDs.

This is the core insight: THE SAME "THING" MEANS DIFFERENT THINGS IN DIFFERENT
CONTEXTS. If you try to create one unified "Product" class that satisfies all
contexts, you get a bloated nightmare with 200 properties. Instead, each module
has its OWN representation of a product — small and focused on what IT needs.

In .NET, this means:
- Catalog module has: CatalogProduct (with all the listing data)
- Inventory module has: InventorySku (with stock data only)
- Ordering module has: OrderLineItem (with price snapshot only)

They share a ProductId (a simple GUID value object in the Shared Kernel),
but each module's internal representation is completely separate.

When you see bounded contexts clearly, module design becomes natural.
The boundaries ARE the bounded contexts.

### 2.3 MODULE COHESION AND COUPLING


Two measures that define how well your modules are designed:

COHESION = How related are the things INSIDE a module?
High cohesion = everything inside the module belongs together.
Low cohesion = stuff got lumped together for convenience, not logical reason.

COUPLING = How dependent are modules on EACH OTHER?
Low coupling = modules barely need to know each other exist.
High coupling = changing one module requires changing several others.

You want: HIGH COHESION within modules, LOW COUPLING between modules.

Signs of LOW COHESION (bad):
- Your "Catalog" module has order management logic in it
- Your "Orders" module sends emails directly
- Your "Vendors" module manages payment processing
- A module is hard to name with one clear noun

Signs of HIGH COUPLING (bad):
- The Orders module directly imports and uses OrderRepository from Catalog
- Changing the Catalog schema requires changing the Orders queries
- You can't test Orders without loading the Catalog
- A module's constructor requires 15 dependencies from other modules

In practical .NET terms, you measure coupling by looking at project references.
If your Orders.csproj file has a reference to Catalog.csproj that goes into
Catalog's internal domain objects — that's high coupling. That's forbidden.
The ONLY reference allowed is to Catalog's public contract/facade project.

### 2.4 PUBLIC VS INTERNAL API OF A MODULE


Every module has two faces:

THE PUBLIC API (the contract):
- What the module exposes to other modules and to the outside world
- Interfaces, DTOs (Data Transfer Objects), contracts, event definitions
- Should be small, stable, and thoughtfully designed
- Changes to this are BREAKING CHANGES and must be versioned carefully
- In .NET, this lives in a dedicated "Contracts" or "PublicApi" project/folder

**THE INTERNAL IMPLEMENTATION:**
- Everything else — domain entities, repositories, services, EF contexts
- Only visible within the module
- Can change freely without affecting other modules
- In .NET, internal classes should use the `internal` access modifier

Example for the Catalog module:

PUBLIC (Catalog.Contracts project):
- interface ICatalogModule
- record ProductSummaryDto(Guid ProductId, string Name, decimal Price)
- class ProductCreatedEvent (the event other modules can subscribe to)
- class GetProductQuery (a query other modules can send)

INTERNAL (Catalog project — only Catalog's code):
- class Product (domain entity with all business rules)
- class CatalogDbContext (EF Core context)
- class ProductRepository
- class CategoryService
- class ProductSpecification (EF specification pattern)
- class CatalogSeedData

The contract between modules is sacred. Treat it like a public API that
external teams (or in the future, separate services) will depend on.
Design it carefully. Keep it minimal.

### 2.5 THE DEPENDENCY RULE IN MODULAR SYSTEMS


The fundamental rule that must be enforced (ideally by automated architecture tests):

**MODULE A CAN DEPEND ON:**
- ✅ The Shared Kernel (common abstractions, value objects)
- ✅ Module B's PUBLIC CONTRACT (the Contracts project, never internals)
- ✅ Its own internal components

**MODULE A CANNOT DEPEND ON:**
- ❌ Module B's internal domain entities
- ❌ Module B's repositories or DbContext
- ❌ Module B's internal services or application logic
- ❌ Module B's EF Core migration files

Example: Orders module needs to know about a product's price.

**WRONG:**
  // In Orders module — DO NOT DO THIS
  using Catalog.Domain.Entities; // Importing Catalog's internal entity!
  var product = _catalogDbContext.Products.Find(productId); // Accessing Catalog's DB!

**RIGHT:**
  // In Orders module — This is correct
  using Catalog.Contracts; // Importing only the public contract
  var productInfo = await _catalogModule.GetProductAsync(productId); // Public facade call
  // OR via an in-process event that carries the needed data

This rule — never cross the boundary into another module's internals — is
THE rule of modular monolith. Everything else is secondary. If you maintain
this rule, your architecture is sound. If you break it, you have a ball of mud.

In .NET, enforce this with:
- Project reference restrictions (Orders.csproj should never reference Catalog.csproj directly)
- Only reference Catalog.Contracts.csproj
- Use NetArchTest or ArchUnitNET in your test suite to verify this at build time

### 2.6 WHAT IS MODULE AUTONOMY?


Autonomy means: a module can do its job without asking other modules for help
at runtime, in most cases.

A highly autonomous module:
- Has all the data it needs stored locally (in its own schema)
- Makes decisions based on its own domain rules without calling other modules
- Only communicates with other modules to announce what happened (events)
```
    or to ask for rare information lookups (public facade calls)

```

Autonomy is achieved through DATA DUPLICATION across modules.
This sounds wrong at first. Developers hate duplication.
But in distributed system design (and modular design), this is intentional.

Example:
When an order is placed, the Orders module needs the vendor's name to display
on the receipt. The vendor's name is owned by the Vendors module.

Low-autonomy (bad): Orders queries Vendors every time it needs to display the receipt.
High-autonomy (good): When a vendor is registered, the Vendors module emits a
VendorRegisteredEvent. The Orders module listens to it and stores a local copy of
the vendor name in its own database. Now Orders never needs to call Vendors again.

Yes, the vendor name is stored in two places. Yes, they could get out of sync
(the Vendors module should emit an event when the name changes too). But the
Orders module is now AUTONOMOUS — it doesn't have a runtime dependency on the
Vendors module being available.

This is the foundation of both modular monoliths and microservices:
Data duplication + eventual consistency beats tight coupling every time.

## PART 3 — WHEN TO USE WHAT


### 3.1 WHEN TO CHOOSE A TRADITIONAL MONOLITH


Despite everything said here, the traditional (unstructured) monolith has
its place. Be honest about when you're there.

**CHOOSE A TRADITIONAL MONOLITH WHEN:**

(a) You're validating an idea / MVP stage
    You have 0-5 engineers. You're not sure the business will survive the year.
    Every day without a working product costs you customers. Go fast. Worry
    about architecture when you have product-market fit and a reason to scale.
    Build it quick and dirty, but DOCUMENT where the boundaries should be.

(b) The domain is simple and unlikely to grow
    A simple internal tool for 50 employees. A report generator. A webhook
    handler. An admin panel. Not everything is a complex domain.

(c) Your team is 1-3 engineers
    With a tiny team, the overhead of defining module boundaries, contracts,
    and event systems adds more friction than it removes. Keep it simple.

(d) Time to market is everything and technical debt is acceptable
    Sometimes business requirements mean you must ship in 3 weeks.
    Ship the thing. Refactor later. Just don't stay in this mode for years.

**WHAT TO DO WHEN IN A TRADITIONAL MONOLITH:**
- Use folders that represent future modules (even if they're not enforced)
- Don't create circular dependencies even within the same project
- Keep business logic out of controllers
- This makes migration to modular MUCH easier when the time comes

### 3.2 WHEN TO CHOOSE A MODULAR MONOLITH


This is the sweet spot for most professional software systems.

**CHOOSE A MODULAR MONOLITH WHEN:**

(a) You have a complex domain with multiple distinct business areas
    Multi-vendor e-commerce, SaaS platforms, ERP systems, healthcare systems,
    insurance platforms, CRM systems — any system where the business naturally
    divides into distinct, semi-independent concerns.

(b) You have 5-80 engineers (or more, depending on organization)
    Big enough to need team isolation and clear ownership. Small enough that
    the operational overhead of microservices would slow you down significantly.

(c) You want to move fast while keeping the codebase maintainable
    A modular monolith deploys in minutes. Local development is a single
    "dotnet run" command. Debugging is just attaching a debugger. Fast iteration.

(d) You're starting a new system and want to do it right
    If you have the luxury of building greenfield, a modular monolith with
    DDD-aligned modules gives you the best foundation. You can always split
    later when you have real data about bottlenecks.

(e) Your team doesn't yet have microservices operational expertise
    Kubernetes, service meshes, distributed tracing, eventual consistency bugs,
    network timeout handling, idempotency, API versioning across services — all
    of this requires significant expertise to do right. If you don't have it,
    microservices will hurt you. The modular monolith doesn't require this.

(f) Transactional consistency is critical across multiple business operations
```
    In a modular monolith, all modules share one database server (even if
    different schemas). Cross-schema transactions are possible. In microservices,
    you need Sagas, 2-phase commits, or you accept inconsistency. A modular
    monolith lets you have ACID transactions where needed.

```

**WHAT NOT TO EXPECT FROM A MODULAR MONOLITH:**
- Independent scaling of individual modules (you scale the whole app)
- Different technology stacks per module (everything is .NET)
- Zero-downtime deployment of individual modules (all modules deploy together)
- Total team independence at the repository level (everyone shares one repo)

### 3.3 WHEN TO CHOOSE MICROSERVICES


Be honest. Very few systems actually need microservices from the start.
But some do, and here's when.

**CHOOSE MICROSERVICES WHEN:**

(a) You have proven, specific scaling requirements for individual components
    Your Payment service processes 100,000 transactions per second and needs
    dedicated hardware. Your Recommendation engine runs ML models and needs GPUs.
    Your Search service needs Elasticsearch tuned specifically for it.
    These are SPECIFIC, MEASURED scaling needs — not theoretical ones.

(b) You need true technology heterogeneity
    The ML team wants Python. The real-time notification team wants Go.
```
    The core business logic team wants .NET. If this is a real need (not
    just engineer preference), microservices enable it.

```

(c) You have genuinely independent deployment requirements
    Different services need to deploy at different frequencies. The Marketing
    team's landing page deploys 20 times a day. The Core Payment system deploys
    once a month with heavy regression testing. Putting them together creates
    coordination overhead that microservices eliminate.

(d) You have separate compliance/regulatory requirements per component
    PCI-DSS compliance for payment. HIPAA for health data. Isolating these
    into separate services with separate infrastructure reduces compliance scope.

(e) Your system is already a working modular monolith with proven boundaries
    You've built it modular, you've measured where the bottlenecks are, and
    you've identified which modules genuinely need to be extracted. NOW extract
    them. The boundaries are already defined and tested.

**WHAT NOT TO DO WITH MICROSERVICES:**
- ❌ Don't start with microservices. You don't know your domain well enough yet.
- ❌ Don't make a microservice per CRUD resource (that's just HTTP calls to a DB)
- ❌ Don't make every service call every other service (distributed monolith)
- ❌ Don't share databases between microservices (you lose the whole point)
- ❌ Don't do synchronous HTTP calls everywhere (use async messaging instead)

### 3.4 THE MIGRATION PATH — HOW TO EVOLVE


The intended evolution path looks like this:

STAGE 1: Traditional Monolith (MVP, 0-12 months)
- Ship fast, validate ideas, get customers
- Use folder conventions to hint at future module boundaries
- Keep business logic out of controllers (even now)

STAGE 2: Modular Monolith (Growth, 1-5 years typically)
- Formalize the module boundaries that emerged naturally
- Introduce the shared kernel, module contracts, event bus
- Enforce boundaries with architecture tests
- Separate database schemas per module
- Teams can work independently within the monolith

STAGE 3: Selective Service Extraction (Scale, when measured need exists)
- Identify the ONE module that genuinely needs independent scaling or deployment
- Extract THAT ONE module into a microservice
- Change in-process events to real queues (RabbitMQ, Azure Service Bus, etc.)
- Replace facade calls with HTTP or gRPC
- The rest stays as the modular monolith
- Repeat for other modules only as needed

Stage 3 can happen gradually over years. You might extract 2-3 modules
and keep everything else in the modular monolith forever. That's fine.
Netflix didn't wake up one day and go full microservices — it took years
of gradual extraction from a working monolith.

The modular monolith is the best foundation for this journey because:
- Module boundaries are already defined and tested
- Data ownership is already clear (each module owns its schema)
- Event contracts are already defined (just swap in-process for queue)
- Public interfaces are already stable (just expose them as HTTP/gRPC)

### 3.5 RED FLAGS THAT TELL YOU WHICH TO PICK


PICK TRADITIONAL MONOLITH if any of these are true:
- 🚩 "We need to ship something in 4 weeks to get funding"
- 🚩 "We have 2 engineers and a part-time designer"
- 🚩 "We're not sure exactly what the product will look like yet"
- 🚩 "We'll rebuild it properly once we have revenue"

PICK MODULAR MONOLITH if any of these are true:
- 🚩 "We have 10 engineers working on different areas and stepping on each other"
- 🚩 "Every deployment is terrifying because it can break anything"
- 🚩 "We can't test one area without the whole system running"
- 🚩 "Nobody knows what this 5,000-class service is doing"
- 🚩 "New engineers take 3 months to become productive because the codebase is overwhelming"
- 🚩 "We want to extract some services to microservices but don't know where to cut"

PICK MICROSERVICES if any of these are true:
- 🚩 "Our Payment processing team needs to deploy 50 times a day independently"
- 🚩 "We've measured that only the Recommendation engine needs to scale, not everything"
- 🚩 "Our ML team writes Python and our core team writes .NET — they work on the same component"
- 🚩 "We're a 200-person engineering org with 15 product teams"
- 🚩 "We already have a mature modular monolith and have identified the modules that need extraction"

## PART 4 — BUILDING A MODULAR MONOLITH IN .NET


### 4.1 SOLUTION STRUCTURE — FOLDERS VS PROJECTS


The first decision you make is how to physically organize the code.
There are two approaches:

**APPROACH 1: ONE .CSPROJ PER MODULE (Strongly Recommended)**

  ECommerceApp.sln
  │
  ├── src/
  │   ├── Host/                           (The startup project — thin shell)
  │   │   └── ECommerceApp.Host.csproj
  │   │
  │   ├── Shared/
  │   │   └── ECommerceApp.Shared.csproj  (The Shared Kernel)
  │   │
  │   ├── Modules/
  │   │   ├── Catalog/
  │   │   │   ├── ECommerceApp.Modules.Catalog.csproj         (internals)
  │   │   │   └── ECommerceApp.Modules.Catalog.Contracts.csproj (public API)
  │   │   │
  │   │   ├── Ordering/
  │   │   │   ├── ECommerceApp.Modules.Ordering.csproj
  │   │   │   └── ECommerceApp.Modules.Ordering.Contracts.csproj
  │   │   │
  │   │   ├── Payment/
  │   │   │   ├── ECommerceApp.Modules.Payment.csproj
  │   │   │   └── ECommerceApp.Modules.Payment.Contracts.csproj
  │   │   │
  │   │   ├── Vendors/
  │   │   │   ├── ECommerceApp.Modules.Vendors.csproj
  │   │   │   └── ECommerceApp.Modules.Vendors.Contracts.csproj
  │   │   │
  │   │   ├── Inventory/
  │   │   │   ├── ECommerceApp.Modules.Inventory.csproj
  │   │   │   └── ECommerceApp.Modules.Inventory.Contracts.csproj
  │   │   │
  │   │   ├── Identity/
  │   │   │   ├── ECommerceApp.Modules.Identity.csproj
  │   │   │   └── ECommerceApp.Modules.Identity.Contracts.csproj
  │   │   │
  │   │   ├── Reviews/
  │   │   │   ├── ECommerceApp.Modules.Reviews.csproj
  │   │   │   └── ECommerceApp.Modules.Reviews.Contracts.csproj
  │   │   │
  │   │   └── Notifications/
  │   │       └── ECommerceApp.Modules.Notifications.csproj
  │   │
  └── tests/
      ├── ECommerceApp.Tests.Architecture.csproj   (boundary enforcement)
      ├── ECommerceApp.Modules.Catalog.Tests.csproj
      ├── ECommerceApp.Modules.Ordering.Tests.csproj
      └── ECommerceApp.Integration.Tests.csproj

WHY SEPARATE .CSPROJ FILES?
- The .NET compiler enforces references between projects
- If Orders.csproj has no reference to Catalog.csproj, the compiler
    PHYSICALLY PREVENTS Orders code from using Catalog internals
- This is the strongest possible boundary enforcement — the compiler is your guard
- It makes the dependency graph explicit and visible in the Solution Explorer

**APPROACH 2: SINGLE PROJECT WITH FOLDER CONVENTIONS (Simpler Start)**

  ECommerceApp.sln
  └── src/
      └── ECommerceApp/
          ├── ECommerceApp.csproj   (one project)
          ├── Shared/
          └── Modules/
              ├── Catalog/
              ├── Ordering/
              └── Payment/

This is simpler to start with but requires architecture tests to enforce
boundaries (since the compiler won't — everything is in one project).
This is a good stepping stone from a traditional monolith.
Eventually migrate to Approach 1 for stronger enforcement.

For our e-commerce example, we'll use Approach 1.

### 4.2 THE HOST PROJECT (STARTUP / COMPOSITION ROOT)


The Host project is the entry point of the application. It is intentionally
THIN. Its only job is to compose the application from its modules.

Think of it as the conductor of an orchestra — it doesn't play music,
it coordinates who plays what and when.

What the Host project contains:
- Program.cs (the startup file)
- appsettings.json (configuration)
- Middleware registration
- Module registration calls
- No business logic. None. Zero.

Program.cs in the Host project looks like this (pseudocode, .NET 8 style):

  var builder = WebApplication.CreateBuilder(args);

  // Register each module's services
  builder.Services.AddCatalogModule(builder.Configuration);
  builder.Services.AddOrderingModule(builder.Configuration);
  builder.Services.AddPaymentModule(builder.Configuration);
  builder.Services.AddVendorsModule(builder.Configuration);
  builder.Services.AddInventoryModule(builder.Configuration);
  builder.Services.AddIdentityModule(builder.Configuration);
  builder.Services.AddReviewsModule(builder.Configuration);
  builder.Services.AddNotificationsModule(builder.Configuration);

  // Register the shared event bus
  builder.Services.AddInternalEventBus();

  // Register Swagger, CORS, authentication etc.
  builder.Services.AddSharedInfrastructure(builder.Configuration);

  var app = builder.Build();

  // Apply each module's middleware and endpoints
  app.UseCatalogModule();
  app.UseOrderingModule();
  app.UsePaymentModule();
  // ...etc

  app.Run();

Notice that the Host project KNOWS about all modules (it imports them to
call AddXxxModule). But modules do NOT know about each other. The Host
is the only place where everything is wired together.

The Host project's .csproj references ALL module projects:
  <ItemGroup>
    <ProjectReference Include="..\Modules\Catalog\ECommerceApp.Modules.Catalog.csproj" />
    <ProjectReference Include="..\Modules\Ordering\ECommerceApp.Modules.Ordering.csproj" />
    <ProjectReference Include="..\Modules\Payment\ECommerceApp.Modules.Payment.csproj" />
    ...
  </ItemGroup>

But NO module project has a reference to another module project.
They only reference the Shared Kernel and Contracts projects.

### 4.3 MODULE STRUCTURE — THE INTERNAL LAYERS


Each module internally follows a clean layered architecture.
In .NET, following Clean Architecture / Onion Architecture within each module
gives you the best result.

INTERNAL STRUCTURE OF, FOR EXAMPLE, THE ORDERING MODULE:

  Modules/Ordering/
  ├── ECommerceApp.Modules.Ordering.Contracts/   (Public API)
  │   ├── IOrderingModule.cs                     (public facade interface)
  │   ├── Dtos/
  │   │   ├── OrderSummaryDto.cs
  │   │   └── CreateOrderRequestDto.cs
  │   └── Events/
  │       ├── OrderPlacedEvent.cs
  │       ├── OrderCancelledEvent.cs
  │       └── OrderFulfilledEvent.cs
  │
  └── ECommerceApp.Modules.Ordering/             (Internal Implementation)
      ├── Domain/
      │   ├── Entities/
      │   │   ├── Order.cs                       (Aggregate Root)
      │   │   ├── OrderLine.cs                   (Entity)
      │   │   └── OrderStatus.cs                 (Enum/Value Object)
      │   ├── ValueObjects/
      │   │   ├── Money.cs
      │   │   ├── Address.cs
      │   │   └── OrderId.cs
      │   ├── Events/                            (Domain events — internal)
      │   │   └── OrderPlacedDomainEvent.cs
      │   └── Repositories/
      │       └── IOrderRepository.cs            (interface, no implementation)
      │
      ├── Application/
      │   ├── Commands/
      │   │   ├── PlaceOrder/
      │   │   │   ├── PlaceOrderCommand.cs
      │   │   │   └── PlaceOrderCommandHandler.cs
      │   │   └── CancelOrder/
      │   │       ├── CancelOrderCommand.cs
      │   │       └── CancelOrderCommandHandler.cs
      │   ├── Queries/
      │   │   ├── GetOrder/
      │   │   │   ├── GetOrderQuery.cs
      │   │   │   └── GetOrderQueryHandler.cs
      │   │   └── GetCustomerOrders/
      │   │       ├── GetCustomerOrdersQuery.cs
      │   │       └── GetCustomerOrdersQueryHandler.cs
      │   ├── EventHandlers/                     (handles events from other modules)
      │   │   ├── PaymentConfirmedEventHandler.cs
      │   │   └── InventoryReservedEventHandler.cs
      │   └── Services/
      │       └── OrderingModuleFacade.cs        (implements IOrderingModule)
      │
      ├── Infrastructure/
      │   ├── Persistence/
      │   │   ├── OrderingDbContext.cs            (EF Core DbContext)
      │   │   ├── Configurations/
      │   │   │   ├── OrderConfiguration.cs      (IEntityTypeConfiguration)
      │   │   │   └── OrderLineConfiguration.cs
      │   │   ├── Repositories/
      │   │   │   └── OrderRepository.cs         (EF implementation of IOrderRepository)
      │   │   └── Migrations/                    (EF migrations for this module only)
      │   └── ExternalServices/
      │       └── InventoryServiceClient.cs      (calls Inventory module's facade)
      │
      └── Presentation/
          ├── OrdersController.cs                (ASP.NET Core controller)
          ├── OrderingExtensions.cs              (AddOrderingModule, UseOrderingModule)
          └── OrderingEndpoints.cs               (Minimal API endpoints, alternative)

This structure is intentional:

DOMAIN layer:
- Pure C# — no dependencies on EF, ASP.NET, or any framework
- Contains the most important business rules
- The Order aggregate root enforces all order-related invariants
- Domain events are raised HERE (not in application or infrastructure)

APPLICATION layer:
- Orchestrates domain objects to fulfill use cases
- Uses MediatR (or any mediator) for CQRS commands and queries
- References domain interfaces (IOrderRepository) but not implementations
- Converts domain events to integration events (for other modules)

INFRASTRUCTURE layer:
- The "dirty" layer — deals with databases, external services, EF Core
- OrderingDbContext maps domain entities to database tables
- Repositories implement the domain interfaces
- External service clients call other modules' public facades

PRESENTATION layer:
- ASP.NET Core controllers or Minimal API endpoints
- Receives HTTP requests, sends MediatR commands/queries, returns responses
- Very thin — no business logic, just HTTP plumbing

### 4.4 MODULE REGISTRATION PATTERN


Every module exposes a clean extension method for service registration.
This is the .NET DI pattern used throughout ASP.NET Core ecosystem.

Example: OrderingExtensions.cs (inside Ordering module's Presentation layer)

  public static class OrderingExtensions
  {
      public static IServiceCollection AddOrderingModule(
          this IServiceCollection services,
          IConfiguration configuration)
      {
          // Register the EF Core DbContext for this module
          services.AddDbContext<OrderingDbContext>(options =>
              options.UseSqlServer(
                  configuration.GetConnectionString("DefaultConnection"),
                  sql => sql.MigrationsHistoryTable("__EFMigrationsHistory", "ordering")));

          // Register domain repositories
          services.AddScoped<IOrderRepository, OrderRepository>();

          // Register application services
          services.AddScoped<IOrderingModule, OrderingModuleFacade>();

          // Register MediatR handlers from this module's assembly
          services.AddMediatR(cfg =>
              cfg.RegisterServicesFromAssembly(typeof(OrderingExtensions).Assembly));

          // Register module-specific validators (FluentValidation)
          services.AddValidatorsFromAssembly(typeof(OrderingExtensions).Assembly);

          // Register background jobs specific to this module
          services.AddHostedService<OrderTimeoutBackgroundService>();

          return services;
      }

      public static IApplicationBuilder UseOrderingModule(
          this IApplicationBuilder app)
      {
          // Run any module-specific middleware
          // Apply migrations on startup (development only)
          using var scope = app.ApplicationServices.CreateScope();
          var db = scope.ServiceProvider.GetRequiredService<OrderingDbContext>();
          db.Database.Migrate();

          return app;
      }

      public static IEndpointRouteBuilder MapOrderingEndpoints(
          this IEndpointRouteBuilder endpoints)
      {
          // Register this module's API endpoints
          endpoints.MapGroup("/api/orders")
              .MapOrderEndpoints()
              .RequireAuthorization();
          return endpoints;
      }
  }

Why this pattern is beautiful:
- Each module is self-contained in its configuration
- The Host just calls the extension methods — it doesn't know internals
- Adding a new module means adding ONE LINE to Program.cs
- Removing a module means removing ONE LINE from Program.cs
- No global service registration that mixes all modules together

### 4.5 THE SHARED KERNEL — WHAT GOES THERE AND WHAT DOESN'T


The Shared Kernel is a set of code that ALL modules can use.
It is NOT where you dump common business logic. It's for purely technical
and fundamental domain abstractions.

**WHAT BELONGS IN THE SHARED KERNEL:**

- ✅ Value Object base class
     public abstract class ValueObject { ... }

- ✅ Entity base class
     public abstract class Entity<TId> { ... }

- ✅ Aggregate Root base class (with domain event collection)
     public abstract class AggregateRoot<TId> : Entity<TId>
     { List<IDomainEvent> _domainEvents; ... }

- ✅ Domain Event interface
     public interface IDomainEvent { ... }

- ✅ Integration Event interface (for cross-module communication)
     public interface IIntegrationEvent { Guid Id; DateTime OccurredOn; }

- ✅ IIntegrationEventBus interface (the event bus abstraction)
     public interface IIntegrationEventBus
     { Task PublishAsync<T>(T @event) where T : IIntegrationEvent; }

- ✅ IEventHandler<T> interface
     public interface IIntegrationEventHandler<T> where T : IIntegrationEvent
     { Task HandleAsync(T @event, CancellationToken ct); }

- ✅ Common value objects used across modules
     - Money.cs (amount + currency)
     - Address.cs (shipping address)
     - UserId.cs (strongly-typed user identifier)
     - ProductId.cs (strongly-typed product identifier)
     Note: Only IDs and truly universal concepts go here

- ✅ Result pattern / Error types
     public record Result<T>(T Value, Error Error, bool IsSuccess);

- ✅ Pagination types
     public record PagedResult<T>(IReadOnlyList<T> Items, int TotalCount, int Page);

- ✅ Common exceptions
     public class NotFoundException : Exception { ... }
     public class ValidationException : Exception { ... }

**WHAT DOES NOT BELONG IN THE SHARED KERNEL:**

- ❌ Business logic from any specific module
     (ProductPricing logic, OrderDiscount logic, etc.)

- ❌ Database entities from any module
     (No Order entity, no Product entity in Shared)

- ❌ Module-specific services or repositories

- ❌ "Utility" classes that grew because someone was lazy
     (The Shared Kernel is not a dumping ground)

- ❌ Specific DTOs from any module
     (Those belong in the module's Contracts project)

CRITICAL RULE: The Shared Kernel should change rarely.
If you're adding things to it every week, something is wrong.
Business logic is bleeding into the shared layer. Push it back to modules.

The Shared Kernel in a .NET project is typically a single, small project:
  ECommerceApp.Shared.csproj
  ├── Abstractions/
  │   ├── Entity.cs
  │   ├── AggregateRoot.cs
  │   ├── ValueObject.cs
  │   ├── IDomainEvent.cs
  │   └── IIntegrationEvent.cs
  ├── EventBus/
  │   ├── IIntegrationEventBus.cs
  │   └── IIntegrationEventHandler.cs
  ├── ValueObjects/
  │   ├── Money.cs
  │   ├── Address.cs
  │   ├── UserId.cs
  │   └── ProductId.cs
  └── Common/
      ├── Result.cs
      ├── Error.cs
      └── PagedResult.cs

### 4.6 CROSS-MODULE COMMUNICATION — IN-PROCESS MESSAGING


This is the most important technical decision in a modular monolith.
How do modules talk to each other?

There are two patterns:

**PATTERN 1: PUBLIC FACADE (Synchronous, direct call)**

  Module B exposes an interface in its Contracts project:

    // Catalog.Contracts
```
    public interface ICatalogModule
    {
        Task<ProductSummaryDto?> GetProductAsync(Guid productId, CancellationToken ct = default);
        Task<bool> DoesProductExistAsync(Guid productId, CancellationToken ct = default);
        Task<IReadOnlyList<ProductSummaryDto>> GetProductsByIdsAsync(IReadOnlyList<Guid> ids, CancellationToken ct = default);
    }

```

  Module A depends on the interface (not the implementation):

    // Ordering module
```
    public class PlaceOrderCommandHandler
    {
        private readonly ICatalogModule _catalog; // injected — this is fine

        public async Task Handle(PlaceOrderCommand cmd, CancellationToken ct)
        {
            // Safe: calling through the public facade only
            var product = await _catalog.GetProductAsync(cmd.ProductId, ct);
            if (product is null) throw new NotFoundException("Product not found");
            // ... create order
        }
    }

```

  The Catalog module implements the interface:

    // Inside Catalog module — the implementation
    internal class CatalogModuleFacade : ICatalogModule
```
    {
        private readonly IProductRepository _products;
        // ... constructor
        public async Task<ProductSummaryDto?> GetProductAsync(Guid productId, CancellationToken ct)
        {
            var product = await _products.GetByIdAsync(productId, ct);
            return product is null ? null : new ProductSummaryDto(product.Id, product.Name, product.Price);
        }
    }

```

  The Host registers this facade so DI can resolve it:

```
    builder.Services.AddScoped<ICatalogModule, CatalogModuleFacade>();

```

  USE THIS PATTERN WHEN: One module needs a synchronous answer from another module.
  For example: Ordering needs to get current product price before creating an order.


**PATTERN 2: INTEGRATION EVENTS (Asynchronous, event-driven)**

  Module B raises an event (publishes it to the in-memory event bus):

    // After an order is placed in Ordering module:
```
    await _eventBus.PublishAsync(new OrderPlacedIntegrationEvent
    {
        OrderId = order.Id,
        CustomerId = order.CustomerId,
        VendorId = order.VendorId,
        TotalAmount = order.TotalAmount,
        LineItems = order.Lines.Select(l => new OrderLineDto(...)).ToList()
    });

```

  Module A (Payment) listens for the event:

    // In Payment module
```
    public class OrderPlacedEventHandler : IIntegrationEventHandler<OrderPlacedIntegrationEvent>
    {
        private readonly IPaymentProcessor _processor;

        public async Task HandleAsync(OrderPlacedIntegrationEvent @event, CancellationToken ct)
        {
            // Initiate payment for the placed order
            await _processor.InitiatePaymentAsync(@event.OrderId, @event.TotalAmount, ct);
        }
    }

```

  USE THIS PATTERN WHEN:
```
    - One module announces something happened ("I don't care who listens")
    - Other modules react to changes (loose coupling)
    - The publisher doesn't need a response
    - The action is naturally "after the fact" (notifications, analytics, etc.)

```

The general rule:
- Use FACADES sparingly, for synchronous lookups where you genuinely need data NOW
- Use EVENTS as the primary communication mechanism — they create less coupling

### 4.7 DOMAIN EVENTS VS INTEGRATION EVENTS


This distinction matters a lot and is often confused.

**DOMAIN EVENTS:**
- Internal to a module
- Raised by domain entities when something meaningful happens in the domain
- Handled within the same module (same transaction, same DbContext)
- Used to trigger side effects within the module
- Never leave the module boundary

  Example (in Ordering module's Order entity):
```
    public class Order : AggregateRoot<OrderId>
    {
        public void Place()
        {
            Status = OrderStatus.Placed;
            RaiseDomainEvent(new OrderPlacedDomainEvent(Id, CustomerId, TotalAmount));
            // This domain event stays within Ordering module
        }
    }

```

  Domain event handler (also within Ordering module):
```
    public class OrderPlacedDomainEventHandler : INotificationHandler<OrderPlacedDomainEvent>
    {
        public async Task Handle(OrderPlacedDomainEvent notification, CancellationToken ct)
        {
            // Update an internal audit log, calculate loyalty points internally, etc.
            // Still within Ordering module — same transaction
        }
    }

```

**INTEGRATION EVENTS:**
- Cross-module communication
- Raised by a module's application layer AFTER a business operation completes
- Published to the event bus, consumed by OTHER modules
- Carry only the data needed by subscribers (not the full domain model)
- Must be carefully versioned (they're cross-boundary contracts)

  Example (in Ordering module's PlaceOrderCommandHandler):
    // After saving the order successfully:
```
    await _eventBus.PublishAsync(new OrderPlacedIntegrationEvent
    {
        OrderId = order.Id.Value,
        CustomerId = order.CustomerId.Value,
        // Only what other modules need — not the full Order domain model
    });

```

**WHY THE DISTINCTION MATTERS:**
  Domain events: Can be refactored freely (internal)
  Integration events: Must be versioned carefully (cross-boundary contract)

  If you change an Integration Event's structure, every subscriber breaks.
  Treat integration events like HTTP API contracts — version them if you change them.

### 4.8 THE INTERNAL EVENT BUS


In a modular monolith, the event bus is in-process (in-memory).
No network, no queue, no serialization needed. Just method calls.

A simple, effective implementation:

  // The interface (in Shared Kernel)
  public interface IIntegrationEventBus
  {
      Task PublishAsync<T>(T @event, CancellationToken ct = default)
          where T : class, IIntegrationEvent;
  }

  // The implementation using the .NET DI container
  public class InMemoryEventBus : IIntegrationEventBus
  {
      private readonly IServiceProvider _serviceProvider;

      public InMemoryEventBus(IServiceProvider serviceProvider)
          => _serviceProvider = serviceProvider;

      public async Task PublishAsync<T>(T @event, CancellationToken ct = default)
          where T : class, IIntegrationEvent
      {
          using var scope = _serviceProvider.CreateScope();

          // Find all registered handlers for this event type
          var handlers = scope.ServiceProvider
              .GetServices<IIntegrationEventHandler<T>>()
              .ToList();

          // Call each handler
          foreach (var handler in handlers)
          {
              await handler.HandleAsync(@event, ct);
          }
      }
  }

Module registration wires up the handlers:

  // In Payment module's AddPaymentModule():
  services.AddScoped<IIntegrationEventHandler<OrderPlacedIntegrationEvent>,
                     OrderPlacedEventHandler>();

  // In Notifications module's AddNotificationsModule():
  services.AddScoped<IIntegrationEventHandler<OrderPlacedIntegrationEvent>,
                     SendOrderConfirmationEmailHandler>();

  // In Analytics module's AddAnalyticsModule():
  services.AddScoped<IIntegrationEventHandler<OrderPlacedIntegrationEvent>,
                     RecordOrderAnalyticsHandler>();

One event, three handlers, in three different modules.
The Ordering module doesn't know any of them exist.
That's the beauty of event-driven design.

IMPORTANT: In this synchronous in-memory implementation, if one handler fails,
the whole publish fails. For production systems, use the OUTBOX PATTERN to
make event delivery reliable (covered in Part 6).

**MIGRATING TO A REAL QUEUE LATER:**
When you eventually extract a module into a microservice, you replace
InMemoryEventBus with a real message broker implementation (RabbitMQ, 
Azure Service Bus, etc.). The interface stays the same. The handlers stay
the same. Only the infrastructure changes. This is why the abstraction matters.

### 4.9 DATABASE STRATEGY — SHARED VS SEPARATE SCHEMAS


Database design is where most modular monolith implementations either succeed
or fail. Let's be very specific about the right approach.

**OPTION 1: ONE DATABASE, SEPARATE SCHEMAS (Recommended)**

  All modules share one SQL Server (or PostgreSQL) database instance,
  but each module gets its own schema:

  Database: ECommerceApp
  ├── Schema: catalog
  │   ├── catalog.products
  │   ├── catalog.categories
  │   └── catalog.product_images
  ├── Schema: ordering
  │   ├── ordering.orders
  │   ├── ordering.order_lines
  │   └── ordering.outbox_messages
  ├── Schema: payment
  │   ├── payment.transactions
  │   ├── payment.payment_methods
  │   └── payment.refunds
  ├── Schema: inventory
  │   ├── inventory.stock_items
  │   └── inventory.reservations
  ├── Schema: vendors
  │   ├── vendors.vendor_accounts
  │   └── vendors.vendor_products
  ├── Schema: identity
  │   ├── identity.users
  │   ├── identity.roles
  │   └── identity.refresh_tokens
  └── Schema: notifications
      └── notifications.notification_log

  WHY THIS APPROACH IS CORRECT:

  (a) Clear data ownership — you know immediately which module owns each table
  (b) Prevents accidental cross-module joins at the DB level (use application logic instead)
  (c) Easy migration to separate databases per service when needed (just change the connection string)
  (d) Allows cross-schema transactions when truly needed (for transactional consistency)
  (e) One database server = simple operations, backups, and monitoring
  (f) Schema permissions can be configured to enforce boundaries at the DB level too

**OPTION 2: COMPLETELY SEPARATE DATABASES (Microservices style)**

  Each module connects to its own database server/instance:
```
    Catalog → catalog-db (SQL Server)
    Ordering → ordering-db (SQL Server)
    Payment → payment-db (SQL Server)

```

  This is overkill for a modular monolith. You lose cross-schema transactions,
  you add significant operational complexity, and you gain nothing meaningful
  since it's still one application. Reserve this for when you extract modules
  into actual microservices.

**OPTION 3: ONE SHARED DATABASE, ALL IN DEFAULT SCHEMA (Anti-pattern)**

  Everything in dbo schema. No separation. This is the Big Ball of Mud.
  Every module can query every other module's tables. Boundaries are
  meaningless. Don't do this.

**CROSS-MODULE DATA REFERENCE:**

Modules reference each other's data using IDs only — never foreign keys
across schemas in the same table definition.

Example:
The ordering.order_lines table has a product_id column.
This is a GUID that refers to a product in catalog.products.
But there is NO foreign key constraint between these tables.
The application layer (Ordering module's facade calling Catalog module)
is responsible for ensuring the product exists, not the database.

Why no FK? Because if you add an FK, you've coupled the schemas at the
database level. Dropping or migrating the catalog schema could break ordering.
Application-level validation is the right boundary.

### 4.10 ENTITY FRAMEWORK CORE IN A MODULAR SETUP


Each module has its OWN DbContext. This is the most important EF Core rule
in a modular system.

Example for the Ordering module:

  // OrderingDbContext.cs (INTERNAL to Ordering module)
  internal class OrderingDbContext : DbContext
  {
      public OrderingDbContext(DbContextOptions<OrderingDbContext> options)
          : base(options) { }

      public DbSet<Order> Orders { get; set; }
      public DbSet<OrderLine> OrderLines { get; set; }
      public DbSet<OutboxMessage> OutboxMessages { get; set; }

      protected override void OnModelCreating(ModelBuilder modelBuilder)
      {
          // Set the default schema for this module
          modelBuilder.HasDefaultSchema("ordering");

          // Apply all entity configurations from this assembly
          modelBuilder.ApplyConfigurationsFromAssembly(typeof(OrderingDbContext).Assembly);

          base.OnModelCreating(modelBuilder);
      }
  }

  // OrderConfiguration.cs
  internal class OrderConfiguration : IEntityTypeConfiguration<Order>
  {
      public void Configure(EntityTypeBuilder<Order> builder)
      {
          builder.ToTable("orders"); // table: ordering.orders

          builder.HasKey(o => o.Id);
          builder.Property(o => o.Id)
              .HasConversion(id => id.Value, value => new OrderId(value));

          builder.OwnsOne(o => o.ShippingAddress, address =>
          {
              address.Property(a => a.Street).HasColumnName("shipping_street");
              address.Property(a => a.City).HasColumnName("shipping_city");
              address.Property(a => a.Country).HasColumnName("shipping_country");
          });

          // No FK to catalog.products — just a GUID column
          builder.Property(o => o.CustomerId)
              .HasConversion(id => id.Value, value => new UserId(value));
      }
  }

IMPORTANT: Mark the DbContext as `internal`.
No other module should be able to instantiate or use OrderingDbContext.
Only Ordering module's own code touches its DbContext.

**REGISTERING MULTIPLE DBCONTEXTS:**
Each module registers its own DbContext in its AddXxxModule() extension:

  // In AddOrderingModule():
  services.AddDbContext<OrderingDbContext>(options =>
      options.UseSqlServer(
          configuration.GetConnectionString("DefaultConnection"),
          sql => sql.MigrationsHistoryTable("__EFMigrationsHistory", "ordering")));

  // Note: MigrationsHistoryTable is placed in the module's own schema
  // Each module tracks its own migration history

All DbContexts point to the SAME connection string (same database),
but each has its own schema. This is the correct configuration.

### 4.11 MIGRATIONS PER MODULE


Each module manages its own EF Core migrations independently.
This is critical for module autonomy — you don't want Ordering module's
schema change to be blocked waiting for Catalog module's migration.

Setting up migrations per module:

1. Each module has a Migrations folder under its Infrastructure/Persistence layer

2. To create a migration for the Ordering module:
   (Run from the solution root)

   dotnet ef migrations add "InitialOrdering" \
       --project src/Modules/Ordering/ECommerceApp.Modules.Ordering.csproj \
       --startup-project src/Host/ECommerceApp.Host.csproj \
       --context OrderingDbContext \
       --output-dir Infrastructure/Persistence/Migrations

3. Each module's migrations table is in its own schema:
   ordering.__EFMigrationsHistory
   catalog.__EFMigrationsHistory
   payment.__EFMigrationsHistory
   etc.

4. Applying migrations at startup (development):
   // In UseOrderingModule() or a startup service:
   var db = serviceProvider.GetRequiredService<OrderingDbContext>();
   db.Database.Migrate(); // Only runs Ordering's migrations

5. In production, prefer running migrations as a pre-deployment step:
   dotnet ef database update --context OrderingDbContext
   dotnet ef database update --context CatalogDbContext
   // etc.

**WHY THIS MATTERS:**
If you use ONE shared DbContext for all modules, then adding a column to
the Catalog module creates a migration that's mixed with Ordering's schema.
This is messy, hard to review, and couples the migration history together.
Separate migrations per module = clean, independent, reviewable history.

### 4.12 THE API LAYER — ONE ENTRY POINT, MANY MODULES


From the outside world (HTTP clients, mobile apps, browser), there is ONE API.
One base URL. One set of authentication headers. One Swagger/OpenAPI page.
Under the hood, different URL paths route to different modules.

URL conventions that make module ownership clear:
  /api/catalog/**     → Catalog module
  /api/orders/**      → Ordering module
  /api/payments/**    → Payment module
  /api/vendors/**     → Vendors module
  /api/inventory/**   → Inventory module
  /api/identity/**    → Identity module
  /api/reviews/**     → Reviews module

Each module registers its own endpoints:

  // In Catalog module
  app.MapGroup("/api/catalog")
      .MapCatalogEndpoints()
      .WithTags("Catalog")
      .RequireAuthorization();

  // CatalogEndpoints.cs
  public static class CatalogEndpoints
  {
      public static RouteGroupBuilder MapCatalogEndpoints(this RouteGroupBuilder group)
      {
          group.MapGet("/products", GetProducts);
          group.MapGet("/products/{id}", GetProductById);
          group.MapPost("/products", CreateProduct).RequireAuthorization("VendorPolicy");
          group.MapPut("/products/{id}", UpdateProduct).RequireAuthorization("VendorPolicy");
          group.MapGet("/categories", GetCategories);
          return group;
      }

      private static async Task<IResult> GetProducts(
          [AsParameters] GetProductsRequest request,
          ISender mediator,
          CancellationToken ct)
      {
          var result = await mediator.Send(new GetProductsQuery(request), ct);
          return Results.Ok(result);
      }
  }

**SWAGGER GROUPING BY MODULE:**
Configure Swagger to group endpoints by module (using Tags):

  builder.Services.AddSwaggerGen(c =>
  {
      c.TagActionsBy(api => api.GroupName); // GroupName maps to module
      c.DocInclusionPredicate((_, _) => true);
  });

This gives you a Swagger UI where each module has its own section,
making the API self-documenting in terms of module ownership.

### 4.13 AUTHENTICATION AND AUTHORIZATION PER MODULE


Authentication is usually handled at the application level (shared), but
authorization (permissions, policies) is often module-specific.

AUTHENTICATION (shared, centralized):
- JWT Bearer token validation happens in the Host project / middleware
- The Identity module issues tokens and manages user sessions
- All other modules receive the user's claims via the token
- Modules don't do authentication themselves — they trust the token

  // In Host/Program.cs
  builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
      .AddJwtBearer(options => {
          options.Authority = configuration["Identity:Authority"];
          options.Audience = configuration["Identity:Audience"];
      });

AUTHORIZATION (module-specific policies):
  Each module can define and register its own authorization policies:

  // In Vendors module's AddVendorsModule()
  services.AddAuthorization(options =>
  {
      options.AddPolicy("VendorPolicy", policy =>
          policy.RequireClaim("role", "vendor"));

      options.AddPolicy("VendorOwnershipPolicy", policy =>
          policy.Requirements.Add(new VendorOwnershipRequirement()));
  });

  // Register the custom handler
  services.AddScoped<IAuthorizationHandler, VendorOwnershipHandler>();

  // VendorOwnershipHandler checks that the current user owns the vendor
  // account they're trying to modify — business logic in authorization

MULTI-TENANCY (for multi-vendor setup):
  For a multi-vendor system, the concept of "which vendor does this user belong to"
  is a cross-cutting concern. Add a VendorId claim to the JWT token when a
  vendor user logs in. Modules can read this claim from IHttpContextAccessor.

  // Extension method in Shared Kernel
  public static class ClaimsPrincipalExtensions
  {
      public static Guid? GetVendorId(this ClaimsPrincipal user)
      {
          var claim = user.FindFirst("vendor_id");
          return claim is null ? null : Guid.Parse(claim.Value);
      }
  }

### 4.14 BACKGROUND JOBS IN A MODULAR SYSTEM


Background jobs are common: sending emails, cleaning up expired orders,
processing payment confirmations, generating reports, etc.

Each module OWNS its own background jobs. Jobs that affect Ordering module's
data run as part of the Ordering module, not as some shared global job runner.

**THREE APPROACHES:**

**APPROACH 1: IHostedService (built-in .NET, good for simple recurring tasks)**

  // Registered in OrderingModule:
  services.AddHostedService<ExpiredOrderCleanupService>();

  // ExpiredOrderCleanupService.cs (internal to Ordering)
  internal class ExpiredOrderCleanupService : BackgroundService
  {
      private readonly IServiceProvider _services;

      protected override async Task ExecuteAsync(CancellationToken ct)
      {
          while (!ct.IsCancellationRequested)
          {
              await Task.Delay(TimeSpan.FromMinutes(5), ct);
              using var scope = _services.CreateScope();
              var repo = scope.ServiceProvider.GetRequiredService<IOrderRepository>();
              await repo.CancelExpiredOrdersAsync(ct);
          }
      }
  }

**APPROACH 2: Hangfire (recommended for production — persistent, observable)**

  // One Hangfire server for the whole app, but jobs are module-specific
  services.AddHangfire(config => config.UseSqlServerStorage(connectionString));
  services.AddHangfireServer();

  // Each module schedules its own recurring jobs in its startup:
  RecurringJob.AddOrUpdate<ExpiredOrderJob>(
      "expire-orders",
      job => job.ExecuteAsync(),
      Cron.Minutely);

**APPROACH 3: Outbox Processor (for reliable event publishing — covered in Part 6)**
  Each module has its own outbox processor background job.

The key principle: Background jobs are module-internal.
The Notifications module doesn't run a job that reads from the Orders database.
The Ordering module runs a job that finds orders needing notifications and
publishes integration events that the Notifications module handles.

### 4.15 LOGGING, OBSERVABILITY, AND TRACING


Observability in a modular monolith is simpler than in microservices
(no distributed tracing needed), but you should still do it right.

**STRUCTURED LOGGING:**
  Use Serilog or Microsoft.Extensions.Logging with structured properties.
  Add module context to every log entry:

  // A module enricher for Serilog
  Log.ForContext("Module", "Ordering")
     .ForContext("OperationId", command.OrderId)
     .Information("Placing order for customer {CustomerId}", command.CustomerId);

  // Output: {"Module":"Ordering","OperationId":"abc-123","CustomerId":"xyz-456",...}

  This lets you filter logs by module in your log aggregator (Seq, DataDog, etc.)

CORRELATION IDs:
  Add a middleware that generates a correlation ID per request and includes it
  in all log entries and response headers:

  app.Use(async (context, next) =>
  {
      var correlationId = context.Request.Headers["X-Correlation-Id"]
          .FirstOrDefault() ?? Guid.NewGuid().ToString();
      context.Response.Headers["X-Correlation-Id"] = correlationId;
      using (LogContext.PushProperty("CorrelationId", correlationId))
      {
          await next();
      }
  });

**METRICS PER MODULE:**
  Each module can expose its own metrics using OpenTelemetry or Prometheus:

  // In Ordering module
  private static readonly Counter<int> OrdersPlaced =
      Meter.CreateCounter<int>("ordering.orders.placed");

  // When an order is placed:
  OrdersPlaced.Add(1, new TagList { { "vendor_id", order.VendorId.ToString() } });

**HEALTH CHECKS PER MODULE:**
  // Each module registers its own health check
  services.AddHealthChecks()
      .AddDbContextCheck<OrderingDbContext>("ordering-db")
      .AddCheck<OrderingHealthCheck>("ordering-module");

  // Aggregate health endpoint in Host
  app.MapHealthChecks("/health", new HealthCheckOptions
  {
      ResponseWriter = UIResponseWriter.WriteHealthCheckUIResponse
  });

## PART 5 — THE MULTI-VENDOR E-COMMERCE SYSTEM (FULL EXAMPLE)


### 5.1 WHY THIS SYSTEM AND WHAT IT COVERS


A Multi-Vendor E-Commerce Platform is one of the most complex and instructive
domains for demonstrating modular architecture because:

(a) It has many distinct business areas (catalog, orders, payments, vendors...)
(b) These areas are clearly separable — a product person, an operations person,
    and a payments person would never accidentally describe the same thing
(c) They interact with each other in complex ways (placing an order triggers
    payment, inventory, notifications, vendor earnings, analytics)
(d) They have different data models (a "product" means completely different
    things to the catalog team vs the inventory team vs the order team)
(e) They have different scaling needs (catalog is read-heavy, payment is
    consistency-critical, analytics is write-heavy)
(f) They have different compliance requirements (payment needs PCI-DSS,
    identity needs data privacy compliance)

Our system is called: "MarketHub" — A multi-vendor marketplace where:
- Multiple vendors (sellers) can register and list products
- Customers can browse products across all vendors
- Customers can place orders that span multiple vendors
- Each vendor gets paid for their portion of an order
- Customers can leave reviews for products
- Admins can manage the platform

Think: Amazon marketplace, Etsy, or Shopify Markets.

### 5.2 IDENTIFYING THE BOUNDED CONTEXTS (MODULES)


Before writing a single line of code, we identify our modules by analyzing
the business domain using Event Storming (or just domain analysis).

We ask: "What are the major business capabilities of MarketHub?"

CAPABILITY: Managing who can use the system and what they can do
→ MODULE: Identity & Access Management (IAM)

CAPABILITY: Managing what products are available for sale
→ MODULE: Catalog

CAPABILITY: Tracking stock levels and fulfillment availability
→ MODULE: Inventory

CAPABILITY: Processing customer purchases
→ MODULE: Ordering

CAPABILITY: Processing money movement (charging customers, paying vendors)
→ MODULE: Payment

CAPABILITY: Managing vendor accounts, their products, and their earnings
→ MODULE: Vendors

CAPABILITY: Collecting and displaying customer feedback on products
→ MODULE: Reviews & Ratings

CAPABILITY: Sending emails, SMS, and push notifications
→ MODULE: Notifications

CAPABILITY: Collecting and analyzing business metrics and KPIs
→ MODULE: Analytics

Now we verify these are good boundaries by checking:
- ✅ Can a team of 3-5 engineers own each one?  YES
- ✅ Does each have a clear business language?  YES
- ✅ Do they change for different business reasons?  YES
- ✅ Are the data models distinct?  YES
- ✅ Can we name each with a single clear noun?  YES

We are ready to build.

### 5.3 MODULE: IDENTITY & ACCESS MANAGEMENT (IAM)


**WHAT THIS MODULE IS RESPONSIBLE FOR:**
  The Identity module is the gatekeeper of the system. It knows who everyone
  is (customers, vendors, admins), what they're allowed to do, and manages
  the lifecycle of their accounts.

**WHY IT EXISTS:**
  Every other module needs to know "who is making this request?" This module
  answers that question and issues the credentials (JWT tokens) that all
  other modules trust. Centralizing identity means consistent security rules,
  a single place to enforce authentication, and clean separation from business logic.

**WHAT IT OWNS:**
- User registration and login (email/password, OAuth social login)
- JWT access token issuance and refresh token management
- Password reset and email verification flows
- Role management (Customer, Vendor, VendorStaff, Admin, SuperAdmin)
- Permission management
- Two-factor authentication
- Audit logs of authentication events
- Session management (active sessions, device tracking)

**WHAT IT DOES NOT OWN:**
- Vendor-specific profile information (that's the Vendors module)
- Customer shipping addresses (that's Ordering or a Customer Profile submodule)
- Purchase history (that's Ordering)
- Product reviews (that's Reviews)
- Payment methods (that's Payment)
  Identity only cares about: "Is this person who they say they are, and what roles do they have?"

DATABASE SCHEMA (identity):

  identity.users
  ├── id                  UUID PK
  ├── email               VARCHAR(320) UNIQUE NOT NULL
  ├── password_hash       VARCHAR(512)
  ├── email_verified      BOOLEAN DEFAULT FALSE
  ├── phone_number        VARCHAR(20)
  ├── phone_verified      BOOLEAN DEFAULT FALSE
  ├── two_factor_enabled  BOOLEAN DEFAULT FALSE
  ├── is_active           BOOLEAN DEFAULT TRUE
  ├── created_at          TIMESTAMP
  └── last_login_at       TIMESTAMP

  identity.user_roles
  ├── user_id             UUID FK → identity.users.id
  └── role                VARCHAR(50) -- 'Customer', 'Vendor', 'Admin', etc.

  identity.refresh_tokens
  ├── id                  UUID PK
  ├── user_id             UUID FK → identity.users.id
  ├── token_hash          VARCHAR(256)
  ├── expires_at          TIMESTAMP
  ├── is_revoked          BOOLEAN DEFAULT FALSE
  └── created_at          TIMESTAMP

  identity.email_verifications
  ├── id                  UUID PK
  ├── user_id             UUID FK → identity.users.id
  ├── token               VARCHAR(256)
  └── expires_at          TIMESTAMP

PUBLIC CONTRACTS (Identity.Contracts):

  // Interface
  public interface IIdentityModule
  {
      Task<UserDto?> GetUserAsync(Guid userId);
      Task<bool> DoesUserExistAsync(Guid userId);
  }

  // DTOs
  public record UserDto(Guid UserId, string Email, IReadOnlyList<string> Roles);

  // Integration Events (published to other modules)
  public record UserRegisteredIntegrationEvent(Guid UserId, string Email) : IIntegrationEvent;
  public record UserDeactivatedIntegrationEvent(Guid UserId) : IIntegrationEvent;

**API ENDPOINTS:**
  POST /api/identity/register          -- Register new user
  POST /api/identity/login             -- Login, get tokens
  POST /api/identity/refresh           -- Refresh access token
  POST /api/identity/logout            -- Revoke refresh token
  POST /api/identity/verify-email      -- Verify email address
  POST /api/identity/forgot-password   -- Request password reset
  POST /api/identity/reset-password    -- Reset password with token
  GET  /api/identity/me                -- Get current user profile
  PUT  /api/identity/me/password       -- Change password

**KEY DESIGN DECISIONS:**
- Identity uses ASP.NET Core Identity internally for user management
- JWT tokens include: userId, email, roles[], vendorId (if vendor)
- Token validation is configured in Host, not in Identity module
- Identity publishes UserRegisteredIntegrationEvent so other modules
```
    (Vendors, Notifications) know when a new user joins

```

### 5.4 MODULE: CATALOG


**WHAT THIS MODULE IS RESPONSIBLE FOR:**
  Everything customers see when they browse the marketplace. Products, their
  descriptions, images, categories, pricing, and discoverability.

**WHY IT EXISTS:**
  Product information is complex, rich, and changes for completely different
  reasons than orders or inventory. A marketing team edits product descriptions
  frequently. A pricing team adjusts prices. A catalog team manages categories
  and SEO. These concerns must be isolated from the transactional concerns of
  ordering and inventory.

**WHAT IT OWNS:**
- Product listings (name, description, specifications, images)
- Product categories and subcategories (hierarchical taxonomy)
- Product pricing (base price, sale price, pricing tiers)
- Product visibility (draft, active, archived)
- Product search and filtering
- Product tags and attributes
- SEO metadata (slug, meta description)
- Product variants (size, color, material combinations)

**WHAT IT DOES NOT OWN:**
- Stock levels (Inventory module owns that)
- Order history for a product (Ordering module owns that)
- Product reviews and ratings (Reviews module owns that, but may read
```
    aggregated ratings from Reviews module's public API for display)
```

- Vendor payment for sales (Payment and Vendors own that)

DATABASE SCHEMA (catalog):

  catalog.products
  ├── id                  UUID PK
  ├── vendor_id           UUID (NO FK — references vendors schema by convention)
  ├── name                VARCHAR(500) NOT NULL
  ├── slug                VARCHAR(500) UNIQUE NOT NULL
  ├── description         TEXT
  ├── base_price          DECIMAL(18,2) NOT NULL
  ├── sale_price          DECIMAL(18,2)
  ├── status              VARCHAR(20) -- 'Draft', 'Active', 'Archived'
  ├── meta_title          VARCHAR(200)
  ├── meta_description    VARCHAR(500)
  ├── created_at          TIMESTAMP
  └── updated_at          TIMESTAMP

  catalog.categories
  ├── id                  UUID PK
  ├── parent_id           UUID FK → catalog.categories.id (nullable — root categories)
  ├── name                VARCHAR(200) NOT NULL
  ├── slug                VARCHAR(200) UNIQUE NOT NULL
  └── display_order       INT

  catalog.product_categories
  ├── product_id          UUID FK → catalog.products.id
  └── category_id         UUID FK → catalog.categories.id

  catalog.product_images
  ├── id                  UUID PK
  ├── product_id          UUID FK → catalog.products.id
  ├── url                 VARCHAR(1000) NOT NULL
  ├── alt_text            VARCHAR(200)
  └── display_order       INT

  catalog.product_variants
  ├── id                  UUID PK
  ├── product_id          UUID FK → catalog.products.id
  ├── sku                 VARCHAR(100) UNIQUE NOT NULL
  ├── attributes          JSONB -- {"color":"red","size":"L"}
  ├── price_adjustment    DECIMAL(18,2) DEFAULT 0
  └── is_active           BOOLEAN DEFAULT TRUE

PUBLIC CONTRACTS (Catalog.Contracts):

  public interface ICatalogModule
  {
      Task<ProductSummaryDto?> GetProductAsync(Guid productId, CancellationToken ct = default);
      Task<IReadOnlyList<ProductSummaryDto>> GetProductsByIdsAsync(
          IReadOnlyList<Guid> productIds, CancellationToken ct = default);
      Task<bool> IsProductAvailableForPurchaseAsync(Guid productId, CancellationToken ct = default);
  }

  public record ProductSummaryDto(
      Guid ProductId,
      Guid VendorId,
      string Name,
      string Slug,
      decimal BasePrice,
      decimal? SalePrice,
      string Status,
      string? PrimaryImageUrl);

  // Integration Events
  public record ProductCreatedIntegrationEvent(
      Guid ProductId, Guid VendorId, string Name, decimal Price) : IIntegrationEvent;

  public record ProductPriceChangedIntegrationEvent(
      Guid ProductId, decimal OldPrice, decimal NewPrice) : IIntegrationEvent;

  public record ProductDeactivatedIntegrationEvent(Guid ProductId) : IIntegrationEvent;

**API ENDPOINTS:**
  GET    /api/catalog/products                -- Browse products (paginated, filterable)
  GET    /api/catalog/products/{slug}         -- Get product details by slug
  GET    /api/catalog/products/{id}           -- Get product by ID
  POST   /api/catalog/products                -- Create product (Vendor role)
  PUT    /api/catalog/products/{id}           -- Update product (Vendor role)
  DELETE /api/catalog/products/{id}           -- Deactivate product (Vendor role)
  GET    /api/catalog/categories              -- Get category tree
  GET    /api/catalog/categories/{slug}/products -- Products in a category

**KEY DESIGN DECISIONS:**
- The Catalog module stores the vendor_id but does NOT validate it at DB level.
```
    When a product is created, the Vendors module's public facade is called to
    verify the vendor exists and is active.
```

- Product pricing is owned here. Ordering module takes a SNAPSHOT of the price
```
    at time of order (never queries Catalog for price retrospectively).
```

- ProductCreatedIntegrationEvent fires when a product is published.
    Inventory module listens to this event and creates an InventorySku record.
- Full-text search can be implemented within this module using PostgreSQL's
    tsvector, SQL Server Full-Text, or by integrating an Elasticsearch adapter.

### 5.5 MODULE: INVENTORY


**WHAT THIS MODULE IS RESPONSIBLE FOR:**
  Knowing exactly how many units of each product variant are available,
  managing stock reservations when orders are placed, and triggering
  restocking workflows when stock runs low.

**WHY IT EXISTS:**
  Inventory is operationally distinct from the catalog. A vendor can have a
  product listing (Catalog) without any stock. A warehouse worker cares about
  stock movements — not product descriptions or SEO. Inventory has strict
  consistency requirements (you can't oversell) that are separate from the
  relaxed consistency of catalog browsing.

**WHAT IT OWNS:**
- Current stock levels per SKU (per product variant)
- Stock reservations (items "held" while an order is being processed)
- Stock adjustments (receiving new stock, writeoffs)
- Low stock threshold configuration
- Out-of-stock status
- Warehouse location per SKU (if multi-warehouse)

**WHAT IT DOES NOT OWN:**
- Product information (name, price, description) — that's Catalog
- Order details — that's Ordering
- Shipping and fulfillment — that could be its own module

DATABASE SCHEMA (inventory):

  inventory.stock_items
  ├── id                  UUID PK
  ├── product_id          UUID NOT NULL (references catalog.products by convention)
  ├── variant_id          UUID (references catalog.product_variants by convention)
  ├── sku                 VARCHAR(100) UNIQUE NOT NULL
  ├── quantity_on_hand    INT NOT NULL DEFAULT 0
  ├── quantity_reserved   INT NOT NULL DEFAULT 0
  ├── low_stock_threshold INT NOT NULL DEFAULT 10
  ├── updated_at          TIMESTAMP
  └── version             INT NOT NULL DEFAULT 1  -- for optimistic concurrency

  inventory.stock_reservations
  ├── id                  UUID PK
  ├── stock_item_id       UUID FK → inventory.stock_items.id
  ├── order_id            UUID NOT NULL (references ordering.orders by convention)
  ├── quantity            INT NOT NULL
  ├── status              VARCHAR(20) -- 'Pending', 'Confirmed', 'Released'
  ├── reserved_at         TIMESTAMP
  └── expires_at          TIMESTAMP  -- if order not confirmed, auto-release

  inventory.stock_movements
  ├── id                  UUID PK
  ├── stock_item_id       UUID FK → inventory.stock_items.id
  ├── quantity_change     INT NOT NULL -- positive = in, negative = out
  ├── reason              VARCHAR(50) -- 'Purchase', 'Return', 'Adjustment', 'Sale'
  ├── reference_id        UUID -- order_id, return_id, etc.
  └── occurred_at         TIMESTAMP

PUBLIC CONTRACTS (Inventory.Contracts):

  public interface IInventoryModule
  {
      Task<int> GetAvailableQuantityAsync(Guid productId, Guid? variantId = null, CancellationToken ct = default);
      Task<StockReservationResult> ReserveStockAsync(ReserveStockRequest request, CancellationToken ct = default);
      Task ReleaseReservationAsync(Guid orderId, CancellationToken ct = default);
  }

  public record StockReservationResult(bool Success, string? FailureReason);

  // Integration Events
  public record StockReservedIntegrationEvent(Guid OrderId, bool Success) : IIntegrationEvent;
  public record StockReleasedIntegrationEvent(Guid OrderId) : IIntegrationEvent;
  public record LowStockAlertIntegrationEvent(Guid ProductId, Guid VendorId, int CurrentStock) : IIntegrationEvent;
  public record OutOfStockIntegrationEvent(Guid ProductId, Guid VendorId) : IIntegrationEvent;

**KEY DESIGN DECISIONS:**
- Optimistic concurrency with a `version` column prevents overselling
- When ReserveStockAsync is called, it increments quantity_reserved atomically
```
    using: UPDATE stock_items SET quantity_reserved = quantity_reserved + @qty,
            version = version + 1 WHERE id = @id AND version = @expectedVersion
```

- Stock reservations expire (cleanup job releases them if order isn't confirmed)
- Inventory listens to ProductCreatedIntegrationEvent to create SkuRecord
- Inventory listens to OrderCancelledIntegrationEvent to release reservations
- LowStockAlertIntegrationEvent is handled by Notifications module (sends email to vendor)

### 5.6 MODULE: ORDERING


**WHAT THIS MODULE IS RESPONSIBLE FOR:**
  The complete lifecycle of a customer's purchase — from cart checkout through
  order placement, confirmation, and fulfillment.

**WHY IT EXISTS:**
  Ordering is the most transactionally critical module. It orchestrates a
  complex business process involving multiple other modules (Inventory,
  Payment, Vendors). It must maintain a consistent, auditable record of
  every purchase and every state change. This is the "core" of any e-commerce
  system. Keeping it separate means business rules about orders (cancellation
  windows, split orders, line item pricing snapshots) are isolated and clear.

**WHAT IT OWNS:**
- Customer orders and their complete history
- Order line items with SNAPSHOTS of product data at time of order
- Order status transitions (Pending → Confirmed → Shipped → Delivered → Returned)
- Shipping address (snapshot, not linked to a separate address record)
- Price snapshots (the price paid, including any discounts active at purchase time)
- Order-level discounts and coupon application
- Order cancellation logic and business rules
- Return and refund requests (initiation — execution is in Payment)

**WHAT IT DOES NOT OWN:**
- Payment processing (Payment module)
- Stock management (Inventory module)
- Product catalog data (Catalog module — Ordering only stores snapshots)
- Vendor earnings calculations (Vendors module)
- Email/SMS notifications (Notifications module)

THE "SNAPSHOT" PATTERN — Critical:
  When an order is placed, the Ordering module takes a SNAPSHOT of:
    - Product name at time of order
    - Product price at time of order
    - Vendor name at time of order
  These snapshots are stored in the ordering.order_lines table.
  If a product's name or price changes later, past orders are not affected.
  This is correct business behavior and is essential for financial auditing.

DATABASE SCHEMA (ordering):

  ordering.orders
  ├── id                  UUID PK
  ├── customer_id         UUID NOT NULL (references identity.users by convention)
  ├── status              VARCHAR(30) NOT NULL  -- 'Pending', 'PaymentPending', 'Confirmed', ...
  ├── total_amount        DECIMAL(18,2) NOT NULL
  ├── shipping_street     VARCHAR(500)
  ├── shipping_city       VARCHAR(200)
  ├── shipping_state      VARCHAR(200)
  ├── shipping_postal     VARCHAR(20)
  ├── shipping_country    VARCHAR(100)
  ├── notes               TEXT
  ├── placed_at           TIMESTAMP
  ├── confirmed_at        TIMESTAMP
  ├── shipped_at          TIMESTAMP
  ├── delivered_at        TIMESTAMP
  └── cancelled_at        TIMESTAMP

  ordering.order_lines
  ├── id                  UUID PK
  ├── order_id            UUID FK → ordering.orders.id
  ├── product_id          UUID NOT NULL (snapshot reference)
  ├── variant_id          UUID (snapshot reference)
  ├── vendor_id           UUID NOT NULL (snapshot of vendor at time of order)
  ├── product_name        VARCHAR(500) NOT NULL   -- SNAPSHOT
  ├── product_image_url   VARCHAR(1000)           -- SNAPSHOT
  ├── vendor_name         VARCHAR(200) NOT NULL   -- SNAPSHOT
  ├── unit_price          DECIMAL(18,2) NOT NULL  -- SNAPSHOT
  ├── quantity            INT NOT NULL
  └── line_total          DECIMAL(18,2) NOT NULL  -- unit_price * quantity

  ordering.outbox_messages
  ├── id                  UUID PK
  ├── event_type          VARCHAR(500) NOT NULL
  ├── payload             JSONB NOT NULL
  ├── occurred_on         TIMESTAMP NOT NULL
  └── processed_on        TIMESTAMP (null = not yet processed)

**THE ORDER STATE MACHINE:**

  [Created] → [PaymentPending] → [PaymentConfirmed] → [StockReserved]
      → [Confirmed] → [Processing] → [Shipped] → [Delivered]
      OR
  [Created] → [Cancelled]              (customer cancels before payment)
  [PaymentPending] → [PaymentFailed] → [Cancelled]
  [StockReserved] → [StockFailed] → [Cancelled] (payment refunded)
  [Confirmed] → [CancellationRequested] → [Cancelled] (admin approval required)

THE ORDER AGGREGATE ROOT (C# pseudocode):

  public sealed class Order : AggregateRoot<OrderId>
  {
      private readonly List<OrderLine> _lines = new();
      public IReadOnlyList<OrderLine> Lines => _lines.AsReadOnly();
      public CustomerId CustomerId { get; private set; }
      public OrderStatus Status { get; private set; }
      public Money TotalAmount { get; private set; }
      public Address ShippingAddress { get; private set; }

      // Private constructor — create via static factory
      private Order() {}

      public static Order Create(CustomerId customerId, Address shippingAddress)
      {
          var order = new Order
          {
              Id = new OrderId(Guid.NewGuid()),
              CustomerId = customerId,
              Status = OrderStatus.Created,
              ShippingAddress = shippingAddress
          };
          order.RaiseDomainEvent(new OrderCreatedDomainEvent(order.Id));
          return order;
      }

      public void AddLine(ProductSnapshot product, int quantity)
      {
          if (Status != OrderStatus.Created)
              throw new InvalidOperationException("Cannot add items to a non-draft order");

          var line = OrderLine.Create(Id, product, quantity);
          _lines.Add(line);
          RecalculateTotal();
      }

      public void SubmitForPayment()
      {
          if (!_lines.Any())
              throw new InvalidOperationException("Cannot submit empty order");

          Status = OrderStatus.PaymentPending;
          RaiseDomainEvent(new OrderSubmittedDomainEvent(Id, TotalAmount));
      }

      public void ConfirmPayment()
      {
          if (Status != OrderStatus.PaymentPending)
              throw new InvalidOperationException("Order is not in PaymentPending state");

          Status = OrderStatus.PaymentConfirmed;
          RaiseDomainEvent(new PaymentConfirmedDomainEvent(Id));
      }

      public void Cancel(string reason)
      {
          if (Status == OrderStatus.Shipped || Status == OrderStatus.Delivered)
              throw new InvalidOperationException("Cannot cancel a shipped or delivered order");

          Status = OrderStatus.Cancelled;
          CancelledAt = DateTime.UtcNow;
          RaiseDomainEvent(new OrderCancelledDomainEvent(Id, reason));
      }
  }

PUBLIC CONTRACTS (Ordering.Contracts):

  // Integration Events published by Ordering module
  public record OrderPlacedIntegrationEvent(
      Guid OrderId, Guid CustomerId, decimal TotalAmount,
      IReadOnlyList<OrderLineDto> Lines) : IIntegrationEvent;

  public record OrderCancelledIntegrationEvent(
      Guid OrderId, Guid CustomerId, string Reason) : IIntegrationEvent;

  public record OrderFulfilledIntegrationEvent(
      Guid OrderId, Guid CustomerId) : IIntegrationEvent;

**WHO LISTENS TO ORDERING EVENTS:**
  OrderPlacedIntegrationEvent:
    → Payment module: Initiate payment collection
    → Inventory module: Reserve stock
    → Notifications module: Send order confirmation email
    → Analytics module: Record order metric
    → Vendors module: Record pending sale

  OrderCancelledIntegrationEvent:
    → Payment module: Initiate refund if already charged
    → Inventory module: Release stock reservation
    → Notifications module: Send cancellation email
    → Vendors module: Remove pending sale record

### 5.7 MODULE: PAYMENT


**WHAT THIS MODULE IS RESPONSIBLE FOR:**
  All money movement on the platform. Charging customers, routing money to
  vendors, processing refunds, and maintaining the financial ledger.

**WHY IT EXISTS:**
  Payment is the most sensitive module from a compliance, security, and
  correctness standpoint. PCI-DSS compliance requirements mean payment data
  must be strictly isolated. Payment logic is inherently different from
  product or order logic. When extracted to a microservice, this module
  would be the first candidate.

**WHAT IT OWNS:**
- Payment intents (the intent to charge a customer for an order)
- Transaction records (the actual charge result)
- Refund records
- Payment method tokens (references to Stripe/Braintree stored payment methods)
- Vendor payout records (money sent to vendors)
- Platform fee calculations

**WHAT IT DOES NOT OWN:**
- Order details (Ordering module)
- Vendor bank account details (dangerous — store only in payment provider's vault)
- Product pricing (Catalog module — Payment receives amounts from Orders)

**INTEGRATION WITH PAYMENT PROVIDERS:**
  In .NET, the Payment module wraps a payment gateway (Stripe, Braintree, PayPal).
  The payment provider does the actual charging. The Payment module:
  1. Creates a Payment Intent in Stripe (captures the "intent to pay" with amount)
  2. Returns a client_secret to the frontend (frontend confirms with card details)
  3. Receives a webhook from Stripe when payment is confirmed/failed
  4. Updates the transaction record and publishes integration events

DATABASE SCHEMA (payment):

  payment.payment_intents
  ├── id                      UUID PK
  ├── order_id                UUID NOT NULL UNIQUE
  ├── customer_id             UUID NOT NULL
  ├── amount                  DECIMAL(18,2) NOT NULL
  ├── currency                VARCHAR(3) NOT NULL DEFAULT 'USD'
  ├── status                  VARCHAR(30) NOT NULL -- 'Pending', 'Succeeded', 'Failed', 'Cancelled'
  ├── provider                VARCHAR(50) NOT NULL -- 'Stripe', 'Braintree'
  ├── provider_intent_id      VARCHAR(200) NOT NULL -- Stripe's pi_xxx ID
  ├── created_at              TIMESTAMP
  └── updated_at              TIMESTAMP

  payment.transactions
  ├── id                      UUID PK
  ├── payment_intent_id       UUID FK → payment.payment_intents.id
  ├── type                    VARCHAR(20) -- 'Charge', 'Refund'
  ├── amount                  DECIMAL(18,2) NOT NULL
  ├── status                  VARCHAR(20) NOT NULL
  ├── provider_transaction_id VARCHAR(200)
  ├── failure_reason          VARCHAR(500)
  └── processed_at            TIMESTAMP

  payment.vendor_payouts
  ├── id                      UUID PK
  ├── vendor_id               UUID NOT NULL
  ├── order_id                UUID NOT NULL
  ├── amount                  DECIMAL(18,2) NOT NULL -- after platform fee
  ├── platform_fee            DECIMAL(18,2) NOT NULL
  ├── status                  VARCHAR(20) -- 'Pending', 'Paid', 'Failed'
  └── paid_at                 TIMESTAMP

PUBLIC CONTRACTS (Payment.Contracts):

  // Integration Events
  public record PaymentSucceededIntegrationEvent(
      Guid OrderId, Guid CustomerId, decimal Amount) : IIntegrationEvent;

  public record PaymentFailedIntegrationEvent(
      Guid OrderId, string Reason) : IIntegrationEvent;

  public record RefundProcessedIntegrationEvent(
      Guid OrderId, decimal RefundAmount) : IIntegrationEvent;

**WHO LISTENS TO PAYMENT EVENTS:**
  PaymentSucceededIntegrationEvent:
    → Ordering module: Mark order as PaymentConfirmed, proceed to stock reservation
    → Notifications module: Send payment receipt email
    → Vendors module: Record confirmed sale, calculate payout
    → Analytics module: Record revenue metric

  PaymentFailedIntegrationEvent:
    → Ordering module: Mark order as PaymentFailed, then Cancelled
    → Notifications module: Send payment failure email with retry option

**KEY DESIGN DECISIONS:**
- Payment module uses Stripe's idempotency keys to prevent double-charging
- Webhook handling has deduplication logic (Stripe can send webhooks multiple times)
- Platform fee is calculated here (e.g., 5% of transaction goes to MarketHub)
- Vendor payouts are batched (processed daily via Hangfire job, not per-order)
- PCI-DSS: No raw card data ever touches this module — only Stripe tokens

### 5.8 MODULE: VENDORS


**WHAT THIS MODULE IS RESPONSIBLE FOR:**
  Everything about the sellers on the marketplace — their accounts, their
  stores, their products (the association, not the product data itself),
  their sales performance, and their payout balances.

**WHY IT EXISTS:**
  Vendors are a distinct entity type from regular users. They have a different
  lifecycle (application → approval → active → suspended), different data
  (store name, business type, tax information), and different dashboards.
  The vendor-specific business rules (approval workflow, commission rates,
  sales reporting) would pollute the Identity or Ordering modules if not isolated.

**WHAT IT OWNS:**
- Vendor account profiles (store name, description, logo)
- Vendor application and approval workflow
- Vendor status lifecycle (Applied → UnderReview → Approved → Active → Suspended)
- Commission rates per vendor (or default platform commission)
- Vendor's payout balance (accumulated from Payment module events)
- Vendor-level product association (which products belong to this vendor)
- Vendor analytics summary (total sales, total earnings — denormalized views)
- Vendor onboarding steps (profile completion, bank account, etc.)

**WHAT IT DOES NOT OWN:**
- Product details (Catalog module — vendor products ARE catalog products)
- Order details (Ordering module)
- Actual payment processing (Payment module)
- User authentication (Identity module — vendors are users with Vendor role)

DATABASE SCHEMA (vendors):

  vendors.vendor_accounts
  ├── id                  UUID PK
  ├── user_id             UUID NOT NULL UNIQUE (references identity.users by convention)
  ├── store_name          VARCHAR(200) NOT NULL
  ├── store_slug          VARCHAR(200) UNIQUE NOT NULL
  ├── store_description   TEXT
  ├── logo_url            VARCHAR(1000)
  ├── status              VARCHAR(30) NOT NULL -- 'Applied', 'UnderReview', 'Approved', 'Active', 'Suspended'
  ├── commission_rate     DECIMAL(5,4) DEFAULT 0.05  -- 5% platform fee
  ├── approved_at         TIMESTAMP
  ├── suspended_at        TIMESTAMP
  ├── suspension_reason   VARCHAR(500)
  ├── created_at          TIMESTAMP
  └── updated_at          TIMESTAMP

  vendors.payout_balances
  ├── vendor_id           UUID PK FK → vendors.vendor_accounts.id
  ├── pending_balance     DECIMAL(18,2) DEFAULT 0  -- earned but not yet paid out
  ├── available_balance   DECIMAL(18,2) DEFAULT 0  -- available for payout
  ├── lifetime_earnings   DECIMAL(18,2) DEFAULT 0
  └── last_payout_at      TIMESTAMP

  vendors.sales_summary
  ├── vendor_id           UUID PK FK → vendors.vendor_accounts.id
  ├── total_orders        INT DEFAULT 0
  ├── total_revenue       DECIMAL(18,2) DEFAULT 0
  └── last_sale_at        TIMESTAMP

PUBLIC CONTRACTS (Vendors.Contracts):

  public interface IVendorsModule
  {
      Task<VendorSummaryDto?> GetVendorAsync(Guid vendorId, CancellationToken ct = default);
      Task<bool> IsVendorActiveAsync(Guid vendorId, CancellationToken ct = default);
  }

  public record VendorSummaryDto(
      Guid VendorId, string StoreName, string StoreSlug,
      string? LogoUrl, string Status);

  // Integration Events
  public record VendorApprovedIntegrationEvent(Guid VendorId, Guid UserId) : IIntegrationEvent;
  public record VendorSuspendedIntegrationEvent(Guid VendorId, string Reason) : IIntegrationEvent;

**EVENT HANDLERS WITHIN VENDORS MODULE:**
  Listens to: PaymentSucceededIntegrationEvent
```
    → Calculate vendor payout (total - platform fee)
    → Increment vendors.payout_balances.pending_balance
    → Increment vendors.sales_summary.total_revenue

```

  Listens to: OrderCancelledIntegrationEvent
    → Decrement pending balance if applicable

### 5.9 MODULE: REVIEWS & RATINGS


**WHAT THIS MODULE IS RESPONSIBLE FOR:**
  Collecting, storing, moderating, and displaying customer reviews and star
  ratings for products on the marketplace.

**WHY IT EXISTS:**
  Reviews are conceptually distinct from products (Catalog). A product can
  exist with zero reviews. Reviews have their own moderation workflow, their
  own abuse detection, their own helpful/unhelpful voting system. Mixing this
  into the Catalog module would violate cohesion — Catalog is about describing
  products, Reviews is about the community experience around products.

**WHAT IT OWNS:**
- Review submissions (text, star rating, media uploads)
- Review moderation status (Pending → Approved / Rejected)
- Helpful votes on reviews
- Aggregated rating per product (average stars, review count)
    Note: This is the Reviews module's own aggregate — Catalog may QUERY this
```
    via public facade to display ratings, but Reviews OWNS the data.
```

- Review reply from vendors

BUSINESS RULES (domain logic):
- Only customers who PURCHASED the product can leave a review
```
    (Verified Purchase badge) — cross-module validation via event history
```

- One review per customer per product
- Reviews must be submitted within 90 days of delivery
- Minimum 10 characters for text review

HOW "ONLY PURCHASERS CAN REVIEW" WORKS:
  When an order is fulfilled (OrderFulfilledIntegrationEvent), the Reviews
  module listens and stores a record in verified_purchases table:

    reviews.verified_purchases
    ├── customer_id    UUID
    ├── product_id     UUID
    └── purchased_at   TIMESTAMP

  When a customer submits a review, the Reviews module checks its LOCAL
  verified_purchases table — no need to call the Ordering module at review time.
  This is module AUTONOMY through data duplication.

PUBLIC CONTRACTS (Reviews.Contracts):

  public interface IReviewsModule
  {
      Task<ProductRatingSummaryDto> GetProductRatingSummaryAsync(
          Guid productId, CancellationToken ct = default);
  }

  public record ProductRatingSummaryDto(
      Guid ProductId, double AverageRating, int TotalReviews,
      Dictionary<int, int> RatingDistribution);  // {5: 100, 4: 50, ...}

### 5.10 MODULE: NOTIFICATIONS


**WHAT THIS MODULE IS RESPONSIBLE FOR:**
  Sending all outbound communications — emails, SMS, and push notifications —
  triggered by events across all other modules.

**WHY IT EXISTS:**
  Without a dedicated Notifications module, notification logic bleeds into
  every other module. The Ordering module should not know how to send emails.
  The Payment module should not know about push notification formatting.
  Centralized notification management means: consistent templates, centralized
  provider configuration (SendGrid, Twilio), easy opt-out management, and
  a single place to see what notifications were sent.

**WHAT IT OWNS:**
- Notification templates (email HTML templates, SMS templates)
- Notification send history (audit log)
- User notification preferences (opt-in/opt-out per notification type)
- Delivery status tracking (sent, delivered, bounced, opened)

**WHAT IT DOES NOT OWN:**
- Any business data it's notifying about. It only receives what it needs
    from integration events. It doesn't query Orders or Products directly.

**HOW IT WORKS:**
  The Notifications module is entirely EVENT-DRIVEN. It has handlers for
  many integration events from other modules:

  UserRegisteredIntegrationEvent → Send welcome email
  OrderPlacedIntegrationEvent → Send order confirmation email (with order details from event payload)
  PaymentSucceededIntegrationEvent → Send payment receipt email
  PaymentFailedIntegrationEvent → Send payment failure email with retry instructions
  OrderFulfilledIntegrationEvent → Send delivery confirmation, prompt for review
  VendorApprovedIntegrationEvent → Send approval email to vendor
  LowStockAlertIntegrationEvent → Send low stock warning to vendor
  ReviewPostedIntegrationEvent → Send notification to vendor

DATABASE SCHEMA (notifications):

  notifications.notification_log
  ├── id                  UUID PK
  ├── user_id             UUID NOT NULL
  ├── type                VARCHAR(100) NOT NULL -- 'OrderConfirmation', 'PaymentReceipt', ...
  ├── channel             VARCHAR(20) NOT NULL -- 'Email', 'SMS', 'Push'
  ├── recipient           VARCHAR(320) NOT NULL -- email or phone
  ├── subject             VARCHAR(500)
  ├── status              VARCHAR(20) NOT NULL -- 'Queued', 'Sent', 'Delivered', 'Failed'
  ├── provider_message_id VARCHAR(200)
  ├── sent_at             TIMESTAMP
  └── failed_reason       VARCHAR(500)

  notifications.user_preferences
  ├── user_id             UUID NOT NULL
  ├── notification_type   VARCHAR(100) NOT NULL
  ├── channel             VARCHAR(20) NOT NULL
  └── is_enabled          BOOLEAN DEFAULT TRUE

### 5.11 MODULE: ANALYTICS


**WHAT THIS MODULE IS RESPONSIBLE FOR:**
  Collecting and aggregating business metrics for dashboards, reports,
  and business intelligence.

**WHY IT EXISTS:**
  Analytics has completely different requirements from operational modules.
  It doesn't need ACID consistency — eventual consistency is fine. It often
  uses different data structures (pre-aggregated, denormalized, time-series).
  It should never slow down operational flows — analytics writes happen
  asynchronously after operations complete. Separating it means the analytics
  team can use a different storage engine (ClickHouse, TimescaleDB, or even
  just pre-aggregated SQL views) without affecting the operational system.

**WHAT IT OWNS:**
- Aggregated sales metrics (revenue per day/week/month, per vendor, per category)
- Order count metrics
- User registration trends
- Product performance metrics (views, purchases, conversion rates)
- Search query analytics
- Notification delivery rates

DATABASE SCHEMA (analytics):

  analytics.daily_order_metrics
  ├── date                DATE PK
  ├── total_orders        INT DEFAULT 0
  ├── total_revenue       DECIMAL(18,2) DEFAULT 0
  ├── new_customers       INT DEFAULT 0
  └── cancelled_orders    INT DEFAULT 0

  analytics.vendor_daily_metrics
  ├── date                DATE
  ├── vendor_id           UUID
  ├── orders              INT DEFAULT 0
  ├── revenue             DECIMAL(18,2) DEFAULT 0
  └── PRIMARY KEY (date, vendor_id)

The Analytics module is PURE CONSUMER — it only listens to events, never
publishes any. It never exposes public contracts that others call.
It only provides data to the admin dashboards via its own API endpoints.

### 5.12 THE SHARED KERNEL IN THIS SYSTEM


For MarketHub, the Shared Kernel (ECommerceApp.Shared.csproj) contains:

Abstractions:
- AggregateRoot<TId>      -- base class for all aggregate roots
- Entity<TId>             -- base class for entities
- ValueObject             -- base class with structural equality
- IDomainEvent            -- marker interface for domain events
- IIntegrationEvent       -- marker interface + Id + OccurredOn timestamp
- IIntegrationEventHandler<T> -- handler interface
- IIntegrationEventBus    -- publisher interface

Common Value Objects:
- Money(decimal Amount, string Currency)
- Address(string Street, string City, string State, string PostalCode, string Country)
- UserId(Guid Value)           -- strongly typed user ID
- VendorId(Guid Value)         -- strongly typed vendor ID
- ProductId(Guid Value)        -- strongly typed product ID
- OrderId(Guid Value)          -- strongly typed order ID
- Email(string Value)          -- validated email address value object

Result Pattern:
- Result<T>               -- success/failure wrapper
- Error(string Code, string Message)

Common Types:
- PagedResult<T>          -- pagination wrapper
- CursorPage<T>           -- cursor-based pagination

Extensions:
- ClaimsPrincipalExtensions (GetUserId, GetVendorId, GetEmail)

What is NOT in the Shared Kernel:
- ❌ OrderService, ProductService, or any business logic
- ❌ Any DbContext or repository
- ❌ Any specific DTO (those live in module Contracts projects)
- ❌ ASP.NET Core controllers or middleware
- ❌ Any third-party library wrapping (keep shared kernel dependency-free)

### 5.13 HOW MODULES TALK TO EACH OTHER (REAL FLOWS)


Let's trace three key flows to see exactly how modules communicate.

**FLOW 1: A vendor creates a product**

  1. HTTP POST /api/catalog/products
     → Received by CatalogEndpoints (Catalog module)
     → Extracts VendorId from JWT token

  2. CreateProductCommandHandler (Catalog module, Application layer)
     → Calls IVendorsModule.IsVendorActiveAsync(vendorId)
        (Synchronous facade call — we NEED to know if vendor is active NOW)
     → If vendor not active: return error
     → Creates Product domain entity
     → Saves to catalog.products via CatalogDbContext
     → Publishes ProductCreatedIntegrationEvent to event bus

  3. InMemoryEventBus delivers event to all handlers:

     → InventoryModule: CreateSkuOnProductCreatedHandler
        Creates a new stock_item record in inventory.stock_items
        with quantity_on_hand = 0 (no stock yet)

     → VendorsModule: RecordVendorProductCreatedHandler
        Increments product count in vendor's profile

  4. HTTP 201 Created returned to vendor

**FLOW 2: A customer places an order (simplified — full version in 5.15)**

  1. HTTP POST /api/orders
     → Received by OrderingEndpoints (Ordering module)

  2. PlaceOrderCommandHandler (Ordering module)
     → For each line item, calls ICatalogModule.GetProductAsync(productId)
        (Synchronous — we need current price and product exists check)
     → Creates Order aggregate with line snapshots
     → Saves Order to ordering.orders via OrderingDbContext
     → Publishes OrderPlacedIntegrationEvent

  3. InMemoryEventBus delivers to:

     → PaymentModule: InitiatePaymentOnOrderPlacedHandler
        Creates a Stripe PaymentIntent, creates payment_intents record
        Returns client_secret to Ordering module...
        (Actually this is simpler: just creates the PaymentIntent and the
         response with client_secret is returned separately via a Payment API call)

     → InventoryModule: ReserveStockOnOrderPlacedHandler
        Calls IInventoryModule.ReserveStockAsync for each line item
        If stock unavailable, publishes StockReservationFailedIntegrationEvent

     → NotificationsModule: SendOrderConfirmationEmailHandler
        Uses data from the event payload (no need to query Orders)
        Sends email via SendGrid

     → AnalyticsModule: RecordOrderPlacedHandler
        Increments analytics.daily_order_metrics

**FLOW 3: Vendor is suspended (cross-module cascade)**

  1. Admin calls: PUT /api/vendors/{vendorId}/suspend
     → VendorsModule suspends vendor account
     → Publishes VendorSuspendedIntegrationEvent

  2. CatalogModule: DeactivateVendorProductsOnSuspensionHandler
     → Marks all products for this vendor as 'Archived' in catalog.products
     → Each deactivation publishes ProductDeactivatedIntegrationEvent

  3. NotificationsModule: NotifyVendorOfSuspensionHandler
     → Sends suspension notification email to vendor

  4. InventoryModule: HandleVendorSuspensionHandler
     → Prevents new reservations on vendor's products

### 5.14 THE DATABASE DESIGN PER MODULE


Full picture of how the database is organized:

SERVER: marketHub-prod-sql.database.windows.net
DATABASE: MarketHubDb

**SCHEMAS AND THEIR MODULE OWNERSHIP:**
┌──────────────────┬──────────────────────────────────────────┐
│ Schema           │ Owner Module                             │
├──────────────────┼──────────────────────────────────────────┤
│ identity         │ Identity & Access Management Module      │
│ catalog          │ Catalog Module                           │
│ inventory        │ Inventory Module                         │
│ ordering         │ Ordering Module                          │
│ payment          │ Payment Module                           │
│ vendors          │ Vendors Module                           │
│ reviews          │ Reviews & Ratings Module                 │
│ notifications    │ Notifications Module                     │
│ analytics        │ Analytics Module                         │
└──────────────────┴──────────────────────────────────────────┘

CROSS-MODULE DATA REFERENCES (by ID only, no FK constraints):

  catalog.products.vendor_id ─────────────────→ vendors.vendor_accounts.id
  ordering.orders.customer_id ────────────────→ identity.users.id
  ordering.order_lines.product_id ────────────→ catalog.products.id
  ordering.order_lines.vendor_id ─────────────→ vendors.vendor_accounts.id
  inventory.stock_items.product_id ───────────→ catalog.products.id
  payment.payment_intents.order_id ───────────→ ordering.orders.id
  payment.vendor_payouts.vendor_id ───────────→ vendors.vendor_accounts.id
  reviews.reviews.customer_id ────────────────→ identity.users.id
  reviews.reviews.product_id ─────────────────→ catalog.products.id
  notifications.notification_log.user_id ─────→ identity.users.id

None of these are enforced at the database level with FK constraints.
The application layer enforces referential integrity through:
  (a) Event-driven synchronization (when an entity is deleted, an event notifies)
  (b) Public facade validation (before using an ID, validate it exists)
  (c) Soft deletes preferred over hard deletes (mark as deleted, keep data)

SCHEMA PERMISSIONS (SQL Server):
  For extra enforcement, create SQL Server logins per module:
- identity_user: only has permissions to identity.* schema
- catalog_user: only has permissions to catalog.* schema
- ordering_user: only has permissions to ordering.* schema
  ... etc.

  Each DbContext's connection string uses the appropriate login.
  This makes it physically impossible (not just convention) for the Ordering
  module to query the catalog.products table directly.

### 5.15 THE FULL REQUEST FLOW — PLACING AN ORDER


Let's trace the complete "Place Order" flow from HTTP request to database,
including all module interactions.

**PRECONDITIONS:**
- Customer is logged in (has JWT with customerId, email, role='Customer')
- Customer has items in their cart (client-side state)
- Products exist in Catalog with stock in Inventory

**STEP 1: Customer submits POST /api/orders**
  Headers: Authorization: Bearer <jwt>
  Body: {
    "items": [
      { "productId": "p1", "variantId": "v1", "quantity": 2 },
      { "productId": "p2", "quantity": 1 }
    ],
```
    "shippingAddress": { "street": "123 Main St", "city": "NYC", ... }
```

  }

**STEP 2: Ordering Module — PlaceOrderCommandHandler**
  a. Extract customerId from JWT
  b. For each requested item:
     → Call ICatalogModule.GetProductAsync(productId)
       [Synchronous facade call to Catalog module]
       → Catalog module queries catalog.products via CatalogDbContext
       → Returns ProductSummaryDto(id, name, price, vendorId, imageUrl)
       → If product not found or not Active → return 404/400 error

  c. Create Order aggregate:
     var order = Order.Create(customerId, shippingAddress);
     For each product:
       order.AddLine(new ProductSnapshot(
         productId, variantId, product.Name, product.Price,
         product.VendorId, vendorSnapshot.StoreName, product.PrimaryImageUrl), qty);
     order.SubmitForPayment();
     → RaiseDomainEvent(OrderSubmittedDomainEvent)

  d. Save order to database:
     await _orderingDbContext.Orders.AddAsync(order);
     // Also save the integration event to the outbox (Outbox Pattern)
     await _orderingDbContext.OutboxMessages.AddAsync(new OutboxMessage
     {
         Id = Guid.NewGuid(),
         EventType = nameof(OrderPlacedIntegrationEvent),
         Payload = JsonSerializer.Serialize(new OrderPlacedIntegrationEvent(...))
     });
     await _orderingDbContext.SaveChangesAsync();
     // Both the order and the outbox message are saved in ONE transaction

**STEP 3: Outbox Processor (Background Job in Ordering module)**
  Every 1 second, the outbox processor:
  a. Reads unprocessed messages from ordering.outbox_messages
  b. For each message, calls _eventBus.PublishAsync(event)
  c. Marks the message as processed
  This ensures events are published even if the process crashes after saving
  but before publishing.

**STEP 4: Event Bus delivers OrderPlacedIntegrationEvent**
  All handlers run (potentially in parallel):

  PAYMENT MODULE handler:
  a. Creates a Stripe PaymentIntent via Stripe API
     → stripe.paymentIntents.create({ amount: totalCents, currency: 'usd', ... })
  b. Saves PaymentIntent to payment.payment_intents
  c. The client_secret is stored but NOT returned here
     (Customer must call GET /api/payments/intent/{orderId} to get it)

  INVENTORY MODULE handler:
  a. For each line item in the event:
     → UPDATE inventory.stock_items
        SET quantity_reserved = quantity_reserved + @qty
        WHERE product_id = @productId
        AND (quantity_on_hand - quantity_reserved) >= @qty
        AND version = @expectedVersion
     → If update affects 0 rows: stock insufficient
  b. If all reservations succeed: publish StockReservedIntegrationEvent
  c. If any fail: publish StockReservationFailedIntegrationEvent
     (→ Ordering module cancels order on receiving this)

  NOTIFICATIONS MODULE handler:
  a. Build email from event data (order summary)
  b. Send via SendGrid API
  c. Log in notifications.notification_log

  ANALYTICS MODULE handler:
  a. UPDATE analytics.daily_order_metrics
     SET total_orders = total_orders + 1, total_revenue = total_revenue + @amount
     WHERE date = CURRENT_DATE

  VENDORS MODULE handler:
  a. For each unique vendor in the line items:
     UPDATE vendors.sales_summary
     SET total_orders = total_orders + 1, total_revenue = total_revenue + @vendorAmount
     WHERE vendor_id = @vendorId

**STEP 5: HTTP Response to customer**
  HTTP 201 Created
  Body: { "orderId": "...", "status": "PaymentPending", ... }

**STEP 6: Frontend initiates payment (separate flow)**
  Customer's browser calls GET /api/payments/intent/{orderId}
  → Payment module returns client_secret
  → Browser uses Stripe.js to confirm payment with client_secret + card details
  → Stripe processes payment directly
  → Stripe sends webhook to POST /api/payments/webhook

**STEP 7: Payment webhook received**
  → Payment module updates payment_intents.status = 'Succeeded'
  → Payment module publishes PaymentSucceededIntegrationEvent

**STEP 8: PaymentSucceededIntegrationEvent handled**

  ORDERING MODULE:
  → order.ConfirmPayment(); → Status = PaymentConfirmed → Status = Confirmed

  NOTIFICATIONS MODULE:
  → Send payment receipt email

  VENDORS MODULE:
  → Calculate payout: amount - platform_fee
  → UPDATE vendors.payout_balances SET pending_balance += payoutAmount

END RESULT: Order is confirmed, inventory is reserved, vendor is credited,
customer has received confirmation email. All within a single process.
No distributed transactions. No saga orchestration needed.
The modular monolith's shared database context makes this reliable.

### 5.16 THE FULL REQUEST FLOW — VENDOR ONBOARDING


This flow shows how the system handles a new vendor registering.

**STEP 1: User is already registered as Customer**
  POST /api/vendors/apply
  Body: { "storeName": "Awesome Gadgets", "storeDescription": "...", ... }
  Auth: JWT with role='Customer'

**STEP 2: Vendors module processes the application**
  a. VendorApplicationCommandHandler runs
  b. Check: Does this user already have a vendor account? If yes → error
  c. Create VendorAccount domain entity with status = 'Applied'
  d. Save to vendors.vendor_accounts
  e. Publish VendorApplicationSubmittedIntegrationEvent

**STEP 3: Event handled**
  NOTIFICATIONS MODULE: Send application received confirmation email
  IDENTITY MODULE: No action needed yet (role is added only on approval)

**STEP 4: Admin approves via admin panel**
  PUT /api/vendors/{vendorId}/approve
  Auth: JWT with role='Admin'

  VendorApprovalCommandHandler:
  a. Load vendor from vendors.vendor_accounts
  b. vendor.Approve(); → Status = 'Active'
  c. Save changes
  d. Call IIdentityModule.AssignRoleAsync(vendor.UserId, "Vendor")
     [Synchronous facade call — we need this to happen now]
  e. Publish VendorApprovedIntegrationEvent

**STEP 5: VendorApprovedIntegrationEvent handled**
  NOTIFICATIONS MODULE: Send approval email with getting started guide
  IDENTITY MODULE: (Already handled synchronously above)

**STEP 6: Vendor logs in again**
  New JWT now includes: role='Vendor', vendorId='...'
  Vendor can now access vendor dashboard, create products, view earnings

## PART 6 — ADVANCED PATTERNS


### 6.1 CQRS INSIDE A MODULE


CQRS = Command Query Responsibility Segregation.
Separate the "write" path (commands) from the "read" path (queries).

**WHY USE IT IN EACH MODULE:**
  Write operations need: validation, domain logic, consistency, transactions
  Read operations need: speed, denormalized data, flexibility, pagination

  If you use the same model for both, you end up with compromises that make
  neither path optimal. CQRS lets each path be optimized independently.

IN .NET WITH MEDIATR:
  Commands (write side):
    PlaceOrderCommand → PlaceOrderCommandHandler
      - Validates input (FluentValidation)
      - Loads domain aggregate (Order)
      - Calls domain methods (order.SubmitForPayment())
      - Persists via repository
      - Publishes integration events
      - Returns a simple response (OrderId, status)

  Queries (read side):
    GetOrderQuery → GetOrderQueryHandler
      - NO domain model loaded — reads directly from DbContext with projections
      - Returns a rich DTO with all display data
      - Can join across tables WITHIN THE SAME MODULE (NOT across modules)
      - Can use raw SQL for complex read queries
      - Can be cached if appropriate

  Example query handler that bypasses the domain model for performance:

    internal class GetOrderQueryHandler : IRequestHandler<GetOrderQuery, OrderDetailDto>
```
    {
        private readonly OrderingDbContext _db;

        public async Task<OrderDetailDto> Handle(GetOrderQuery query, CancellationToken ct)
        {
            var order = await _db.Orders
                .AsNoTracking()       // Read-only — no change tracking overhead
                .Include(o => o.Lines)
                .Where(o => o.Id == new OrderId(query.OrderId))
                .Select(o => new OrderDetailDto(
                    o.Id.Value,
                    o.Status.ToString(),
                    o.TotalAmount.Amount,
                    o.PlacedAt,
                    o.Lines.Select(l => new OrderLineDto(
                        l.ProductId.Value,
                        l.ProductName,
                        l.UnitPrice.Amount,
                        l.Quantity)).ToList()
                ))
                .FirstOrDefaultAsync(ct);

            return order ?? throw new NotFoundException($"Order {query.OrderId} not found");
        }
    }

```

READ MODELS vs WRITE MODELS:
  Over time, you might split the read and write databases:
  Write DB: SQL Server (normalized, consistent)
  Read DB: Redis or a separate read replica with denormalized views

  This is advanced — start with one database, optimize later.

### 6.2 THE OUTBOX PATTERN FOR RELIABLE EVENTS


**THE PROBLEM:**
  After saving an order to the database, you publish an integration event.
  But what if the process crashes AFTER saving but BEFORE publishing?
  The order is saved but no one knows about it. Payment never initiates.
  Inventory never reserves. Customer never gets an email.
  This is a real reliability problem.

THE SOLUTION — OUTBOX PATTERN:
  Instead of publishing directly after saving, you save the integration event
  to an "outbox" table IN THE SAME TRANSACTION as the business operation.
  A background processor then reads from the outbox and publishes reliably.

DATABASE TABLE (ordering schema):
  ordering.outbox_messages
  ├── id              UUID PK
  ├── event_type      VARCHAR(500) NOT NULL
  ├── payload         JSONB / NVARCHAR(MAX) NOT NULL
  ├── occurred_on     TIMESTAMP NOT NULL
  └── processed_on    TIMESTAMP (NULL = not yet processed)

**SAVING THE OUTBOX MESSAGE:**
  // In PlaceOrderCommandHandler:
  await _db.Orders.AddAsync(order);
  await _db.OutboxMessages.AddAsync(new OutboxMessage
  {
      Id = Guid.NewGuid(),
      EventType = typeof(OrderPlacedIntegrationEvent).FullName,
      Payload = JsonSerializer.Serialize(new OrderPlacedIntegrationEvent {...}),
      OccurredOn = DateTime.UtcNow
  });
  await _db.SaveChangesAsync(); // Single transaction — both or neither

OUTBOX PROCESSOR (Background job per module):
  public class OrderingOutboxProcessor : BackgroundService
  {
      protected override async Task ExecuteAsync(CancellationToken ct)
      {
          while (!ct.IsCancellationRequested)
          {
              await ProcessPendingMessagesAsync(ct);
              await Task.Delay(TimeSpan.FromSeconds(1), ct);
          }
      }

      private async Task ProcessPendingMessagesAsync(CancellationToken ct)
      {
          using var scope = _serviceProvider.CreateScope();
          var db = scope.ServiceProvider.GetRequiredService<OrderingDbContext>();
          var bus = scope.ServiceProvider.GetRequiredService<IIntegrationEventBus>();

          var messages = await db.OutboxMessages
              .Where(m => m.ProcessedOn == null)
              .OrderBy(m => m.OccurredOn)
              .Take(20) // batch size
              .ToListAsync(ct);

          foreach (var message in messages)
          {
              var eventType = Type.GetType(message.EventType);
              var @event = JsonSerializer.Deserialize(message.Payload, eventType);
              await bus.PublishAsync((IIntegrationEvent)@event, ct);
              message.ProcessedOn = DateTime.UtcNow;
          }

          await db.SaveChangesAsync(ct);
      }
  }

**GUARANTEES:**
- At-least-once delivery (event might be published more than once if processor crashes mid-batch)
- Handlers must be IDEMPOTENT (handle the same event twice safely)
- For ordering, use the ProcessedOn timestamp to detect duplicates in handlers

**WHEN TO MOVE TO A REAL MESSAGE BROKER:**
  When you extract a module to a microservice, replace:
- InMemoryEventBus → RabbitMQ / Azure Service Bus publisher
- OutboxProcessor → reads from outbox, publishes to the queue
  The outbox table and processor code change minimally. The interface stays the same.

### 6.3 SAGA / PROCESS MANAGER FOR LONG-RUNNING FLOWS


Some business processes span multiple steps and can take time to complete.
The "Place Order" flow is one: reserve stock, charge payment, confirm order.
If payment fails, release the stock reservation. If stock fails, cancel order.
This is a SAGA — a sequence of steps with compensating actions on failure.

IN A MODULAR MONOLITH, SAGAS ARE SIMPLER:
  Because everything is in-process, you can implement a saga as a regular
  application service (Process Manager) that:
  1. Listens to events from multiple modules
  2. Tracks the current state of the long-running process
  3. Sends commands to other modules based on the current state

EXAMPLE: OrderFulfillmentSaga (lives in the Ordering module)

  // Saga state stored in the database:
  ordering.order_fulfillment_sagas
  ├── order_id          UUID PK
  ├── state             VARCHAR(50) -- 'AwaitingPayment', 'AwaitingStock', 'Completed', 'Compensating'
  ├── payment_confirmed BOOLEAN DEFAULT FALSE
  ├── stock_reserved    BOOLEAN DEFAULT FALSE
  ├── started_at        TIMESTAMP
  └── completed_at      TIMESTAMP

  // Saga coordinator (event handlers + state machine)
  public class OrderFulfillmentSaga :
      IIntegrationEventHandler<OrderPlacedIntegrationEvent>,
      IIntegrationEventHandler<PaymentSucceededIntegrationEvent>,
      IIntegrationEventHandler<PaymentFailedIntegrationEvent>,
      IIntegrationEventHandler<StockReservedIntegrationEvent>,
      IIntegrationEventHandler<StockReservationFailedIntegrationEvent>
  {
      public async Task HandleAsync(OrderPlacedIntegrationEvent e, CancellationToken ct)
      {
          // Create saga state record
          await _repo.CreateSagaAsync(e.OrderId, SagaState.AwaitingPayment);
          // Payment module already handles OrderPlacedEvent and initiates payment
          // Saga just tracks the state
      }

      public async Task HandleAsync(PaymentSucceededIntegrationEvent e, CancellationToken ct)
      {
          var saga = await _repo.GetSagaAsync(e.OrderId);
          saga.PaymentConfirmed = true;
          saga.State = SagaState.AwaitingStock;
          // If stock already reserved (can happen in different order):
          if (saga.StockReserved) await CompleteSagaAsync(saga);
          await _repo.UpdateAsync(saga);
      }

      public async Task HandleAsync(PaymentFailedIntegrationEvent e, CancellationToken ct)
      {
          var saga = await _repo.GetSagaAsync(e.OrderId);
          // Compensate: if stock was reserved, release it
          if (saga.StockReserved)
              await _inventoryModule.ReleaseReservationAsync(e.OrderId, ct);
          // Cancel the order
          await _mediator.Send(new CancelOrderCommand(e.OrderId, "Payment failed"));
      }

      // ... other handlers
  }

**WHEN TO USE A SAGA:**
- A business process spans more than 2 steps across module boundaries
- Steps can fail and need compensating actions
- The process takes time (might span seconds or minutes)
- You need to track the overall state of the process

**WHEN NOT TO USE A SAGA:**
- For simple 2-step operations (just use event handlers)
- When everything can be wrapped in a single DB transaction

### 6.4 FEATURE FLAGS PER MODULE


Feature flags let you deploy code without activating features. This is
critical for continuous delivery and A/B testing.

In .NET, use Microsoft.FeatureManagement:

  // In any module
  private readonly IFeatureManager _features;

  public async Task Handle(PlaceOrderCommand cmd, CancellationToken ct)
  {
      if (await _features.IsEnabledAsync("NewPricingEngine"))
      {
          // Use new pricing logic
      }
      else
      {
          // Use existing pricing logic
      }
  }

Feature flags can be module-specific (stored in appsettings or Azure App Config):

  appsettings.json:
  {
```
    "FeatureManagement": {
      "NewPricingEngine": false,
      "MultiCurrencySupport": false,
      "VendorAnalyticsDashboard": true
    }
```

  }

Each module registers its own feature definitions.
No module accesses another module's feature flags directly.

### 6.5 MODULE HEALTH CHECKS


Each module should register its own health checks:

  // In AddOrderingModule():
  services.AddHealthChecks()
      .AddDbContextCheck<OrderingDbContext>(
          name: "ordering-database",
          tags: new[] { "ordering", "database" })
      .AddCheck<OrderingOutboxHealthCheck>(
          name: "ordering-outbox",
          tags: new[] { "ordering", "outbox" });

  // OrderingOutboxHealthCheck
  public class OrderingOutboxHealthCheck : IHealthCheck
  {
      private readonly OrderingDbContext _db;

      public async Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken ct)
      {
          var stalledMessages = await _db.OutboxMessages
              .CountAsync(m => m.ProcessedOn == null &&
                          m.OccurredOn < DateTime.UtcNow.AddMinutes(-5), ct);

          return stalledMessages > 100
              ? HealthCheckResult.Degraded($"{stalledMessages} outbox messages stalled")
              : HealthCheckResult.Healthy();
      }
  }

  // Host exposes the health endpoint
  app.MapHealthChecks("/health", new HealthCheckOptions
  {
      Predicate = _ => true,
      ResponseWriter = UIResponseWriter.WriteHealthCheckUIResponse
  });

  app.MapHealthChecks("/health/ordering", new HealthCheckOptions
  {
      Predicate = check => check.Tags.Contains("ordering")
  });

### 6.6 CACHING STRATEGY PER MODULE


Each module decides its own caching strategy based on its data characteristics.

CATALOG MODULE (heavy read, slow-changing data):
- Cache product list responses in Redis for 5 minutes
- Cache individual product details for 30 minutes
- Invalidate cache when ProductUpdatedIntegrationEvent is received

  // In Catalog module using IMemoryCache or IDistributedCache
  public async Task<ProductSummaryDto?> GetProductAsync(Guid productId, CancellationToken ct)
  {
      var cacheKey = $"catalog:product:{productId}";
      if (_cache.TryGetValue(cacheKey, out ProductSummaryDto? cached))
          return cached;

      var product = await _db.Products.FindAsync(productId, ct);
      var dto = product?.ToSummaryDto();

      if (dto is not null)
          _cache.Set(cacheKey, dto, TimeSpan.FromMinutes(30));

      return dto;
  }

INVENTORY MODULE (critical consistency, no stale reads):
- Do NOT cache stock levels — always read from DB
- Stale stock levels could lead to overselling

REVIEWS MODULE (read-heavy aggregates):
- Cache the aggregated rating summary per product (update when new review is approved)
- Cache individual review pages for 10 minutes

IDENTITY MODULE (tokens are validated per request):
- Do NOT cache individual user data — always read fresh for security decisions
- Cache JWT public keys (refresh rarely)

### 6.7 RATE LIMITING AND THROTTLING AT THE MODULE LEVEL


ASP.NET Core 7+ has built-in rate limiting middleware.
Each module can define its own rate limiting policies:

  // In AddCatalogModule() — catalog browsing is liberal
  services.AddRateLimiter(options =>
  {
      options.AddPolicy("catalog-browse", context =>
          RateLimitPartition.GetTokenBucketLimiter(
              context.Connection.RemoteIpAddress?.ToString() ?? "unknown",
              _ => new TokenBucketRateLimiterOptions
              {
                  TokenLimit = 100,
                  ReplenishmentPeriod = TimeSpan.FromMinutes(1),
                  TokensPerPeriod = 100
              }));
  });

  // In AddOrderingModule() — ordering is strict
  services.AddRateLimiter(options =>
  {
      options.AddPolicy("ordering-create", context =>
          RateLimitPartition.GetSlidingWindowLimiter(
              context.User?.FindFirst("sub")?.Value ?? context.Connection.RemoteIpAddress?.ToString(),
              _ => new SlidingWindowRateLimiterOptions
              {
                  PermitLimit = 5, // Max 5 order submissions per minute per user
                  Window = TimeSpan.FromMinutes(1),
                  SegmentsPerWindow = 6
              }));
  });

  // Applied to the endpoint:
  group.MapPost("/orders", CreateOrder)
       .RequireRateLimiting("ordering-create");

## PART 7 — TESTING A MODULAR MONOLITH


### 7.1 UNIT TESTING MODULES IN ISOLATION


Each module is tested independently. The ideal unit test tests domain logic
in isolation — no database, no network, no other modules.

EXAMPLE: Unit testing the Order domain aggregate

  [Fact]
  public void Order_AddLine_IncreasesTotalAmount()
  {
      // Arrange
      var order = Order.Create(
          new CustomerId(Guid.NewGuid()),
          new Address("123 Main", "NYC", "NY", "10001", "US"));

      var product = new ProductSnapshot(
          productId: Guid.NewGuid(), name: "Test Widget",
          price: new Money(29.99m, "USD"), vendorId: Guid.NewGuid(),
          vendorName: "Test Vendor");

      // Act
      order.AddLine(product, quantity: 2);

      // Assert
      order.TotalAmount.Amount.Should().Be(59.98m);
      order.Lines.Should().HaveCount(1);
  }

  [Fact]
  public void Order_Cancel_WhenShipped_ThrowsException()
  {
      // Arrange
      var order = Order.Create(...);
      order.AddLine(...);
      order.SubmitForPayment();
      order.ConfirmPayment();
      order.MarkAsShipped();

      // Act & Assert
      order.Invoking(o => o.Cancel("test"))
          .Should().Throw<InvalidOperationException>()
          .WithMessage("*shipped*");
  }

Unit tests should be fast (< 1ms each), plentiful, and test ONE behavior.
Target: 70-80% of your tests should be unit tests.

### 7.2 INTEGRATION TESTING WITH THE REAL DATABASE


Integration tests test a module end-to-end with a real database.
Use a real SQL Server (TestContainers in .NET is excellent for this).

**SETUP:**

  // Using Testcontainers.MsSql
  public class OrderingIntegrationTests : IAsyncLifetime
  {
      private MsSqlContainer _sqlContainer;
      private OrderingDbContext _db;

      public async Task InitializeAsync()
      {
          _sqlContainer = new MsSqlBuilder()
              .WithImage("mcr.microsoft.com/mssql/server:2022-latest")
              .Build();

          await _sqlContainer.StartAsync();

          var options = new DbContextOptionsBuilder<OrderingDbContext>()
              .UseSqlServer(_sqlContainer.GetConnectionString())
              .Options;

          _db = new OrderingDbContext(options);
          await _db.Database.MigrateAsync();
      }

      [Fact]
      public async Task PlaceOrder_PersistsToDatabase()
      {
          // Arrange
          var mockCatalog = new Mock<ICatalogModule>();
          mockCatalog.Setup(c => c.GetProductAsync(It.IsAny<Guid>(), default))
              .ReturnsAsync(new ProductSummaryDto(Guid.NewGuid(), ...));

          var handler = new PlaceOrderCommandHandler(
              _db, mockCatalog.Object, new InMemoryEventBus());

          // Act
          var result = await handler.Handle(new PlaceOrderCommand(...), default);

          // Assert
          var order = await _db.Orders.FindAsync(result.OrderId);
          order.Should().NotBeNull();
          order.Status.Should().Be(OrderStatus.PaymentPending);
      }

      public async Task DisposeAsync()
      {
          await _sqlContainer.StopAsync();
      }
  }

Key patterns:
- Mock other modules' facades (ICatalogModule, IInventoryModule)
- Use real DB for the module being tested
- Test the complete command handler flow
- Test that events are written to the outbox

### 7.3 ARCHITECTURE TESTS — ENFORCING MODULE BOUNDARIES


This is the most powerful and important test category for a modular monolith.
Architecture tests AUTOMATICALLY FAIL THE BUILD if module boundaries are violated.

Use NetArchTest.Rules (NuGet package):

  public class ArchitectureTests
  {
      [Fact]
      public void OrderingModule_ShouldNotReference_CatalogModuleInternals()
      {
          var result = Types
              .InAssembly(typeof(OrderingModule).Assembly) // Ordering module
              .That()
              .ResideInNamespace("ECommerceApp.Modules.Ordering")
              .ShouldNot()
              .HaveDependencyOn("ECommerceApp.Modules.Catalog") // But CAN reference Catalog.Contracts
              .GetResult();

          result.IsSuccessful.Should().BeTrue(
              because: "Ordering module must not depend on Catalog module internals");
      }

      [Fact]
      public void OrderingModule_CanReference_CatalogContracts()
      {
          // This is the ALLOWED dependency
          var types = Types
              .InAssembly(typeof(OrderingModule).Assembly)
              .That()
              .HaveDependencyOn("ECommerceApp.Modules.Catalog.Contracts")
              .GetTypes();

          // This test just documents that this is intentional
          types.Should().NotBeEmpty(because: "Ordering legitimately uses Catalog contracts");
      }

      [Fact]
      public void DomainLayer_ShouldNot_DependOnInfrastructure()
      {
          var result = Types
              .InAssembly(typeof(Order).Assembly)
              .That()
              .ResideInNamespace("ECommerceApp.Modules.Ordering.Domain")
              .ShouldNot()
              .HaveDependencyOn("Microsoft.EntityFrameworkCore")
              .GetResult();

          result.IsSuccessful.Should().BeTrue();
      }

      [Fact]
      public void AllModuleDbContexts_ShouldBe_Internal()
      {
          var publicDbContexts = Types
              .InAssemblies(GetAllModuleAssemblies())
              .That()
              .Inherit(typeof(DbContext))
              .And()
              .ArePublic()
              .GetTypes();

          publicDbContexts.Should().BeEmpty(
              because: "All DbContexts must be internal to their module");
      }
  }

Run these in CI/CD. A boundary violation = build failure. No exceptions.
This keeps the architecture honest as the team grows.

### 7.4 CONTRACT TESTS BETWEEN MODULES


When Module A depends on Module B's public contract (ICatalogModule),
both sides need tests that verify the contract is honored.

CONSUMER TEST (Ordering module — the consumer):
  Tests that Ordering correctly uses the ICatalogModule interface:

  [Fact]
  public async Task PlaceOrder_WhenProductNotFound_ShouldReturnError()
  {
      var catalog = new Mock<ICatalogModule>();
      catalog.Setup(c => c.GetProductAsync(It.IsAny<Guid>(), default))
          .ReturnsAsync((ProductSummaryDto?)null);

      var handler = new PlaceOrderCommandHandler(catalog.Object, ...);
      var result = await handler.Handle(new PlaceOrderCommand(...), default);

      result.IsFailure.Should().BeTrue();
      result.Error.Code.Should().Be("Product.NotFound");
  }

PROVIDER TEST (Catalog module — the provider):
  Tests that CatalogModuleFacade correctly implements ICatalogModule:

  [Fact]
  public async Task GetProductAsync_WhenProductExists_ReturnsCorrectDto()
  {
      // Seed the catalog DB
      // Call CatalogModuleFacade.GetProductAsync(productId)
      // Verify the returned DTO matches the interface's expectations
  }

Together, these ensure that the contract is both correctly used and correctly provided.

## PART 8 — MIGRATION AND OPERATIONS


### 8.1 STARTING GREENFIELD — THE RIGHT WAY


If you're starting a new project with the intention of building it as a
modular monolith from day one, here is the recommended sequence:

WEEK 1-2: Domain Discovery
- Run event storming sessions with business stakeholders
- Identify the bounded contexts (your future modules)
- Document the "ubiquitous language" per context (the words each area uses)
- Don't write code yet. Understand the domain first.

WEEK 2-3: Solution Setup
- Create the solution structure (Host, Shared, Modules)
- Create the Shared Kernel with base classes and abstractions
- Create the InMemoryEventBus implementation
- Create the first module (usually Identity — everything depends on users)
- Set up CI/CD pipeline with architecture tests

WEEK 3-N: Module by Module
- Build modules in order of business priority
- Each module follows the same internal structure
- Write architecture tests for each new module
- Integrate modules via events and facades as you build
- Don't try to build all modules simultaneously — finish one properly first

**ORDERING RECOMMENDATION FOR MARKETHUB:**
  1. Identity (users, authentication — everyone needs this)
  2. Vendors (needed before products can be created)
  3. Catalog (the products vendors sell)
  4. Inventory (stock tracking for catalog items)
  5. Ordering (customers can now buy)
  6. Payment (money collection)
  7. Notifications (communication layer)
  8. Reviews (social proof)
  9. Analytics (business intelligence)

### 8.2 MIGRATING A BIG BALL OF MUD TO MODULAR


If you have an existing messy monolith and want to modularize it, here is
the realistic path. This takes time — usually 6-18 months for a real system.

**STEP 1: Understand what you have**
- Draw a dependency graph of the existing code
- Identify natural clusters (things that change together, owned by one team)
- These clusters will become your modules
- Look for God Classes and God Services — these will need to be broken up

**STEP 2: Introduce the Shared Kernel**
- Extract common abstractions (base classes, common types) into Shared Kernel
- Don't move business logic here — only technical abstractions

**STEP 3: Identify boundaries with the Strangler Fig pattern**
- Pick ONE bounded context to modularize first (start small, prove the pattern)
- Create the new module structure for it alongside the existing code
- Move classes one by one into the module, adding tests as you go
- Replace direct calls with facade calls and events
- Delete the original messy code once the module is proven

**STEP 4: Tackle the database**
- Add schema prefixes to tables (ALTER SCHEMA, not rename tables initially)
- Gradually remove cross-schema JOINs — replace with application-level lookups
- Add outbox tables per module
- Add module-specific DbContexts (may need to coexist with old context)

**STEP 5: Introduce the event bus**
- Add the InMemoryEventBus infrastructure
- Gradually replace direct service calls with events
- Start with non-critical paths (notifications are a great first target)

**STEP 6: Enforce with architecture tests**
- Add NetArchTest rules as you clean up each module
- This catches regressions and prevents new spaghetti from forming

**REALISTIC EXPECTATIONS:**
- This is not a weekend project. Plan for 1-2 quarters per major module
- You will be doing this alongside normal feature development
- Prioritize based on which areas cause the most pain
- Celebrate incremental wins — each boundary established is a victory

### 8.3 MIGRATING FROM MODULAR MONOLITH TO MICROSERVICES (WHEN READY)


When a specific module genuinely needs to be extracted (due to measured scaling
needs or independent deployment requirements), here is the process:

PRECONDITION: The module is already well-isolated with:
- ✅ Clear public contracts (interfaces in Contracts project)
- ✅ No cross-module DB dependencies
- ✅ Integration events for cross-module communication
- ✅ Outbox pattern for reliable event publishing

**STEP 1: Extract the database**
- Point the module's DbContext at a separate database connection string
- Ensure no other module's DbContext reads from this schema
- Run migrations to create the new database (in parallel with old)
- Migrate data from old schema to new database

**STEP 2: Replace the in-memory event bus with a real queue (for this module)**
- Replace InMemoryEventBus usage in this module with RabbitMQ/ASB publisher
- All other modules consuming events from this module switch to queue consumers
- This can be done without breaking the modular monolith (just changing the bus impl)

**STEP 3: Replace facade calls with HTTP/gRPC**
- Any module that calls IXxxModule.Facade replace with an HTTP client
- The module being extracted now exposes an HTTP or gRPC endpoint
- Keep the IXxxModule interface — just change the implementation to an HTTP client

**STEP 4: Deploy separately**
- Remove the module's code from the monolith solution
- Deploy it as a standalone service
- Update configuration for the remaining monolith modules

**STEP 5: Monitor and validate**
- Ensure the extracted service is healthy
- Validate that cross-module flows still work
- Monitor latency (now includes network round trips)

The key insight: because the module was ALREADY isolated, steps 1-4 are
mechanical. There's no redesign of the business logic. You're just changing
the transport mechanism.

### 8.4 DEPLOYMENT — DOCKER, KUBERNETES, AND EVERYTHING ELSE


A modular monolith is a SINGLE APPLICATION. Deployment is as simple as any
other single application.

**DOCKERFILE:**
  FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
  WORKDIR /app
  EXPOSE 8080

  FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
  WORKDIR /src
  COPY ["src/Host/ECommerceApp.Host.csproj", "src/Host/"]
  COPY ["src/Shared/ECommerceApp.Shared.csproj", "src/Shared/"]
  COPY ["src/Modules/Catalog/ECommerceApp.Modules.Catalog.csproj", "src/Modules/Catalog/"]
  # ... all module project files
  RUN dotnet restore "src/Host/ECommerceApp.Host.csproj"
  COPY . .
  RUN dotnet build "src/Host/ECommerceApp.Host.csproj" -c Release
  RUN dotnet publish "src/Host/ECommerceApp.Host.csproj" -c Release -o /app/publish

  FROM base AS final
  WORKDIR /app
  COPY --from=build /app/publish .
  ENTRYPOINT ["dotnet", "ECommerceApp.Host.dll"]

KUBERNETES (one Deployment, just like any app):
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: markethub-api
  spec:
    replicas: 3    # Scale horizontally when needed
    selector:
      matchLabels:
        app: markethub-api
    template:
      spec:
        containers:
        - name: markethub-api
          image: markethub-api:v1.2.3
          ports:
          - containerPort: 8080
          env:
          - name: ConnectionStrings__DefaultConnection
            valueFrom:
              secretKeyRef:
                name: db-secrets
                key: connection-string

AZURE (for .NET developers, Azure is natural):
- Azure App Service: simplest option for a modular monolith (just deploy the DLL)
- Azure Container Apps: managed containers, auto-scaling, no Kubernetes complexity
- Azure SQL: managed SQL Server (the database for all module schemas)
- Azure Cache for Redis: for module-level caching
- Azure Service Bus: when you eventually need real async messaging
- Azure Application Insights: for logging and tracing

**SCALING A MODULAR MONOLITH:**
- You scale the entire application (all modules together)
- Behind a load balancer with multiple instances
- Stateless design is required (session state in Redis, not in-memory)
- Database connection pooling is important with multiple instances
- The outbox processor needs to handle concurrent instances safely
```
    (use database row locking or Redis distributed locks)

```

### 8.5 SCALING A MODULAR MONOLITH


Horizontal scaling means running multiple instances of the same application.
Everything must be STATELESS for this to work.

**STATELESS REQUIREMENTS:**
- ✅ No in-memory session state (use distributed session with Redis)
- ✅ No in-memory cache that can go stale (use IDistributedCache with Redis)
- ✅ No singleton services that hold mutable state between requests
- ✅ Background job concurrency control (two instances shouldn't process same outbox message)

**HANDLING OUTBOX CONCURRENCY:**
  When two instances both run the outbox processor:
  Option A: Use database row locking
```
    SELECT TOP 20 FROM outbox_messages WHERE processed_on IS NULL
    ORDER BY occurred_on
    WITH (UPDLOCK, ROWLOCK, READPAST)  -- SQL Server: skip locked rows

```

  Option B: Use a distributed lock (Redlock pattern with Redis)
  Option C: Use a single dedicated outbox processor instance

VERTICAL SCALING (bigger server) is often the right answer:
  A modular monolith on a 32-core, 128GB RAM machine can handle enormous load.
  Before going horizontal, consider: is vertical scaling simpler and cheaper?
  For MarketHub, a 2x16-core SQL Server + 4x8-core API servers can handle
  millions of daily active users with the modular monolith approach.

### 8.6 ZERO DOWNTIME DEPLOYMENTS


Even with a single application, you can achieve zero downtime deployments.

**BLUE-GREEN DEPLOYMENT:**
- Run two identical environments (blue = current, green = new version)
- Deploy to green, run smoke tests
- Switch load balancer from blue to green
- Blue is on standby for instant rollback

ROLLING DEPLOYMENT (Kubernetes):
- Kubernetes gradually replaces old pods with new pods
- At any point, some pods run old version, some run new
- Requires backward-compatible API changes during transition

**DATABASE MIGRATION STRATEGY FOR ZERO DOWNTIME:**
  The tricky part is database schema changes. Approach:

  1. EXPAND: Deploy a migration that ADDS new columns/tables (backward compatible)
     - New code reads from new columns
     - Old code still works (new columns are nullable or have defaults)

  2. MIGRATE: Run a background job to populate new columns from old data

  3. CONTRACT: Once all instances use new code, deploy a cleanup migration
     - Remove old columns/tables
     - This migration runs only after all instances are on new code

  Never do a migration that REMOVES or RENAMES columns in a single deployment.
  Always use the expand/contract pattern.

## PART 9 — WHAT NOT TO DO


### 9.1 COMMON MISTAKES WHEN BUILDING A MODULAR MONOLITH


Having described what to do, let's be very clear about what NOT to do.
These mistakes are common and will undermine your architecture.

MISTAKE 1: MODULE BOUNDARIES BASED ON TECHNICAL LAYERS
  WRONG: "Module" = Controllers, "Module" = Services, "Module" = Repositories
  RIGHT: "Module" = Catalog, "Module" = Ordering, "Module" = Payment
  WHY WRONG: Technical layers cut across business concerns. A Catalog operation
  touches its own controller, service, AND repository. Layer-based modules
  force everything to talk to everything.

MISTAKE 2: SHARING A DBCONTEXT ACROSS MODULES
  WRONG: One giant ApplicationDbContext with all tables registered
  RIGHT: One DbContext per module, scoped to its schema
  WHY WRONG: Shared DbContext means any module can load any entity from any table.
  No one can prevent it. Boundaries become fictional.

MISTAKE 3: MAKING "MODULES" THAT ARE JUST NAMESPACES
  WRONG: Organizing code into folders called "Catalog", "Ordering" but
         everything is in one project with no enforcement
  RIGHT: Separate .csproj projects per module, or at minimum, architecture tests
  WHY WRONG: Without enforcement, developers will take shortcuts. "Just this once
  I'll call the product repository directly from the order handler." It compounds.

MISTAKE 4: THE SHARED KERNEL BECOMING A DUMPING GROUND
  WRONG: Adding business services, business entities, cross-module repositories to Shared
  RIGHT: Only true domain-agnostic abstractions and value objects in Shared
  WHY WRONG: A fat Shared Kernel creates the same coupling problem as no boundaries.
  Everyone depends on Shared, Shared has everything, you're back to a ball of mud.

MISTAKE 5: SYNCHRONOUS FACADE CALLS FOR EVERYTHING
  WRONG: Every module calls every other module via synchronous facades
  RIGHT: Use events for post-hoc reactions, facades only for synchronous lookups
  WHY WRONG: Excessive synchronous cross-module calls create runtime coupling.
  If Catalog goes down (unlikely in same process, but imagine a future extraction),
  Ordering goes down too. Also, it hides the natural eventual consistency in the domain.

MISTAKE 6: PUTTING CROSS-MODULE JOIN QUERIES IN THE DATABASE
  WRONG: SELECT o.*, c.name FROM ordering.orders o
         JOIN catalog.products c ON o.product_id = c.id
  RIGHT: Store snapshots in ordering.order_lines (product name, price at purchase time)
  WHY WRONG: Cross-schema JOINs couple the schemas at the database level.
  If Catalog changes its products table structure, the Ordering join breaks.
  Snapshots + application-level composition = true isolation.

MISTAKE 7: NOT HAVING ARCHITECTURE TESTS
  WRONG: Trusting developers to follow boundaries by convention
  RIGHT: Automated architecture tests that fail the build if rules are violated
  WHY WRONG: Under deadline pressure, shortcuts happen. Architecture degrades
  gradually, one "just this once" at a time. Tests make boundaries non-negotiable.

MISTAKE 8: PUTTING ALL MODULES IN ONE HUGE FEATURE FOLDER
  WRONG: src/Features/Catalog/ProductController.cs (all in one project, bad folder structure)
  RIGHT: src/Modules/Catalog/ECommerceApp.Modules.Catalog.csproj (separate project)
  WHY WRONG: Without separate projects, the compiler can't enforce boundaries.

### 9.2 ANTI-PATTERNS TO AVOID COMPLETELY


ANTI-PATTERN: THE SHARED DATABASE ENTITY
  Using the same EF Core entity class in multiple modules.
  Example: Both Ordering and Catalog use the Product class.
  Each module MUST have its own internal representation.
  Share only IDs (value objects) through the Shared Kernel.

ANTI-PATTERN: THE MODULE THAT KNOWS EVERYTHING
  A "Common" or "Core" module that all other modules depend on,
  which contains business logic from multiple domains.
  This is just a hidden monolith inside your modular monolith.

ANTI-PATTERN: CIRCULAR MODULE DEPENDENCIES
  Module A depends on Module B which depends on Module A.
  This is always a design smell — one of them is in the wrong bounded context.
  Resolve by extracting shared behavior into the Shared Kernel or by
  inverting the dependency direction via events.

ANTI-PATTERN: THE GOD MODULE
  One module that does too much — the "Business Logic" module, the "Core" module.
  If a module can't be described in one clear noun, it's doing too much.
  Split it.

ANTI-PATTERN: EVENT SPAGHETTI
  Events that trigger events that trigger events with no clear flow.
  Event A → Handler publishes Event B → Handler publishes Event C → Handler publishes A again.
  Maintain a clear event flow diagram. Every event should have a clear origin
  and clear consumers. If tracing an event requires following 5 hops, simplify.

ANTI-PATTERN: ANEMIC DOMAIN MODEL IN MODULES
  Module has a Product entity with only properties and no methods.
  All logic is in ProductService.
  This is not DDD. Domain entities should have behavior.
  Order.Place(), Product.Deactivate(), Vendor.Approve() — logic lives in the entity.

ANTI-PATTERN: USING MEDIATR AS A MODULE BOUNDARY
  Some teams use MediatR commands as the inter-module communication mechanism.
  PlaceOrderCommand sent from Catalog to Ordering via MediatR.
  This is wrong — MediatR is for in-module CQRS. Use facades/events for cross-module.
  MediatR across modules hides dependencies and makes the module graph unclear.

### 9.3 THE THINGS THAT MAKE IT COLLAPSE


The modular monolith is not a silver bullet. It CAN collapse under these conditions:

**COLLAPSE CONDITION 1: TEAM DOESN'T BUY IN**
  If developers don't understand and respect the architecture, boundaries erode.
  Mitigation: Architectural documentation, code reviews that check boundaries,
  automated architecture tests, regular architecture review sessions.

**COLLAPSE CONDITION 2: THE SHARED KERNEL GROWS UNCONTROLLED**
  If every "cross-cutting" thing ends up in Shared, you've built a hidden monolith.
  Mitigation: Regular reviews of Shared Kernel additions. High bar for what goes there.
  Rule: "If in doubt, don't put it in Shared."

**COLLAPSE CONDITION 3: SKIPPING THE ARCHITECTURE TESTS**
  "We'll add them later." Later never comes. Boundaries erode silently.
  Mitigation: Architecture tests are DAY ONE requirements, not optional extras.

**COLLAPSE CONDITION 4: THE BUSINESS GROWS FASTER THAN THE ARCHITECTURE RESPONDS**
  New features are added to the closest existing module rather than creating
  a new module when a new bounded context emerges.
  Mitigation: Regular domain review sessions. When a module starts handling
  two distinct business concerns, split it proactively.

**COLLAPSE CONDITION 5: IGNORING THE DATABASE LAYER**
  Cross-schema JOINs are added because they're "simpler."
  Mitigation: Database schema permissions per module. Code review checks.
  Architecture tests that scan for cross-schema references.

## PART 10 — SUMMARY AND DECISION FRAMEWORKS


### 10.1 THE DECISION CHECKLIST


**USE THIS BEFORE CHOOSING YOUR ARCHITECTURE:**

□ How many engineers will be building this? (< 5 = monolith, 5-80 = modular monolith, 80+ = consider microservices)
□ Is the domain complex with multiple distinct business areas? (yes = modular monolith candidate)
□ Do you have specific, MEASURED scaling requirements per component? (no = probably not microservices yet)
□ Do different parts of the system need to deploy independently right now? (no = modular monolith is fine)
□ Does your team have microservices operational expertise? (if not, microservices will be painful)
□ Are you still learning the domain? (if yes, monolith first — boundaries will emerge)
□ Do you need ACID transactions across business operations? (yes = modular monolith has advantage)
□ Is minimizing infrastructure cost important right now? (yes = modular monolith)
□ Do you want to be able to extract services later without a rewrite? (yes = modular monolith with clean boundaries)

ANSWERING "YES" TO MOST OF THESE POINTS TO MODULAR MONOLITH.

### 10.2 THE HONEST TRADEOFFS TABLE


┌───────────────────────────────┬─────────────────────────┬────────────────────────┐
│ CONCERN                       │ MODULAR MONOLITH: WIN   │ MODULAR MONOLITH: LOSS │
├───────────────────────────────┼─────────────────────────┼────────────────────────┤
│ Deployment simplicity         │ ✅ One artifact          │                        │
│ Local development             │ ✅ One "dotnet run"      │                        │
│ Debugging                     │ ✅ One process to attach │                        │
│ Transactional integrity       │ ✅ Same DB server        │                        │
│ In-module refactoring         │ ✅ Internal visibility   │                        │
│ Code sharing (Shared Kernel)  │ ✅ Direct reference      │                        │
│ Build time                    │ ✅ One build pipeline    │                        │
│ Initial setup complexity      │ ✅ Lower than microsvcs  │                        │
│ Team ownership of modules     │ ✅ Clear boundaries      │                        │
│ Independent module scaling    │                          │ ❌ Scale whole app      │
│ Technology heterogeneity      │                          │ ❌ One tech stack       │
│ Independent module deployment │                          │ ❌ All deploy together  │
│ True data isolation           │                          │ ❌ Shared DB server     │
│ Blast radius of bugs          │                          │ ❌ Bug can affect all   │
│ Horizontal scale efficiency   │                          │ ❌ Wasteful at extremes │
└───────────────────────────────┴─────────────────────────┴────────────────────────┘

The losses are real but manageable for 90% of systems. The wins are substantial.
Most engineering teams overestimate how much they need the microservices wins
and underestimate the ongoing cost of managing them.

### 10.3 FINAL WORDS


After all of this, here is the summary for a .NET backend engineer:

THE MODULAR MONOLITH IS THE PROFESSIONAL CHOICE FOR MOST SYSTEMS.

It gives you:
- The simplicity of a single deployment
- The clarity of well-defined module boundaries
- The ability to work in teams without stepping on each other
- The flexibility to extract services when you genuinely need to
- The power of ACID transactions where they matter
- The joy of "dotnet run" bringing up the entire system locally

As a .NET engineer, you have all the tools:
- Clean Architecture / Onion Architecture for module internals
- EF Core with multiple DbContexts for per-module data isolation
- MediatR for CQRS within modules
- ASP.NET Core's DI and extension methods for module registration
- NetArchTest for boundary enforcement
- Testcontainers for integration testing
- ASP.NET Core's Minimal API for module endpoint registration

The industry pressure toward microservices is real but often misapplied.
Amazon, Netflix, Uber — they NEEDED microservices at their scale.
You are probably not at their scale yet, and if you are, you have the budget
to handle the operational complexity.

Build the modular monolith. Ship it. Make money. When a module needs to be
a service, extract it. You'll be able to do so cleanly, because you built it right.

The goal was never to have microservices. The goal was to build great software.
A modular monolith, done well, is great software.


END OF GUIDE

Written for: .NET Backend Engineers
Real-world example: MarketHub Multi-Vendor E-Commerce Platform
Guide size: 85KB+ of structured, practical, honest content
