# TouchWood Platform — Consolidated Overview

**Purpose:** everything I hold as true, after the handoff document, your corrections across this conversation, and the design mockup. Read it as a checklist. Correct anything wrong before we start.

**Status of the design file:** unpacked and read in full — the home page, the storefront (category / product / cart), and the admin panel including its section specification. It is the most informative artefact in the project so far, and it contradicts or extends the handoff in roughly twenty places. Those are in §4 and §5.

---

# 1. The business

This was thin in the handoff and the design made it concrete. Stating it because several design decisions only make sense against it.

TouchWood is a **kitchen and wardrobe hardware supplier in Saudi Arabia** — hinges, drawer slides, handles, wardrobe organizers, cabinet lighting, fittings. Warehouse in Al-Khumrah, Jeddah. It is the **exclusive Saudi agent for Tallsen** and a distributor for Hettich, Blum and Häfele, alongside its own **TouchWood house brand**.

Two customer populations, buying the same goods:

- **Individuals** fitting a single kitchen. Buy by the piece, no minimum, no account needed to browse.
- **Workshops, carpenters and fit-out contractors** fitting ten a month. Buy by volume at tier prices.

The catalog in the mockup is roughly **840 products across 6 top categories**, not the 5,000 in the handoff. Worth confirming which is right — it changes nothing architecturally, but it changes what "slow" means.

This explains things that looked arbitrary before: the technical list view with SKU and finish columns, the "complete the set" bundles, the contractor catalog, the per-piece price emphasis, and why wholesale is public rather than gated.

---

# 2. Settled — do not re-open

## 2.1 Shape

One Laravel 13 codebase, one PostgreSQL database, one deployment. Three country Stores (KSA, Egypt, UAE) under `brand.com/sa|eg|ae`. Adding a country is INSERT plus configuration, never a deploy. No country name, currency code or store code appears anywhere in `Domain/` or `Application/`.

Global: product identity, SKU, variants, attribute definitions, categories, brands, translations, media, staff, roles, permissions, customer identity.
Store-scoped: availability, visibility, prices, stock, slugs, tax, payment config, carriers, coupons, promotions, homepage content, loyalty config and balances, carts, orders, payments.

Stack: Inertia + React + shadcn/ui with SSR, PostgreSQL, Redis + Horizon, Postgres FTS + `pg_trgm` for search, Laravel session auth (no JWT), Deptrac CI-blocking from commit one, Larastan level 8, Pest.

Modular monolith. A module may import only `Modules/{Other}/Public/**` and `Shared/**`. Three communication channels: synchronous public contracts, asynchronous integration events carrying IDs not payloads, and a tiny shared kernel. DTOs only across boundaries, never Eloquent models. One schema per module, foreign keys across schemas allowed, Eloquent relationships across modules forbidden.

## 2.2 The two axes — settled this conversation

| Axis | Values | Meaning | Where it lives |
|---|---|---|---|
| **`audience`** | `PUBLIC` / `COMPANY` | Who is buying | Price lists, coupons, promotions, gift rules, homepage config, loyalty redemption mode |
| **`sale_mode`** | `RETAIL` / `WHOLESALE` | How it is being sold | Product enablement per store, quantity rules and MOQ, cart lines, order lines, wholesale page |

Independent. A private customer buying at MOQ is `PUBLIC` + `WHOLESALE`. An approved company buying one piece is `COMPANY` + `RETAIL`. `COMPANY` means `company.status == APPROVED`. Nothing named `b2c` or `b2b` exists in the schema; those stay UI words.

## 2.3 Accounts

**Account type is chosen at registration and never changes.** No upgrade, no downgrade, in any direction, from any state. All related transitions deleted.

Two actor types with separate guards: `Customer` and `StaffUser`. A staff account and a customer account never share a table with a boolean.

Registration by email only. Email verified, then phone added and verified by SMS OTP. Ordering requires both. One phone per account, never null once set; changing it keeps the old number live until the new one verifies.

