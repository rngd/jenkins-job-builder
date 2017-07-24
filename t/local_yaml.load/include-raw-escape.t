.. vim: ft=rst

setup::

  >>> from setup import strio
  >>> import jenkins_jobs.local_yaml as cut
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


reads named files doubling curly braces::

  >>> input = strio(u"""
  ... snafu: !include-raw-escape:
  ...   - foo
  ...   - bar
  ... """)

  >>> with open("foo", "w") as fd:
  ...   _ = fd.write("stuff in foo: {omg}")
  >>> with open("bar", "w") as fd:
  ...   _ = fd.write("stuff in bar: {wtf}")

  >>> rv = cut.load(input)
  >>> print(rv['snafu'])
  stuff in foo: {{omg}}
  stuff in bar: {{wtf}}


expandos in filenames provoke a bug where JJB sends
a ``jenkins_jobs.local_yaml.LazyLoaderCollection`` down
to ``re.sub``::

  >>> input = strio(u"""
  ... snafu: !include-raw-escape:
  ...   - foo{bar}
  ...   - bar
  ... """)

  >>> try:
  ...   rv = cut.load(input)
  ... except TypeError as e:
  ...   print(e)
  expected string or ...
