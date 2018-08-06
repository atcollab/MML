__author__ = 'rfgunion'

from ArchClient import ArchClient
import logging

if __name__=='__main__':
	import argparse
	parser = argparse.ArgumentParser(description='delete pvs listed in a file, one per line')
	group = parser.add_mutually_exclusive_group()
	group.add_argument('-v', '--verbose', help="Turn on verbose output", action="store_true")
	group.add_argument('-q', '--quiet', help="Be vewwy quiet", action="store_true")
	parser.add_argument('-s', '--server', help="Server where archiver appliance is running (default arch02.als.lbl.gov)", default="arch02.als.lbl.gov")
	parser.add_argument('-p', '--port', help="Port on which archiver appliance is running (default 17665)", type=int, default="17665")
	parser.add_argument('file', help='File(s) from which to read pv names, one per line', type=file, nargs='+')

	args = parser.parse_args()

	level = logging.INFO
	if args.verbose:
		level = logging.DEBUG
	elif args.quiet:
		level = logging.WARNING
	logging.basicConfig(format="%(asctime)s %(levelname)s %(message)s", level=level)

	client = ArchClient()
	client.server = args.server
	client.port = args.port

	for f in args.file:
		for pvname in f:
			if pvname.startswith('#'):
				continue
			# If pvs get in archiver accidentally with spaces leading or trailing,
			# we will want to remove them.
			pvname = pvname.strip()
			#pvname = pvname[0:-1]
			if pvname == '':
				continue
			print 'Pausing pv "%s"' % pvname
			print client.pauseArchivingPV(pvname)
			print 'Deleting pv "%s"' % pvname
			print client.deletePV(pvname)
