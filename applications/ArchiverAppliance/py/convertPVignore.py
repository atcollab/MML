__author__ = 'rfgunion'

from PVImportConfig import PathImportItem, IOCImportItem, PVImportItem, DBImportItem
import time
import os

def translateLine(line, type, captureGroupsIn={}):
	line = line.strip()
	(line, captureGroupsOut) = extractCaptureGroups(line)
	line = replaceCaptureGroups(line, captureGroupsIn)
	excludechar = '-'
	if line.startswith('!'):
		excludechar = '+'
		line = line[1:]
	result = excludechar+type+':'+line
	return (result, captureGroupsOut)

def extractCaptureGroups(line):
	captureregex = re.compile(r'(.*)\(\?P<(.+)>(.+)\)(.*)')
	capturegroups = {}
	m = captureregex.match(line)
	while m is not None:
		capturegroups[m.group(2)] = m.group(3)
		line = m.group(1)+'('+m.group(3)+')'+m.group(4)
		m = captureregex.match(line)
	return (line, capturegroups)

def replaceCaptureGroups(line, capturegroups):
	for name, repl in capturegroups.items():
		line = line.replace('(?@='+name+')', '('+repl+')')
	return line

def writeDBLines(dbitem, o):
	print 'writeDBLines('+dbitem.expression+'): parent expression = '+dbitem.parent.expression
	for d in os.listdir('/vxboot'):
		m = re.match(dbitem.parent.expression, d)
		if m is None:
			print 'directory does not match regex: '+d
			continue
		print 'directory matches: '+d
		path = '/vxboot/'+d+'/boot/db'
		for dbfile in os.listdir(path):
			m = re.match(dbitem.expression, dbfile)
			if m is None:
				print 'dbfile does not match: '+dbfile
				continue
			print 'dbfile matches: '+dbfile
			with open(path+'/'+dbfile) as f:
				for l in f:
					l = l.strip()
					m = re.match('^record\(\w+, *"?([^ "]+)"?\)\s*{?$', l)
					if m is None:
						print 'not a record line: *'+l+'*'
						continue
					print 'Found pv: '+m.group(1)
					l = re.sub(r'\$\([^)]+\)', '.+', m.group(1))
					o.write('\t\t-pv:'+l+'\n')

if __name__=='__main__':
	import argparse
	import re
	parser = argparse.ArgumentParser(description='Converts the old PVignore file format to pvconfig.')
	parser.add_argument('-f', '--file', help='Name/path to the PVignore file', default='PVignore', type=file)
	parser.add_argument('-o', '--output', help='Name/path of file to write', default='pvconfig', type=argparse.FileType('w'))

	args = parser.parse_args()
	f = args.file
	o = args.output

	ioc = ''
	dbfile = ''
	pv = ''

	pathitem = PathImportItem('+path:/vxboot/PVnames')
	pathitems = [pathitem]
	iocitem = None
	pvitem = None
	iocCaptureGroups = {}
	dbCaptureGroups = {}

	regex = re.compile(r'(\t?)(\t?)(.*)')
	pathregex = re.compile(r'(.+)`(.+)`((D|F|L)?)$')
	captureregex = re.compile(r'(.*)\(\?P<(.+)>(.+)\)(.*)')
	capgroupname = None
	capgroup = None
	for line in f:
		if line.startswith('#'):
			print 'Skipping comment: '+line
			continue
		m = pathregex.match(line)
		if m is not None:
			print 'Proxy line: proxy='+m.group(1)+', path='+m.group(2)+', format='+m.group(3)
			excludechar = '-'
			if m.group(1)[0] == '!':
				excludechar = '+'
			proxyitem = PathImportItem(excludechar+'path:'+m.group(2))
			proxyformat = m.group(4)
			pathitems.append(proxyitem)
			proxyiocitem = IOCImportItem(excludechar+'ioc:'+m.group(1)[1:])
			proxyitem.addSubItem(proxyiocitem)
			proxyiocitem.parent = proxyitem
			iocitem = None
			dbitem = None
			continue
		m = regex.match(line)
		if m is None:
			print 'Cannot parse line: '+line
			continue
		if len(m.group(1)) == 0:
			print 'IOC regex: '+m.group(3)
			(line, iocCaptureGroups) = translateLine(line, 'ioc')
			iocitem = IOCImportItem(line)
			pathitem.addSubItem(iocitem)
			iocitem.parent = pathitem
			proxyitem = None
			dbitem = None
		elif len(m.group(2)) == 0:
			if proxyitem is None:
				print 'db file(s) regex: '+line
				if 'iocExit.db' in line:
					print 'skipping iocExit line'
					continue
				(line, dbCaptureGroups) = translateLine(line, 'db', iocCaptureGroups)
				dbitem = DBImportItem(line)
				iocitem.addSubItem(dbitem)
				dbitem.parent = iocitem
			else:
				print 'proxy subitem: '+line
				path = proxyitem.expression[1:-1] # strip ^ and $ from regex
				proxyiocitem = proxyitem.iocitems[0]
				if proxyformat == 'L':
					print 'Reading lines like {type} {pvname} from '+path+'/'+m.group(3)
					with open(path+'/'+m.group(3)) as fproxy:
						for l in fproxy:
							print 'Proxy line: '+l
							spl = l.split()
							pvitem = PVImportItem(excludechar+'pv:'+spl[1])
							proxyiocitem.addSubItem(pvitem)
							pvitem.parent = proxyiocitem
					if excludechar == '+':
						# exclude everything not listed in the file
						pvitem = PVImportItem('-pv:.+')
						proxyiocitem.addSubItem(pvitem)
						pvitem.parent = proxyiocitem
		else:
			print 'PV regex:'+line
			allCaptureGroups = iocCaptureGroups
			for n, v in dbCaptureGroups.items():
				allCaptureGroups[n] = v
			(line, pvCaptureGroups) = translateLine(line, 'pv', allCaptureGroups)
			pvitem = PVImportItem(line)
			if dbitem is not None:
				dbitem.addSubItem(pvitem)
				pvitem.parent = dbitem
			else:
				iocitem.addSubItem(pvitem)
				pvitem.parent = iocitem
	f.close()

	o.write('# PVignore file converted '+time.asctime()+'\n')
	# Ignore all heartbeats
	o.write('-pv:.+:hb\n')
	o.write('-pv:.+:HEARTBEAT\n')
	for pathitem in pathitems:
		o.write(pathitem.getLine())
		for iocitem in pathitem.iocitems:
			if len(iocitem.dbitems) == 0 and len(iocitem.pvitems) == 0:
				print 'No children under '+iocitem.expression
				continue
			iocitem.excludechar = '+'
			o.write('\t'+iocitem.getLine())
			for dbitem in iocitem.dbitems:
				writeDBLines(dbitem, o)
				o.write('\t\t**** DB: '+dbitem.getLine())
				for pvitem in dbitem.pvitems:
					o.write('\t\t\t'+pvitem.getLine())
			for pvitem in iocitem.pvitems:
				o.write('\t\t'+pvitem.getLine())
	o.close()
