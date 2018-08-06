__author__ = 'rfgunion'

import unittest
import os
from PVImportConfig import PVImportConfig, PVImportItem, IOCImportItem, PathImportItem

class PVImportConfigTest(unittest.TestCase):
	fname = 'pvconfigtest.txt'

	def setUp(self):
		text = '''
# Here's an example file.  This line is a comment.
-pv:.*:hb$ # pvs ending in ":hb" will be ignored, regardless of which path/ioc they are in
-ioc:.*junk.* # iocs whose name contains "junk" will be ignored, regardless of path
path:/vxboot/PVnames # The directory name
	-ioc:junkioc # This ioc will be ignored
	+ioc:goodioc # This ioc will be included, subject to the following line(s)
		-pv:^junk.* # pvs whose names start with junk will be ignored
		'''
		f = open(self.fname, 'w')
		f.write(text)
		f.close()

	def tearDown(self):
		os.unlink(self.fname)

	def test_readWithNoArg(self):
		config = PVImportConfig(self.fname)
		self.assertTrue(config.read())
		self.assertEqual(3, len(config.items))
		self.assertIsInstance(config.items[0], PVImportItem)
		self.assertIsInstance(config.items[1], IOCImportItem)
		self.assertIsInstance(config.items[2], PathImportItem)
		pathitem = config.items[2]
		self.assertEqual(len(pathitem.iocitems), 3)
		iocitem = pathitem.iocitems[0]
		self.assertEqual(len(iocitem.pvitems), 1)
		del config

	def test_readWithArg(self):
		config2 = PVImportConfig('')
		self.assertTrue(config2.read(self.fname))
		del config2

if __name__ == '__main__':
	unittest.main()
