# 03 — Read preprocessing

## Why preprocess?

Adapter contamination and low-quality read tails can reduce mapping quality. `fastp` can filter and trim reads while producing an HTML and JSON report.

## Important decision

Do not trim automatically just because a QC tool shows a warning. Preserve original FASTQ files and compare raw versus processed QC. Over-trimming can remove useful cfDNA-derived sequence and alter read representation.

## Paired-end example

```bash
fastp \
  -i data/sample_R1.fastq.gz \
  -I data/sample_R2.fastq.gz \
  -o results/trimmed_fastq/sample_R1.trimmed.fastq.gz \
  -O results/trimmed_fastq/sample_R2.trimmed.fastq.gz \
  --html results/trimmed_fastq/sample.fastp.html \
  --json results/trimmed_fastq/sample.fastp.json \
  --thread 4
```

## Single-end example

```bash
fastp \
  -i data/sample.fastq.gz \
  -o results/trimmed_fastq/sample.trimmed.fastq.gz \
  --html results/trimmed_fastq/sample.fastp.html \
  --json results/trimmed_fastq/sample.fastp.json \
  --thread 4
```

## Platform/library-specific adapters

Adapter sequences depend on the library preparation kit and sequencing configuration. MGI/DNBSEQ data are not defined by one universal adapter sequence. Use the exact kit documentation or validated laboratory configuration. Do not copy adapter sequences from an unrelated kit.

After preprocessing, run FastQC and MultiQC again. Compare:
- Reads retained.
- Bases retained.
- Quality distribution.
- GC distribution.
- Adapter content.
- Read length distribution.

Keep raw and processed reports side by side.
