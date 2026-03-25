# Multi-Vendor E-Commerce Platform - Complete System Specification

**System Name**: MarketHub  
**Architecture**: Modular Monolith with Clean Architecture per Module  
**Patterns**: CQRS, Event-Driven, Domain-Driven Design (DDD), Repository Pattern, Result Pattern  
**Database**: PostgreSQL with Schema-per-Module  
**Language**: C# 12 / .NET 8  
**Primary Framework**: ASP.NET Core 8.0

---

## Table of Contents

1. [System Overview](#1-system-overview)
2. [Architecture Principles](#2-architecture-principles)
3. [Solution Structure](#3-solution-structure)
4. [Building Blocks (Shared Kernel)](#4-building-blocks-shared-kernel)
5. [Module Specifications](#5-module-specifications)
6. [Cross-Module Communication](#6-cross-module-communication)
7. [Database Strategy](#7-database-strategy)
8. [Testing Strategy](#8-testing-strategy)
9. [Error Handling & Result Pattern](#9-error-handling--result-pattern)
10. [Logging & Observability](#10-logging--observability)
11. [Security & Authentication](#11-security--authentication)
12. [Code Standards & Conventions](#12-code-standards--conventions)
13. [Development Workflow](#13-development-workflow)

---

## 1. System Overview

### 1.1 Business Domain
MarketHub is a multi-vendor e-commerce marketplace similar to Amazon or Trendyol, where:
- **Vendors** can register, create stores, and sell products
- **Customers** can browse products, place orders, make payments, and leave reviews
- **Admins** manage platform operations, approve vendors, and monitor analytics
- **Platform** takes a commission on each sale

### 1.2 Core Capabilities
- User registration and authentication (Customers, Vendors, Admins)
- Vendor onboarding with approval workflow
- Product catalog management with categories, variants, and images
- Real-time inventory tracking with stock reservations
- Shopping cart and order management
- Payment processing with vendor payouts
- Product reviews and ratings (verified purchases only)
- Email/SMS notifications
- Vendor and platform analytics dashboards

### 1.3 MVP Scope
**Phase 1 (Initial Launch)**:
- Identity & Access Management (IAM)
- Vendors Module
- Catalog Module
- Inventory Module
- Cart Module (basic, can use in-memory/Redis initially)
- Ordering Module
- Payment Module (Stripe integration)
- Notifications Module (Email only initially)

**Phase 2 (Post-Launch)**:
- Reviews Module
- Analytics Module
- Advanced search and filtering
- Promotions/discounts
- Shipping integration

---

## 2. Architecture Principles

### 2.1 Modular Monolith Philosophy
**Definition**: A single deployable unit (one ASP.NET Core application) divided into independent modules. Each module:
- Has clear boundaries
- Owns its data (separate database schema)
- Exposes a public contract (interfaces, DTOs, events)
- Communicates with other modules ONLY through contracts (never direct database access)
- Can be extracted into a microservice later with minimal code changes

**Why Modular Monolith?**:
- Simpler deployment than microservices
- Easier local development
- Lower operational complexity initially
- Maintains modularity benefits
- Clear migration path to microservices when needed

### 2.2 Clean Architecture per Module
Each module follows Clean Architecture with these layers:

```
Module.Domain       (innermost - no dependencies)
  ↓
Module.Application  (depends on Domain)
  ↓
Module.Infrastructure (depends on Domain & Application)
  ↓
Module.Api          (depends on Application, registers Infrastructure)
```

**Dependency Rule**: Dependencies flow INWARD only. Domain never depends on Application/Infrastructure/Api.

### 2.3 CQRS (Command Query Responsibility Segregation)
**Commands** (write operations):
- Mutate state
- Return Result<T> (success/failure)
- Go through domain logic validation
- Publish domain events
- Examples: CreateProductCommand, PlaceOrderCommand

**Queries** (read operations):
- Read-only
- Can bypass domain (query database directly for performance)
- Return DTOs
- Examples: GetProductsQuery, GetOrderByIdQuery

**Implementation**: MediatR library for command/query handling with pipeline behaviors.

### 2.4 Event-Driven Communication
**Domain Events** (internal to module):
- Published by domain entities
- Handled within the same module
- Examples: OrderCreatedDomainEvent, ProductPublishedDomainEvent

**Integration Events** (cross-module):
- Published by Application layer after SaveChanges succeeds
- Consumed by other modules
- Delivered via Event Bus (RabbitMQ)
- Examples: UserRegisteredIntegrationEvent, OrderPlacedIntegrationEvent

### 2.5 Result Pattern (No Exceptions for Business Logic)
- Domain methods return `Result<T>` or `Result`
- Exceptions reserved for infrastructure failures only
- Each module defines its own error codes
- Error aggregation bubbles up through layers

---

## 3. Solution Structure

### 3.1 File System Layout

```
MarketHub.sln
│
├── src/
│   │
│   ├── API/
│   │   └── MarketHub.API/                           (ASP.NET Core Web API - STARTUP PROJECT)
│   │       ├── Program.cs                           (Module registration, middleware)
│   │       ├── appsettings.json                     (Configuration)
│   │       ├── appsettings.Development.json
│   │       └── MarketHub.API.csproj
│   │
│   ├── Host/
│   │   └── MarketHub.AppHost/                       (.NET Aspire - Optional orchestration)
│   │       ├── Program.cs
│   │       └── MarketHub.AppHost.csproj
│   │
│   ├── Modules/
│   │   │
│   │   ├── IAM/                                     (Identity & Access Management)
│   │   │   ├── MarketHub.Modules.IAM.Domain/
│   │   │   │   ├── Entities/
│   │   │   │   ├── ValueObjects/
│   │   │   │   ├── DomainEvents/
│   │   │   │   ├── Repositories/                    (Interfaces only)
│   │   │   │   ├── Errors/
│   │   │   │   └── MarketHub.Modules.IAM.Domain.csproj
│   │   │   │
│   │   │   ├── MarketHub.Modules.IAM.Application/
│   │   │   │   ├── Commands/
│   │   │   │   ├── Queries/
│   │   │   │   ├── DTOs/
│   │   │   │   ├── Behaviors/                       (MediatR pipeline behaviors)
│   │   │   │   ├── Validators/                      (FluentValidation)
│   │   │   │   ├── DomainEventHandlers/
│   │   │   │   ├── IntegrationEventHandlers/
│   │   │   │   ├── DependencyInjection.cs
│   │   │   │   └── MarketHub.Modules.IAM.Application.csproj
│   │   │   │
│   │   │   ├── MarketHub.Modules.IAM.Infrastructure/
│   │   │   │   ├── Persistence/
│   │   │   │   │   ├── IAMDbContext.cs
│   │   │   │   │   ├── Configurations/              (EF Core entity configs)
│   │   │   │   │   ├── Migrations/
│   │   │   │   │   └── Repositories/                (Repository implementations)
│   │   │   │   ├── Authentication/
│   │   │   │   │   ├── JwtTokenGenerator.cs
│   │   │   │   │   └── PasswordHasher.cs
│   │   │   │   ├── Email/
│   │   │   │   │   └── EmailService.cs
│   │   │   │   ├── DependencyInjection.cs
│   │   │   │   └── MarketHub.Modules.IAM.Infrastructure.csproj
│   │   │   │
│   │   │   └── MarketHub.Modules.IAM.Api/
│   │   │       ├── Controllers/
│   │   │       │   └── IdentityController.cs
│   │   │       ├── Requests/                        (HTTP request DTOs)
│   │   │       ├── Responses/                       (HTTP response DTOs)
│   │   │       ├── IAMModuleExtensions.cs           (DI registration)
│   │   │       ├── AssemblyReference.cs             (For controller discovery)
│   │   │       └── MarketHub.Modules.IAM.Api.csproj
│   │   │
│   │   ├── Catalog/
│   │   │   ├── MarketHub.Modules.Catalog.Domain/
│   │   │   ├── MarketHub.Modules.Catalog.Application/
│   │   │   ├── MarketHub.Modules.Catalog.Infrastructure/
│   │   │   └── MarketHub.Modules.Catalog.Api/
│   │   │
│   │   ├── Inventory/
│   │   │   ├── MarketHub.Modules.Inventory.Domain/
│   │   │   ├── MarketHub.Modules.Inventory.Application/
│   │   │   ├── MarketHub.Modules.Inventory.Infrastructure/
│   │   │   └── MarketHub.Modules.Inventory.Api/
│   │   │
│   │   ├── Ordering/
│   │   │   ├── MarketHub.Modules.Ordering.Domain/
│   │   │   ├── MarketHub.Modules.Ordering.Application/
│   │   │   ├── MarketHub.Modules.Ordering.Infrastructure/
│   │   │   └── MarketHub.Modules.Ordering.Api/
│   │   │
│   │   ├── Payment/
│   │   │   ├── MarketHub.Modules.Payment.Domain/
│   │   │   ├── MarketHub.Modules.Payment.Application/
│   │   │   ├── MarketHub.Modules.Payment.Infrastructure/
│   │   │   └── MarketHub.Modules.Payment.Api/
│   │   │
│   │   ├── Vendors/
│   │   │   ├── MarketHub.Modules.Vendors.Domain/
│   │   │   ├── MarketHub.Modules.Vendors.Application/
│   │   │   ├── MarketHub.Modules.Vendors.Infrastructure/
│   │   │   └── MarketHub.Modules.Vendors.Api/
│   │   │
│   │   ├── Notifications/
│   │   │   ├── MarketHub.Modules.Notifications.Domain/
│   │   │   ├── MarketHub.Modules.Notifications.Application/
│   │   │   ├── MarketHub.Modules.Notifications.Infrastructure/
│   │   │   └── MarketHub.Modules.Notifications.Api/
│   │   │
│   │   ├── Reviews/                                 (Phase 2)
│   │   │   ├── MarketHub.Modules.Reviews.Domain/
│   │   │   ├── MarketHub.Modules.Reviews.Application/
│   │   │   ├── MarketHub.Modules.Reviews.Infrastructure/
│   │   │   └── MarketHub.Modules.Reviews.Api/
│   │   │
│   │   └── Analytics/                               (Phase 2)
│   │       ├── MarketHub.Modules.Analytics.Domain/
│   │       ├── MarketHub.Modules.Analytics.Application/
│   │       ├── MarketHub.Modules.Analytics.Infrastructure/
│   │       └── MarketHub.Modules.Analytics.Api/
│   │
│   └── BuildingBlocks/
│       │
│       ├── MarketHub.BuildingBlocks.Domain/
│       │   ├── AggregateRoot.cs
│       │   ├── Entity.cs
│       │   ├── ValueObject.cs
│       │   ├── IDomainEvent.cs
│       │   ├── DomainException.cs
│       │   ├── Result.cs
│       │   ├── Error.cs
│       │   ├── ISoftDelete.cs
│       │   ├── IAuditableEntity.cs
│       │   └── MarketHub.BuildingBlocks.Domain.csproj
│       │
│       ├── MarketHub.BuildingBlocks.Abstractions/
│       │   ├── Messaging/
│       │   │   ├── IIntegrationEvent.cs
│       │   │   ├── IEventBus.cs
│       │   │   └── IIntegrationEventHandler.cs
│       │   ├── Caching/
│       │   │   └── ICacheService.cs
│       │   ├── Pagination/
│       │   │   ├── PagedResult.cs
│       │   │   └── ISpecification.cs
│       │   ├── Time/
│       │   │   └── IDateTimeProvider.cs
│       │   └── MarketHub.BuildingBlocks.Abstractions.csproj
│       │
│       ├── MarketHub.BuildingBlocks.Infrastructure/
│       │   ├── Persistence/
│       │   │   ├── BaseDbContext.cs
│       │   │   ├── DatabaseOptions.cs
│       │   │   ├── DbContextExtensions.cs
│       │   │   └── UnitOfWork.cs
│       │   ├── EventBus/
│       │   │   └── (placeholder - implemented in EventBus.RabbitMQ)
│       │   ├── Outbox/
│       │   │   ├── OutboxMessage.cs
│       │   │   ├── OutboxMessageConfiguration.cs
│       │   │   └── ProcessOutboxMessagesJob.cs
│       │   ├── Time/
│       │   │   └── DateTimeProvider.cs
│       │   └── MarketHub.BuildingBlocks.Infrastructure.csproj
│       │
│       ├── MarketHub.BuildingBlocks.EventBus/
│       │   ├── IntegrationEvent.cs                  (Base class)
│       │   └── MarketHub.BuildingBlocks.EventBus.csproj
│       │
│       ├── MarketHub.BuildingBlocks.EventBus.RabbitMQ/
│       │   ├── RabbitMQEventBus.cs
│       │   ├── RabbitMQOptions.cs
│       │   ├── RabbitMQExtensions.cs
│       │   └── MarketHub.BuildingBlocks.EventBus.RabbitMQ.csproj
│       │
│       ├── MarketHub.BuildingBlocks.Caching/
│       │   ├── RedisCacheService.cs
│       │   ├── InMemoryCacheService.cs
│       │   ├── CachingExtensions.cs
│       │   └── MarketHub.BuildingBlocks.Caching.csproj
│       │
│       ├── MarketHub.BuildingBlocks.Security/
│       │   ├── JwtOptions.cs
│       │   ├── JwtExtensions.cs
│       │   ├── PasswordHasher.cs
│       │   └── MarketHub.BuildingBlocks.Security.csproj
│       │
│       └── MarketHub.BuildingBlocks.Logging/
│           ├── SerilogExtensions.cs
│           └── MarketHub.BuildingBlocks.Logging.csproj
│
└── tests/
    ├── UnitTests/
    │   ├── MarketHub.Modules.IAM.Domain.UnitTests/
    │   ├── MarketHub.Modules.Catalog.Domain.UnitTests/
    │   ├── MarketHub.Modules.Ordering.Domain.UnitTests/
    │   └── ... (one per module)
    │
    ├── IntegrationTests/
    │   ├── MarketHub.Modules.IAM.IntegrationTests/
    │   ├── MarketHub.Modules.Catalog.IntegrationTests/
    │   └── ... (one per module, tests contracts between modules)
    │
    └── EndToEndTests/
        └── MarketHub.API.E2ETests/                  (Full workflow tests)
```

---

## 4. Building Blocks (Shared Kernel)

### 4.1 BuildingBlocks.Domain

**Purpose**: Base classes and interfaces for domain modeling that ALL modules inherit from.

#### 4.1.1 Entity.cs (Base Entity Class)
**Contents**:
- `Guid Id` property
- Equality comparison based on Id
- Should be generic: `Entity<TId>` where TId can be `Guid`, `int`, etc.

**Usage**: All entities inherit from this.

#### 4.1.2 AggregateRoot.cs (Base Aggregate Root)
**Inherits from**: Entity

**Additional Responsibilities**:
- `List<IDomainEvent> _domainEvents` (private field)
- `IReadOnlyList<IDomainEvent> DomainEvents` (public property)
- `void AddDomainEvent(IDomainEvent domainEvent)` (protected method)
- `void ClearDomainEvents()` (public method)

**When to Use**: Use AggregateRoot for entities that are the root of an aggregate boundary (e.g., Order, Product, User).

#### 4.1.3 ValueObject.cs (Base Value Object)
**Purpose**: Immutable objects compared by value equality, not identity.

**Contents**:
- Abstract method `GetEqualityComponents()` that returns `IEnumerable<object>`
- Override `Equals()`, `GetHashCode()`, `==`, `!=` based on equality components

**Examples**: Money, Address, Email, PhoneNumber

#### 4.1.4 IDomainEvent.cs (Domain Event Interface)
```csharp
public interface IDomainEvent
{
    Guid EventId { get; }
    DateTime OccurredOn { get; }
}
```

**Implementation Pattern**:
```csharp
public record OrderCreatedDomainEvent(Guid OrderId) : IDomainEvent
{
    public Guid EventId { get; init; } = Guid.NewGuid();
    public DateTime OccurredOn { get; init; } = DateTime.UtcNow;
}
```

#### 4.1.5 Result Pattern Classes

**Result.cs (Non-generic for void operations)**:
```csharp
public class Result
{
    public bool IsSuccess { get; }
    public bool IsFailure => !IsSuccess;
    public Error Error { get; }
    
    protected Result(bool isSuccess, Error error)
    {
        IsSuccess = isSuccess;
        Error = error;
    }
    
    public static Result Success() => new(true, Error.None);
    public static Result Failure(Error error) => new(false, error);
}
```

**Result<TValue>.cs (Generic for operations returning value)**:
```csharp
public class Result<TValue> : Result
{
    public TValue? Value { get; }
    
    private Result(TValue? value, bool isSuccess, Error error)
        : base(isSuccess, error)
    {
        Value = value;
    }
    
    public static Result<TValue> Success(TValue value) 
        => new(value, true, Error.None);
    
    public static Result<TValue> Failure(Error error) 
        => new(default, false, error);
}
```

#### 4.1.6 Error.cs (Error Descriptor)
```csharp
public sealed record Error(string Code, string Message, ErrorType Type)
{
    public static readonly Error None = new(string.Empty, string.Empty, ErrorType.None);
    
    public static Error Validation(string code, string message) 
        => new(code, message, ErrorType.Validation);
    
    public static Error NotFound(string code, string message) 
        => new(code, message, ErrorType.NotFound);
    
    public static Error Conflict(string code, string message) 
        => new(code, message, ErrorType.Conflict);
    
    public static Error Failure(string code, string message) 
        => new(code, message, ErrorType.Failure);
}

public enum ErrorType
{
    None,
    Validation,
    NotFound,
    Conflict,
    Failure,
    Unauthorized,
    Forbidden
}
```

**Module-Specific Error Classes**: Each module defines its own static error class.

**Example** (IAM Module):
```csharp
// In IAM.Domain/Errors/IAMErrors.cs
public static class IAMErrors
{
    public static class User
    {
        public static Error EmailAlreadyExists(string email) 
            => Error.Conflict(
                "User.EmailAlreadyExists", 
                $"User with email '{email}' already exists");
        
        public static Error InvalidCredentials() 
            => Error.Validation(
                "User.InvalidCredentials", 
                "The provided credentials are invalid");
        
        public static Error NotFound(Guid userId) 
            => Error.NotFound(
                "User.NotFound", 
                $"User with ID '{userId}' was not found");
    }
    
    public static class RefreshToken
    {
        public static Error Expired() 
            => Error.Validation(
                "RefreshToken.Expired", 
                "The refresh token has expired");
        
        public static Error Invalid() 
            => Error.Validation(
                "RefreshToken.Invalid", 
                "The refresh token is invalid");
    }
}
```

#### 4.1.7 DomainException.cs
**Purpose**: For exceptional domain violations that should halt execution (rare).

```csharp
public class DomainException : Exception
{
    public DomainException(string message) : base(message) { }
    public DomainException(string message, Exception innerException) 
        : base(message, innerException) { }
}
```

**When to Use**: Use Result<T> for expected failures (validation, not found). Use DomainException for programmer errors or invariant violations.

#### 4.1.8 ISoftDelete.cs (Soft Delete Marker)
```csharp
public interface ISoftDelete
{
    bool IsDeleted { get; }
    DateTime? DeletedAt { get; }
    void Delete();
    void Restore();
}
```

**Implementation** (in Entity):
```csharp
public abstract class Entity : ISoftDelete
{
    public bool IsDeleted { get; private set; }
    public DateTime? DeletedAt { get; private set; }
    
    public void Delete()
    {
        IsDeleted = true;
        DeletedAt = DateTime.UtcNow;
    }
    
    public void Restore()
    {
        IsDeleted = false;
        DeletedAt = null;
    }
}
```

**Global Query Filter** (applied in BaseDbContext):
```csharp
modelBuilder.Entity<EntityType>().HasQueryFilter(e => !e.IsDeleted);
```

#### 4.1.9 IAuditableEntity.cs
```csharp
public interface IAuditableEntity
{
    DateTime CreatedAt { get; }
    string? CreatedBy { get; }
    DateTime? UpdatedAt { get; }
    string? UpdatedBy { get; }
}
```

**Implementation** (in Entity or AggregateRoot):
```csharp
public abstract class AggregateRoot : Entity, IAuditableEntity
{
    public DateTime CreatedAt { get; private set; }
    public string? CreatedBy { get; private set; }
    public DateTime? UpdatedAt { get; private set; }
    public string? UpdatedBy { get; private set; }
    
    protected void SetAuditInfo(string userId)
    {
        if (CreatedAt == default)
        {
            CreatedAt = DateTime.UtcNow;
            CreatedBy = userId;
        }
        else
        {
            UpdatedAt = DateTime.UtcNow;
            UpdatedBy = userId;
        }
    }
}
```

---

### 4.2 BuildingBlocks.Abstractions

**Purpose**: Contracts (interfaces) for infrastructure concerns. NO implementations here.

#### 4.2.1 IIntegrationEvent.cs
```csharp
public interface IIntegrationEvent
{
    Guid EventId { get; }
    DateTime OccurredOn { get; }
}
```

**Base Implementation** (in BuildingBlocks.EventBus):
```csharp
public abstract record IntegrationEvent : IIntegrationEvent
{
    public Guid EventId { get; init; } = Guid.NewGuid();
    public DateTime OccurredOn { get; init; } = DateTime.UtcNow;
}
```

**Module-Specific Events Inherit**:
```csharp
public record UserRegisteredIntegrationEvent(
    Guid UserId, 
    string Email) : IntegrationEvent;
```

#### 4.2.2 IEventBus.cs
```csharp
public interface IEventBus
{
    Task PublishAsync<TEvent>(TEvent @event, CancellationToken ct = default)
        where TEvent : IIntegrationEvent;
    
    void Subscribe<TEvent, THandler>()
        where TEvent : IIntegrationEvent
        where THandler : IIntegrationEventHandler<TEvent>;
}
```

#### 4.2.3 IIntegrationEventHandler.cs
```csharp
public interface IIntegrationEventHandler<in TEvent>
    where TEvent : IIntegrationEvent
{
    Task Handle(TEvent @event, CancellationToken ct = default);
}
```

#### 4.2.4 ICacheService.cs
```csharp
public interface ICacheService
{
    Task<T?> GetAsync<T>(string key, CancellationToken ct = default);
    
    Task SetAsync<T>(
        string key, 
        T value, 
        TimeSpan? expiration = null, 
        CancellationToken ct = default);
    
    Task RemoveAsync(string key, CancellationToken ct = default);
    
    Task RemoveByPrefixAsync(string prefix, CancellationToken ct = default);
}
```

#### 4.2.5 IDateTimeProvider.cs
```csharp
public interface IDateTimeProvider
{
    DateTime UtcNow { get; }
    DateTime Now { get; }
}
```

**Why?**: Testability. Tests can inject a fake time provider.

#### 4.2.6 PagedResult.cs
```csharp
public class PagedResult<T>
{
    public IReadOnlyList<T> Items { get; }
    public int TotalCount { get; }
    public int Page { get; }
    public int PageSize { get; }
    public int TotalPages => (int)Math.Ceiling(TotalCount / (double)PageSize);
    public bool HasPrevious => Page > 1;
    public bool HasNext => Page < TotalPages;
    
    public PagedResult(
        IReadOnlyList<T> items, 
        int totalCount, 
        int page, 
        int pageSize)
    {
        Items = items;
        TotalCount = totalCount;
        Page = page;
        PageSize = pageSize;
    }
}
```

#### 4.2.7 ISpecification.cs (Specification Pattern for Queries)
```csharp
public interface ISpecification<T>
{
    IQueryable<T> Apply(IQueryable<T> query);
}
```

**Example Implementation**:
```csharp
public class ProductFilterSpecification : ISpecification<Product>
{
    private readonly string? _searchTerm;
    private readonly Guid? _categoryId;
    private readonly Guid? _vendorId;
    
    public ProductFilterSpecification(
        string? searchTerm, 
        Guid? categoryId, 
        Guid? vendorId)
    {
        _searchTerm = searchTerm;
        _categoryId = categoryId;
        _vendorId = vendorId;
    }
    
    public IQueryable<Product> Apply(IQueryable<Product> query)
    {
        if (!string.IsNullOrWhiteSpace(_searchTerm))
            query = query.Where(p => p.Name.Contains(_searchTerm));
        
        if (_categoryId.HasValue)
            query = query.Where(p => p.CategoryId == _categoryId.Value);
        
        if (_vendorId.HasValue)
            query = query.Where(p => p.VendorId == _vendorId.Value);
        
        return query;
    }
}
```

---

### 4.3 BuildingBlocks.Infrastructure

#### 4.3.1 BaseDbContext.cs

**Purpose**: Base class for all module DbContexts. Handles:
- Domain event dispatching
- Soft delete query filter
- Audit field population
- SaveChanges with event publishing

**Key Responsibilities**:
1. Override SaveChangesAsync to:
   - Collect domain events from aggregate roots
   - Save changes to database
   - Publish domain events via MediatR
   - Write integration events to outbox table
   - Clear domain events from entities

2. Apply global configurations:
   - Soft delete query filter
   - Audit field defaults

**Structure**:
```csharp
public abstract class BaseDbContext : DbContext
{
    private readonly IMediator? _mediator;
    private readonly IDateTimeProvider? _dateTimeProvider;
    
    protected BaseDbContext(DbContextOptions options) 
        : base(options) { }
    
    protected BaseDbContext(
        DbContextOptions options, 
        IMediator mediator,
        IDateTimeProvider dateTimeProvider) 
        : base(options)
    {
        _mediator = mediator;
        _dateTimeProvider = dateTimeProvider;
    }
    
    public override async Task<int> SaveChangesAsync(
        CancellationToken cancellationToken = default)
    {
        // 1. Set audit fields
        SetAuditFields();
        
        // 2. Collect domain events
        var domainEvents = GetDomainEvents();
        
        // 3. Save to database
        var result = await base.SaveChangesAsync(cancellationToken);
        
        // 4. Publish domain events (in-process, same transaction)
        await PublishDomainEventsAsync(domainEvents, cancellationToken);
        
        // 5. Clear domain events
        ClearDomainEvents();
        
        return result;
    }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        ApplySoftDeleteFilter(modelBuilder);
        ConfigureAuditFields(modelBuilder);
        base.OnModelCreating(modelBuilder);
    }
    
    private void SetAuditFields()
    {
        var entries = ChangeTracker.Entries<IAuditableEntity>();
        
        foreach (var entry in entries)
        {
            if (entry.State == EntityState.Added)
            {
                entry.Entity.CreatedAt = _dateTimeProvider?.UtcNow ?? DateTime.UtcNow;
                // CreatedBy set from HttpContext in infrastructure
            }
            else if (entry.State == EntityState.Modified)
            {
                entry.Entity.UpdatedAt = _dateTimeProvider?.UtcNow ?? DateTime.UtcNow;
                // UpdatedBy set from HttpContext in infrastructure
            }
        }
    }
    
    private List<IDomainEvent> GetDomainEvents()
    {
        return ChangeTracker
            .Entries<AggregateRoot>()
            .Select(e => e.Entity)
            .Where(e => e.DomainEvents.Any())
            .SelectMany(e => e.DomainEvents)
            .ToList();
    }
    
    private async Task PublishDomainEventsAsync(
        List<IDomainEvent> domainEvents, 
        CancellationToken ct)
    {
        if (_mediator == null) return;
        
        foreach (var domainEvent in domainEvents)
        {
            await _mediator.Publish(domainEvent, ct);
        }
    }
    
    private void ClearDomainEvents()
    {
        ChangeTracker
            .Entries<AggregateRoot>()
            .Select(e => e.Entity)
            .ToList()
            .ForEach(e => e.ClearDomainEvents());
    }
    
    private void ApplySoftDeleteFilter(ModelBuilder modelBuilder)
    {
        foreach (var entityType in modelBuilder.Model.GetEntityTypes())
        {
            if (typeof(ISoftDelete).IsAssignableFrom(entityType.ClrType))
            {
                var parameter = Expression.Parameter(entityType.ClrType, "e");
                var property = Expression.Property(parameter, nameof(ISoftDelete.IsDeleted));
                var filter = Expression.Lambda(
                    Expression.Equal(property, Expression.Constant(false)),
                    parameter);
                
                modelBuilder.Entity(entityType.ClrType).HasQueryFilter(filter);
            }
        }
    }
    
    private void ConfigureAuditFields(ModelBuilder modelBuilder)
    {
        foreach (var entityType in modelBuilder.Model.GetEntityTypes())
        {
            if (typeof(IAuditableEntity).IsAssignableFrom(entityType.ClrType))
            {
                modelBuilder.Entity(entityType.ClrType)
                    .Property<DateTime>("CreatedAt")
                    .HasDefaultValueSql("CURRENT_TIMESTAMP");
            }
        }
    }
}
```

#### 4.3.2 DatabaseOptions.cs
```csharp
public class DatabaseOptions
{
    public const string SectionName = "DatabaseOptions";
    
    public string ConnectionString { get; init; } = string.Empty;
    public int MaxRetryCount { get; init; } = 3;
    public int CommandTimeout { get; init; } = 30;
    public bool EnableSensitiveDataLogging { get; init; } = false;
    public bool EnableDetailedErrors { get; init; } = false;
}
```

#### 4.3.3 DbContextExtensions.cs
```csharp
public static class DbContextExtensions
{
    public static DbContextOptionsBuilder ConfigurePostgreSQL(
        this DbContextOptionsBuilder optionsBuilder,
        string connectionString,
        string schemaName,
        string migrationsAssembly,
        DatabaseOptions? options = null)
    {
        options ??= new DatabaseOptions();
        
        optionsBuilder.UseNpgsql(
            connectionString,
            npgsqlOptions =>
            {
                npgsqlOptions.MigrationsAssembly(migrationsAssembly);
                npgsqlOptions.MigrationsHistoryTable(
                    "__EFMigrationsHistory", 
                    schemaName);
                npgsqlOptions.EnableRetryOnFailure(
                    maxRetryCount: options.MaxRetryCount);
                npgsqlOptions.CommandTimeout(options.CommandTimeout);
            });
        
        if (options.EnableSensitiveDataLogging)
            optionsBuilder.EnableSensitiveDataLogging();
        
        if (options.EnableDetailedErrors)
            optionsBuilder.EnableDetailedErrors();
        
        return optionsBuilder;
    }
}
```

#### 4.3.4 Outbox Pattern Implementation

**Why Outbox Pattern?**: Ensures integration events are published reliably. If the database transaction succeeds but event bus fails, the event is still stored in the outbox table and will be retried.

**OutboxMessage.cs**:
```csharp
public sealed class OutboxMessage
{
    public Guid Id { get; init; }
    public string Type { get; init; } = string.Empty;
    public string Content { get; init; } = string.Empty;
    public DateTime OccurredOnUtc { get; init; }
    public DateTime? ProcessedOnUtc { get; private set; }
    public string? Error { get; private set; }
    
    public void MarkAsProcessed()
    {
        ProcessedOnUtc = DateTime.UtcNow;
    }
    
    public void MarkAsFailed(string error)
    {
        Error = error;
    }
}
```

**Each Module's DbContext Includes**:
```csharp
public DbSet<OutboxMessage> OutboxMessages { get; set; }
```

**When Publishing Integration Event** (in Application Layer):
```csharp
// Don't publish directly - write to outbox
var outboxMessage = new OutboxMessage
{
    Id = Guid.NewGuid(),
    Type = typeof(UserRegisteredIntegrationEvent).AssemblyQualifiedName!,
    Content = JsonSerializer.Serialize(integrationEvent),
    OccurredOnUtc = DateTime.UtcNow
};

_context.OutboxMessages.Add(outboxMessage);
await _context.SaveChangesAsync(); // Atomic with domain changes
```

**Background Job Processes Outbox**:
```csharp
// ProcessOutboxMessagesJob.cs (runs every 10 seconds)
public class ProcessOutboxMessagesJob
{
    private readonly IEventBus _eventBus;
    private readonly DbContext _dbContext;
    
    public async Task Execute()
    {
        var messages = await _dbContext.OutboxMessages
            .Where(m => m.ProcessedOnUtc == null)
            .OrderBy(m => m.OccurredOnUtc)
            .Take(20)
            .ToListAsync();
        
        foreach (var message in messages)
        {
            try
            {
                var eventType = Type.GetType(message.Type);
                var @event = JsonSerializer.Deserialize(message.Content, eventType);
                
                await _eventBus.PublishAsync(@event);
                message.MarkAsProcessed();
            }
            catch (Exception ex)
            {
                message.MarkAsFailed(ex.Message);
            }
        }
        
        await _dbContext.SaveChangesAsync();
    }
}
```

---

### 4.4 BuildingBlocks.EventBus.RabbitMQ

**RabbitMQEventBus.cs Implementation**:

**Responsibilities**:
- Publish integration events to RabbitMQ exchange
- Subscribe handlers to specific event types
- Deserialize incoming messages and dispatch to handlers

**Key Design**:
- Exchange: `markethub_events` (topic exchange)
- Routing Key: Event type name (e.g., `UserRegisteredIntegrationEvent`)
- Queue per module: `markethub_iam_queue`, `markethub_catalog_queue`, etc.
- Each module's queue binds to events it cares about

**Structure**:
```csharp
public class RabbitMQEventBus : IEventBus, IDisposable
{
    private readonly IConnection _connection;
    private readonly IModel _channel;
    private readonly IServiceProvider _serviceProvider;
    private readonly Dictionary<string, Type> _eventTypes = new();
    private readonly Dictionary<string, List<Type>> _handlers = new();
    
    public RabbitMQEventBus(
        IConnection connection,
        IServiceProvider serviceProvider)
    {
        _connection = connection;
        _channel = connection.CreateModel();
        _serviceProvider = serviceProvider;
        
        // Declare exchange
        _channel.ExchangeDeclare(
            exchange: "markethub_events",
            type: ExchangeType.Topic,
            durable: true);
    }
    
    public async Task PublishAsync<TEvent>(
        TEvent @event, 
        CancellationToken ct = default)
        where TEvent : IIntegrationEvent
    {
        var eventName = typeof(TEvent).Name;
        var message = JsonSerializer.Serialize(@event);
        var body = Encoding.UTF8.GetBytes(message);
        
        var properties = _channel.CreateBasicProperties();
        properties.Persistent = true;
        properties.MessageId = @event.EventId.ToString();
        
        _channel.BasicPublish(
            exchange: "markethub_events",
            routingKey: eventName,
            basicProperties: properties,
            body: body);
    }
    
    public void Subscribe<TEvent, THandler>()
        where TEvent : IIntegrationEvent
        where THandler : IIntegrationEventHandler<TEvent>
    {
        var eventName = typeof(TEvent).Name;
        
        if (!_eventTypes.ContainsKey(eventName))
            _eventTypes[eventName] = typeof(TEvent);
        
        if (!_handlers.ContainsKey(eventName))
            _handlers[eventName] = new List<Type>();
        
        _handlers[eventName].Add(typeof(THandler));
    }
    
    public void StartConsuming(string queueName)
    {
        _channel.QueueDeclare(
            queue: queueName,
            durable: true,
            exclusive: false,
            autoDelete: false);
        
        var consumer = new EventingBasicConsumer(_channel);
        consumer.Received += async (model, ea) =>
        {
            var eventName = ea.RoutingKey;
            var message = Encoding.UTF8.GetString(ea.Body.ToArray());
            
            await ProcessEvent(eventName, message);
            
            _channel.BasicAck(ea.DeliveryTag, multiple: false);
        };
        
        _channel.BasicConsume(
            queue: queueName,
            autoAck: false,
            consumer: consumer);
    }
    
    private async Task ProcessEvent(string eventName, string message)
    {
        if (!_eventTypes.ContainsKey(eventName)) return;
        
        using var scope = _serviceProvider.CreateScope();
        
        var eventType = _eventTypes[eventName];
        var @event = JsonSerializer.Deserialize(message, eventType);
        
        if (_handlers.ContainsKey(eventName))
        {
            foreach (var handlerType in _handlers[eventName])
            {
                var handler = scope.ServiceProvider.GetService(handlerType);
                if (handler == null) continue;
                
                var handleMethod = handlerType.GetMethod("Handle");
                await (Task)handleMethod.Invoke(handler, new[] { @event, CancellationToken.None });
            }
        }
    }
}
```

**Module Registration**:
```csharp
// In each module's DependencyInjection
public static IServiceCollection AddIAMModule(
    this IServiceCollection services,
    IConfiguration configuration)
{
    // ... other registrations
    
    // Subscribe to events this module cares about
    var sp = services.BuildServiceProvider();
    var eventBus = sp.GetRequiredService<IEventBus>();
    
    // IAM doesn't subscribe to any events currently
    
    return services;
}

// In Notifications Module
public static IServiceCollection AddNotificationsModule(
    this IServiceCollection services,
    IConfiguration configuration)
{
    // ... other registrations
    
    services.AddScoped<IIntegrationEventHandler<UserRegisteredIntegrationEvent>,
        UserRegisteredEventHandler>();
    services.AddScoped<IIntegrationEventHandler<OrderPlacedIntegrationEvent>,
        OrderPlacedEventHandler>();
    
    var sp = services.BuildServiceProvider();
    var eventBus = sp.GetRequiredService<IEventBus>();
    
    eventBus.Subscribe<UserRegisteredIntegrationEvent, UserRegisteredEventHandler>();
    eventBus.Subscribe<OrderPlacedIntegrationEvent, OrderPlacedEventHandler>();
    
    return services;
}
```

---

### 4.5 BuildingBlocks.Caching

**RedisCacheService.cs**:
```csharp
public class RedisCacheService : ICacheService
{
    private readonly IConnectionMultiplexer _redis;
    private readonly IDatabase _db;
    
    public RedisCacheService(IConnectionMultiplexer redis)
    {
        _redis = redis;
        _db = redis.GetDatabase();
    }
    
    public async Task<T?> GetAsync<T>(string key, CancellationToken ct = default)
    {
        var value = await _db.StringGetAsync(key);
        return value.HasValue 
            ? JsonSerializer.Deserialize<T>(value!) 
            : default;
    }
    
    public async Task SetAsync<T>(
        string key, 
        T value, 
        TimeSpan? expiration = null, 
        CancellationToken ct = default)
    {
        var serialized = JsonSerializer.Serialize(value);
        await _db.StringSetAsync(key, serialized, expiration);
    }
    
    public async Task RemoveAsync(string key, CancellationToken ct = default)
    {
        await _db.KeyDeleteAsync(key);
    }
    
    public async Task RemoveByPrefixAsync(string prefix, CancellationToken ct = default)
    {
        var endpoints = _redis.GetEndPoints();
        var server = _redis.GetServer(endpoints.First());
        var keys = server.Keys(pattern: $"{prefix}*").ToArray();
        
        if (keys.Any())
            await _db.KeyDeleteAsync(keys);
    }
}
```

**Cache Key Conventions**:
- `product:{productId}`
- `products:page:{page}:size:{pageSize}:search:{searchTerm}`
- `vendor:{vendorId}`
- `user:{userId}`

---

### 4.6 BuildingBlocks.Security

**JwtExtensions.cs**:
```csharp
public static class JwtExtensions
{
    public static IServiceCollection AddJwtAuthentication(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        var jwtOptions = configuration
            .GetSection(JwtOptions.SectionName)
            .Get<JwtOptions>() ?? throw new InvalidOperationException("JWT config missing");
        
        services.AddSingleton(jwtOptions);
        
        services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options =>
            {
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ValidateIssuerSigningKey = true,
                    ValidIssuer = jwtOptions.Issuer,
                    ValidAudience = jwtOptions.Audience,
                    IssuerSigningKey = new SymmetricSecurityKey(
                        Encoding.UTF8.GetBytes(jwtOptions.SecretKey)),
                    ClockSkew = TimeSpan.Zero
                };
            });
        
        services.AddAuthorization(options =>
        {
            options.AddPolicy("AdminOnly", 
                policy => policy.RequireRole("Admin"));
            options.AddPolicy("VendorOnly", 
                policy => policy.RequireRole("Vendor"));
            options.AddPolicy("CustomerOnly", 
                policy => policy.RequireRole("Customer"));
        });
        
        return services;
    }
}
```

---

### 4.7 BuildingBlocks.Logging

**SerilogExtensions.cs**:
```csharp
public static class SerilogExtensions
{
    public static IServiceCollection AddCustomLogging(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        Log.Logger = new LoggerConfiguration()
            .ReadFrom.Configuration(configuration)
            .Enrich.FromLogContext()
            .Enrich.WithMachineName()
            .Enrich.WithEnvironmentName()
            .WriteTo.Console()
            .WriteTo.File(
                path: "logs/markethub-.log",
                rollingInterval: RollingInterval.Day,
                outputTemplate: "{Timestamp:yyyy-MM-dd HH:mm:ss.fff zzz} [{Level:u3}] {Message:lj}{NewLine}{Exception}")
            .CreateLogger();
        
        services.AddSerilog();
        
        return services;
    }
}
```

---

## 5. Module Specifications

### 5.1 IAM Module (Identity & Access Management)

**Responsibility**: User registration, login, authentication, authorization, password management.

**Public Contracts**:
```csharp
// IAM.Contracts (can be a separate project or inside Api layer)

public interface IIdentityModule
{
    Task<UserDto?> GetUserAsync(Guid userId, CancellationToken ct = default);
    Task<bool> DoesUserExistAsync(Guid userId, CancellationToken ct = default);
    Task<IReadOnlyList<string>> GetUserRolesAsync(Guid userId, CancellationToken ct = default);
}

public record UserDto(
    Guid UserId, 
    string Email, 
    IReadOnlyList<string> Roles,
    bool IsActive);

// Integration Events
public record UserRegisteredIntegrationEvent(
    Guid UserId, 
    string Email, 
    string Role) : IntegrationEvent;

public record UserDeactivatedIntegrationEvent(
    Guid UserId) : IntegrationEvent;

public record UserRoleChangedIntegrationEvent(
    Guid UserId, 
    string OldRole, 
    string NewRole) : IntegrationEvent;
```

---

#### 5.1.1 IAM.Domain Layer

**Entities**:

**User.cs (Aggregate Root)**:
```csharp
public sealed class User : AggregateRoot
{
    public Email Email { get; private set; }
    public PasswordHash PasswordHash { get; private set; }
    public bool EmailVerified { get; private set; }
    public PhoneNumber? PhoneNumber { get; private set; }
    public bool PhoneVerified { get; private set; }
    public bool TwoFactorEnabled { get; private set; }
    public bool IsActive { get; private set; }
    public DateTime? LastLoginAt { get; private set; }
    
    private readonly List<UserRole> _roles = new();
    public IReadOnlyList<UserRole> Roles => _roles.AsReadOnly();
    
    private User() { } // EF Core
    
    public static Result<User> Create(
        Email email, 
        PasswordHash passwordHash, 
        string role)
    {
        // Domain validation
        if (string.IsNullOrWhiteSpace(role))
            return Result<User>.Failure(IAMErrors.User.InvalidRole());
        
        var user = new User
        {
            Id = Guid.NewGuid(),
            Email = email,
            PasswordHash = passwordHash,
            EmailVerified = false,
            IsActive = true,
            CreatedAt = DateTime.UtcNow
        };
        
        user._roles.Add(UserRole.Create(user.Id, role));
        user.AddDomainEvent(new UserCreatedDomainEvent(user.Id, email.Value));
        
        return Result<User>.Success(user);
    }
    
    public Result VerifyEmail()
    {
        if (EmailVerified)
            return Result.Failure(IAMErrors.User.EmailAlreadyVerified());
        
        EmailVerified = true;
        AddDomainEvent(new EmailVerifiedDomainEvent(Id));
        return Result.Success();
    }
    
    public Result Deactivate()
    {
        if (!IsActive)
            return Result.Failure(IAMErrors.User.AlreadyDeactivated());
        
        IsActive = false;
        AddDomainEvent(new UserDeactivatedDomainEvent(Id));
        return Result.Success();
    }
    
    public void RecordLogin()
    {
        LastLoginAt = DateTime.UtcNow;
    }
    
    public Result ChangePassword(PasswordHash newPasswordHash)
    {
        PasswordHash = newPasswordHash;
        AddDomainEvent(new PasswordChangedDomainEvent(Id));
        return Result.Success();
    }
}
```

**UserRole.cs (Entity)**:
```csharp
public sealed class UserRole : Entity
{
    public Guid UserId { get; private set; }
    public string Role { get; private set; }
    
    private UserRole() { }
    
    public static UserRole Create(Guid userId, string role)
    {
        return new UserRole
        {
            Id = Guid.NewGuid(),
            UserId = userId,
            Role = role
        };
    }
}
```

**RefreshToken.cs (Entity)**:
```csharp
public sealed class RefreshToken : Entity
{
    public Guid UserId { get; private set; }
    public string TokenHash { get; private set; }
    public DateTime ExpiresAt { get; private set; }
    public bool IsRevoked { get; private set; }
    public DateTime CreatedAt { get; private set; }
    
    private RefreshToken() { }
    
    public static RefreshToken Create(Guid userId, string tokenHash, int expiryDays)
    {
        return new RefreshToken
        {
            Id = Guid.NewGuid(),
            UserId = userId,
            TokenHash = tokenHash,
            ExpiresAt = DateTime.UtcNow.AddDays(expiryDays),
            IsRevoked = false,
            CreatedAt = DateTime.UtcNow
        };
    }
    
    public bool IsValid()
    {
        return !IsRevoked && ExpiresAt > DateTime.UtcNow;
    }
    
    public void Revoke()
    {
        IsRevoked = true;
    }
}
```

**EmailVerification.cs (Entity)**:
```csharp
public sealed class EmailVerification : Entity
{
    public Guid UserId { get; private set; }
    public string Token { get; private set; }
    public DateTime ExpiresAt { get; private set; }
    
    private EmailVerification() { }
    
    public static EmailVerification Create(Guid userId, string token)
    {
        return new EmailVerification
        {
            Id = Guid.NewGuid(),
            UserId = userId,
            Token = token,
            ExpiresAt = DateTime.UtcNow.AddHours(24)
        };
    }
    
    public bool IsExpired() => ExpiresAt < DateTime.UtcNow;
}
```

**Value Objects**:

**Email.cs**:
```csharp
public sealed class Email : ValueObject
{
    public string Value { get; }
    
    private Email(string value) => Value = value;
    
    public static Result<Email> Create(string email)
    {
        if (string.IsNullOrWhiteSpace(email))
            return Result<Email>.Failure(IAMErrors.Email.Empty());
        
        if (email.Length > 320)
            return Result<Email>.Failure(IAMErrors.Email.TooLong());
        
        if (!Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
            return Result<Email>.Failure(IAMErrors.Email.InvalidFormat());
        
        return Result<Email>.Success(new Email(email.ToLowerInvariant()));
    }
    
    protected override IEnumerable<object> GetEqualityComponents()
    {
        yield return Value;
    }
}
```

**PasswordHash.cs**:
```csharp
public sealed class PasswordHash : ValueObject
{
    public string Value { get; }
    
    private PasswordHash(string value) => Value = value;
    
    public static PasswordHash Create(string hash)
    {
        if (string.IsNullOrWhiteSpace(hash))
            throw new ArgumentException("Password hash cannot be empty");
        
        return new PasswordHash(hash);
    }
    
    protected override IEnumerable<object> GetEqualityComponents()
    {
        yield return Value;
    }
}
```

**PhoneNumber.cs**:
```csharp
public sealed class PhoneNumber : ValueObject
{
    public string Value { get; }
    
    private PhoneNumber(string value) => Value = value;
    
    public static Result<PhoneNumber> Create(string phoneNumber)
    {
        if (string.IsNullOrWhiteSpace(phoneNumber))
            return Result<PhoneNumber>.Failure(IAMErrors.PhoneNumber.Empty());
        
        // Basic validation (can use libphonenumber for production)
        var digitsOnly = Regex.Replace(phoneNumber, @"\D", "");
        
        if (digitsOnly.Length < 10 || digitsOnly.Length > 15)
            return Result<PhoneNumber>.Failure(IAMErrors.PhoneNumber.InvalidFormat());
        
        return Result<PhoneNumber>.Success(new PhoneNumber(digitsOnly));
    }
    
    protected override IEnumerable<object> GetEqualityComponents()
    {
        yield return Value;
    }
}
```

**Domain Events**:
```csharp
public record UserCreatedDomainEvent(Guid UserId, string Email) : IDomainEvent
{
    public Guid EventId { get; init; } = Guid.NewGuid();
    public DateTime OccurredOn { get; init; } = DateTime.UtcNow;
}

public record EmailVerifiedDomainEvent(Guid UserId) : IDomainEvent
{
    public Guid EventId { get; init; } = Guid.NewGuid();
    public DateTime OccurredOn { get; init; } = DateTime.UtcNow;
}

public record UserDeactivatedDomainEvent(Guid UserId) : IDomainEvent
{
    public Guid EventId { get; init; } = Guid.NewGuid();
    public DateTime OccurredOn { get; init; } = DateTime.UtcNow;
}

public record PasswordChangedDomainEvent(Guid UserId) : IDomainEvent
{
    public Guid EventId { get; init; } = Guid.NewGuid();
    public DateTime OccurredOn { get; init; } = DateTime.UtcNow;
}
```

**Repository Interfaces**:
```csharp
public interface IUserRepository
{
    Task<User?> GetByIdAsync(Guid id, CancellationToken ct = default);
    Task<User?> GetByEmailAsync(Email email, CancellationToken ct = default);
    Task<bool> ExistsByEmailAsync(Email email, CancellationToken ct = default);
    Task AddAsync(User user, CancellationToken ct = default);
    void Update(User user);
}

public interface IRefreshTokenRepository
{
    Task<RefreshToken?> GetByTokenHashAsync(string tokenHash, CancellationToken ct = default);
    Task AddAsync(RefreshToken token, CancellationToken ct = default);
    void Update(RefreshToken token);
}

public interface IEmailVerificationRepository
{
    Task<EmailVerification?> GetByTokenAsync(string token, CancellationToken ct = default);
    Task AddAsync(EmailVerification verification, CancellationToken ct = default);
}
```

**Errors** (IAMErrors.cs):
```csharp
public static class IAMErrors
{
    public static class User
    {
        public static Error EmailAlreadyExists(string email) =>
            Error.Conflict("User.EmailAlreadyExists", $"User with email '{email}' already exists");
        
        public static Error NotFound(Guid userId) =>
            Error.NotFound("User.NotFound", $"User with ID '{userId}' was not found");
        
        public static Error InvalidCredentials() =>
            Error.Validation("User.InvalidCredentials", "Invalid email or password");
        
        public static Error EmailNotVerified() =>
            Error.Validation("User.EmailNotVerified", "Email is not verified");
        
        public static Error AccountDeactivated() =>
            Error.Validation("User.AccountDeactivated", "Account is deactivated");
        
        public static Error InvalidRole() =>
            Error.Validation("User.InvalidRole", "Invalid user role");
        
        public static Error EmailAlreadyVerified() =>
            Error.Validation("User.EmailAlreadyVerified", "Email is already verified");
        
        public static Error AlreadyDeactivated() =>
            Error.Validation("User.AlreadyDeactivated", "User is already deactivated");
    }
    
    public static class Email
    {
        public static Error Empty() =>
            Error.Validation("Email.Empty", "Email cannot be empty");
        
        public static Error TooLong() =>
            Error.Validation("Email.TooLong", "Email cannot exceed 320 characters");
        
        public static Error InvalidFormat() =>
            Error.Validation("Email.InvalidFormat", "Email format is invalid");
    }
    
    public static class PhoneNumber
    {
        public static Error Empty() =>
            Error.Validation("PhoneNumber.Empty", "Phone number cannot be empty");
        
        public static Error InvalidFormat() =>
            Error.Validation("PhoneNumber.InvalidFormat", "Phone number format is invalid");
    }
    
    public static class RefreshToken
    {
        public static Error Expired() =>
            Error.Validation("RefreshToken.Expired", "Refresh token has expired");
        
        public static Error Invalid() =>
            Error.Validation("RefreshToken.Invalid", "Refresh token is invalid");
        
        public static Error Revoked() =>
            Error.Validation("RefreshToken.Revoked", "Refresh token has been revoked");
    }
    
    public static class EmailVerification
    {
        public static Error Expired() =>
            Error.Validation("EmailVerification.Expired", "Email verification token has expired");
        
        public static Error Invalid() =>
            Error.Validation("EmailVerification.Invalid", "Email verification token is invalid");
    }
    
    public static class Password
    {
        public static Error TooShort() =>
            Error.Validation("Password.TooShort", "Password must be at least 8 characters");
        
        public static Error MissingUppercase() =>
            Error.Validation("Password.MissingUppercase", "Password must contain at least one uppercase letter");
        
        public static Error MissingLowercase() =>
            Error.Validation("Password.MissingLowercase", "Password must contain at least one lowercase letter");
        
        public static Error MissingDigit() =>
            Error.Validation("Password.MissingDigit", "Password must contain at least one digit");
        
        public static Error MissingSpecialChar() =>
            Error.Validation("Password.MissingSpecialChar", "Password must contain at least one special character");
        
        public static Error Mismatch() =>
            Error.Validation("Password.Mismatch", "Passwords do not match");
        
        public static Error Incorrect() =>
            Error.Validation("Password.Incorrect", "Current password is incorrect");
    }
}
```

---

#### 5.1.2 IAM.Application Layer

**Commands**:

**RegisterUserCommand.cs**:
```csharp
public sealed record RegisterUserCommand(
    string Email,
    string Password,
    string ConfirmPassword,
    string Role) : IRequest<Result<Guid>>;
```

**RegisterUserCommandHandler.cs**:
```csharp
public sealed class RegisterUserCommandHandler 
    : IRequestHandler<RegisterUserCommand, Result<Guid>>
{
    private readonly IUserRepository _userRepository;
    private readonly IPasswordHasher _passwordHasher;
    private readonly IEmailService _emailService;
    private readonly IEmailVerificationRepository _verificationRepository;
    private readonly IAMDbContext _context;
    
    public async Task<Result<Guid>> Handle(
        RegisterUserCommand request,
        CancellationToken ct)
    {
        // 1. Validate password
        var passwordValidation = ValidatePassword(request.Password, request.ConfirmPassword);
        if (passwordValidation.IsFailure)
            return Result<Guid>.Failure(passwordValidation.Error);
        
        // 2. Create email value object
        var emailResult = Email.Create(request.Email);
        if (emailResult.IsFailure)
            return Result<Guid>.Failure(emailResult.Error);
        
        // 3. Check if email already exists
        if (await _userRepository.ExistsByEmailAsync(emailResult.Value, ct))
            return Result<Guid>.Failure(IAMErrors.User.EmailAlreadyExists(request.Email));
        
        // 4. Hash password
        var passwordHash = _passwordHasher.Hash(request.Password);
        var passwordHashVO = PasswordHash.Create(passwordHash);
        
        // 5. Create user aggregate
        var userResult = User.Create(emailResult.Value, passwordHashVO, request.Role);
        if (userResult.IsFailure)
            return Result<Guid>.Failure(userResult.Error);
        
        var user = userResult.Value;
        
        // 6. Create email verification token
        var verificationToken = Guid.NewGuid().ToString("N");
        var verification = EmailVerification.Create(user.Id, verificationToken);
        
        // 7. Persist
        await _userRepository.AddAsync(user, ct);
        await _verificationRepository.AddAsync(verification, ct);
        await _context.SaveChangesAsync(ct); // Publishes domain events
        
        // 8. Send verification email (fire and forget or queue)
        _ = _emailService.SendVerificationEmailAsync(
            request.Email, 
            verificationToken, 
            ct);
        
        return Result<Guid>.Success(user.Id);
    }
    
    private Result ValidatePassword(string password, string confirmPassword)
    {
        if (password != confirmPassword)
            return Result.Failure(IAMErrors.Password.Mismatch());
        
        if (password.Length < 8)
            return Result.Failure(IAMErrors.Password.TooShort());
        
        if (!password.Any(char.IsUpper))
            return Result.Failure(IAMErrors.Password.MissingUppercase());
        
        if (!password.Any(char.IsLower))
            return Result.Failure(IAMErrors.Password.MissingLowercase());
        
        if (!password.Any(char.IsDigit))
            return Result.Failure(IAMErrors.Password.MissingDigit());
        
        if (!password.Any(ch => !char.IsLetterOrDigit(ch)))
            return Result.Failure(IAMErrors.Password.MissingSpecialChar());
        
        return Result.Success();
    }
}
```

**LoginCommand.cs**:
```csharp
public sealed record LoginCommand(
    string Email,
    string Password) : IRequest<Result<LoginResponse>>;

public sealed record LoginResponse(
    string AccessToken,
    string RefreshToken,
    DateTime ExpiresAt);
```

**LoginCommandHandler.cs**:
```csharp
public sealed class LoginCommandHandler 
    : IRequestHandler<LoginCommand, Result<LoginResponse>>
{
    private readonly IUserRepository _userRepository;
    private readonly IRefreshTokenRepository _refreshTokenRepository;
    private readonly IPasswordHasher _passwordHasher;
    private readonly IJwtTokenGenerator _jwtTokenGenerator;
    private readonly IAMDbContext _context;
    
    public async Task<Result<LoginResponse>> Handle(
        LoginCommand request,
        CancellationToken ct)
    {
        // 1. Get user by email
        var emailResult = Email.Create(request.Email);
        if (emailResult.IsFailure)
            return Result<LoginResponse>.Failure(IAMErrors.User.InvalidCredentials());
        
        var user = await _userRepository.GetByEmailAsync(emailResult.Value, ct);
        if (user == null)
            return Result<LoginResponse>.Failure(IAMErrors.User.InvalidCredentials());
        
        // 2. Verify password
        if (!_passwordHasher.Verify(request.Password, user.PasswordHash.Value))
            return Result<LoginResponse>.Failure(IAMErrors.User.InvalidCredentials());
        
        // 3. Check if account is active
        if (!user.IsActive)
            return Result<LoginResponse>.Failure(IAMErrors.User.AccountDeactivated());
        
        // 4. Generate JWT
        var accessToken = _jwtTokenGenerator.GenerateAccessToken(
            user.Id, 
            user.Email.Value, 
            user.Roles.Select(r => r.Role).ToList());
        
        // 5. Generate refresh token
        var refreshTokenValue = Guid.NewGuid().ToString("N");
        var refreshTokenHash = _passwordHasher.Hash(refreshTokenValue);
        var refreshToken = RefreshToken.Create(user.Id, refreshTokenHash, expiryDays: 30);
        
        await _refreshTokenRepository.AddAsync(refreshToken, ct);
        
        // 6. Record login
        user.RecordLogin();
        _userRepository.Update(user);
        
        await _context.SaveChangesAsync(ct);
        
        return Result<LoginResponse>.Success(new LoginResponse(
            accessToken.Token,
            refreshTokenValue,
            accessToken.ExpiresAt));
    }
}
```

**Other Commands**:
- `VerifyEmailCommand`
- `ForgotPasswordCommand`
- `ResetPasswordCommand`
- `ChangePasswordCommand`
- `RefreshTokenCommand`
- `LogoutCommand`

**Queries**:

**GetCurrentUserQuery.cs**:
```csharp
public sealed record GetCurrentUserQuery(Guid UserId) 
    : IRequest<Result<UserDto>>;
```

**GetCurrentUserQueryHandler.cs**:
```csharp
public sealed class GetCurrentUserQueryHandler 
    : IRequestHandler<GetCurrentUserQuery, Result<UserDto>>
{
    private readonly IAMDbContext _context;
    
    public async Task<Result<UserDto>> Handle(
        GetCurrentUserQuery request,
        CancellationToken ct)
    {
        var user = await _context.Users
            .Include(u => u.Roles)
            .FirstOrDefaultAsync(u => u.Id == request.UserId, ct);
        
        if (user == null)
            return Result<UserDto>.Failure(IAMErrors.User.NotFound(request.UserId));
        
        var dto = new UserDto(
            user.Id,
            user.Email.Value,
            user.Roles.Select(r => r.Role).ToList(),
            user.IsActive);
        
        return Result<UserDto>.Success(dto);
    }
}
```

**Domain Event Handlers**:

**UserCreatedDomainEventHandler.cs**:
```csharp
public sealed class UserCreatedDomainEventHandler 
    : INotificationHandler<UserCreatedDomainEvent>
{
    private readonly IAMDbContext _context;
    
    public async Task Handle(
        UserCreatedDomainEvent notification,
        CancellationToken ct)
    {
        // Write integration event to outbox
        var integrationEvent = new UserRegisteredIntegrationEvent(
            notification.UserId,
            notification.Email,
            "Customer"); // Get from user roles
        
        var outboxMessage = new OutboxMessage
        {
            Id = Guid.NewGuid(),
            Type = typeof(UserRegisteredIntegrationEvent).AssemblyQualifiedName!,
            Content = JsonSerializer.Serialize(integrationEvent),
            OccurredOnUtc = DateTime.UtcNow
        };
        
        _context.OutboxMessages.Add(outboxMessage);
        // SaveChanges called by BaseDbContext after domain event handling
    }
}
```

**Pipeline Behaviors**:

**ValidationBehavior.cs** (using FluentValidation):
```csharp
public sealed class ValidationBehavior<TRequest, TResponse> 
    : IPipelineBehavior<TRequest, TResponse>
    where TRequest : IRequest<TResponse>
    where TResponse : Result
{
    private readonly IEnumerable<IValidator<TRequest>> _validators;
    
    public async Task<TResponse> Handle(
        TRequest request,
        RequestHandlerDelegate<TResponse> next,
        CancellationToken ct)
    {
        if (!_validators.Any())
            return await next();
        
        var context = new ValidationContext<TRequest>(request);
        
        var validationResults = await Task.WhenAll(
            _validators.Select(v => v.ValidateAsync(context, ct)));
        
        var failures = validationResults
            .SelectMany(r => r.Errors)
            .Where(f => f != null)
            .ToList();
        
        if (failures.Any())
        {
            var errors = failures
                .Select(f => f.ErrorMessage)
                .ToList();
            
            var error = Error.Validation(
                "Validation.Failed",
                string.Join("; ", errors));
            
            return (TResponse)Activator.CreateInstance(
                typeof(TResponse), 
                false, 
                error)!;
        }
        
        return await next();
    }
}
```

**LoggingBehavior.cs**:
```csharp
public sealed class LoggingBehavior<TRequest, TResponse> 
    : IPipelineBehavior<TRequest, TResponse>
    where TRequest : IRequest<TResponse>
{
    private readonly ILogger<LoggingBehavior<TRequest, TResponse>> _logger;
    
    public async Task<TResponse> Handle(
        TRequest request,
        RequestHandlerDelegate<TResponse> next,
        CancellationToken ct)
    {
        var requestName = typeof(TRequest).Name;
        
        _logger.LogInformation(
            "Handling {RequestName}", 
            requestName);
        
        var stopwatch = Stopwatch.StartNew();
        
        try
        {
            var response = await next();
            
            stopwatch.Stop();
            
            _logger.LogInformation(
                "Handled {RequestName} in {ElapsedMs}ms",
                requestName,
                stopwatch.ElapsedMilliseconds);
            
            return response;
        }
        catch (Exception ex)
        {
            stopwatch.Stop();
            
            _logger.LogError(
                ex,
                "Error handling {RequestName} after {ElapsedMs}ms",
                requestName,
                stopwatch.ElapsedMilliseconds);
            
            throw;
        }
    }
}
```

**DependencyInjection.cs**:
```csharp
public static class DependencyInjection
{
    public static IServiceCollection AddIAMApplication(
        this IServiceCollection services)
    {
        services.AddMediatR(cfg =>
        {
            cfg.RegisterServicesFromAssembly(typeof(DependencyInjection).Assembly);
            cfg.AddOpenBehavior(typeof(ValidationBehavior<,>));
            cfg.AddOpenBehavior(typeof(LoggingBehavior<,>));
        });
        
        services.AddValidatorsFromAssembly(typeof(DependencyInjection).Assembly);
        
        return services;
    }
}
```

---

#### 5.1.3 IAM.Infrastructure Layer

**IAMDbContext.cs**:
```csharp
public sealed class IAMDbContext : BaseDbContext
{
    public const string SCHEMA = "identity";
    
    public DbSet<User> Users => Set<User>();
    public DbSet<UserRole> UserRoles => Set<UserRole>();
    public DbSet<RefreshToken> RefreshTokens => Set<RefreshToken>();
    public DbSet<EmailVerification> EmailVerifications => Set<EmailVerification>();
    public DbSet<OutboxMessage> OutboxMessages => Set<OutboxMessage>();
    
    public IAMDbContext(DbContextOptions<IAMDbContext> options)
        : base(options) { }
    
    public IAMDbContext(
        DbContextOptions<IAMDbContext> options,
        IMediator mediator,
        IDateTimeProvider dateTimeProvider)
        : base(options, mediator, dateTimeProvider) { }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema(SCHEMA);
        ConfigureBaseEntities(modelBuilder);
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(IAMDbContext).Assembly);
        
        // Seed roles
        SeedRoles(modelBuilder);
        
        base.OnModelCreating(modelBuilder);
    }
    
    private void SeedRoles(ModelBuilder modelBuilder)
    {
        // This is just for reference - roles are managed by UserRole entity
        // Could seed default admin user here
    }
}
```

**Entity Configurations**:

**UserConfiguration.cs**:
```csharp
public sealed class UserConfiguration : IEntityTypeConfiguration<User>
{
    public void Configure(EntityTypeBuilder<User> builder)
    {
        builder.ToTable("Users", IAMDbContext.SCHEMA);
        
        builder.HasKey(u => u.Id);
        
        builder.Property(u => u.Id)
            .ValueGeneratedNever();
        
        builder.OwnsOne(u => u.Email, email =>
        {
            email.Property(e => e.Value)
                .HasColumnName("Email")
                .HasMaxLength(320)
                .IsRequired();
            
            email.HasIndex(e => e.Value)
                .IsUnique();
        });
        
        builder.OwnsOne(u => u.PasswordHash, password =>
        {
            password.Property(p => p.Value)
                .HasColumnName("PasswordHash")
                .HasMaxLength(512)
                .IsRequired();
        });
        
        builder.OwnsOne(u => u.PhoneNumber, phone =>
        {
            phone.Property(p => p.Value)
                .HasColumnName("PhoneNumber")
                .HasMaxLength(20);
        });
        
        builder.Property(u => u.EmailVerified)
            .HasDefaultValue(false);
        
        builder.Property(u => u.PhoneVerified)
            .HasDefaultValue(false);
        
        builder.Property(u => u.TwoFactorEnabled)
            .HasDefaultValue(false);
        
        builder.Property(u => u.IsActive)
            .HasDefaultValue(true);
        
        builder.Property(u => u.LastLoginAt);
        
        builder.HasMany(u => u.Roles)
            .WithOne()
            .HasForeignKey("UserId")
            .OnDelete(DeleteBehavior.Cascade);
        
        builder.Ignore(u => u.DomainEvents);
    }
}
```

**UserRoleConfiguration.cs**, **RefreshTokenConfiguration.cs**, etc. follow similar patterns.

**Repositories**:

**UserRepository.cs**:
```csharp
public sealed class UserRepository : IUserRepository
{
    private readonly IAMDbContext _context;
    
    public UserRepository(IAMDbContext context)
    {
        _context = context;
    }
    
    public async Task<User?> GetByIdAsync(Guid id, CancellationToken ct = default)
    {
        return await _context.Users
            .Include(u => u.Roles)
            .FirstOrDefaultAsync(u => u.Id == id, ct);
    }
    
    public async Task<User?> GetByEmailAsync(Email email, CancellationToken ct = default)
    {
        return await _context.Users
            .Include(u => u.Roles)
            .FirstOrDefaultAsync(u => u.Email == email, ct);
    }
    
    public async Task<bool> ExistsByEmailAsync(Email email, CancellationToken ct = default)
    {
        return await _context.Users
            .AnyAsync(u => u.Email == email, ct);
    }
    
    public async Task AddAsync(User user, CancellationToken ct = default)
    {
        await _context.Users.AddAsync(user, ct);
    }
    
    public void Update(User user)
    {
        _context.Users.Update(user);
    }
}
```

**Authentication Services**:

**JwtTokenGenerator.cs**:
```csharp
public sealed class JwtTokenGenerator : IJwtTokenGenerator
{
    private readonly JwtOptions _jwtOptions;
    
    public JwtTokenGenerator(JwtOptions jwtOptions)
    {
        _jwtOptions = jwtOptions;
    }
    
    public JwtToken GenerateAccessToken(Guid userId, string email, List<string> roles)
    {
        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Sub, userId.ToString()),
            new(JwtRegisteredClaimNames.Email, email),
            new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };
        
        claims.AddRange(roles.Select(role => new Claim(ClaimTypes.Role, role)));
        
        var key = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(_jwtOptions.SecretKey));
        
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
        
        var expiresAt = DateTime.UtcNow.AddMinutes(_jwtOptions.ExpiryInMinutes);
        
        var token = new JwtSecurityToken(
            issuer: _jwtOptions.Issuer,
            audience: _jwtOptions.Audience,
            claims: claims,
            expires: expiresAt,
            signingCredentials: creds);
        
        var tokenString = new JwtSecurityTokenHandler().WriteToken(token);
        
        return new JwtToken(tokenString, expiresAt);
    }
}

public record JwtToken(string Token, DateTime ExpiresAt);
```

**PasswordHasher.cs**:
```csharp
public sealed class PasswordHasher : IPasswordHasher
{
    public string Hash(string password)
    {
        return BCrypt.Net.BCrypt.HashPassword(password, workFactor: 12);
    }
    
    public bool Verify(string password, string hash)
    {
        return BCrypt.Net.BCrypt.Verify(password, hash);
    }
}
```

**DependencyInjection.cs**:
```csharp
public static class DependencyInjection
{
    public static IServiceCollection AddIAMInfrastructure(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        var connectionString = configuration.GetConnectionString("Database")
            ?? throw new InvalidOperationException("Database connection not configured");
        
        var databaseOptions = configuration
            .GetSection(DatabaseOptions.SectionName)
            .Get<DatabaseOptions>() ?? new DatabaseOptions();
        
        services.AddDbContext<IAMDbContext>((sp, options) =>
        {
            var mediator = sp.GetRequiredService<IMediator>();
            var dateTimeProvider = sp.GetRequiredService<IDateTimeProvider>();
            
            options.ConfigurePostgreSQL(
                connectionString,
                IAMDbContext.SCHEMA,
                typeof(IAMDbContext).Assembly.FullName!,
                databaseOptions);
        });
        
        services.AddScoped<IUserRepository, UserRepository>();
        services.AddScoped<IRefreshTokenRepository, RefreshTokenRepository>();
        services.AddScoped<IEmailVerificationRepository, EmailVerificationRepository>();
        
        services.AddScoped<IJwtTokenGenerator, JwtTokenGenerator>();
        services.AddScoped<IPasswordHasher, PasswordHasher>();
        services.AddScoped<IEmailService, EmailService>();
        
        return services;
    }
}
```

---

#### 5.1.4 IAM.Api Layer

**IdentityController.cs**:
```csharp
[ApiController]
[Route("api/identity")]
public sealed class IdentityController : ControllerBase
{
    private readonly ISender _sender;
    
    public IdentityController(ISender sender)
    {
        _sender = sender;
    }
    
    [HttpPost("register")]
    public async Task<IActionResult> Register(
        [FromBody] RegisterRequest request,
        CancellationToken ct)
    {
        var command = new RegisterUserCommand(
            request.Email,
            request.Password,
            request.ConfirmPassword,
            request.Role);
        
        var result = await _sender.Send(command, ct);
        
        if (result.IsFailure)
            return BadRequest(new { error = result.Error.Message });
        
        return Ok(new { userId = result.Value });
    }
    
    [HttpPost("login")]
    public async Task<IActionResult> Login(
        [FromBody] LoginRequest request,
        CancellationToken ct)
    {
        var command = new LoginCommand(request.Email, request.Password);
        
        var result = await _sender.Send(command, ct);
        
        if (result.IsFailure)
            return Unauthorized(new { error = result.Error.Message });
        
        return Ok(result.Value);
    }
    
    [HttpPost("refresh")]
    public async Task<IActionResult> RefreshToken(
        [FromBody] RefreshTokenRequest request,
        CancellationToken ct)
    {
        var command = new RefreshTokenCommand(request.RefreshToken);
        
        var result = await _sender.Send(command, ct);
        
        if (result.IsFailure)
            return Unauthorized(new { error = result.Error.Message });
        
        return Ok(result.Value);
    }
    
    [HttpPost("logout")]
    [Authorize]
    public async Task<IActionResult> Logout(
        [FromBody] LogoutRequest request,
        CancellationToken ct)
    {
        var command = new LogoutCommand(request.RefreshToken);
        
        var result = await _sender.Send(command, ct);
        
        if (result.IsFailure)
            return BadRequest(new { error = result.Error.Message });
        
        return NoContent();
    }
    
    [HttpPost("verify-email")]
    public async Task<IActionResult> VerifyEmail(
        [FromBody] VerifyEmailRequest request,
        CancellationToken ct)
    {
        var command = new VerifyEmailCommand(request.Token);
        
        var result = await _sender.Send(command, ct);
        
        if (result.IsFailure)
            return BadRequest(new { error = result.Error.Message });
        
        return Ok();
    }
    
    [HttpPost("forgot-password")]
    public async Task<IActionResult> ForgotPassword(
        [FromBody] ForgotPasswordRequest request,
        CancellationToken ct)
    {
        var command = new ForgotPasswordCommand(request.Email);
        
        var result = await _sender.Send(command, ct);
        
        if (result.IsFailure)
            return BadRequest(new { error = result.Error.Message });
        
        return Ok();
    }
    
    [HttpPost("reset-password")]
    public async Task<IActionResult> ResetPassword(
        [FromBody] ResetPasswordRequest request,
        CancellationToken ct)
    {
        var command = new ResetPasswordCommand(
            request.Token,
            request.NewPassword,
            request.ConfirmPassword);
        
        var result = await _sender.Send(command, ct);
        
        if (result.IsFailure)
            return BadRequest(new { error = result.Error.Message });
        
        return Ok();
    }
    
    [HttpGet("me")]
    [Authorize]
    public async Task<IActionResult> GetCurrentUser(CancellationToken ct)
    {
        var userId = Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
        
        var query = new GetCurrentUserQuery(userId);
        
        var result = await _sender.Send(query, ct);
        
        if (result.IsFailure)
            return NotFound(new { error = result.Error.Message });
        
        return Ok(result.Value);
    }
    
    [HttpPut("me/password")]
    [Authorize]
    public async Task<IActionResult> ChangePassword(
        [FromBody] ChangePasswordRequest request,
        CancellationToken ct)
    {
        var userId = Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
        
        var command = new ChangePasswordCommand(
            userId,
            request.CurrentPassword,
            request.NewPassword,
            request.ConfirmPassword);
        
        var result = await _sender.Send(command, ct);
        
        if (result.IsFailure)
            return BadRequest(new { error = result.Error.Message });
        
        return NoContent();
    }
}
```

**Request/Response DTOs**:
```csharp
public record RegisterRequest(
    string Email,
    string Password,
    string ConfirmPassword,
    string Role);

public record LoginRequest(string Email, string Password);

public record RefreshTokenRequest(string RefreshToken);

public record LogoutRequest(string RefreshToken);

public record VerifyEmailRequest(string Token);

public record ForgotPasswordRequest(string Email);

public record ResetPasswordRequest(
    string Token,
    string NewPassword,
    string ConfirmPassword);

public record ChangePasswordRequest(
    string CurrentPassword,
    string NewPassword,
    string ConfirmPassword);
```

**IAMModuleExtensions.cs**:
```csharp
public static class IAMModuleExtensions
{
    public static IServiceCollection AddIAMModule(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        services.AddIAMApplication();
        services.AddIAMInfrastructure(configuration);
        
        return services;
    }
    
    public static async Task UseIAMModuleAsync(this IApplicationBuilder app)
    {
        using var scope = app.ApplicationServices.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<IAMDbContext>();
        await context.Database.MigrateAsync();
    }
}
```

**AssemblyReference.cs**:
```csharp
public static class AssemblyReference { }
```

---

### 5.2 Other Modules (Summary Structure)

The same pattern applies to all other modules:

**Catalog Module**:
- Domain: Product, Category, ProductVariant, ProductImage aggregates
- Commands: CreateProduct, UpdateProduct, PublishProduct, DeactivateProduct
- Queries: GetProducts (with filters, pagination), GetProductById, GetProductsByVendor
- Integration Events: ProductCreated, ProductPriceChanged, ProductDeactivated

**Inventory Module**:
- Domain: StockItem, StockReservation, StockMovement
- Commands: ReserveStock, ReleaseReservation, AdjustStock
- Queries: GetAvailableQuantity, GetStockReservations
- Integration Events: StockReserved, StockReleased, LowStockAlert, OutOfStock
- Event Handlers: Listens to ProductCreated (create StockItem), OrderCancelled (release stock)

**Ordering Module**:
- Domain: Order (aggregate root with OrderLine entities), OrderStatus state machine
- Commands: CreateOrder, SubmitOrder, CancelOrder, ConfirmOrder
- Queries: GetOrders, GetOrderById, GetOrdersByCustomer
- Integration Events: OrderPlaced, OrderCancelled, OrderFulfilled
- Event Handlers: Listens to PaymentSucceeded (confirm order), StockReserved (proceed to processing)

**Payment Module**:
- Domain: PaymentIntent, Transaction, VendorPayout
- Commands: CreatePaymentIntent, ProcessPayment, RefundPayment
- Queries: GetPaymentIntent, GetVendorPayouts
- Integration Events: PaymentSucceeded, PaymentFailed, PayoutProcessed
- Event Handlers: Listens to OrderPlaced (create payment intent)

**Vendors Module**:
- Domain: VendorAccount, PayoutBalance, SalesSummary
- Commands: ApplyAsVendor, ApproveVendor, SuspendVendor
- Queries: GetVendor, GetVendorDashboard
- Integration Events: VendorApproved, VendorSuspended
- Event Handlers: Listens to UserRegistered (if role=Vendor), PaymentSucceeded (update balance)

**Notifications Module**:
- Domain: NotificationLog, UserPreferences, NotificationTemplate
- Commands: (mostly internal - triggered by events)
- Event Handlers: Listens to ALL relevant events (UserRegistered, OrderPlaced, PaymentSucceeded, etc.)
- Sends emails/SMS via SendGrid/Twilio

**Reviews Module** (Phase 2):
- Domain: Review, VerifiedPurchase
- Commands: SubmitReview, ModerateReview, VoteHelpful
- Queries: GetProductReviews, GetRatingSummary
- Integration Events: ReviewSubmitted
- Event Handlers: Listens to OrderFulfilled (create VerifiedPurchase record)

**Analytics Module** (Phase 2):
- Domain: DailyOrderMetrics, VendorDailyMetrics (read models)
- Commands: (none - pure consumer)
- Queries: GetDashboardMetrics, GetVendorAnalytics
- Event Handlers: Listens to ALL events and updates denormalized views

---

## 6. Cross-Module Communication

### 6.1 Rules
1. **NO direct database access** between modules
2. **NO direct assembly references** to another module's Domain/Infrastructure/Application
3. **Communicate ONLY via**:
   - Integration Events (asynchronous)
   - Public Contracts/Interfaces (synchronous when absolutely necessary)

### 6.2 Integration Event Flow

**Example: User Registration Flow**

1. **IAM Module**:
   - User registers → `RegisterUserCommandHandler` creates User aggregate
   - Domain event `UserCreatedDomainEvent` raised
   - `UserCreatedDomainEventHandler` writes `UserRegisteredIntegrationEvent` to outbox
   - `SaveChangesAsync` commits transaction (user + outbox message)

2. **Outbox Processor** (background job):
   - Reads unprocessed outbox messages
   - Publishes `UserRegisteredIntegrationEvent` to RabbitMQ
   - Marks outbox message as processed

3. **RabbitMQ**:
   - Routes event to queues of subscribed modules (Notifications, Vendors if role=Vendor)

4. **Notifications Module**:
   - `UserRegisteredEventHandler` receives event
   - Sends welcome email
   - Logs notification

5. **Vendors Module** (if role=Vendor):
   - `UserRegisteredEventHandler` receives event
   - Creates VendorAccount with status=Applied
   - Publishes VendorApplicationSubmitted event

**Example: Order Placement Flow**

1. **Ordering Module**:
   - `PlaceOrderCommand` → creates Order aggregate
   - Order.SubmitForPayment() → status = PaymentPending
   - Publishes `OrderPlacedIntegrationEvent` (to outbox)

2. **Payment Module**:
   - Listens to `OrderPlacedIntegrationEvent`
   - Creates PaymentIntent for the order
   - Calls Stripe API to create payment intent
   - Returns payment client secret to frontend (via separate API call)

3. **Frontend**:
   - Customer completes payment with Stripe
   - Stripe sends webhook to Payment module

4. **Payment Module** (webhook handler):
   - Receives `payment_intent.succeeded` from Stripe
   - Marks PaymentIntent as Succeeded
   - Publishes `PaymentSucceededIntegrationEvent`

5. **Ordering Module**:
   - Listens to `PaymentSucceededIntegrationEvent`
   - Updates Order status to PaymentConfirmed
   - Publishes `OrderConfirmedIntegrationEvent`

6. **Inventory Module**:
   - Listens to `OrderConfirmedIntegrationEvent`
   - Reserves stock for order items
   - Publishes `StockReservedIntegrationEvent` (success or failure)

7. **Ordering Module**:
   - Listens to `StockReservedIntegrationEvent`
   - If success: Update Order status to Processing
   - If failure: Update Order status to Cancelled, publish OrderCancelled

8. **Payment Module**:
   - Listens to `OrderCancelledIntegrationEvent`
   - Initiates refund via Stripe

9. **Notifications Module**:
   - Listens to all these events and sends appropriate emails

---

## 7. Database Strategy

### 7.1 Single Database, Multiple Schemas

**Database**: `markethub_db` (PostgreSQL)

**Schemas**:
- `identity` (IAM Module)
- `catalog` (Catalog Module)
- `inventory` (Inventory Module)
- `ordering` (Ordering Module)
- `payment` (Payment Module)
- `vendors` (Vendors Module)
- `notifications` (Notifications Module)
- `reviews` (Reviews Module)
- `analytics` (Analytics Module)

### 7.2 Connection String

**appsettings.json**:
```json
{
  "ConnectionStrings": {
    "Database": "Host=localhost;Port=5432;Database=markethub_db;Username=postgres;Password=your_password"
  }
}
```

### 7.3 Module DbContext Registration

Each module registers its own DbContext pointing to the same connection string but different schema.

**Example** (Catalog Module):
```csharp
services.AddDbContext<CatalogDbContext>((sp, options) =>
{
    var mediator = sp.GetRequiredService<IMediator>();
    var dateTimeProvider = sp.GetRequiredService<IDateTimeProvider>();
    
    options.ConfigurePostgreSQL(
        connectionString,
        CatalogDbContext.SCHEMA, // "catalog"
        typeof(CatalogDbContext).Assembly.FullName!,
        databaseOptions);
});
```

### 7.4 Migrations

Each module manages its own migrations.

**Create Migration**:
```bash
dotnet ef migrations add InitialCreate \
  --project src/Modules/Catalog/MarketHub.Modules.Catalog.Infrastructure \
  --startup-project src/API/MarketHub.API \
  --context CatalogDbContext \
  --output-dir Persistence/Migrations
```

**Apply Migrations** (automatically on startup):
```csharp
public static async Task UseCatalogModuleAsync(this IApplicationBuilder app)
{
    using var scope = app.ApplicationServices.CreateScope();
    var context = scope.ServiceProvider.GetRequiredService<CatalogDbContext>();
    await context.Database.MigrateAsync();
}
```

### 7.5 Cross-Schema References

**NEVER use foreign keys across schemas**.

Instead, store the ID and validate existence via:
1. Integration events (eventual consistency)
2. Public module interfaces (when synchronous validation is required)

**Example**: Catalog module stores `VendorId` without FK constraint. It trusts that Vendors module only publishes valid vendor IDs via events.

---

## 8. Testing Strategy

### 8.1 Unit Tests (Domain Layer)

**Purpose**: Test domain logic in isolation.

**What to Test**:
- Aggregate creation
- Business rule validation
- State transitions
- Domain events raised

**Example** (IAM.Domain.UnitTests):
```csharp
public class UserTests
{
    [Fact]
    public void Create_WithValidData_ShouldSucceed()
    {
        // Arrange
        var emailResult = Email.Create("test@example.com");
        var passwordHash = PasswordHash.Create("hashed_password");
        
        // Act
        var result = User.Create(emailResult.Value, passwordHash, "Customer");
        
        // Assert
        result.IsSuccess.Should().BeTrue();
        result.Value.Email.Value.Should().Be("test@example.com");
        result.Value.Roles.Should().HaveCount(1);
        result.Value.DomainEvents.Should().ContainSingle(
            e => e is UserCreatedDomainEvent);
    }
    
    [Fact]
    public void VerifyEmail_WhenAlreadyVerified_ShouldFail()
    {
        // Arrange
        var user = CreateValidUser();
        user.VerifyEmail();
        
        // Act
        var result = user.VerifyEmail();
        
        // Assert
        result.IsFailure.Should().BeTrue();
        result.Error.Code.Should().Be("User.EmailAlreadyVerified");
    }
}
```

### 8.2 Integration Tests (Module Level)

**Purpose**: Test module contracts and event handling between modules.

**What to Test**:
- Integration event publishing
- Integration event handling
- Public interface implementations
- Database interactions

**Example** (IAM.IntegrationTests):
```csharp
public class UserRegistrationIntegrationTests : IClassFixture<IAMModuleFixture>
{
    private readonly IAMModuleFixture _fixture;
    
    public UserRegistrationIntegrationTests(IAMModuleFixture fixture)
    {
        _fixture = fixture;
    }
    
    [Fact]
    public async Task RegisterUser_ShouldPublishIntegrationEvent()
    {
        // Arrange
        var command = new RegisterUserCommand(
            "newuser@example.com",
            "Password123!",
            "Password123!",
            "Customer");
        
        var eventBusMock = new Mock<IEventBus>();
        // ... setup mock
        
        // Act
        var result = await _fixture.SendAsync(command);
        
        // Assert
        result.IsSuccess.Should().BeTrue();
        
        // Verify outbox message created
        var outboxMessage = await _fixture.GetOutboxMessageAsync(
            typeof(UserRegisteredIntegrationEvent).Name);
        
        outboxMessage.Should().NotBeNull();
    }
}

public class IAMModuleFixture : IDisposable
{
    private readonly ServiceProvider _serviceProvider;
    private readonly IAMDbContext _context;
    
    public IAMModuleFixture()
    {
        var services = new ServiceCollection();
        
        // Use in-memory database
        services.AddDbContext<IAMDbContext>(options =>
            options.UseInMemoryDatabase("IAMTestDb"));
        
        services.AddIAMApplication();
        // ... register other dependencies
        
        _serviceProvider = services.BuildServiceProvider();
        _context = _serviceProvider.GetRequiredService<IAMDbContext>();
    }
    
    public async Task<TResponse> SendAsync<TResponse>(IRequest<TResponse> request)
    {
        using var scope = _serviceProvider.CreateScope();
        var mediator = scope.ServiceProvider.GetRequiredService<ISender>();
        return await mediator.Send(request);
    }
    
    public async Task<OutboxMessage?> GetOutboxMessageAsync(string eventType)
    {
        return await _context.OutboxMessages
            .FirstOrDefaultAsync(m => m.Type.Contains(eventType));
    }
    
    public void Dispose()
    {
        _context.Database.EnsureDeleted();
        _serviceProvider.Dispose();
    }
}
```

### 8.3 End-to-End Tests (API Level)

**Purpose**: Test complete workflows across multiple modules.

**What to Test**:
- Full user journeys (register → login → place order → payment → fulfillment)
- API contracts
- Authentication/Authorization

**Example** (API.E2ETests):
```csharp
public class OrderPlacementE2ETests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;
    
    public OrderPlacementE2ETests(WebApplicationFactory<Program> factory)
    {
        _client = factory.CreateClient();
    }
    
    [Fact]
    public async Task CompleteOrderFlow_ShouldSucceed()
    {
        // 1. Register user
        var registerResponse = await _client.PostAsJsonAsync("/api/identity/register", new
        {
            Email = "customer@test.com",
            Password = "Test123!",
            ConfirmPassword = "Test123!",
            Role = "Customer"
        });
        
        registerResponse.StatusCode.Should().Be(HttpStatusCode.OK);
        
        // 2. Login
        var loginResponse = await _client.PostAsJsonAsync("/api/identity/login", new
        {
            Email = "customer@test.com",
            Password = "Test123!"
        });
        
        var loginResult = await loginResponse.Content.ReadFromJsonAsync<LoginResponse>();
        var accessToken = loginResult!.AccessToken;
        
        _client.DefaultRequestHeaders.Authorization = 
            new AuthenticationHeaderValue("Bearer", accessToken);
        
        // 3. Add to cart
        await _client.PostAsJsonAsync("/api/cart/items", new
        {
            ProductId = Guid.NewGuid(),
            Quantity = 2
        });
        
        // 4. Place order
        var orderResponse = await _client.PostAsJsonAsync("/api/orders", new
        {
            ShippingAddress = new
            {
                Street = "123 Main St",
                City = "Test City",
                State = "TS",
                PostalCode = "12345",
                Country = "Testland"
            }
        });
        
        orderResponse.StatusCode.Should().Be(HttpStatusCode.Created);
        
        // 5. Verify order created
        var orderResult = await orderResponse.Content.ReadFromJsonAsync<OrderDto>();
        orderResult!.Status.Should().Be("PaymentPending");
    }
}
```

---

## 9. Error Handling & Result Pattern

### 9.1 Principles
- **Domain layer**: Return `Result<T>` for all operations that can fail
- **Application layer**: Return `Result<T>` from command/query handlers
- **Infrastructure layer**: Throw exceptions only for infrastructure failures (DB connection, external API errors)
- **API layer**: Map `Result<T>` to HTTP status codes

### 9.2 Error Mapping in Controllers

**Base Controller** (optional):
```csharp
public abstract class ApiController : ControllerBase
{
    protected IActionResult ToActionResult<T>(Result<T> result)
    {
        return result.Error.Type switch
        {
            ErrorType.Validation => BadRequest(new { error = result.Error.Message }),
            ErrorType.NotFound => NotFound(new { error = result.Error.Message }),
            ErrorType.Conflict => Conflict(new { error = result.Error.Message }),
            ErrorType.Unauthorized => Unauthorized(new { error = result.Error.Message }),
            ErrorType.Forbidden => Forbid(),
            _ => StatusCode(500, new { error = "An error occurred" })
        };
    }
    
    protected IActionResult ToActionResult(Result result)
    {
        if (result.IsSuccess)
            return NoContent();
        
        return result.Error.Type switch
        {
            ErrorType.Validation => BadRequest(new { error = result.Error.Message }),
            ErrorType.NotFound => NotFound(new { error = result.Error.Message }),
            ErrorType.Conflict => Conflict(new { error = result.Error.Message }),
            ErrorType.Unauthorized => Unauthorized(new { error = result.Error.Message }),
            ErrorType.Forbidden => Forbid(),
            _ => StatusCode(500, new { error = "An error occurred" })
        };
    }
}
```

**Usage**:
```csharp
public class ProductsController : ApiController
{
    [HttpPost]
    public async Task<IActionResult> CreateProduct(CreateProductRequest request)
    {
        var command = new CreateProductCommand(...);
        var result = await _sender.Send(command);
        
        if (result.IsFailure)
            return ToActionResult(result);
        
        return CreatedAtAction(
            nameof(GetProduct), 
            new { id = result.Value }, 
            result.Value);
    }
}
```

### 9.3 Global Exception Handler

**For unhandled exceptions**:
```csharp
public class GlobalExceptionHandler : IExceptionHandler
{
    private readonly ILogger<GlobalExceptionHandler> _logger;
    
    public async ValueTask<bool> TryHandleAsync(
        HttpContext httpContext,
        Exception exception,
        CancellationToken ct)
    {
        _logger.LogError(exception, "Unhandled exception occurred");
        
        var problemDetails = new ProblemDetails
        {
            Status = StatusCodes.Status500InternalServerError,
            Title = "An error occurred while processing your request",
            Type = "https://tools.ietf.org/html/rfc7231#section-6.6.1"
        };
        
        httpContext.Response.StatusCode = StatusCodes.Status500InternalServerError;
        await httpContext.Response.WriteAsJsonAsync(problemDetails, ct);
        
        return true;
    }
}
```

---

## 10. Logging & Observability

### 10.1 Structured Logging with Serilog

**appsettings.json**:
```json
{
  "Serilog": {
    "Using": ["Serilog.Sinks.Console", "Serilog.Sinks.File"],
    "MinimumLevel": {
      "Default": "Information",
      "Override": {
        "Microsoft": "Warning",
        "Microsoft.EntityFrameworkCore": "Warning",
        "System": "Warning"
      }
    },
    "WriteTo": [
      {
        "Name": "Console",
        "Args": {
          "outputTemplate": "[{Timestamp:HH:mm:ss} {Level:u3}] {Message:lj} {Properties:j}{NewLine}{Exception}"
        }
      },
      {
        "Name": "File",
        "Args": {
          "path": "logs/markethub-.log",
          "rollingInterval": "Day",
          "outputTemplate": "{Timestamp:yyyy-MM-dd HH:mm:ss.fff zzz} [{Level:u3}] {Message:lj} {Properties:j}{NewLine}{Exception}"
        }
      }
    ],
    "Enrich": ["FromLogContext", "WithMachineName", "WithThreadId"]
  }
}
```

### 10.2 Request Logging Middleware

**Program.cs**:
```csharp
app.UseSerilogRequestLogging(options =>
{
    options.EnrichDiagnosticContext = (diagnosticContext, httpContext) =>
    {
        diagnosticContext.Set("UserAgent", httpContext.Request.Headers["User-Agent"]);
        diagnosticContext.Set("ClientIP", httpContext.Connection.RemoteIpAddress);
        
        var userId = httpContext.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (userId != null)
            diagnosticContext.Set("UserId", userId);
    };
});
```

### 10.3 Logging in Handlers

**Example**:
```csharp
public class CreateProductCommandHandler : IRequestHandler<CreateProductCommand, Result<Guid>>
{
    private readonly ILogger<CreateProductCommandHandler> _logger;
    
    public async Task<Result<Guid>> Handle(CreateProductCommand request, CancellationToken ct)
    {
        _logger.LogInformation(
            "Creating product for vendor {VendorId} with name {ProductName}",
            request.VendorId,
            request.Name);
        
        // ... logic
        
        if (result.IsFailure)
        {
            _logger.LogWarning(
                "Failed to create product: {ErrorCode} - {ErrorMessage}",
                result.Error.Code,
                result.Error.Message);
        }
        else
        {
            _logger.LogInformation(
                "Product created successfully with ID {ProductId}",
                result.Value);
        }
        
        return result;
    }
}
```

---

## 11. Security & Authentication

### 11.1 JWT Authentication

**Configuration** (appsettings.json):
```json
{
  "Jwt": {
    "SecretKey": "your-super-secret-key-at-least-32-characters-long",
    "Issuer": "MarketHub",
    "Audience": "MarketHubClients",
    "ExpiryInMinutes": 60
  }
}
```

**Registration** (Program.cs):
```csharp
builder.Services.AddJwtAuthentication(builder.Configuration);
```

### 11.2 Authorization Policies

**Built-in Policies**:
- `AdminOnly`: Requires "Admin" role
- `VendorOnly`: Requires "Vendor" role
- `CustomerOnly`: Requires "Customer" role

**Custom Policies**:
```csharp
services.AddAuthorization(options =>
{
    options.AddPolicy("VendorOrAdmin", policy =>
        policy.RequireRole("Vendor", "Admin"));
    
    options.AddPolicy("CanManageProducts", policy =>
        policy.Requirements.Add(new ProductManagementRequirement()));
});
```

**Usage**:
```csharp
[Authorize(Policy = "VendorOnly")]
[HttpPost("products")]
public async Task<IActionResult> CreateProduct(...)
{
    // Only vendors can access
}
```

### 11.3 Resource-Based Authorization

**For operations where authorization depends on resource ownership**:

**Example**: Vendor can only edit their own products.

**Requirement**:
```csharp
public class ProductOwnershipRequirement : IAuthorizationRequirement { }
```

**Handler**:
```csharp
public class ProductOwnershipHandler 
    : AuthorizationHandler<ProductOwnershipRequirement, Product>
{
    protected override Task HandleRequirementAsync(
        AuthorizationHandlerContext context,
        ProductOwnershipRequirement requirement,
        Product product)
    {
        var userIdClaim = context.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        
        if (userIdClaim == null)
            return Task.CompletedTask;
        
        var userId = Guid.Parse(userIdClaim);
        
        // Check if user is vendor and owns this product
        if (context.User.IsInRole("Vendor") && product.VendorId == userId)
        {
            context.Succeed(requirement);
        }
        
        return Task.CompletedTask;
    }
}
```

**Controller**:
```csharp
[HttpPut("products/{id}")]
[Authorize(Roles = "Vendor")]
public async Task<IActionResult> UpdateProduct(Guid id, UpdateProductRequest request)
{
    var product = await _productRepository.GetByIdAsync(id);
    
    if (product == null)
        return NotFound();
    
    // Check ownership
    var authResult = await _authorizationService.AuthorizeAsync(
        User, 
        product, 
        new ProductOwnershipRequirement());
    
    if (!authResult.Succeeded)
        return Forbid();
    
    // ... proceed with update
}
```

---

## 12. Code Standards & Conventions

### 12.1 Naming Conventions

**Projects**:
- `MarketHub.Modules.{ModuleName}.{Layer}`
- `MarketHub.BuildingBlocks.{Concern}`

**Namespaces**:
- Match folder structure
- `MarketHub.Modules.Catalog.Domain.Entities`

**Files**:
- One class per file
- File name matches class name
- Use PascalCase

**Classes**:
- PascalCase
- Aggregate roots end with aggregate name (e.g., `Order`, `Product`)
- Value objects end with value type (e.g., `Email`, `Money`)
- Commands end with `Command` (e.g., `CreateProductCommand`)
- Queries end with `Query` (e.g., `GetProductsQuery`)
- Handlers end with `Handler` (e.g., `CreateProductCommandHandler`)
- Events end with `Event` (e.g., `ProductCreatedDomainEvent`)

**Interfaces**:
- Start with `I` (e.g., `IProductRepository`)

**Private fields**:
- Use `_camelCase` (e.g., `_productRepository`)

**Constants**:
- Use `UPPER_CASE` (e.g., `SCHEMA`)

### 12.2 Code Organization

**Domain Layer**:
```
Domain/
├── Entities/
├── ValueObjects/
├── DomainEvents/
├── Repositories/        (interfaces only)
├── Errors/
├── Exceptions/
└── Specifications/
```

**Application Layer**:
```
Application/
├── Commands/
│   ├── CreateProduct/
│   │   ├── CreateProductCommand.cs
│   │   ├── CreateProductCommandHandler.cs
│   │   └── CreateProductCommandValidator.cs
│   └── UpdateProduct/
│       ├── UpdateProductCommand.cs
│       ├── UpdateProductCommandHandler.cs
│       └── UpdateProductCommandValidator.cs
├── Queries/
│   ├── GetProducts/
│   │   ├── GetProductsQuery.cs
│   │   └── GetProductsQueryHandler.cs
│   └── GetProductById/
│       ├── GetProductByIdQuery.cs
│       └── GetProductByIdQueryHandler.cs
├── DTOs/
├── Behaviors/
├── DomainEventHandlers/
├── IntegrationEventHandlers/
└── DependencyInjection.cs
```

### 12.3 Comments

**When to comment**:
- Complex business logic that isn't self-explanatory
- Why a certain approach was chosen (architectural decisions)
- TODO items with ticket numbers

**When NOT to comment**:
- Don't state the obvious
- Don't comment bad code - refactor it

**Example**:
```csharp
// GOOD
// Calculate commission based on vendor tier
// Platinum: 2%, Gold: 3%, Silver: 5%, Bronze: 7%
var commission = vendorTier switch
{
    VendorTier.Platinum => 0.02m,
    VendorTier.Gold => 0.03m,
    VendorTier.Silver => 0.05m,
    _ => 0.07m
};

// BAD
// Set the product name
product.Name = request.Name;
```

---

## 13. Development Workflow

### 13.1 Setting Up Development Environment

**Prerequisites**:
- .NET 8 SDK
- PostgreSQL 16+
- Redis 7+
- RabbitMQ 3.12+
- Docker (optional, for infrastructure)

**Steps**:
1. Clone repository
2. Run infrastructure via Docker Compose:
   ```bash
   docker-compose up -d
   ```
3. Update `appsettings.Development.json` with connection strings
4. Run migrations:
   ```bash
   dotnet run --project src/API/MarketHub.API
   ```
   (Migrations run automatically on startup)
5. Access Swagger: `https://localhost:5001/swagger`

### 13.2 Adding a New Module

**Checklist**:
1. Create module folder structure:
   - `{Module}.Domain`
   - `{Module}.Application`
   - `{Module}.Infrastructure`
   - `{Module}.Api`

2. **Domain Layer**:
   - Define entities, value objects
   - Define domain events
   - Define repository interfaces
   - Define module-specific errors

3. **Application Layer**:
   - Define commands/queries
   - Implement handlers
   - Define DTOs
   - Add validators
   - Implement domain event handlers
   - Register with DI

4. **Infrastructure Layer**:
   - Create DbContext (inherit from BaseDbContext)
   - Create entity configurations
   - Implement repositories
   - Create initial migration
   - Register with DI

5. **API Layer**:
   - Create controllers
   - Define request/response DTOs
   - Create module extensions
   - Create AssemblyReference

6. **Register in API Project**:
   - Add module registration in `Program.cs`
   - Add controller assembly to MVC

7. **Define Public Contracts**:
   - Define integration events
   - Define public interfaces (if needed)

8. **Write Tests**:
   - Unit tests for domain
   - Integration tests for module
   - E2E tests for workflows

### 13.3 Adding a New Feature to Existing Module

**Checklist**:
1. **Domain**: Add/modify entities if needed
2. **Application**: Create command/query + handler + validator
3. **API**: Add controller endpoint
4. **Tests**: Add unit/integration tests
5. **Documentation**: Update API docs

### 13.4 Database Migration Workflow

**Create Migration**:
```bash
dotnet ef migrations add {MigrationName} \
  --project src/Modules/{Module}/MarketHub.Modules.{Module}.Infrastructure \
  --startup-project src/API/MarketHub.API \
  --context {Module}DbContext \
  --output-dir Persistence/Migrations
```

**Review Migration**:
- Check generated SQL
- Ensure no accidental changes to other schemas

**Apply Migration**:
- Automatic on app startup (dev)
- Manual for production:
  ```bash
  dotnet ef database update \
    --project src/Modules/{Module}/MarketHub.Modules.{Module}.Infrastructure \
    --startup-project src/API/MarketHub.API \
    --context {Module}DbContext
  ```

### 13.5 Git Workflow

**Branching Strategy**:
- `main`: Production-ready code
- `develop`: Integration branch
- `feature/{module}-{feature-name}`: Feature branches
- `bugfix/{issue-number}`: Bug fixes
- `hotfix/{issue-number}`: Production hotfixes

**Commit Message Format**:
```
{module}: {short description}

{detailed description if needed}

Closes #{issue-number}
```

**Example**:
```
IAM: Add email verification flow

- Added EmailVerification entity
- Implemented VerifyEmailCommand
- Added verification email sending
- Added endpoint POST /api/identity/verify-email

Closes #42
```

### 13.6 Code Review Checklist

**Reviewer checks**:
- [ ] Follows clean architecture principles
- [ ] Domain logic is in domain layer
- [ ] No business logic in controllers
- [ ] Result pattern used correctly
- [ ] Error handling present
- [ ] Logging added
- [ ] Tests written
- [ ] Migration reviewed (if DB changes)
- [ ] No cross-module dependencies violated
- [ ] Integration events used for cross-module communication
- [ ] Public contracts documented

---

## Summary

This specification defines a **production-ready, scalable, maintainable multi-vendor e-commerce platform** using **Modular Monolith architecture with Clean Architecture per module**.

**Key Takeaways**:
1. Each module is isolated with clear boundaries
2. Modules communicate via integration events (RabbitMQ)
3. Each module has its own database schema
4. Result pattern eliminates exceptions for business logic
5. CQRS separates writes and reads
6. Outbox pattern ensures reliable event publishing
7. Comprehensive testing at all levels
8. Security via JWT with role-based authorization
9. Structured logging and observability
10. Clear migration path to microservices

**Next Steps**:
1. Set up solution structure
2. Implement BuildingBlocks
3. Implement IAM module (foundation)
4. Implement Catalog module
5. Implement remaining modules
6. Add tests
7. Deploy to staging
8. Launch MVP

This document serves as the **complete blueprint** for building the system. Every technical decision is documented, every pattern is explained, and every module structure is defined. Use this as your guide and reference throughout development.
