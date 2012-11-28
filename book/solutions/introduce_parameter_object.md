## Introduce Parameter Object

Uses:

* Removes [Long Parameter Lists](#long-parameter-list).
* Groups parameters that go naturally together.

Let's take a look at an example [Long Parameter List](#long-parameter-list) and 
improve it by grouping the recipients attributes:

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

By introducing a new object `recipient` we can group the attributes `first_name`,
`last_name`, `email`, and `phone_number`.

```` ruby
def survey_completion_notification(recipient)
  @recipient = recipient

  mail(
    to: @recipient.email,
    subject: 'Thank you for completing the survey'
  )
end
```
