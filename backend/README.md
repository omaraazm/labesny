# labesny backend

FastAPI service holding the wardrobe and the outfit matching engine.

## Setup

    cd backend
    python3 -m venv .venv
    .venv/bin/pip install -r requirements.txt

Built against Python 3.13.

## Running

    cd backend
    .venv/bin/uvicorn labesny_api.main:app --host 0.0.0.0 --port 8000 --reload

`--host 0.0.0.0` matters: it makes the server reachable from your phone over WiFi,
not just from the Mac. Interactive API docs at http://localhost:8000/docs.

Run it from the `backend/` directory — `data/wardrobe.json` and `uploads/` are
resolved relative to the working directory.

## Endpoints

| Method | Path | Purpose |
|---|---|---|
| GET | `/items/` | List every wardrobe item |
| POST | `/items/` | Add an item (`type`, `color`, `dresscode`, `fit`, optional `image_url`) |
| DELETE | `/items/{id}` | Remove an item by id |
| GET | `/outfits/` | Every shirt/pants pairing, ranked by score |
| GET | `/outfits/random/` | One random pairing |
| GET | `/outfits/best/` | The highest-scoring pairing |
| GET | `/items/palettes/` | Each item with the colour palettes it belongs to |
| POST | `/upload-image/` | Upload a photo; returns the URL it's served at |
| GET | `/uploads/{filename}` | Uploaded photos (served statically) |

Colours are validated with `webcolors` + PIL, so `POST /items/` rejects anything
that isn't a recognisable colour name.

`/upload-image/` builds the returned URL from the host the request arrived on, so
a phone reaching the server over the LAN gets a LAN address rather than
`localhost`.

## Layout

    labesny_api/
      main.py              FastAPI app and routes
      models.py            Pydantic request/response models
      clothes.py           ClothingItem dataclass
      enums.py             ClothingType / DressCode / ClothingFit
      wardrobe.py          JSON file persistence
      wardrobe_manager.py  Add/remove/list, random outfit
      matching.py          Pairs shirts with pants
      scores.py            The scoring rubric
      rules.py             Colour/fit comparison helpers
      colors.py            Colour name → RGB, palette lookup
    data/wardrobe.json     The wardrobe (rewritten on every change)
    uploads/               Uploaded photos (contents gitignored)
    run.py                 Convenience launcher
    scripts/cli.py         Old interactive CLI, kept for reference
    tests/test_api.py      Manual smoke-test script

## Storage

A single JSON file (`data/wardrobe.json`), rewritten on every add or remove. One
global wardrobe — no users, no database, no auth. Anyone on your network can read
and write it.
