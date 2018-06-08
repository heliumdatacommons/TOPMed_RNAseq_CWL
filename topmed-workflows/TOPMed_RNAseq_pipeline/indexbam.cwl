doc: |
    A wrapper for running `samtools index <bam>`.

cwlVersion: v1.0
class: CommandLineTool
id: "run-index-bam"
label: "run-index-bam"
baseCommand: ["samtools", "index"]

requirements:
- class: InlineJavascriptRequirement
- class: DockerRequirement
  dockerPull: heliumdatacommons/topmed-rnaseq:latest
- class: InitialWorkDirRequirement
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
      glob: $(inputs.input_bam.basename)
    secondaryFiles:
      - .bai
