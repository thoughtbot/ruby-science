# Long Parameter List

Ruby supports positional method arguments which can lead to Long Parameter Lists.

### Symptoms

* You can't easily change the method's arguments.
* The method has three or more arguments.
* The method is complex due to number of collaborating parameters.
* The method requires large amounts of setup during isolated testing.

### Example

Look at this mailer for an example of Long Parameter List.

` app/mailers/mailer.rb@44f85d8

### Solutions

* [Introduce Parameter Object](#introduce-parameter-object) and pass it in as an
object of naturally grouped attributes.

A common technique used to mask a long parameter list is grouping parameters using a
hash of named parameters; this will replace connascence position with connascence 
of name (a good first step). However, it will not reduce the number of collaborators
in the method.

* [Extract Class](#extract-class) if the method is complex due to the number of collaborators.
