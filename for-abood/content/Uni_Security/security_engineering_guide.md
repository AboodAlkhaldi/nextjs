# Security Engineering — Study Guide
### Chapters 1, 2 & 4 | Ross Anderson | Clear & Simplified

---

## Table of Contents
- [Chapter 1 — What Is Security Engineering?](#chapter-1--what-is-security-engineering)
- [Chapter 2 — Who Is the Opponent?](#chapter-2--who-is-the-opponent)
- [Chapter 4 — Protocols](#chapter-4--protocols)

---

# Chapter 1 — What Is Security Engineering?
> *Building systems that survive malice, error, and mischance*

---

## What is security engineering?

Security engineering is about building systems that keep working correctly even when someone is actively trying to break them, or when mistakes are made, or when bad luck strikes. Most engineering disciplines deal with error and accident — security engineering adds a third challenge: **people who intentionally want to cause harm**.

Think of it this way: a bridge engineer worries about storms, heavy loads, and design flaws. A security engineer worries about all of that *plus* someone who deliberately wants to collapse the bridge.

> **Why is it so broad?**
> Security engineering requires knowledge from many fields — not just computer science. You also need cryptography, psychology (how people behave), economics (what is worth protecting), law, and organisational culture. All of these interact in real systems.

---

## The 4-Part Framework — How to think about any secure system

Every secure system depends on four things working together. If any one of them is broken, the system fails — even if the other three are perfect.

| Component | What it means and why it matters |
|-----------|----------------------------------|
| **Policy** | What you are trying to protect, and from whom. Example: *"Only Alice can read this file."* If the policy is wrong (e.g. allows knives through airport security), even a perfect mechanism fails. |
| **Mechanism** | The technical tools that enforce the policy — encryption, passwords, locks, alarms. These are what most people think of as "security." |
| **Assurance** | How confident you can be that the mechanisms actually work as intended. A mechanism can exist and still be weak, misconfigured, or bypassed. |
| **Incentives** | Why do the people running the system actually protect it? Why do attackers want to break it? Misaligned incentives create *security theatre* — things that look secure but aren't. |

> **The framework in action — Airport security after 9/11**
>
> - **Policy failure:** knives up to 3 inches were permitted — the hijackers exploited this.
> - **Mechanism failure:** less than half of real weapons are detected in tests.
> - **Assurance failure:** billions spent on passenger screening; aircraft parked overnight are almost unguarded.
> - **Incentive failure:** politicians and companies benefit more from *visible* measures than *effective* ones — this is "security theatre."

---

## Four real-world examples

The chapter walks through four areas to show how different every system's security needs are.

### Bank

- **Core bookkeeping** — main threat is dishonest employees (1% of branch staff are fired yearly for petty theft). Defence: double-entry bookkeeping (every debit must match a credit — money cannot be created from nothing), two-person authorisation for large transfers, mandatory holidays so no one can cover their tracks indefinitely.
- **ATMs** — first large-scale use of cryptography in civilian life. The challenge: authenticate a customer with no bank clerk present. Failures led to "phantom withdrawal" scandals worldwide.
- **Online banking** — phishing (fake websites) evolved into real-time man-in-the-middle attacks and SIM-swap fraud. Each bank defence spawned a new criminal technique.
- **High-value messaging (bank-to-bank transfers)** — prime target for nation-state hackers. North Korea has stolen hundreds of millions this way.
- **Bank branches** — the stone facade is theatre. A gun gets the cash immediately. Real protection is alarm systems with encrypted communications to prevent an attacker spoofing an "all clear" signal.

### Military base

- **Cryptography for communications** goes back to ancient Egypt. But encrypting messages is not enough — an enemy can locate the transmitter by the signal alone, without breaking the code.
- **Electronic warfare** — jamming, spoofing, and counter-measures developed here decades before the internet. Denial-of-service attacks are not new; they were a military reality long before websites were targeted.
- **Classified information** — "Top Secret" compartments limit who can know what. Managing information flow drove the development of access control technology now used in phones and laptops.
- **Nuclear weapons security** — led to biometrics (iris scanning), optical-fibre alarm sensors, and provably-secure authentication systems.

### Hospital

- **Infusion pumps** — safety usability failures kill tens of thousands per year in the USA. A hospital with six different pump models from six vendors creates fatal error opportunities. Hackability makes this worse because regulators are more likely to order recalls when hostile action is possible.
- **Patient record access** — nurses should only see records of patients in their department. Implementing the rule *"nurses can see records of anyone cared for in their department in the last 90 days"* is harder than it sounds.
- **Anonymisation** — removing names is not enough. Searching *"male, born 1953, treated for atrial fibrillation on 19 October 2003"* is enough to identify Tony Blair. Re-identification from combinations of data is a growing problem.
- **WannaCry (2017)** — hospitals that shut down their networks to stop malware spreading found they couldn't operate because X-rays now travel via network, not physical envelopes. There were backup generators — but no backup networks.

### Home

- **Car immobilisers** — encrypted challenge-response prevents hotwiring, but keyless entry introduced relay attacks (covered in depth in Chapter 4).
- **Mobile phones** — authenticate to networks via crypto, but police can use a fake base station (Stingray/IMSI-catcher) to intercept calls. SIM-swap fraud lets criminals take over your number.
- **Prepayment electricity meters** — work even off-grid (Kenya: pay via mobile, unlock solar power with a code). One of the most successful real-world uses of cryptography in the developing world.
- **Smart home devices** (Alexa, Google Home) — always-on microphones, speech processed in the cloud. By 2015, US presidential advisers predicted every inhabited space on Earth would have microphones connected to a small number of cloud providers.

---

## Key definitions — words that are often confused

| Term | What it actually means |
|------|------------------------|
| **Secrecy** | An engineering property — the result of using mechanisms (crypto, access controls) to limit who can access information. |
| **Confidentiality** | An obligation — the duty to protect someone else's secrets. A doctor has a duty of confidentiality to patients. |
| **Privacy** | A right — your ability to control your own personal information and personal space. Applies to people, not corporations. |
| **Trusted** | A component whose *failure* would break the security policy. Not the same as trustworthy. |
| **Trustworthy** | A component that actually won't fail. An NSA spy is *trusted* (their failure matters) but *not trustworthy* (they betrayed that trust). |
| **Hack** | Something a system's rules permit but that was unintended and unwanted by its designers. Tax loopholes are hacks on the tax code; exploits are hacks on software. |
| **Vulnerability** | A property of a system that, combined with a threat, causes a security failure (breach of policy). |
| **Security policy** | A concise statement of what the system must protect. Example: *"Credits and debits must always balance, and transfers over $1m need two approvals."* |

> **Remember the trusted/trustworthy distinction.**
> Most security systems give enormous power to a small number of trusted components (a key server, a certificate authority, an admin account). If that component is trusted but not trustworthy, the whole system can fail silently.

---

## The big themes of Chapter 1

- **History matters** — civil engineers learn more from one bridge that collapses than from a hundred that stand. Security engineers must study past attacks to understand what can go wrong.
- **Human factors cause most failures** — usability problems (people writing down passwords, using the wrong machine, ignoring warnings) are a bigger source of failures than cryptographic weaknesses.
- **Complexity is the enemy** — every system that evolved from another carries the mistakes and assumptions of its predecessors. Understanding history is how you navigate inherited complexity.
- **"Security" means different things to different people** — to a corporation it might mean monitoring employees; to those employees it might mean freedom from monitoring. The security engineer must pin down precisely what the policy actually says.

---

# Chapter 2 — Who Is the Opponent?
> *A complete map of threat actors — their motives, tools, and scale*

---

## Why does this matter?

You cannot defend a system against "all possible attacks" — that would make it too expensive and too slow to be useful. Instead, you identify the specific attackers most likely to target your system, understand their capabilities and motives, and design defences calibrated to that real threat. This is called your **threat model**.

A hospital doesn't need to defend against the same threats as a military communications network. Getting this wrong in either direction — over-engineering or under-engineering — is costly.

> **The scale of the problem**
> Cybercrime now accounts for approximately **half of all crime** by volume and value in developed countries. Yet law enforcement typically spends less than **1% of its budget** fighting it. The result: as crime moved online, it effectively disappeared from official statistics for years.

---

## Category 1 — Spies (Nation-State Actors)

Governments have the largest budgets, the most sophisticated tools, and the most patience of any attackers. They also have legal authority to compel cooperation from companies in their jurisdiction. Even if nation-states are not in your threat model today, **their tools routinely end up in criminal hands within a few years**.

### The Five Eyes (USA, UK, Canada, Australia, New Zealand)
*Revealed by Edward Snowden in 2013*

| Program | What it did |
|---------|-------------|
| **PRISM** | Collected email and social media data (Gmail, Facebook, etc.) for non-US persons. Any NSA analyst could access a foreigner's account by clicking a single tab. |
| **Tempora** | UK tapped 200+ transatlantic fibre-optic cables — up to 21 petabytes of data per day. Britain's Victorian-era telegraph cable routes gave it physical access to a quarter of the global internet backbone. |
| **Muscular** | Collected data flowing between Google and Yahoo's own data centres — data transmitted unencrypted internally, even though user-facing connections were encrypted. The leaked "smiley face" PowerPoint slide shocked Silicon Valley. |
| **Bullrun / Edgehill** | $100m/year program to weaken global cryptography: backdoored random number generators (Dual_EC_DRBG), weakened export standards, supply-chain implants in routers. Created vulnerabilities in hotel locks, car immobilisers, and VPNs. |
| **XKeyScore** | A search engine for all collected surveillance data. An analyst could query: *"Show me all exploitable machines in country X"* or build a full profile of any person's global online activity. |
| **Quantum / CNE** | Active hacking — injected network packets to redirect targets' browsers to attack servers. Used to hack Belgium's main phone company (Belgacom) and gain access to EU institutions. |
| **Stuxnet** | A worm jointly developed by the USA and Israel to physically destroy Iran's uranium centrifuges by manipulating their Siemens industrial controllers. Used four zero-day exploits and two stolen certificates. The first cyberweapon to cause physical destruction. |

> **Why nation-states think differently about scale**
>
> Tapping one phone requires following someone with equipment in a car, risking detection, and often losing the signal. Tapping an entire fibre cable costs a large upfront investment but then captures *everyone's* traffic at near-zero marginal cost per person. The Five Eyes strategy is to collect everything globally — the infrastructure cost is amortised over billions of targets.

### China

- **Goal:** total domestic control + aggressive overseas intelligence gathering.
- Views western tech firms and surveillance tools as extensions of US geopolitical power — and therefore legitimate targets alongside military contractors.
- **OPM hack (2015):** stole deeply personal data on 22 million US federal employees — including security clearance interview contents (drug use, sexual partners, foreign contacts). The most valuable intelligence database ever stolen.
- **Tactics evolved** from crude spear-phishing (Tibetan government hack, 2008) to sophisticated zero-day attacks on iPhones targeting the Uighur diaspora (2020).
- **Huawei:** GCHQ found 70 copies of 4 different OpenSSL versions (including known-vulnerable ones) and 304 partial copies of 14 versions in their equipment. Conclusion: so poorly maintained that *anyone* could hack it, not just China.

### Russia

Russia acts as a **spoiler** — trying to disrupt the international order, not just gather intelligence.

- **Estonia DDoS (2007):** attacked government, banks, and media after Estonia moved a Soviet-era statue. First major state-level cyberattack.
- **Ukraine power grid (2015):** took down 30 electricity substations across three separate distribution systems within 30 minutes — 230,000 people without power. First cyberattack to cut mains electricity.
- **NotPetya (2017):** the most damaging cyberattack in history. Disguised as ransomware, spread via a Ukrainian accounting software update, then used stolen NSA tools to propagate globally. Cost: Maersk $300m, FedEx $300m, Mondelez $100m. Insurers refused to pay, calling it an "act of war."
- **2016 election interference:** GRU hacked Democratic campaign emails; the Internet Research Agency ran a massive disinformation campaign. Putin's approach described as "judo" — using an opponent's strength (open social media, free press) to trip them up.

### Others

| Actor | Key incidents and methods |
|-------|--------------------------|
| **UAE** | Hired ex-NSA analysts as mercenaries in Dubai. Karma tool hacked iPhones of foreign leaders and dissidents with no user interaction required. |
| **Saudi Arabia** | Hacked Jeff Bezos's iPhone via a WhatsApp message sent directly from the Crown Prince's phone. Murdered journalist Jamal Khashoggi. Used Twitter employees as spies against critics. |
| **Syria** | Combined malware with physical coercion — police threatened family members with violence unless suspects revealed passwords, then spear-phished all contacts during the arrest. |
| **Iran** | Hacked Diginotar CA to monitor dissidents' Gmail. Shamoon malware hit Saudi Aramco. Traced the CIA's covert communications network, leading to the execution of ~30 agents. |
| **North Korea** | Sony hack (2014). WannaCry worm (2017, 200,000+ computers). $1 billion+ stolen from cryptocurrency exchanges and banks — including $81m from the Bank of Bangladesh in a single operation. |

---

## Category 2 — Crooks (Cybercriminals)

The criminal underground industrialised in **2003–2005** with the emergence of underground markets. Instead of one person doing everything (stealing cards, forging them, using them), specialists emerged — just like manufacturing in the Industrial Revolution.

| Actor type | What they do |
|------------|--------------|
| **Botnet herders** | Run networks of thousands to millions of compromised machines, rented to spammers, DDoS attackers, and fraudsters. Mirai (2016) targeted IoT devices with default passwords and took down Twitter for 6 hours. |
| **Malware developers** | Write exploits, remote-access trojans, and banking trojans (Zeus, Dridex) that wait for you to log into your bank, make transfers to mule accounts, and hide the activity from your screen. |
| **Spam / phishing senders** | Getting past modern spam filters requires specialist tools that change constantly. Business email compromise: impersonate the CEO to order a wire transfer, or tell a customer the company's bank account has changed. |
| **Cashout gangs** | Buy stolen credentials on underground markets, convert them to real money via mule networks or cryptocurrency. A card number + expiry date sells for under $1. With CVV, name, and address: a few dollars. The real value is in the cashout. |
| **Ransomware operators** | Since 2017: ransomware-as-a-service. Professional gangs wait weeks until backups are also encrypted, then demand bitcoin. UCSF paid $1m+. Operators now also threaten to publish stolen data. |
| **Hack-for-hire** | Will attempt to compromise a specific target account for ~$750. Modern equivalent of private investigators — used in corporate disputes, divorce cases, and political campaigns. |

> **The economics of cybercrime**
> The total cost of cybercrime to society is typically **two orders of magnitude** larger than what criminals actually steal. A card fraud netting $10,000 might cost banks $1,000,000 in notification, reissuance, investigation, and reputation damage. This leverage ratio makes cybercrime extremely attractive even at low success rates.

**Corporate crime — companies attack each other too:**
- **Volkswagen emissions scandal:** diesel engines programmed to detect test conditions and run cleanly only then. CEO fired and indicted; €25 billion+ set aside for fines and compensation.
- **Printer and console vendors** use cryptography to force customers to buy proprietary accessories. Courts ruled competitors can legally crack this crypto — creating a formal arms race between cryptographers (hired by incumbents) and cryptanalysts (hired by competitors).

---

## Category 3 — Researchers (Geeks)

Academics, security company researchers, and skilled hobbyists who find and report vulnerabilities. Motivated by curiosity, professional reputation, and money — not malice.

- **Responsible disclosure:** report the bug privately to the vendor, give them months to fix it, then publish regardless. Before this norm, researchers posted bugs immediately (giving criminals instant access) or faced legal threats.
- **Bug bounty programs** now pay $1 million+ for critical vulnerabilities. This created a legal market that competes with the criminal market for the same talent.
- **The dark side:** governments buy zero-days and stockpile them as weapons. Once used, exploits spread — EternalBlue was an NSA tool, leaked in 2017, then used by North Korea in WannaCry and by Russia in NotPetya within weeks.
- **Volkswagen** sued Birmingham and Nijmegen university researchers for reverse-engineering their car key system. VW lost — and the lawsuit publicised the exact insecurity they were trying to hide.

---

## Category 4 — The Swamp (Abuse)

Offences against people rather than property. The "weapon" is usually the **angry mob**, which can now be assembled and directed at scale using social media.

- **Hacktivism and hate campaigns:** ranges from law-abiding NGOs writing to legislators → bots gaming media analytics → doxxing → coordinated harassment. Gamergate (2014) showed how a leaderless online mob can coordinate real-world harm.
- **State-directed information warfare:** Russia's Internet Research Agency ran coordinated campaigns in both the Brexit referendum and 2016 US election. The goal was not to elect anyone specific — it was to deepen social divisions and undermine trust in institutions.
- **Intimate partner abuse:** the hardest security problem. The attacker knows your passwords, your recovery answers, your habits, your social network. Standard security advice is backwards. Takes an average of **7 escape attempts** to achieve lasting separation. Stalkerware apps are explicitly marketed to abusive men.
- **Child safety:** sexting became normal among teenagers years after laws were written that make possession of such images criminal — creating situations where teenagers are criminalised for consensual behaviour with peers.

> **Design principle — Abusability**
> Think about *abusability* as well as usability. When you design a system, ask not just "how will legitimate users use this?" but "how could a determined abuser exploit this against a victim?"
> Households are not units. Devices are not personal. The person who bought a device is not always the only user.

---

## Summary — What every security engineer should take away

| Lesson | Why it matters |
|--------|----------------|
| **Motive is your primary filter** | Why someone attacks determines how they'll attack and how much effort they'll invest. Start there. |
| **Nation-state tools become criminal tools** | EternalBlue, Vault 7 CIA tools — all ended up in criminal and other state hands. What top-tier attackers use today, mid-tier attackers will use in 2–5 years. |
| **Scale changes everything** | Every category of attacker in this chapter is solving the same problem: how do I turn a skilled individual attack into something that runs at industrial volume? |
| **Spear-phishing is universal** | Both intelligence agencies and criminal gangs primarily gain access through targeted phishing emails. Flashy zero-days are the exception; deception is the rule. |
| **Attribution is possible, not easy** | Anonymity online is much harder than people think. Sophisticated attackers make operational security mistakes. But attribution is politically inconvenient. |
| **Insiders and outsiders blend** | The boundary between insider threat and outsider attack is increasingly blurred. Plan for both. |

---

# Chapter 4 — Protocols
> *The rules that link cryptography to real systems — and where they break*

---

## What is a security protocol?

A security protocol is a precise set of steps that two or more parties follow to establish trust — to prove identity, exchange keys, or authorise an action. Protocols are **where cryptography meets reality**. A cryptographic algorithm (e.g. AES) might be mathematically perfect, but the protocol wrapping it can still be completely broken.

Think of it like a handshake ritual between strangers. Even if both people are honest and strong, if the ritual has a flaw (e.g. it can be mimicked from a distance), the handshake means nothing.

> **Two questions to ask about any protocol:**
> 1. Is the threat model realistic? (Does it account for the actual attackers it will face?)
> 2. Does the protocol deal with that threat? (Does it actually prevent the attack, or just appear to?)
>
> Many protocols fail the first question — they were designed for a world that no longer exists.

---

## Essential vocabulary

| Term | What it means |
|------|---------------|
| **Nonce (N)** | A *"Number used Once"* — proves a message is fresh, not a replay. Can be a random number, a counter, or a timestamp. Each has different trade-offs. |
| **Challenge-response** | Verifier sends a random challenge N. Prover returns `{N}K` — the challenge encrypted with a shared key K. Proves possession of K without revealing K. Used in car immobilisers, military IFF, 2FA devices. |
| **Protocol notation** | `A → B : {M}K` means "A sends B the message M encrypted under key K." Everything in braces is encrypted. Names inside bindings prevent messages being reused in another context. |
| **Session key (KAB)** | A temporary key used just for one conversation. Even if captured later, only that session is exposed. Long-term keys should only be used to deliver session keys, never to encrypt actual messages. |
| **Key diversification** | Each device gets its own key derived from a master: `KT = {T}KM`. Compromising one device gives you one key, not the master. Breaking the whole system requires compromising the central server. |
| **Trusted third party (TTP)** | A server that both parties already trust, used to introduce them and distribute session keys. Kerberos is an example. Trade-off: the TTP can read everything. |
| **TOFU** | Trust-On-First-Use — a device trusts the first key it ever receives (like a baby duckling imprinting on the first thing it sees). Simple and cheap. Whoever reaches the device first wins. |

---

## The four main protocol attack types

All four attacks share a root cause: **a message is being accepted in a context it was not designed for.** The defence for all four is the same: make every important thing explicit in the message itself — names, roles, timestamps, application identifiers.

### 1. Replay attack

Capture a valid message and retransmit it later.

**Example:** A "grabber" device records the signal your car key sends to unlock the door, then replays it after you've gone.

**Defence:** Nonces — every message must include a fresh value never used before. The receiver checks it has not seen this nonce already.

**Subtle failure:** The South African prepayment meter that only checked *"is this different from last time?"* could be recharged indefinitely by alternating two valid codes: `A B A B A B...`

---

### 2. Man-in-the-Middle (MITM)

Attacker sits between two parties, relaying messages in both directions while intercepting the content.

**Military example — MIG-in-the-middle:** Cuban MIGs flew through South African air defences by relaying IFF challenges from the defence radar through Angolan ground batteries and back to a South African bomber. The bomber's genuine response was relayed back, making the MIGs appear friendly.

**Modern example:** A phishing site presents your bank's genuine 2FA challenge to you in real time, captures your response, and submits it to the bank immediately — within the code's validity window. No cryptography is broken; you are used as a live cryptographic oracle.

---

### 3. Reflection attack

A special MITM where the attacker reflects your own challenge *back at you* (or at your own wingman).

**Example:** A fighter challenges a bomber → bomber reflects the challenge at the fighter's wingman → wingman (unknowingly) produces the correct response → bomber returns it as its own.

**Fix:** Include both parties' names in what gets signed:
```
B → F : {B, N}K
```
A reflected response `{F', N}K` from a different aircraft is now detectable.

---

### 4. Chosen protocol attack

Design a fake protocol that tricks the victim into unknowingly signing something for a different, real protocol.

**The Mafia-in-the-middle:** A porn site asks users to "prove their age" by signing a random challenge — which is actually a gold-coin purchase transaction the Mafia has submitted in parallel. The user signs thinking it's just age verification; the Mafia gets the gold.

**Root cause:** Reusing the same cryptographic key across multiple applications.

**Fix:** Strict separation between applications — banking apps and other apps must have strictly separate keys.

---

## Case study — Car key security (1990–2020): a full arms race

Every "fix" introduced new problems. This story runs through every concept in the chapter.

| Stage | What happened and why it failed |
|-------|---------------------------------|
| **1. Static serial number (pre-1995)** | Car remote broadcasts its serial number to unlock. Attack: "grabber" records the signal in a car park, replays it later. Trivially broken. |
| **2. 16-bit password** | Only 65,536 possible codes. Brute-force device tries all of them in under an hour. In a car park of 100 vehicles, expect success in under a minute. |
| **3. 32-bit password** | Marketed as "over 4 billion codes!" Still only 1–2 valid codes per car — grabbers still work. No real improvement. |
| **4. Cryptographic immobiliser** | Challenge-response protocol. Proper improvement — theft falls. But: politicians mandated weak 40-bit keys (export control); vendors used proprietary weak ciphers; VW used a single master key for millions of cars at once. All broken by 2016. |
| **5. Passive Keyless Entry (PKES)** | Marketing wanted "no button press." New attack: relay attack. Thief stands near your front door with one antenna, accomplice stands near your car with another. Key thinks it's next to the car. UK thefts rose **56% in 2017**. |
| **6. Fix: UWB radio (2019+)** | Ultrawideband ranging measures physical distance to the key with 10cm precision. Relay attacks fail because the key is actually far away. Now shipping in new cars. |

> **The political dimension**
> The biggest weaknesses in car immobilisers were not technical errors — they were imposed by export control laws mandating short key lengths, and by marketing departments wanting "passive keyless entry" without understanding relay attacks. Cryptographic design cannot fix policy failures.

---

## Two-factor authentication (2FA) — and how it fails

2FA adds a second verification step beyond a password. A hardware token generates a code by encrypting a random challenge (nonce) from the server with a secret key, combined with a PIN.

**The formal protocol:**
```
Server → User : N              (random nonce)
User → Device : N, PIN
Device → User : {N, PIN}K     (encrypted response)
User → Server : {N, PIN}K
```
The server verifies the response matches what it would get by encrypting N and PIN with the shared key K. The US DoD found this cut network intrusions by **46%**.

**Where 2FA fails:**

- **Real-time MITM:** A phishing site presents the bank's genuine challenge to you, captures your one-time response, and submits it to the bank immediately — within the validity window. No crypto is broken; the attack exploits the human relay.
- **SIM-swap:** Attacker calls the phone company, claims your phone is lost, gets your number transferred to their SIM. All SMS verification codes now go to the attacker. This is why SMS-based 2FA is significantly weaker than a hardware token.
- **Knifepoint:** Someone who takes your card at knifepoint can now verify you gave them the correct PIN by watching the transaction succeed. This literally happens.

**Banks' layered response:** No single defence stops MITM, so banks combine known device fingerprinting + password + 2FA + transaction risk scoring + authenticating the payee account number. They only check the **last four digits** of the account — because full verification is slow enough that customers give up and call the helpline, which itself becomes a new MITM target.

---

## Key distribution — how do two strangers agree on a key?

If Alice and Bob have never met, how do they get a shared key without an attacker intercepting it? They use a **trusted third party (Sam)** who both already trust.

**Basic pattern:**
```
A → S : A, B
S → A : {A, B, KAB, T}KAS , {A, B, KAB, T}KBS
A → B : {A, B, KAB, T}KBS , {Message}KAB
```
Sam makes a session key KAB, encrypts one copy for Alice and one for Bob. Alice forwards Bob's copy. Both learn KAB. The timestamp T prevents replay of old session keys.

### Needham-Schroeder (1978) — a famous flaw

Uses nonces instead of timestamps (avoids clock synchronisation problems). But Bob has **no way to verify that the session key KAB is fresh**. Alice could wait a year between step 2 and step 3, replaying an old key.

If an old key was compromised — say Alice was fired and her credentials stolen — an attacker can impersonate her to Bob indefinitely. The flaw was not found for **17 years** after publication.

**Root cause:** Written in 1978, assuming all principals behave honestly. By the 1990s, the threat model had shifted — insiders were now part of the threat — and the protocol was no longer sound under the new assumptions.

### Kerberos — the practical fix

- Adds **timestamps and lifetimes** to session keys — old keys simply expire.
- Splits into two server types: **authentication servers** (log in once with your password) and **ticket-granting servers** (get time-limited tickets for specific resources).
- Used in Windows and Linux domain authentication today.
- **Trade-off:** Clocks must stay synchronised — deliberate desync can be an attack. The key distribution centre (Sam) is fully trusted — police with a warrant get all keys.

### OAuth / OpenID Connect

Modern delegation protocol. "Log in with Google" → Google asks your consent → the app gets a short-lived access token. **OpenID Connect** is the authentication-specific profile of OAuth used when you log into a website using your Google or Facebook account. Risk: OAuth wasn't designed for authentication; access tokens aren't strongly bound to clients, creating cross-site phishing attack surfaces.

---

## Design assurance — can we prove a protocol is correct?

Formal methods like **BAN logic** (Burrows-Abadi-Needham) reason about what a principal can *reasonably believe* after receiving certain messages. They force designers to state every assumption explicitly — which is exactly where most bugs hide.

**The limits of formal verification:**
- Larry Paulson formally proved SSL/TLS correct in 1998. Roughly **one security bug per year** has been found in SSL/TLS since then. None were in the verified part — all were in features added later, or in implementation details like timing attacks.
- Formal proof tells you where the attacker does not need to bother looking. It does not make the entire system safe.

**Robustness principles (a practical alternative):**
- A message's meaning must depend only on its content, not its context.
- Every important thing — names, roles, application identifier, timestamp — must be stated explicitly inside the message.
- Data formats must be unambiguous: a name field cannot be misread as a timestamp.
- The protocol itself must not be usable to attack the software that handles it (no buffer overflows via crafted protocol messages).

---

## Key lessons from Chapter 4

| Lesson | Why it matters |
|--------|----------------|
| **Never reuse keys across protocols** | The chosen protocol attack shows that two individually secure protocols can be broken by cross-protocol key reuse. Banking apps and other apps must have strictly separate keys. |
| **Include both parties' names in what is signed** | Prevents reflection attacks. If the response proves "B responded to A's challenge N," it cannot be reflected back by a third party. |
| **Nonces prevent replay — but each type has costs** | Random nonces need the receiver to remember all past nonces. Counters need synchronisation. Timestamps need clock sync. Choose based on your application's constraints. |
| **Environment change = protocol failure** | The card fraud epidemic in filling stations happened because the protocol was designed for trusted bank terminals, then deployed in untrusted retail terminals without rethinking the threat model. |
| **Real-time MITM defeats 2FA** | If the attacker can relay messages fast enough, any challenge-response 2FA can be defeated without breaking any cryptography. |
| **Don't design your own protocols** | Even expert cryptographers get the first version wrong — often multiple times. Always get a specialist and publish for peer review before deployment. |

> **The most important lesson in Chapter 4**
>
> *"The most pernicious failures are caused by creeping changes in the environment for which a protocol was designed, so that the protection it gives is no longer relevant."*
>
> Every protocol is a contract built on assumptions. When the world changes — new devices, new deployment contexts, new adversaries — those assumptions may silently become false. Reviewing your protocol's threat model is not a one-time task.

---

*Security Engineering — Study Guide | Chapters 1, 2 & 4 | Ross Anderson*
