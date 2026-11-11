# 00 — Scope, assumptions, and safety

## The key distinction: NIPT cfDNA is not fetal WGS

Maternal-plasma cell-free DNA (cfDNA) used for non-invasive prenatal testing is a mixture. Most circulating cfDNA is maternal; the pregnancy-associated fraction is largely placental in origin and is used as a proxy for fetal chromosome representation.

Consequences:
- Reads cannot automatically be assigned to the fetus.
- Maternal variants can dominate a mixed-sample variant callset.
- Placental mosaicism, maternal CNVs, maternal malignancy, vanishing twin, and other biological or technical factors can affect results.
- A chromosome-level signal is a screening observation, not a definitive fetal diagnosis.
- Ordinary diploid genotype assumptions may fail in mixed cfDNA.

## What is reasonable to learn from low-pass NIPT data?

Depending on assay design, sequencing depth, fetal fraction, library preparation, controls, and validated methods:
- Read quality and mapping metrics.
- Chromosome-specific read representation.
- GC and mappability bias.
- Some large chromosome-level gains/losses using a validated method and suitable reference cohort.
- Exploratory coverage patterns.

Do not assume that low-pass NIPT data can support:
- Comprehensive fetal SNV/indel discovery.
- Reliable fetal zygosity or genotype calls.
- Runs-of-homozygosity (ROH) analysis of the fetus.
- Comprehensive rare-disease screening.
- Reliable small CNV detection.

## Single-end versus paired-end

These terms refer to how a DNA fragment is sequenced:
- Single-end: one read is generated from each fragment.
- Paired-end: reads are generated from both ends of a fragment, usually labelled R1 and R2.

Paired-end data can improve alignment and fragment-level information, but does not make mixed maternal/placental reads fetal-specific. Neither layout alone indicates strand-specific sequencing.

## Research and clinical boundaries

This repository is not a clinical pipeline. Do not use its outputs to make pregnancy-management decisions, diagnose a fetus, or report pathogenic variants. Clinical interpretation requires a validated assay, documented performance characteristics, appropriate controls, qualified review, and confirmatory testing when indicated.

## Privacy and consent

Genomic data can identify a person and relatives. Use only data you are authorised to analyse. Prefer de-identified sample codes, encrypted storage, restricted access, and local processing. Never publish raw human FASTQ/BAM/CRAM/VCF data, identifying metadata, or clinical reports in a public repository.
