.. vim: ft=rst

setup::

  >>> from setup import JJBConfig
  >>> import jenkins_jobs.parser as cut

  >>> from setup import isolate; isolate()

  >>> class FakeRegistry(object):
  ...   def __init__(o):
  ...     o.modules = ()


processes job nodes::

  >>> input = u"""
  ... - job:
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
  {'job': {'roflmao': ...}}

  >>> rv = p.expandYaml(FakeRegistry())

  >>> sorted(rv[0].keys())
  ['foo', 'name', 'omgwtf']
  >>> rv[0]['foo']
  ['bar', 'baz', 69, 42]


expandos in job nodes pass through as-is::

  >>> input = u"""
  ... - job:
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
  {'job': {'x-{roflmao}': ...}}

  >>> rv = p.expandYaml(FakeRegistry())

  >>> sorted(rv[0].keys())
  ['foo', 'name', 'omgwtf']
  >>> rv[0]['foo']
  ['bar', 'baz', 69, 42]
