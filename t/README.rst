run these from the root of the repo with either::

  % python2 t/fe.py

or::

  % python3 t/fe.py

output of ``YamlParser#expandYaml`` is unstable under python3
as noted in the affected test(s).  plus there's some
annoying output from ``logging``::

    roman@dagon ~/wk/jenkins-job-builder explore 0 1389 0 . python3 t/fe.py
    .Failed to include file using search path: '.'
    .Failed to include file using search path: '.'
    .......Failed to include file using search path: '.:.'
    .Failed to include file using search path: '.:.'
    ..
    ----------------------------------------------------------------------
    Ran 12 tests in 0.065s

    OK
    roman@dagon ~/wk/jenkins-job-builder explore 0 1390 0 . python2 t/fe.py
    .No handlers could be found for logger "jenkins_jobs.local_yaml"
    ...........
    ----------------------------------------------------------------------
    Ran 12 tests in 0.069s

    OK

