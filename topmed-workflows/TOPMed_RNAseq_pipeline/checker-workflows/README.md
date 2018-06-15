# TOPMed RNA-seq pipeline - Checker Workflow

The checker workflow verifies the output of the CWL workflow, more information [here](https://docs.dockstore.org/docs/publisher-tutorials/checker-workflows/).

The main workflow has 2 verification options:
1. [Verify BAM file](topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/check_bams_wf.cwl) - compares the BAM file output to a previously generated BAM file.
2. [Verify file md5 sum](topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/check_md5_wf.cwl) - compares the md5 sum of the new file to a previously computed md5 sum.

The full checker workflow is [here](topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/rnaseq_pipeline_fastq_checker.cwl) and is on Dockstore [here](https://dockstore.org/workflows/github.com/heliumdatacommons/cwl_workflows/TOPMed_RNAseq_pipeline_cwl_checker).

Input files for the checker workflows are [here](topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/inputs).

Individual CWL Tools used in the workflows are [here](topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/components) with input examples [here](topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/components/input-examples).

## Input files
Sample input files to run the checker workflow are available through HTTPS links in [rnaseq_pipeline_fastq_checker.yml](topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/inputs/rnaseq_pipeline_fasta_checker.yml).

The files are hosted in resources through https://beta.commonsshare.org/