Roles are database rows created by the admin at runtime, named in Arabic and English, built by checking permissions, optionally cloned from an existing role as a **copy** — never live inheritance. Permissions are `{module}.{resource}.{action}`, derived from the use-case catalog, checked in the application layer, deny by default. Super Admin bypasses via `Gate::before`, is non-deletable and non-editable, and is **seeded**. Store access lives on the role assignment, not the user: `All Stores` or `Selected Stores` with a checklist.

Staff onboarding: admin creates the record, system emails an expiring invitation link, staff set their own password, admin never knows it. Invitations can be cancelled and resent.

**Account status vs company status are separate concerns** — see §6.3.

## 2.4 Company accounts

Four statuses only:

```
PENDING    can log in, browse, build a cart. CANNOT order. Company prices visible.
APPROVED   can order. Company prices. IBAN visible.
REJECTED   can log in, edit company info, reapply. CANNOT order. Reapply → PENDING.
SUSPENDED  can log in, view past orders and the suspension notice. CANNOT order.
```

Ordering rule, with no special cases: `company.status === APPROVED`.

`AWAITING_DOCUMENTS`, `REJECTED_ONCE`, `REJECTED_BLOCKED` and every downgrade transition are removed. Reapplication is unlimited and returns to `PENDING`; a company cannot submit a new application while one is already pending. The reapply form carries documents and a note.

A pending company **sees company prices, not public prices** — it simply cannot check out.

Registration fields: company name, company type, responsible person and phone, address, Commercial Registration, Tax Number, plus a document upload area. Document types seen in the design: VAT certificate, commercial registration, authorised signatory ID.

**B2B pays offline only.** No gateway for company accounts. Order placed → flagged for staff → bank transfer to the IBAN shown on site, or wait for staff contact. (But see §4.3 — the design contradicts this.)

## 2.5 Catalog

Every product has at least one variant; a simple product is a product with exactly one variant. One code path everywhere downstream.

Product data is identical across stores — name, slug, photos, description, everything — **except price and stock**.

Attributes can be informational, filterable, or variant-generating. Price is per combination, never additive. The backend resolves the variant, always.

Categories nest without limit and carry an admin-set rank per store. Brands are global: name ar/en, slug, logo, description, status.

Product status is three independent axes: editorial (`DRAFT | ACTIVE | ARCHIVED`), availability derived from stock, and `force_unavailable` as an override. **Out of stock is never a flag** — it is a stock movement. `force_unavailable` is the separate "stock exists but must not be sold" boolean, surfaced in the admin as "Not available now."

Alternative search names (synonyms) per product, entered by staff or seeded.

## 2.6 Brand — settled this conversation

One `products.brand_id`, NOT NULL, admin form pre-selects TouchWood. Not a table per brand: 840 products filtered on an indexed column is sub-millisecond work, and separate tables would force UNIONs in search, double the Odoo mapping, and make adding a brand a migration.

```
brands
├── id, slug, name_ar, name_en, logo, description
├── origin_country, agency_type (house | exclusive_agent | distributor | imported)
├── is_default                     ← TouchWood
├── show_in_default_listings       ← TouchWood true, Tallsen false
└── position, is_active
```

`show_in_default_listings` is denormalized into `product_search` so the default grid is one indexed predicate with no join. Toggling it triggers a re-stamp job for that brand's rows.

**Tallsen categories use option (a):** one global category tree. Tallsen products sit in it alongside everything else. The "Tallsen section" the customer sees is the tree filtered to that brand. No second tree, no schema change.

## 2.7 Pricing

One generalized price-list mechanism. Everything is a price list, differing by `audience`, `kind`, `priority` and date window:

| Concept | Expression |
|---|---|
| Retail base price | `PUBLIC`, priority 0, min_qty 1, no dates |
| Sale price | `PUBLIC`, priority 10, dated |
| Wholesale tiers | One row per quantity band |
| Seasonal promotion | `kind = CAMPAIGN`, higher priority, dated |
| Company price | `audience = COMPANY` |

