# 01 — Input data and read layout

## FASTQ structure

A FASTQ record normally contains four lines:
1. Read identifier.
2. Nucleotide sequence.
3. Separator line beginning with `+`.
4. Per-base quality characters.

FASTQ quality scores encode the sequencing instrument's estimate of base-call confidence. FASTQ files may be compressed as `.fastq.gz` or `.fq.gz`.

## Identify the data

Useful commands:

```bash
find data -maxdepth 2 -type f
du -sh data/
seqkit stats -a data/*.fastq.gz
gzip -t data/sample.fastq.gz
```

For paired-end data, verify that R1 and R2 belong to the same sample and contain matching read identifiers in corresponding order. Do not assume filenames alone prove correct pairing.

## Sample sheet

Copy `samplesheet.example.csv`. Columns:

| Column | Meaning |
|---|---|
| sample | Unique, de-identified sample label |
| fastq_1 | R1 path for paired-end, or the only FASTQ for single-end |
| fastq_2 | R2 path for paired-end; blank for single-end |
| layout | `paired`, `single`, or `auto` |

Examples:

```csv
sample,fastq_1,fastq_2,layout
CASE_001,data/CASE_001_R1.fastq.gz,data/CASE_001_R2.fastq.gz,paired
CASE_002,data/CASE_002.fastq.gz,,single
CASE_003,data/CASE_003_R1.fastq.gz,data/CASE_003_R2.fastq.gz,auto
```

`auto` is a convenience based on whether `fastq_2` is supplied. It is not biological inference. Explicitly select the layout whenever it is known.

## Validation

```bash
python scripts/validate_samplesheet.py samplesheet.csv
```

The validator checks required columns, duplicate sample labels, file existence, and consistency between layout and FASTQ_2.

## Platform independence

The workflow accepts standard FASTQ files from Illumina, MGI/DNBSEQ, and other short-read platforms. Adapter sequences and quality characteristics vary by library preparation kit and instrument. Never apply a guessed adapter sequence. Obtain the correct library-kit documentation or inspect QC/overrepresented sequences before choosing trimming parameters.

## File naming and sample sheet notes

Use simple file paths without commas. The starter shell runner expects the sample sheet paths to be valid relative to the directory from which you launch the workflow, or absolute paths. Run commands from the repository root. Keep sample labels simple (letters, numbers, underscore, and hyphen).
