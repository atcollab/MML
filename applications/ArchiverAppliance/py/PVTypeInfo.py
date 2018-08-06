"""
Created on Oct 29, 2013

@author: rfgunion
"""
from datetime import datetime


class PVTypeInfo(object):
	"""
	Holds configuration info for a PV in the archiver appliance.
	"""
	pvname = ''
	creationTime = None
	computedEventRate = 0
	computedStorageRate = 0
	computedBytesPerEvent = 0
	paused = False
	elementCount = 1
	scalar = True
	lowerCtrlLimit = 0.0
	lowerDisplayLimit = 0.0
	lowerWarningLimit = 'NaN'
	lowerAlarmLimit = 'NaN'
	upperCtrlLimit = 0.0
	upperDisplayLimit = 0.0
	upperWarningLimit = 'NaN'
	upperAlarmLimit = 'NaN'
	archiveFields = [] # 'LOLO', 'HIGH', 'LOW', 'LOPR', 'HOPR', 'HIHI'
	applianceIdentity = ""
	DBRType = "" # e.g. DBR_SCALAR_DOUBLE
	hasReducedDataSet = False
	samplingPeriod = 180.0
	units = ''
	precision = 0.0
	modificationTime = None # e.g. "2013-08-23T00:24:16.483Z"
	samplingMethod = '' # e.g. "SCAN"
	dataStores = []
	userSpecifiedEventRate = 0.0
	extraFields = {}
	SCAN = 0.0
	chunkKey = ''

	def __init__(self, name):
		"""
	    Constructor
	    """
		self.pvname = name

	def __repr__(self):
		return 'PVTypeInfo('+self.pvname+'): ' \
			+ 'creationTime='+str(self.creationTime)+', ' \
			+ 'computedEventRate='+str(self.computedEventRate)+', ' \
			+ 'computedStorageRate='+str(self.computedStorageRate)+', ' \
			+ 'computedBytesPerEvent='+str(self.computedBytesPerEvent)+', ' \
			+ 'paused='+str(self.paused)+', ' \
			+ 'elementCount='+str(self.elementCount)+', ' \
			+ 'scalar='+str(self.scalar)+', ' \
			+ 'lowerCtrlLimit='+str(self.lowerCtrlLimit)+', ' \
			+ 'lowerDisplayLimit='+str(self.lowerDisplayLimit)+', ' \
			+ 'lowerWarningLimit='+str(self.lowerWarningLimit)+', ' \
			+ 'lowerAlarmLimit='+str(self.lowerAlarmLimit)+', ' \
			+ 'upperCtrlLimit='+str(self.upperCtrlLimit)+', ' \
			+ 'upperDisplayLimit='+str(self.upperDisplayLimit)+', ' \
			+ 'upperWarningLimit='+str(self.upperWarningLimit)+', ' \
			+ 'upperAlarmLimit='+str(self.upperAlarmLimit)+', ' \
			+ 'archiveFields='+str(self.archiveFields)+', ' \
			+ 'applianceIdentity='+str(self.applianceIdentity)+', ' \
			+ 'DBRType='+str(self.DBRType)+', ' \
			+ 'hasReducedDataSet='+str(self.hasReducedDataSet)+', ' \
			+ 'samplingPeriod='+str(self.samplingPeriod)+', ' \
			+ 'units='+str(self.units)+', ' \
			+ 'precision='+str(self.precision)+', ' \
			+ 'modificationTime='+str(self.modificationTime)+', ' \
			+ 'samplingMethod='+str(self.samplingMethod)+', ' \
			+ 'dataStores='+str(self.dataStores)+', ' \
			+ 'userSpecifiedEventRate='+str(self.userSpecifiedEventRate)+', ' \
			+ 'extraFields='+str(self.extraFields)+', ' \
			+ 'SCAN='+str(self.SCAN)+', ' \
			+ 'chunkKey='+str(self.chunkKey)

	def __str__(self):
		return self.pvname

	def parseObj(self, obj):
		self.creationTime = self.parsedatetime('creationTime', obj)
		self.computedEventRate = self.parsefloat('computedEventRate', obj)
		self.computedStorageRate = self.parsefloat('computedStorageRate', obj)
		self.computedBytesPerEvent = self.parsefloat('computedBytesPerEvent', obj)
		self.paused = self.parsebool('paused', obj)
		self.elementCount = self.parseint('elementCount', obj)
		self.scalar = self.parsebool('scalar', obj)
		self.lowerCtrlLimit = self.parsefloat('lowerCtrlLimit', obj)
		self.lowerDisplayLimit = self.parsefloat('lowerDisplayLimit', obj)
		self.lowerWarningLimit = self.parsefloat('lowerWarningLimit', obj)
		self.lowerAlarmLimit = self.parsefloat('lowerAlarmLimit', obj)
		self.upperCtrlLimit = self.parsefloat('upperCtrlLimit', obj)
		self.upperDisplayLimit = self.parsefloat('upperDisplayLimit', obj)
		self.upperWarningLimit = self.parsefloat('upperWarningLimit', obj)
		self.upperAlarmLimit = self.parsefloat('upperAlarmLimit', obj)
		self.applianceIdentity = self.parsestring('applianceIdentity', obj)
		self.DBRType = self.parsestring('DBRType', obj)
		self.hasReducedDataSet = self.parsebool('hasReducedDataSet', obj)
		self.samplingMethod = self.parsestring('samplingMethod', obj)
		self.samplingPeriod = self.parsefloat('samplingPeriod', obj)
		self.units = self.parsestring('units', obj, '')
		self.precision = self.parsefloat('precision', obj)
		self.modificationTime = self.parsedatetime('modificationTime', obj)
		self.dataStores = self.parsestring('dataStores', obj)
		self.userSpecifiedEventRate = self.parsefloat('userSpecifiedEventRate', obj)
		self.extraFields = self.parsestring('extraFields', obj)
		self.SCAN = self.parsestring('SCAN', obj, '')
		self.chunkKey = self.parsestring('chunkKey', obj, '')

	def parsestring(self, key, obj, default=''):
		if key in obj:
			return obj[key]
		return default

	def parsefloat(self, key, obj, default=0.0):
		"""
		@rtype : float
		"""
		if key in obj:
			return float(obj[key])
		return default

	def parsedatetime(self, key, obj, default=datetime(1, 1, 1)):
		if key in obj:
			return datetime.strptime(obj[key], "%Y-%m-%dT%H:%M:%S.%fZ")
		return default

	def parsebool(self, key, obj, default=False):
		if key in obj:
			return bool(obj[key])
		return default

	def parseint(self, key, obj, default=0):
		if key in obj:
			return int(obj[key])
		return default