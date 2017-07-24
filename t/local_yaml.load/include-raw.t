.. vim: ft=rst

setup::

  >>> import jenkins_jobs.local_yaml as cut
  >>> from setup import strio
  >>> import os

  >>> from setup import isolate; isolate()


complains if the named files do not exist::

  >>> input = strio(u"""
  ... snafu: !include-raw:
  ...   - foo
  ...   - bar
  ... """)

  >>> try:
  ...   rv = cut.load(input)
  ... except IOError as e:
  ...   print(e)
  [Errno 2] No such file or directory: 'foo'


reads named files as-is::

  >>> input = strio(u"""
  ... snafu: !include-raw:
  ...   - foo
  ...   - bar
  ... """)

  >>> with open("foo", "w") as fd:
  ...   _ = fd.write("stuff in foo: {omg}")
  >>> with open("bar", "w") as fd:
  ...   _ = fd.write("stuff in bar: {wtf}")

  >>> rv = cut.load(input)
  >>> print(rv['snafu'])
  stuff in foo: {omg}
  stuff in bar: {wtf}


expandos in filenames cause postponed resolution::

  >>> input = strio(u"""
  ... snafu: !include-raw:
  ...   - foo{bar}baz
  ...   - rof{l}mao
  ... """)

  >>> rv = cut.load(input)
  >>> print(rv['snafu'])
  <jenkins_jobs.local_yaml.LazyLoaderCollection object ...>


literal filenames are still eager::

  >>> input = strio(u"""
  ... snafu: !include-raw:
  ...   - foo{bar}baz
  ...   - qux
  ... """)

  >>> try:
  ...   rv = cut.load(input)
  ... except IOError as e:
  ...   print(e)
  [Errno 2] No such file or directory: 'qux'

  >>> with open("qux", "w") as fd:
  ...   _ = fd.write("stuff in qux: {omg}")

  >>> input = strio(u"""
  ... snafu: !include-raw:
  ...   - foo{bar}baz
  ...   - qux
  ... """)

  >>> rv = cut.load(input)
  >>> print(rv['snafu'])
  <jenkins_jobs.local_yaml.LazyLoaderCollection object ...>

  >>> print(rv['snafu']._data[1])
  stuff in qux: {omg}
