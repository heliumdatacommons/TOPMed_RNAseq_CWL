doc: |
    A wrapper for running samtools index <bam>.

cwlVersion: v1.0
class: CommandLineTool
id: "run-index-bam"
label: "run-index-bam"
baseCommand: ["samtools", "index"]

requirements:
  DockerRequirement:
    dockerPull: heliumdatacommons/topmed-rnaseq:latest
  InitialWorkDirRequirement:
    listing:
      - $(inputs.input_bam)

inputs:
  input_bam:
    type: File
    inputBinding:
      position: 1

outputs:
  bam_index:
    type: File
    outputBinding:
      glob: "*.bai"

dct:creator:
  "@id": "https://orcid.org/0000-0003-3523-5312"
  foaf:name: Christopher Ball
  foaf:mbox: "mailto:christopherball@rti.org"
