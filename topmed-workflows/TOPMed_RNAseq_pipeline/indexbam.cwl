doc: |
    A wrapper for running `samtools index <bam>`.

cwlVersion: v1.0
class: CommandLineTool
label: "run-index-bam"
baseCommand: [ samtools, index ]

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
      valueFrom: $(self.basename)

outputs:
  bam_index:
    type: File
    outputBinding:
      glob: $(inputs.input_bam.basename)
    secondaryFiles:
      - .bai
