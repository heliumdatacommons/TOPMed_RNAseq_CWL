doc: |
    TOPMed RNA-seq CWL workflow. Documentation on the workflow can be found [here](https://github.com/heliumdatacommons/cwl_workflows/blob/master/topmed-workflows/TOPMed_RNAseq_pipeline/README.md).
    Example input files: [Dockstore.json](https://github.com/heliumdatacommons/cwl_workflows/blob/master/topmed-workflows/TOPMed_RNAseq_pipeline/input-examples/Dockstore.json) and [rnaseq_pipeline_fastq-example.yml](https://github.com/heliumdatacommons/cwl_workflows/blob/master/topmed-workflows/TOPMed_RNAseq_pipeline/input-examples/rnaseq_pipeline_fastq-example.yml).

    Quickstart instructions are [here](https://github.com/heliumdatacommons/cwl_workflows/blob/master/topmed-workflows/TOPMed_RNAseq_pipeline/README.md#Quick Start).

    [GitHub Repo](https://github.com/heliumdatacommons/cwl_workflows)

    Pipeline steps:
    1. Align RNA-seq reads with [STAR v2.5.3a](https://github.com/alexdobin/STAR).
    2. Run [Picard](https://github.com/broadinstitute/picard) [MarkDuplicates](https://broadinstitute.github.io/picard/command-line-overview.html#MarkDuplicates).
    2a. Create BAM index for MarkDuplicates BAM with [Samtools 1.6](https://github.com/samtools/samtools/releases) index.
    3. Transcript quantification with [RSEM 1.3.0](https://deweylab.github.io/RSEM/)
    4. Gene quantification and quality control with [RNA-SeQC 1.1.9](https://github.com/francois-a/rnaseqc)

cwlVersion: v1.0
class: Workflow
id: "TOPMed_RNA-seq"
label: "TOPMed_RNA-seq"

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ResourceRequirement
    coresMin: 4
    ramMin: 16
    tmpdirMin: 51200

inputs:
  star_index:
    type: Directory
  fastqs:
    type: File[]
  prefix_str:
    type: string
  threads:
    type: int
  memory:
    type: int
  rsem_ref_dir:
    type: Directory
  max_frag_len:
    type: int
  estimate_rspd:
    type: string
  is_stranded:
    type: string
  paired_end:
    type: string
  genes_gtf:
    type: File
  genome_fasta:
    type: File
    secondaryFiles:
      - .fai
      - ^.dict
  java_path:
    type: string
  rnaseqc_flags:
    type: string[]
  gatk_flags:
    type:
      type: "null"
      type: array
      items: string

outputs:
  - id: star_output_bam
    outputSource: run_star/bam_file
    type: File
  - id: star_output_bam_index
    outputSource: run_star/bam_index
    type: File
  - id: star_output_transcriptome_bam
    outputSource: run_star/transcriptome_bam
    type: File
  - id: star_output_chimeric_junctions
    outputSource: run_star/chimeric_junctions
    type: File
  - id: star_output_chimeric_bam_file
    outputSource: run_star/chimeric_bam_file
    type: File
  - id: star_output_chimeric_bam_index
    outputSource: run_star/chimeric_bam_index
    type: File
  - id: star_output_read_counts
    outputSource: run_star/read_counts
    type: File
  - id: star_output_junctions
    outputSource: run_star/junctions
    type: File
  - id: star_output_junctions_pass1
    outputSource: run_star/junctions_pass1
    type: File
  - id: star_output_logs
    outputSource: run_star/logs
    type: File[]
  - id: markduplicates_output_bam
    outputSource: run_markduplicates/bam_file
    type: File
  - id: markduplicates_output_metrics
    outputSource: run_markduplicates/metrics
    type: File
  - id: markduplicates_bam_index
    outputSource: run_index_markduplicates_bam/bam_index
    type: File
  - id: rsem_output_gene_results
    outputSource: run_rsem/gene_results
    type: File
  - id: rsem_output_isoforms_results
    outputSource: run_rsem/isoforms_results
    type: File
  - id: rna-seqc_output_gene_rpkm
    outputSource: run_rna-seqc/gene_rpkm
    type: File
  - id: rna-seqc_output_gene_counts
    outputSource: run_rna-seqc/gene_counts
    type: File
  - id: rna-seqc_output_exon_counts
    outputSource: run_rna-seqc/exon_counts
    type: File
  - id: rna-seqc_output_count_metrics
    outputSource: run_rna-seqc/count_metrics
    type: File
  - id: rna-seqc_output_count_outputs
    outputSource: run_rna-seqc/count_outputs
    type: File

steps:
  run_star:
    requirements:
      ResourceRequirement:
        coresMin: 4
        ramMin: 16
        tmpdirMin: 51200
    run: star.cwl
    in:
      star_index: star_index
      fastqs: fastqs
      prefix_str: prefix_str
      threads: threads
    out:
      [
        bam_file,
        bam_index,
        transcriptome_bam,
        chimeric_junctions,
        chimeric_bam_file,
        chimeric_bam_index,
        read_counts,
        junctions,
        junctions_pass1,
        logs
      ]

  run_markduplicates:
    run: markduplicates.cwl
    in:
      input_bam: run_star/bam_file
      prefix_str: prefix_str
      memory: memory
    out:
      [
        bam_file,
        metrics
      ]

  run_index_markduplicates_bam:
    run: indexbam.cwl
    in:
      input_bam: run_markduplicates/bam_file
    out: [bam_index]

  run_rsem:
    run: rsem.cwl
    in:
      rsem_ref_dir: rsem_ref_dir
      transcriptome_bam: run_star/transcriptome_bam
      prefix_str: prefix_str
      max_frag_len: max_frag_len
      estimate_rspd: estimate_rspd
      is_stranded: is_stranded
      paired_end: paired_end
      threads: threads
    out:
      [
        gene_results,
        isoforms_results
      ]

  run_rna-seqc:
    run: rna_seqc.cwl
    in:
      bam_file: run_index_markduplicates_bam/bam_index
      genes_gtf: genes_gtf
      genome_fasta: genome_fasta
      prefix_str: prefix_str
      java_path: java_path
      memory: memory
      rnaseqc_flags: rnaseqc_flags
      gatk_flags: gatk_flags
    out:
      [
        gene_rpkm,
        gene_counts,
        exon_counts,
        count_metrics,
        count_outputs
      ]

$namespaces:
  s: https://schema.org/

$schemas:
- http://dublincore.org/2012/06/14/dcterms.rdf
- http://xmlns.com/foaf/spec/20140114.rdf
- https://schema.org/docs/schema_org_rdfa.html

s:author:
  - class: s:Person
    s:id: https://orcid.org/0000-0003-3523-5312
    s:email: christopherball@rti.org
    s:name: Christopher Ball

s:codeRepository: https://github.com/heliumdatacommons/cwl_workflows
