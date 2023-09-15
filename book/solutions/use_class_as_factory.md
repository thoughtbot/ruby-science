## Use Class as Factory

An Abstract Factory is an object that knows how to build something, such as one
of several possible strategies for summarizing answers to questions on a survey.
An object that holds a reference to an abstract factory doesn't need to know
what class is going to be used; it trusts the factory to return an object that
responds to the required interface.

Because classes are objects in Ruby, every class can act as an abstract factory.
Using a class as a factory allows us to remove most explicit factory objects.

### Uses

* Removes [duplicated code](#duplicated-code) and [shotgun
  surgery](#shotgun-surgery) by cutting out crufty factory classes.
* Combines with [convention over configuration](#convention-over-configuration)
  to eliminate [shotgun surgery](#shotgun-surgery) and [case
  statements](#case-statement).

\clearpage

### Example

This controller uses one of several possible summarizer strategies to generate a
summary of answers to the questions on a survey:

` app/controllers/summaries_controller.rb@ac471507

The `summarizer` method is a Factory Method. It returns a summarizer object
based on `params[:id]`.

\clearpage

We can refactor that using the abstract factory pattern:

``` ruby
def summarizer
  summarizer_factory.build
end

def summarizer_factory
  case params[:id]
  when 'breakdown'
    BreakdownFactory.new
  when 'most_recent'
    MostRecentFactory.new
  when 'your_answers'
    UserAnswerFactory.new(current_user)
  else
    raise "Unknown summary type: #{params[:id]}"
  end
end
```

Now the `summarizer` method asks the `summarizer_factory` method for an abstract
factory, and it asks the factory to build the actual summarizer instance.

However, this means we need to provide an abstract factory for each summarizer
strategy:

``` ruby
class BreakdownFactory
  def build
    Breakdown.new
  end
end

class MostRecentFactory
  def build
    MostRecent.new
  end
end
```

\clearpage

``` ruby
class UserAnswerFactory
  def initialize(user)
    @user = user
  end

  def build
    UserAnswer.new(@user)
  end
end
```

These factory classes are repetitive and don't pull their weight. We can rip two
of these classes out by using the actual summarizer class as the factory
instance. First, let's rename the `build` method to `new`, to follow the Ruby
convention:

``` ruby
def summarizer
  summarizer_factory.new
end

class BreakdownFactory
  def new
    Breakdown.new
  end
end

class MostRecentFactory
  def new
    MostRecent.new
  end
end
```

\clearpage

``` ruby
class UserAnswerFactory
  def initialize(user)
    @user = user
  end

  def new
    UserAnswer.new(@user)
  end
end
```

Now, an instance of `BreakdownFactory` acts exactly like the `Breakdown` class
itself, and the same is true of `MostRecentFactory` and `MostRecent`. Therefore,
let's use the classes themselves instead of instances of the factory classes:

``` ruby
def summarizer_factory
  case params[:id]
  when 'breakdown'
    Breakdown
  when 'most_recent'
    MostRecent
  when 'your_answers'
    UserAnswerFactory.new(current_user)
  else
    raise "Unknown summary type: #{params[:id]}"
  end
end
```

Now we can delete two of our factory classes.

### Next Steps

* [Use convention over configuration](#use-convention-over-configuration) to
  remove manual mappings and possibly remove more classes.
