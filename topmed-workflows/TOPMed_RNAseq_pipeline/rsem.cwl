doc: |
    A wrapper for [run_RSEM.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_RSEM.py)
    
    CWL implementation to run RSEM. This is step 3 of the TOPMed RNA-seq workflow.

cwlVersion: v1.0
class: CommandLineTool
id: "run-rsem"
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
  threads:
    type: int
    inputBinding:
      position: 8
      prefix: --threads

outputs:
  gene_results:
    type: File
    outputBinding:
      glob: "*.rsem.genes.results"
  isoforms_results:
    type: File
    outputBinding:
      glob: "*.rsem.isoforms.results"

dct:creator:
  "@id": "https://orcid.org/0000-0003-3523-5312"
  foaf:name: Christopher Ball
  foaf:mbox: "mailto:christopherball@rti.org"
