## Introduce Parameter Object

This is a technique to reduce the number of input parameters to a method.

To introduce a Parameter Object:

* Pick a name for the object that represents the grouped parameters.
* Replace the method's grouped parameters with the object.

### Uses

* Removes [long parameter lists](#long-parameter-list).
* Groups parameters that naturally fit together.
* Encapsulates behavior between related parameters.

\clearpage

### Example

Let's take a look at the example from [Long Parameter List](#long-parameter-list) and
improve it by grouping the related parameters into an object:

` app/mailers/mailer.rb@44f85d8

` app/views/mailer/completion_notification.html.erb@44f85d8

\clearpage

By introducing the new parameter object `recipient` we can naturally group the
attributes `first_name`, `last_name`, and `email` together.

` app/models/recipient.rb

` app/mailers/mailer.rb@28f3651

Notice that we've also created a new `full_name` method on the `recipient`
object to encapsulate behavior between the `first_name` and `last_name`.

` app/views/mailer/completion_notification.html.erb@28f3651

### Next Steps

* Check to see if the same data clump exists elsewhere in the application and
 reuse the parameter object to group them together.
* Verify the methods using the parameter object don't have [feature envy](#feature-envy).
