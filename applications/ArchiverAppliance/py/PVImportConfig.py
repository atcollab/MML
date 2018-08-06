'''
PVImportConfig.py: Implementation of the PVImportConfig class
@author: rfgunion
@date: 10/31/13 4:42 PM
'''
import re
import os
import logging

class ImportItem(object):
	'''
	Represents a single line in the configuration file. Base class for
	PVImportItem, IOCImportItem, and PathImportItem.  Populates the
	attributes.
	'''
	valid = True        # whether the line has valid syntax
	exclude = False     # whether to explicitly include (False) or exclude (True) items
	excludechar = '+'   # character code corresponding to exclude
	line = None         # the original line, excluding prefixes and trailing comments
	prefix = None       # the original prefix
	comment = None      # the trailing comment, if any
	expression = None   # the expression w/out prefix and comment

	def __init__(self, line):
		self.line = line.strip()
		# Remove prefix and trailing comment, if any
		match = re.match(r'([-+]?)((path|ioc|pv|db):)([^\s#]+)\s*#?(.*)', line)
		if not match:
			logging.error('ImportItem: cannot parse line %s', line)
			self.valid = False
			return
		if match.group(1) != '+':
			self.exclude = True
			self.excludechar = '-'
		self.prefix = match.group(2)
		self.expression = match.group(4)
		self.comment = match.group(5)
		# Force full-string match
		if not self.expression.startswith('^'):
			self.expression = '^'+self.expression
		if not self.expression.endswith('$'):
			self.expression += '$'

	def getLine(self):
		result = self.excludechar+self.prefix
		expr = self.expression
		if expr.startswith('^'): expr = expr[1:]
		if expr.endswith('$'): expr = expr[:-1]
		result += expr
		if len(self.comment) > 0:
			result += '\t'+self.comment
		return result+'\n'

	def addSubItems(self, items):
		pass

class PVImportItem(ImportItem):
	'''
	Represents a single line in the configuration file beginning with "pv:"
	'''

	def __init__(self, line):
		ImportItem.__init__(self, line)

	def parse(self, pathitem, iocitem):
		return True

class DBImportItem(ImportItem):
	'''
	Represents a .db line.  Used in PVignore, not pvconfig, so only relevant
	to convertPVignore.py.
	'''
	pvitems = []

	def __init__(self, line):
		ImportItem.__init__(self, line)
		self.pvitems = []

	def addSubItem(self, item):
		found = False
		for pvitem in self.pvitems:
			if pvitem.expression == item.expression:
				found = True
				break
		if not found:
			self.pvitems.append(item)

class IOCImportItem(ImportItem):
	'''
	Represents a single line in the configuration file beginning with "ioc:"
	'''
	iocnames = []
	pvitems = []
	dbitems = []

	def __init__(self, line):
		ImportItem.__init__(self, line)
		self.iocnames = []
		self.pvitems = []
		self.dbitems = []

	def parse(self, pathitem):
		# Defer searching if path is not provided
		if pathitem is None:
			return True
		found = False
		for path in pathitem.fullpaths:
			for fname in os.listdir(path):
				fullpath = os.path.join(path, fname)
				if os.path.isdir(fullpath):
					# Skip subdirectories - looking for iocs
					continue
				if re.match(self.expression, fname):
					found = True
					if pathitem.findIOC(fname) is not None:
						self.iocnames.append(fname)
		# return True even if no matches found
		return True

	def addSubItems(self, items):
		for item in items:
			if isinstance(item, PVImportItem):
				self.addSubItem(item)

	def addSubItem(self, item):
		if isinstance(item, DBImportItem):
			self.dbitems.append(item)
		else:
			found = False
			for pvitem in self.pvitems:
				if pvitem.expression == item.expression:
					found = True
					break
			if not found:
				self.pvitems.append(item)

class PathImportItem(ImportItem):
	'''
	Represents a single line in the configuration file beginning with "path:"
	'''
	fullpaths = None
	iocitems = []

	def __init__(self, line):
		ImportItem.__init__(self, line)
		self.fullpaths = None
		self.iocitems = []

	def parse(self):
		'''
		Parses self.expression. Populates self.fullpaths
		@return: True if the expression is valid, False otherwise.
		'''
		expr = self.expression[1:-1]
		if os.path.exists(os.path.abspath(expr)):
			logging.info('Explicit path: %s' % expr)
			self.fullpaths = [os.path.abspath(expr)]
			return True
		index = expr.rfind(os.sep)
		parentdir = '.'
		if index != -1:
			parentdir = expr[0:index]
		parentdir = os.path.abspath(parentdir)
		if not os.path.exists(parentdir):
			logging.error('Cannot find parent path %s' % parentdir)
			self.valid = False
			return
		regex = expr[index+1:]
		found = False
		for subdir in os.listdir(parentdir):
			fullpath = os.path.join(parentdir, subdir)
			if not os.path.isdir(fullpath):
				continue
			if re.match(regex, subdir):
				logging.info('Matched path: %s' % fullpath)
				self.fullpaths.append(fullpath)
				found = True
		self.valid = found
		return self.valid

	def addSubItem(self, item):
		found = False
		for iocitem in self.iocitems:
			if iocitem.expression == item.expression:
				found = True
				break
		if not found:
			self.iocitems.append(item)

	def addSubItems(self, items):
		for item in items:
			if isinstance(item, IOCImportItem):
				self.addSubItem(item)
			elif isinstance(item, PVImportItem):
				for iocitem in self.iocitems:
					iocitem.addSubItem(item)

	def findIOC(self, iocname):
		'''
		Searches for an ioc name in the existing list.
		@return the IOCImportItem object containing the ioc, or None if not found
		'''
		for iocitem in self.iocitems:
			for name in iocitem.iocnames:
				if iocname == name:
					return iocitem
		return None

