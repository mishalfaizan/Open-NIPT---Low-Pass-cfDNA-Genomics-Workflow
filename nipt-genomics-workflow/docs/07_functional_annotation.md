# 07 — Functional variant annotation

Annotation describes the likely relationship between a variant and genes/transcripts. Annotation is not the same as clinical interpretation.

## Tools and databases

- Ensembl Variant Effect Predictor (VEP): https://www.ensembl.org/info/docs/tools/vep/index.html
- SnpEff: https://pcingola.github.io/SnpEff/
- ClinVar: https://www.ncbi.nlm.nih.gov/clinvar/
- gnomAD: https://gnomad.broadinstitute.org/
- dbSNP: https://www.ncbi.nlm.nih.gov/snp/
- OMIM: https://www.omim.org/

## Common annotation fields

- Chromosome, position, reference allele, alternate allele.
- Gene symbol and stable gene identifier.
- Transcript identifier and transcript version.
- Consequence (missense, synonymous, stop-gained, frameshift, splice-region, intronic, etc.).
- cDNA and protein change.
- Population allele frequency.
- Clinical database assertions and review status.

## Reference-build consistency

The variant coordinates and annotation resources must use the same reference assembly. If liftover is required, record the source and target builds and verify the result.

## Interpretation

A computational prediction is not proof of pathogenicity. ClinVar records may differ in review status, date, submitter evidence, and assertion. Apply the ACMG/AMP framework with appropriate evidence and expert review; do not classify variants from one prediction score alone.
