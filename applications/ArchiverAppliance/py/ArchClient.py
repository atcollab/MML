'''
Created on Oct 29, 2013

@author: rfgunion
'''
from RestClient import RestClient
from PVTypeInfo import PVTypeInfo
import json
import urllib
import sys

class ArchClient(RestClient):
	'''
	classdocs
	'''

	def archivePV(self, pvnames, samplingperiod=60, samplingmethod='SCAN', controllingPV='', policy=''):
		params = {'pv':','.join(pvnames), 'samplingperiod':samplingperiod}
		if samplingmethod != 'MONITOR':
			params['samplingmethod'] = samplingmethod
		if controllingPV != '':
			params['controllingPV'] = controllingPV
		if policy != '':
			params['policy'] = policy
		resp = self.mgmtpost('archivePV', params)
		return resp

	def pauseArchivingPV(self, pvname):
		params = {'pv':pvname}
		return self.mgmtget('pauseArchivingPV', params)

	def resumeArchivingPV(self, pvname):
		params = {'pv':pvname}
		return self.mgmtget('resumeArchivingPV', params)

	def deletePV(self, pvname, deleteData=False):
		params = {'pv':pvname}
		if deleteData:
			params['deleteData'] = 'true'
		return self.mgmtget('deletePV', params)

	def abortArchivingPV(self, pvname):
		params = {'pv':pvname}
		return self.mgmtget('abortArchivingPV', params)

	def changeArchivalParams(self, pvname, period, method='SCAN'):
		params = {'pv':pvname,
				'samplingperiod':period,
				'samplingmethod':method}
		resp = self.mgmtget('changeArchivalParameters', params)
		return resp

	def getNeverConnectedPVs(self):
		'''
		Retrieve the list of pvs that have never connected.
		@return list of dicts, each with keys 'pvName' and 'requestedTime'
		'''
		return self.mgmtget('getNeverConnectedPVs')

	def getCurrentlyDisconnectedPVs(self):
		'''
		Retrieve the list of pvs that have never connected.
		@return list of dicts, each with keys 'pvName' and 'requestedTime'
		'''
		return self.mgmtget('getCurrentlyDisconnectedPVs')

	def getAllPVs(self, glob=""):
		'''
		Retrieve the list of pvs.  Excludes those that have never connected.
		@param string glob a glob-style wildcard to filter the list.  If empty
		or not provided, all pvs are returned
		@return list of strings of pvnames
		'''
		params = {}
		if len(glob) > 0:
			params["q"] = glob
		return self.mgmtget('getAllPVs', params=params)

	def getConfig(self, glob=""):
		'''
		Retrieve the pv configurations.  Excludes those that have never connected.
		@param string glob a glob-style wildcard to filter the list.  If empty
		or not provided, all pvs are returned
		@return list of dicts, each with a 'pvName' key and several others.
		'''
		params = {}
		if len(glob) > 0:
			params["q"] = glob
		return self.mgmtget('exportConfig', params=params)

	def getEveryPV(self):
		'''
		Retrieve all pvs known to the system, even those that have never connected.
		@return list of dicts, each with keys 'pvname' and 'connected'.
		'''
		conn = self.getAllPVs()
		nconn = self.getNeverConnectedPVs()
		every = {}
		for pv in conn:
			every[pv] = True
		for pv in nconn:
			every[pv['pvName']] = False
		return every

	def getData(self, pvname, start, end):
		params = {
				'pv': pvname,
				'from': start,
				'to': end}
		return self.retrievalget('getData.txt', params)

if __name__=='__main__':
	client = ArchClient();

	for pv in client.getAllPVs():
		print pv
	sys.exit(0)

	'''
	disconn = client.getCurrentlyDisconnectedPVs()
	print "Found %d pvs that have are currently disconnected" % len(disconn)
	print "name\t\tlost at\thost\tlast known\tstate\t"
	for n in sorted(disconn, key=lambda pv: pv['pvName']):
		print n['pvName']
		#print "%s\t%s\t%s\t%s\t%s" % (
		#		n['pvName'],
		#		n['connectionLostAt'],
		#		n['hostName'],
		#		n['lastKnownEvent'],
		#		n['internalState'])
	'''

	'''
	neverconn = client.getNeverConnectedPVs()
	print "Found %d pvs that have never connected" % len(neverconn)
	for n in neverconn:
		print repr(n) #n['pvName']
	'''

	'''
	pvs = client.getAllPVs()
	print "Found %d pvs" % len(pvs)
	for pv in pvs:
		print pv
	'''

	exported = client.getConfig()
	print "Found %d configs:" % len(exported)
	#for e in exported:
	#	print e['pvName']

	'''
	neverconn = client.getNeverConnectedPVs()
	print "%d pv(s) have never connected:" % len(neverconn)
	for n in neverconn:
		print n['pvName'], "requested at", n['requestTime']
		for e in exported:
			if e['pvName'] == n['pvName']:
				print "Config: created at", e['creationTime']
	'''

	pvs = {}
	for e in exported:
		if 'pvName' in e:
			pv = PVTypeInfo(e['pvName'])
			pv.parseObj(e)
			pvs[e['pvName']] = pv
		elif 'chunkKey' in e:
			print 'No pvName, but chunkKey found'
			pv = PVTypeInfo(e['chunkKey'])
			pv.parseObj(e)
			pvs[e['chunkKey']] = pv
		else:
			print 'No pvName or chunkKey in e:', repr(e)
	
	types = []
	for pvname, pv in pvs.items():
		if pv.DBRType == 'DBR_SCALAR_FLOAT':
			if pv.samplingMethod == 'MONITOR':
				print 'Changing from MONITOR to SCAN:   %s' % pvname
				resp = client.changeArchivalParams(pvname, pv.samplingPeriod, 'SCAN')
				print 'Response: ' + str(resp)
		elif pv.DBRType == 'DBR_SCALAR_STRING':
			print 'STRING: ' + pvname
			print repr(pv)
