riak_search
==========

The `riak_search` OTP application provides
[Riak](https://github.com/basho/riak) with the capability to act as a
_text search engine_ similar to Apache's Lucene.  Previously Riak
Search was a release in it's own right.  Since then Basho has decided
it would be easier for our users if Search was simply a set of
functionality that can be enabled via a config option.  For that
reason, if you want to use Search you'll have to build a Riak release
and enable it.


Enabling Search
----------

In order to enable the `riak_search` app in your Riak cluster you have
to modify the `etc/app.config` file.  Search for the text
`riak_search` and then change `{enabled, false}` to `{enabled, true}`.
The Search portion of your `app.config` will look something like this.

     {riak_search, [
                    {enabled, true},
                    {search_backend, merge_index_backend},
                    {java_home, "/usr"},
                    {max_search_results, 100000}
                   ]},
