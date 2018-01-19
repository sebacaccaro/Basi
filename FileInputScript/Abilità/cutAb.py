fileINP = raw_input("Nomefile: ")
in_file = open(fileINP,"r")
text = in_file.read()
in_file.close()

finalstr = ""
for line in text.splitlines():
	line = line[line.find('\t')+1:]
	linecp = line[line.find('\t')+1:]
	delt = linecp.find('\t')
	delt += line.find('\t')
	finalstr += line[:delt]
	finalstr += '\n'

out_file = open("out2.txt","w")
out_file.write(finalstr)
out_file.close()
