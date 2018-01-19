# -*- coding: utf-8 -*-
fileINP = raw_input("Nomefile: ")
in_file = open(fileINP,"r")
text = in_file.read()
in_file.close()

text = text.replace("%","")
text = text.replace(" ","")
text = text.replace("–","\N")

out_file = open("out.txt","w")
out_file.write(text)
out_file.close()
