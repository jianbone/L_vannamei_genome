#! /usr/bin/perl

my $gff = shift;
open(FILE,"<$gff") or die;
 while(<FILE>){
     chomp;
     unless(/#/){
          my @a = split;
          if($a[2] and $a[2] eq 'gene'){
               print  "$_\n";
               $i=0;
          }elsif($a[2] and $a[2] eq 'transcript'){
               $_=~s/transcript/mRNA/;
               print  "$_\n";
          }elsif($a[2] and $a[2] eq 'CDS'){
               $i++;
               my $cds=$_;
               $_=~s/cds;/exon.$i;/;
               $_=~s/CDS/exon/;
               print  "$_\n";
               $cds=~s/cds;/cds.$i;/;
               print  "$cds\n";
          }
      }
}
close(FILE);
