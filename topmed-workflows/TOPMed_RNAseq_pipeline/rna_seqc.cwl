doc: |
    A wrapper for [run_rnaseqc.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_rnaseqc.py)
    
    CWL implementation to run RNA-SeQC. This is step 4 of the TOPMed RNA-seq workflow.

cwlVersion: v1.0
class: CommandLineTool
id: "run-seqc"
label: "run-seqc"
# run_rnaseqc.py is not an executable file in the docker container.
baseCommand: ["python3", "/src/run_rnaseqc.py"]

requirements:
  DockerRequirement:
    dockerPull: heliumdatacommons/topmed-rnaseq:latest

inputs:
  bam_file:
    type: File
    secondaryFiles:
      - .bai
    inputBinding:
      position: 1
  genes_gtf:
    type: File
    inputBinding:
      position: 2
  genome_fasta:
    type: File
    secondaryFiles:
      - .fai
      - ^.dict
    inputBinding:
      position: 3
  prefix_str:
    type: string
    inputBinding:
      position: 4
  java_path:
    type: string
    inputBinding:
      position: 5
      prefix: --java
  memory:
    type: int
    inputBinding:
      position: 6
      prefix: --memory
  rnaseqc_flags:
    type:
      type: array
      items: string
      inputBinding:
        itemSeparator: " "
    inputBinding:
      position: 7
      prefix: --rnaseqc_flags
  gatk_flags:
    type:
      type: "null"
      type: array
      items: string
      inputBinding:
        itemSeparator: " "
    inputBinding:
      position: 8
      prefix: --gatk_flags

outputs:
  gene_rpkm:
    type: File
    outputBinding:
      glob: "*.gene_rpkm.gct.gz"
  gene_counts:
    type: File
    outputBinding:
      glob: "*.gene_reads.gct.gz"
  exon_counts:
    type: File
    outputBinding:
      glob: "*.exon_reads.gct.gz"
  count_metrics:
    type: File
    outputBinding:
      glob: "*.metrics.tsv"
  count_outputs:
    type: File
    outputBinding:
      glob: "*.tar.gz"

dct:creator:
  "@id": "https://orcid.org/0000-0003-3523-5312"
  foaf:name: Christopher Ball
  foaf:mbox: "mailto:christopherball@rti.org"
