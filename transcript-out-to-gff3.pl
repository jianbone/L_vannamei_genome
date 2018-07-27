#! /usr/bin/perl

my $file = shift;

my $id1; my $id2;
open(FILE,"<$file") or die;
 while(<FILE>){
     chomp;
     unless(/#/){
          my @a = split /\t/,$_;
          if($a[2] and $a[2] eq 'transcript'){
               my $tmp = $_;
               $tmp =~ s/transcript/gene/;
               $_=~s/transcript/mRNA/;
               #print  "$tmp\n$_\n";
               $a[8] =~ /gene_id \"(\S+)\"/;
               $id1 = $1;
               
               print "$a[0]\t$a[1]\tgene\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\tID=$id1\n";
               $id2 = "mRNA.".$id1;
               print "$a[0]\t$a[1]\tmRNA\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\tID=$id2;Parent=$id1\n";
               $i=0;
          }elsif($a[2] and $a[2] eq 'exon'){
               $i++;
               my $cds=$_;
               
               $_=~s/cds;/exon.$i;/;
                
               print  "$a[0]\t$a[1]\texon\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\tID=$id2.exon$i;Parent=$id2\n";
               print  "$a[0]\t$a[1]\tCDS\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\tID=$id2.cds$i;Parent=$id2\n";
               
          }
      }
}
close(FILE);

