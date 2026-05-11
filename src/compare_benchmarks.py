from __future__ import annotations

import argparse
import csv
from pathlib import Path

from .config import BENCHMARK_OUTPUT_DIR


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Compare latest baseline and optimized benchmark summaries."
    )
    parser.add_argument(
        "--baseline-dir",
        type=Path,
        default=None,
        help="Optional explicit baseline run directory containing summary.csv.",
    )
    parser.add_argument(
        "--optimized-dir",
        type=Path,
        default=None,
        help="Optional explicit optimized run directory containing summary.csv.",
    )
    return parser.parse_args()


def latest_run_dir(stage: str) -> Path:
    stage_dir = BENCHMARK_OUTPUT_DIR / stage
    candidates = sorted(path for path in stage_dir.glob("*") if path.is_dir())
    if not candidates:
        raise FileNotFoundError(f"No benchmark runs found under {stage_dir}")
    return candidates[-1]


def read_summary(run_dir: Path) -> dict[str, float]:
    summary_path = run_dir / "summary.csv"
    if not summary_path.exists():
        raise FileNotFoundError(f"Missing summary.csv: {summary_path}")

    with summary_path.open(newline="", encoding="utf-8") as file:
        reader = csv.DictReader(file)
        return {
            row["query_name"]: float(row["execution_time_ms"])
            for row in reader
        }


def format_delta(baseline_ms: float, optimized_ms: float) -> tuple[float, str]:
    delta_pct = ((optimized_ms - baseline_ms) / baseline_ms) * 100 if baseline_ms else 0.0
    direction = "faster" if delta_pct < 0 else "slower"
    return abs(delta_pct), direction


def main() -> None:
    args = parse_args()
    baseline_dir = args.baseline_dir or latest_run_dir("baseline")
    optimized_dir = args.optimized_dir or latest_run_dir("optimized")

    baseline = read_summary(baseline_dir)
    optimized = read_summary(optimized_dir)

    print(f"Baseline:  {baseline_dir}")
    print(f"Optimized: {optimized_dir}")
    print()
    print("| Query | Baseline ms | Optimized ms | Change |")
    print("| --- | ---: | ---: | ---: |")

    for query_name in sorted(baseline):
        if query_name not in optimized:
            print(f"| {query_name} | {baseline[query_name]:.3f} | missing | n/a |")
            continue
        change_pct, direction = format_delta(baseline[query_name], optimized[query_name])
        print(
            f"| {query_name} | {baseline[query_name]:.3f} | "
            f"{optimized[query_name]:.3f} | {change_pct:.1f}% {direction} |"
        )


if __name__ == "__main__":
    main()
