from __future__ import annotations

import os
from datetime import datetime
from pathlib import Path

try:
    from dotenv import load_dotenv
except ImportError:
    def load_dotenv(*args, **kwargs) -> bool:
        return False


BASE_DIR = Path(__file__).resolve().parents[1]
OUTPUT_DIR = BASE_DIR / "output"
BENCHMARK_OUTPUT_DIR = OUTPUT_DIR / "benchmarks"

load_dotenv(BASE_DIR / ".env")
load_dotenv(BASE_DIR.parent / ".env", override=False)

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME", "ecommerce_project03")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD", "postgres")
RANDOM_SEED = int(os.getenv("RANDOM_SEED", "42"))

DATABASE_URL = (
    f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

ORDER_START = datetime(2025, 8, 1, 0, 0, 0)
ORDER_END = datetime(2025, 10, 31, 23, 59, 59)
STATUS_VALUES = ["PLACED", "PAID", "SHIPPED", "DELIVERED", "CANCELLED", "RETURNED"]
STATUS_WEIGHTS = [0.25, 0.2, 0.25, 0.18, 0.08, 0.04]
