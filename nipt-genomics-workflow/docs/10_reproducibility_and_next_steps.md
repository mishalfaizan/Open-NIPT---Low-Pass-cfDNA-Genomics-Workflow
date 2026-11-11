# 10 — Reproducibility and next steps

## Record software versions

```bash
fastqc --version
fastp --version
seqkit version
bwa-mem2 version
samtools --version
mosdepth --version
multiqc --version
```

Save the environment specification and command log with each research run. Consider adopting Nextflow or Snakemake for larger projects and containerised execution.

## Suggested extensions

1. Add a workflow manager (Nextflow or Snakemake).
2. Add reference checksum verification.
3. Add automated read-pair synchronisation checks.
4. Add mosdepth coverage plots.
5. Add a reproducible R notebook for chromosome-level plots.
6. Evaluate WISECONDORX/NIPTeR using suitable reference cohorts and published validation.
7. Build a separate WGS/WES variant-calling module.
8. Add VEP annotation and a structured variant review table.
9. Add HPO-based candidate prioritisation for suitable clinical WGS/WES datasets.
10. Add unit tests and continuous integration for scripts.

## Suggested GitHub project milestones

- v0.1: sample sheet, validation, raw QC, preprocessing, alignment.
- v0.2: coverage summaries and QC reporting.
- v0.3: documented chromosome-level analysis with reference cohort.
- v0.4: separate WGS/WES variant calling and annotation module.
- v0.5: rare-disease prioritisation and visualisation examples.

Keep real patient data out of GitHub. Use synthetic or public datasets with appropriate licences for demonstrations.
