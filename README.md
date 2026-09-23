# labesny

An iOS app for outfit generation from your own wardrobe. Photograph your clothes,
and the app pairs them into scored outfits based on colour, dress code, and fit.

Runs as a single-user app on your local network: a SwiftUI iOS app talking to a
FastAPI backend on your Mac.

## Layout

    ios/        SwiftUI app (Xcode project, target "labesny")
    backend/    FastAPI service: wardrobe storage + the outfit matching engine

Setup instructions live in each half: [ios/README.md](ios/README.md) and
[backend/README.md](backend/README.md).

## Quick start

1. Start the backend (see `backend/README.md`) — it listens on port 8000.
2. Create `ios/labesny/Secrets.swift` (gitignored — see `ios/README.md`) pointing
   at your Mac's current LAN IP.
3. Open `ios/labesny.xcodeproj` and run on an iPhone simulator.

## How matching works

The backend scores every shirt/pants pair out of 15 and returns them ranked:

| Factor | Points |
|---|---|
| Same colour | 3 |
| Colours share a palette | 5 |
| Same dress code | 5 |
| Casual top / formal bottom | 4 |
| Formal top / casual bottom | 3 |
| Same fit | 5 |
| Regular ↔ oversized | 4 |
| Slim + regular, or slim + oversized | 3 |

Every pair scores at least 6, so nothing is ever filtered out — items are ranked,
not rejected. Colour matching converts names to RGB and checks proximity against
three palettes (`Set3_12`, `Tableau_10`, `Balance_20`).

## Current scope

- Single user, no accounts — one shared wardrobe, no authentication
- Shirts and pants only; shoes and other types aren't modelled yet
- Local network only — the backend isn't deployed anywhere
- The trip-planning screens are an unfinished mockup, not wired to real data
