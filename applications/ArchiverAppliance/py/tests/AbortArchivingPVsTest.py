__author__ = 'rfgunion'

import unittest
from ArchClient import ArchClient

class AbortArchivingPVsTest(unittest.TestCase):
	client = None
	pvnames = [
		'001abortArchivingPVsTest:pvone', \
		'001abortArchivingPVsTest:pvtwo', \
		'001abortArchivingPVsTest:pvthree', \
		'001abortArchivingPVsTest:pvfour' \
	]

	def setUp(self):
		self.client = ArchClient()

	def test_abortArchivingPVs(self):
		pvnames = ','.join(self.pvnames)
		respobj = self.client.archivePV(pvnames)
		self.assertIsNotNone(respobj)
		for pvname in self.pvnames:
			self.client.abortArchivingPV(pvname)

if __name__ == '__main__':
	unittest.main()
