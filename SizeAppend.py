import os
def SizeAppend(name):
	statinfo = os.stat(name)
	fi = open(name, 'r')
	text = fi.read()
	while ((len(text) % 16 == 0) == False):
		text += ' '
	return text