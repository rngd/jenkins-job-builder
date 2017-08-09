.. vim: ft=rst

setup::

  >>> from setup import JJBConfig
  >>> import jenkins_jobs.parser as cut

  >>> from setup import isolate; isolate()

  >>> class FakeRegistry(object):
  ...   def __init__(o):
  ...     o.modules = ()


fails if a project references nonexistent job(-template)::

  >>> input = u"""
  ... - project:
  ...     name: snafubar
  ...     jobs:
  ...       - roflmao
  ...       - x-{lol}
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> p = cut.YamlParser(JJBConfig())
  >>> p.parse("input")
  >>> try:
  ...   rv = p.expandYaml(FakeRegistry())
  ... except cut.JenkinsJobsException as e:
  ...   print(e)
  Failed to find suitable template named 'roflmao'

and::

  >>> input = u"""
  ... - project:
  ...     name: snafubar
  ...     jobs:
  ...       - roflmao
  ...       - x-{lol}
  ... - job:
  ...     name: roflmao
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> p = cut.YamlParser(JJBConfig())
  >>> p.parse("input")
  >>> try:
  ...   rv = p.expandYaml(FakeRegistry())
  ... except cut.JenkinsJobsException as e:
  ...   print(e)
  Failed to find suitable template named 'x-{lol}'

and::

  >>> input = u"""
  ... - project:
  ...     name: snafubar
  ...     jobs:
  ...       - roflmao
  ...       - x-{lol}
  ... - job:
  ...     name: roflmao
  ... - job:
  ...     name: x-{lol}
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> p = cut.YamlParser(JJBConfig())
  >>> p.parse("input")
  >>> rv = p.expandYaml(FakeRegistry())

  >>> sorted(rv, key = lambda x: x['name'])
  [{'name': 'roflmao'}, {'name': 'x-{lol}'}]


doesn't resolve/inline other named references like
builders or wrappers::

  >>> input = u"""
  ... - project:
  ...     name: snafubar
  ...     lol: wtf
  ...     jobs:
  ...       - roflmao
  ...       - x-{lol}
  ... - job:
  ...     name: roflmao
  ...     builders:
  ...       - wtf
  ...       - omg
  ... - job:
  ...     name: x-{lol}
  ...     builders:
  ...       - x-{lol}-wtf
  ...       - x-{lol}-omg
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> p = cut.YamlParser(JJBConfig())
  >>> p.parse("input")
  >>> rv = p.expandYaml(FakeRegistry())

  >>> def names(jobs):
  ...   for j in jobs: yield j['name']

  >>> def find(jobs, name):
  ...   for j in jobs:
  ...     if 'name' in j and j['name'] == name:
  ...       return j

  >>> sorted(names(rv))
  ['roflmao', 'x-{lol}']

  >>> find(rv, 'roflmao')['builders']
  ['wtf', 'omg']

  >>> find(rv, 'x-{lol}')['builders']
  ['x-{lol}-wtf', 'x-{lol}-omg']