Resolution: filter by store, audience eligibility and active date → order by priority DESC → match the quantity band → first hit. Materialized into `effective_prices` so resolution never runs at request time.

`PricingEngine::calculate(PricingContext): PriceQuote` is a pure function with no database access.

The backend is the only authority on price. Per-store price editing is permission-scoped by the existing store-access model.

Money is `(bigint minor_units, string currency_code)` with the exponent read from a `currencies` row. Never DECIMAL, never float, never a hardcoded `/100`. `Money` exposes `format()`, `add()`, `multiply()` and `allocate()`.

**Canonical amounts — confirmed:**

```
gross_subtotal  = Σ (list price × qty)
net_subtotal    = Σ (effective unit price × qty)
coupon_discount
points_discount
goods_total     = net_subtotal − coupon_discount − points_discount
shipping
taxable_base    = goods_total + shipping
vat             = taxable_base × store.tax_percentage
order_total     = taxable_base + vat
```

Thresholds bind to named amounts: coupon minimum → `net_subtotal`; free shipping → `goods_total`; gift eligibility → `goods_total`; points earning base → `goods_total`; VAT → `taxable_base`.

## 2.8 Discounts, coupons, points

**One coupon code per order.** The customer chooses either a personal code or a public one. Never two.

**Line-level application.** A coupon applies only to the lines it is eligible for. A mixed cart of discounted and normal products does not cause a rejection — the coupon lands on the eligible lines and leaves the rest alone.

**Per-coupon `allow_with_points`** decides whether points may be combined with that specific code.

**Assigned coupons** — new this conversation:

```
coupons.eligibility          PUBLIC | ASSIGNED
coupon_assignments           coupon_id, customer_id, assigned_at, notified_at, used_at
```

Assignment is by **segment**, not one customer at a time. Segments are saved definitions, split by individual and company:

```
customer_segments
├── name_ar, name_en
├── type            DYNAMIC (rule-based) | STATIC (hand-picked)
├── audience        INDIVIDUAL | COMPANY
└── rules           no_orders_ever | last_order_before(X) | order_count >= N in period | store

customer_segment_members    ← materialized, nightly + on demand
```

Examples in scope: frequent buyers, monthly buyers, no order in 6 months, no order in a year. **Not** in scope: spend-based grouping.

Segments are reusable — newsletters, pop-up targeting, notifications — not coupon-only.

*Recommendation needing your yes:* assignment **snapshots** membership at the moment of assigning. Otherwise a "hasn't ordered in 6 months" customer loses their coupon the instant they order, which is the opposite of the intent.

Each coupon carries expiry date **and** max uses per customer, whichever hits first; or date only, meaning unlimited uses within the window.

Coupons are store-scoped while accounts are global, so a coupon works in KSA and not in Egypt for the same person. Confirmed.

**The discount ceiling** — the rule that replaces the three open stacking questions:

Per store, admin-defined `max_discount_percent`, 0–100. Evaluation is strictly ordered so the outcome is deterministic:

```
1. Product / campaign / category prices resolve  → net_subtotal
2. Coupon applies to eligible lines
      → if it would breach the ceiling, reject the coupon with a message
3. Points apply
      → if they would breach, reject the whole redemption and return the points unused
         (points are all-or-nothing, so a partial application is not possible)
```

Points are evaluated last and refused first, which matches your description exactly.

## 2.9 Inventory

Stock reserves through an atomic conditional UPDATE — zero affected rows means insufficient stock, no explicit lock, no race.

```
available_to_sell = on_hand − reserved − safety_buffer
```

`stock_movements` is an append-only ledger with a unique `external_ref`, and it doubles as the sync mechanism. Reservations expire; a scheduled job releases them.

**Every store always reads stock from our system.** External providers are synchronization partners, never a read-time source. No external call ever happens inside a web request.

## 2.10 External inventory providers — generalized this conversation

Any store may optionally connect an external inventory system. Odoo is one adapter, not the domain. A store with no connection row has the sync layer dormant. `stock_items.source` disappears as a concept.

