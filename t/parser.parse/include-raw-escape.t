.. vim: ft=rst

setup::

  >>> from setup import JJBConfig
  >>> import jenkins_jobs.parser as cut

  >>> from setup import isolate; isolate()


complains if the named files do not exist::

  >>> input = u"""
  ... - rofl:
  ...     name: omgwtf
  ...     roflmao: !include-raw-escape:
  ...       - foo
  ...       - bar
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> p = cut.YamlParser(JJBConfig())
  >>> try:
  ...   p.parse("input")
  ... except IOError as e:
  ...   print(e)
  [Errno 2] No such file or directory: 'foo'


reads named files doubling curly braces in their contents::

  >>> input = u"""
  ... - rofl:
  ...     name: omgwtf
  ...     roflmao: !include-raw-escape:
  ...       - foo
  ...       - bar
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> with open("foo", "w") as fd:
  ...   _ = fd.write("stuff in foo: {omg}")
  >>> with open("bar", "w") as fd:
  ...   _ = fd.write("stuff in bar: {wtf}")

  >>> p = cut.YamlParser(JJBConfig())
  >>> p.parse("input")
  >>> print(p.data['rofl']['omgwtf']['roflmao'])
  stuff in foo: {{omg}}
  stuff in bar: {{wtf}}


expandos in filenames provoke a bug where JJB sends
a ``jenkins_jobs.local_yaml.LazyLoaderCollection`` down
to ``re.sub``::

  >>> input = u"""
  ... - rofl:
  ...     name: omgwtf
  ...     roflmao: !include-raw-escape:
  ...       - foo{bar}
  ...       - bar
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> with open("foo", "w") as fd:
  ...   _ = fd.write("stuff in foo: {omg}")
  >>> with open("bar", "w") as fd:
  ...   _ = fd.write("stuff in bar: {wtf}")

  >>> p = cut.YamlParser(JJBConfig())
  >>> try:
  ...   p.parse("input")
  ... except TypeError as e:
  ...   print(e)
  expected string or ...
