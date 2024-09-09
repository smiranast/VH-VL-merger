sample_file="" # txt file with a list of sample names for amp1 (fastq name before _R{1,2}_001.fastq.gz)
input_dir="" # Directory with input fastq files for amplicone 1

while read s; do
        echo "$s"
	cutadapt -g CAGRTBCAGCTKGTRCAGTCTGG -g CAGRTCACCTTGARGGAGTCTGGTCCT -g SARGTGCAKCTGGTGGAGTC -g CAGSTRCAGCTRCAGSAGTC -G TGARGAGACGGTGACCRTKGTCCC -G TGAGGAGACRGTGACCAGGGT -o $s"_R1_001.trimmed.fastq" -p $s"_R2_001.trimmed.fastq" $input_dir/$s"_R1_001.fastq.gz" $input_dir/$s"_R2_001.fastq.gz" -j 3 --discard-untrimmed --action=retain
        mixcr -Xmx20G analyze amplicon -s hs --starting-material dna -t 4 --contig-assembly --5-end v-primers --3-end j-primers --adapters adapters-present --align -OvParameters.parameters.absoluteMinScore=40 --align -OdParameters.absoluteMinScore=25 --align -OjParameters.parameters.absoluteMinScore=40 --align -OmaxHits=3 --library my_library_IGH.json -r report_$s"_2" $s"_R1_001.trimmed.fastq" $s"_R2_001.trimmed.fastq"  $s"_2" --receptor-type igh --export "--preset min" --export "-cloneId -fraction -targetSequences"
done < "$sample_file"


sample_file="" # Same for amp2
input_dir="" # Directory with input fastq files for amplicone 2

while read s; do
        echo "$s"
       cutadapt -G TGGAGCTGAGCAGCCTGAGATCTGA -G CAATGACCAACATGGACCCTGTGG -G TCTGCAAATGAACAGCCTGAGAGCC -G AGCTCTGTGACCGCCGCGGACAC -G CACCGCCTACCTGCAGTGGAGC -G TTCTCCCTGCAGCTGAACTCTGTG -G CACGGCATATCTGCAGATCA -G Tggagctgagcagcctgagatccga -G Tctgcaaatgaacagcctgaaaacc -G TTctgcaaatgaacagtctgagaRct -G Ttcttcaaatgggcagcctgagagct -G cacggcatatctgcagatct -G TAgctctgtgactgccgcagacac -o $s"_R1_001.trimmed.fastq" -p $s"_R2_001.trimmed.fastq" $input_dir/$s"_R1_001.fastq.gz" $input_dir/$s"_R2_001.fastq.gz" -j 3 --discard-untrimmed --action=retain

       mixcr -Xmx20G analyze amplicon -s hs --starting-material dna -t 4 --contig-assembly --5-end v-primers --3-end j-primers --adapters adapters-present --align -OvParameters.parameters.absoluteMinScore=40 --align -OdParameters.absoluteMinScore=25 --align -OjParameters.parameters.absoluteMinScore=40 --align -OmaxHits=3 --library mylibrary_IGKL.json -r report_$s"_IGKL" $s"_R1_001.trimmed.fastq"  $s"_IGKL" --receptor-type bcr --export "--preset min" --export "-cloneId -fraction -targetSequences"
        mixcr exportAlignments --preset min -cloneId -readIds -chains -targetSequences $s"_IGKL".clna $s"_IGKL".alignments.txt -f

	mixcr -Xmx20G analyze amplicon -s hs --starting-material dna -t 4 --contig-assembly --5-end v-primers --3-end j-primers --adapters adapters-present --align -OvParameters.parameters.absoluteMinScore=40 --align -OdParameters.absoluteMinScore=25 --align -OjParameters.parameters.absoluteMinScore=40 --align -OmaxHits=3 --library my_library_IGH.json -r report_$s"_IGH" $s"_R2_001.trimmed.fastq"  $s"_IGH" --receptor-type igh
        mixcr exportAlignments --preset min -cloneId -readIds $s"_IGH".clna $s"_IGH".alignments.txt -f
done < "$sample_file"