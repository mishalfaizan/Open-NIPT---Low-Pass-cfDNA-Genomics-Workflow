# Open NIPT & Low-Pass cfDNA Genomics Workflow

A modular, platform-agnostic educational repository for learning how to inspect FASTQ sequencing data, perform quality control, align short reads to a human reference genome, examine chromosome-level read representation, and understand the downstream steps of variant annotation and rare-disease research.

**Designed for:** Illumina, MGI/DNBSEQ, and other short-read FASTQ data, subject to library-preparation and platform-specific validation.

**Important:** This is an educational/research workflow, not a clinically validated NIPT pipeline or a diagnostic tool. Standard maternal-plasma NIPT data are mixtures of maternal and placental cfDNA. They are not equivalent to fetal whole-genome sequencing (WGS).

## What this repository does

The runnable starter workflow covers:

1. Input validation and read-layout selection.
2. Raw FASTQ quality control (FastQC).
3. Optional read preprocessing (fastp; outputs are kept separate from raw files).
4. Post-processing quality control (FastQC + MultiQC).
5. Short-read alignment to a user-supplied reference (BWA-MEM2).
6. BAM sorting, indexing and basic alignment statistics (SAMtools).
7. Optional coverage summaries (mosdepth).

The documentation then describes how to approach chromosome-level analysis, CNV analysis, variant discovery, functional annotation, rare-disease prioritisation, and genome visualisation. These downstream analyses are intentionally separated because their assumptions and data requirements differ.

## What this repository does NOT do

- It does not diagnose fetal or maternal conditions.
- It does not infer a complete fetal genome from ordinary NIPT data.
- It does not provide a validated fetal-fraction estimate or clinical aneuploidy call.
- It does not claim that generic germline variant callers can reliably genotype fetal variants in mixed maternal/placental cfDNA.
- It does not automatically call CNVs from one sample without an appropriate reference cohort, validated normalisation, and platform/library-specific controls.
- It does not upload FASTQ data to GitHub or any public service.

## Repository map

```text
.
├── README.md
├── LICENSE
├── CITATION.cff
├── .gitignore
├── environment.yml
├── samplesheet.example.csv
├── config/
│   └── config.example.env
├── docs/
│   ├── 00_scope_and_safety.md
│   ├── 01_input_and_read_layout.md
│   ├── 02_quality_control.md
│   ├── 03_preprocessing.md
│   ├── 04_reference_and_alignment.md
│   ├── 05_chromosome_and_cnv_analysis.md
│   ├── 06_variant_discovery.md
│   ├── 07_functional_annotation.md
│   ├── 08_rare_disease_prioritisation.md
│   ├── 09_visualisation_and_reporting.md
│   └── 10_reproducibility_and_next_steps.md
└── scripts/
    ├── check_dependencies.sh
    ├── validate_samplesheet.py
    └── run_workflow.sh
```

## Quick start

### 1. Install tools

A Linux environment is recommended for reproducible genomics work. macOS can be used for learning and smaller datasets. For larger FASTQ files, use a workstation/server with sufficient RAM, CPU, and storage.

Install Conda/Miniforge or use Homebrew on macOS.

**Conda/Miniforge route:**

```bash
conda env create -f environment.yml
conda activate nipt-genomics
```

**Homebrew route (macOS):**

```bash
brew install fastqc fastp seqkit bwa-mem2 samtools mosdepth
python3 -m pip install --user multiqc
```

If Homebrew does not provide a formula for a tool on your macOS/CPU combination, use its official installation instructions or the Conda route. Apple Silicon and Intel package availability can differ. For larger human-genome datasets, a Linux workstation/server is often more practical than a laptop.

Check the installed tools:

```bash
bash scripts/check_dependencies.sh
```

The environment includes FastQC, fastp, MultiQC, SeqKit, BWA-MEM2, SAMtools, and mosdepth. Conda package availability can differ by operating system and CPU architecture; consult the relevant tool documentation if a package is unavailable.

### 2. Prepare the sample sheet

Copy the example:

