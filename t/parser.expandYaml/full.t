.. vim: ft=rst

setup::

  >>> from setup import JJBConfig
  >>> import jenkins_jobs.parser as cut

  >>> from setup import isolate; isolate()

  >>> class FakeRegistry(object):
  ...   def __init__(o):
  ...     o.modules = ()


uses jobs and job templates plugged into a project::

  >>> input = u"""
  ... - job:
  ...     name: roflmao
  ...     goal: riches
  ...     fubars:
  ...       - dafubar
  ...     builders:
  ...       - omgwtf:
  ...           rofl: lmao
  ...       - x-builder
  ... - job-template:
  ...     name: x-{lol}
  ...     builders:
  ...       - x-builder:
  ...           goal: noise
  ... - project:
  ...     name: snafubar
  ...     jobs:
  ...       - roflmao
  ...       - x-{lol}
  ...     lol:
  ...       - 69
  ...       - 42
  ... - job-template:
  ...     name: job-{c}
  ...     builders:
  ...       - x-builder
  ... - project:
  ...     name: ohno
  ...     jobs:
  ...       - job-{c}
  ...     c:
  ...       - a
  ...       - b
  ...     goal:
  ...       - omg
  ...       - wtf
  ... - builder:
  ...     name: a-builder
  ...     builders:
  ...       - shell: 'make cake'
  ... - builder:
  ...     name: b-builder
  ...     builders:
  ...       - shell: 'make love'
  ... - builder:
  ...     name: x-builder
  ...     builders:
  ...       - shell: 'make {goal}'
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> p = cut.YamlParser(JJBConfig())
  >>> p.parse("input")
  >>> rv = p.expandYaml(FakeRegistry())

  >>> rv is p.jobs
  True

  >>> rv[0]['name']
  'roflmao'

  >>> list(rv[0]['builders'][0].keys())
  ['omgwtf']

  >>> list(rv[0]['builders'][0]['omgwtf'].keys())
  ['rofl']

  >>> rv[0]['builders'][0]['omgwtf']['rofl']
  'lmao'

  >>> rv[0]['builders'][1]
  'x-builder'

  >>> rv[0]['fubars']
  ['dafubar']

this is unstable in python3, a cointoss whether i get
``('x-69', [OrderedDict([('x-builder', ...)])])`` instead::

  >>> rv[1]['name'], rv[1]['builders']
  ('job-a', ['x-builder'])

  >>> rv[2]['name'], rv[2]['builders']
  ('job-b', ['x-builder'])

  >>> rv[3]['name'], rv[3]['builders'][0]['x-builder']['goal']
  ('x-69', 'noise')

  >>> rv[4]['name'], rv[4]['builders'][0]['x-builder']['goal']
  ('x-42', 'noise')