Connection is **all or nothing** per store: if a provider is connected, every product in that store syncs.

Sync rules:

- **Stock** syncs as signed movements with idempotency refs, never absolute quantities. Absolute values are used only for nightly reconciliation and never silently overwrite.
- **Prices and product details** sync **last-write-wins in both directions**. No side "wins." Every resolution writes a row to `sync_conflicts` so a lost edit is visible rather than silent.
- Event-driven both ways on edit, a 15-minute cursor poll as a safety net, nightly full reconciliation that reports drift without auto-correcting.
- FIFO per entity, not one global queue. Failure is halt-and-escalate, not rollback: four attempts, then dead-letter, halt that entity's FIFO only, notify staff, admin screen to retry or resolve.
- Loop prevention by origin tagging plus content checksum. Both required.

**Price mapping to an external provider — proposed, needs your yes.** Your model (one price + a discount amount + an expiry) maps onto price lists cleanly if we treat it as the *sync contract* rather than the internal model:

| External field | Maps to |
|---|---|
| Product price | `kind = BASE`, `audience = PUBLIC`, min_qty 1, no dates |
| Discount + expiry | `kind = SALE`, `audience = PUBLIC`, dated, `input_mode = PERCENT_OFF \| FIXED_OFF` |
| Nothing | Wholesale tiers, company prices, category discounts, campaigns — **ours only, never synced** |

When the external discount expires, the SALE row's window closes and BASE resolves again on its own. The original price was never overwritten, so there is no restore step and nothing to lose. This is exactly the behaviour you described, achieved structurally.

On your alternative — putting a price-list id in the product's price column — the direction has to be the reverse. A product doesn't point at a list; lists hold rows pointing at variants, and one variant can be touched by five lists simultaneously (base, sale, tier, company, category discount). A single foreign key can't express that.

## 2.11 Sales

```
Cart   — mutable, permissive, no invariants, one store only, survives 30+ days
  ↓ StartCheckout
Quote  — server-computed, itemised, immutable, ~15 min TTL
  ↓ PlaceOrder(quoteId)   ← the client posts an id, never amounts
Order  — permanent, fully snapshotted
```

All orders, individual and company, pass manual staff approval. Historical orders never change when the catalog changes.

Four independent state machines — order, payment, fulfilment (per shipment), return — presented to the customer as one derived status and to staff as all four.

## 2.12 Payments, shipping, returns

Gateway adapters in code behind a `PaymentGateway` interface with no `refund()` method. Admin configures adapters — enable per store, credentials in an encrypted column, display name, logo, ordering, min/max order value, audience restriction — but cannot add or edit gateways.

**All refunds are manual**, partial and full alike. Staff execute a bank transfer and record it.

Carriers are fixed-rate tables defined by staff. No live rate APIs. Tracking is a URL template rendered with the tracking number. Shipping is domestic only per store. Free-shipping threshold per store per carrier.

Packaging: products are auto or manual. Auto compares weight and three dimensions against box maxima with admin-set padding and picks the smallest fit. Manual bypasses the engine entirely and flags the order for staff. No 3D bin packing.

Return window admin-configurable per store, return shipping paid by the company.

## 2.13 Loyalty

Points earn on **DELIVERED**, reverse on cancellation or completed return, proportionally on partial return. Only those two triggers. Per store, isolated. FIFO expiry with an admin-defined period. Earn rate and redeem rate are separate admin values. Minimum redemption threshold. Redemption mode `ALL_OR_NOTHING` or `PARTIAL`, set separately per audience. Maximum redemption percentage of an order. Points redeem as a direct discount, never a generated code. Negative balances allowed with no expiry, with a checkout warning.

## 2.14 Conventions — all approved

