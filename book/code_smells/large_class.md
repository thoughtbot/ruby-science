# Large Class

Most Rails applications suffer from several Large Classes. Large classes are
difficult to understand and they make it harder to change or reuse behavior.
Tests for large classes are slow and churn tends to be higher, leading to more
bugs and conflicts. Large classes likely also suffer from [Divergent
Change](#divergent-change).

### Symptoms

* You can't easily describe what the class does in one sentence.
* You can't tell what the class does without scrolling.
* The class needs to change for more than one reason.
* The class has more private methods that public methods.
* The class has more than 7 methods.
* The class has a total flog score of 50.

\clearpage

### Example

This class has a high flog score, has a large number of methods, more private
than public methods, and has multiple responsibility:

` app/models/question.rb@2f6e005

### Solutions

* [Move Method](#move-method) to move methods to another class if an
  existing class could better handle the responsibility.
* [Extract Class](#extract-class) if the class has multiple responsibilities.
* [Replace Conditional with Polymorphism](#replace-conditional-with-polymorphism) 
if the class contains private methods related to conditional branches.
* [Extract Value Object](#extract-value-object) if the class contains
  private query methods.
* [Extract Decorator](#extract-decorator) if the class contains delegation
  methods.
* [Extract Service Object](#extract-service-object) if the class contains
  numerous objects related to a single action.

### Prevention

Following the [Single Responsibility
Principle](#single-responsibility-principle) will prevent large classes from
cropping up. It's difficult for any class to become too large without taking on
more than one responsibility.

\clearpage

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

## God Class

A particular specimen of Large Class affects most Rails applications: the God
Class. A God Class is any class that seems to know everything about an
application. It has a reference to the majority of the other models, and it's
difficult to answer any question or perform any action in the application
without going through this class.

Most applications have two God Classes: User, and the central focus of the
application. For a todo list application, it will be User and Todo; for photo
sharing application, it will be User and Photo.

You need to be particularly vigilant about refactoring these classes. If you
don't start splitting up your God Classes early on, then it will become
impossible to separate them without rewriting most of your application.

Treatment and prevention of God Classes is the same as for any Large Class.
