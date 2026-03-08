# Comprehensive Azure Services Guide

=============================================================================
## COMPREHENSIVE AZURE SERVICES GUIDE

---

This file is a reference guide for Azure services.
All content is commented for use as a shell script reference.

---

=============================================================================
## TABLE OF CONTENTS

---

1.  Compute Services
2.  Storage Services
3.  Networking Services
4.  Databases
5.  AI & Machine Learning
6.  Analytics & Big Data
7.  DevOps & Developer Tools
8.  Security & Identity
9.  Integration Services
10. IoT Services
11. Management & Governance
12. Migration Services
13. Media Services
14. Mixed Reality
15. Blockchain

---

=============================================================================
## SECTION 1: COMPUTE SERVICES

---

### 1.1 Azure Virtual Machines (VMs)
**WHAT IT IS:**
  Infrastructure-as-a-Service (IaaS) offering that provides on-demand,
  scalable computing resources. You get full control over the OS, software,
  and configuration. Supports Windows and Linux distributions.

WHAT IT IS GOOD FOR (USE CASES):
- Lift-and-shift migrations from on-premises to cloud
- Running legacy applications that require specific OS versions
- Development and test environments
- Running custom software that cannot be containerized easily
- High-performance computing workloads
- Disaster recovery environments
- Hosting databases that need custom configurations
- Running applications requiring GPU acceleration (e.g., gaming, rendering)
- SAP, Oracle, and other enterprise workloads
- Batch processing and compute-intensive jobs

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Simple web hosting (use App Service instead)
- Microservices architectures (use AKS or Container Apps)
- Event-driven workloads (use Functions)
- When you want minimal operational overhead
- Serverless scenarios
- Short-lived tasks (expensive idle time)
- When auto-scaling is a primary requirement without complexity

**VM SIZES AND FAMILIES:**
- B-series: Burstable, cost-effective for dev/test
- D-series: General purpose, balanced CPU and memory
- E-series: Memory-optimized for in-memory workloads
- F-series: Compute-optimized for CPU-intensive tasks
- G-series: Memory and storage optimized
- H-series: High-performance computing (HPC)
- L-series: Storage-optimized for high disk throughput
- M-series: Largest memory for SAP HANA
- N-series: GPU-enabled for ML/AI and graphics

**PRICING MODELS:**
- Pay-as-you-go: Most flexible, highest per-hour cost
- Reserved Instances (1 or 3 year): Up to 72% savings
- Spot VMs: Up to 90% savings, but can be evicted
- Azure Hybrid Benefit: Use existing Windows Server licenses

**IMPORTANT CONCEPTS:**
- Availability Sets: Protect against hardware failure within a datacenter
- Availability Zones: Protect against datacenter failure
- VM Scale Sets (VMSS): Auto-scale groups of identical VMs
- Managed Disks: Azure manages disk storage for you
- Proximity Placement Groups: Low-latency grouping of VMs

**BEST PRACTICES:**
- Always use Managed Disks
- Enable Azure Backup for production VMs
- Use Availability Zones for high availability
- Apply NSGs to restrict network access
- Enable Azure Monitor and Log Analytics
- Use Reserved Instances for predictable workloads
- Enable auto-shutdown for dev/test VMs to save costs
### 1.2 Azure App Service
**WHAT IT IS:**
  A fully managed Platform-as-a-Service (PaaS) for hosting web applications,
  REST APIs, and mobile backends. Supports .NET, .NET Core, Java, Ruby,
  Node.js, PHP, and Python. Handles infrastructure, patching, and scaling.

WHAT IT IS GOOD FOR (USE CASES):
- Web applications and websites
- RESTful APIs and microservices
- Mobile backends
- Rapid application deployment
- Applications requiring custom domains and SSL
- Continuous deployment via GitHub Actions, Azure DevOps
- Applications requiring authentication (Easy Auth)
- WebJobs for background processing
- WordPress and CMS platforms

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Applications needing OS-level customization
- Long-running background processes (use Functions or VMs)
- GPU-intensive workloads
- Applications requiring full container orchestration
- Very high traffic requiring ultra-low latency (consider VMs with CDN)
- Legacy desktop applications

APP SERVICE PLANS (TIERS):
- Free (F1): 60 CPU minutes/day, shared infrastructure, no SLA
- Shared (D1): Shared infrastructure, custom domain support
- Basic (B1-B3): Dedicated VMs, manual scaling, no autoscale
- Standard (S1-S3): Autoscale, staging slots, 5 slots max
- Premium (P1v3-P3v3): Enhanced performance, more slots
- Isolated (I1v2-I3v2): Network-isolated, dedicated environment (ASE)

**KEY FEATURES:**
- Deployment slots (staging, production) for blue-green deployments
- Auto-scaling based on metrics or schedule
- Custom domains and free managed SSL certificates
- Integration with Azure AD for authentication
- VNet integration for private network access
- Built-in CI/CD with GitHub, Bitbucket, Azure DevOps
- Application Insights integration
- WebSockets support

**BEST PRACTICES:**
- Use deployment slots for zero-downtime deployments
- Enable Application Insights for monitoring
- Use environment variables for configuration
- Implement health check endpoints
- Use VNet Integration for secure backend access
- Enable auto-scaling rules based on CPU/memory
- Always use Standard tier or above for production
### 1.3 Azure Kubernetes Service (AKS)
**WHAT IT IS:**
  A managed Kubernetes container orchestration service. Azure handles the
  control plane (API server, etcd, scheduler) for free. You only pay for
  agent nodes (VMs). Supports full Kubernetes ecosystem.

WHAT IT IS GOOD FOR (USE CASES):
- Microservices architectures
- Containerized application deployments
- Multi-container applications with complex dependencies
- Applications requiring fine-grained scaling control
- CI/CD pipelines for container deployments
- Mixed workloads (Linux and Windows containers)
- Stateful and stateless applications
- Service mesh implementations (Istio, Linkerd)
- ML model serving at scale
- Applications requiring GPU workloads in containers

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Simple single-container applications (use Container Apps or App Service)
- Teams without Kubernetes expertise
- Small workloads that don't need orchestration overhead
- Serverless event-driven scenarios (use Functions)
- When you need extremely fast spin-up times

**KEY COMPONENTS:**
- Node Pools: Groups of VMs with same configuration
- System Node Pool: Runs AKS system pods (required)
- User Node Pool: Runs application workloads
- Virtual Nodes: Serverless burst using Azure Container Instances
- Cluster Autoscaler: Automatically adjusts node count
- Horizontal Pod Autoscaler (HPA): Scales pods based on metrics
- Azure CNI: Advanced networking with VNet integration
- Kubenet: Basic networking, simpler setup

**INTEGRATIONS:**
- Azure Container Registry (ACR) for image storage
- Azure Monitor and Container Insights for observability
- Azure Policy for governance
- Azure Key Vault for secrets management
- Azure Active Directory for RBAC
- Azure Load Balancer and Application Gateway ingress
- Azure Disk and Azure Files for persistent storage
- KEDA for event-driven autoscaling

**BEST PRACTICES:**
- Use separate node pools for different workloads
- Enable cluster autoscaler for cost optimization
- Implement Pod Disruption Budgets for HA
- Use namespaces for workload isolation
- Integrate with Azure AD for RBAC
- Enable Azure Policy Add-on
- Regularly upgrade Kubernetes version
- Use Spot node pools for non-critical workloads
### 1.4 Azure Functions
**WHAT IT IS:**
  A serverless compute service that lets you run event-triggered code without
  managing infrastructure. You pay only for execution time and resources.
  Supports C#, JavaScript, Python, Java, PowerShell, TypeScript.

WHAT IT IS GOOD FOR (USE CASES):
- Event-driven processing (HTTP triggers, queue messages, timers)
- API backends for mobile and web apps
- Processing IoT data streams
- File processing (blob triggers)
- Scheduled jobs and cron tasks
- Integration workflows and orchestration (Durable Functions)
- Webhooks and event handlers
- Lightweight microservices
- Real-time data transformation
- Chatbots and conversational AI backends

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Long-running processes (>10 min on Consumption plan)
- Stateful workflows without Durable Functions
- CPU-intensive or memory-heavy workloads
- Applications requiring predictable, consistent performance (cold starts)
- Large, monolithic applications
- When you need persistent connections

**HOSTING PLANS:**
- Consumption Plan: Auto-scale, pay per execution, cold starts
- Premium Plan: Pre-warmed instances, no cold starts, VNet integration
- Dedicated (App Service) Plan: Run on existing App Service infrastructure
- Azure Container Apps: Microservices-oriented hosting

**TRIGGER TYPES:**
- HTTP Trigger: REST API endpoints
- Timer Trigger: CRON-based scheduling
- Blob Trigger: React to Azure Storage events
- Queue Trigger: Process Azure Storage Queue messages
- Service Bus Trigger: Process Service Bus messages
- Event Hub Trigger: Process streaming events
- Cosmos DB Trigger: React to database changes
- Event Grid Trigger: React to Azure events
- SignalR: Real-time web functionality