ULID primary keys, bigint for high-volume ledgers. Human-facing codes separate from ids (`TW-10428`). `timestamptz`, UTC in the database, converted at the presentation edge. Soft deletes only where needed, never on ledgers or orders. One aggregate per transaction, `DB::transaction()` in the command handler and never in a repository. `after_commit` globally, outbox for ~8 critical events. Module-owned exception hierarchies inheriting a base error class, never leaking `ModelNotFoundException`. Idempotency keys on every webhook. Two validation layers. `spatie/laravel-data` DTOs. Backed enums stored as strings. Structured logging. A feature is not finished until its tests are written.

Internationalization: translation tables for searchable entities, JSON columns for labels. Arabic default. No fallback on name and slug — publish blocks if a locale is missing. Arabic slugs for `ar`, Latin for `en`, both with history for 301s. Tailwind logical properties only. Postgres `ar-x-icu` collation. Arabic normalization on write and on query: strip tashkeel and tatweel, normalize alef forms, `ى → ي`, `ة → ه`, Arabic-Indic digits.

---

# 3. Answers to your questions

## 3.1 Why media goes to object storage, not the database

Putting images in Postgres costs you five things:

Every image read pulls bytes through the connection pool and the app server, so the database becomes a file server competing with the queries that actually need it. Backups balloon — a 200 GB image database means 200 GB backups and a restore measured in hours. No CDN can cache at the edge, so a customer in Jeddah fetches from origin every single time, which is precisely the latency you are rebuilding to remove. No range requests or partial reads. And the connection pool exhausts under image load in a way that takes the whole site down, not just the images.

Object storage plus CDN: the application stores only a key, the browser fetches from the nearest edge, the database stays small enough to restore quickly.

The pipeline: pre-generate sizes on upload (thumb, card, detail, zoom) in WebP and AVIF with a JPEG fallback. Never resize at request time. Explicit width and height attributes to prevent layout shift. Lazy load below the fold.

```
media
├── id, disk, object_key, mime, bytes
├── width, height, checksum          ← dedupe identical uploads
├── alt_ar, alt_en
└── uploaded_by, created_at
```

Permissions `platform.media.upload` and `platform.media.delete`, so role assignment controls it exactly as you described.

## 3.2 Account deletion — anonymize

Yes, that is what I meant, and it is the non-harmful approach:

- The account can no longer log in.
- Personal fields on the customer are overwritten: name → "Deleted customer", email → an irreversible hash placeholder preserving uniqueness, phone → null, saved addresses purged, preferences cleared.
- **Order rows keep their snapshot** of name, phone and delivery address as captured at order time, because that is a financial record and it is what protects you in a dispute.

Two sub-decisions: does the order snapshot itself get anonymized after a retention period (Saudi commercial record-keeping generally wants around ten years), and do the customer's reviews survive as "Deleted customer" or get removed.

## 3.3 Account status vs company status

Separate concerns, separate columns, different owners. Never conflated.

```
customers.status   ACTIVE | BLOCKED        ← Access module. Controls LOGIN.
companies.status   PENDING | APPROVED      ← B2B module. Controls ORDERING and PRICING.
                 | REJECTED | SUSPENDED
```

A BLOCKED person cannot log in regardless of company status. A SUSPENDED company logs in fine but cannot order. Both audited independently.

The ordering gate becomes one function, with no branching per account type:

```
canPlaceOrder(customer) =
       customer.status == ACTIVE
   AND customer.email_verified_at != null
   AND customer.phone_verified_at != null
   AND (customer.account_type == INDIVIDUAL
        OR customer.company.status == APPROVED)
```

## 3.4 Addresses — per store, as you asked

Each store owns its own address shape. Implemented so that Egypt changing its format is a configuration row rather than a migration:

```
addresses
├── customer_id, store_id, label, recipient_name, phone, is_default
└── fields  JSONB            ← the country-specific shape

store_address_formats
├── store_id
├── field definitions: key, label_ar, label_en, required, validation, order
└── display_template          ← how it renders on the order and the shipping label
```

Send me each store's format when you have them and I'll fill the config.

---

# 4. Where the design contradicts the specification

Each of these needs a decision. They are ordered by how much they change.

## 4.1 Warehouses exist

