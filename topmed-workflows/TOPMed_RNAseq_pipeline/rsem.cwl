doc: |
    A CWL wrapper for [run_RSEM.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_RSEM.py)

    Runs [RSEM 1.3.0](https://deweylab.github.io/RSEM/)

    This CWL Tool was developed as step 3 of the TOPMed RNA-seq workflow.

cwlVersion: v1.0
class: CommandLineTool
label: "run-rsem"
baseCommand: /src/run_RSEM.py

requirements:
  DockerRequirement:
    dockerPull: heliumdatacommons/topmed-rnaseq:latest

inputs:
  rsem_ref_dir:
    type: Directory
    default:
      type: Directory
    inputBinding:
      position: 1
  transcriptome_bam:
    type: File
    inputBinding:
      position: 2
  prefix_str:
    type: string
    inputBinding:
      position: 3
  max_frag_len:
    type: int
    inputBinding:
      position: 4
      prefix: --max_frag_len
  estimate_rspd:
    type: string
    inputBinding:
      position: 5
      prefix: --estimate_rspd
  is_stranded:
    type: string
    inputBinding:
      position: 6
      prefix: --is_stranded
  paired_end:
    type: string
    inputBinding:
      position: 7
      prefix: --paired_end

arguments:
  - prefix: --threads
    valueFrom: $(runtime.cores)

outputs:
  gene_results:
    type: File
    outputBinding:
      glob: "*.rsem.genes.results"
  isoforms_results:
    type: File
    outputBinding:
      glob: "*.rsem.isoforms.results"
