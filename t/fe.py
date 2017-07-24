# vim: sw=2 sts=2 et

from os.path import abspath, dirname, join
from glob import glob
import doctest

testdir = abspath(dirname(__file__))

doctestflags = (
  doctest.DONT_ACCEPT_TRUE_FOR_1
| doctest.ELLIPSIS
| doctest.REPORT_ONLY_FIRST_FAILURE
)

def load_tests(loader, tests, pattern):
  '''`load_tests` Protocol implementation for `unittest` (new in 2.7)

  `doctest` seems to defer aggregate test runs to `unittest`
  '''
  tests.addTests(doctest.DocFileSuite(
    *find_tests(testdir),
    module_relative = False,
    optionflags = doctestflags
  ))
  return tests

def find_tests(testdir):
  return sorted(
    glob(join(testdir, '*.t'))
  + glob(join(testdir, '*/*.t'))
  + glob(join(testdir, '*/*/*.t'))
  )

if __name__ == '__main__':
  from os import chdir, getcwd
  from sys import path
  from tempfile import mkdtemp
  import unittest

  path.insert(0, getcwd())
  path.insert(0, testdir)
  chdir(mkdtemp())
  unittest.main()
