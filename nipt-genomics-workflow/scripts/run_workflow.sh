#!/usr/bin/env bash
# Educational short-read workflow: raw QC -> optional fastp -> alignment -> coverage.
# Does not perform clinical NIPT interpretation, CNV calling, or fetal genotyping.

set -euo pipefail

SAMPLESHEET=""
REFERENCE=""
OUTDIR="results"
THREADS=4
TRIM=0

usage() {
  cat <<'EOF'
Usage:
  bash scripts/run_workflow.sh --samplesheet samplesheet.csv --reference reference.fa [options]

Required:
  --samplesheet FILE   CSV with sample,fastq_1,fastq_2,layout
  --reference FILE     Reference FASTA (GRCh38 recommended for a new project)

Options:
  --outdir DIR         Output directory (default: results)
  --threads N          Threads per sample (default: 4)
  --trim               Run fastp and align processed reads
  -h, --help           Show this help

Layouts in sample sheet:
  paired  = fastq_1 and fastq_2
  single  = fastq_1 only
  auto    = paired if fastq_2 is present, otherwise single
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --samplesheet) SAMPLESHEET="$2"; shift 2 ;;
    --reference) REFERENCE="$2"; shift 2 ;;
    --outdir) OUTDIR="$2"; shift 2 ;;
    --threads) THREADS="$2"; shift 2 ;;
    --trim) TRIM=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

[[ -n "$SAMPLESHEET" && -n "$REFERENCE" ]] || { usage; exit 1; }
[[ -f "$SAMPLESHEET" ]] || { echo "Sample sheet not found: $SAMPLESHEET" >&2; exit 1; }
[[ -f "$REFERENCE" ]] || { echo "Reference FASTA not found: $REFERENCE" >&2; exit 1; }
[[ "$THREADS" =~ ^[1-9][0-9]*$ ]] || { echo "Threads must be a positive integer." >&2; exit 1; }

for tool in fastqc fastp multiqc seqkit bwa-mem2 samtools mosdepth python; do
  command -v "$tool" >/dev/null 2>&1 || { echo "Missing dependency: $tool" >&2; exit 1; }
done

python scripts/validate_samplesheet.py "$SAMPLESHEET"

mkdir -p "$OUTDIR"/{qc_raw,trimmed_fastq,qc_trimmed,alignment,coverage,multiqc,logs}
REF_ABS="$(cd "$(dirname "$REFERENCE")" && pwd)/$(basename "$REFERENCE")"

# Build BWA-MEM2 index if the expected index files are not present.
if [[ ! -f "${REF_ABS}.0123" && ! -f "${REF_ABS}.bwt.2bit.64" ]]; then
  echo "Building BWA-MEM2 index..."
  bwa-mem2 index "$REF_ABS"
fi

# Raw QC on all FASTQs in the sample sheet.
python - "$SAMPLESHEET" <<'PY' > "$OUTDIR/logs/fastq_list.txt"
import csv, sys
with open(sys.argv[1], newline="") as f:
    for row in csv.DictReader(f):
        print(row["fastq_1"])
        if row.get("fastq_2", "").strip():
            print(row["fastq_2"])
PY

FASTQS=()
while IFS= read -r fq; do
  [[ -n "$fq" ]] && FASTQS[${#FASTQS[@]}]="$fq"
done < "$OUTDIR/logs/fastq_list.txt"
fastqc --threads "$THREADS" --outdir "$OUTDIR/qc_raw" "${FASTQS[@]}"
multiqc "$OUTDIR/qc_raw" --outdir "$OUTDIR/multiqc/raw"

while IFS=',' read -r SAMPLE R1 R2 LAYOUT; do
  [[ "$SAMPLE" == "sample" ]] && continue
  [[ -n "$SAMPLE" ]] || continue

  # Remove simple surrounding whitespace and CSV quote characters.
  SAMPLE="$(echo "$SAMPLE" | sed 's/^"//;s/"$//;s/^[[:space:]]*//;s/[[:space:]]*$//')"
  R1="$(echo "$R1" | sed 's/^"//;s/"$//;s/^[[:space:]]*//;s/[[:space:]]*$//')"
  R2="$(echo "$R2" | sed 's/^"//;s/"$//;s/^[[:space:]]*//;s/[[:space:]]*$//')"
  LAYOUT="$(echo "$LAYOUT" | tr '[:upper:]' '[:lower:]' | tr -d '"[:space:]')"

  [[ "$LAYOUT" == "auto" ]] && { [[ -n "$R2" ]] && LAYOUT="paired" || LAYOUT="single"; }

  if [[ "$TRIM" -eq 1 ]]; then
    OUT_R1="$OUTDIR/trimmed_fastq/${SAMPLE}.R1.trimmed.fastq.gz"
    OUT_R2="$OUTDIR/trimmed_fastq/${SAMPLE}.R2.trimmed.fastq.gz"
    if [[ "$LAYOUT" == "paired" ]]; then
      fastp -i "$R1" -I "$R2" -o "$OUT_R1" -O "$OUT_R2" \
        --html "$OUTDIR/trimmed_fastq/${SAMPLE}.fastp.html" \
        --json "$OUTDIR/trimmed_fastq/${SAMPLE}.fastp.json" \
        --thread "$THREADS" 2>&1 | tee "$OUTDIR/logs/${SAMPLE}.fastp.log"
      R1="$OUT_R1"; R2="$OUT_R2"
    else
      fastp -i "$R1" -o "$OUT_R1" \
        --html "$OUTDIR/trimmed_fastq/${SAMPLE}.fastp.html" \
        --json "$OUTDIR/trimmed_fastq/${SAMPLE}.fastp.json" \
        --thread "$THREADS" 2>&1 | tee "$OUTDIR/logs/${SAMPLE}.fastp.log"
      R1="$OUT_R1"; R2=""
    fi
    fastqc --threads "$THREADS" --outdir "$OUTDIR/qc_trimmed" "$R1" ${R2:+"$R2"}
  fi

  BAM="$OUTDIR/alignment/${SAMPLE}.sorted.bam"
  if [[ "$LAYOUT" == "paired" ]]; then
    bwa-mem2 mem -t "$THREADS" "$REF_ABS" "$R1" "$R2" 2> "$OUTDIR/logs/${SAMPLE}.bwa.log" \
      | samtools view -b - \
      | samtools sort -@ "$THREADS" -o "$BAM" -
  else
    bwa-mem2 mem -t "$THREADS" "$REF_ABS" "$R1" 2> "$OUTDIR/logs/${SAMPLE}.bwa.log" \
      | samtools view -b - \
      | samtools sort -@ "$THREADS" -o "$BAM" -
  fi

  samtools index "$BAM"
  samtools flagstat "$BAM" > "$OUTDIR/alignment/${SAMPLE}.flagstat.txt"
  samtools stats "$BAM" > "$OUTDIR/alignment/${SAMPLE}.stats.txt"
  samtools idxstats "$BAM" > "$OUTDIR/alignment/${SAMPLE}.idxstats.txt"
  mosdepth --threads "$THREADS" "$OUTDIR/coverage/${SAMPLE}" "$BAM"

done < "$SAMPLESHEET"

if [[ "$TRIM" -eq 1 ]]; then
  multiqc "$OUTDIR/qc_trimmed" "$OUTDIR/trimmed_fastq" --outdir "$OUTDIR/multiqc/processed"
fi

echo "Workflow complete. Review reports under: $OUTDIR"
