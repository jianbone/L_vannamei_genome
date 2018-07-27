#! /usr/bin/perl
my $file = shift;
 open FILE,$file;
                open OUT,">genemark_out.gff3";
                my %s;
                my %e;
                my %line;
                my %c;
                while(<FILE>){
                        chomp;
                        my @a = split;
                        if($a[2] and $a[2] eq 'start_codon'){
                                $a[9]=~/"(.*)"/;
                                my $tag=$1;
                                $s{$tag}=$a[3];
                                if($a[6] eq '-'){
                                        $s{$tag}=$a[4];
                                }
                                if($s{$tag} and $e{$tag}){
                                        my $s;
                                        my $e;
                                        if($s{$tag}<$e{$tag}){
                                                $s=$s{$tag};
                                                $e=$e{$tag};
                                        }
                                        else{
                                                $s=$e{$tag};
                                                $e=$s{$tag};
                                        }
                                        print OUT "$a[0]\t$a[1]\tgene\t$s\t$e\t$a[5]\t$a[6]\t$a[7]\tID=$tag;Name=gene.$tag\n";
                                        print OUT "$a[0]\t$a[1]\tmRNA\t$s\t$e\t$a[5]\t$a[6]\t$a[7]\tID=mRNA.$tag;Parent=$tag\n";
                                        print OUT $line{$tag};
                                }
                                $c{$tag}=0;
                        }
                        elsif($a[2] and $a[2] eq 'CDS'){
                                $a[9]=~/"(.*)"/;
                                my $tag=$1;
                                $c{$tag}++;
                                my $line="$a[0]\t$a[1]\texon\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\tID=exon.$tag.$c{$tag};Parent=mRNA.$tag\n$a[0]\t$a[1]\tCDS\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\tID=cds.$tag.$c{$tag};Parent=mRNA.$tag\n";
                                $line{$tag}.=$line;
                        }
                        elsif($a[2] and $a[2] eq 'stop_codon'){
                                $a[9]=~/"(.*)"/;
                                my $tag = $1;
                                $e{$tag}=$a[4];
                                if($a[6] eq '-'){
                                        $e{$tag}=$a[3];
                                }
                                if($s{$tag} and $e{$tag}){
                                        my $s;
                                        my $e;
                                        if($s{$tag}<$e{$tag}){
                                                $s=$s{$tag};
                                                $e=$e{$tag};
                                        }
                                        else{
                                                $s=$e{$tag};
                                                $e=$s{$tag};
                                        }
                                        print OUT "$a[0]\t$a[1]\tgene\t$s\t$e\t$a[5]\t$a[6]\t$a[7]\tID=$tag;Name=gene.$tag\n";
                                        print OUT "$a[0]\t$a[1]\tmRNA\t$s\t$e\t$a[5]\t$a[6]\t$a[7]\tID=mRNA.$tag;Parent=$tag\n";
                                        print OUT $line{$tag};
                                }
                                $c{$tag}=0;
                        }
               
}
