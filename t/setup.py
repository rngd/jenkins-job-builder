# vim: sw=2 sts=2 et

try:
  from io import StringIO as strio
except ImportError:
  from StringIO import StringIO as strio

def isolate():
  chdir(mkdtemp('', 'tmp', getcwd()))

class JJBConfig(object):
  def __init__(cfg):
    cfg.yamlparser = dict(
      allow_empty_variables = False,
      include_path = '',
      keep_descriptions = True,
    )

from os import chdir, getcwd
from tempfile import mkdtemp
