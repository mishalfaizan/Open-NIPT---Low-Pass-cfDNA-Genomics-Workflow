# 08 — Rare-disease candidate prioritisation

## Appropriate data

Rare-disease prioritisation is best performed with high-quality genomic data from the affected individual, ideally with parental sequencing (trio) and reliable clinical phenotype information. Standard low-pass NIPT cfDNA is not suitable for comprehensive fetal rare-disease screening.

## Concepts to learn

- Autosomal dominant and autosomal recessive inheritance.
- X-linked inheritance.
- De novo variants.
- Compound heterozygosity.
- Homozygous variants.
- Penetrance and variable expressivity.
- Phenotype terms and Human Phenotype Ontology (HPO).
- Segregation and family-based analysis.

## Tools

- Exomiser: https://github.com/exomiser/Exomiser
- Human Phenotype Ontology: https://hpo.jax.org/
- OMIM: https://omim.org/
- DECIPHER: https://www.deciphergenomics.org/
- PanelApp: https://panelapp.genomicsengland.co.uk/

## Homozygosity and ROH

A homozygous genotype means both alleles at a locus have the same allele. A run of homozygosity (ROH) is a long region with consecutive homozygous genotypes. ROH analysis requires reliable individual genotypes and suitable marker density.

PLINK 2 can support genotype/ROH analyses: https://www.cog-genomics.org/plink/2.0/

Mixed low-coverage cfDNA does not provide a conventional fetal diploid genotype set. Do not infer fetal ROH or recessive disease from routine NIPT reads. For research into recessive disease, use appropriate individual WGS/WES and, where possible, parental samples.
