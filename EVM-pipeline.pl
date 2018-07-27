#! /usr/bin/perl -w
use strict;
use warnings;
use FindBin qw($Bin);
my $bin = $Bin;
if(@ARGV <5){
     print STDERR "EVM-pipeline.pl genome denovo.list transcript.list homology.list prefix\n";
     print STDERR "All list files contain the corresponding gff result file name\n";
     exit;
}

my $genome = shift;
my $denovo = shift;
my $transcript = shift;
my $homology = shift;
my $prefix = shift;

my $dir = `pwd`;
chomp $dir;
`mkdir gff3`;

my $weight = $prefix."-weight.txt";
open(WEIGHT,">$weight") or die;
open(DENOVO,"<$denovo") or die;
while(<DENOVO>){
    chomp $_;
    if($_ =~ /augustus/i){
       `perl $bin/augustus_out_to_gff3.pl $_ >gff3/augustus.1.gff3`;
       `perl $bin/format_augustus_gff3.pl gff3/augustus.1.gff3 >gff3/augustus.gff3`;
       `cat gff3/augustus.gff3 >>gff3/evm.gene.predict.gff3`;
        print WEIGHT "ABINITIO_PREDICTION\tAUGUSTUS\t1\n";
    }elsif($_ =~ /genemark/i){
        `perl $bin/genemark_out_to_gff3.pl $_`;
        `cp genemark_out.gff3 ./gff3/`;
        `cat gff3/genemark_out.gff3 >>gff3/evm.gene.predict.gff3`;
         print WEIGHT "ABINITIO_PREDICTION\tGeneMark.hmm\t1\n";
    }elsif($_ =~ /glimmerhmm/i){
        `perl $bin/glimmerHMM_out_to_gff3.pl $_ $genome >gff3/glimmerhmm.gff3`;
        `cat gff3/glimmerhmm.gff3 >>gff3/evm.gene.predict.gff3`;
        print WEIGHT "ABINITIO_PREDICTION\tGlimmerHMM\t1\n";
    }elsif($_ =~ /snap/i){
        `perl $bin/SNAP_output_to_gff3.pl $_ >gff3/snap.gff3`;
        `cat gff3/snap.gff3 >>gff3/evm.gene.predict.gff3`;
        print WEIGHT "ABINITIO_PREDICTION\tSNAP\t1\n";
    }
}
close(DENOVO);

open(TRANS,"<$transcript") or die;
while(<TRANS>){
     chomp $_;
     `perl $bin/transcripts-alternative-splicing-redundancy.pl $_ >gff3/evm.transcript.predict.gff3`;
     `perl /work/liqiang/bio-soft/genome/predict/TransDecoder/TransDecoder-2.0.1/util/cufflinks_gtf_to_alignment_gff3.pl ./gff3/evm.transcript.predict.gff3 > gff3/evm.transcript.alignment.gff3`;
     #`perl $bin/transcript-out-to-gff3.pl $_ >gff3/evm.transcript.predict.gff3`;
     print WEIGHT "TRANSCRIPT\tCufflinks\t10\n";
}
close(TRANS);

open(HOMO,"<$homology") or die;
while(<HOMO>){
     chomp $_;
     $_ =~ /([^\/]+).gff/;
     my $pre = substr($1,0,4);
     my $modify = $1.".modify.gff";
     my $out = $1.".gff3";
     `perl $bin/exonerate.modify.pl $_ >gff3/$modify`;
     `perl $bin/exonerate_gff_to_alignment_gff3.pl  gff3/$modify  $pre >gff3/$out`;
     #`perl $bin/exonerate-out-to-gff3.pl $_ $pre >gff3/$out`;
     `cat gff3/$out >> gff3/evm.homology.predict.gff3`;
     print WEIGHT "PROTEIN\texonerate-$pre\t2\n";
}
close(HOMO);
close(WEIGHT);

`mkdir EVM-details`;
open(NEXT,">./EVM-details/evm.sh") or die;
print NEXT "perl $bin/evm.pl $genome $dir/gff3/evm.gene.predict.gff3 $dir/gff3/evm.transcript.alignment.gff3 $dir/gff3/evm.homology.predict.gff3 $dir/$weight\n";
print NEXT "perl /data2/pxj/euk_gene_predication/soft/EVM_r2012-06-25/EvmUtils/gff3_file_to_proteins.pl evm_final.gff3 $genome prot >evm_final.protein.faa\n";
