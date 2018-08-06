__author__ = 'rfgunion'

import unittest

from ArchClient import ArchClient

class ArchClientTest(unittest.TestCase):
	client = None

	def setUp(self):
		self.client = ArchClient()

	def test_getEveryPV(self):
		pvs = self.client.getEveryPV()
		self.assertGreater(len(pvs), 1)


if __name__ == '__main__':
	unittest.main()