class PVImportConfig(object):
	'''
	Represents the configuration for import of pv names into the
	archiver appliance.  Similar to the old PVIgnore at the ALS,
	but with more flexible syntax for a broader range of options.
	Generalized syntax:
	 - Anything following " #" (that is, whitespace preceding #) is a comment,
	   whether at the beginning of a line or following a legal declaration
	 - A line like "path:expr" includes the directory(ies) specified
	   by expr, a regular expression
	 - Leading whitespace is ignored, so can be used to make the file more readable.
	 - First non-whitespace character is - or + to exclude or include the expression, resp.
	 - Label follows: either "ioc:" or "pv:"
	 - Each label constrains the following lines to the given instance, until
	   a blank line or a wider classification is encountered.
	 - Any ioc not explicitly listed is included by default.  And any pv
	   within each included db file is included by default.  In other words,
	   everything is included by default unless explicitly excluded.
	Example:
	# Here's an example file.  This line is a comment.
	-ioc:.*junk.* # iocs whose name contains "junk" will be ignored, regardless of path
	-pv:.*:hb$ # pvs ending in ":hb" will be ignored, regardless of which path/ioc they are in
	path:/vxboot/PVnames # The directory name
	-ioc:junkioc # This ioc will be ignored
	+ioc:goodioc # This ioc will be included, subject to the following line(s)
		-pv:^junk.* # pvs whose names start with junk will be ignored
	'''

	items = []
	pathitem = None
	iocitem = None

	def __init__(self, fname):
		'''
		Constructor: ensure attributes are empty; python seems to recycle objects
		even when it shouldn't.
		@param fname:  string the configuration file name
		'''
		self.fname = fname
		self.items = []
		self.pathitem = None
		self.iocitem = None

	def __del__(self):
		self.items = []
		del self.pathitem
		del self.iocitem

	def read(self, fname=''):
		'''
		Read a configuration file.  If this is called multiple times, the
		configuration will be added to each time, allowing for multiple files.
		@param fname: the name of the file to read, or blank to read self.fname
		@return: True on success, False on failure
		'''
		if fname == '':
			fname = self.fname
		self.pathitem = None
		self.iocitem = None
		with open(fname) as f:
			for line in f:
				if not self.parseLine(line):
					self.pathitem = None
					self.iocitem = None
					return False
		self.pathitem = None
		self.iocitem = None

		for item in self.items:
			item.addSubItems(self.items)

		return True

	def parseLine(self, line):
		logging.debug('Parsing line: %s' % line)
		line = line.strip()
		# Ignore blank lines and comments (avoid overhead of regexp search)
		if line == '' or line[0] == '#':
			return True

		index = 0
		if line[0] == '-' or line[0] == '+':
			index = 1
		if line[index:].startswith('path:'):
			logging.info('Parsing path: %s' % line)
			item = PathImportItem(line)
			if item.parse():
				self.pathitem = item
				self.items.append(item)
			else:
				self.pathitem = None
			self.iocitem = None
		elif line[index:].startswith('ioc:'):
			logging.info('Parsing ioc: %s' % line)
			item = IOCImportItem(line)
			if item.parse(self.pathitem):
				self.iocitem = item
				if self.pathitem is not None:
					self.pathitem.addSubItem(item)
					item.parent = self.pathitem
				else:
					self.items.append(item)
			else:
				self.iocitem = None
		elif line[index:].startswith('pv:'):
			logging.info('Parsing pv: %s' % line)
			item = PVImportItem(line)
			if item.parse(self.pathitem, self.iocitem):
				if self.iocitem is not None:
					self.iocitem.addSubItem(item)
					item.parent = self.iocitem
				elif self.pathitem is not None:
					self.pathitem.pvitems.append(item)
					item.parent = self.pathitem
				else:
					self.items.append(item)
		else:
			logging.error('Cannot parse line: %s' % line)
			return False
		return True

	def findPVNames(self):
		'''
		Searches self.items to populate a list of pv names.
		@return:
		'''
