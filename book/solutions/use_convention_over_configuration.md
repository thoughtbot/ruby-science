## Use Convention Over Configuration

Ruby's meta-programming allows us to avoid boilerplate code and duplication by
relying on conventions for class names, file names and directory structure.
Although depending on class names can be constricting in some situations,
careful use of conventions will make your applications less tedious and more
bug-proof.

### Uses

* Eliminates [case statements](#case-statement) by finding classes by name.
* Eliminates [shotgun surgery](#shotgun-surgery) by removing the need to register
  or configure new strategies and services.
* Eliminates [duplicated code](#duplicated-code) by removing manual associations
  from identifiers to class names.
* Prevents future duplication, making it easier to [avoid duplication](#dry).

\clearpage

### Example

This controller accepts an `id` parameter identifying which summarizer strategy
to use and renders a summary of the survey based on the chosen strategy:

` app/controllers/summaries_controller.rb@ec95b89f

The controller is manually mapping a given strategy name to an object
that can perform the strategy with the given name. In most cases, a strategy
name directly maps to a class of the same name.

We can use the `constantize` method from Rails to retrieve a class by name:

``` ruby
params[:id].classify.constantize
```

This will find the `MostRecent` class from the string `"most_recent"`, and so
on. This means we can rely on a convention for our summarizer strategies: Each
named strategy will map to a class implementing that strategy. The controller
can [use the class as an abstract factory](#use-class-as-factory) and obtain a
summarizer.

However, we can't immediately start using `constantize` in our example, because
there's one outlier case: The `UserAnswer` class is referenced using
`"your_answers"` instead of `"user_answer"`, and `UserAnswer` takes different
parameters than the other two strategies.

Before refactoring the code to rely on our new convention, let's refactor to
obey it. All our names should map directly to class names and each class should
accept the same parameters:

` app/controllers/summaries_controller.rb@5170bf536:9,20

\clearpage

Now that we know we can instantiate any of the summarizer classes the same way,
let's extract a method for determining the summarizer class:

` app/controllers/summaries_controller.rb@c5a44aaa1:9,24

The extracted method performs exactly the same logic as `constantize`, so
let's use it:

` app/controllers/summaries_controller.rb@2c632f078:9,15

Now we'll never need to change our controller when adding a new strategy; we
just add a new class following the naming convention.

### Scoping `constantize`

Our controller currently takes a string directly from user input (`params`) and
instantiates a class with that name.

There are two issues with this approach that should be fixed:

* There's no list of available strategies, so a developer would need to perform
  a complicated search to find the relevant classes.
* Without a whitelist, users can make the application instantiate any class
  they want, by hacking parameters. This can result in security vulnerabilities.

We can solve both easily by altering our convention slightly: Scope all the
strategy classes within a module.

We change our strategy factory method:

` app/controllers/summaries_controller.rb@2c632f078:9,15

To:

` app/controllers/summaries_controller.rb@4addd764:13,15

With this convention in place, you can find all strategies by just looking in
the `Summarizer` module. In a Rails application, this will be in a `summarizer`
directory by convention.

Users also won't be able to instantiate anything they want by abusing our
`constantize`, because only classes in the `Summarizer` module are available.

### Drawbacks

#### Weak Conventions

Conventions are most valuable when they're completely consistent.

The convention is slightly forced in this case because `UserAnswer` needs
different parameters than the other two strategies. This means that we now need
to add no-op `initializer` methods to the other two classes:

` app/models/summarizer/breakdown.rb@4addd764

This isn't a deal-breaker, but it makes the other classes a little noisier and
adds the risk that a developer will waste time trying to remove the unused
parameter.

Every compromise made weakens the convention, and having a weak convention is
worse than having no convention. If you have to change the convention for every
class you add that follows it, try something else.

#### Class-Oriented Programming

Another drawback to this solution is that it's entirely class-based, which means
you can't assemble strategies at run-time. This means that reuse requires
inheritance.

Also, while this class-based approach is convenient when developing an
application, it's more likely to cause frustration when writing a library. Forcing
developers to pass a class name instead of an object limits the amount of
runtime information strategies can use. In our example, only a `user` was
required. When you control both sides of the API, it's fine to assume that this
is safe. When writing a library that will interface with other developers'
applications, it's better not to rely on class names.
