## Extract Class

Dividing responsibilities into classes is the primary way to manage complexity
in object-oriented software. [Extract class](#extract-class) is the primary mechanism for
introducing new classes. This refactoring takes one class and splits it into two
by moving one or more methods and instance variables into a new class.

The process for extracting a class looks like this:

1. Create a new, empty class.
2. Instantiate the new class from the original class.
3. [Move a method](#move-method) from the original class to the new class.
4. Repeat step 3 until you're happy with the original class.

### Uses

* Removes [large class](#large-class) by splitting up the class.
* Eliminates [divergent change](#divergent-change) by moving one reason to
  change into a new class.
* Provides a cohesive set of functionality with a meaningful name, making it
  easier to understand and talk about.
* Fully encapsulates a concern within a single class, following the [single
  responsibility principle](#single-responsibility-principle) and making it
  easier to change and reuse that functionality.
* Allows concerns to be injected, following the [dependency inversion
  principle](#dependency-inversion-principle).
* Makes behavior easier to reuse, which makes it easier to [avoid duplication](#dry).

### Example

The `InvitationsController` is a [large class](#large-class) hidden behind a
[long method](#long-method):

` app/controllers/invitations_controller.rb@bd74a9f

Although it contains only two methods, there's a lot going on under the hood. It
parses and validates emails, manages several pieces of state which the view needs
to know about, handles control flow for the user and creates and delivers
invitations.

[A liberal
application](https://github.com/thoughtbot/ruby-science/commit/65f1b428) of
[extract method](#extract-method) to break up this [long method](#long-method)
will reveal the complexity:

` app/controllers/invitations_controller.rb@65f1b428

Let's extract all of the non-controller logic into a new class. We'll start by
defining and instantiating a new, empty class:

` app/controllers/invitations_controller.rb@cce33485:10

` app/models/survey_inviter.rb@cce33485

At this point, we've [created a staging
area](https://github.com/thoughtbot/ruby-science/commit/cce33485) for using
[move method](#move-method) to transfer complexity from one class to the other.

Next, we'll move one method from the controller to our new class. It's best to
move methods which depend on few private methods or instance variables from the
original class, so we'll start with a method which only uses one private method:

` app/models/survey_inviter.rb@ac014750:6,8

We need the recipients for this method, so we'll accept it in the `initialize`
method:

` app/models/survey_inviter.rb@ac014750:2,4

And pass it from our controller:

` app/controllers/invitations_controller.rb@ac014750:10

The original controller method can delegate to the extracted method:

` app/controllers/invitations_controller.rb@ac014750:47,49

We've [moved a little complexity out of our
controller](https://github.com/thoughtbot/ruby-science/commit/ac014750) and we
now have a repeatable process for doing so: We can continue to move methods out
until we feel good about what's left in the controller.

Next, let's move out `invalid_recipients` from the controller, since it depends
on `recipient_list`, which we've already moved:

` app/models/survey_inviter.rb@0fefb969:8,14

Again, the original controller method can delegate:

` app/controllers/invitations_controller.rb@0fefb969:38,40

This method references a constant from the controller. This was the only place
where the constant was used, so we can move it to our new class:

` app/models/survey_inviter.rb@0fefb969:2

We can remove an instance variable in the controller by invoking this method
directly in the view:

` app/views/invitations/new.html.erb@0fefb969:7,12

Now that parsing email lists is [moved out of our
controller](https://github.com/thoughtbot/ruby-science/commit/0fefb969), let's
extract and delegate the only method in the controller that depends on
`invalid_recipients`:

` app/models/survey_inviter.rb@b434954d:31,33

Now we can remove `invalid_recipients` from the controller entirely.

The `valid_recipients?` method is only used in the compound validation
condition:

` app/controllers/invitations_controller.rb@0fefb969:10

If we extract `valid_message?` as well, we can fully encapsulate validation
within `SurveyInviter`.

` app/models/survey_inviter.rb@b434954d:27,29

We need `message` for this method, so we'll add that to `initialize`:

` app/models/survey_inviter.rb@b434954d:4,7

And pass it in:

` app/controllers/invitations_controller.rb@b434954d:9

We can now extract a method to encapsulate this compound condition:

` app/models/survey_inviter.rb@b434954d:9,11

And use that new method in our controller:

` app/controllers/invitations_controller.rb@b434954d:10

Now these methods can be private, trimming down the public interface for
`SurveyInviter`:

` app/models/survey_inviter.rb@b434954d:25,33

We've [pulled out most of the private
methods](https://github.com/thoughtbot/ruby-science/commit/b434954d), so the
remaining complexity results largely from saving and delivering the invitations.

Let's extract and move a `deliver` method for that:

` app/models/survey_inviter.rb@000babe1:15,25

We need the sender (the currently signed-in user) as well as the survey from the
controller to do this. This pushes our initialize method up to four parameters,
so let's switch to a hash:

` app/models/survey_inviter.rb@000babe1:4,9

And extract a method in our controller to build it:

` app/controllers/invitations_controller.rb@000babe1:22,24

Now we can invoke this method in our controller:

` app/controllers/invitations_controller.rb@000babe1:10,17

The `recipient_list` method is now only used internally in `SurveyInviter`, so
let's make it private.

We've [moved most of the behavior out of the
controller](https://github.com/thoughtbot/ruby-science/commit/000babe1), but
we're still assigning a number of instance variables for the view, which have
corresponding private methods in the controller. These values are also available
on `SurveyInviter`, which is already assigned to the view, so let's expose those
using `attr_reader`:

` app/models/survey_inviter.rb@a0505921:11

And use them directly from the view:

` app/views/invitations/new.html.erb@a0505921:1,17

Only the `SurveyInviter` is used in the controller now, so we can [remove the
remaining instance variables and private
methods](https://github.com/thoughtbot/ruby-science/commit/a0505921).

Our controller is now much simpler:

` app/controllers/invitations_controller.rb@a0505921

It only assigns one instance variable, it doesn't have too many methods and all
of its methods are fairly small.

\clearpage

The newly extracted `SurveyInviter` class absorbed much of the complexity, but
still isn't as bad as the original controller:

` app/models/survey_inviter.rb@a0505921

We can take this further by extracting more classes from `SurveyInviter`. See
our [full solution on
GitHub](https://github.com/thoughtbot/ruby-science/commit/fd6cd8d5).

### Drawbacks

Extracting classes decreases the amount of complexity in each class, but
increases the overall complexity of the application. Extracting too many classes
will create a maze of indirection that developers will be unable to navigate.

Every class also requires a name. Introducing new names can help to
explain functionality at a higher level and facilitate communication between
developers. However, introducing too many names results in vocabulary overload,
which makes the system difficult to learn for new developers.

If you extract classes in response to pain and resistance, you'll end up with just
the right number of classes and names.

### Next Steps

* Check the newly extracted class to make sure it isn't a [large
  class](#large-class), and extract another class if it is.
* Check the original class for [feature envy](#feature-envy) of the extracted
  class and use [move method](#move-method) if necessary.
