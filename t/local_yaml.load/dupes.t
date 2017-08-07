.. vim: ft=rst

setup::

  >>> from setup import strio
  >>> import jenkins_jobs.local_yaml as cut

  >>> from setup import isolate; isolate()

anything goes on this level::

  >>> input = strio(u"""
  ... rofl:
  ...   - snafu
  ...   - fubar
  ... rofl:
  ...   - omg
  ...   - wtf
  ... """)

  >>> rv = cut.load(input)

  >>> type(rv)
  <class 'collections.OrderedDict'>

  >>> list(rv.keys())
  ['rofl']

  >>> type(rv['rofl'])
  <... 'list'>

  >>> rv['rofl'][0]
  'omg'