**DURABLE FUNCTIONS:**
- Orchestrator Functions: Coordinate workflow execution
- Activity Functions: Perform work units
- Entity Functions: Manage stateful entities
- Patterns: Function chaining, fan-out/fan-in, async HTTP, monitoring

**BEST PRACTICES:**
- Design for idempotency (functions may run multiple times)
- Use Durable Functions for complex workflows
- Store secrets in Key Vault, reference via App Settings
- Enable Application Insights for monitoring
- Use Premium Plan for production to avoid cold starts
- Keep functions focused on single responsibilities
- Use managed identity to authenticate to other services
### 1.5 Azure Container Instances (ACI)
**WHAT IT IS:**
  The fastest and simplest way to run containers in Azure without managing
  any underlying VMs or orchestrators. Billed per second.

WHAT IT IS GOOD FOR (USE CASES):
- Simple container workloads and quick tasks
- Batch processing and data processing pipelines
- Development and testing of containerized apps
- Event-driven tasks that need containers
- Burst workloads for AKS (Virtual Nodes)
- CI/CD pipeline stages
- Run-once or run-occasionally containers

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Long-running, always-on applications
- Complex multi-container orchestration
- When you need Kubernetes-level control
- Applications requiring persistent storage (limited support)
- High-throughput, latency-sensitive workloads

**KEY FEATURES:**
- Container Groups: Multi-container pods (similar to Kubernetes pods)
- Public IP and custom DNS name
- Azure Virtual Network integration
- Persistent storage with Azure Files mount
- GPU support (preview)
- Confidential containers
### 1.6 Azure Container Apps
**WHAT IT IS:**
  A serverless container service built on Kubernetes and open-source
  technologies (KEDA, Dapr, Envoy). Abstracts Kubernetes complexity while
  providing powerful scaling and microservices capabilities.

WHAT IT IS GOOD FOR (USE CASES):
- Microservices architectures
- API backends
- Event-driven processing with KEDA
- Background processing jobs
- Applications using Dapr for service discovery
- When you want Kubernetes benefits without managing it

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- When you need full Kubernetes API access (use AKS)
- Monolithic applications
- Applications requiring extensive custom Kubernetes configurations
### 1.7 Azure Batch
**WHAT IT IS:**
  A managed service for running large-scale parallel and high-performance
  computing (HPC) batch jobs. Automatically schedules and manages compute
  nodes.

WHAT IT IS GOOD FOR (USE CASES):
- Large-scale parallel processing
- Financial risk modeling and simulations
- 3D rendering and media transcoding
- Scientific simulations and research
- Genomics and bioinformatics processing
- Machine learning training at scale
- EDA (Electronic Design Automation)

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Real-time or interactive workloads
- Simple, small-scale jobs
- Applications requiring stateful processing
### 1.8 Azure Service Fabric
**WHAT IT IS:**
  A distributed systems platform for packaging, deploying, and managing
  microservices and containers. Powers many Microsoft Azure services.
  Suitable for stateful and stateless microservices.

WHAT IT IS GOOD FOR (USE CASES):
- Stateful microservices that need reliable state management
- Applications requiring fine-grained lifecycle management
- IoT scenarios requiring distributed state
- Gaming backends requiring stateful services
- Financial services needing transactional consistency

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Simple stateless applications
- Teams without Service Fabric expertise
- When AKS would suffice
- Simple web applications

---

## SECTION 2: STORAGE SERVICES

---

### 2.1 Azure Blob Storage
**WHAT IT IS:**
  Microsoft's object storage solution for unstructured data. Massively
  scalable (exabytes), highly available, and durable. Three types of blobs:
  Block Blobs (files), Append Blobs (logs), Page Blobs (VHDs).

WHAT IT IS GOOD FOR (USE CASES):
- Storing images, videos, audio files
- Backup and disaster recovery
- Data archiving (cool and archive tiers)
- Serving static web content (static website hosting)
- Data lake storage for analytics (with Azure Data Lake Storage Gen2)
- Application data storage
- Log file storage
- Machine learning datasets
- CDN origin for media delivery

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Relational or structured data (use SQL Database)
- File system operations requiring frequent read/write (use Azure Files)
- Message queuing (use Service Bus or Storage Queues)
- High-frequency small transactions (use Cosmos DB or Redis)

**ACCESS TIERS:**
- Hot: Frequently accessed data, highest storage cost, lowest access cost
- Cool: Infrequently accessed, lower storage cost, higher access cost
- Cold: Rarely accessed, accessed every 90+ days
- Archive: Rarely accessed, offline, must be rehydrated before access
    (takes hours), lowest storage cost, highest access cost

**KEY FEATURES:**
- Lifecycle Management: Automatically transition blobs between tiers
- Blob Versioning: Keep previous versions of blobs
- Soft Delete: Recover deleted blobs within retention period
- Immutable Storage: WORM (Write Once, Read Many) policies
- Change Feed: Log of all changes to blobs
- Static Website Hosting: Serve HTML, CSS, JS directly
- Azure Data Lake Storage Gen2: Hierarchical namespace for analytics

**REDUNDANCY OPTIONS:**
- LRS (Locally Redundant Storage): 3 copies in single datacenter
- ZRS (Zone-Redundant Storage): 3 copies across availability zones
- GRS (Geo-Redundant Storage): 6 copies across two regions
- GZRS: Combines ZRS and GRS
- RA-GRS and RA-GZRS: Read access to secondary region

**BEST PRACTICES:**
- Use lifecycle policies to automatically tier cold data
- Enable soft delete to prevent accidental deletion
- Use SAS tokens for temporary, limited access
- Enable Azure Monitor for storage metrics
- Use private endpoints for secure access
- Enable versioning for critical data
### 2.2 Azure Files
**WHAT IT IS:**
  Fully managed cloud file shares accessible via SMB (Server Message Block)
  and NFS protocols. Can be mounted by Windows, macOS, and Linux clients,
  both in the cloud and on-premises.

WHAT IT IS GOOD FOR (USE CASES):
- Replacing or extending on-premises file servers
- Lift-and-shift of applications using file shares
- Shared configuration files for VMs and containers
- Developer tools, diagnostics, and utility tools sharing
- Enterprise applications expecting file shares (SAP, etc.)
- Home directories in virtualized desktop infrastructure (VDI)
- Azure File Sync to extend on-premises file servers to cloud

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Object/blob storage (use Blob Storage)
- Database storage
- High-throughput random I/O workloads (use Premium Azure Files or Disks)
- Multi-region distributed access without sync

**TIERS:**
- Transaction Optimized: Default, good for transaction-heavy workloads
- Hot: Frequently accessed shares
- Cool: Cost-optimized for infrequently accessed shares
- Premium: SSD-based, low latency, high IOPS

**KEY FEATURES:**
- Azure File Sync: Sync Azure Files with on-premises Windows Server
- Identity-based authentication (AD DS, Azure AD DS)
- Snapshots for backup and recovery
- SMB 3.x and NFS 4.1 support
### 2.3 Azure Disk Storage
**WHAT IT IS:**
  Block-level storage volumes (managed disks) for Azure VMs. Similar to
  physical hard disks but in the cloud. Managed disks are recommended
  over unmanaged (storage account based) disks.

WHAT IT IS GOOD FOR (USE CASES):
- VM OS disks and data disks
- Database servers requiring low-latency block storage
- Enterprise applications requiring high IOPS
- SQL Server, Oracle database workloads
- SAP HANA and other in-memory databases

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Shared file access across multiple VMs (use Azure Files)
- Object storage (use Blob Storage)
- Non-VM workloads (disks are attached to VMs)

**DISK TYPES:**
- Ultra Disk: Highest performance (up to 160,000 IOPS), SAP HANA, tier-1 DB
- Premium SSD v2: High performance, configurable IOPS/throughput
- Premium SSD: SSD-based, high performance for production VMs
- Standard SSD: SSD-based, balanced performance for web servers
- Standard HDD: Lowest cost, backup and non-critical workloads

**KEY FEATURES:**
- Shared Disks: Attach same disk to multiple VMs (clustered apps)
- Disk Encryption: Server-side encryption by default
- Disk Snapshots: Point-in-time copy
- Disk Bursting: Temporary IOPS boost
- Incremental Snapshots: Only changed data
### 2.4 Azure Queue Storage
**WHAT IT IS:**
  A service for storing large numbers of messages for asynchronous message
  passing between application components. Messages can be up to 64KB.
  Simple, cost-effective queueing solution.

WHAT IT IS GOOD FOR (USE CASES):
- Simple task queuing between web and worker roles
- Decoupling application components
- Buffering messages for processing
- Audit logging

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Messages larger than 64KB
- When you need ordering guarantees (FIFO) - use Service Bus
- Publish-subscribe scenarios (use Service Bus Topics or Event Grid)
- When you need message sessions or transactions
- Dead-letter queue requirements
### 2.5 Azure Table Storage
**WHAT IT IS:**
  NoSQL key-attribute data store for semi-structured data. Schemaless,
  flexible, and extremely cost-effective. Good for large amounts of
  non-relational data.

