## Move Method

Moving methods is generally easy. Moving a method allows you to place a method
closer to the state it uses by moving it to the class that owns the related
state.

To move a method:

* Move the entire method definition and body into the new class.
* Change any parameters that are part of the state of the new class to simply
  reference the instance variables or methods.
* Introduce any necessary parameters because of state which belongs to the old
  class.
* Rename the method if the new name no longer makes sense in the new context
  (for example, rename `invite_user` to `invite` once the method is moved to the
  `User` class).
* Replace calls to the old method to calls to the new method. This may require
  introducing delegation or building an instance of the new class.

### Uses

* Removes [feature envy](#feature-envy) by moving a method to the class where the
  envied methods live.
* Makes private, parameterized methods easier to reuse by moving them to public,
  unparameterized methods.
* Improves readability by keeping methods close to the other methods they use.

Let's take a look at an example method that suffers from [feature
envy](#feature-envy) and use [extract method](#extract-method) and [move method](#move-method)
to improve it:

` app/models/completion.rb@e6895ad:16,21

The block in this method suffers from [feature envy](#feature-envy): It
references `answer` more than it references methods or instance variables from
its own class. We can't move the entire method; we only want to move the block,
so let's first extract a method:

` app/models/completion.rb@d5b4871:16,20

` app/models/completion.rb@d5b4871:28,31

The `score` method no longer suffers from [feature envy](#feature-envy), and the
new `score_for_answer` method is easy to move, because it only references its
own state. See the [Extract Method](#extract-method) chapter for details on
the mechanics and properties of this refactoring.

Now that the [feature envy](#feature-envy) is isolated, let's resolve it by
moving the method:

` app/models/completion.rb@fe3ef38:16,20

` app/models/answer.rb@fe3ef38:17,19

The newly extracted and moved `Question#score` method no longer suffers from
[feature envy](#feature-envy). It's easier to reuse, because the logic is freed
from the internal block in `Completion#score`. It's also available to other
classes because it's no longer a private method. Both methods are also easier
to follow because the methods they invoke are close to the methods they depend
on.

### Dangerous: Move and Extract at the Same Time

It's tempting to do everything as one change: create a new method in `Answer`,
move the code over from `Completion` and change `Completion#score` to call the
new method. Although this frequently works without a hitch, with practice, you
can perform the two, smaller refactorings just as quickly as the single, larger
refactoring. By breaking the refactoring into two steps, you reduce the duration
of "down time" for your code; that is, you reduce the amount of time during
which something is broken. Improving code in smaller steps makes it easier to debug
when something goes wrong and prevents you from writing more code than you need
to. Because the code still works after each step, you can simply stop whenever
you're happy with the results.

### Next Steps

* Make sure the new method doesn't suffer from [feature envy](#feature-envy)
  because of state it used from its original class. If it does, try splitting
  the method up and moving part of it back.
* Check the class of the new method to make sure it's not a [large
  class](#large-class).
