fileINP = raw_input("Nomefile: ")
in_file = open(fileINP,"r")
text = in_file.read()
in_file.close()

finalstr = ""
for line in text.splitlines():
	line = line[:line.find('(')-2]
	finalstr += line
	finalstr += "\n"

out_file = open("out.txt","w")
out_file.write(finalstr)
out_file.close()
