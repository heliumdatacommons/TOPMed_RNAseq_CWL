#!/usr/bin/env cwl-runner
doc: |
    A CWL wrapper for [run_MarkDuplicates.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_MarkDuplicates.py)

    Runs [Picard](https://github.com/broadinstitute/picard) [MarkDuplicates](https://broadinstitute.github.io/picard/command-line-overview.html#MarkDuplicates)

    This CWL Tool was developed as step 2 of the TOPMed RNA-seq workflow.

    [GitHub Repo](https://github.com/heliumdatacommons/cwl_workflows)

cwlVersion: v1.0
class: CommandLineTool
label: "run-MarkDuplicates"
baseCommand: ["python3", "-u", "/src/run_MarkDuplicates.py"]

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
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

arguments:
  - prefix: --memory
    valueFrom: ${runtime.mem / 1024}

outputs:
  bam_file:
    type: File
    outputBinding:
      glob: "*.md.bam"
  metrics:
    type: File
    outputBinding:
      glob: "*.marked_dup_metrics.txt"
