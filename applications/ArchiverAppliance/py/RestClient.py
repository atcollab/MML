'''
Created on Oct 29, 2013

@author: rfgunion
'''

import httplib
import json
import urllib
import logging

class RestClient(object):
	'''
	classdocs
	'''
	server = 'arch02.als.lbl.gov'
	mgmtport = 17665
	mgmturl = '/mgmt/bpl/'
	retrievalport = 17668
	retrievalurl = '/retrieval/data/'

	def mgmtget(self, method, params={}):
		conn = httplib.HTTPConnection(self.server, self.mgmtport)
		url = self.mgmturl+method
		if len(params) > 0: url += "?"+urllib.urlencode(params)
		conn.request('GET', url)
		resp = conn.getresponse()
		resptext = resp.read()
		try:
			respobj = json.loads(resptext)
			return respobj
		except ValueError as err:
			logging.warn('ValueError decoding json response "%s" - treating as a simple string' % str(err))
			return resptext
	
	def mgmtpost(self, method, data):
		conn = httplib.HTTPConnection(self.server, self.mgmtport)
		params = urllib.urlencode(data)
		headers = {"Content-type": "application/x-www-form-urlencoded",
				   "Accept": "text/plain"}
		conn.request("POST", self.mgmturl+method, params, headers)
		resp = conn.getresponse()
		respdata = resp.read()
		conn.close()
		return respdata
	
	def retrievalget(self, method, params={}):
		conn = httplib.HTTPConnection(self.server, self.retrievalport)
		url = self.retrievalurl+method
		if len(params) > 0:
			url += "?"+urllib.urlencode(params) + '&donotchunk&usereduced=false'
		else:
			url += '?donotchunk&usereduced=0'
		logging.debug('url: '+url)
		conn.request('GET', url)
		resp = conn.getresponse()
		resptext = resp.read()
		#try:
		#	respobj = json.loads(resptext)
		#	return respobj
		#except ValueError as err:
		#	logging.warn('ValueError decoding json response "%s" - treating as a simple string' % str(err))
		return resptext

