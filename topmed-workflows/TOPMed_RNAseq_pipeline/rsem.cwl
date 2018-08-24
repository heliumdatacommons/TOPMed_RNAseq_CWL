#!/usr/bin/env cwl-runner
doc: |
    A CWL wrapper for [run_RSEM.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_RSEM.py)

    Runs [RSEM 1.3.0](https://deweylab.github.io/RSEM/)

    This CWL Tool was developed as step 3 of the TOPMed RNA-seq workflow.

cwlVersion: v1.0
class: CommandLineTool
label: "run-rsem"
baseCommand: rsem-calculate-expression

hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/rsem:1.3.0--boost1.64_3

inputs:
  rsem_ref_dir:
    type: Directory
    inputBinding:
      position: 1
      valueFrom: $(self.path)/rsem_reference
  transcriptome_bam:
    type: File
    inputBinding:
      prefix: --bam
  prefix_str:
    type: string
  max_frag_len:
    type: int
    inputBinding:
      prefix: --fragment-length-max
  estimate_rspd:
    type: boolean
    inputBinding:
      prefix: --estimate-rspd
  is_stranded:
    type: boolean
    inputBinding:
      prefix: "--forward-prob 0.0"
  paired_end:
    type: boolean
    inputBinding:
      prefix: --paired-end

arguments:
  - prefix: --num-threads
    valueFrom: $(runtime.cores)
  - prefix: --fragment-length-max
    valueFrom: "1000"
  - --no-bam-output
  - $(inputs.prefix_str).rsem

outputs:
  gene_results:
    type: File
    outputBinding:
      glob: $(inputs.prefix_str).rsem.genes.results
  isoforms_results:
    type: File
    outputBinding:
      glob: $(inputs.prefix_str).rsem.isoforms.results
