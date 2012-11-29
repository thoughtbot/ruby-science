## Introduce Parameter Object

A technique to reduce the number of input parameters to a method.

To introduce a parameter object:

* Pick a name for the object that represents the grouped parameters.
* Replace method's grouped parameters with the object.

Uses:

* Remove [Long Parameter Lists](#long-parameter-list).
* Group parameters that naturally fit together.
* Encapsulate behavior between related parameters.

Let's take a look at the example from [Long Parameter List](#long-parameter-list) and 
improve it by grouping the related parameters into an object:

` app/mailers/mailer.rb@44f85d8

` app/views/mailer/completion_notification.html.erb@44f85d8

By introducing the new parameter object `recipient` we can naturally group the 
attributes `first_name`, `last_name`, and `email` together.

` app/mailers/mailer.rb@28f3651

This also gives us the opportunity to create a new method `full_name` on the `recipient`
object to encapsulate behavior between the `first_name` and `last_name`.

` app/views/mailer/completion_notification.html.erb@28f3651

#### Next Steps

* Check to see if the same Data Clump exists elsewhere in the application, and
 reuse the Parameter Object to group them together.
* Verify the methods using the Parameter Object don't have [Feature Envy](#feature-envy).
