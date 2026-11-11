#!/usr/bin/env python3
"""Validate a CSV sample sheet for single-end and paired-end FASTQ inputs."""

import csv
import sys
from pathlib import Path

REQUIRED = {"sample", "fastq_1", "fastq_2", "layout"}
VALID_LAYOUTS = {"single", "paired", "auto"}

def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)

def main() -> None:
    if len(sys.argv) != 2:
        fail("Usage: python scripts/validate_samplesheet.py samplesheet.csv")

    sheet = Path(sys.argv[1]).expanduser().resolve()
    if not sheet.is_file():
        fail(f"Sample sheet not found: {sheet}")

    with sheet.open(newline="") as handle:
        reader = csv.DictReader(handle)
        if not reader.fieldnames:
            fail("CSV has no header.")
        missing = REQUIRED - set(reader.fieldnames)
        if missing:
            fail(f"Missing columns: {', '.join(sorted(missing))}")

        rows = list(reader)

    if not rows:
        fail("No sample rows found.")

    seen = set()
    errors = []
    for line_number, row in enumerate(rows, start=2):
        sample = (row.get("sample") or "").strip()
        r1 = (row.get("fastq_1") or "").strip()
        r2 = (row.get("fastq_2") or "").strip()
        layout = (row.get("layout") or "").strip().lower()

        if not sample:
            errors.append(f"Line {line_number}: sample is blank.")
            continue
        if sample in seen:
            errors.append(f"Line {line_number}: duplicate sample label '{sample}'.")
        seen.add(sample)

        if layout not in VALID_LAYOUTS:
            errors.append(f"Line {line_number}: layout must be single, paired, or auto.")
            continue
        if not r1:
            errors.append(f"Line {line_number}: fastq_1 is required.")
            continue

        resolved_r1 = Path(r1).expanduser()
        if not resolved_r1.is_file():
            errors.append(f"Line {line_number}: fastq_1 does not exist: {r1}")

        if layout == "paired" and not r2:
            errors.append(f"Line {line_number}: paired layout requires fastq_2.")
        if layout == "single" and r2:
            errors.append(f"Line {line_number}: single layout requires blank fastq_2.")
        if layout == "auto" and not r2:
            pass

        if r2:
            resolved_r2 = Path(r2).expanduser()
            if not resolved_r2.is_file():
                errors.append(f"Line {line_number}: fastq_2 does not exist: {r2}")

    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        raise SystemExit(1)

    print(f"Validated {len(rows)} sample(s).")
    for row in rows:
        layout = row["layout"].strip().lower()
        inferred = "paired" if row["fastq_2"].strip() else "single"
        final_layout = inferred if layout == "auto" else layout
        print(f"  {row['sample'].strip()}: {final_layout}")

if __name__ == "__main__":
    main()
