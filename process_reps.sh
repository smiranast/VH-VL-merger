sample_file="" # txt file with a list of sample names for amp1 (fastq name before _R{1,2}_001.fastq.gz)
input_dir="" # Directory with input fastq files for amplicone 1

while read s; do
        echo "$s"
	cutadapt -g CAGRTBCAGCTKGTRCAGTCTGG -g CAGRTCACCTTGARGGAGTCTGGTCCT -g SARGTGCAKCTGGTGGAGTC -g CAGSTRCAGCTRCAGSAGTC -G TGARGAGACGGTGACCRTKGTCCC -G TGAGGAGACRGTGACCAGGGT -o $s"_R1_001.trimmed.fastq" -p $s"_R2_001.trimmed.fastq" $input_dir/$s"_R1_001.fastq.gz" $input_dir/$s"_R2_001.fastq.gz" -j 3 --discard-untrimmed --action=retain
    mixcr -Xmx20G analyze generic-amplicon --species hsa --dna --floating-left-alignment-boundary --floating-right-alignment-boundary J -t 4 --library my_library_IGH.json --assemble-contigs-by CDR3 --add-step assembleContigs --append-export-clones-field -vHit --append-export-clones-field -dHit --append-export-clones-field -jHit --append-export-clones-field -cHit -f $s"_R1_001.trimmed.fastq" $s"_R2_001.trimmed.fastq"  $s"_2"
done < "$sample_file"


sample_file="" # Same for amp2
input_dir="" # Directory with input fastq files for amplicone 2

while read s; do
        echo "$s"
       cutadapt -G TGGAGCTGAGCAGCCTGAGATCTGA -G CAATGACCAACATGGACCCTGTGG -G TCTGCAAATGAACAGCCTGAGAGCC -G AGCTCTGTGACCGCCGCGGACAC -G CACCGCCTACCTGCAGTGGAGC -G TTCTCCCTGCAGCTGAACTCTGTG -G CACGGCATATCTGCAGATCA -G Tggagctgagcagcctgagatccga -G Tctgcaaatgaacagcctgaaaacc -G TTctgcaaatgaacagtctgagaRct -G Ttcttcaaatgggcagcctgagagct -G cacggcatatctgcagatct -G TAgctctgtgactgccgcagacac -o $s"_R1_001.trimmed.fastq" -p $s"_R2_001.trimmed.fastq" $input_dir/$s"_R1_001.fastq.gz" $input_dir/$s"_R2_001.fastq.gz" -j 3 --discard-untrimmed --action=retain

       mixcr -Xmx20G analyze generic-amplicon --species hsa --dna --floating-left-alignment-boundary --floating-right-alignment-boundary J -t 4 --library mylibrary_IGKL.json --assemble-contigs-by CDR3 --add-step assembleContigs --append-export-clones-field -vHit --append-export-clones-field -dHit --append-export-clones-field -jHit --append-export-clones-field -cHit -f  $s"_IGKL"
       
       # If there was no IGL chains
       if [ ! -f $s""_IGKL.clones_IGL.tsv ]; then
        head -n 1 $s""_IGKL.clones_IGK.tsv > $s""_IGKL.clones_IGL.tsv
       fi

       
       mixcr exportAlignments -vHit -dHit -jHit -cHit -cloneId -readIds -chains -targetSequences $s"_IGKL".clna $s"_IGKL".alignments.tsv -f

       mixcr -Xmx20G analyze generic-amplicon --species hsa --dna --floating-left-alignment-boundary --floating-right-alignment-boundary J -t 4 --library my_library_IGH.json --assemble-contigs-by CDR3 --add-step assembleContigs  --append-export-clones-field -vHit --append-export-clones-field -dHit --append-export-clones-field -jHit --append-export-clones-field -cHit -f $s"_R2_001.trimmed.fastq" $s"_IGH"
       mixcr exportAlignments -vHit -dHit -jHit -cHit -cloneId -readIds $s"_IGH".clna $s"_IGH".alignments.tsv -f
done < "$sample_file"