WHAT IT IS GOOD FOR (USE CASES):
- Web application data (user data, metadata)
- Address books and contact information
- Device information for IoT
- Simple lookups and configuration data
- Large datasets that don't need complex queries

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Complex queries and relationships (use Cosmos DB or SQL)
- When you need secondary indexes
- Low-latency requirements (consider Cosmos DB)
- When you need ACID transactions

---

## SECTION 3: NETWORKING SERVICES

---

### 3.1 Azure Virtual Network (VNet)
**WHAT IT IS:**
  The fundamental building block for private networking in Azure. Provides
  isolation, segmentation, and control over network traffic. Similar to
  traditional on-premises network but in the cloud.

WHAT IT IS GOOD FOR (USE CASES):
- Isolating Azure resources from the internet
- Segmenting workloads using subnets
- Connecting Azure to on-premises networks
- Enabling private communication between Azure services
- Building multi-tier application architectures
- Hub-and-spoke network topologies

**KEY CONCEPTS:**
- Address Space: CIDR blocks assigned to VNet
- Subnets: Subdivisions of address space
- Network Security Groups (NSGs): Firewall rules for subnets/NICs
- Route Tables: Custom routing rules
- Service Endpoints: Optimal routing to Azure services
- Private Endpoints: Private IP for Azure PaaS services
- VNet Peering: Connect VNets within or across regions
- NAT Gateway: Outbound internet connectivity
### 3.2 Azure Load Balancer
**WHAT IT IS:**
  A high-performance, ultra-low-latency Layer 4 (TCP/UDP) load balancer.
  Distributes inbound traffic to backend VM pools.

WHAT IT IS GOOD FOR (USE CASES):
- Load balancing traffic across VMs
- High availability for VM-based applications
- Inbound NAT for direct VM access
- Outbound connectivity for VMs

**TIERS:**
- Basic: Free, simple scenarios, no SLA, no availability zones
- Standard: Production, zone-redundant, SLA 99.99%, more features

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- HTTP/HTTPS-based routing (use Application Gateway)
- URL-based routing (use Application Gateway)
- Web Application Firewall requirements
### 3.3 Azure Application Gateway
**WHAT IT IS:**
  A Layer 7 (HTTP/HTTPS) web traffic load balancer with Web Application
  Firewall (WAF) capabilities. Supports URL-based routing, SSL termination,
  session affinity, and more.

WHAT IT IS GOOD FOR (USE CASES):
- HTTP/HTTPS load balancing
- URL-path-based routing to different backend pools
- Multi-site hosting on same gateway
- SSL/TLS termination and offloading
- Web Application Firewall (WAF) protection
- Rewrite HTTP headers and URLs
- AKS ingress controller

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Non-HTTP/HTTPS protocols (use Load Balancer or Traffic Manager)
- Global traffic distribution (use Front Door or Traffic Manager)
- Simple TCP/UDP load balancing (use Load Balancer)

**WAF CAPABILITIES:**
- OWASP Core Rule Sets protection
- Custom rules
- Bot protection
- Rate limiting
- Geo-filtering
### 3.4 Azure Front Door
**WHAT IT IS:**
  A global, scalable entry point that uses Microsoft's global edge network
  to deliver fast, reliable, and secure web applications. Combines CDN,
  WAF, load balancing, and URL routing at the global level.

WHAT IT IS GOOD FOR (USE CASES):
- Global web application acceleration
- Multi-region load balancing and failover
- Global WAF protection
- Static asset caching globally
- API acceleration
- Blue-green and canary deployments globally

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Non-HTTP/HTTPS workloads
- Single-region applications
- Simple CDN needs (consider Azure CDN)
### 3.5 Azure VPN Gateway
**WHAT IT IS:**
  Sends encrypted traffic between Azure virtual networks and on-premises
  locations over the public internet. Site-to-Site VPN, Point-to-Site VPN,
  and VNet-to-VNet connectivity.

WHAT IT IS GOOD FOR (USE CASES):
- Connecting on-premises networks to Azure (Site-to-Site)
- Remote worker access to Azure VNet (Point-to-Site)
- Connecting Azure VNets across regions
- Hybrid cloud scenarios
- Dev/test connectivity to Azure

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- High bandwidth requirements (use ExpressRoute)
- Latency-sensitive workloads (use ExpressRoute)
- When consistent, guaranteed bandwidth is needed
### 3.6 Azure ExpressRoute
**WHAT IT IS:**
  Private dedicated connectivity between on-premises and Azure via a
  connectivity provider. Not over public internet. Provides guaranteed
  bandwidth, consistent latency, and enterprise-grade SLAs.

WHAT IT IS GOOD FOR (USE CASES):
- Mission-critical enterprise workloads
- Large data migrations
- Compliance requirements for private connectivity
- High-bandwidth requirements (up to 100Gbps)
- Hybrid applications requiring predictable performance
- Disaster recovery with private connectivity

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Cost-sensitive scenarios (much more expensive than VPN)
- Small businesses or dev/test (VPN Gateway sufficient)
- Temporary connectivity needs
### 3.7 Azure DNS
**WHAT IT IS:**
  Hosting service for DNS domains that provides name resolution using
  Microsoft Azure infrastructure. Reliable, highly available DNS service
  using anycast networking.

WHAT IT IS GOOD FOR (USE CASES):
- Hosting public DNS zones for internet-facing apps
- Private DNS zones for Azure VNet name resolution
- Custom DNS records for Azure services
- Alias records for Azure resources

**KEY FEATURES:**
- Azure DNS Private Zones: DNS resolution within VNet
- DNS-based traffic routing (with Traffic Manager)
- DNSSEC support
### 3.8 Azure Traffic Manager
**WHAT IT IS:**
  DNS-based traffic load balancer that distributes traffic optimally to
  services across global Azure regions. Works at the DNS level.

WHAT IT IS GOOD FOR (USE CASES):
- Global traffic distribution across regions
- Failover between primary and secondary regions
- Geographic routing (route users to nearest region)
- Performance-based routing
- Multi-value routing

**ROUTING METHODS:**
- Priority: Primary/failover routing
- Weighted: Distribute traffic by percentage
- Performance: Route to lowest latency endpoint
- Geographic: Route based on user location
- Multivalue: Return multiple healthy endpoints
- Subnet: Route based on user IP subnet
### 3.9 Azure CDN
**WHAT IT IS:**
  Content Delivery Network that caches content at strategically placed
  point-of-presence (POP) locations to deliver content faster to users.

WHAT IT IS GOOD FOR (USE CASES):
- Accelerating static web content delivery
- Streaming media (video, audio)
- Software download acceleration
- Dynamic site acceleration
- Reducing load on origin servers

CDN PROVIDERS (via Azure):
- Microsoft (classic): Native Azure CDN
- Verizon Standard/Premium: Additional rules and analytics
- Akamai Standard: Widely distributed network
### 3.10 Azure Private Link
**WHAT IT IS:**
  Enables private connectivity to Azure services and customer/partner
  services over a private endpoint in your VNet, eliminating internet
  exposure.

WHAT IT IS GOOD FOR (USE CASES):
- Accessing PaaS services (Storage, SQL, etc.) over private network
- Compliance and regulatory requirements
- Preventing data exfiltration
- Service providers offering private connectivity to customers

---

## SECTION 4: DATABASE SERVICES

---

### 4.1 Azure SQL Database
**WHAT IT IS:**
  A fully managed relational database service based on the latest stable
  version of Microsoft SQL Server. PaaS with built-in high availability,
  automatic backups, and intelligent performance features.

WHAT IT IS GOOD FOR (USE CASES):
- Modern cloud applications requiring relational database
- Applications being migrated from SQL Server
- SaaS applications needing elastic scaling
- Applications requiring ACID transactions
- Reporting and analytics with T-SQL
- Applications with variable or unpredictable load (serverless option)
- Multi-tenant SaaS with Elastic Pools

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Applications needing NoSQL (use Cosmos DB)
- Very large data warehousing (use Synapse Analytics)
- When you need full SQL Server instance features (use Managed Instance)
- Graph data workloads at scale (consider Cosmos DB Gremlin)

**DEPLOYMENT OPTIONS:**
- Single Database: Isolated database with dedicated resources
- Elastic Pool: Multiple databases sharing resources (cost savings)
- Serverless: Auto-pause when inactive, auto-resume on demand

**PURCHASING MODELS:**
- DTU-based: Bundled CPU, memory, and I/O
- vCore-based: Choose vCores, memory, storage independently
    (Azure Hybrid Benefit applies here)

