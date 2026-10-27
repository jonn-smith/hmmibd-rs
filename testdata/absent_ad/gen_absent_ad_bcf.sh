#!/usr/bin/env bash
# Regenerates absent_ad.bcf, the fixture for the dominant-allele reader's
# handling of genotypes without FORMAT/AD data (see src/bcf.rs tests).
# Site 100: GT+AD present; s2 has AD=. with GT=./. (no coverage), s4 has
#           AD=. with GT=1/1 (GT resolves the call).
# Site 200: AD only, no GT; absent AD falls through to the absent-ad-as flag.
# Site 300: s2 has explicit AD=0,0 with GT=0/0 (stays missing: zero reads);
#           s4 AD=. GT=0/0 (ref via GT); s5 AD=. GT=0/1 (het: missing).
set -euo pipefail
cd "$(dirname "$0")"
bcftools view -Ob -o absent_ad.bcf - << 'VCF'
##fileformat=VCFv4.2
##contig=<ID=chr1,length=100000>
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##FORMAT=<ID=AD,Number=R,Type=Integer,Description="Allelic depths">
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	s1	s2	s3	s4	s5
chr1	100	.	A	T	.	PASS	.	GT:AD	0/0:30,0	./.:.	1/1:0,25	1/1:.	0/1:10,10
chr1	200	.	G	C	.	PASS	.	AD	20,0	.	25,0	.	2,18
chr1	300	.	C	A	.	PASS	.	GT:AD	0/0:28,0	0/0:0,0	1/1:0,30	0/0:.	0/1:.
VCF
