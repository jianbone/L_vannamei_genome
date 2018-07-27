import re
import sys


p = re.compile(r'(Genbank:.+?)[,;]')

with open(sys.argv[1]) as f:
	rows = [x.strip().split('\t') for x in f if x.startswith('#') == False]

names = ['gene','mRNA','exon','CDS']

rows = [x for x in rows if x[2] in names]

group = []
for row in rows:
	if row[2] == 'gene':
		if group:
			if len(group) >= 4 and group[0][2] == 'gene' and group[1][2] == 'mRNA':
				group = ['\t'.join(x) for x in group]
				print '\n'.join(group)
				print
			group = []
		row[8] = row[8].split(';')[0]
		group.append(row)
	if row[2] == 'mRNA':
		row[8] = ';'.join(row[8].split(';')[:2])
		group.append(row)
	if row[2] == 'exon':
		m = p.search(row[8])
		if m:
			row[8] = ';'.join(row[8].split(';')[:2]+[m.group(1)])
			group.append(row)
	if row[2] == 'CDS':
		m = p.search(row[8])
		if m:
			row[8] = ';'.join(row[8].split(';')[:2]+[m.group(1)])
			group.append(row)
