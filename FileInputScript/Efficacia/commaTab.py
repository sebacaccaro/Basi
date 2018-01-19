fileINP = raw_input("Nomefile: ")
in_file = open(fileINP,"r")
text = in_file.read()
in_file.close()

finalstr = ""
for line in text.splitlines():
	for linedx in text.splitlines():
		finalstr += line
		finalstr += '\t'
		finalstr += linedx
		finalstr += '\n' 

out_file = open("out.txt","w")
out_file.write(finalstr)
out_file.close()
