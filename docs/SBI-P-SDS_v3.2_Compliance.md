# P124 V0.013 - SBI-P-SDS v3.2 Compliance

## Stable baseline

- Development baseline: P124 V0.7.
- General play behavior and existing database objects are retained.
- Red vs. White is an additive, front-end-only mode.

## Web versioning

- Visible label: `P124 Web Version V0.013`.
- `styles.css`, `demo-data.js`, and `app.js` use cache-busting parameter `v=0.013`.
- Package version and visible Web Version are aligned.

## Configuration and delivery

- The package contains `config-sample.js` only.
- Deployment-specific `config.js` remains excluded by `.gitignore`.
- The ZIP uses a same-named outer folder.
- README, `database/`, `docs/`, front-end files, and GeoJSON sources are retained.
- The established A3 portrait poster is included in PDF and SVG formats under `docs/`.

## Project isolation

- No database migration is required for Red vs. White.
- No table, view, RPC, policy, trigger, Edge Function, or Storage object is added or changed.
- Existing SQL remains scoped to P124 objects.
- V0.013 adds only local Natural Earth Great Lakes display data; no database migration is required.

## Authentication

- P124 remains a public activity and does not add authentication.
- No account data, team name, score, or match result is written to Supabase.

## Match data

- Scores, turn order, used questions, timer state, and results exist only in browser memory for the current match.
- Starting a new match or leaving the mode clears the current match state.
