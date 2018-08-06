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
	parser = ArchArgumentParser(description="Get data for one or more PVs", fromfile_prefix_chars='@')
	group = parser.add_mutually_exclusive_group()
	group.add_argument('-v', '--verbose', help="Turn on verbose output", action="store_true")
	group.add_argument('-q', '--quiet', help="Be vewwy quiet", action="store_true")
	parser.add_argument('-s', '--server', help="Server where archiver appliance is running", default="arch02.als.lbl.gov")
	parser.add_argument('-p', '--port', help="Port on which archiver appliance is running", type=int, default="17665")
	parser.add_argument('-b', '--begin', help="Start date/time; format=YYYY-MM-DDTHH:MM:SS.MMMZ.  Timezone Z may be replaced by offset in hours, e.g. PST=-08")
	parser.add_argument('-e', '--end', help="End date/time; format=YYYY-MM-DDTHH:MM:SS.MMMZ.  Timezone Z may be replaced by offset in hours, e.g. PST=-08")
	parser.add_argument('-o', '--output', help="Output path/filename")
	parser.add_argument('pvs', nargs="+", help="pv name(s).")

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
	
	with open(args.output, 'w') as f:
		for pvname in args.pvs:
			logging.info('PV %s' % pvname)
			result = client.getData(pvname, args.begin, args.end)
			f.write(result)

