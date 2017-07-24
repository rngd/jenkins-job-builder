.. vim: ft=rst

setup::

  >>> from setup import JJBConfig
  >>> import jenkins_jobs.parser as cut

  >>> from setup import isolate; isolate()

expansion does not happen in arbitrary nodes::

  >>> input = u"""
  ... - rofl:
  ...     name: lmao{wtf}
  ...     omg: 'rofl{snafubar}lmao'
  ...     foo: '{lol}-bar'
  ...     baz: qux
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> p = cut.YamlParser(JJBConfig())
  >>> p.parse("input")
  >>> p.data
  {'rofl': {'lmao{wtf}': ...}}

  >>> p.data['rofl']['lmao{wtf}']['name']
  'lmao{wtf}'
  >>> p.data['rofl']['lmao{wtf}']['omg']
  'rofl{snafubar}lmao'

expansion does not happen in job nodes::

  >>> input = u"""
  ... - job:
  ...     name: lmao{wtf}
  ...     omg: 'rofl{snafubar}lmao'
  ...     foo: '{lol}-bar'
  ...     baz: qux
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> p = cut.YamlParser(JJBConfig())
  >>> p.parse("input")
  >>> p.data
  {'job': {'lmao{wtf}': ...}}

  >>> p.data['job']['lmao{wtf}']['name']
  'lmao{wtf}'
  >>> p.data['job']['lmao{wtf}']['omg']
  'rofl{snafubar}lmao'

expansion does not happen in job-template nodes::

  >>> input = u"""
  ... - job-template:
  ...     name: lmao{wtf}
  ...     omg: 'rofl{snafubar}lmao'
  ...     foo: '{lol}-bar'
  ...     baz: qux
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> p = cut.YamlParser(JJBConfig())
  >>> p.parse("input")
  >>> p.data
  {'job-template': {'lmao{wtf}': ...}}

  >>> p.data['job-template']['lmao{wtf}']['name']
  'lmao{wtf}'
  >>> p.data['job-template']['lmao{wtf}']['omg']
  'rofl{snafubar}lmao'
