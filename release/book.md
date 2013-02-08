% Ruby Science
% thoughtbot; Joe Ferris; Harlow Ward

\clearpage

# Introduction

Ruby on Rails is almost a decade old, and its community has developed a number
of principles for building applications that are fast, fun, and easy to change:
don't repeat yourself, keep your views dumb, keep your controllers skinny, and
keep business logic in your models. These principles carry most applications to
their first release or beyond.

However, these principles only get you so far. After a few releases, most
applications begin to suffer. Models become fat, classes become few and large,
tests become slow, and changes become painful. In many applications, there
comes a day when the developers realize that there's no going back; the
application is a twisted mess, and the only way out is a rewrite or a new job.

Fortunately, it doesn't have to be this way. Developers have been using
object-oriented programming for several decades, and there's a wealth of
knowledge out there which still applies to developing applications today. We can
use the lessons learned by these developers to write good Rails applications by
applying good object-oriented programming.

Ruby Science will outline a process for detecting emerging problems in code, and
will dive into the solutions, old and new.

## Code Reviews

The first step towards cleaner code is to make sure you read the code as you
write it. Have you ever typed up a long e-mail, hit "Send," and then realized
later that you made several typos? The problem here is obvious: you didn't read
what you'd written before sending it. Proofreading your e-mails will save you
from all kinds of embarrassments. Proofreading your code will do the same.

An easy way to make it simple to proofread code is to always work on a feature
branch.  Never commit directly to your master branch; doing so will make it
tempting to either push code that hasn't been reviewed, or keep code on your
local machine.  Neither is a good idea.

The first person who should look at every line of code you write is easy to
find: it's you! Before merging your feature branch, look at the diff of what
you've done. Read through each changed line, each new method, and each new
class to make sure that you like what you see. One easy way to make sure that
you look at everything before committing it is to use `git add --patch` instead
of `git add`. This will force you to confirm each change you make.

If you're working on a team, ask your teammates to review your code as well.
After working on the same piece of code for a while, it's easy to develop
tunnel vision. Getting a fresh and different perspective will help catch
mistakes early. After you review your own code, don't merge your feature branch
just yet. Push it up and invite your team members to view the diff as well.
When reviewing somebody else's code, take the same approach you took above:
page through the diff, and make sure you like everything you see.

Team code reviews provide another benefit: you get immediate feedback on how
understandable a piece of code is. Chances are good that you'll understand your
own code. After all, you just wrote it. However, you want your team members to
understand your code as well. Also, even though the code is clear now, it may
not be as obvious looking over it again in six months. Your team members will
be a good indicator of what your own understanding will be in the future. If it
doesn't make sense to them now, it won't make sense to you later.

Code reviews provide an opportunity to catch mistakes and improve code before it
ever gets merged, but there's still a big question out there: what should you be
looking for?

## Just Follow Your Nose

The primary motivator for refactoring is the code smell. A code smell is an
indicator that something may be wrong in the code. Not every smell means
that you should fix something; however, smells are useful because they're
easy to spot, and the root cause for a particular problem can be harder to track
down.

When performing code reviews, be on the lookout for smells. Whenever you see a
smell, think about whether or not it would be better if you changed the code to
remove the smell. If you're reviewing somebody else's code, suggest possible
ways to refactor the code which would remove the smell.

Don't treat code smells as bugs. Attempting to "fix" every smell you run across
will end up being a waste of time, as not every smell is the symptom of an
actual problem. Worse, removing code smells for the sake of process will end up
obfuscating code because of the unnecessary hoops you'll jump through. In the
end, it will prove impossible to remove every smell, as removing one smell will
often introduce another.

Each smell is associated with one or more common refactorings. If you see a long
method, the most common way to improve the method is to extract new, smaller
methods. Knowing the common refactorings that remove a smell will allow you to
quickly think about how the code might change. Knowing that long methods can be
removed by extracting methods, you can decide whether or not the end result of
having several methods will be better or worse.

## Removing Resistance

There's another obvious opportunity for refactoring: any time you're having a
hard time introducing a change to existing code, consider refactoring the code
first. What you change will depend on what type of resistance you met.

Did you have a hard time understanding the code? If the result you wanted seemed
simple, but you couldn't figure out where to introduce it, the code isn't
readable enough. Refactor the code until it's obvious where your change belongs,
and it will make this change and every subsequent change easier. Refactor for
readability first.

Was it hard to change the code without breaking existing code? Change the
existing code to be more flexible. Add extension points or extract code to be
easier to reuse, and then try to introduce your change. Repeat this process
until the change you want is easy to introduce.

This work flow pairs well with fast branching systems like Git. First, create a
new branch and attempt to make your change without any refactoring. If the
change is difficult, make a work in progress commit, switch back to master, and
create a new branch for refactoring. Refactor until you fix the resistance you
met on your feature branch, and then rebase the feature branch on top of the
refactoring branch. If the change is easier now, you're good to go. If not,
switch back to your refactoring branch and try again.

Each change should be easy to introduce. If it's not, it's time to refactor.

## Bugs and Churn

If you're spending a lot of time swatting bugs, you should consider refactoring
the buggy portions of code. After each bug is fixed, examine the methods and
classes you had to change to fix the bug. If you remove any smells you discover
in the affected areas, then you'll make it less likely that a bug will be
reintroduced.

Bugs tend to crop up in the same places over and over. These places also tend to
be the methods and classes with the highest rate of churn. When you find a bug,
use Git to see if the buggy file changes often. If so, try refactoring the
classes or methods which keep changing. If you separate the pieces that change
often from the pieces that don't, then you'll spend less time fixing existing
code. When you find files with high churn, look for smells in the areas that
keep changing. The smell may reveal the reason for the high churn.

Conversely, it may make sense to avoid refactoring areas with low churn.
Although refactoring is an important part of keeping your code sane, refactoring
changes code, and with each change, you risk introducing new bugs. Don't
refactor just for the sake of "cleaner" code; refactor to address real problems.
If a file hasn't changed in six months and you aren't finding bugs in it, leave
it alone. It may not be the prettiest thing in your code base, but you'll have
to spend more time looking at it when you break it while trying to fix something
that wasn't broken.

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

Getting obsessed with the counts and scores from these tools will distract from
the actual issues in your code, but it's worthwhile to run them continually and
watch out for potential warning signs.

## How To Read This Book

This book contains three catalogs: smells, solutions, and principles.

Start by looking up a smell that sounds familiar. Each chapter on smells explains
the potential problems each smell may reveal and references possible
solutions.

Once you've identified the problem revealed by a smell, read the relevant
solution chapter to learn how to fix it. Each solution chapter will explain
which problems it addresses and potential problems which can be introduced.

Lastly, smell and solution chapters will reference related principles. The smell
chapters will reference principles that you can follow to avoid the root problem
in the future. The solution chapters will explain how each solution changes your
code to follow related principles.

By following this process, you'll learn how to detect and fix actual problems in
your code using smells and reusable solutions, and you'll learn about principles
that you can follow to improve the code you write from the beginning.

\mainmatter
\part{Code Smells}

# Long Method

The most common smell in Rails applications is the Long Method.

Long methods are exactly what they sound like: methods which are too long.
They're easy to spot.

### Symptoms

* If you can't tell exactly what a method does at a glance, it's too long.
* Methods with more than one level of nesting are usually too long.
* Methods with more than one level of abstraction may be too long.
* Methods with a flog score of 10 or higher may be too long.

You can watch out for long methods as you write them, but finding existing
methods is easiest with tools like flog:

    % flog app lib
        72.9: flog total
         5.6: flog/method average

        15.7: QuestionsController#create       app/controllers/questions_controller.rb:9
        11.7: QuestionsController#new          app/controllers/questions_controller.rb:2
        11.0: Question#none
         8.1: SurveysController#create         app/controllers/surveys_controller.rb:6

Methods with higher scores are more complicated. Anything with a score higher
than 10 is worth looking at, but flog will only help you find potential trouble
spots; use your own judgement when refactoring.

### Example

For an example of a Long Method, let's take a look at the highest scored method
from flog, `QuestionsController#create`:

```` ruby
def create
  @survey = Survey.find(params[:survey_id])
  @submittable_type = params[:submittable_type_id]
  question_params = params.
    require(:question).
    permit(:submittable_type, :title, :options_attributes, :minimum, :maximum)
  @question = @survey.questions.new(question_params)
  @question.submittable_type = @submittable_type

  if @question.save
    redirect_to @survey
  else
    render :new
  end
end
````

### Solutions

