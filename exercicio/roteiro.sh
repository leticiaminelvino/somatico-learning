
sudo apt-get install samtools

wget -c https://hgdownload.soe.ucsc.edu/goldenPath/hg19/chromosomes/chr19.fa.gz

wget -c https://hgdownload.soe.ucsc.edu/goldenPath/hg19/chromosomes/chr13.fa.gz

zcat chr13.fa.gz chr19.fa.gz | sed -e "s/chr//g" > hg19.fa

samtools faidx hg19.fa

wget -c https://github.com/broadinstitute/gatk/releases/download/4.2.2.0/gatk-4.2.2.0.zip

./gatk-4.2.2.0/gatk CreateSequenceDictionary -R hg19.fa -O hg19.dict

./gatk-4.2.2.0/gatk ScatterIntervalsByNs -R hg19.fa -O hg19.interval_list -OT ACGT


#### 190 191 ####

mkdir 190-191-outputs

samtools view -H tumor_wp191.bam

./gatk-4.2.2.0/gatk Mutect2 \
	-R hg19.fa \
	-I tumor_wp190.bam \
	-I tumor_wp191.bam \
	-normal WP191 \
	--germline-resource af-only-gnomad-chr13-chr19.vcf.gz \
	-O somatic190191.vcf.gz \
	-L hg19.interval_list


./gatk-4.2.2.0/gatk GetPileupSummaries \
	-I tumor_wp190.bam \
	-V af-only-gnomad-chr13-chr19.vcf.gz \
	-L hg19.interval_list \
	-O 190-191-outputs/tumor_wp190.table


./gatk-4.2.2.0/gatk GetPileupSummaries \
	-I tumor_wp191.bam \
	-V af-only-gnomad-chr13-chr19.vcf.gz \
	-L hg19.interval_list \
	-O 190-191-outputs/normal_wp191.table


./gatk-4.2.2.0/gatk CalculateContamination \
	-I 190-191-outputs/tumor_wp190.table \
	-matched 190-191-outputs/normal_wp191.table \
	-O 190-191-outputs/contamination190191.table


./gatk-4.2.2.0/gatk FilterMutectCalls \
	-R hg19.fa \
	-V 190-191-outputs/somatic190191.vcf.gz \
	--contamination-table 190-191-outputs/contamination190191.table \
	-O 190-191-outputs/filtered190191.vcf.gz



#### 17 18 ####

mkdir 017-018-outputs

samtools view -H tumor_wp018.bam

./gatk-4.2.2.0/gatk Mutect2 \
	-R hg19.fa \
	-I tumor_wp017.bam \
	-I tumor_wp018.bam \
	-normal WP018 \
	--germline-resource af-only-gnomad-chr13-chr19.vcf.gz \
	-O 017-018-outputs/somatic017018.vcf.gz \
	-L hg19.interval_list


./gatk-4.2.2.0/gatk GetPileupSummaries \
	-I tumor_wp017.bam \
	-V af-only-gnomad-chr13-chr19.vcf.gz \
	-L hg19.interval_list \
	-O 017-018-outputs/tumor_wp017.table


./gatk-4.2.2.0/gatk GetPileupSummaries \
	-I tumor_wp018.bam \
	-V af-only-gnomad-chr13-chr19.vcf.gz \
	-L hg19.interval_list \
	-O 017-018-outputs/normal_wp018.table


./gatk-4.2.2.0/gatk CalculateContamination \
	-I 017-018-outputs/tumor_wp017.table \
	-matched 017-018-outputs/normal_wp018.table \
	-O 017-018-outputs/contamination017018.table


./gatk-4.2.2.0/gatk FilterMutectCalls \
	-R hg19.fa \
	-V 017-018-outputs/somatic017018.vcf.gz \
	--contamination-table 017-018-outputs/contamination017018.table \
	-O 017-018-outputs/filtered017018.vcf.gz
