import sys

if len(sys.argv) <2:
	print "python /work/wanglong/software/Gene_Annotate/NCBI_gff_formate_all.py gff faa ffn prefix > bash"
	sys.exit()

print "python /work/daihui/software/my-usr/Euk_Gene/script/NCBI_genome/NCBI_gff_formate.py "+sys.argv[1]+" >"+sys.argv[4]+".formate.gff"
print "python /work/daihui/software/my-usr/Euk_Gene/script/NCBI_genome/NCBI_gff_formate2.py "+sys.argv[4]+".formate.gff >"+sys.argv[4]+".duiying.list"
print "python /work/daihui/software/my-usr/Euk_Gene/script/NCBI_genome/NCBI_gff_formate3.py "+sys.argv[2]+" "+sys.argv[3]+" "+sys.argv[4]+".duiying.list "+sys.argv[4]
