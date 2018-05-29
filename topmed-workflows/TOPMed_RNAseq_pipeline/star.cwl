doc: |
    A wrapper for [run_STAR.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_STAR.py)
    
    CWL implementation to run the Star aligner.

cwlVersion: v1.0
class: CommandLineTool
id: "run-star"
label: "run-star"
baseCommand: /src/run_STAR.py

dct:creator:
  "@id": "https://orcid.org/0000-0003-3523-5312"
  foaf:name: Christopher Ball
  foaf:mbox: "mailto:christopherball@rti.org"

requirements:
  - class: DockerRequirement
    dockerPull: "#docker_image"

inputs:
  star_index:
    type: File
    inputBinding:
      position: 1
  fastq1:
    type: File
    inputBinding:
      position: 2
  fastq2:
    type: File
    inputBinding:
      position: 3
  prefix_str:
    type: string
    inputBinding:
      position: 4
  output_dir:
    type: string
    inputBinding:
      position: 5
      prefix: --output_dir
  threads:
    type: int
    inputBinding:
      position: 6
      prefix: --threads

outputs:
  bam_file:
    type: File
    outputBinding:
      glob: "#output_dir/#prefix_str.Aligned.sortedByCoord.out.bam"
  bam_index:
    type: File
    outputBinding:
      glob: "#output_dir/#prefix_str.Aligned.sortedByCoord.out.bam.bai"
  transcriptome_bam:
    type: File
    outputBinding:
      glob: "#output_dir/#prefix_str.Aligned.toTranscriptome.out.bam"
  chimeric_junctions:
    type: File
    outputBinding:
      glob: "#output_dir/#prefix_str.Chimeric.out.junction"
  chimeric_bam_file:
    type: File
    outputBinding:
      glob: "#output_dir/#prefix_str.Chimeric.out.sorted.bam"
  chimeric_bam_index:
    type: File
    outputBinding:
      glob: "#output_dir/#prefix_str.Chimeric.out.sorted.bam.bai"
  read_counts:
    type: File
    outputBinding:
      glob: "#output_dir/#prefix_str.ReadsPerGene.out.tab"
  junctions:
    type: File
    outputBinding:
      glob: "#output_dir/#prefix_str.SJ.out.tab"
  junctions_pass1:
    type: File
    outputBinding:
      glob: "#output_dir/#prefix_str._STARpass1/SJ.out.tab"
  logs:
    type:
      type: array
      items: File
    outputBinding:
      glob: "#output_dir/#prefix_str.*.out"
