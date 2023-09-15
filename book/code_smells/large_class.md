## Large Class

Most Rails applications suffer from several Large Classes. Large classes are
difficult to understand and make it harder to change or reuse behavior.
Tests for large classes are slow and churn tends to be higher, leading to more
bugs and conflicts. Large classes likely also suffer from [divergent
change](#divergent-change).

### Symptoms

* You can't easily describe what the class does in one sentence.
* You can't tell what the class does without scrolling.
* The class needs to change for more than one reason.
* The class has more than seven methods.
* The class has a total flog score of 50.

### Example

This class has a high flog score, has a large number of methods, more private
than public methods and has multiple responsibilities:

` app/models/question.rb@2f6e005

### Solutions

* [Move method](#move-method) to move methods to another class if an
  existing class could better handle the responsibility.
* [Extract class](#extract-class) if the class has multiple responsibilities.
* [Replace conditional with polymorphism](#replace-conditional-with-polymorphism)
if the class contains private methods related to conditional branches.
* [Extract value object](#extract-value-object) if the class contains
  private query methods.
* [Extract decorator](#extract-decorator) if the class contains delegation
  methods.
* [Replace subclasses with strategies](#replace-subclasses-with-strategies) if
  the large class is a base class in an inheritance hierarchy.

### Prevention

Following the [single responsibility
principle](#single-responsibility-principle) will prevent large classes from
cropping up. It's difficult for any class to become too large without taking on
more than one responsibility.

Using [composition over inheritance](#composition-over-inheritance) makes it
easier to create small classes.

If a large portion of the class is devoted to instantiating subclasses, try
following the [dependency inversion principle](#dependency-inversion-principle).

Following the [open/closed principle](#openclosed-principle) will prevent large
classes by preventing new concerns from being introduced.

You can use flog to analyze classes as you write and modify them:

    % flog -a app/models/question.rb
        48.3: flog total
         6.9: flog/method average

        15.6: Question#summarize_multiple_choice_answers app/models/question.rb:38
        12.0: Question#none
         6.3: Question#summary                 app/models/question.rb:17
         5.2: Question#summarize_open_answers  app/models/question.rb:48
         3.6: Question#summarize_scale_answers app/models/question.rb:52
         3.4: Question#steps                   app/models/question.rb:28
         2.2: Question#scale?                  app/models/question.rb:34

#### Private Methods

In general, public methods are a greater liability than private methods. This is
because it's harder to tell where public methods are used, so you need to take
greater care when refactoring them. However, a large suite of private methods is
also a strong indicator of a large class.

Private methods can't be reused between classes, which makes it more likely that
code will be duplicated. Extracting private methods to new classes makes it
easier for developers to do the right thing.

Additionally, private methods can't be tested directly. This makes it more
difficult to write focused, simple unit tests, since the tests will need to go
through one or more public methods. The further a test is from the code it
tests, the harder it is to understand.

Lastly, private methods are often the easiest to extract to new classes. Large
classes can be difficult to split up because of entangled dependencies between
public and private methods.

Attempts to extract public methods will frequently halt when shared dependencies
are discovered on private methods. Extracting the private behavior of a class
into a small, reusable class is often the easiest first step towards splitting
up a large class.

Keeping a class's public interface as small as possible is a best practice.
However, keep an eye on your private interface as well. A maze of private
dependencies is a good sign that your public interface is not cohesive and can
be split into two or more classes.

#### God Class

A particular specimen of large class affects most Rails applications: the God
class. A God class is any class that seems to know everything about an
application. It has a reference to the majority of the other models and it's
difficult to answer any question or perform any action in the application
without going through this class.

Most applications have two God classes: the user, and the central focus of the
application. For a todo list application, it will be user and todo; for photo
sharing application, it will be user and photo.

You need to be particularly vigilant about refactoring these classes. If you
don't start splitting up your God classes early on, it will become
impossible to separate them without rewriting most of your application.

Treatment and prevention of God classes is the same as for any large class.
