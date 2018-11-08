# TOPMed RNA-seq pipeline

The [TOPMed RNA-Seq pipeline](https://github.com/broadinstitute/gtex-pipeline/blob/b65c22beb1967f991384a62bf3a6f63b35c0a387/TOPMed_RNAseq_pipeline.md) was converted to CWL for a deliverable to have a CWL pipeline available through a public [Tool Registry Service](https://github.com/ga4gh/tool-registry-service-schemas). Specifically, this workflow is available through [Dockstore.org](https://dockstore.org/).

## Workflow description

This document describes team Helium's implimentation of the TOPMed RNA-seq pipeline as described in commit [b65c22b](https://github.com/broadinstitute/gtex-pipeline/blob/b65c22beb1967f991384a62bf3a6f63b35c0a387/TOPMed_RNAseq_pipeline.md). The CWL Workflow is registered publicly on Dockstore [here](https://dockstore.org/workflows/github.com/heliumdatacommons/cwl_workflows/TOPMed_RNAseq_pipeline). This CWL workflow has 4 components described below.

A checker workflow registered on Dockstore is also available to verify operation of this pipeline. See information [here](/topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/README.md).

The scripts and settings used for the TOPMed MESA RNA-seq pilot match commit [725a2bc](https://github.com/broadinstitute/gtex-pipeline/tree/725a2bc74f9654244065256df91b44e8f5b7e62a/rnaseq/src), packaged [here](https://github.com/broadinstitute/gtex-pipeline/releases/tag/TOPMed_MESA_RNAseq_pilot).

### Intended Audience

The intended audiance is any scientist familiar with RNA-seq analysis wishing to run RNA-seq analysis on the TOPMed public access data.

## Quick Start

Run the pipeline locally with small test input files. Creating these sample input files is described [here](/topmed-workflows/TOPMed_RNAseq_pipeline/Downsampled_test_data.md).

1. Dockstore CLI, CWLTool, Git, [Git LFS](https://git-lfs.github.com/) and Docker should be installed.
2. Clone this GitHub repository:
    ```
    git clone https://github.com/heliumdatacommons/cwl_workflows.git
    ```
3. Decompress sample files.
    ```
    ./topmed-workflows/TOPMed_RNAseq_pipeline/input-examples/download_examples.sh
    ```
4. Use [this](/topmed-workflows/TOPMed_RNAseq_pipeline/input-examples/Dockstore.json) input file or edit the file paths based on your local machine paths.
5. Run the workflow with CWLTool.
    ```
    cwltool topmed-workflows/TOPMed_RNAseq_pipeline/rnaseq_pipeline_fastq.cwl \
    topmed-workflows/TOPMed_RNAseq_pipeline/input-examples/Dockstore.json
    ```

## Checker Workflow

A checker workflow for the TOPMed RNA-seq pipeline is published on Dockstore [here](https://dockstore.org/workflows/github.com/heliumdatacommons/cwl_workflows/TOPMed_RNAseq_pipeline_cwl_checker). It is described in more detail in this [README.md](/topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/README.md)

## Sample data sets

The sample data sets intended to be used as input are available through this [BioProject](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA173917).
* Direct [DataSets link](https://www.ncbi.nlm.nih.gov/bioproject?Db=biosample&DbFrom=bioproject&Cmd=Link&LinkName=bioproject_biosample&LinkReadableName=BioSample&ordinalpos=1&IdsFromResult=173917).

Creating downsampled datasets for testing is described [here](/topmed-workflows/TOPMed_RNAseq_pipeline/Downsampled_test_data.md).

## Pipeline components

`OUTPUTS` describes the files generated by the TOPMed RNA-Seq pipeline, for each sample.

* Alignment: [STAR 2.5.3a](https://github.com/alexdobin/STAR)
    * STAR [CWL File](/topmed-workflows/TOPMed_RNAseq_pipeline/star.cwl)
    * Python script ran by CWL file in Docker container: [run_STAR.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_STAR.py)
    * INPUT: STAR Index and sample FASTQ's. See example [input](/topmed-workflows/TOPMed_RNAseq_pipeline/input-examples/star-example.yml) file.
        * See [here](/topmed-workflows/TOPMed_RNAseq_pipeline/README.md#create-star-index) to create STAR Index
    * OUTPUT: Aligned RNA-seq reads in BAM format.
* Post-processing: [Picard 2.9.0](https://github.com/broadinstitute/picard) [MarkDuplicates](https://broadinstitute.github.io/picard/command-line-overview.html#MarkDuplicates)
    * Picard MarkDuplicates [CWL File](/topmed-workflows/TOPMed_RNAseq_pipeline/markduplicates.cwl)
    * Python script ran by CWL file in Docker container: [run_MarkDuplicates.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_MarkDuplicates.py)
    * INPUT: Aligned BAM file from STAR. See example [input](/topmed-workflows/TOPMed_RNAseq_pipeline/input-examples/markduplicates-example.yml)
    * OUTPUT: Marked duplicates BAM file.
        * Will need to create BAM index file with Samtools index, [CWL File](/topmed-workflows/TOPMed_RNAseq_pipeline/indexbam.cwl), example [input](/topmed-workflows/TOPMed_RNAseq_pipeline/input-examples/indexbam-example.yml)
* Transcript quantification: [RNA-SeQC 1.1.9](https://github.com/francois-a/rnaseqc)
    * RNA-SeQC [CWL File](/topmed-workflows/TOPMed_RNAseq_pipeline/rna_seqc.cwl)
    * Python script ran by CWL file in Docker container: [run_rnaseqc.py](https://github.com/heliumdatacommons/cwl_workflows/blob/master/topmed-workflows/TOPMed_RNAseq_pipeline/src/run_rnaseqc.py)
    * INPUT: Genome FASTA, GTF file, Aligned BAM file from STAR. See example [input](/topmed-workflows/TOPMed_RNAseq_pipeline/input-examples/rna_seqc-example.yml)
    * OUTPUT:
        * Transcript-level expression quantifications, provided as TPM, expected read counts, and isoform percentages.
        * Standard quality control metrics derived from the aligned reads.
* Gene quantification and quality control: [RSEM 1.3.0](https://deweylab.github.io/RSEM/)
    * RSEM [CWL File](/topmed-workflows/TOPMed_RNAseq_pipeline/rsem.cwl)
    * Python script ran by CWL file in Docker container: [run_RSEM.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_RSEM.py)
    * INPUT: RSEM refernce files, BAM with reads aligned to transcriptome from STAR. See example [input](/topmed-workflows/TOPMed_RNAseq_pipeline/input-examples/rsem-example.yml)
        * See [here](/topmed-workflows/TOPMed_RNAseq_pipeline/README.md#create-rsem-reference) to create RSEM refernce directory.
    * OUTPUT: Gene-level expression quantifications based on a collapsed version of a reference transcript annotation, provided as read counts and TPM.
* Utilities: [SAMtools 1.6](https://github.com/samtools/samtools/releases) and [HTSlib 1.6](https://github.com/samtools/htslib/releases)
    * Samtools index is used to create `.bai` files for input `.bam` files. [CWL File](/topmed-workflows/TOPMed_RNAseq_pipeline/indexbam.cwl), example [input](/topmed-workflows/TOPMed_RNAseq_pipeline/input-examples/indexbam-example.yml)

## Alternative Approaches

Many other software packages are available to perform similar funcionality as this pipeline. For deatiled information on RNA-seq analysis steps and other software options, please see [A survey of best practices for RNA-seq data analysis](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-0881-8).

## Docker Image
Currently, republishing the GTEx pipeline Docker container on Docker Hub.
* Original: [Dockerfile](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/Dockerfile)
* Local: [Dockerfile](/topmed-workflows/TOPMed_RNAseq_pipeline/Docker/Dockerfile)
* Docker Hub [Link](https://hub.docker.com/r/heliumdatacommons/topmed-rnaseq/)

Obtaining docker image.
1. Docker should be installed. See [here](https://docs.docker.com/install/) if not.
2. Pull the image from Docker Hub
    ```
    docker pull heliumdatacommons/topmed-rnaseq:latest
    ```

## Create required inputs

The following steps assume:
1. You have downloaded the following files:
    * [Genome FASTA](https://personal.broadinstitute.org/francois/topmed/Homo_sapiens_assembly38_noALT_noHLA_noDecoy_ERCC.tar.gz)
    * [Genes GTF](https://personal.broadinstitute.org/francois/topmed/gencode.v26.GRCh38.ERCC.genes.gtf.gz)

    ```
    $ wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_26/gencode.v26.annotation.gtf.gz
    $ gunzip gencode.v26.annotation.gtf.gz

    $ wget https://personal.broadinstitute.org/francois/topmed/Homo_sapiens_assembly38_noALT_noHLA_noDecoy_ERCC.tar.gz
    $ tar -xzf Homo_sapiens_assembly38_noALT_noHLA_noDecoy_ERCC.tar.gz
    ```
2. You have obtained the Docker container described [here](/topmed-workflows/TOPMed_RNAseq_pipeline/README.md#docker-image)

#### Create .fai file
Create the index file using `samtools faidx`.

`~/input_files` contains the `Homo_sapiens_assembly38_noALT_noHLA_noDecoy_ERCC.fasta` file.

```
docker run --rm -v ~/input_files:/input_files heliumdatacommons/topmed-rnaseq \
    samtools faidx /input_files/Homo_sapiens_assembly38_noALT_noHLA_noDecoy_ERCC.fasta
```

#### Create .dict file
Create the dictionary file using Picard CreateSequenceDictionary.

`~/input_files` contains the `Homo_sapiens_assembly38_noALT_noHLA_noDecoy_ERCC.fasta` file.

```
docker run --rm -v ~/input_files:/input_files heliumdatacommons/topmed-rnaseq \
    java -jar /opt/picard-tools/picard.jar CreateSequenceDictionary \
    R=/input_files/Homo_sapiens_assembly38_noALT_noHLA_noDecoy_ERCC.fasta \
    O=/input_files/Homo_sapiens_assembly38_noALT_noHLA_noDecoy_ERCC.dict
```

#### Create STAR Index
1. Create `.fai` and `.dict` file for Genome FASTA (both described above).
2. GTF file, Genome FASTA file, `.fai` and `.dict` should all be in the same directory. Use this directoy as a volume mount when running docker. We used `input_files` below.
3. Run the following command:
    ```
    docker run --rm -v ~/input_files:/input_files heliumdatacommons/topmed-rnaseq \
        STAR --runMode genomeGenerate \
        --genomeDir /input_files/star_index \
        --genomeFastaFiles /input_files/Homo_sapiens_assembly38_noALT_noHLA_noDecoy_ERCC.fasta \
        --sjdbGTFfile /input_files/gencode.v26.annotation.gtf \
        --sjdbOverhang 100 --runThreadN 10
    ```
4. Upon completion, your STAR Index will be in the `~/input_files/star_index` directory.

#### Create RSEM Reference
1. Create `.fai` and `.dict` file for Genome FASTA (both described above).
2. GTF file, Genome FASTA file, `.fai` and `.dict` should all be in the same directory. Use this directoy as a volume mount when running docker.
3. Create RSEM reference using `rsem-prepare-reference`:
```
docker run --rm -v ~/input_files:/input_files heliumdatacommons/topmed-rnaseq:latest \
    rsem-prepare-reference --num-threads 4 \
    --gtf /input_files/gencode.v26.annotation.gtf \
    /input_files/Homo_sapiens_assembly38_noALT_noHLA_noDecoy_ERCC.fasta \
    /input_files/rsem_reference
```
4. Upon completion, the RSEM reference directory will be in the `~/input_files/rsem_reference` directory.
