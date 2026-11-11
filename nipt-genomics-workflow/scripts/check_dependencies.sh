#!/usr/bin/env bash
set -euo pipefail

tools=(fastqc fastp seqkit multiqc bwa-mem2 samtools mosdepth python)
missing=0

for tool in "${tools[@]}"; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf "FOUND  %-12s %s\n" "$tool" "$(command -v "$tool")"
  else
    printf "MISSING %-12s\n" "$tool"
    missing=1
  fi
done

if [[ "$missing" -ne 0 ]]; then
  echo "One or more dependencies are missing. See README.md."
  exit 1
fi

echo "Dependency check complete."
