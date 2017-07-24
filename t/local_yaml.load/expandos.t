.. vim: ft=rst

setup::

  >>> from setup import strio
  >>> import jenkins_jobs.local_yaml as cut

  >>> from setup import isolate; isolate()


expansion does not happen in this layer::

  >>> input = strio(u"""
  ... rofl:
  ...   - lmao{wtf}
  ...   - rofl{snafubar}lmao:
  ...       foo: '{lol}-bar'
  ...       baz: qux
  ... """)

  >>> rv = cut.load(input)

  >>> rv['rofl'][0]
  'lmao{wtf}'

  >>> list(rv['rofl'][1].keys())
  ['rofl{snafubar}lmao']

  >>> list(rv['rofl'][1]['rofl{snafubar}lmao'].items())
  [('foo', '{lol}-bar'), ('baz', 'qux')]
