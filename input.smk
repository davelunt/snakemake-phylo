# we should have data as individual fasta files each in a folder in data with a name that needs preserving
SAMPLES, = glob_wildcards("data/{sample}")
SEQS, = glob_wildcards("data/{sample}/{seq}.fas", sample=SAMPLES)
# this hasn't worked and got all samples, just one, try another input methods?

rule all:
  input: expand("results/mafft/{sample}_allseqs.afa", sample=SAMPLES)

rule concatenate:
  input: expand("data/{sample}/{seq}.fas", sample=SAMPLES, seq=SEQS)
  output: "results/concat/{sample}_allseqs.fas"
  shell: "cat {input} >> {output}"

rule mafft_align: # alignment
    input:
        "results/concat/{sample}_allseqs.fas"
    output:
        "results/mafft/{sample}_allseqs.afa"
    shell:
        "mafft --auto --quiet {input} > {output}"

# rule trimal: # alignment curation https://vicfero.github.io/trimal/
#     input:
#         "results/mafft/{sample}_allseqs.afa"
#     output:
#         "results/trimal/{sample}_allseqs.afa"
#     shell:
#         "trimal -in {input} -out {output} -gappyout -keepheader"

# rule report:
#     output: "mafft_report.txt"
#     shell: "ls results/mafft/ > {output}"
