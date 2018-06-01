doc: |
    TOPMed RNA-seq CWL workflow.

cwlVersion: v1.0
class: Workflow
id: "TOPMed_RNA-seq"
label: "TOPMed_RNA-seq"

requirements:
  - class: SubworkflowFeatureRequirement

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
    type: string[]

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
#   - id: rna-seqc_output_gene_rpkm
#     outputSource: run_rna-seqc/gene_rpkm
#     type: File
#   - id: rna-seqc_output_gene_counts
#     outputSource: run_rna-seqc/gene_counts
#     type: File
#   - id: rna-seqc_output_exon_counts
#     outputSource: run_rna-seqc/exon_counts
#     type: File
#   - id: rna-seqc_output_count_metrics
#     outputSource: run_rna-seqc/count_metrics
#     type: File
#   - id: rna-seqc_output_count_outputs
#     outputSource: run_rna-seqc/count_outputs
#     type: File

steps:
  run_star:
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

#   run_rna-seqc:
#     run: rna_seqc.cwl
#     in:
#       bam_file: run_markduplicates/input_bam
#         # - secondaryFiles:
#         #    - run_index_markduplicates_bam/bam_index
#       genes_gtf: genes_gtf
#       genome_fasta: genome_fasta
#       prefix_str: prefix_str
#       java_path: java_path
#       memory: memory
#       rnaseqc_flags: rnaseqc_flags
#       gatk_flags: gatk_flags
#     out:
#       [
#         gene_rpkm,
#         gene_counts,
#         exon_counts,
#         count_metrics,
#         count_outputs
#       ]


dct:creator:
  "@id": "https://orcid.org/0000-0003-3523-5312"
  foaf:name: Christopher Ball
  foaf:mbox: "mailto:christopherball@rti.org"