* [Extract Method](#extract-method) is the most common way to break apart long methods.
* [Replace Temp with Query](#replace-temp-with-query) if you have local variables
in the method.

After extracting methods, check for [Feature Envy](#feature-envy) in the new
methods to see if you should employ [Move Method](#move-method) to provide the
method with a better home.

# Large Class

Most Rails applications suffer from several Large Classes. Large classes are
difficult to understand and make it harder to change or reuse behavior.
Tests for large classes are slow and churn tends to be higher, leading to more
bugs and conflicts. Large classes likely also suffer from [Divergent
Change](#divergent-change).

### Symptoms

* You can't easily describe what the class does in one sentence.
* You can't tell what the class does without scrolling.
* The class needs to change for more than one reason.
* The class has more private methods than public methods.
* The class has more than 7 methods.
* The class has a total flog score of 50.

\clearpage

### Example

This class has a high flog score, has a large number of methods, more private
than public methods, and has multiple responsibility:

```ruby
# app/models/question.rb
class Question < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  SUBMITTABLE_TYPES = %w(Open MultipleChoice Scale).freeze

  validates :maximum, presence: true, if: :scale?
  validates :minimum, presence: true, if: :scale?
  validates :question_type, presence: true, inclusion: SUBMITTABLE_TYPES
  validates :title, presence: true

  belongs_to :survey
  has_many :answers
  has_many :options

  accepts_nested_attributes_for :options, reject_if: :all_blank

  def summary
    case question_type
    when 'MultipleChoice'
      summarize_multiple_choice_answers
    when 'Open'
      summarize_open_answers
    when 'Scale'
      summarize_scale_answers
    end
  end

  def steps
    (minimum..maximum).to_a
  end

  private

  def scale?
    question_type == 'Scale'
  end

  def summarize_multiple_choice_answers
    total = answers.count
    counts = answers.group(:text).order('COUNT(*) DESC').count
    percents = counts.map do |text, count|
      percent = (100.0 * count / total).round
      "#{percent}% #{text}"
    end
    percents.join(', ')
  end

  def summarize_open_answers
    answers.order(:created_at).pluck(:text).join(', ')
  end

  def summarize_scale_answers
    sprintf('Average: %.02f', answers.average('text'))
  end
end
```

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
* [Replace Subclasses with Strategies](#replace-subclasses-with-strategies) if
  the large class is a base class in an inheritance hierarchy.

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

# Feature Envy

Feature envy reveals a method (or method-to-be) that would work better on a
different class.

Methods suffering from feature envy contain logic that is difficult to reuse,
because the logic is trapped within a method on the wrong class. These methods
are also often private methods, which makes them unavailable to other classes.
Moving the method (or affected portion of a method) to a more appropriate class
improves readability, makes the logic easier to reuse, and reduces coupling.

### Symptoms

* Repeated references to the same object.
* Parameters or local variables which are used more than methods and instance
  variables of the class in question.
* Methods that includes a class name in their own names (such as `invite_user`).
* Private methods on the same class that accept the same parameter.
* [Law of Demeter](#law-of-demeter) violations.
* [Tell, Don't Ask](#tell-dont-ask) violations.

### Example

```ruby
# app/models/completion.rb
def score
  answers.inject(0) do |result, answer|
    question = answer.question
    result + question.score(answer.text)
  end
end
```

The `answer` local variable is used twice in the block: once to get its
`question`, and once to get its `text`. This tells us that we can probably
extract a new method and move it to the `Answer` class.

### Solutions

* [Extract Method](#extract-method) if only part of the method suffers from
  feature envy, and then move the method.
* [Move Method](#move-method) if the entire method suffers from feature envy.

# Case Statement

Case statements are a sign that a method contains too much knowledge.

### Symptoms

* Case statements that check the class of an object.
* Case statements that check a type code.
* [Divergent Change](#divergent-change) caused by changing or adding `when`
  clauses.
* [Shotgun Surgery](#shotgun-surgery) caused by duplicating the case statement.

Actual `case` statements are extremely easy to find. Just grep your codebase for
"case." However, you should also be on the lookout for `case`'s sinister cousin,
the repetitive `if-elsif`.

## Type Codes

Some applications contain type codes: fields that store type information about
objects. These fields are easy to add and seem innocent, but they result in code
that's harder to maintain. A better solution is to take advantage of Ruby's
ability to invoke different behavior based on an object's class, called "dynamic
dispatch." Using a case statement with a type code inelegantly reproduces
dynamic dispatch.

The special `type` column that ActiveRecord uses is not necessarily a type code.
The `type` column is used to serialize an object's class to the database, so
that the correct class can be instantiated later on. If you're just using the
`type` column to let ActiveRecord decide which class to instantiate, this isn't
a smell. However, make sure to avoid referencing the `type` column from `case`
or `if` statements.

### Example

This method summarizes the answers to a question. The summary varies based on
the type of question.

```ruby
# app/models/question.rb
def summary
  case question_type
  when 'MultipleChoice'
    summarize_multiple_choice_answers
  when 'Open'
    summarize_open_answers
  when 'Scale'
    summarize_scale_answers
  end
end
```

Note that many applications replicate the same `case` statement, which is a more
serious offence. This view duplicates the `case` logic from `Question#summary`,
this time in the form of multiple `if` statements:

```rhtml
# app/views/questions/_question.html.erb
<% if question.question_type == 'MultipleChoice' -%>
  <ol>
    <% question.options.each do |option| -%>
      <li>
        <%= submission_fields.radio_button :text, option.text, id: dom_id(option) %>
        <%= content_tag :label, option.text, for: dom_id(option) %>
      </li>
    <% end -%>
  </ol>
<% end -%>

<% if question.question_type == 'Scale' -%>
  <ol>
    <% question.steps.each do |step| -%>
      <li>
        <%= submission_fields.radio_button :text, step %>
        <%= submission_fields.label "text_#{step}", label: step %>
      </li>
    <% end -%>
  </ol>
<% end -%>
```

### Solutions

* [Replace Type Code with Subclasses](#replace-type-code-with-subclasses) if the
  `case` statement is checking a type code, such as `question_type`.
* [Replace Conditional with Polymorphism](#replace-conditional-with-polymorphism)
  when the `case` statement is checking the class of an object.
* [Use Convention over Configuration](#use-convention-over-configuration) when
  selecting a strategy based on a string name.

# High Fan-out

STUB

# Shotgun Surgery

Shotgun Surgery is usually a more obvious symptom that reveals another smell.

### Symptoms

* You have to make the same small change across several different files.
* Changes become difficult to manage because they are hard to keep track of.

Make sure you look for related smells in the affected code:

* [Duplicated Code](#duplicated-code)
* [Case Statement](#case-statement)
* [Feature Envy](#feature-envy)
* [Long Parameter List](#long-parameter-list)
* [Parallel Inheritance Hierarchies](#parallel-inheritance-hierarchies)

\clearpage

### Example

Users names are formatted and displayed as 'First Last' throughout the application. 
If we want to change the formating to include a middle initial (e.g. 'First M. Last') 
we'd need to make the same small change in several places.

```rhtml
# app/views/users/show.html.erb
<%= current_user.first_name %> <%= current_user.last_name %>

# app/views/users/index.html.erb
<%= current_user.first_name %> <%= current_user.last_name %>

# app/views/layouts/application.html.erb
<%= current_user.first_name %> <%= current_user.last_name %>

# app/views/mailers/completion_notification.html.erb
<%= current_user.first_name %> <%= current_user.last_name %>

```

### Solutions

* [Replace Conditional with Polymorphism](#replace-conditional-with-polymorphism)
to replace duplicated `case` statements and `if-elsif` blocks.
* [Replace Conditional with Null Object](#replace-conditional-with-null-object)
  if changing a method to return `nil` would require checks for `nil` in several
  places.
* [Extract Decorator](#extract-decorator) to replace duplicated display code in 
views/templates.
* [Introduce Parameter Object](#introduce-parameter-object) to hang useful
formatting methods alongside a data clump of related attributes.
* [Use Convention over Configuration](#use-convention-over-configuration) to
  eliminate small steps that can be inferred based on a convention such as a
  name.

# Divergent Change

A class suffers from Divergent Change when it changes for multiple reasons.

### Symptoms

* You can't easily describe what the class does in one sentence.
* The class is changed more frequently than other classes in the application.
* Different changes to the class aren't related to each other.

### Example

```ruby
# app/controllers/summaries_controller.rb
class SummariesController < ApplicationController
  def show
    @survey = Survey.find(params[:survey_id])
    @summaries = @survey.summarize(summarizer)
  end

  private

  def summarizer
    case params[:id]
    when 'breakdown'
      Breakdown.new
    when 'most_recent'
      MostRecent.new
    when 'your_answers'
      UserAnswer.new(current_user)
    else
      raise "Unknown summary type: #{params[:id]}"
    end
  end
end
```

This controller has multiple reasons to change:

* Control flow logic related to summaries, such as authentication.
* Any time a summarizer strategy is added or changed.

### Solutions

* [Extract Class](#extract-class) to move one cause of change to a new class.
* [Move Method](#move-method) if the class is changing because of methods that
  relate to another class.
* [Extract Validator](#extract-validator) to move validation logic out of
  models.
* [Introduce Form Object](#introduce-form-object) to move form logic out of
  controllers.
* [Use Convention over Configuration](#use-convention-over-configuration) to
  eliminate changes that can be inferred by a convention such as a name.

### Prevention

You can prevent Divergent Change from occurring by following the [Single
Responsibility Principle](#single-responsibility-principle). If a class has only
one responsibility, it has only one reason to change.

You can use churn to discover which files are changing most frequently. This
isn't a direct relationship, but frequently changed files often have more than
one responsibility, and thus more than one reason to change.

# Long Parameter List

Ruby supports positional method arguments which can lead to Long Parameter Lists.

### Symptoms

* You can't easily change the method's arguments.
* The method has three or more arguments.
* The method is complex due to number of collaborating parameters.
* The method requires large amounts of setup during isolated testing.

### Example

Look at this mailer for an example of Long Parameter List.

```ruby
# app/mailers/mailer.rb
class Mailer < ActionMailer::Base
  default from: "from@example.com"

  def completion_notification(first_name, last_name, email)
    @first_name = first_name
    @last_name = last_name

    mail(
      to: email,
      subject: 'Thank you for completing the survey'
    )
  end
end
```

### Solutions

* [Introduce Parameter Object](#introduce-parameter-object) and pass it in as an
object of naturally grouped attributes.

A common technique used to mask a long parameter list is grouping parameters using a
hash of named parameters; this will replace connascence position with connascence 
of name (a good first step). However, it will not reduce the number of collaborators
in the method.

* [Extract Class](#extract-class) if the method is complex due to the number of collaborators.

# Duplicated Code

One of the first principles we're taught as developers: Keep your code [DRY](#dry).

### Symptoms

* You find yourself copy and pasting code from one place to another.
* [Shotgun Surgery](#shotgun-surgery) occurs when changes to your application 
require the same small edits in multiple places.

\clearpage

### Example

The `QuestionsController` suffers from duplication in the `create` and `update` methods.

```ruby
# app/controllers/questions_controller.rb
def create
  @survey = Survey.find(params[:survey_id])
  question_params = params.
    require(:question).
    permit(:title, :options_attributes, :minimum, :maximum)
  @question = type.constantize.new(question_params)
  @question.survey = @survey

  if @question.save
    redirect_to @survey
  else
    render :new
  end
end

def update
  @question = Question.find(params[:id])
  question_params = params.
    require(:question).
    permit(:title, :options_attributes, :minimum, :maximum)
  @question.update_attributes(question_params)

  if @question.save
    redirect_to @question.survey
  else
    render :edit
  end
end
```

### Solutions

* [Extract Method](#extract-method) for duplicated code in the same file.
* [Extract Class](#extract-class) for duplicated code across multiple files.
* [Extract Partial](#extract-partial) for duplicated view and template code.
* [Replace Conditional with Polymorphism](#replace-conditional-with-polymorphism)
for duplicated conditional logic.
* [Replace Conditional with Null Object](#replace-conditional-with-null-object)
  to remove duplicated checks for `nil` values.

# Uncommunicative Name

STUB

# Single Table Inheritance (STI)

Using subclasses is a common method of achieving reuse in object-oriented
software. Rails provides a mechanism for storing instances of different classes
in the same table, called Single Table Inheritance. Rails will take care of most
of the details, writing the class's name to the type column and instantiating
the correct class when results come back from the database.

Inheritance has its own pitfalls - see [Composition Over
Inheritance](#composition-over-inheritance) - and STI introduces a few new
gotchas that may cause you to consider an alternate solution.

### Symptoms

* You need to change from one subclass to another.
* Behavior is shared among some subclasses but not others.
* One subclass is a fusion of one or more other subclasses.

\clearpage

### Example

This method on `Question` changes the question to a new type. Any necessary
attributes for the new subclass are provided to the `attributes` method.

```ruby
# app/models/question.rb
def switch_to(type, new_attributes)
  attributes = self.attributes.merge(new_attributes)
  new_question = type.constantize.new(attributes.except('id', 'type'))
  new_question.id = id

  begin
    Question.transaction do
      destroy
      new_question.save!
    end
  rescue ActiveRecord::RecordInvalid
  end

  new_question
end
```

This transition is difficult for a number of reasons:

* You need to worry about common `Question` validations.
* You need to make sure validations for the old subclass are not used.
* You need to make sure validations for the new subclass are used.
* You need to delete data from the old subclass, including associations.
* You need to support data from the new subclass.
* Common attributes need to remain the same.

The implementation achieves all these requirements, but is awkward:

* You can't actually change the class of an instance in Ruby, so you need to
  return the instance of the new class.
* The implementation requires deleting and creating records, but part of the
  transaction (`destroy`) must execute before we can validate the new instance.
  This results in control flow using exceptions.
* The STI abstraction leaks into the model, because it needs to understand that
  it has a `type` column. STI models normally don't need to understand that
  they're implemented using STI.
* It's hard to understand why this method is implemented the way it is, so other
  developers fixing bugs or refactoring  in the future will have a hard time
  navigating it.

### Solutions

* If you're using STI to reuse common behavior, use [Replace Subclasses with
  Strategies](#replace-subclasses-with-strategies) to switch to a
  composition-based model.
* If you're using STI so that you can easily refer to several different classes
  in the same table, switch to using a polymorphic association instead.

### Prevention

By following [Composition Over Inheritance](#composition-over-inheritance),
you'll use STI as a solution less often.

# Parallel Inheritance Hierarchies

STUB

# Comments

Comments can be used appropriately to introduce classes and provide
documentation, but used incorrectly, they mask readability and process problems
by further obfuscating already unreadable code.

### Symptoms

* Comments within method bodies.
* More than one comment per method.
* Comments that restate the method name in English.
* TODO comments.
* Commented out, dead code.

### Example

```ruby
# app/models/open_question.rb
def summary
  # Text for each answer in order as a comma-separated string
  answers.order(:created_at).pluck(:text).join(', ')
end
```

This comment is trying to explain what the following line of code does, because
the code itself is too hard to understand. A better solution would be to improve
the legibility of the code.

\clearpage

Some comments add no value at all and can safely be removed:

``` ruby
class Invitation
  # Deliver the invitation
  def deliver
    Mailer.invitation_notification(self, message).deliver
  end
end
```

If there isn't a useful explanation to provide for a method or class beyond the
name, don't leave a comment.

### Solutions

* [Introduce Explaining Variable](#introduce-explaining-variable) to make
  obfuscated lines easier to read in pieces.
* [Extract Method](#extract-method) to break up methods that are difficult
  to read.
* Move TODO comments into a task management system.
* Delete commented out code, and rely on version control in the event that you
  want to get it back.
* Delete superfluous comments that don't add more value than the method or class
  name.

# Mixin

STUB

# Callback

Callbacks are a convenient way to decorate the default `save` method with custom
persistence logic, without the drudgery of template methods, overriding, or
calling `super`.

However, callbacks are frequently abused by adding non-persistence logic to the
persistence life cycle, such as sending emails or processing payments. Models
riddled with callbacks are harder to refactor and prone to bugs, such as
accidentally sending emails or performing external changes before a database
transaction is committed.

### Symptoms

* Callbacks which contain business logic such as processing payments.
* Attributes which allow certain callbacks to be skipped.
* Methods such as `save_without_sending_email` which skip callbacks.
* Callbacks which need to be invoked conditionally.

### Example

```ruby
# app/models/survey_inviter.rb
def deliver_invitations
  recipients.map do |recipient_email|
    Invitation.create!(
      survey: survey,
      sender: sender,
      recipient_email: recipient_email,
      status: 'pending',
      message: @message
    )
  end
end
```

```ruby
# app/models/invitation.rb
after_create :deliver
```

```ruby
# app/models/invitation.rb
def deliver
  Mailer.invitation_notification(self).deliver
end
```

In the above code, the `SurveyInviter` is simply creating `Invitation` records,
and the actual delivery of the invitation email is hidden behind
`Invitation.create!` via a callback.

If one of several invitations fails to save, the user will see a 500 page, but
some of the invitations will already have been saved and delivered. The user
will be unable to tell which invitations were sent.

Because delivery is coupled with persistence, there's no way to make sure that
all of the invitations are saved before starting to deliver emails.

### Solutions

* [Replace Callback with Method](#replace-callback-with-method) if the callback
  logic is unrelated to persistence.

\part{Solutions}

# Replace Conditional with Polymorphism

Conditional code clutters methods, makes extraction and reuse harder, and can
lead to leaky concerns. Object-oriented languages like Ruby allow developers to
avoid conditionals using polymorphism. Rather than using `if`/`else` or
`case`/`when` to create a conditional path for each possible situation, you can
implement a method differently in different classes, adding (or reusing) a class
for each situation.

Replacing conditional code allows you to move decisions to the best point in the
application. Depending on polymorphic interfaces will create classes that don't
need to change when the application changes.

### Uses

* Removes [Divergent Change](#divergent-change) from classes that need to alter
  their behavior based on the outcome of the condition.
* Removes [Shotgun Surgery](#shotgun-surgery) from adding new types.
* Removes [Feature Envy](#feature-envy) by allowing dependent classes to make
  their own decisions.
* Makes it easier to remove [Duplicated Code](#duplicated-code) by taking
  behavior out of conditional clauses and private methods.

\clearpage

### Example

This `Question` class summarizes its answers differently depending on its
`question_type`:

```ruby
# app/models/question.rb
class Question < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  SUBMITTABLE_TYPES = %w(Open MultipleChoice Scale).freeze

  validates :maximum, presence: true, if: :scale?
  validates :minimum, presence: true, if: :scale?
  validates :question_type, presence: true, inclusion: SUBMITTABLE_TYPES
  validates :title, presence: true

  belongs_to :survey
  has_many :answers
  has_many :options

  accepts_nested_attributes_for :options, reject_if: :all_blank

  def summary
    case question_type
    when 'MultipleChoice'
      summarize_multiple_choice_answers
    when 'Open'
      summarize_open_answers
    when 'Scale'
      summarize_scale_answers
    end
  end

  def steps
    (minimum..maximum).to_a
  end

  private

  def scale?
    question_type == 'Scale'
  end

  def summarize_multiple_choice_answers
    total = answers.count
    counts = answers.group(:text).order('COUNT(*) DESC').count
    percents = counts.map do |text, count|
      percent = (100.0 * count / total).round
      "#{percent}% #{text}"
    end
    percents.join(', ')
  end

  def summarize_open_answers
    answers.order(:created_at).pluck(:text).join(', ')
  end

  def summarize_scale_answers
    sprintf('Average: %.02f', answers.average('text'))
  end
end
```

There are a number of issues with the `summary` method:

* Adding a new question type will require modifying the method, leading to
  [Divergent Change](#divergent-change).
* The logic and data for summarizing every type of question and answer is jammed
  into the `Question` class, resulting in a [Large Class](#large-class) with
  [Obscure Code](#obscure-code).
* This method isn't the only place in the application that checks question
  types, meaning that new types will cause [Shotgun Surgery](#shotgun-surgery).

## Replace Type Code With Subclasses

Let's replace this case statement with polymorphism by introducing a subclass
for each type of question.

Our `Question` class is a subclass of `ActiveRecord::Base`. If we want to create
subclasses of `Question`, we have to tell ActiveRecord which subclass to
instantiate when it fetches records from the `questions` table. The mechanism
Rails uses for storing instances of different classes in the same table is
called [Single Table Inheritance](#single-table-inheritance-sti). Rails will
take care of most of the details, but there are a few extra steps we need to
take when refactoring to Single Table Inheritance.

## Single Table Inheritance (STI)

The first step to convert to [STI](#single-table-inheritance-sti) is generally
to create a new subclass for each type. However, the existing type codes are
named "Open," "Scale," and "MultipleChoice," which won't make good class names;
names like "OpenQuestion" would be better, so let's start by changing the
existing type codes:

```ruby
# app/models/question.rb
def summary
  case question_type
  when 'MultipleChoiceQuestion'
    summarize_multiple_choice_answers
  when 'OpenQuestion'
    summarize_open_answers
  when 'ScaleQuestion'
    summarize_scale_answers
  end
end
```

```ruby
# db/migrate/20121128221331_add_question_suffix_to_question_type.rb
class AddQuestionSuffixToQuestionType < ActiveRecord::Migration
  def up
    connection.update(<<-SQL)
      UPDATE questions SET question_type = question_type || 'Question'
    SQL
  end

  def down
    connection.update(<<-SQL)
      UPDATE questions SET question_type = REPLACE(question_type, 'Question', '')
    SQL
  end
end
```

See commit b535171 for the full change.

The `Question` class stores its type code as `question_type`. The Rails
convention is to use a column named `type`, but Rails will automatically start
using STI if that column is present. That means that renaming `question_type` to
`type` at this point would result in debugging two things at once: possible
breaks from renaming, and possible breaks from using STI. Therefore,  let's
start by just marking `question_type` as the inheritance column, allowing us to
debug STI failures by themselves:

```ruby
# app/models/question.rb
set_inheritance_column  'question_type'
```

\clearpage

Running the tests after this will reveal that Rails wants the subclasses to be
defined, so let's add some placeholder classes:

```ruby
# app/models/open_question.rb
class OpenQuestion < Question
end
```

```ruby
# app/models/scale_question.rb
class ScaleQuestion < Question
end
```

```ruby
# app/models/multiple_choice_question.rb
class MultipleChoiceQuestion < Question
end
```

Rails generates URLs and local variable names for partials based on class names.
Our views will now be getting instances of subclasses like `OpenQuestion` rather
than `Question`, so we'll need to update a few more references. For example,
we'll have to change lines like:

``` erb
<%= form_for @question do |form| %>
```

To:

``` erb
<%= form_for @question, as: :question do |form| %>
```

Otherwise, it will generate `/open_questions` as a URL instead of `/questions`.
See commit c18ebeb for the full change.

At this point, the tests are passing with STI in place, so we can rename
`question_type` to `type`, following the Rails convention:

```ruby
# db/migrate/20121128225425_rename_question_type_to_type.rb
class RenameQuestionTypeToType < ActiveRecord::Migration
  def up
    rename_column :questions, :question_type, :type
  end

  def down
    rename_column :questions, :type, :question_type
  end
end
```

\clearpage

Now we need to build the appropriate subclass instead of `Question`. We can use
a little Ruby meta-programming to make that fairly painless:

```ruby
# app/controllers/questions_controller.rb
def build_question
  @question = type.constantize.new(question_params)
  @question.survey = @survey
end

def type
  params[:question][:type]
end
```

At this point, we're ready to proceed with a regular refactoring.

### Extracting Type-Specific Code

The next step is to move type-specific code from `Question` into the subclass
for each specific type.

Let's look at the `summary` method again:

```ruby
# app/models/question.rb
def summary
  case question_type
  when 'MultipleChoice'
    summarize_multiple_choice_answers
  when 'Open'
    summarize_open_answers
  when 'Scale'
    summarize_scale_answers
  end
end
```

For each path of the condition, there is a sequence of steps.

The first step is to use [Extract Method](#extract-method) to move each path to
its own method. In this case, we already extracted methods called
`summarize_multiple_choice_answers`, `summarize_open_answers`, and
`summarize_scale_answers`, so we can proceed immediately.

\clearpage

The next step is to use [Move Method](#move-method) to move the extracted method
to the appropriate class. First, let's move the method
`summarize_multiple_choice_answers` to `MultipleChoiceQuestion` and rename it to
`summary`:

```` ruby
class MultipleChoiceQuestion < Question
  def summary
    total = answers.count
    counts = answers.group(:text).order('COUNT(*) DESC').count
    percents = counts.map do |text, count|
      percent = (100.0 * count / total).round
      "#{percent}% #{text}"
    end
    percents.join(', ')
  end
end
````

`MultipleChoiceQuestion#summary` now overrides `Question#summary`, so the
correct implementation will now be chosen for multiple choice questions.

Now that the code for multiple choice types is in place, we repeat the steps for
each other path. Once every path is moved, we can remove `Question#summary`
entirely.

In this case, we've already created all our subclasses, but you can use [Extract
Class](#extract-class) to create them if you're extracting each conditional path
into a new class.

You can see the full change for this step in commit a08f801.

The `summary` method is now much better. Adding new question types is easier.
The new subclass will implement `summary`, and the `Question` class doesn't need
to change. The summary code for each type now lives with its type, so no one
class is cluttered up with the details.

\clearpage

## Polymorphic Partials

Applications rarely check the type code in just one place. Running grep on our
example application reveals several more places. Most interestingly, the views
check the type before deciding how to render a question:

```rhtml
# app/views/questions/_question.html.erb
<% if question.type == 'MultipleChoiceQuestion' -%>
  <ol>
    <% question.options.each do |option| -%>
      <li>
        <%= submission_fields.radio_button :text, option.text, id: dom_id(option) %>
        <%= content_tag :label, option.text, for: dom_id(option) %>
      </li>
    <% end -%>
  </ol>
<% end -%>

<% if question.type == 'ScaleQuestion' -%>
  <ol>
    <% question.steps.each do |step| -%>
      <li>
        <%= submission_fields.radio_button :text, step %>
        <%= submission_fields.label "text_#{step}", label: step %>
      </li>
    <% end -%>
  </ol>
<% end -%>

<% if question.type == 'OpenQuestion' -%>
  <%= submission_fields.text_field :text %>
<% end -%>
```

In the previous example, we moved type-specific code into `Question` subclasses.
However, moving view code would violate MVC (introducing [Divergent
Change](#divergent-change) into the subclasses), and more importantly, it would
be ugly and hard to understand.

Rails has the ability to render views polymorphically. A line like this:

```` erb
<%= render @question %>
````

Will ask `@question` which view should be rendered by calling `to_partial_path`.
As subclasses of `ActiveRecord::Base`, our `Question` subclasses will return a
path based on their class name. This means that the above line will attempt to
render `open_questions/_open_question.html.erb` for an open question, and so on.

We can use this to move the type-specific view code into a view for each type:

```rhtml
# app/views/open_questions/_open_question.html.erb
<%= submission_fields.text_field :text %>
```

You can see the full change in commit 8243493.

### Multiple Polymorphic Views

Our application also has different fields on the question form depending on the
question type. Currently, that also performs type-checking:

```rhtml
# app/views/questions/new.html.erb
<% if @question.type == 'MultipleChoiceQuestion' -%>
  <%= form.fields_for(:options, @question.options_for_form) do |option_fields| -%>
    <%= option_fields.input :text, label: 'Option' %>
  <% end -%>
<% end -%>

<% if @question.type == 'ScaleQuestion' -%>
  <%= form.input :minimum %>
  <%= form.input :maximum %>
<% end -%>
```

We already used views like `open_questions/_open_question.html.erb` for showing
a question, so we can't just put the edit code there. Rails doesn't support
prefixes or suffixes in `render`, but we can do it ourselves easily enough:

```rhtml
# app/views/questions/new.html.erb
<%= render "#{@question.to_partial_path}_form", question: @question, form: form %>
```

This will render `app/views/open_questions/_open_question_form.html.erb` for an
open question, and so on.

### Drawbacks

It's worth noting that, although this refactoring improved our particular
example, replacing conditionals with polymorphism is not without drawbacks.

Using polymorphism like this makes it easier to add new types, because adding a
new type means you just need to add a new class and implement the required
methods. Adding a new type won't require changes to any existing classes, and
it's easy to understand what the types are, because each type is encapsulated
within a class.

However, this change makes it harder to add new behaviors. Adding a new behavior
will mean finding every type and adding a new method. Understanding the behavior
becomes more difficult, because the implementations are spread out among the
types. Object-oriented languages lean towards polymorphic implementations, but
if you find yourself adding behaviors much more often than adding types, you
should look into using [observers](#introduce-observer) or
[visitors](#introduce-visitor) instead.

Also, using STI has specific disadvantages. See the [chapter on
STI](#single-table-inheritance-sti) for details.

### Next Steps

* Check the new classes for [Duplicated Code](#duplicated-code) that can be
  pulled up into the superclass.
* Pay attention to changes that affect the new types, watching out for [Shotgun
  Surgery](#shotgun-surgery) that can result from splitting up classes.

# Replace conditional with Null Object

Every Ruby developer is familiar with `nil`, and Ruby on Rails comes with a full
complement of tools to handle it: `nil?`, `present?`, `try`, and more. However,
it's easy to let these tools hide duplication and leak concerns. If you find
yourself checking for `nil` all over your codebase, try replacing some of the
`nil` values with null objects.

### Uses

* Removes [Shotgun Surgery](#shotgun-surgery) when an existing method begins
  returning `nil`.
* Removes [Duplicated Code](#duplicated-code) related to checking for `nil`.
* Removes clutter, improving readability of code that consumes `nil`.

### Example

```ruby
# app/models/question.rb
def most_recent_answer_text
  answers.most_recent.try(:text) || Answer::MISSING_TEXT
end
```

The `most_recent_answer_text` method asks its `answers` association for
`most_recent` answer. It only wants the `text` from that answer, but it must
first check to make sure that an answer actually exists to get `text` from. It
needs to perform this check because `most_recent` might return `nil`:

```ruby
# app/models/answer.rb
def self.most_recent
  order(:created_at).last
end
```

This call clutters up the method, and returning `nil` is contagious: any method
that calls `most_recent` must also check for `nil`. The concept of a missing
answer is likely to come up more than once, as in this example:

```ruby
# app/models/user.rb
def answer_text_for(question)
  question.answers.for_user(self).try(:text) || Answer::MISSING_TEXT
end
```

Again, `most_recent_answer_text` might return `nil`:

```ruby
# app/models/answer.rb
def self.for_user(user)
  joins(:completion).where(completions: { user_id: user.id }).last
end
```

The `User#answer_text_for` method duplicates the check for a missing answer, and
worse, it's repeating the logic of what happens when you need text without an
answer.

We can remove these checks entirely from `Question` and `User` by introducing a
Null Object:

```ruby
# app/models/question.rb
def most_recent_answer_text
  answers.most_recent.text
end
```

```ruby
# app/models/user.rb
def answer_text_for(question)
  question.answers.for_user(self).text
end
```

\clearpage

We're now just assuming that `Answer` class methods will return something
answer-like; specifically, we expect an object that returns useful `text`. We
can refactor `Answer` to handle the `nil` check:

```ruby
# app/models/answer.rb
class Answer < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :completion
  belongs_to :question

  validates :text, presence: true

  def self.for_user(user)
    joins(:completion).where(completions: { user_id: user.id }).last ||
      NullAnswer.new
  end

  def self.most_recent
    order(:created_at).last || NullAnswer.new
  end
end
```

Note that `for_user` and `most_recent` return a `NullAnswer` if no answer can be
found, so these methods will never return `nil`. The implementation for
`NullAnswer` is simple:

```ruby
# app/models/null_answer.rb
class NullAnswer
  def text
    'No response'
  end
end
```

\clearpage

We can take things just a little further and remove a bit of duplication with a
quick [Extract Method](#extract-method):

```ruby
# app/models/answer.rb
class Answer < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :completion
  belongs_to :question

  validates :text, presence: true

  def self.for_user(user)
    joins(:completion).where(completions: { user_id: user.id }).last_or_null
  end

  def self.most_recent
    order(:created_at).last_or_null
  end

  private

  def self.last_or_null
    last || NullAnswer.new
  end
end
```

Now we can easily create `Answer` class methods that return a usable answer, no
matter what.

### Drawbacks

Introducing a null object can remove duplication and clutter, but it can also
cause pain and confusion:

* As a developer reading a method like `Question#most_recent_answer_text`, you
  may be confused to find that `most_recent_answer` returned an instance of
  `NullAnswer` and not `Answer`.
* It's possible some methods will need to distinguish between `NullAnswer`s and
  real `Answer`s. This is common in views, when special markup is required to
  denote missing values. In this case, you'll need to add explicit `present?`
  checks and define `present?` to return `false` on your null object.
* `NullAnswer` may eventually need to reimplement large part of the `Answer`
  API, leading to potential [Duplicated Code](#duplicated-code) and [Shotgun
  Surgery](#shotgun-surgery), which is largely what we hoped to solve in the
  first place.

Don't introduce a null object until you find yourself swatting enough `nil`
values to grow annoyed. And make sure the removal of the `nil`-handling logic
outweighs the drawbacks above.

### Next Steps

* Look for other `nil` checks of the return values of refactored methods.
* Make sure your Null Object class implements the required methods from the
  original class.
* Make sure no [Duplicated Code](#duplicated-code) exists between the Null
  Object class and the original.

## truthiness, try, and other tricks

All checks for `nil` are a condition, but Ruby provides many ways to check for
`nil` without using an explicit `if`. Watch out for `nil` conditional checks
disguised behind other syntax. The following are all roughly equivalent:

```` ruby
# Explicit if with nil?
if user.nil?
  nil
else
  user.name
end

# Implicit nil check through truthy conditional
if user
  user.name
end

# Relies on nil being falsey
user && user.name

# Call to try
user.try(:name)
````


# Extract method

The simplest refactoring to perform is Extract Method. To extract a method:

* Pick a name for the new method.
* Move extracted code into the new method.
* Call the new method from the point of extraction.

### Uses

* Removes [Long Methods](#long-method).
* Sets the stage for moving behavior via [Move Method](#move-method).
* Resolves obscurity by introducing intention-revealing names.
* Allows removal of [Duplicated Code](#duplicated-code) by moving the common
  code into the extracted method.
* Reveals complexity.

\clearpage

Let's take a look at an example [Long Method](#long-method) and improve it by
extracting smaller methods:

```` ruby
def create
  @survey = Survey.find(params[:survey_id])
  @submittable_type = params[:submittable_type_id]
  question_params = params.
    require(:question).
    permit(:submittable_type, :title, :options_attributes, :minimum, :maximum)
  @question = @survey.questions.new(question_params)
  @question.submittable_type = @submittable_type

  if @question.save
    redirect_to @survey
  else
    render :new
  end
end
````

This method performs a number of tasks:

* It finds the survey that the question should belong to.
* It figures out what type of question we're creating (the `submittable_type`).
* It builds parameters for the new question by applying a white list to the HTTP
  parameters.
* It builds a question from the given survey, parameters, and submittable type.
* It attempts to save the question.
* It redirects back to the survey for a valid question.
* It re-renders the form for an invalid question.

\clearpage

Any of these tasks can be extracted to a method. Let's start by extracting the
task of building the question.

```` ruby
def create
  @survey = Survey.find(params[:survey_id])
  @submittable_type = params[:submittable_type_id]
  build_question

  if @question.save
    redirect_to @survey
  else
    render :new
  end
end

private

def build_question
  question_params = params.
    require(:question).
    permit(:submittable_type, :title, :options_attributes, :minimum, :maximum)
  @question = @survey.questions.new(question_params)
  @question.submittable_type = @submittable_type
end
````

The `create` method is already much more readable. The new `build_question`
method is noisy, though, with the wrong details at the beginning. The task of
pulling out question parameters is clouding up the task of building the
question. Let's extract another method.

## Replace temp with query

One simple way to extract methods is by replacing local variables. Let's pull
`question_params` into its own method:

```` ruby
def build_question
  @question = @survey.questions.new(question_params)
  @question.submittable_type = @submittable_type
end

def question_params
  params.
    require(:question).
    permit(:submittable_type, :title, :options_attributes, :minimum, :maximum)
end
````

### Next Steps

* Check the original method and the extracted method to make sure neither is a
  [Long Method](#long-method).
* Check the original method and the extracted method to make sure that they both
  relate to the same core concern. If the methods aren't highly related, the
  class will suffer from [Divergent Change](#divergent-change).
* Check newly extracted methods for [Feature Envy](#feature-envy). If you find
  some, you may wish to employ [Move Method](#move-method) to provide the new
  method with a better home.
* Check the affected class to make sure it's not a [Large Class](#large-class).
  Extracting methods reveals complexity, making it clearer when a class is doing
  too much.

# Extract Class

STUB

# Extract Value Object

STUB

# Extract Decorator

STUB

# Extract Partial

Extracting a partial is a technique used for removing complex or duplicated view 
code from your application. This is the equivalent of using [Long Method](#long-method) and
[Extract Method](#extract-method) in your views and templates.

### Uses

* Remove [Duplicated Code](#duplicated-code) from views.
* Remove [Shotgun Surgery](#shotgun-surgery) by forcing changes to happen in one place.
* Remove [Divergent Change](#divergent-change) by removing a reason for the view to change.
* Group common code.
* Reduce view size and complexity.

### Steps

* Create a new file for partial prefixed with an underscore (_filename.html.erb).
* Move common code into newly created file.
* Render the partial from the source file.

\clearpage

### Example

Let's revisit the view code for _adding_ and _editing_ questions.

Note: There are a few small differences in the files (the url endpoint, and the 
label on the submit button).

```rhtml
# app/views/questions/new.html.erb
<h1>Add Question</h1>

<%= simple_form_for @question, as: :question, url: survey_questions_path(@survey) do |form| -%>
  <%= form.hidden_field :type %>
  <%= form.input :title %>
  <%= render "#{@question.to_partial_path}_form", question: @question, form: form %>
  <%= form.submit 'Create Question' %>
<% end -%>
```

```rhtml
# app/views/questions/edit.html.erb
<h1>Edit Question</h1>

<%= simple_form_for @question, as: :question, url: question_path do |form| -%>
  <%= form.hidden_field :type %>
  <%= form.input :title %>
  <%= render "#{@question.to_partial_path}_form", question: @question, form: form %>
  <%= form.submit 'Update Question' %>
<% end -%>
```

First extract the common code into a partial, remove any instance variables, and 
use `question` and `url` as a local variables.

```rhtml
# app/views/questions/_form.html.erb
<%= simple_form_for question, as: :question, url: url do |form| -%>
  <%= form.hidden_field :type %>
  <%= form.input :title %>
  <%= render "#{question.to_partial_path}_form", question: question, form: form %>
  <%= form.submit %>
<% end -%>
```

Move the submit button text into the locales file.

```ruby
# config/locales/en.yml
en:
  helpers:
    submit:
      question:
        create: 'Create Question'
        update: 'Update Question'
```

Then render the partial from each of the views, passing in the values for
`question` and `url`.

```rhtml
# app/views/questions/new.html.erb
<h1>Add Question</h1>

<%= render 'form', question: @question, url: survey_questions_path(@survey) %>
```

```rhtml
# app/views/questions/edit.html.erb
<h1>Edit Question</h1>

<%= render 'form', question: @question, url: question_path %>
```

### Next Steps

* Check for other occurances of the duplicated view code in your application and 
replace them with the newly extracted partial.

# Extract Service Object

STUB

# Extract Validator

A form of [Extract Class](#extract-class) used to remove complex validation details
from `ActiveRecord` models. This technique also prevents duplication of validation
code across several files.

### Uses

* Keep validation implementation details out of models.
* Encapsulate validation details into a single file.
* Remove duplication among classes performing the same validation logic.

### Example

The `Invitation` class has validation details in-line. It checks that the
`repient_email` matches the formatting of the regular expression `EMAIL_REGEX`.

```ruby
# app/models/invitation.rb
class Invitation < ActiveRecord::Base
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :recipient_email, presence: true, format: EMAIL_REGEX
end
```

We extract the validation details into a new class `EmailValidator`, and place the
new class into the `app/validators` directory.

\clearpage

```ruby
# app/validators/email_validator.rb
class EmailValidator < ActiveModel::EachValidator
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  def validate_each(record, attribute, value)
    unless value.match EMAIL_REGEX
      record.errors.add(attribute, "#{value} is not a valid email")
    end
  end
end
```

Once the validator has been extracted. Rails has a convention for using the new
validation class. `EmailValidator` is used by setting `email: true` in the validation
arguments.

```ruby
# app/models/invitation.rb
class Invitation < ActiveRecord::Base
  validates :recipient_email, presence: true, email: true
end
```

The convention is to use the validation class name (in lowercase, and removing
`Validator` from the name). For exmaple, if we were validating an attribute with
`ZipCodeValidator` we'd set `zip_code: true` as an argument to the validation call.

When validating an array of data as we do in `SurveyInviter`, we use
the `EnumerableValidator` to loop over the contents of an array.

```ruby
# app/models/survey_inviter.rb
validates_with EnumerableValidator,
  attributes: [:recipients],
  unless: 'recipients.nil?',
  validator: EmailValidator
```

The `EmailValidator` is passed in as an argument, and each element in the array
is validated against it.

\clearpage

```ruby
# app/validators/enumerable_validator.rb
class EnumerableValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, enumerable)
    enumerable.each do |value|
      validator.validate_each(record, attribute, value)
    end
  end

  private

  def validator
    options[:validator].new(validator_options)
  end

  def validator_options
    options.except(:validator).merge(attributes: attributes)
  end
end
```

### Next Steps

* Verify the extracted validator does not have any [Long Methods](#long-methods).
* Check for other models that could use the validator.

# Introduce Explaining Variable

This refactoring allows you to break up a complex, hard-to-read statement by
placing part of it in a local variable. The only difficult part is finding a
good name for the variable.

### Uses

* Improves legibility of code.
* Makes it easier to [Extract Methods](#extract-method) by breaking up long
  statements.
* Removes the need for extra [Comments](#comments).

### Example

This line of code was hard enough to understand that a comment was added:

```ruby
# app/models/open_question.rb
def summary
  # Text for each answer in order as a comma-separated string
  answers.order(:created_at).pluck(:text).join(', ')
end
```

Adding an explaining variable makes the line easy to understand without a
comment:

```ruby
# app/models/open_question.rb
def summary
  text_from_ordered_answers = answers.order(:created_at).pluck(:text)
  text_from_ordered_answers.join(', ')
end
```

You can follow up by using [Replace Temp with Query](#replace-temp-with-query).

``` ruby
def summary
  text_from_ordered_answers.join(', ')
end

private

def text_from_ordered_answers
  answers.order(:created_at).pluck(:text)
end
```

This increases the overall size of the class and moves
`text_from_ordered_answers` further away from `summary`, so you'll want to be
careful when doing this. The most obvious reason to extract a method is to reuse
the value of the variable.

However, there's another potential benefit: it changes the way developers read
the code.  Developers instinctively read code top-down. Expressions based on
variables place the details first, which means that a developer will start with
the details:

``` ruby
text_from_ordered_answers = answers.order(:created_at).pluck(:text)
```

And work their way down to the overall goal of a method:

``` ruby
text_from_ordered_answers.join(', ')
```

Note that you naturally focus first on the code necessary to find the array of
texts, and then progress to see what happens to those texts.

Once a method is extracted, the high level concept comes first:

``` ruby
def summary
  text_from_ordered_answers.join(', ')
end
```

And then you progress to the details:

``` ruby
def text_from_ordered_answers
  answers.order(:created_at).pluck(:text)
end
```

You can use this technique of extracting methods to make sure that developers
focus on what's important first, and only dive into the implementation details
when necessary.

### Next Steps

* [Replace Temp with Query](#replace-temp-with-query) if you want to reuse the
  expression or revert the naturally order in which a developer reads the
  method.
* Check the affected expression to make sure that it's easy to read. If it's
  still too dense, try extracting more variables or methods.
* Check the extracted variable or method for [Feature Envy](#feature-envy).

# Introduce Observer

STUB

# Introduce Form Object

A specialized type of [Extract Class](#extract-class) used to remove business
logic from controllers when processing data outside of an ActiveRecord model.

### Uses

* Keep business logic out of Controllers and Views.
* Add validation support to plain old Ruby objects.
* Display form validation errors using Rails conventions.
* Set the stage for [Extract Validator](#extract-validator).

### Example

The `create` action of our `InvitationsController` relies on user submitted data for
`message` and `recipients` (a comma delimited list of email addresses).

It performs a number of tasks:

* Finds the current survey.
* Validates the `message` is present.
* Validates each of the `recipients` are email addresses.
* Creates an invitation for each of the recipients.
* Sends an email to each of the recipients.
* Sets view data for validation failures.

\clearpage

```ruby
# app/controllers/invitations_controller.rb
class InvitationsController < ApplicationController
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/

  def new
    @survey = Survey.find(params[:survey_id])
  end

  def create
    @survey = Survey.find(params[:survey_id])
    if valid_recipients? && valid_message?
      recipient_list.each do |email|
        invitation = Invitation.create(
          survey: @survey,
          sender: current_user,
          recipient_email: email,
          status: 'pending'
        )
        Mailer.invitation_notification(invitation, message)
      end
      redirect_to survey_path(@survey), notice: 'Invitation successfully sent'
    else
      @recipients = recipients
      @message = message
      render 'new'
    end
  end

  private

  def valid_recipients?
    invalid_recipients.empty?
  end

  def valid_message?
    message.present?
  end

  def invalid_recipients
    @invalid_recipients ||= recipient_list.map do |item|
      unless item.match(EMAIL_REGEX)
        item
      end
    end.compact
  end

  def recipient_list
    @recipient_list ||= recipients.gsub(/\s+/, '').split(/[\n,;]+/)
  end

  def recipients
    params[:invitation][:recipients]
  end

  def message
    params[:invitation][:message]
  end
end
```

By introducing a form object we can move the concerns of data validation, invitation
creation, and notifications to the new model `SurveyInviter`.

Including [ActiveModel::Model](https://github.com/rails/rails/blob/master/activemodel/lib/active_model/model.rb)
allows us to leverage the familiar
[Active Record Validation](http://guides.rubyonrails.org/active_record_validations_callbacks.html)
syntax.

As we introduce the form object we'll also extract an enumerable class `RecipientList`
and validators `EnumerableValidator` and `EmailValidator`. They will be covered 
in the chapters [Extract Class](#extract-class) and [Extract Validator](#extract-validator).

```ruby
# app/models/survey_inviter.rb
class SurveyInviter
  include ActiveModel::Model
  attr_accessor :recipients, :message, :sender, :survey

  validates :message, presence: true
  validates :recipients, length: { minimum: 1 }
  validates :sender, presence: true
  validates :survey, presence: true

  validates_with EnumerableValidator,
    attributes: [:recipients],
    unless: 'recipients.nil?',
    validator: EmailValidator

  def recipients=(recipients)
    @recipients = RecipientList.new(recipients)
  end

  def invite
    if valid?
      deliver_invitations
    end
  end

  private

  def create_invitations
    recipients.map do |recipient_email|
      Invitation.create!(
        survey: survey,
        sender: sender,
        recipient_email: recipient_email,
        status: 'pending'
      )
    end
  end

  def deliver_invitations
    create_invitations.each do |invitation|
      Mailer.invitation_notification(invitation, message).deliver
    end
  end
end
```

Moving business logic into the new form object dramatically reduces the size and
complexity of the `InvitationsController`. The controller is now focused on the
interaction between the user and the models.

```ruby
# app/controllers/invitations_controller.rb
class InvitationsController < ApplicationController
  def new
    @survey = Survey.find(params[:survey_id])
    @survey_inviter = SurveyInviter.new
  end

  def create
    @survey = Survey.find(params[:survey_id])
    @survey_inviter = SurveyInviter.new(survey_inviter_params)

    if @survey_inviter.invite
      redirect_to survey_path(@survey), notice: 'Invitation successfully sent'
    else
      render 'new'
    end
  end

  private

  def survey_inviter_params
    params.require(:survey_inviter).permit(
      :message,
      :recipients
    ).merge(
      sender: current_user,
      survey: @survey
    )
  end
end
```

### Next Steps

* Check that the controller no longer has [Long Methods](#long-method).
* Verify the new form object is not a [Large Class](#large-class).
* Check for places to re-use any new validators if [Extract Validator](#extract-validator)
was used during the refactoring.

# Introduce Parameter Object

A technique to reduce the number of input parameters to a method.

To introduce a parameter object:

* Pick a name for the object that represents the grouped parameters.
* Replace method's grouped parameters with the object.

### Uses

* Remove [Long Parameter Lists](#long-parameter-list).
* Group parameters that naturally fit together.
* Encapsulate behavior between related parameters.

Let's take a look at the example from [Long Parameter List](#long-parameter-list) and 
improve it by grouping the related parameters into an object:

```ruby
# app/mailers/mailer.rb
class Mailer < ActionMailer::Base
  default from: "from@example.com"

  def completion_notification(first_name, last_name, email)
    @first_name = first_name
    @last_name = last_name

    mail(
      to: email,
      subject: 'Thank you for completing the survey'
    )
  end
end
```

```rhtml
# app/views/mailer/completion_notification.html.erb
<%= @first_name %> <%= @last_name %>
```

By introducing the new parameter object `recipient` we can naturally group the 
attributes `first_name`, `last_name`, and `email` together.

```ruby
# app/mailers/mailer.rb
class Mailer < ActionMailer::Base
  default from: "from@example.com"

  def completion_notification(recipient)
    @recipient = recipient

    mail(
      to: recipient.email,
      subject: 'Thank you for completing the survey'
    )
  end
end
```

This also gives us the opportunity to create a new method `full_name` on the `recipient`
object to encapsulate behavior between the `first_name` and `last_name`.

```rhtml
# app/views/mailer/completion_notification.html.erb
<%= @recipient.full_name %>
```

### Next Steps

* Check to see if the same Data Clump exists elsewhere in the application, and
 reuse the Parameter Object to group them together.
* Verify the methods using the Parameter Object don't have [Feature Envy](#feature-envy).

# Use class as Factory

STUB

# Move method

Moving methods is generally easy. Moving a method allows you to place a method
closer to the state it uses by moving it to the class which owns the related
state.

To move a method:

* Move the entire method definition and body into the new class.
* Change any parameters which are part of the state of the new class to simply
  reference the instance variables or methods.
* Introduce any necessary parameters because of state which belongs to the old
  class.
* Rename the method if the new name no longer makes sense in the new context
  (for example, rename `invite_user` to `invite` once the method is moved to the
  `User` class).
* Replace calls to the old method to calls to the new method. This may require
  introducing delegation or building an instance of the new class.

### Uses

* Remove [Feature Envy](#feature-envy) by moving a method to the class where the
  envied methods live.
* Make private, parameterized methods easier to reuse by moving them to public,
  unparameterized methods.
* Improve readability by keeping methods close to the other methods they use.

Let's take a look at an example method that suffers from [Feature
Envy](#feature-envy) and use [Extract Method](#extract-method) and Move Method
to improve it:

```ruby
# app/models/completion.rb
def score
  answers.inject(0) do |result, answer|
    question = answer.question
    result + question.score(answer.text)
  end
end
```

The block in this method suffers from [Feature Envy](#feature-envy): it
references `answer` more than it references methods or instance variables from
its own class. We can't move the entire method; we only want to move the block,
so let's first extract a method:

```ruby
# app/models/completion.rb
def score
  answers.inject(0) do |result, answer|
    result + score_for_answer(answer)
  end
end
```

```ruby
# app/models/completion.rb
def score_for_answer(answer)
  question = answer.question
  question.score(answer.text)
end
```

The `score` method no longer suffers from [Feature Envy](#feature-envy), and the
new `score_for_answer` method is easy to move, because it only references its
own state. See the chapter on [Extract Method](#extract-method) for details on
the mechanics and properties of this refactoring.

Now that the [Feature Envy](#feature-envy) is isolated, let's resolve it by
moving the method:

```ruby
# app/models/completion.rb
def score
  answers.inject(0) do |result, answer|
    result + answer.score
  end
end
```

```ruby
# app/models/answer.rb
def score
  question.score(text)
end
```

The newly extracted and moved `Question#score` method no longer suffers from
[Feature Envy](#feature-envy). It's easier to reuse, because the logic is freed
from the internal block in `Completion#score`. It's also available to other
classes, because it's no longer a private method. Both methods are also easier
to follow, because the methods they invoke are close to the methods they depend
on.

### Dangerous: move and extract at the same time

It's tempting to do everything as one change: create a new method in `Answer`,
move the code over from `Completion`, and change `Completion#score` to call the
new method. Although this frequently works without a hitch, with practice, you
can perform the two, smaller refactorings just as quickly as the single, larger
refactoring. By breaking the refactoring into two steps, you reduce the duration
of "down time" for your code; that is, you reduce the amount of time during
which something is broken. Improving code in tiny steps makes it easier to debug
when something goes wrong and prevents you from writing more code than you need
to. Because the code still works after each step, you can simply stop whenever
you're happy with the results.

### Next Steps

* Make sure the new method doesn't suffer from [Feature Envy](#feature-envy)
  because of state it used from its original class. If it does, try splitting
  the method up and moving part of it back.
* Check the class of the new method to make sure it's not a [Large
  Class](#large-class).

# Inline class

STUB

# Inject dependencies

STUB

# Replace Subclasses with Strategies

Subclasses are a common method of achieving reuse and polymorphism, but
inheritance has its drawbacks. See [Composition Over
Inheritance](#composition-over-inheritance) for reasons why you might decide to
avoid an inheritance-based model.

During this refactoring, we will replace the subclasses with individual strategy
classes. Each strategy class will implement a common interface. The original
base class is promoted from an abstract class to the composition root, which
composes the strategy classes.

This allows for smaller interfaces, stricter separation of concerns, and easier
testing. It also makes it possible to swap out part of the structure, which
would require converting to a new type in an inheritance-based model.

When applying this refactoring to an `ActiveRecord::Base` subclass,
[STI](#single-table-inheritance-sti) is removed, often in favor of a polymorphic
association.

### Uses

* Eliminate [Large Classes](#large-class) by splitting up a bloated base class.
* Convert [STI](#single-table-inheritance-sti) to a composition-based scheme.
* Make it easier to change part of the structure by separating the parts that
  change from the parts that don't.

\clearpage

### Example

The `switch_to` method on `Question` changes the question to a new type. Any
necessary attributes for the new subclass are provided to the `attributes`
method.

```ruby
# app/models/question.rb
def switch_to(type, new_attributes)
  attributes = self.attributes.merge(new_attributes)
  new_question = type.constantize.new(attributes.except('id', 'type'))
  new_question.id = id

  begin
    Question.transaction do
      destroy
      new_question.save!
    end
  rescue ActiveRecord::RecordInvalid
  end

  new_question
end
```

Using inheritance makes changing question types awkward for a number of reasons:

* You can't actually change the class of an instance in Ruby, so you need to
  return the instance of the new class.
* The implementation requires deleting and creating records, but part of the
  transaction (`destroy`) must execute before we can validate the new instance.
  This results in control flow using exceptions.
* It's hard to understand why this method is implemented the way it is, so other
  developers fixing bugs or refactoring in the future will have a hard time
  navigating it.

We can make this operation easier by using composition instead of inheritance.

This is a difficult change that becomes larger as more behavior is added to the
inheritance tree. We can make the change easier by breaking it down into smaller
steps, ensuring that the application is in a fully-functional state with passing
tests after each change. This allows us to debug is smaller sessions and create
safe checkpoint commits that we can retreat to if something goes wrong.

#### Use Extract Class to Extract Non-Railsy Methods From Subclasses

The easiest way to start is by extracting a strategy class from each subclass
and moving (and delegating) as many methods as you can to the new class. There's
some class-level wizardry that goes on in some Rails features like associations,
so let's start by moving simple, instance-level methods that aren't part of the
framework.

Let's start with a simple subclass: `OpenQuestion.`

Here's the `OpenQuestion` class using an STI model:

```ruby
# app/models/open_question.rb
class OpenQuestion < Question
  def score(text)
    0
  end

  def breakdown
    text_from_ordered_answers = answers.order(:created_at).pluck(:text)
    text_from_ordered_answers.join(', ')
  end
end
```

We can start by creating a new strategy class:

``` ruby
class OpenSubmittable
end
```

When switching from inheritance to composition, you need to add a new word to
the application's vocabulary. Before, we had questions, and different subclasses
of questions handled the variations in behavior and data. Now, we're switching
to a model where there's only one question class, and question will compose
_something_ that will handle the variations. In our case, that _something_ is a
"submittable." In our new model, each question is just a question, and every
question composes a submittable that decides how the question can be submitted.
Thus, our first extracted class is called `OpenSubmittable,` extracted from
`OpenQuestion.`

Let's move our first method over to `OpenSubmittable`:

```ruby
# app/models/open_submittable.rb
class OpenSubmittable
  def score(text)
    0
  end
end
```

And change `OpenQuestion` to delegate to it:

```ruby
# app/models/open_question.rb
class OpenQuestion < Question
  def score(text)
    submittable.score(text)
  end

  def breakdown
    text_from_ordered_answers = answers.order(:created_at).pluck(:text)
    text_from_ordered_answers.join(', ')
  end

  def submittable
    OpenSubmittable.new
  end
end
```

Each question subclass implements the `score` method, so we repeat this process
for `MultipleChoiceQuestion` and `ScaleQuestion`. You can see the full change
for this step in the [example
app](https://github.com/thoughtbot/ruby-science/commit/7747366a12b3f6f21d0008063c5655faba8e4890).

At this point, we've introduced a [parallel inheritance
hierarchy](#parallel-inheritance-hierarchies). During a longer refactor, things
may get worse before they get better. This is one of several reasons that it's
always best to refactor on a branch, separately from any feature work. We'll
make sure that the parallel inheritance hierarchy is removed before merging.

#### Pull Up Delegate Method Into Base Class

After the first step, each subclass implements a `submittable` method to build
its parallel strategy class. The `score` score method in each subclass simply
delegates to its submittable. We can now pull the `score` method up into the
base `Question` class, completely removing this concern from the subclasses.

First, we add a delegator to `Question`:

```ruby
# app/models/question.rb
delegate :score, to: :submittable
```

Then, we simply remove the `score` method from each subclass.

You can see this change in full in the [example
app](https://github.com/thoughtbot/ruby-science/commit/9c2ddc65e7248bab1f010d8a2c74c8f994a8b26d).

#### Move Remaining Common API Into Strategies

We can now repeat the first two steps for every non-Railsy method that the
subclasses implement. In our case, this is just the `breakdown` method.

The most interesting part of this change is that the `breakdown` method requires
state from the subclasses, so the question is now provided to the submittable:

```ruby
# app/models/multiple_choice_question.rb
def submittable
  MultipleChoiceSubmittable.new(self)
end
```

```ruby
# app/models/multiple_choice_submittable.rb
def answers
  @question.answers
end

def options
  @question.options
end
```

You can view this change in the [example
app](https://github.com/thoughtbot/ruby-science/commit/db3658cd1c4601c07f49a7c666f57c00f5c22ffd).

#### Move Remaining Non-Railsy Public Methods Into Strategies

We can take a similar approach for the uncommon API; that is, public methods
that are only implemented in one subclass.

First, move the body of the method into the strategy:

```ruby
# app/models/scale_submittable.rb
def steps
  (@question.minimum..@question.maximum).to_a
end
```

Then, add a delegator. This time, the delegator can live directly on the
subclass, rather than the base class:

```ruby
# app/models/scale_question.rb
def steps
  submittable.steps
end
```

Repeat this step for the remaining public methods that aren't part of the Rails
framework. You can see the full change for this step in our [example app](https://github.com/thoughtbot/ruby-science/commit/2bce7f7b0812b417dc41af369d18b83e057419ac).

#### Remove Delegators From Subclasses

Our subclasses now contain only delegators, code to instantiate the submittable,
and framework code. Eventually, we want to completely delete these subclasses,
so let's start stripping them down.  The delegators are easiest to delete, so
let's take them on before the framework code.

First, find where the delegators are used:

```rhtml
# app/views/multiple_choice_questions/_multiple_choice_question_form.html.erb
<%= form.fields_for(:options, question.options_for_form) do |option_fields| -%>
  <%= option_fields.input :text, label: 'Option' %>
<% end -%>
```

And change the code to directly use the strategy instead:

```rhtml
# app/views/multiple_choice_questions/_multiple_choice_question_form.html.erb
<%= form.fields_for(:options, submittable.options_for_form) do |option_fields| -%>
  <%= option_fields.input :text, label: 'Option' %>
<% end -%>
```

You may need to pass the strategy in where the subclass was used before:

```rhtml
# app/views/questions/_form.html.erb
<%= render(
  "#{question.to_partial_path}_form",
  submittable: question.submittable,
  form: form
) %>
```

We can come back to these locations later and see if we need to pass in the
question at all.

After fixing the code that uses the delegator, remove the delegator from the
subclass. Repeat this process for each delegator until they've all been removed.

You can see how we do this in the [example app](https://github.com/thoughtbot/ruby-science/commit/c7a61dadfed53b9d93b578064d982f22d62f7b8d).

\clearpage

#### Instantiate Strategy Directly From Base Class

If you look carefully at the `submittable` method from each question subclass,
you'll notice that it simply instantiates a class based on its own class name
and passes itself to the `initialize` method:

```ruby
# app/models/open_question.rb
def submittable
  OpenSubmittable.new(self)
end
```

This is a pretty strong convention, so let's apply some [Convention Over
Configuration](#use-convention-over-configuration) and pull the method up into
the base class:

```ruby
# app/models/question.rb
def submittable
  submittable_class_name = type.sub('Question', 'Submittable')
  submittable_class_name.constantize.new(self)
end
```

We can then delete `submittable` from each of the subclasses.

At this point, the subclasses contain only Rails-specific code like associations
and validations.

You can see the full change in the [example app](https://github.com/thoughtbot/ruby-science/commit/75075985e6050e5c1008010855e75df14547890c).

#### A Fork In the Road

At this point, we're faced with a difficult decision. At a glance, it seems as
though only associations and validations live in our subclasses, and we could
easily move those to our strategy. However, there are two major issues.

First, you can't move the association to a strategy class without making that
strategy an `ActiveRecord::Base` subclass. Associations are deeply coupled with
`ActiveRecord::Base`, and they simply won't work in other situations.

Also, one of our submittable strategies has state specific to that strategy.
Scale questions have a minimum and maximum. These fields are only used by scale
questions, but they're on the questions table. We can't remove this pollution
without creating a table for scale questions.

There are two obvious ways to proceed:

* Continue without making the strategies `ActiveRecord::Base` subclasses. Keep
  the association for multiple choice questions and the minimum and maximum for
  scale questions on the `Question` class, and use that data from the strategy.
  This will result in [Divergent Change](#divergent-change) and probably a
  [Large Class](#large-class) on `Question`, as every change in the data
  required for new or existing strategies will require new behavior on
  `Question`.
* Convert the strategies to `ActiveRecord::Base` subclasses. Move the
  association and state specific to strategies to those classes. This involves
  creating a table for each strategy and adding a polymorphic association to
  `Question.` This will avoid polluting the `Question` class with future
  strategy changes, but is awkward right now, because the tables for multiple
  choice questions and open questions would contain no data except the primary
  key. These tables provide a placeholder for future strategy-specific data, but
  those strategies may never require any more data and until they do, the tables
  are a waste of queries and developer mental space.

In this example, I'm going to move forward with the second approach, because:

* It's easier with ActiveRecord. ActiveRecord will take care of instantiating
  the strategy in most situations if it's an association, and it has special
  behavior for associations using nested attribute forms.
* It's the easiest way to avoid [Divergent Change](#divergent-change) and [Large
  Classes](#large-class) in a Rails application. Both of these smells can cause
  problems that are hard to fix if you wait too long.

#### Convert Strategies to ActiveRecord subclasses

Continuing with our refactor, we'll change each of our strategy classes to
inherit from `ActiveRecord::Base`.

First, simply declare that the class is a child of `ActiveRecord::Base`:

```ruby
# app/models/open_submittable.rb
class OpenSubmittable < ActiveRecord::Base
```

Your tests will complain that the corresponding table doesn't exist, so create
it:

```ruby
# db/migrate/20130131205432_create_open_submittables.rb
class CreateOpenSubmittables < ActiveRecord::Migration
  def change
    create_table :open_submittables do |table|
      table.timestamps null: false
    end
  end
end
```

Our strategies currently accept the question as a parameter to `initialize` and
assign it as an instance variable. In an `ActiveRecord::Base` subclass, we don't
control `initialize`, so let's change `question` from an instance variable to an
association and pass a hash:

```ruby
# app/models/open_submittable.rb
class OpenSubmittable < ActiveRecord::Base
  has_one :question, as: :submittable

  def breakdown
    text_from_ordered_answers = answers.order(:created_at).pluck(:text)
    text_from_ordered_answers.join(', ')
  end

  def score(text)
    0
  end

  private

  def answers
    question.answers
  end
end
```

```ruby
# app/models/question.rb
def submittable
  submittable_class = type.sub('Question', 'Submittable').constantize
  submittable_class.new(question: self)
end
```

Our strategies are now ready to use Rails-specific functionality like
associations and validations.

View the full change on [GitHub](https://github.com/thoughtbot/ruby-science/commit/e4809cd43da76bf1e6b0933040bffd9cc3ea810c).

#### Introduce A Polymorphic Association

Now that our strategies are persistable using ActiveRecord, we can use them in a
polymorphic association. Let's add the association:

```ruby
# app/models/question.rb
belongs_to :submittable, polymorphic: true
```

And add the necessary columns:

```ruby
# db/migrate/20130131203344_add_submittable_type_and_id_to_questions.rb
class AddSubmittableTypeAndIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :submittable_id, :integer
    add_column :questions, :submittable_type, :string
  end
end
```

We're currently defining a `submittable` method that overrides the association.
Let's change that to a method that will build the association based on the STI
type:

```ruby
# app/models/question.rb
def build_submittable
  submittable_class = type.sub('Question', 'Submittable').constantize
  self.submittable = submittable_class.new(question: self)
end
```

Previously, the `submittable` method built the submittable on demand, but now
it's persisted in an association and built explicitly. Let's change our
controllers accordingly:

```ruby
# app/controllers/questions_controller.rb
def build_question
  @question = type.constantize.new(question_params)
  @question.build_submittable
  @question.survey = @survey
end
```

View the full change on [GitHub](https://github.com/thoughtbot/ruby-science/commit/7d6e294ef8d0e427f83710f74448768da80af2d4).

#### Pass Attributes to Strategies

We're persisting the strategy as an association, but the strategies currently
don't have any state. We need to change that, since scale submittables need a
minimum and maximum.

Let's change our `build_submittable` method to accept attributes:

```ruby
# app/models/question.rb
def build_submittable(attributes)
  submittable_class = type.sub('Question', 'Submittable').constantize
  self.submittable = submittable_class.new(attributes.merge(question: self))
end
```

We can quickly change the invocations to pass an empty hash, and we're back to
green.

Next, let's move the `minimum` and `maximum` fields over to the
`scale_submittables` table:

```ruby
# db/migrate/20130131211856_move_scale_question_state_to_scale_submittable.rb
add_column :scale_submittables, :minimum, :integer
add_column :scale_submittables, :maximum, :integer
```

Note that this migration is [rather
lengthy](https://github.com/thoughtbot/ruby-science/blob/41b49f49706135572a1b907f6a4c9747fb8446bb/example_app/db/migrate/20130131211856_move_scale_question_state_to_scale_submittable.rb),
because we also need to move over the minimum and maximum values for existing
questions. The SQL in our example app will work on most databases, but is
cumbersome. If you're using Postgresql, you can handle the `down` method easier
using an `UPDATE FROM` statement.

Next, we'll move validations for these attributes over from `ScaleQuestion`:

```ruby
# app/models/scale_submittable.rb
validates :maximum, presence: true
validates :minimum, presence: true
```

And change `ScaleSubmittable` methods to use those attributes directly, rather
than looking for them on `question`:

```ruby
# app/models/scale_submittable.rb
def steps
  (minimum..maximum).to_a
end
```

We can pass those attributes in our form by using `fields_for` and
`accepts_nested_attributes_for`:

```rhtml
# app/views/scale_questions/_scale_question_form.html.erb
<%= form.fields_for :submittable do |submittable_fields| -%>
  <%= submittable_fields.input :minimum %>
  <%= submittable_fields.input :maximum %>
<% end -%>
```

```ruby
# app/models/question.rb
accepts_nested_attributes_for :submittable
```

In order to make sure the `Question` fails when its submittable is invalid, we
can cascade the validation:

```ruby
# app/models/question.rb
validates :submittable, associated: true
```

Now we just need our controllers to pass the appropriate submittable params:

```ruby
# app/controllers/questions_controller.rb
def build_question
  @question = type.constantize.new(question_params)
  @question.build_submittable(submittable_params)
  @question.survey = @survey
end
```

```ruby
# app/controllers/questions_controller.rb
def question_params
  params.
    require(:question).
    permit(:title, :options_attributes)
end

def submittable_params
  if submittable_attributes = params[:question][:submittable_attributes]
    submittable_attributes.permit(:minimum, :maximum)
  else
    {}
  end
end
```

All behavior and state is now moved from `ScaleQuestion` to `ScaleSubmittable`,
and the `ScaleQuestion` class is completely empty.

You can view the full change in the [example app](https://github.com/thoughtbot/ruby-science/commit/41b49f49706135572a1b907f6a4c9747fb8446bb).

#### Move Remaining Railsy Behavior Out of Subclasses

We can now repeat this process for remaining Rails-specific behavior. In our
case, this is the logic to handle the `options` association for multiple choice
questions.

We can move the association and behavior over to the strategy class:

```ruby
# app/models/multiple_choice_submittable.rb
has_many :options, foreign_key: :question_id
has_one :question, as: :submittable

accepts_nested_attributes_for :options, reject_if: :all_blank
```

Again, we remove the `options` method which delegated to `question` and rely on
`options` being directly available. Then we update the form to use `fields_for`
and move the allowed attributes in the controller from `question` to
`submittable`.

At this point, every question subclass is completely empty.

You can view the full change in the [example app](https://github.com/thoughtbot/ruby-science/commit/662e50874a377f8050ea2ad1326a7a4e47125f86).

#### Backfill Strategies For Existing Records

Now that everything is moved over to the strategies, we need to make sure that
submittables exist for every existing question. We can write a quick backfill
migration to take care of that:

```ruby
# db/migrate/20130207164259_backfill_submittables.rb
class BackfillSubmittables < ActiveRecord::Migration
  def up
    backfill 'open'
    backfill 'multiple_choice'
  end

  def down
    connection.delete 'DELETE FROM open_submittables'
    connection.delete 'DELETE FROM multiple_choice_submittables'
  end

  private

  def backfill(type)
    say_with_time "Backfilling #{type}  submittables" do
      connection.update(<<-SQL)
        UPDATE questions
        SET
          submittable_id = id,
          submittable_type = '#{type.camelize}Submittable'
        WHERE type = '#{type.camelize}Question'
      SQL
      connection.insert(<<-SQL)
        INSERT INTO #{type}_submittables
          (id, created_at, updated_at)
        SELECT
          id, created_at, updated_at
        FROM questions
        WHERE questions.type = '#{type.camelize}Question'
      SQL
    end
  end
end
```

We don't port over scale questions, because we took care of them in a [previous
migration](https://github.com/thoughtbot/ruby-science/blob/41b49f49706135572a1b907f6a4c9747fb8446bb/example_app/db/migrate/20130131211856_move_scale_question_state_to_scale_submittable.rb).

#### Pass the Type When Instantiating the Strategy

At this point, the subclasses are just dead weight. However, we can't delete
them just yet. We're relying on the `type` column to decide what type of
strategy to build, and Rails will complain if we have a `type` column without
corresponding subclasses.

Let's remove our dependence on that `type` column. Accept a `type` when building
the submittable:

```ruby
# app/models/question.rb
def build_submittable(type, attributes)
  submittable_class = type.sub('Question', 'Submittable').constantize
  self.submittable = submittable_class.new(attributes.merge(question: self))
end
```

And pass it in when calling:

```ruby
# app/controllers/questions_controller.rb
@question.build_submittable(type, submittable_params)
```

[Full Change](https://github.com/thoughtbot/ruby-science/commit/a3b36db9f0ec2d66e0ec1e7732662732380e6fc8)

#### Always Instantiate the Base Class

Now we can remove our dependence on the STI subclasses by always building an
instance of `Question`.

In our controller, we change this line:

```ruby
# app/controllers/questions_controller.rb
@question = type.constantize.new(question_params)
```

To this:

```ruby
# app/controllers/questions_controller.rb
@question = Question.new(question_params)
```

We're still relying on `type` as a parameter in forms and links to decide what
type of submittable to build. Let's change that to `submittable_type`, which is
already available because of our polymorphic association:

```ruby
# app/controllers/questions_controller.rb
params[:question][:submittable_type]
```

```rhtml
# app/views/questions/_form.html.erb
<%= form.hidden_field :submittable_type %>
```

We'll also need to revisit views that rely on [polymorphic
partials](#polymorphic-partials) based on the question type and change them to
rely on the submittable type instead:

```rhtml
# app/views/surveys/show.html.erb
<%= render(
  question.submittable,
  submission_fields: submission_fields
) %>
```

Now we can finally remove our `type` column entirely:

```ruby
# db/migrate/20130207214017_remove_questions_type.rb
class RemoveQuestionsType < ActiveRecord::Migration
  def up
    remove_column :questions, :type
  end

  def down
    add_column :questions, :type, :string

    connection.update(<<-SQL)
      UPDATE questions
      SET type = REPLACE(submittable_type, 'Submittable', 'Question')
    SQL

    change_column_null :questions, :type, true
  end
end
```

[Full Change](https://github.com/thoughtbot/ruby-science/commit/19ee3047f57807f342cb7cefd1b6589aff15ea6b)

#### Remove Subclasses

Now for a quick, glorious change: those `Question` subclasses are entirely empty
and unused, so we can [delete
them](https://github.com/thoughtbot/ruby-science/commit/c6f0e545ae9b3da017b3318f2882cb40954213ee).

This also removes the [parallel inheritance
hierarchy](#parallel-inheritance-hierarchies) that we introduced earlier.

At this point, the code is as good as we found it.

#### Simplify Type Switching

If you were previously switching from one subclass to another as we did to
change question types, you can now greatly simplify that code.

Instead of deleting the old question and cloning it with a merged set of old
generic attributes and new specific attributes, you can simply swap in a new
strategy for the old one.

```ruby
# app/models/question.rb
def switch_to(type, attributes)
  old_submittable = submittable
  build_submittable type, attributes

  transaction do
    if save
      old_submittable.destroy
    end
  end
end
```

Our new `switch_to` method is greatly improved:

* This method no longer needs to return anything, because there's no need to
  clone. This is nice because `switch_to` is now simply a command method (it
  does something) rather than a mixed command and query method (it does
  something and returns something).
* The method no longer needs to delete the old question, and the new submittable
  is valid before we delete the old one. This means we no longer need to use
  exceptions for control flow.
* It's simpler and its code is obvious, so other developers will have no trouble
  refactoring or fixing bugs.

You can see the full change that resulted in our new method in the [example
app](https://github.com/thoughtbot/ruby-science/commit/5f4a14ff6c43bf5b846d1c58d7509861c6fe3ac1).

#### Conclusion

Our new, composition-based model is improved in a number of ways:

* It's easy to change types.
* Each submittable is easy to use independently of its question, reducing
  coupling.
* There's a clear boundary in the API for questions and submittables, making it
  easier to test and making it less likely that concerns leak between the two.
* Shared behavior happens via composition, making it less likely that the base
  class becomes a [large class](#large-class).
* It's easy to add new state without effecting other types, because
  strategy-specific state is stored on a table for that strategy.

You can view the entire refactor will all steps combined in the [example
app](https://github.com/thoughtbot/ruby-science/compare/4939d3e3c539c5caaa36400d75258cc3f3f4e7d8...5f4a14ff6c43bf5b846d1c58d7509861c6fe3ac1) to get an idea of what changed at the macro level.

This is a difficult transition to make, and the more behavior and data that you
shove into an inheritance scheme, the harder it becomes. In situations where
[STI](#single-table-inheritance-sti) is not significantly easier than using a
polymorphic relationship, it's better to start with composition. STI provides
few advantages over composition, and it's easier to merge models than to split
them.

### Drawbacks

Our application also got worse in a number of ways:

* We introduced a new word into the application vocabulary. This can increase
  understanding of a complex system, but vocabulary overload makes simpler
  systems unnecessarily hard to learn.
* We now need two queries to get a question's full state, and we'll need to
  query up to four tables to get information about a set of questions.
* We introduced useless tables for two of our question types. This will happen
  whenever you use ActiveRecord to back a strategy without state.
* We increased the overall complexity of the system. In this case, it may have
  been worth it, because we reduced the complexity per component. However, it's
  worth keeping an eye on.

Before performing a large change like this, try to imagine what will be easy to
change in the new world that's hard right now.

After performing a large change, keep track of difficult changes you make. Would
they have been easier in the old world?

Answering this questions will increase your ability to judge whether or not to
use composition or inheritance in future situations.

### Next Steps

* Check the extracted strategy classes to make sure they don't have [Feature
  Envy](#feature-envy) related to the original base class. You may want to use
  [Move Method](#move-method) to move methods between strategies and the root
  class.
* Check the extracted strategy classes for [Duplicated Code](#duplicated-code)
  introduced while splitting up the base class. Use [Extract
  Method](#extract-method) or [Extract Class](#extract-class) to extract common
  behavior.

# Replace mixin with composition

STUB

# Replace Callback with Method

If your models are hard to use and change because their persistence logic is
coupled with business logic, one way to loosen things up is by replacing
[callbacks](#callback).

### Uses

* Reduces coupling persistence logic with business logic.
* Makes it easier to extract concerns from models.
* Fixes bugs from accidentally triggered callbacks.
* Fixes bugs from callbacks with side effects when transactions roll back.

### Steps

* Use [Extract Method](#extract-method) if the callback is an anonymous block.
* Promote the callback method to a public method if it's private.
* Call the public method explicitly rather than relying on `save` and callbacks.

\clearpage

### Example

```ruby
# app/models/survey_inviter.rb
def deliver_invitations
  recipients.map do |recipient_email|
    Invitation.create!(
      survey: survey,
      sender: sender,
      recipient_email: recipient_email,
      status: 'pending',
      message: @message
    )
  end
end
```

```ruby
# app/models/invitation.rb
after_create :deliver
```

```ruby
# app/models/invitation.rb
private

def deliver
  Mailer.invitation_notification(self).deliver
end
```

In the above code, the `SurveyInviter` is simply creating `Invitation` records,
and the actual delivery of the invitation email is hidden behind
`Invitation.create!` via a callback.

If one of several invitations fails to save, the user will see a 500 page, but
some of the invitations will already have been saved and delivered. The user
will be unable to tell which invitations were sent.

Because delivery is coupled with persistence, there's no way to make sure that
all of the invitations are saved before starting to deliver emails.

Let's make the callback method public so that it can be called from
`SurveyInviter`:

```ruby
# app/models/invitation.rb
def deliver
  Mailer.invitation_notification(self).deliver
end

private
```

Then remove the `after_create` line to detach the method from persistence.

Now we can split invitations into separate persistence and delivery phases:

```ruby
# app/models/survey_inviter.rb
def deliver_invitations
  create_invitations.each(&:deliver)
end

def create_invitations
  Invitation.transaction do
    recipients.map do |recipient_email|
      Invitation.create!(
        survey: survey,
        sender: sender,
        recipient_email: recipient_email,
        status: 'pending',
        message: @message
      )
    end
  end
end
```

If any of the invitations fail to save, the transaction will roll back. Nothing
will be committed, and no messages will be delivered.

### Next Steps

* Find other instances where the model is saved to make sure that the extracted
  method doesn't need to be called.

# Use convention over configuration

Ruby's metaprogramming allows us to avoid boilerplate code and duplication by
relying on conventions for class names, file names, and directory structure.
Although depending on class names can be constricting in some situations,
careful use of conventions will make your applications less tedious and more
bug-proof.

### Uses

* Eliminate [Case Statements](#case-statement) by finding classes by name.
* Eliminate [Shotgun Surgery](#shotgun-surgery) by removing the need to register
  or configure new strategies and services.
* Remove [Duplicated Code](#duplicated-code) by removing manual associations
  from identifiers to class names.

### Example

This controller accepts an `id` parameter identifying which summarizer strategy
to use and renders a summary of the survey based on the chosen strategy:

```ruby
# app/controllers/summaries_controller.rb
class SummariesController < ApplicationController
  def show
    @survey = Survey.find(params[:survey_id])
    @summaries = @survey.summarize(summarizer)
  end

  private

  def summarizer
    case params[:id]
    when 'breakdown'
      Breakdown.new
    when 'most_recent'
      MostRecent.new
    when 'your_answers'
      UserAnswer.new(current_user)
    else
      raise "Unknown summary type: #{params[:id]}"
    end
  end
end
```

The controller is manually mapping a given strategy name to an object
that can perform the strategy with the given name. In most cases, a strategy
name directly maps to a class of the same name.

We can use the `constantize` method from Rails to retrieve a class by name:

``` ruby
params[:id].classify.constantize
```

This will find the `MostRecent` class from the string `"most_recent"`, and so
on. This means we can rely on a convention for our summarizer strategies: each
named strategy will map to a class which the controller can instantiate to
obtain a summarizer.

However, we can't simplify start using `constantize` in our example, because
there's one outlier case: the `UserAnswer` class is referenced using
`"your_answers"` instead of `"user_answer"`, and `UserAnswer` takes different
parameters than the other two strategies.

Before refactoring the code to rely on our new convention, let's refactor to
obey it. All our names should map directly to class names, and each class should
accept the same parameters:

```ruby
# app/controllers/summaries_controller.rb
def summarizer
  case params[:id]
  when 'breakdown'
    Breakdown.new(user: current_user)
  when 'most_recent'
    MostRecent.new(user: current_user)
  when 'user_answer'
    UserAnswer.new(user: current_user)
  else
    raise "Unknown summary type: #{params[:id]}"
  end
end
```

Now that we know we can instantiate any of the summarizer classes the same way,
let's extract a method for determining the summarizer class:

```ruby
# app/controllers/summaries_controller.rb
def summarizer
  summarizer_class.new(user: current_user)
end

def summarizer_class
  case params[:id]
  when 'breakdown'
    Breakdown
  when 'most_recent'
    MostRecent
  when 'user_answer'
    UserAnswer
  else
    raise "Unknown summary type: #{params[:id]}"
  end
end
```

Now the extracted class performs exactly the same logic as `constantize`, so
let's use it:

```ruby
# app/controllers/summaries_controller.rb
def summarizer
  summarizer_class.new(user: current_user)
end

def summarizer_class
  params[:id].classify.constantize
end
```

Now we'll never need to change our controller when adding a new strategy; we
just add a new class following the naming convention.

There are two drawbacks we should fix before merging:

* Before, a developer could simply look at the controller to find the list of
  available strategies. Now you'd need to perform a complicated search to find
  the relevant classes.
* The original code had a whitelist of strategies; that is, a user couldn't
  instantiate any class they wanted just by hacking parameters. The new code
  will instantiate anything you want.

We can solve both easily by altering our convention slightly: scope all the
summarizer classes within a module.

```ruby
# app/controllers/summaries_controller.rb
def summarizer_class
  "Summarizer::#{params[:id].classify}".constantize
end
```

With this convention in place, you can find all summaries by just looking in the
`Summarizer` module. In a Rails application, this will be in a `summarizer`
directory by convention.

Users also won't be able to instantiate anything they want by abusing our
`constantize`, because only classes in the `Summarizer` module are available.

### Drawbacks

#### Weak Conventions

Conventions are most valuable when they're completely consistent.

The convention is slightly forced in this case because `UserAnswer` needs
different parameters than the other two strategies. This means that we now need
to add no-op `initializer` methods to the other two classes:

```ruby
# app/models/summarizer/breakdown.rb
class Summarizer::Breakdown
  def initialize(options)
  end

  def summarize(question)
    question.breakdown
  end
end
```

This isn't a deal-breaker, but it makes the other classes a little noisier, and
adds the risk that a developer will waste time trying to remove the unused
parameter.

Every compromise made weakens the convention, and having a weak convention is
worse than having no convention. If you have to change the convention for every
class you add that follows it, try something else.

#### Class-Oriented Programming

Another drawback to this solution is that it's entirely class-based, which means
you can't assemble strategies at run-time. This means that reuse requires
inheritance.

Also, this class-based approach, while convenient when developing an
application, is more likely to cause frustration when writing a library. Forcing
developers to pass a class name instead of an object limits the amount of
runtime information strategies can use. In our example, only a `user` was
required. When you control both sides of the API, it's fine to assume that this
is safe. When writing a library that will interface with other developers'
applications, it's better not to rely on class names.

# Introduce Visitor

STUB

\part{Principles}

# DRY

STUB

# Single responsibility principle

STUB

# Tell, Don't Ask

STUB

# Law of Demeter

STUB

# Composition over inheritance

STUB

# Open closed principle

STUB

# Dependency inversion principle

STUB
