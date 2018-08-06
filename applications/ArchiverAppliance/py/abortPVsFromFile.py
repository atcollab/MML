__author__ = 'rfgunion'

from ArchClient import ArchClient

if __name__=='__main__':
	import argparse
	parser = argparse.ArgumentParser(description='Aborts archive requests for pvs listed in a file, one per line')
	parser.add_argument('file', help='File(s) from which to read pv names, one per line', nargs='+', type=file)

	args = parser.parse_args()

	client = ArchClient()

	for f in args.file:
		for pvname in f:
			if pvname.startswith('#'):
				continue
			pvname = pvname.strip()
			if pvname == '':
				continue
			print client.abortArchivingPV(pvname)
