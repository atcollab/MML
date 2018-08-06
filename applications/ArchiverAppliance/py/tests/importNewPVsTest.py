__author__ = 'rfgunion'

import sys
import unittest
import importNewPVs
from ArchClient import ArchClient

class importNewPVsTest(unittest.TestCase):

	def setUp(self):
		sys.argv = sys.argv[0:1]

	def test_defaultargs(self):
		self.assertEqual(len(sys.argv), 1)
		args = importNewPVs.parseImportArgs()
		self.assertEqual(args.verbose, False)
		self.assertEqual(args.quiet, False)
		self.assertIsNone(args.config)
		self.assertEqual(args.server, 'arch02.als.lbl.gov')
		self.assertEqual(args.port, 17665)
		self.assertIsNone(args.dblpath)

	def test_testconfigfile(self):
		self.assertEqual(len(sys.argv), 1)
		sys.argv.append('@test.cfg')
		args = importNewPVs.parseImportArgs()
		self.assertTrue(args.verbose)
		self.assertEqual(args.server, 'testarchiver')
		self.assertEqual(args.port, 17666)
		self.assertListEqual(args.dblpath, ['/path1/subdir', '/path2/subdir'])

	def test_prodconfigfile(self):
		self.assertEqual(len(sys.argv), 1)
		sys.argv.append('@prod.cfg')
		args = importNewPVs.parseImportArgs()
		self.assertTrue(args.verbose)
		self.assertEqual(args.server, 'arch02.als.lbl.gov')
		self.assertEqual(args.port, 17665)
		self.assertListEqual(args.dblpath, ['/vxboot/PVnames'])

	def test_createClient(self):
		self.assertEqual(len(sys.argv), 1)
		sys.argv.append('@prod.cfg')
		args = importNewPVs.parseImportArgs()
		client = importNewPVs.createClient(args)
		self.assertIsInstance(client, ArchClient)
		self.assertEqual(client.server, 'arch02.als.lbl.gov')
		self.assertEqual(client.port, 17665)
		self.assertEqual(client.bplurl, '/mgmt/bpl/')


if __name__ == '__main__':
	unittest.main()
