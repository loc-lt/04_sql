from __future__ import annotations

import argparse
import csv
import json
from datetime import datetime
from pathlib import Path

from sqlalchemy import text

from .benchmark_queries import BENCHMARK_QUERIES
from .config import BENCHMARK_OUTPUT_DIR
from .db import ensure_directory, get_engine


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Capture benchmark snapshots (runtime and execution plans)."
    )
    parser.add_argument(
        "--stage",
        choices=["baseline", "optimized"],
        required=True,
        help="Snapshot stage name.",
    )
    return parser.parse_args()


def run_explain(connection, query: str) -> dict:
    explain_query = f"EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON) {query}"
    result = connection.execute(text(explain_query)).scalar()
    return result[0]


def extract_metrics(plan: dict) -> tuple[float, float]:
    planning_time = float(plan.get("Planning Time", 0.0))
    execution_time = float(plan.get("Execution Time", 0.0))
    return planning_time, execution_time


def write_markdown_summary(output_path: Path, rows: list[dict]) -> None:
    lines = [
        "# Benchmark Snapshot",
        "",
        "| Query | Planning Time (ms) | Execution Time (ms) |",
        "| --- | ---: | ---: |",
    ]
    for row in rows:
        lines.append(
            f"| {row['query_name']} | {row['planning_time_ms']:.3f} | {row['execution_time_ms']:.3f} |"
        )
    output_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    args = parse_args()
    timestamp = datetime.utcnow().strftime("%Y%m%dT%H%M%SZ")
    stage_dir = BENCHMARK_OUTPUT_DIR / args.stage
    run_dir = stage_dir / timestamp
    plans_dir = run_dir / "plans"

    ensure_directory(plans_dir)

    summary_rows: list[dict] = []
    engine = get_engine()
    try:
        with engine.connect() as connection:
            for query_name, query_sql in BENCHMARK_QUERIES.items():
                plan = run_explain(connection, query_sql)
                planning_time, execution_time = extract_metrics(plan)

                (plans_dir / f"{query_name}.json").write_text(
                    json.dumps(plan, indent=2),
                    encoding="utf-8",
                )

                summary_rows.append(
                    {
                        "query_name": query_name,
                        "planning_time_ms": planning_time,
                        "execution_time_ms": execution_time,
                    }
                )
                print(
                    f"[{args.stage}] {query_name}: "
                    f"planning={planning_time:.3f} ms, execution={execution_time:.3f} ms"
                )
    finally:
        engine.dispose()

    csv_path = run_dir / "summary.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(
            file, fieldnames=["query_name", "planning_time_ms", "execution_time_ms"]
        )
        writer.writeheader()
        writer.writerows(summary_rows)

    write_markdown_summary(run_dir / "summary.md", summary_rows)
    print(f"Snapshot saved: {run_dir}")


if __name__ == "__main__":
    main()
