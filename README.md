# JRobin - Access to JRobin JRD files via Perl Objects

This provides users with an easier way to access JRobin files if they aren't
starting with Java.  The most likely usage would be to read the JRobin
database, format it into JSON or CSV and pass it to d3.js or another charting
library to do custom charts.

# Limitations

## Currently passes filehandle around

It used to use a screwed up method of passing the "remaining" bits of the
buffer around.  I decided that was dumb and rewrote it to just pass the
filehandle and read what bytes were needed at each place.

This makes more sense, but then I realized that if the JRobin source isn't a
file (filehandle) then you can't use this.

So another rewrite is needed with something better, but right now it does the
right thing for files.

## Is currently read-only

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


