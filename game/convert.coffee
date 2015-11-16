fs = require 'fs'
owl2 = fs.readFileSync 'OWL2.txt','utf8'
wordList = owl2.split('\n')
fileContents = """
	root = typeof exports === "undefined" ? window : exports;
	root.OWL2 = ['#{wordList.join "',\n'"}']
"""
fs.writeFile 'OWL2.js', fileContents