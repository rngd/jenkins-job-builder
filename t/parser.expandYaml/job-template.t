.. vim: ft=rst

setup::

  >>> from setup import JJBConfig
  >>> import jenkins_jobs.parser as cut

  >>> from setup import isolate; isolate()

  >>> class FakeRegistry(object):
  ...   def __init__(o):
  ...     o.modules = ()


omits unused job templates::

  >>> input = u"""
  ... - job-template:
  ...     name: roflmao
  ...     omgwtf: snafubar
  ...     foo:
  ...       - bar
  ...       - baz
  ...       - 69
  ...       - 42
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> p = cut.YamlParser(JJBConfig())
  >>> p.parse("input")
  >>> p.data
  {'job-template': {'roflmao': ...}}

  >>> p.expandYaml(FakeRegistry())
  []


whether they have expandos or not::

  >>> input = u"""
  ... - job-template:
  ...     name: x-{roflmao}
  ...     omgwtf: snafubar
  ...     foo:
  ...       - bar
  ...       - baz
  ...       - 69
  ...       - 42
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> p = cut.YamlParser(JJBConfig())
  >>> p.parse("input")
  >>> p.data
  {'job-template': {'x-{roflmao}': ...}}

  >>> p.expandYaml(FakeRegistry())
  []