The handoff says explicitly: one stock pool per store, no warehouse entity, physical locations are not this system's concern.

The design says otherwise, in four places. The inventory screen has a **Warehouse** column with *Riyadh main*, *Jeddah branch* and *Dammam hub*. Store settings carry a **"Ships from"** value per store. The order sidebar lists **"Warehouse pickup — orders the customer collects from a branch or warehouse."** A customer enquiry in the support screen reads *"Is 160mm in stock in Jeddah?"*

This is a genuine multi-location inventory model inside a single store, and it is the single largest change the design introduces. It affects the stock table's primary key, the availability calculation, reservation (which location holds the stock), fulfilment (which location ships), the pickup flow as a fulfilment type, and the external sync mapping (each location maps to a provider warehouse reference).

Three options:

**(a)** Locations are real. Stock is per `(store, location, variant)`. Availability sums across locations in the store. Pickup is a fulfilment method. This is correct if you genuinely hold different stock in Riyadh and Jeddah and a customer can collect.
**(b)** Locations are labels only. One pool per store; "warehouse" is informational text for staff. Simplest, and matches the handoff.
**(c)** Defer. Build one pool per store now, with the stock table keyed so a location column can be added later without rewriting.

I need to know which. If (a), Inventory grows considerably and it must be decided before Catalog, not after.

## 4.2 Tax classes per product

The handoff is emphatic: a fixed percentage per store, no zero-rating, no exemptions, no per-product tax classes.

The product editor in the design has a **Tax class** field with *Standard 15% VAT* and *Zero rated*.

These cannot both be true. Zero-rating is real in Saudi VAT for exports and a few categories, so the design may be right. But it changes the tax model from a single store number to a table of classes with a per-product assignment, and it changes `taxable_base` from one number to a per-class breakdown.

## 4.3 Credit terms — Net 30 and Net 60

Not in the handoff anywhere. The design has it in five places: company accounts carry a **Credit terms** column with *Prepaid*, *Net 30*, *Net 60*; orders carry a payment state of **`terms`**; the sidebar has **"Unpaid orders — awaiting payment or on approved credit terms"**; and the company review screen sets terms at approval.

This is trade credit. The company orders now and pays in thirty days. It is a different thing from "B2B pays by bank transfer," and it brings with it: a credit terms field on the company, probably a credit limit, an aging report, a payment due date on the order, and a dunning process when a company goes past due.

It also partly explains the confusion earlier about B2B online payment. If terms exist, the question was never "card or transfer" — it was "prepaid or on account."

Needs a straight answer: **is trade credit in scope for v1?**

## 4.4 Payment methods per store

| Store | Design shows | Handoff says |
|---|---|---|
| KSA | Mada, Visa, Apple Pay, **Tamara** | Fatoorati |
| Egypt | Visa, **Fawry**, **Cash on delivery** | Undecided |
| UAE | Visa, Apple Pay, **Tabby** | Undecided |

Fatoorati does not appear in the design at all. Three things follow.

**Cash on delivery** is new and is not a small addition — it means the order ships unpaid, the carrier collects, money is reconciled against a remittance file, and failed deliveries carry real cost. It has its own payment status, its own reconciliation screen and its own fraud exposure.

**Tamara and Tabby** move from "undecided" to "shown in the UI." The BNPL mechanism itself is simple because they pay you in full, but they are still two adapters.

**Fatoorati** — is it still the gateway, or has that changed?

## 4.5 UAE is not launched

Store settings show KSA live, Egypt live, **UAE not launched**. The handoff says all three launch together.

Small, but it means the store record needs a lifecycle (`live` / `not_launched` / `disabled`) and the storefront needs to handle a configured-but-unpublished store, rather than assuming every store row is a live site.

## 4.6 The wallet is back

The handoff removed store credits entirely and recorded it as a decision — points replaced them because credits are a monetary liability with legal weight.

The design has **"Wallet top-up requests"** under payments and **"Wallet top-up history"** under reports.

