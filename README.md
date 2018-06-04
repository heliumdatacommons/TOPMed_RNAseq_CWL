# Helium CWL Workflows

This repository contains example CWL Workflows that run on the PIVOT architecture.

Published CWL workflows:
* TOPMed RNA-seq [CWL File](topmed-workflows/TOPMed_RNAseq_pipeline/rnaseq_pipeline_fastq.cwl) and [Dockstore](https://dockstore.org/workflows/github.com/heliumdatacommons/cwl_workflows/TOPMed_RNAseq_pipeline)
    * Pipeline components:
        * STAR: [CWL File](topmed-workflows/TOPMed_RNAseq_pipeline/star.cwl) and [Dockstore](https://dockstore.org/containers/registry.hub.docker.com/heliumdatacommons/topmed-rnaseq/run-star)
        * Picard MarkDuplicates: [CWL File](topmed-workflows/TOPMed_RNAseq_pipeline/markduplicates.cwl)
        * Samtools index: [CWL File](topmed-workflows/TOPMed_RNAseq_pipeline/indexbam.cwl)
        * RSEM: [CWL File](topmed-workflows/TOPMed_RNAseq_pipeline/rsem.cwl)
        * RNA-SeQC: [CWL File](topmed-workflows/TOPMed_RNAseq_pipeline/rna_seqc.cwl)
