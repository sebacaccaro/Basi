fileINP = raw_input("Nomefile: ")
in_file = open(fileINP,"r")
text = in_file.read()
in_file.close()

finalstr = ""
for line in text.splitlines():
	line = line[line.find('#'):]
	line = line[1:]
	line = line[9:]
	line = line[line.find('\t')+1:]
	line = line[line.find('\t')+1:]
	if line.find('\t') == -1:
		line += "\t\N"
	finalstr += line;
	finalstr += "\n"

out_file = open("out2.txt","w")
out_file.write(finalstr)
out_file.close()
