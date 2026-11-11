# 05 — Chromosome representation and CNV analysis

## The NIPT question

Low-pass cfDNA sequencing is commonly used to estimate chromosome representation. A chromosome with a relative excess or deficit of mapped reads may produce a signal. This is a statistical comparison, not a direct visual count of fetal chromosomes.

## Core steps

1. Align reads to a consistent reference.
2. Exclude or account for low-mappability and problematic regions.
3. Count reads in genomic bins or chromosome intervals.
4. Account for GC content and mappability bias.
5. Normalise read counts.
6. Compare with an appropriate reference cohort/control set.
7. Estimate uncertainty and apply a validated decision threshold.
8. Visualise chromosome-level and segment-level profiles.

## Tools to investigate

- WISECONDORX: low-pass whole-genome sequencing copy-number analysis; assess whether its assumptions and reference design fit the dataset.
- NIPTeR: R package focused on NIPT data analysis.
- mosdepth: coverage summaries.
- bedtools: genomic interval operations.
- R / ggplot2: chromosome plots.
- Circos: circular genome visualisation.
- IGV: read-level inspection.

Project links:
- WISECONDORX: https://github.com/CenterForMedicalGeneticsGhent/WisecondorX
- NIPTeR: https://github.com/VanLoo-lab/NIPTeR
- mosdepth: https://github.com/brentp/mosdepth
- bedtools: https://bedtools.readthedocs.io/
- Circos: https://circos.ca/

## Reference cohort is essential

Do not interpret one sample's raw chromosome counts as evidence of aneuploidy. Robust methods require suitable controls/reference samples and correction for GC bias, mappability, batch effects, and library preparation. Reference samples should be generated with a comparable assay and processed consistently.

## Fetal fraction and biological confounders

The fetal/placental fraction affects the amplitude of a chromosome dosage signal. Maternal CNVs, confined placental mosaicism, maternal malignancy, vanishing twin, and other factors may influence results. A screen-positive or unusual signal requires clinical laboratory review and appropriate follow-up; this repository does not provide such interpretation.

## Resolution

A method's ability to detect a CNV depends on sequencing depth, bin size, fetal fraction, noise, library quality, reference cohort, and validated assay performance. Do not claim a universal resolution limit.
