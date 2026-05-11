# Results Snapshot

This file is required submission evidence. Fill it after the full run; do not leave template placeholders in the final handoff.

## 1) Data generation checks

- Orders count:
- Order item count:
- Date range:
- Avg items per order:
- Sellers with fewer than 4 valid products:
- Invalid FK/business-rule checks:

## 2) Baseline vs optimized performance

Paste the output from:

```bash
poetry run python -m src.compare_benchmarks
```

Then add 2-3 notes explaining whether partition pruning and indexes were used in the important plans.

Reference files:
- `output/benchmarks/baseline/<timestamp>/summary.md`
- `output/benchmarks/optimized/<timestamp>/summary.md`
- `output/benchmarks/*/<timestamp>/plans/*.json`

## 3) Monthly Revenue Report

- Paste result table or screenshot note.

## 4) Daily Revenue Report

- Paste result table or screenshot note.

## 5) Seller Performance Report

- Paste top 10 sellers and values.

## 6) Top Products per Brand

- Paste sample output (at least 2 brands).

## 7) Order Status Summary

- Paste status distribution and revenue share.

## Notes

- Add any assumptions or anomalies observed during validation.
- Mention PostgreSQL version, machine class, and approximate load duration.
