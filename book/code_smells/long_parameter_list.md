## Long Parameter List

Ruby supports positional method arguments which can lead to Long Parameter Lists.

#### Symptoms

* If you have three or more arguments, your parameter list is probably too long.
* Adding an argument causes [Shotgun Surgery](#shotgun-surgery).
* Method complexity caused by number of collaborating objects.
* Large amounts of setup required for isolated testing.

#### Example

Look at this mailer for an example of Long Parameter List.

```ruby
def survey_completion_notification(first_name, last_name, email, phone_number)
  @first_name = first_name
  @last_name = last_name
  @email = email
  @phone_number = phone_number

  mail(
    to: @email,
    subject: 'Thank you for completing the survey'
  )
end
```

#### Solutions

If the input parameters all belong to the same object, apply [Introduce Parameter Object](#introduce-parameter-object)
and pass in the object as a parameter instead of the individual attributes.

A common technique used to mask a long parameter list is grouping parameters using a
 hash of named parameters; this will replace connascence position with connascence 
of name (a good first step). 
However, it will not reduce the number of collaborators required by the method.
If a method is complex due to the number of collaborators use 
[Extract Class](#extract-class) to reduce complexity, and pass in the extracted 
class using [Dependency Injection](#dependency-injection) if needed.