A wallet is store credit. If it is in scope, the removal decision is reversed and the Loyalty module needs a sibling: a ledger, top-up approval, refund rules, and an accounting treatment for customer money you are holding.

## 4.7 "Campaign" means two different things

In the handoff, a campaign is a dated high-priority price list — a pricing mechanism.

In the design, a campaign is a **visual theme**: twelve presets (Ramadan, Eid, National Day, Founding Day, Flash Sale, Wholesale offers…), one live at a time, filling six positions — announcement bar, homepage hero, homepage promo, listing banners, product badges, cart messaging. The screen says, in as many words, that *a visual theme does not create discounts, and promotional pricing is configured separately.*

These are two separate features sharing a word, and the design is right to separate them. So:

- **Campaign (Content module)** — theme, artwork, copy, positions, schedule. No prices.
- **Promotional price list (Pricing module)** — the actual discount. Already specified.

They link optionally, so activating the Ramadan theme can point at the Ramadan price list, but neither requires the other.

## 4.8 Print invoice

The handoff is clear that this system issues no invoices; Odoo does. The order screen has a **Print invoice** button.

Most likely this is an order confirmation or packing document rather than a tax invoice, which is fine. But if staff expect a real invoice out of this button, that is the removed scope walking back in, and it is the single most expensive thing on this list.

## 4.9 Incoming stock and pre-order

Inventory has an **Incoming** column. The category filter has **"includes pre-order."** Support shows *"Any restock date?"*

The handoff has no backorder concept at all. If a customer can order something out of stock and wait, that changes reservation, order state, fulfilment timing and the delivery promise on the product page.

---

# 5. Scope in the design that is not in the specification

Not conflicts — additions. Grouped by whether they change the module structure.

## 5.1 New modules implied

**Support** — tickets with status, assignee and response time; live product chats; written product enquiries; contact channels with working hours and out-of-hours auto-reply; a WhatsApp toggle. None of this exists in the 14 modules. It is a module of its own, and live chat in particular is a real build.

**Content grows a lot** — a blog with posts and categories, a projects showcase with shoppable part lists, newsletters with subscribers and send history, pop-up offers with targeting, alert banners, a "smart bar" above listings, and campaign themes. Content was a thin tier-3 module; this makes it a proper one.

**Reporting becomes real** — profit report (which requires a **cost of goods** field per variant per store, currently nowhere in the model), product sales, stock, favourites, and a **customer searches report including zero-result searches**. That last one is genuinely valuable: it is the source list for your synonyms.

## 5.2 Catalog additions

Category-level discounts with a window and an applies-to scope (all variants, retail only, wholesale only, selected brands). Custom labels on cards such as "new" or "clearance." A colour library with swatch values feeding variants. Warranty as a reusable record with periods and terms rather than free text. **Product add-ons** — installation service, gift wrapping, extended warranty — which are sellable services attached to a product and therefore new line types with their own pricing and tax treatment. CSV product import.

## 5.3 Loyalty additions

The design calls the whole thing **Cashback** and adds two things the handoff does not have: **per-product earn-rate overrides**, and **loyalty packages** — tiers such as *Contractor plan* and *Showroom plan* unlocking benefits like free delivery, early access and a dedicated account manager. The homepage advertises **2× points on approved wholesale orders**, which is an audience-based earn multiplier.

## 5.4 Storefront additions

Save for later in the cart. Abandoned cart tracking, including a separate wholesale variant. A grid / technical-list toggle on listings, where the technical list drops the image and adds SKU and finish columns, and the choice persists. A branches page. Public order tracking by number. A downloadable technical catalog PDF. Client logo marquee. Guest price visibility as a toggle. A setting for whether retail and wholesale lines may be mixed in one cart.

## 5.5 Admin additions

Internal notes attachable to a product, order or company, with author and pin. A monthly sales target with achieved and remaining. Two-factor authentication for staff. Staff profile fields — job title, date of birth, phone, country, address — and **per-staff notification preferences** (new orders, company applications, low stock, campaign expiry). Bank transfer verification with a required receipt image, a verification time target, and a "hold stock while verifying" setting.

