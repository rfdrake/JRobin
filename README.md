# JRobin - Access to JRobin JRD files via Perl Objects ![BUILD](https://travis-ci.org/rfdrake/JRobin.svg)


This provides users with an easier way to access JRobin files if they aren't
starting with Java.  The most likely usage would be to read the JRobin
database, format it into JSON or CSV and pass it to d3.js or another charting
library to do custom charts.

# Limitations

## The documentation isn't the best

It's a complete afterthought.  I've tried to expand it and keep it correct but
I know there are gaps where I just left out how things work.  Reading the
source is pretty much a requirement to figure out how to use it.

## Currently read-only

I don't think it would be hard to add write provisions to the code, but it
wasn't something I needed, nor am I sure it would be a great idea.  You run
the risk of Java and Perl's differences with doubles becoming a noticeable
thing in your graphs.  I think it's best to stick with only one library for
writing.  However, if someone sees a need we could always add it.

# Maybe OpenNMS already exports these as XML via REST?

Well then that's nice.  Way to spoil my fun.

My intention was to write this years ago, but lots of things have gotten in
the way.  It's always bothered me that JRobin has been under-documented.  I
know I haven't done much to better document it by reading the source and
implementing this, but at least this reader is pretty small and could
hopefully be rewritten by people in other languages if they wanted to give it
a shot.

And maybe OpenNMS hasn't gotten around to implementing this yet.  Or maybe
you're running an older release and you really want this kind of feature but
can't upgrade to latest scary-version yet. :)

