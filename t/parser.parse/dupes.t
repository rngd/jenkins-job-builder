.. vim: ft=rst

setup::

  >>> from setup import JJBConfig
  >>> import jenkins_jobs.parser as cut

  >>> from setup import isolate; isolate()

  >>> input = u"""
  ... - rofl:
  ...     name: lmao
  ... - rofl:
  ...     name: lmao
  ... """
  >>> with open("dupes", "w") as fd:
  ...   _ = fd.write(input)

  >>> input = u"""
  ... - rofl:
  ...     name: lmao
  ... """
  >>> with open("rofl0", "w") as fd:
  ...   _ = fd.write(input)
  >>> with open("rofl1", "w") as fd:
  ...   _ = fd.write(input)


all is ok with duplicates allowed::

  >>> p = cut.YamlParser(JJBConfig(allow_duplicates = True))
  >>> p.parse("dupes")
  >>> p.parse("rofl0")
  >>> p.parse("rofl1")


throws with duplicates disallowed::

  >>> p = cut.YamlParser(JJBConfig(allow_duplicates = False))

  >>> try:
  ...   p.parse("dupes")
  ... except cut.JenkinsJobsException as e:
  ...   print(e)
  Duplicate entry found in 'dupes: 'lmao' already defined

  >>> try:
  ...   p.parse("rofl0")
  ... except cut.JenkinsJobsException as e:
  ...   print(e)
  Duplicate entry found in 'rofl0: 'lmao' already defined
