DIRECTORIES = ["gene1", "gene2", "gene3"]
SAMPLES = ["Gg2", "Ggg", "Hsap1"]

rule all:
    input:
        "results/concat/dirseqs.fasta"

rule concat:
    input:
        expand("data/{dirs}/{sample}.fas", sample=SAMPLES, dirs=DIRECTORIES)
    output:
        "results/concat/dirseqs.fasta"
    shell:
        "cat {input} >> {output}"

#
# rule all:
#     input:
#         "results/concat/threeseqs.fasta"
#
# rule concat:
#     input:
#         expand("data/{sample}.fas", sample=SAMPLES)
#     output:
#         "results/concat/threeseqs.fasta"
#     shell:
#         "cat {input} >> {output}"
