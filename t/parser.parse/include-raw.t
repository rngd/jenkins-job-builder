.. vim: ft=rst

setup::

  >>> from setup import JJBConfig
  >>> import jenkins_jobs.parser as cut

  >>> from setup import isolate; isolate()


complains if the named files do not exist::

  >>> input = u"""
  ... - rofl:
  ...     name: omgwtf
  ...     roflmao: !include-raw:
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


reads named files as-is::

  >>> input = u"""
  ... - snafu:
  ...     name: roflmao
  ...     fubar: !include-raw:
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
  >>> print(p.data['snafu']['roflmao']['fubar'])
  stuff in foo: {omg}
  stuff in bar: {wtf}


expandos in filenames cause postponed resolution::

  >>> input = u"""
  ... - snafu:
  ...     name: roflmao
  ...     fubar: !include-raw:
  ...       - '{foo}'
  ...       - '{bar}'
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> p = cut.YamlParser(JJBConfig())
  >>> p.parse("input")
  >>> print(p.data['snafu']['roflmao']['fubar'])
  <jenkins_jobs.local_yaml.LazyLoaderCollection object at ...>


literal filenames are still eager::

  >>> input = u"""
  ... - snafu:
  ...     name: roflmao
  ...     fubar: !include-raw:
  ...       - '{foo}'
  ...       - qux
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> p = cut.YamlParser(JJBConfig())
  >>> try:
  ...   p.parse("input")
  ... except IOError as e:
  ...   print(e)
  [Errno 2] No such file or directory: 'qux'

  >>> with open("qux", "w") as fd:
  ...   _ = fd.write("stuff in qux: {omg}")

  >>> input = u"""
  ... - snafu:
  ...     name: roflmao
  ...     fubar: !include-raw:
  ...       - '{foo}'
  ...       - qux
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> p = cut.YamlParser(JJBConfig())
  >>> p.parse("input")
  >>> print(p.data['snafu']['roflmao']['fubar'])
  <jenkins_jobs.local_yaml.LazyLoaderCollection object at ...>
