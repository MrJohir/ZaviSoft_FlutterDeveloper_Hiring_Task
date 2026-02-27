# Daraz-Style Product Listing

Flutter app mimicking Daraz's product listing — collapsible header, sticky tabs, swipeable category tabs, single scroll. Built with [FakeStore API](https://fakestoreapi.com/).

## Run

```bash
flutter pub get
flutter run
```

Credentials: `mor_2314` / `83r5^_`

## Structure

```
lib/
├── main.dart
└── app/
    ├── data/
    │   ├── models/
    │   ├── providers/       # raw HTTP calls
    │   └── repositories/    # JSON parsing, returns models
    ├── modules/
    │   ├── login/
    │   ├── home/
    │   ├── profile/
    │   ├── product_details/
    │   └── cart/
    └── routes/
```

Using GetX for state management and routing. MVC pattern — Provider does HTTP, Repository parses JSON, Controller holds state, View renders widgets.

---

## Scroll Architecture

### Who owns the vertical scroll?

`NestedScrollView`. That's it — one scrollable for the whole screen.

It handles both the collapsing header (outer) and the per-tab product grids (inner) through a single scroll chain. No competing `ScrollController`s, no manual offset hacks.

```
NestedScrollView
├─ header:
│  └─ SliverOverlapAbsorber → SliverAppBar
│     ├─ flexibleSpace → banner + search
│     └─ bottom → TabBar (stays pinned)
└─ body:
   └─ RefreshIndicator
      └─ TabBarView
         ├─ Tab "All" → CustomScrollView + SliverOverlapInjector + SliverGrid
         ├─ Tab "electronics" → ...
         └─ etc.
```

`SliverOverlapAbsorber` wraps the app bar so each tab can use `SliverOverlapInjector` to know how much space the pinned header takes — no hardcoded pixels.

Each tab has a `PageStorageKey` so scroll position is remembered when switching tabs.

### How does horizontal swipe work?

`TabBarView` owns horizontal drag, `NestedScrollView` owns vertical drag. Flutter's gesture system figures out which direction you're dragging before committing, so they don't fight each other.

Both tab tapping and swiping go through the same `TabController`, so they're always in sync.

### Pull-to-refresh

The `RefreshIndicator` wraps `TabBarView` with two important things:

- `notificationPredicate: depth == 1` — scroll events from each tab's `CustomScrollView` pass through TabBarView's PageView, so they arrive at depth 1 instead of the default 0. Without this, pull-to-refresh simply won't fire.
- `edgeOffset` set to the pinned header height — so the loading spinner shows below the tab bar, not behind it.

Refresh reloads everything (all tabs), keeps things simple and consistent.

---

## Trade-offs

- **Header won't fully collapse with very few items** — that's a NestedScrollView thing. Not an issue here since FakeStore has enough products.
- **Full reload on refresh** — I reload all tabs at once instead of just the active one. Easier to keep data in sync.
- **No pagination** — FakeStore doesn't support it. Would add infinite scroll with cursor pagination in production.
- **FakeStore login returns 201** — handled both 200 and 201 in the provider.
- **Each tab needs CustomScrollView + SliverOverlapInjector** — can't just use a simple ListView. That's the cost of getting single-scroll right.
- **depth == 1 assumption** — works because TabBarView adds exactly one PageView layer. Would need to change if the widget tree structure changes.

## Packages

| Package | Why |
|---------|-----|
| `get` | State, routing, DI |
| `http` | API calls |
| `get_storage` | Token storage |
| `cached_network_image` | Image caching |
