# 02 — Quality control

Quality control (QC) is performed before and, where preprocessing is used, after trimming.

## Tools

- FastQC: per-file read quality and composition report.
- MultiQC: combines reports into one dashboard.
- SeqKit: FASTQ counts, lengths, and GC statistics.
- fastp: optional preprocessing plus HTML/JSON QC report.
- SAMtools: alignment statistics after mapping.
- mosdepth: coverage summaries after mapping.

## Raw QC

```bash
mkdir -p results/qc_raw
fastqc --threads 4 --outdir results/qc_raw data/*.fastq.gz
multiqc results/qc_raw --outdir results/multiqc_raw
seqkit stats -a data/*.fastq.gz
```

## Modules to inspect

1. Per-base sequence quality.
2. Per-sequence quality scores.
3. Per-base sequence content.
4. Per-sequence GC content.
5. Sequence length distribution.
6. Sequence duplication levels.
7. Adapter content.
8. Overrepresented sequences.

A FastQC warning is not automatically a sample failure. Interpret it in the context of library preparation and assay design. cfDNA libraries can have different profiles from standard genomic DNA libraries.

## NIPT-specific considerations

Assess:
- Total reads and usable reads.
- Read length and quality.
- GC distribution and GC bias.
- Duplicate rate and library complexity.
- Adapter contamination.
- Mapping rate and unique mapping.
- Chromosome-specific read counts.
- Batch/library effects and sample comparability.

Do not compare chromosome read counts across samples without considering library preparation, sequencing batch, GC bias, mappability, reference build, and normalisation.
