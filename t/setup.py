# vim: sw=2 sts=2 et

try:
  from io import StringIO as strio
except ImportError:
  from StringIO import StringIO as strio

def isolate():
  chdir(mkdtemp('', 'tmp', getcwd()))

class JJBConfig(object):
  def __init__(
    cfg
  , allow_duplicates = False
  , allow_empty_variables = False
  , include_path = ''
  , keep_descriptions = True
  ):
    cfg.yamlparser = dict(
      allow_duplicates = allow_duplicates,
      allow_empty_variables = allow_empty_variables,
      include_path = include_path,
      keep_descriptions = keep_descriptions,
    )

from os import chdir, getcwd
from tempfile import mkdtemp
