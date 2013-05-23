## Metrics

Various tools are available which can aid you in your search for code smells.

You can use [flog](http://rubygems.org/gems/flog) to detect complex parts of
code. If you look at the classes and methods with the highest flog score, you'll
probably find a few smells worth investigating.

Duplication is one of the hardest problems to find by hand. If you're using
diffs during code reviews, it will be invisible when you copy and paste
existing methods. The original method will be unchanged and won't show up in the
diff, so unless the reviewer knows and remembers that the original existed, they
won't notice that the copied method isn't just a new addition. Use
[flay](http://rubygems.org/gems/flay) to find duplication. Every duplicated
piece of code is a bug waiting to happen.

When looking for smells, [reek](https://github.com/troessner/reek/wiki) can find
certain smells reliably and quickly. Attempting to maintain a "reek free"
code base is costly, but using reek once you discover a problematic class or
method may help you find the solution.

To find files with a high churn rate, try out the aptly-named
[churn](https://github.com/danmayer/churn) gem. This works best with Git, but
will also work with Subversion.

You can also use [Code Climate](https://codeclimate.com/), a hosted tool
which will scan your code for issues every time you push to Git. Code Climate
attempts to locate hot spots for refactoring and assigns each class a simple A
through F grade.

If you'd prefer not to use a hosted service, you can use
[MetricFu](https://github.com/metricfu/metric_fu) to run a large suite of tools
to analyze your application.

Getting obsessed with the counts and scores from these tools will distract from
the actual issues in your code, but it's worthwhile to run them continually and
watch out for potential warning signs.
