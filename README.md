resque-fairly
====

Normally resque processes queues in a fixed order.  This can lead to
jobs in queues at the end of the list not getting handled for very
long periods.  resque-fairly provides a mechanism where by workers are
distributed across the set of queues with pending jobs fairly.  This
results in a much more predictable mean time to handling for jobs in
queues that are not the first in the list.

Note on Patches/Pull Requests
----
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with the version.  (if you
  want to have your own version, that is fine but bump version in a
  commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
----

Copyright (c) 2010 Peter Williams. See LICENSE for details.