```bash
cp samplesheet.example.csv samplesheet.csv
```

Edit it to point to your FASTQ files. The `layout` column is mandatory and accepts:

- `paired` — two files per sample (R1 and R2).
- `single` — one file per sample.
- `auto` — infer paired-end when `fastq_2` is supplied, otherwise single-end.

Example paired-end:

```csv
sample,fastq_1,fastq_2,layout
SAMPLE_A,data/SAMPLE_A_R1.fastq.gz,data/SAMPLE_A_R2.fastq.gz,paired
```

Example single-end:

```csv
sample,fastq_1,fastq_2,layout
SAMPLE_B,data/SAMPLE_B.fastq.gz,,single
```

**Terminology:** “single-end” and “paired-end” describe sequencing read layout. They do not mean one-directional versus bidirectional DNA analysis, and paired-end sequencing does not by itself establish strand-specific library preparation.

### 3. Obtain a compatible reference genome

Use a reference assembly appropriate to your study (commonly GRCh38 for current human-genomics work). Download the FASTA and its matching annotation/resources from a trusted source such as NCBI or Ensembl.

Record:
- Assembly name and release/version.
- Download source and date.
- FASTA filename and checksum.
- Whether contig names use `chr1` or `1` style.
- Any decoy, alternate, or mitochondrial contigs included.

Do not mix GRCh37/hg19 and GRCh38/hg38 coordinates or resources. The starter workflow builds BWA-MEM2 indexes beside the supplied FASTA.

### 4. Run the workflow

```bash
python scripts/validate_samplesheet.py samplesheet.csv
```

Then:

```bash
bash scripts/run_workflow.sh \
  --samplesheet samplesheet.csv \
  --reference reference/GRCh38.fa \
  --outdir results \
  --threads 4 \
  --trim
```

Omit `--trim` to run QC and alignment on original reads without fastp preprocessing:

```bash
bash scripts/run_workflow.sh \
  --samplesheet samplesheet.csv \
  --reference reference/GRCh38.fa \
  --outdir results \
  --threads 4
```

The script never overwrites the input FASTQ files. It writes derived files under the output directory.

### 5. Inspect outputs

```text
results/
├── qc_raw/
├── trimmed_fastq/       # only if --trim is selected
├── qc_trimmed/          # only if --trim is selected
├── alignment/
├── coverage/            # mosdepth summaries
└── multiqc/
```

Important outputs include:
- FastQC HTML reports.
- MultiQC HTML report.
- fastp HTML/JSON reports when trimming is enabled.
- Coordinate-sorted BAM and BAM index.
- SAMtools alignment statistics.
- mosdepth coverage summaries.

## Recommended learning order

1. Read `docs/00_scope_and_safety.md`.
2. Complete `docs/01_input_and_read_layout.md`.
3. Run the starter workflow and study `docs/02_quality_control.md`.
4. Understand trimming decisions in `docs/03_preprocessing.md`.
5. Study alignment and reference-build consistency in `docs/04_reference_and_alignment.md`.
6. Only then explore chromosome/CNV analysis in `docs/05_chromosome_and_cnv_analysis.md`.
7. Treat variant discovery, annotation, and rare-disease prioritisation as separate modules with stricter data requirements.

## Data privacy

Human sequencing files are sensitive genomic data. Do not commit FASTQ, BAM, CRAM, VCF, clinical metadata, sample identifiers, or patient reports to a public GitHub repository. Keep data outside the repository or in access-controlled storage. The `.gitignore` excludes common genomic data formats, but it is not a substitute for checking `git status` before every commit.

## Suggested GitHub description

> Modular educational workflow for short-read human cfDNA/NIPT data: FASTQ QC, preprocessing, reference alignment, chromosome-level analysis concepts, variant annotation resources, and reproducible research documentation.

## Disclaimer

This repository is for education and research method development only. Clinical NIPT interpretation requires validated assays, appropriate controls/reference cohorts, quality thresholds, confirmatory testing where indicated, and qualified clinical laboratory oversight. See `docs/00_scope_and_safety.md`.
