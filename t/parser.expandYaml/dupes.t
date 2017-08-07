.. vim: ft=rst

setup::

  >>> from setup import JJBConfig
  >>> import jenkins_jobs.parser as cut

  >>> from setup import isolate; isolate()

  >>> class FakeRegistry(object):
  ...   def __init__(o):
  ...     o.modules = ()


won't be fooled by duplicates after expansion::

  >>> input = u"""
  ... - project:
  ...     name: snafubar
  ...     jobs:
  ...       - x-{omg}
  ...       - x-{wtf}
  ...     omg: fubar
  ...     wtf: fubar
  ... - job-template:
  ...     name: x-{omg}
  ... - job-template:
  ...     name: x-{wtf}
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> p = cut.YamlParser(JJBConfig())
  >>> p.parse("input")
  >>> try:
  ...   rv = p.expandYaml(FakeRegistry())
  ... except cut.JenkinsJobsException as e:
  ...   print(e)
  Duplicate definitions for job 'x-fubar' specified

won't be fooled by duplicates after expansion::

  >>> input = u"""
  ... - project:
  ...     name: snafubar
  ...     jobs:
  ...       - fubar
  ...       - snafu
  ...       - fubar
  ... - job:
  ...     name: fubar
  ... - job:
  ...     name: snafu
  ... """
  >>> with open("input", "w") as fd:
  ...   _ = fd.write(input)

  >>> p = cut.YamlParser(JJBConfig())
  >>> p.parse("input")
  >>> try:
  ...   rv = p.expandYaml(FakeRegistry())
  ... except cut.JenkinsJobsException as e:
  ...   print(e)
  Duplicate job 'fubar' specified for project 'snafubar'
