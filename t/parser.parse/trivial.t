.. vim: ft=rst

setup::

  >>> from setup import JJBConfig
  >>> import jenkins_jobs.parser as cut

  >>> from setup import isolate; isolate()


top-level element must be a list::

  >>> input = u"""
  ... rofl:
  ...   - lmao
  ...   - roflmao:
  ...       foo: bar
  ...       baz: qux
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> try:
  ...   rv = cut.YamlParser(JJBConfig()).parse("input")
  ... except cut.JenkinsJobsException as e:
  ...   print(repr(e))
  JenkinsJobsException("The topmost collection in file 'input' must be a list...",)


members of top-level list must be maps::

  >>> input = u"""
  ... - rofl:
  ...     - lmao
  ...     - roflmao:
  ...         foo: bar
  ...         baz: qux
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> try:
  ...   rv = cut.YamlParser(JJBConfig()).parse("input")
  ... except AttributeError as e:
  ...   print(repr(e))
  AttributeError("'list' object has no attribute 'get'",)


said maps must have 'name' keys::

  >>> input = u"""
  ... - rofl:
  ...     omg: wtf
  ...     roflmao:
  ...       foo: bar
  ...       baz: qux
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> try:
  ...   rv = cut.YamlParser(JJBConfig()).parse("input")
  ... except KeyError as e:
  ...   print(repr(e))
  KeyError('name',)


they end up in YamlParser#data as follows::

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
