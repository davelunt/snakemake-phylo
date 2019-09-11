SAMPLES, = glob_wildcards("data/{sample}.fas")

rule all:
  input: "allseqs.fas"

rule concatenate:
  input: "expand("data/{sample}.fas", sample=SAMPLES)"
  output: "allseqs.fas"
  shell: "cat {input} >> {output}"
