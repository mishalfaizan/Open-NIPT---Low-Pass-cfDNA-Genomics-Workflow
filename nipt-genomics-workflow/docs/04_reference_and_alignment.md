# 04 — Reference genome and alignment

## Reference choice

GRCh38 is a common current human reference assembly. Use the assembly required by the project and record the exact release/source. Keep FASTA, indexes, gene annotations, known-sites resources, and variant databases build-consistent.

Trusted sources:
- NCBI Datasets: https://www.ncbi.nlm.nih.gov/datasets/
- Ensembl: https://www.ensembl.org/info/data/ftp/index.html
- UCSC Genome Browser: https://hgdownload.soe.ucsc.edu/

## Build and record the reference

```bash
mkdir -p reference
# Download the desired FASTA from a trusted source.
# Verify checksum using the provider's published checksum.
```

Do not mix hg19/GRCh37 and hg38/GRCh38 coordinates. Contig naming (e.g. `chr1` versus `1`) must also be consistent across tools and annotations.

## BWA-MEM2 and SAMtools

The starter script:
1. Builds BWA-MEM2 indexes if missing.
2. Aligns paired-end or single-end reads according to the sample sheet.
3. Converts SAM output to BAM.
4. Sorts and indexes BAM.
5. Runs `samtools flagstat` and `samtools stats`.

BWA-MEM2 is a short-read aligner. It is not a variant caller.

## Inspect alignments

Use IGV to inspect selected regions:
https://igv.org/

Use SAMtools:
```bash
samtools flagstat results/alignment/SAMPLE.sorted.bam
samtools idxstats results/alignment/SAMPLE.sorted.bam
samtools stats results/alignment/SAMPLE.sorted.bam
```

Interpret mapping metrics in light of read length, reference composition, adapters, contamination, and library quality. High mapping percentage alone does not prove that a sample is suitable for a specific downstream analysis.
