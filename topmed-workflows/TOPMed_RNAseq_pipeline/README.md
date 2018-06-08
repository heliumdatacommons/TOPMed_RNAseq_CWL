# TOPMed RNA-seq pipeline

This document describes team Helium's implimentation of the TOPMed RNA-seq pipeline as described in commit [b65c22b](https://github.com/broadinstitute/gtex-pipeline/blob/b65c22beb1967f991384a62bf3a6f63b35c0a387/TOPMed_RNAseq_pipeline.md).

The scripts and settings used for the TOPMed MESA RNA-seq pilot match commit [725a2bc](https://github.com/broadinstitute/gtex-pipeline/tree/725a2bc74f9654244065256df91b44e8f5b7e62a), packaged [here](https://github.com/broadinstitute/gtex-pipeline/releases/tag/TOPMed_MESA_RNAseq_pilot).

## Docker Image

Currently, republishing the GTEx pipeline Docker container on Docker Hub. 
Original: [Dockerfile](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/Dockerfile)
Local: [Dockerfile](topmed-workflows/TOPMed_RNAseq_pipeline/Docker/Dockerfile)

## Workflow steps
1. STAR ([run_STAR.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_STAR.py))
2. MarkDuplicates ([run_MarkDuplicates.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_MarkDuplicates.py))
    * Index bam with [samtools](topmed-workflows/TOPMed_RNAseq_pipeline/indexbam.cwl) after running.
3. RSEM ([run_RSEM.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_RSEM.py))
4. RNA-SeQC ([run_rnaseqc.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_rnaseqc.py))

## Create sample inputs
See instructions [here](topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows#creating-downsampled-inputs)

## Running in Helium Datacommons
* Register files into iRODS
    * [STAR index](https://personal.broadinstitute.org/francois/topmed/STAR_genome_GRCh38_noALT_noHLA_noDecoy_ERCC_v26_oh100.tar.gz)
    * [RSEM reference](https://personal.broadinstitute.org/francois/topmed/rsem_reference_GRCh38_gencode26_ercc.tar.gz)
    * [Genome FASTA](https://personal.broadinstitute.org/francois/topmed/Homo_sapiens_assembly38_noALT_noHLA_noDecoy_ERCC.tar.gz)
    * [Genes GTF](https://personal.broadinstitute.org/francois/topmed/gencode.v26.GRCh38.ERCC.genes.gtf.gz)
    * Unpack `tar` and `gz` files.
    ```
    $ cd /renci/irods/topmed-demo/
    $ gunzip -c LC_C13_cRNA_sequence_R1.txt.gz > LC_C13_cRNA_sequence_R1.fastq
    $ gunzip -c LC_C13_cRNA_sequence_R2.txt.gz > LC_C13_cRNA_sequence_R2.fastq
    $ mkdir star_index
    $ tar -xvvf STAR_genome_GRCh38_noALT_noHLA_noDecoy_ERCC_v26_oh100.tar.gz -C star_index --strip-components=1
    ```
    * Run `ireg` command for all files into desired resource.
* Start an appliance using the instructions [here](https://github.com/heliumdatacommons/PIVOT/blob/master/examples/cwl.md).
* Run with toil
```
cwltoil --noLinkImports --jobStore /<path>/jobstore1 --batchSystem chronos --workDir ./ /<path>/<workflow>.cwl /<path>/<workflow-inputs>.yml
```
