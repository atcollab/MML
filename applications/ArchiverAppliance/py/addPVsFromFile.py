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
	parser = ArchArgumentParser(description="Add PVs to the archiver configuration", fromfile_prefix_chars='@')
	group = parser.add_mutually_exclusive_group()
	group.add_argument('-v', '--verbose', help="Turn on verbose output", action="store_true")
	group.add_argument('-q', '--quiet', help="Be vewwy quiet", action="store_true")
	parser.add_argument('-s', '--server', help="Server where archiver appliance is running (default arch02.als.lbl.gov)", default="arch02.als.lbl.gov")
	parser.add_argument('-p', '--port', help="Port on which archiver appliance is running (default 17665)", type=int, default="17665")
	parser.add_argument('-t', '--time', type=int, help="Sampling interval in seconds (default 60)", default=60)
	parser.add_argument('-m', '--method', help="Sampling method: either SCAN or MONITOR (default SCAN)", default='SCAN')
	parser.add_argument('-c', '--controlPV', help="Controlling PV name (none by default)", default='')
	parser.add_argument('-l', '--path', help="Path to files (default current directory)")
	parser.add_argument('files', nargs="+", help="filename(s) to read.  Each PV is listed on its own line.")

	args = parser.parse_args()

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

if __name__ == '__main__':
	args = parseImportArgs()
	if args is None:
		sys.exit()

	client = createClient(args)
	
	if args.path is not None and not os.path.isdir(args.path):
		logging.error("Invalid path: '%s'" % args.path)
		sys.exit()

	path = args.path
	if path is None:
		path = '.'

	pvnames = set()
	for fname in args.files:
		fullpath = os.path.join(path, fname)
		logging.info('Reading file %s', fullpath)
		f = open(fullpath)
		if f is None:
			logging.critical('Cannot open file "%s"' % fullpath)
			sys.exit()
		for pvname in f:
			pvname = pvname.strip()
			if len(pvname) == 0:
				continue
			logging.debug('Adding pvname "%s"' % pvname)
			pvnames.add(pvname)

	logging.info('Submitting the new pvs..')
	response = client.archivePV(pvnames, args.time, args.method, args.controlPV)
	if response is None:
		logging.critical('Failed to submit new pvs')
		sys.exit()

	logging.info('New pvs have been submitted.  Response:')
	print response

