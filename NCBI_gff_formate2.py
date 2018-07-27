import sys


with open(sys.argv[1]) as f:
    groups = f.read().strip().split('\n\n')

for group in groups:
    group = group.split('\n')
    group = [x.split('\t') for x in group]
    mrnas = []
    rna = []
    name = group[0][8][3:]
    for g in group[1:]:
        if g[2] == 'mRNA':
            if rna:
                mrnas.append(rna)
                rna = []
            rna.append(g)
        else:
            rna.append(g)
    if rna:
        mrnas.append(rna)
    mrnas.sort(key=lambda x:int(x[0][4])-int(x[0][3]),reverse=True)
    rna = mrnas[0]
    rna_name = rna[0][8].split(';')[0][3:]
    for r in rna[1:]:
        if r[2] == 'exon':
            nm_name = r[8].split(';')[2].split(':')[1]
        if r[2] == 'CDS':
            np_name = r[8].split(';')[2].split(':')[1]
    print '%s\t%s\t%s\t%s' % (name,rna_name,nm_name,np_name)