**SERVICE TIERS:**
- General Purpose: Balanced compute and storage
- Business Critical: High IOPS, fast failover, in-memory OLTP
- Hyperscale: Up to 100TB, fast backups, horizontal read scale-out

**KEY FEATURES:**
- Built-in high availability (99.99% SLA)
- Automatic backups with point-in-time restore
- Active Geo-Replication for read replicas
- Auto-failover groups for regional failover
- Advanced Threat Protection and vulnerability assessment
- Transparent Data Encryption (TDE)
- In-memory OLTP for high performance (Business Critical)
- Query Performance Insight and automatic tuning
### 4.2 Azure SQL Managed Instance
**WHAT IT IS:**
  A fully managed SQL Server instance with near 100% compatibility with
  on-premises SQL Server. Ideal for lift-and-shift migrations where you
  need SQL Agent, linked servers, or other instance-level features.

WHAT IT IS GOOD FOR (USE CASES):
- Migrating on-premises SQL Server with minimal changes
- Applications requiring SQL Server Agent jobs
- Cross-database queries and transactions
- Applications using CLR, Database Mail, Service Broker
- When instance-level features are needed

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- New cloud-native applications (use SQL Database)
- Single database scenarios
- When you need the lowest possible latency (it's VNet-injected)
### 4.3 Azure Cosmos DB
**WHAT IT IS:**
  A globally distributed, multi-model NoSQL database. Provides single-digit
  millisecond read and write latencies at any scale, anywhere in the world.
  Supports multiple APIs: NoSQL, MongoDB, Cassandra, Gremlin, Table.

WHAT IT IS GOOD FOR (USE CASES):
- Globally distributed applications
- Applications requiring low latency at any scale
- IoT telemetry storage
- Real-time personalization
- Product catalogs and user preference stores
- Gaming leaderboards
- Social and mobile applications
- Multi-model data (document, graph, key-value, column-family)

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Complex relational queries and JOINs (use SQL Database)
- Applications requiring complex transactions across documents
- Cost-sensitive workloads with moderate requirements (it's expensive)
- Analytical workloads (use Synapse Analytics)
- When data is heavily normalized and relational

CONSISTENCY LEVELS (weakest to strongest):
- Eventual: Highest availability, lowest latency, no ordering guarantee
- Consistent Prefix: No out-of-order reads
- Session: Within a session, monotonic reads/writes
- Bounded Staleness: Reads lag writes by K versions or T time
- Strong: Linear consistency, highest latency

**CAPACITY MODES:**
- Provisioned Throughput: Request Units (RUs) per second, predictable
- Serverless: Pay per operation, ideal for sporadic workloads
- Autoscale: Auto-scale RU/s between min/max range

**KEY FEATURES:**
- Multi-region writes (active-active replication)
- 99.999% availability SLA for multi-region
- Automatic and instant scalability
- No schema management
- HTAP with Analytical Store (Azure Synapse Link)
- Change Feed for event-driven architectures
- Free tier (400 RU/s, 5GB storage)
### 4.4 Azure Database for PostgreSQL
**WHAT IT IS:**
  Fully managed PostgreSQL database service with high availability, security,
  and intelligent performance features. Supports PostgreSQL community version.

WHAT IT IS GOOD FOR (USE CASES):
- Applications built on PostgreSQL
- Geospatial applications (PostGIS extension)
- Analytics workloads
- Open-source stack applications
- Migrating on-premises PostgreSQL to cloud

**DEPLOYMENT MODES:**
- Flexible Server: Recommended, more control, zone-redundant HA, cost savings
- Single Server: Legacy option, simpler but limited (being deprecated)
### 4.5 Azure Database for MySQL
**WHAT IT IS:**
  Fully managed MySQL community edition database service. Good for
  LAMP-stack web applications and MySQL-compatible workloads.

WHAT IT IS GOOD FOR (USE CASES):
- Web applications using LAMP stack
- WordPress and PHP applications
- E-commerce platforms
- Applications migrating from on-premises MySQL
### 4.6 Azure Cache for Redis
**WHAT IT IS:**
  Fully managed in-memory data store based on Redis. Provides ultra-fast
  data access with sub-millisecond latency. Supports Redis data structures.

WHAT IT IS GOOD FOR (USE CASES):
- Application caching to reduce database load
- Session store for web applications
- Message broker and pub/sub
- Leaderboards and counting
- Real-time analytics
- Distributed locking
- Rate limiting

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Durable, persistent primary data store
- Large datasets that don't fit in memory
- Complex query requirements

**TIERS:**
- Basic: Single node, development/test, no SLA
- Standard: Replicated, 99.9% SLA
- Premium: Clustering, data persistence, VNet, geo-replication
- Enterprise: Redis Enterprise, highest performance
- Enterprise Flash: Redis on Flash, cost-effective large cache
### 4.7 Azure Synapse Analytics
**WHAT IT IS:**
  An integrated analytics service that brings together enterprise data
  warehousing (formerly Azure SQL Data Warehouse), big data analytics,
  data integration (pipelines), and BI reporting under one platform.

WHAT IT IS GOOD FOR (USE CASES):
- Enterprise data warehousing at petabyte scale
- Big data analytics combining structured and unstructured data
- Real-time analytics on streaming data
- Data lake analytics with Spark
- Business intelligence and reporting
- Data integration and ETL/ELT pipelines

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- OLTP (operational) workloads (use SQL Database)
- Simple reporting (use Power BI with direct connection)
- Small datasets

**KEY COMPONENTS:**
- Dedicated SQL Pool: MPP-based data warehouse (formerly SQL DW)
- Serverless SQL Pool: On-demand SQL queries over data lake
- Apache Spark Pool: Big data processing
- Synapse Pipelines: Data integration (similar to Data Factory)
- Synapse Studio: Unified workspace
- Azure Synapse Link: No-ETL analytics on operational data

---

## SECTION 5: AI & MACHINE LEARNING

---

### 5.1 Azure Machine Learning
**WHAT IT IS:**
  An enterprise-grade machine learning service for the full ML lifecycle:
  data preparation, model training, deployment, and management. Supports
  AutoML, designer (GUI), and code-first approaches.

WHAT IT IS GOOD FOR (USE CASES):
- Training custom ML models at scale
- AutoML for automated model selection and hyperparameter tuning
- MLOps pipelines for automated model deployment
- Responsible AI and model explainability
- Distributed training on GPU clusters
- Experiment tracking and model registry
- Feature engineering and data labeling

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Pre-built AI use cases (use Azure Cognitive Services / AI Services)
- Simple data transformation (use Synapse or Data Factory)
- When you need real-time ML without operationalization complexity

**KEY COMPONENTS:**
- Workspace: Top-level resource organizing all ML artifacts
- Compute: Clusters, instances, and inference endpoints
- Datastores and Datasets: Data management
- Experiments and Runs: Tracking training executions
- Models: Model registry with versioning
- Endpoints: Real-time and batch inference
- Pipelines: ML workflow automation
- Designer: Drag-and-drop ML
- AutoML: Automated machine learning
- Responsible AI Dashboard: Bias, fairness, explainability
### 5.2 Azure Cognitive Services / Azure AI Services
**WHAT IT IS:**
  Pre-built AI APIs that allow you to add intelligence to applications
  without deep ML expertise. Covers vision, speech, language, decision,
  and more. Now rebranded as Azure AI Services.

WHAT IT IS GOOD FOR (USE CASES):
- Adding AI to applications quickly without ML expertise
- Computer vision (object detection, OCR, face recognition)
- Speech-to-text and text-to-speech
- Language understanding and translation
- Sentiment analysis and key phrase extraction
- Content moderation
- Anomaly detection

**KEY SERVICES:**
  Vision:
  - Azure Computer Vision: Image analysis, OCR, spatial analysis
  - Azure Custom Vision: Train custom image classifiers/detectors
  - Azure Face: Face detection, verification, identification
  - Azure Video Indexer: Video analysis and indexing
  Speech:
  - Speech-to-Text: Convert audio to text
  - Text-to-Speech: Convert text to natural speech
  - Speech Translation: Real-time audio translation
  - Speaker Recognition: Identify speakers from voice
  Language:
  - Azure OpenAI Service: GPT-4, DALL-E, Whisper models
  - Language Understanding (LUIS): Intent and entity recognition
  - Azure Text Analytics: Sentiment, key phrases, NER
  - Azure Translator: 100+ language translation
  - QnA Maker / Azure AI Language: Q&A knowledge bases
  Decision:
  - Anomaly Detector: Detect anomalies in time-series data
  - Content Moderator: Screen text, images, videos
  - Personalizer: Reinforcement learning for recommendations
  - Metrics Advisor: Monitor business metrics
### 5.3 Azure OpenAI Service
**WHAT IT IS:**
  Provides access to OpenAI's powerful language models (GPT-4, GPT-3.5,
  DALL-E, Whisper, Embeddings) with Azure's enterprise-grade security,
  compliance, and reliability.

WHAT IT IS GOOD FOR (USE CASES):
- Generative AI applications (chatbots, content generation)
- Code generation and review
- Document summarization and analysis
- Semantic search with embeddings
- Language translation and localization
- Image generation (DALL-E)
- Speech transcription (Whisper)
- Retrieval Augmented Generation (RAG) patterns

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Deterministic, rule-based responses
- Real-time low-latency requirements
- When response accuracy must be 100% (hallucinations possible)
- Regulated industries without proper guardrails

**KEY FEATURES:**
- Private deployment (your data doesn't train OpenAI models)
- Azure AD authentication
- VNet integration and private endpoints
- Content filtering and responsible AI controls
- Fine-tuning support
- On Your Data feature for grounding with enterprise data
### 5.4 Azure Bot Service
**WHAT IT IS:**
  A managed service for developing, testing, and deploying intelligent
  bots. Integrates with Bot Framework SDK and Azure OpenAI for
  conversational AI.

WHAT IT IS GOOD FOR (USE CASES):
- Customer support chatbots
- FAQ bots
- Internal helpdesk automation
- Multi-channel bot deployment (Teams, Slack, web, phone)

**KEY FEATURES:**
- Multi-channel publishing (Teams, Slack, Facebook, etc.)
- Integration with Azure OpenAI and Language Understanding
- Power Virtual Agents integration
- Built-in analytics and conversation transcripts

---

## SECTION 6: ANALYTICS & BIG DATA

---

### 6.1 Azure Data Factory (ADF)
**WHAT IT IS:**
  Cloud-based ETL/ELT and data integration service. Create data-driven
  workflows (pipelines) to orchestrate data movement and transformation
  at scale. Code-free and code-based options.

WHAT IT IS GOOD FOR (USE CASES):
- Data ingestion from 90+ connectors (SaaS, databases, files)
- ETL/ELT data pipelines
- Orchestrating Spark, HDInsight, Azure ML activities
- Migrating data to Azure data platform
- Operational data movement
- Data lake ingestion patterns

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Real-time streaming (use Stream Analytics or Event Hubs)
- Compute-heavy transformations (combine with Spark/Databricks)
- Very complex workflow orchestration (consider Logic Apps or Airflow)
### 6.2 Azure Databricks
**WHAT IT IS:**
  Apache Spark-based analytics platform optimized for Azure. Combines
  data engineering, data science, and ML in a collaborative notebook
  environment. Built by the original Spark creators.

WHAT IT IS GOOD FOR (USE CASES):
- Large-scale data engineering and ETL
- Machine learning at scale with MLflow
- Real-time and batch analytics
- Data lake transformation (Delta Lake)
- Collaborative data science
- Streaming analytics
- BI and SQL analytics (SQL Analytics/Lakehouse)

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Small datasets (cost-prohibitive)
- Simple SQL queries (use Synapse Serverless)
- Non-data-engineering tasks
### 6.3 Azure Event Hubs
**WHAT IT IS:**
  A fully managed, real-time data ingestion service. Can receive and
  process millions of events per second. Acts as the "front door" for
  an event pipeline.

WHAT IT IS GOOD FOR (USE CASES):
- Telemetry ingestion from IoT devices
- Log and metrics streaming
- Clickstream analytics
- Application event streaming
- Integration with Apache Kafka (Kafka-compatible endpoint)
- Fraud detection pipelines

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Message queuing with individual message delivery (use Service Bus)
- Command and control messaging (use Service Bus)
- When you need guaranteed ordering of messages

**KEY FEATURES:**
- Capture: Automatically save events to Blob Storage or Data Lake
- Kafka-compatible endpoint: Migrate Kafka workloads easily
- Partitioned consumer model for parallel processing
- Event retention (up to 90 days)
- Schema Registry for event schemas
### 6.4 Azure Stream Analytics
**WHAT IT IS:**
  A real-time analytics and event-processing engine. Process streaming data
  from Event Hubs, IoT Hub, or Blob Storage using SQL-like queries.

WHAT IT IS GOOD FOR (USE CASES):
- Real-time telemetry analysis
- Fraud detection in real-time
- IoT data processing
- Real-time dashboards and alerting
- Anomaly detection in streams
- ETL on streaming data

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Complex ML on streams (use Databricks Streaming)
- Historical batch analytics
- When you need Python/Java logic (limited to SQL queries)
### 6.5 Azure HDInsight
**WHAT IT IS:**
  Managed open-source analytics cluster service. Supports Hadoop, Spark,
  Hive, HBase, Kafka, and Storm on Azure without managing clusters.

WHAT IT IS GOOD FOR (USE CASES):
- Organizations with existing Hadoop/HBase expertise
- When you need specific open-source versions and configurations
- ETL with Hive
- Kafka brokers management

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- New data engineering projects (consider Databricks or Synapse)
- When managed services are preferred
- Cost-sensitive scenarios (Databricks often better value)
### 6.6 Azure Data Lake Storage Gen2
**WHAT IT IS:**
  A set of capabilities built on Azure Blob Storage for big data analytics.
  Adds hierarchical namespace to Blob Storage, enabling directory operations
  and ACLs compatible with HDFS.

WHAT IT IS GOOD FOR (USE CASES):
- Enterprise data lake for all data types
- Foundation for analytics workloads (Databricks, Synapse, HDInsight)
- Scalable, cost-effective storage for big data
- Storing raw, refined, and curated data in a data lakehouse
### 6.7 Microsoft Fabric
**WHAT IT IS:**
  An all-in-one analytics platform combining data engineering, data
  warehouse, data science, real-time intelligence, and BI. Built on top
  of Azure infrastructure with OneLake as the unified storage layer.

WHAT IT IS GOOD FOR (USE CASES):
- Unified analytics platform to replace multiple Azure services
- Organizations wanting single platform for all analytics needs
- Power BI-centric organizations expanding to data engineering
- Self-service analytics at enterprise scale

**COMPONENTS:**
- OneLake: Unified data lake
- Data Engineering: Spark-based notebooks and pipelines
- Data Warehouse: SQL-based analytics
- Data Factory: Data integration
- Real-Time Intelligence: Streaming analytics
- Power BI: Business intelligence
- Data Activator: Event-driven alerting

---

## SECTION 7: DEVOPS & DEVELOPER TOOLS

---

### 7.1 Azure DevOps
**WHAT IT IS:**
  A suite of development collaboration tools: Boards (Agile planning),
  Repos (Git), Pipelines (CI/CD), Test Plans (testing), and Artifacts
  (package management).

WHAT IT IS GOOD FOR (USE CASES):
- End-to-end DevOps workflows
- CI/CD pipelines for any language/platform
- Agile project management
- Private and public Git repositories
- Package management (NuGet, npm, Maven, Python)
- Test automation and test management

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Organizations already heavily invested in GitHub (consider GitHub Actions)
- Simple open-source projects (GitHub is more suitable)
### 7.2 GitHub + GitHub Actions
**WHAT IT IS:**
  GitHub is a code hosting platform owned by Microsoft. GitHub Actions is
  the CI/CD and workflow automation service. Deeply integrated with Azure.

WHAT IT IS GOOD FOR (USE CASES):
- Open-source and inner-source development
- CI/CD pipelines with GitHub Actions
- Code review and pull request workflows
- Security scanning (GitHub Advanced Security)
- Project management with GitHub Issues and Projects

**AZURE INTEGRATION:**
- Azure credentials stored as GitHub Secrets
- Deploy to Azure services via official GitHub Actions
- GitHub Codespaces for cloud development environments
### 7.3 Azure Container Registry (ACR)
**WHAT IT IS:**
  Managed, private Docker registry service based on Docker Registry 2.0.
  Store and manage container images and artifacts.

WHAT IT IS GOOD FOR (USE CASES):
- Private container image storage
- Automated image builds (ACR Tasks)
- Geo-replication for global deployments
- Image scanning for vulnerabilities
- Supply chain security with signed images

**TIERS:**
- Basic: Development, limited storage
- Standard: Production, more storage
- Premium: Geo-replication, private endpoints, content trust
### 7.4 Azure Monitor
**WHAT IT IS:**
  Comprehensive monitoring solution for collecting, analyzing, and acting
  on telemetry from cloud and on-premises environments. Provides metrics,
  logs, traces, and alerts.

WHAT IT IS GOOD FOR (USE CASES):
- Infrastructure monitoring (VMs, AKS, PaaS services)
- Application performance monitoring
- Log analytics and querying
- Alerting and notifications
- Dashboards and workbooks
- Autoscale based on metrics

**KEY COMPONENTS:**
- Metrics: Numerical time-series data
- Log Analytics: Log data stored in Log Analytics workspace
- Application Insights: APM for web applications
- Alerts: Rules-based alerting on metrics and logs
- Dashboards and Workbooks: Visualization
- Autoscale: Scale resources based on metrics
- Network Insights: Network monitoring
- Container Insights: AKS and container monitoring
### 7.5 Application Insights
**WHAT IT IS:**
  Application Performance Management (APM) feature of Azure Monitor.
  Automatic performance anomaly detection, powerful analytics, and
  end-to-end transaction tracing for web applications.

WHAT IT IS GOOD FOR (USE CASES):
- Web application performance monitoring
- Distributed tracing across microservices
- Usage analytics (who uses your app and how)
- Exception tracking and alerting
- Live metrics stream for real-time monitoring
- Custom events and metrics
### 7.6 Azure Log Analytics
**WHAT IT IS:**
  A service within Azure Monitor that stores and analyzes log data using
  KQL (Kusto Query Language). Central hub for log data from all sources.

WHAT IT IS GOOD FOR (USE CASES):
- Centralized log management
- Security event correlation
- Infrastructure and application log analysis
- Custom dashboards and workbooks
- Long-term log retention

---

## SECTION 8: SECURITY & IDENTITY

---

### 8.1 Microsoft Entra ID (formerly Azure Active Directory)
**WHAT IT IS:**
  Cloud-based identity and access management service. Foundation for
  authentication and authorization in Azure and Microsoft 365. Supports
  SSO, MFA, Conditional Access, and B2B/B2C scenarios.

WHAT IT IS GOOD FOR (USE CASES):
- Single Sign-On (SSO) to cloud and on-premises apps
- Multi-Factor Authentication (MFA)
- Conditional Access policies
- External identity management (B2B, B2C)
- Application registration and OIDC/OAuth flows
- Device management (Intune integration)
- Privileged Identity Management (PIM)

**KEY FEATURES:**
- Conditional Access: Context-aware access policies
- Identity Protection: Risk-based policies
- Privileged Identity Management (PIM): JIT access for admin roles
- Entitlement Management: Access packages
- Azure AD B2C: Consumer identity management
- Azure AD B2B: Guest/partner access
- Seamless SSO: On-premises joined machines

**TIERS:**
- Free: Included with Azure subscription, basic features
- P1: Conditional Access, hybrid identity, self-service password reset
- P2: Identity Protection, PIM, access reviews
### 8.2 Azure Key Vault
**WHAT IT IS:**
  Cloud service for securely storing and accessing secrets, keys, and
  certificates. Centralizes application secrets and provides hardware
  security module (HSM) backed key storage.

WHAT IT IS GOOD FOR (USE CASES):
- Storing application secrets (connection strings, API keys)
- Managing encryption keys for data encryption
- Storing SSL/TLS certificates
- Managed identity integration for secretless apps
- Key rotation automation

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Storing large amounts of data
- Secrets not requiring central management

**OBJECT TYPES:**
- Secrets: Passwords, connection strings (max 25KB)
- Keys: Cryptographic keys (RSA, EC)
- Certificates: X.509 certificates with automatic renewal

**TIERS:**
- Standard: Software-protected keys
- Premium: HSM-protected keys (FIPS 140-2 Level 2)

**BEST PRACTICES:**
- Use Managed Identity to access Key Vault (no credentials)
- Enable soft delete and purge protection
- Use separate vaults per application and environment
- Enable logging and auditing
- Set access policies or use Azure RBAC
### 8.3 Microsoft Defender for Cloud
**WHAT IT IS:**
  Cloud Security Posture Management (CSPM) and Cloud Workload Protection
  Platform (CWPP). Provides security recommendations, threat detection,
  and compliance assessment.

WHAT IT IS GOOD FOR (USE CASES):
- Security posture assessment and recommendations
- Threat detection across VMs, containers, databases
- Regulatory compliance monitoring
- DevSecOps security scanning
- Multi-cloud security (AWS, GCP support)
- Just-in-Time VM access

**PLANS:**
- Foundational CSPM: Free, basic security recommendations
- Defender CSPM: Advanced posture management, AI-powered
- Workload Plans: Individual plans for servers, containers, databases, etc.
### 8.4 Microsoft Sentinel
**WHAT IT IS:**
  Cloud-native Security Information and Event Management (SIEM) and
  Security Orchestration, Automation, and Response (SOAR) solution.
  AI-powered threat intelligence.

WHAT IT IS GOOD FOR (USE CASES):
- Enterprise-wide security event correlation
- Threat hunting and investigation
- Automated incident response
- Compliance reporting
- Integration with 200+ data connectors
### 8.5 Azure Firewall
**WHAT IT IS:**
  Managed, cloud-native network security service with stateful firewall
  capabilities. Fully managed with built-in high availability and
  auto-scaling.

WHAT IT IS GOOD FOR (USE CASES):
- Central network security policy enforcement
- Outbound internet traffic filtering
- East-west traffic filtering between VNets
- Threat intelligence-based filtering
- FQDN-based application rules

**TIERS:**
- Standard: FQDN filtering, network rules, NAT
- Premium: TLS inspection, IDPS, URL categories, web categories
### 8.6 Azure DDoS Protection
**WHAT IT IS:**
  Protects Azure resources from Distributed Denial of Service attacks.
  Adaptive real-time tuning and attack analytics.

**TIERS:**
- Network Protection (Basic): Automatically enabled for all Azure services
- IP Protection: Per-IP protection for specific public IPs
- Network Protection: Enhanced, cost guarantee, DDoS response team access
### 8.7 Azure Policy
**WHAT IT IS:**
  Governance service to enforce organizational standards and assess
  compliance at scale. Define rules for resource configurations.

WHAT IT IS GOOD FOR (USE CASES):
- Enforcing naming conventions
- Restricting resource creation to approved regions
- Requiring tags on resources
- Enforcing security configurations
- Audit-only or enforce mode

---

## SECTION 9: INTEGRATION SERVICES

---

### 9.1 Azure Service Bus
**WHAT IT IS:**
  Enterprise message broker with advanced messaging features. Supports
  queues (point-to-point) and topics/subscriptions (publish-subscribe).
  Guaranteed message delivery.

WHAT IT IS GOOD FOR (USE CASES):
- Enterprise application integration
- Decoupling services with reliable messaging
- Order processing and workflow orchestration
- When message ordering is required (sessions)
- When you need dead-letter queues
- Financial transactions and audit trails
- Publish-subscribe patterns

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- High-volume event streaming (use Event Hubs)
- Simple task queuing (Storage Queues sufficient)
- Real-time streaming

**KEY FEATURES:**
- Sessions: Group-ordered message processing
- Dead-letter Queue: Messages that can't be processed
- Scheduled Messages: Deliver at future time
- Message deferral: Defer processing
- Duplicate detection
- Transactions: Atomic operations across messages
- Message lock: Prevent other consumers from reading

**TIERS:**
- Basic: Queues only, no topics
- Standard: Queues and topics, variable messaging
- Premium: Dedicated resources, VNet, geo-disaster recovery
### 9.2 Azure Event Grid
**WHAT IT IS:**
  Serverless event routing service using publish-subscribe model. Routes
  events from Azure services or custom sources to event handlers.
  Built on Azure fabric.

WHAT IT IS GOOD FOR (USE CASES):
- React to Azure resource changes (blob created, VM deleted)
- Event-driven architectures
- Serverless application workflows
- Integrating systems via events
- IoT event routing
- Application integration

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Large event payloads (>1MB, use Event Hubs)
- High-volume ordered event streaming
- When you need event retention/replay (use Event Hubs)
### 9.3 Azure Logic Apps
**WHAT IT IS:**
  Low-code platform for automating workflows and integrating apps, data,
  and services. 400+ connectors for SaaS, enterprise, and Azure services.

WHAT IT IS GOOD FOR (USE CASES):
- Business process automation
- SaaS application integration (Salesforce, Office 365, etc.)
- Scheduled tasks and data sync
- Approval workflows
- EDI/B2B scenarios (B2B Enterprise Integration Pack)

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Complex code logic (use Functions or Durable Functions)
- High-performance, low-latency scenarios
- When development team wants full code control

**HOSTING OPTIONS:**
- Consumption: Serverless, pay per execution
- Standard: Dedicated, VNet integration, multi-workflow
### 9.4 Azure API Management (APIM)
**WHAT IT IS:**
  Full lifecycle API management platform. Create consistent API gateways
  for existing backend services. Add policies for security, transformation,
  rate limiting, and monitoring.

WHAT IT IS GOOD FOR (USE CASES):
- Publishing APIs to internal and external developers
- API gateway with security and rate limiting
- API versioning and lifecycle management
- Developer portal with documentation
- Monetizing APIs
- Multi-backend API aggregation
- Self-hosted gateway for on-premises APIs

**TIERS:**
- Developer: Non-production, no SLA
- Basic: Basic production use
- Standard: Medium traffic, multi-region
- Premium: Multi-region, VNet, high traffic
- Consumption: Serverless, pay per call

---

## SECTION 10: IoT SERVICES

---

### 10.1 Azure IoT Hub
**WHAT IT IS:**
  Managed service for bi-directional communication between IoT devices
  and cloud. Device-to-cloud telemetry, cloud-to-device commands.
  Supports MQTT, AMQP, HTTPS protocols.

WHAT IT IS GOOD FOR (USE CASES):
- IoT device management and communication
- Telemetry ingestion from millions of devices
- Device provisioning and lifecycle management
- Edge computing orchestration (IoT Edge)
- Industrial IoT scenarios

**KEY FEATURES:**
- Device Twin: JSON-based device state synchronization
- Direct Methods: Invoke device functions from cloud
- Device Provisioning Service: Zero-touch provisioning
- IoT Edge: Run cloud intelligence on edge devices
### 10.2 Azure IoT Central
**WHAT IT IS:**
  Managed IoT application platform (SaaS) that simplifies IoT solution
  creation. No infrastructure management required. Built-in dashboards,
  analytics, and device management.

WHAT IT IS GOOD FOR (USE CASES):
- Rapid IoT application deployment without IoT expertise
- Asset tracking and monitoring
- Connected equipment management
- Smart energy and utilities
- Retail analytics

WHAT IT IS NOT GOOD FOR (AVOID WHEN):
- Custom, complex IoT architectures (use IoT Hub directly)
- High-throughput, low-latency requirements

---

## SECTION 11: MANAGEMENT & GOVERNANCE

---

### 11.1 Azure Resource Manager (ARM)
**WHAT IT IS:**
  The deployment and management service for Azure. Provides consistent
  management layer for all Azure operations. ARM Templates (JSON or Bicep)
  enable infrastructure as code.

WHAT IT IS GOOD FOR (USE CASES):
- Infrastructure as Code deployments
- Consistent resource deployment across environments
- RBAC at resource group level
- Resource tagging and organization

**ARM TEMPLATE ALTERNATIVES:**
- Bicep: Domain-specific language, cleaner syntax than JSON ARM
- Terraform: Multi-cloud IaC (uses Azure ARM under the hood)
- Pulumi: Infrastructure as actual programming code
### 11.2 Azure Management Groups
**WHAT IT IS:**
  Containers that help manage access, policy, and compliance across
  multiple Azure subscriptions. Hierarchical structure above subscriptions.

**HIERARCHY:**
  Root Management Group → Management Groups → Subscriptions → Resource Groups → Resources
### 11.3 Azure Cost Management + Billing
**WHAT IT IS:**
  Tools to monitor, allocate, and optimize Azure spending. Provides
  budgets, cost analysis, and cost alerts.

WHAT IT IS GOOD FOR (USE CASES):
- Cloud cost visibility and analysis
- Budget creation and alerts
- Cost allocation with tags
- Savings recommendations
- Chargeback and showback reports
### 11.4 Azure Advisor
**WHAT IT IS:**
  Personalized cloud consultant that analyzes configurations and telemetry
  to provide best practice recommendations.

**RECOMMENDATION CATEGORIES:**
- Reliability (formerly High Availability)
- Security
- Performance
- Cost
- Operational Excellence
### 11.5 Azure Blueprints
**WHAT IT IS:**
  Define repeatable sets of Azure resources that comply with standards,
  patterns, and requirements. Package ARM templates, policies, and role
  assignments.

NOTE: Azure Blueprints is being deprecated in favor of Azure Deployment
      Stacks combined with Azure Policy.
### 11.6 Azure Automation
**WHAT IT IS:**
  Cloud-based automation and configuration service. Runbooks (PowerShell/
  Python scripts), Update Management, Change Tracking, and DSC.

WHAT IT IS GOOD FOR (USE CASES):
- Automating repetitive operational tasks
- VM patching with Update Management
- Configuration Management with DSC
- Start/stop VMs on schedule
- Process automation workflows
### 11.7 Azure Arc
**WHAT IT IS:**
  Extends Azure management capabilities to on-premises, other clouds,
  and edge environments. Manage non-Azure resources as if they were
  Azure resources.

WHAT IT IS GOOD FOR (USE CASES):
- Managing on-premises servers with Azure tools
- Running Azure PaaS services on-premises or other clouds
- Unified security and compliance across environments
- Kubernetes management across environments (Arc-enabled Kubernetes)
- SQL Server management on any environment

---

## SECTION 12: MIGRATION SERVICES

---

### 12.1 Azure Migrate
**WHAT IT IS:**
  Centralized hub for discovering, assessing, and migrating on-premises
  workloads to Azure. Covers VMs, databases, web apps, and VDI.

WHAT IT IS GOOD FOR (USE CASES):
- Discovery and assessment of on-premises environment
- VM migration (Hyper-V, VMware, physical)
- Database migration assessment
- Web app migration

**KEY TOOLS:**
- Azure Migrate: Discovery and Assessment
- Azure Migrate: Server Migration
- Data Migration Assistant (DMA)
- Database Migration Service (DMS)
### 12.2 Azure Database Migration Service
**WHAT IT IS:**
  Fully managed service for migrating databases to Azure at scale.
  Supports SQL Server, Oracle, MySQL, PostgreSQL, and more.

**MIGRATION TYPES:**
- Offline: Downtime required during migration
- Online: Continuous sync, minimal downtime
### 12.3 Azure Data Box
**WHAT IT IS:**
  Physical data transfer devices for moving large amounts of data to Azure
  when network transfer would be too slow or expensive.

**DEVICE VARIANTS:**
- Data Box Disk: Up to 40TB, SSD disks
- Data Box: 80TB, ruggedized device
- Data Box Heavy: 1PB, large-scale migrations
- Data Box Gateway: Virtual device for ongoing online transfers

---

## SECTION 13: MEDIA SERVICES

---

### 13.1 Azure Media Services
**WHAT IT IS:**
  Cloud-based platform for broadcasting-quality video streaming. Encode,
  protect, and stream video content at scale.

NOTE: Azure Media Services is being retired on June 30, 2024.
      Microsoft recommends migrating to alternative solutions.

WHAT IT IS GOOD FOR (USE CASES):
- Live streaming events
- Video on demand (VOD)
- Content protection with DRM
- Video transcoding at scale

---

## SECTION 14: MIXED REALITY

---

### 14.1 Azure Spatial Anchors
**WHAT IT IS:**
  Cross-platform service for building spatially aware mixed reality
  applications. Create persistent anchors in physical spaces.

WHAT IT IS GOOD FOR (USE CASES):
- Multi-user mixed reality experiences
- Industrial asset labeling and navigation
- AR wayfinding applications
### 14.2 Azure Remote Rendering
**WHAT IT IS:**
  Render high-quality, interactive 3D content in the cloud and stream
  it in real-time to mixed reality devices.

WHAT IT IS GOOD FOR (USE CASES):
- Industrial equipment visualization
- Engineering and architecture review
- Medical imaging visualization

---

## SECTION 15: ADDITIONAL IMPORTANT SERVICES

---

### 15.1 Azure Active Directory Domain Services (Entra DS)
**WHAT IT IS:**
  Managed domain services including domain join, group policy, LDAP, and
  Kerberos/NTLM authentication. No need to deploy/manage domain controllers.

WHAT IT IS GOOD FOR (USE CASES):
- Lift-and-shift of applications requiring AD (LDAP, Kerberos)
- Domain join for Azure VMs without on-premises AD
- Legacy apps needing domain services in cloud
### 15.2 Azure Bastion
**WHAT IT IS:**
  Fully managed PaaS service for secure RDP/SSH access to VMs without
  public IP addresses on VMs. Access via Azure portal browser.

WHAT IT IS GOOD FOR (USE CASES):
- Secure VM access without exposing public IPs
- Eliminating need for jump servers/bastions VMs
- Simplified secure access management

**TIERS:**
- Developer: Single VM access, cheapest
- Basic: Shared VM access within same VNet
- Standard: File copy, native client support, shareable links
### 15.3 Azure SignalR Service
**WHAT IT IS:**
  Fully managed service for adding real-time web functionality. Handles
  WebSocket connections at scale. Backend can be Azure Functions or App Service.

WHAT IT IS GOOD FOR (USE CASES):
- Real-time dashboards and monitoring
- Live chat and collaboration features
- Live sports scores and gaming
- Real-time notifications
### 15.4 Azure Static Web Apps
**WHAT IT IS:**
  A service that automatically builds and deploys full-stack web apps
  to Azure from a code repository. Combines static frontend hosting
  with serverless API backend (Functions).

WHAT IT IS GOOD FOR (USE CASES):
- JAMstack applications (React, Vue, Angular, Next.js, Gatsby)
- Documentation sites
- Personal and portfolio websites
- Applications with GitHub/Azure DevOps CI/CD

**KEY FEATURES:**
- Free SSL certificates
- Custom domains
- Globally distributed CDN
- Preview environments per pull request
- Built-in API with Azure Functions
- Authentication (AAD, GitHub, Twitter, Google)
### 15.5 Azure Communication Services
**WHAT IT IS:**
  Cloud-based communications platform. Add voice, video, chat, SMS,
  email, and telephony to your applications. Same infrastructure
  powering Microsoft Teams.

WHAT IT IS GOOD FOR (USE CASES):
- In-app video calling and conferencing
- Chat integration in applications
- SMS notifications
- Email delivery
- PSTN calling capabilities
### 15.6 Azure Notification Hubs
**WHAT IT IS:**
  Scalable push notification engine for sending push notifications to any
  platform (iOS, Android, Windows, Kindle) from any backend.

WHAT IT IS GOOD FOR (USE CASES):
- Cross-platform mobile push notifications
- User segmentation for targeted notifications
- Broadcast notifications to millions of users
### 15.7 Azure Spring Apps
**WHAT IT IS:**
  Fully managed service for deploying Spring Boot and Steeltoe .NET
  microservices. Handles infrastructure, scaling, monitoring.

WHAT IT IS GOOD FOR (USE CASES):
- Java Spring Boot microservices
- Organizations with large Spring Boot investment
- Managed service registry and config server
### 15.8 Azure Confidential Computing
**WHAT IT IS:**
  Protects data in use by performing computation in hardware-based Trusted
  Execution Environments (TEEs). Data remains encrypted even during processing.

WHAT IT IS GOOD FOR (USE CASES):
- Processing sensitive financial or healthcare data
- Multi-party computation where parties don't trust each other
- IP protection for ML models and algorithms
- Regulated industries requiring data isolation

---

## QUICK REFERENCE: CHOOSING THE RIGHT SERVICE

---

**COMPUTE DECISION GUIDE:**
Simple web app, no infra management   → Azure App Service
Complex containerized microservices   → AKS (Azure Kubernetes Service)
Serverless, event-driven code         → Azure Functions
Full VM control needed                → Azure Virtual Machines
Simple container, short-lived task    → Azure Container Instances
Serverless containers, microservices  → Azure Container Apps
Large-scale HPC batch processing      → Azure Batch
**STORAGE DECISION GUIDE:**
Unstructured files/objects            → Azure Blob Storage
Shared file system (SMB/NFS)          → Azure Files
VM disks                              → Azure Disk Storage
Simple message queuing                → Azure Storage Queues
Simple NoSQL key-value                → Azure Table Storage
**DATABASE DECISION GUIDE:**
Relational SQL (cloud-native)         → Azure SQL Database
Relational SQL (lift-and-shift)       → Azure SQL Managed Instance
PostgreSQL workloads                  → Azure DB for PostgreSQL
MySQL workloads                       → Azure DB for MySQL
Global NoSQL, multi-model             → Azure Cosmos DB
In-memory caching                     → Azure Cache for Redis
Enterprise data warehouse             → Azure Synapse Analytics
**MESSAGING DECISION GUIDE:**
Enterprise messaging, ordering        → Azure Service Bus
High-volume event streaming           → Azure Event Hubs
Event routing, serverless             → Azure Event Grid
Simple task queuing                   → Azure Storage Queues
**NETWORKING DECISION GUIDE:**
HTTP/S load balancing + WAF           → Application Gateway
Global load balancing + CDN + WAF     → Azure Front Door
Layer 4 TCP/UDP load balancing        → Azure Load Balancer
DNS-based global routing              → Traffic Manager
VPN to on-premises                    → VPN Gateway
Private dedicated link to Azure       → ExpressRoute
CDN content caching                   → Azure CDN
**ANALYTICS DECISION GUIDE:**
ETL/ELT data pipelines                → Azure Data Factory
Spark-based big data analytics        → Azure Databricks
Enterprise data warehouse             → Azure Synapse Analytics
Real-time event streaming             → Azure Stream Analytics
Unified analytics platform            → Microsoft Fabric
IoT telemetry ingestion               → Azure Event Hubs + Stream Analytics
**SECURITY DECISION GUIDE:**
Identity and SSO                      → Microsoft Entra ID
Secrets and keys management           → Azure Key Vault
Cloud security posture                → Defender for Cloud
SIEM and SOAR                         → Microsoft Sentinel
Network firewall                      → Azure Firewall
WAF for web apps                      → Application Gateway or Front Door

---

## AZURE WELL-ARCHITECTED FRAMEWORK PILLARS

---

The Azure Well-Architected Framework provides guidance for designing robust
cloud solutions. The five pillars are:

1. RELIABILITY
- Use Availability Zones for zone-redundant deployments
- Implement retry logic and circuit breakers
- Design for failure; everything will fail eventually
- Use health probes and auto-healing
- Geo-redundant deployments for disaster recovery
- Regular backup testing

2. SECURITY
- Zero trust: "Never trust, always verify"
- Defense in depth: Multiple security layers
- Least privilege access
- Encrypt data at rest and in transit
- Regularly rotate credentials and certificates
- Enable MFA everywhere
- Keep services patched and updated

3. COST OPTIMIZATION
- Right-size resources for actual usage
- Use Reserved Instances for predictable workloads
- Leverage Spot VMs for interruptible workloads
- Set up budgets and cost alerts
- Delete unused resources and development environments
- Use auto-scaling to pay for what you use
- Archive cold data to cheaper storage tiers

4. OPERATIONAL EXCELLENCE
- Infrastructure as Code (Bicep, Terraform)
- CI/CD pipelines for all deployments
- Comprehensive monitoring and alerting
- Runbooks and playbooks for operations
- Regular chaos engineering and disaster recovery drills
- Feature flags for safe deployments

5. PERFORMANCE EFFICIENCY
- Choose correct service tier for workload
- Use CDN for content delivery
- Cache frequently accessed data
- Async processing and queuing
- Database indexing and query optimization
- Right region for users (proximity)
- Use Azure Advisor performance recommendations

---

## AZURE REGIONS AND GEOGRAPHY

---

Azure operates in 60+ regions worldwide, organized into geographies.
Key concepts:

Region: Physical location with one or more datacenters
Geography: Area containing multiple regions (e.g., "US", "Europe")
Availability Zone: Physically separate datacenters within a region
Region Pair: Each region paired with another for disaster recovery

**RECOMMENDED REGION SELECTION CRITERIA:**
- Proximity to users (latency)
- Data residency/sovereignty requirements
- Service availability (not all services in all regions)
- Compliance requirements
- Price (varies by region)
- Region pairs for disaster recovery

**MAJOR REGION PAIRS:**
East US       <-> West US
North Europe  <-> West Europe
Southeast Asia <-> East Asia
Brazil South  <-> South Central US

---

## AZURE PRICING AND COST MANAGEMENT TIPS

---

Key strategies for managing Azure costs:

1. RESERVED INSTANCES
- 1-year or 3-year commitment
- Up to 72% savings over pay-as-you-go
- Available for VMs, SQL, Cosmos DB, etc.
- Can be exchanged or refunded (with restrictions)

2. AZURE HYBRID BENEFIT
- Use existing Windows Server/SQL Server licenses with SA
- Additional savings on top of Reserved Instances
- Also available for Red Hat and SUSE Linux

3. SPOT VMs / SPOT INSTANCES
- Up to 90% discount on unused capacity
- Can be evicted with 30-second notice
- Good for: batch jobs, dev/test, stateless workloads

4. DEV/TEST PRICING
- Discounted rates for Visual Studio subscribers
- Not for production use

5. FREE TIER SERVICES
- Many services have free tiers:
     * Azure Functions: 1M free executions/month
     * Azure Cosmos DB: 400 RU/s and 5GB free
     * Azure App Service: F1 tier (60 CPU min/day)
     * Azure Blob Storage: 5GB free (12 months)

6. COST OPTIMIZATION TOOLS
- Azure Cost Management: Analyze spending
- Azure Advisor: Cost recommendations
- Azure Calculator: Estimate costs before deploying
- Azure Price Sheet: Full price list
- Total Cost of Ownership (TCO) Calculator: Compare on-prem vs Azure

---

## AZURE COMPLIANCE AND CERTIFICATIONS

---

Azure is certified for a wide range of compliance standards:

**GLOBAL:**
- ISO 27001, 27017, 27018, 27701
- SOC 1, 2, 3
- CSA STAR

**US GOVERNMENT:**
- FedRAMP High (Azure Government)
- DoD IL2, IL4, IL5
- ITAR
- CJIS

**INDUSTRY:**
- HIPAA/HITECH (Healthcare)
- PCI DSS Level 1 (Payment)
- FERPA (Education)
- SEC/FINRA (Financial)
- FDA 21 CFR Part 11

**REGIONAL:**
- GDPR (Europe)
- UK G-Cloud / Cyber Essentials Plus
- Germany C5
- Australia IRAP
- Singapore MTCS

---

## END OF GUIDE

---

This guide covers the major Azure services as of 2024-2025.
For the most current information, visit:
  https://azure.microsoft.com/en-us/products/
  https://learn.microsoft.com/en-us/azure/
  https://azure.microsoft.com/en-us/pricing/
=============================================================================