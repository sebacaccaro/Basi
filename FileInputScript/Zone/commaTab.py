fileINP = raw_input("Nomefile: ")
in_file = open(fileINP,"r")
text = in_file.read()
in_file.close()

finalstr = ""
text = text.replace(" (Kanto)","")
for line in text.splitlines():
	line = line[line.find("title")+7:]
	line = line[:line.find('"')]	
	finalstr += line
	finalstr += '\n'

out_file = open("out.txt","w")
out_file.write(finalstr)
out_file.close()
