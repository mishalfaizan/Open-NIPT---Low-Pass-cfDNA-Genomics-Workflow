# 06 — Variant discovery: separate germline-WGS learning module

## Important limitation for NIPT

Standard germline callers generally assume reads derive from one diploid individual. Maternal-plasma cfDNA is a mixture dominated by maternal DNA with a smaller placental contribution. Consequently, a conventional germline VCF from NIPT reads cannot be treated as a fetal genotype callset.

Use NIPT data to learn file formats and software mechanics only. Do not use exploratory calls to diagnose or exclude fetal disease.

## Learn with an appropriate dataset

For a separate high-quality WGS dataset (or suitable WES dataset), study:
- GATK germline short-variant best practices: https://gatk.broadinstitute.org/
- DeepVariant: https://github.com/google/deepvariant
- FreeBayes: https://github.com/freebayes/freebayes
- BCFtools: https://samtools.github.io/bcftools/

## Typical conceptual workflow

1. QC and align reads.
2. Mark duplicates where appropriate and document the method.
3. Assess coverage and sample contamination.
4. Call SNPs and indels using a caller validated for the data type.
5. Filter variants using genotype quality, depth, allele balance, mapping quality, and caller-specific evidence.
6. Normalise and left-align variants.
7. Validate sample identity/relatedness and assess callset quality.
8. Annotate variants.

Do not apply a generic minimum depth or allele-fraction threshold without considering the assay and validation. Duplicate handling and base-quality recalibration are workflow-specific; follow the selected caller's current best-practice documentation.
