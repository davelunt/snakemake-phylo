
rule replace_spaces: # replace spaces with underscores in fasta
    input:
        "results/mafft/{sample}.afa"
    output:
        "results/trimal/{sample}.afa"
    shell:
        "sed -E 's/ /_/g' {input} {output}"

rule replace_underscores: # replace underscores with spaces in fasta
    input:
        "results/trimal/{sample}.afa.trimal"
    output:
        "results/trimal/{sample}.afa.trimal_fixed"
    shell:
        "sed -E 's/_/ /g' {input} {output}"
