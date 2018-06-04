doc: |
    A CWL wrapper for [run_STAR.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_STAR.py)

    Runs [STAR v2.5.3a](https://github.com/alexdobin/STAR)

    This CWL Tool was developed as step 1 of the TOPMed RNA-seq workflow.

    [GitHub Repo](https://github.com/heliumdatacommons/cwl_workflows)

cwlVersion: v1.0
class: CommandLineTool
id: "run-star"
label: "run-star"
baseCommand: /src/run_STAR.py

requirements:
  DockerRequirement:
    dockerPull: heliumdatacommons/topmed-rnaseq:latest

inputs:
  star_index:
    type: Directory
    default:
      type: Directory
    inputBinding:
      position: 1
  fastqs:
    type:
      type: array
      items: File
      inputBinding:
        itemSeparator: ","
    inputBinding:
      position: 2
  prefix_str:
    type: string
    inputBinding:
      position: 3
  threads:
    type: int?
    inputBinding:
      position: 5
      prefix: --threads

outputs:
  bam_file:
    type: File
    outputBinding:
      glob: "*.Aligned.sortedByCoord.out.bam"
  bam_index:
    type: File
    outputBinding:
      glob: "*.Aligned.sortedByCoord.out.bam.bai"
  transcriptome_bam:
    type: File
    outputBinding:
      glob: "*.Aligned.toTranscriptome.out.bam"
  chimeric_junctions:
    type: File
    outputBinding:
      glob: "*.Chimeric.out.junction"
  chimeric_bam_file:
    type: File
    outputBinding:
      glob: "*.Chimeric.out.sorted.bam"
  chimeric_bam_index:
    type: File
    outputBinding:
      glob: "*.Chimeric.out.sorted.bam.bai"
  read_counts:
    type: File
    outputBinding:
      glob: "*.ReadsPerGene.out.tab"
  junctions:
    type: File
    outputBinding:
      glob: "*.SJ.out.tab"
  junctions_pass1:
    type: File
    outputBinding:
      glob: "*._STARpass1/SJ.out.tab"
  logs:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*.*.out"

dct:creator:
  "@id": "https://orcid.org/0000-0003-3523-5312"
  foaf:name: Christopher Ball
  foaf:mbox: "mailto:christopherball@rti.org"
