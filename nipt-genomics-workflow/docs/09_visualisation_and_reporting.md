# 09 — Visualisation and reporting

## Useful visualisation tools

- IGV: read-level alignment inspection — https://igv.org/
- Circos: circular genome plots — https://circos.ca/
- R packages: ggplot2, karyoploteR, RIdeogram.
- Python: pandas, matplotlib, seaborn (for research plots), Plotly.

## Recommended plots

1. FastQC and MultiQC quality summaries.
2. Read depth and coverage distribution.
3. Mapping and duplication metrics.
4. Chromosome-level normalised read representation.
5. GC bias versus coverage.
6. CNV segment plot, only when supported by an appropriate validated analysis.
7. Variant consequence summaries for suitable WGS/WES datasets.

## Reporting template

Every report should state:
- Research purpose and sample type.
- Consent/authorisation and de-identification status.
- Sequencing platform and library preparation kit, if known.
- Read layout (single-end or paired-end).
- Reference assembly and version.
- Tool versions and exact commands/configuration.
- QC findings and limitations.
- Whether data were trimmed and why.
- Alignment and coverage metrics.
- Reference cohort and normalisation method for chromosome analysis.
- Uncertainty, limitations, and any confirmatory testing required.

Do not label an exploratory NIPT signal as a diagnosis.
