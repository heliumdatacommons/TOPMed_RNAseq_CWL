doc: |
    A wrapper for [run_MarkDuplicates.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_MarkDuplicates.py)

    CWL implementation to run run_MarkDuplicates.py. This is step 2 of the TOPMed RNA-seq workflow.

cwlVersion: v1.0
class: CommandLineTool
id: "run-MarkDuplicates"
label: "run-MarkDuplicates"
baseCommand: ["python3", "-u", "/src/run_MarkDuplicates.py"]

requirements:
  - class: DockerRequirement
    dockerPull: heliumdatacommons/topmed-rnaseq:latest

inputs:
  input_bam:
    type: File
    inputBinding:
      position: 1
  prefix_str:
    type: string
    inputBinding:
      position: 2
  memory:
    type: int
    inputBinding:
      position: 3
      prefix: --memory

outputs:
  bam_file:
    type: File
    outputBinding:
      glob: "*.md.bam"
  metrics:
    type: File
    outputBinding:
      glob: "*.marked_dup_metrics.txt"

dct:creator:
  "@id": "https://orcid.org/0000-0003-3523-5312"
  foaf:name: Christopher Ball
  foaf:mbox: "mailto:christopherball@rti.org"
