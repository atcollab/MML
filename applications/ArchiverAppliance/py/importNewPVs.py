__author__ = 'rfgunion'

from ArchClient import ArchClient
import argparse
import os
import sys
import logging
import re

class ArchArgumentParser(argparse.ArgumentParser):

	def convert_arg_line_to_args(self, arg_line):
		for arg in arg_line.split('='):
			if not arg.strip():
				continue
			yield arg

def parseImportArgs():
	parser = ArchArgumentParser(description="Scan for new PVs and add them to the archiver configuration", fromfile_prefix_chars='@')
	group = parser.add_mutually_exclusive_group()
	group.add_argument('-v', '--verbose', help="Turn on verbose output", action="store_true")
	group.add_argument('-q', '--quiet', help="Be vewwy quiet", action="store_true")
	parser.add_argument('-n', '--noprompt', help="Do not prompt for confirmation", action='store_true')
	parser.add_argument('-c', '--config', help="Configuration file (--argname[=value])", type=file)
	parser.add_argument('-s', '--server', help="Server where archiver appliance is running", default="arch02.als.lbl.gov")
	parser.add_argument('-p', '--port', help="Port on which archiver appliance is running", type=int, default="17665")
	parser.add_argument('-i', '--ignore', help="Path/filename of ignore file", type=file)
	parser.add_argument('-r', '--regex', action='append', help="Regular expression(s) to ignore")
	parser.add_argument('-t', '--time', type=int, help="Sampling interval in seconds", default=60)
	parser.add_argument('-l', '--dblpath', help="Path to dbl files")
	parser.add_argument('files', nargs="+", help="dbl filename(s) to read")

	args = parser.parse_args()

	if args.config is not None:
		for line in args.config:
			print line
			(key, val) = line.split('=')
			args.__set__(key, val)

	level = logging.INFO
	if args.verbose:
		level = logging.DEBUG
	elif args.quiet:
		level = logging.WARNING
	logging.basicConfig(format="%(asctime)s %(levelname)s %(message)s", level=level)

	return args

def createClient(args):
	logging.info('Creating archiver client: server = %s, port = %d'
			% (args.server, args.port))
	client = ArchClient()
	client.server = args.server
	client.port = args.port
	return client

def menu():
	print 'e: list existing pvs'
	print 'n: list new pvs'
	print 's: submit the new pvs'
	print 'q: quit the program without submitting'
	response = raw_input('Select an option: ')
	return response.lower()

def reportandconfirm(existingpvs, newpvs):
	response = ''
	while response != 'q':
		response = menu()
		if response == 'q':
			return False
		elif response == 's':
			return True
		elif response == 'e':
			print '%d pvs found but already in the archiver:' % len(existingpvs)
			print '-----------------------------------------------'
			for pvname in existingpvs:
				print pvname
			print ''
		elif response == 'n':
			print '%d pvs to be added to the archiver:' % len(newpvs)
			print '-----------------------------------------------'
			for pvname in newpvs:
				print pvname
			print ''

if __name__ == '__main__':
	args = parseImportArgs()
	if args is None:
		sys.exit()

	client = createClient(args)
	oldpvnames = set(client.getEveryPV().keys())
	if oldpvnames is None:
		logging.critical('Unable to get existing pvs from server')
		sys.exit()
	logging.info('%d pvs already exist in the archiver configuration.' % len(oldpvnames))

	regexes = []
	if args.regex is not None:
		for r in args.regex:
			logging.debug('Adding regular expression: "%s"' % r)
			regexes.append(re.compile(r))
	if args.ignore is not None:
		logging.info('Parsing ignore file: %s' % args.ignore.name)
		for line in args.ignore:
			line = line.strip()
			if line.startswith('#'):
				logging.debug('Skipping comment "%s"' % line)
				continue
			index = line.find('#')
			if index >= 0:
				line = line.substring(0, index)
				line = line.strip()
			if len(line) == 0:
				logging.debug('Skipping empty line')
				continue
			if not line.endswith('$'):
				line = line+'$'
			logging.debug('Adding regular expression from file: "%s"' % line)
			regexes.append(re.compile(line))
	
	if args.dblpath is not None and not os.path.isdir(args.dblpath):
		logging.error("Invalid path: '%s'" % args.dblpath)
		sys.exit()

	dblpath = args.dblpath
	if dblpath is None:
		dblpath = '.'

	pvnames = set()
	for fname in args.files:
		path = os.path.join(dblpath, fname)
		logging.info('Reading file %s', path)
		f = open(path)
		if f is None:
			logging.critical('Cannot open file "%s"' % path)
			sys.exit()
		for pvname in f:
			pvname = pvname.strip()
			if len(pvname) == 0:
				continue
			logging.debug('Checking pvname "%s"' % pvname)
			matched = False
			for r in regexes:
				if r.match(pvname) is not None:
					logging.debug('PV "%s" matches regex "%s"' % (pvname, r.pattern))
					matched = True
					break
			if matched:
				continue
			pvnames.add(pvname)

	logging.info('Found %d pvs.  Checking against existing pvs.' % len(pvnames))
	existingpvs = pvnames & oldpvnames
	newpvs = pvnames - oldpvnames
	logging.info('Of %d pvs, %d are new, %d are already in archiver.'
			% (len(pvnames), len(newpvs), len(existingpvs)))

	doit = True
	if not args.noprompt:
		doit = reportandconfirm(existingpvs, newpvs)
	if not doit:
		logging.info('Aborting due to user request')
		sys.exit()

	logging.info('Submitting the new pvs..')
	response = client.archivePV(newpvs, args.time)
	if response is None:
		logging.critical('Failed to submit new pvs')
		sys.exit()

	logging.info('New pvs have been submitted.  Response:')
	print response

