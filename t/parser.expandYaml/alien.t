.. vim: ft=rst

setup::

  >>> from setup import JJBConfig
  >>> import jenkins_jobs.parser as cut

  >>> from setup import isolate; isolate()

  >>> class FakeRegistry(object):
  ...   def __init__(o):
  ...     o.modules = ()


omits alien nodes::

  >>> input = u"""
  ... - rofl:
  ...     name: omgwtf
  ...     roflmao:
  ...       foo: bar
  ...       baz: qux
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> p = cut.YamlParser(JJBConfig())
  >>> p.parse("input")
  >>> p.data
  {'rofl': {'omgwtf': ...}}

  >>> p.expandYaml(FakeRegistry())
  []