---

# 6. What is still blocking

## 6.1 Client deliverables outstanding

| Item | Blocks |
|---|---|
| **External provider schema, credentials, real product sample** | Catalog, Sync, Inventory. Still the longest pole. |
| Payment gateway docs and sandbox | Payments |
| Box list with inner dimensions and max weights | Shipping / packaging |
| Carrier list and rate tables | Shipping |
| SMS provider | Access (OTP), Ops |
| Email provider and sending domain | Access, Ops |
| Per-store address formats | Access, Shipping |
| Old database dump | Migration |

## 6.2 Decisions needed before Platform and Access start

Everything else can be answered while we build. These cannot:

1. **Warehouses** — §4.1, options (a), (b) or (c). Affects the Platform store record and the Inventory key.
2. **Tax classes** — §4.2. A single store percentage, or a class table.
3. **Store lifecycle** — §4.5. Does a store record carry `live / not_launched / disabled`.
4. **Staff 2FA** — in or out of Access v1.
5. **Staff profile fields and per-staff notification preferences** — in or out of Access v1.
6. **Order snapshot retention** on account deletion — §3.2.
7. **Coupon assignment snapshot** — §2.8, confirm the recommendation.
8. **Discount ceiling base** — does the ceiling govern only customer-applied discounts (coupon and points), with merchant pricing exempt, or does it cap total reduction from list price including campaign prices? A clearance item at 70% off under a 50% ceiling is the case that decides it.

## 6.3 Decisions needed before Catalog, Pricing and Sales

Trade credit (§4.3), cash on delivery (§4.4), the wallet (§4.6), pre-order (§4.9), product add-ons (§5.2), cost of goods (§5.1), loyalty tiers and per-product rates (§5.3), and the external price mapping (§2.10).

## 6.4 Still confirmed and still undesigned

**Bundles** — the design promotes them heavily on the product page with a savings figure and an "add the whole set" button, so they are real and visible. They touch stock reservation, price composition, packaging and discount eligibility at once. Must be specified before Catalog.

**Reviews** — the design shows 4.6 from 128 ratings, verified-purchase badges, the purchased variant on each review, and the translate button behaviour. Needs a module home; my recommendation is its own thin module rather than inside Catalog, because moderation, translation caching and rating aggregation have nothing to do with what we sell or how it is found.

**Wishlist / favourites** — the design adds a favourites report and a most-favourited ranking, so it needs more than a join table.

**Cancellation flow, notification matrix, search ranking** — all still undesigned.

---

# 7. Build plan

**Stage 1 — Platform.** Stores with lifecycle, currencies, tax configuration, settings, media pipeline, audit. Blocked by nothing external. Needs decisions 1–3 above.

**Stage 2 — Access.** The template module. Identity for both actor types, auth, email and phone verification with the pending-change flow, OTP, roles, permissions, store access on assignments, staff invitations, sessions and lockout, account status, anonymized deletion, addresses with per-store formats. Needs decisions 4–6.

**Stage 3 — B2B.** Small, and Access cannot close its ordering-eligibility contract until B2B's public API can answer "can this account order." The four-status model is settled; the document list is now known enough to build a configurable document-type table.

**Stage 4 — Reviews and Bundles.** Both alter the Catalog schema, so they land before Catalog.

**Stage 5 — Catalog.** The gate. Cannot be finalised without the external schema and a real product sample.

**Then** Pricing, Inventory and Sync together, Sales, Promotions and Loyalty, Payments and Shipping when vendor data arrives, Content and Support, migration and hardening.

Stages 1 to 4 are roughly three to four weeks of work that depends on nothing external, which is the reason to run them while the schema is being chased.

**Per module, the deliverable is the same every time:** aggregates and invariants, the public contract interface, every use case with its permission string, complete state machines, tables with columns and indexes, published and consumed events, the error type hierarchy, the test scenario list, and a register of the open questions that module raised.
