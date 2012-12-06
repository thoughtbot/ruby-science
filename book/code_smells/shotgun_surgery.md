# Shotgun Surgery

Shotgun Surgery is usually a more obvious symptom that reveals another smell.

#### Symptoms

* You have to make the same small change across several different files.
* Changes become difficult to manage because they hard to keep track of.

Make sure you look for related smells in the affected code:

* [Duplicated Code](#duplicated-code)
* [Case Statement](#case-statement)
* [Feature Envy](#feature-envy)
* [Long Parameter List](#long-parameter-list)
* [Parallel Inheritance Hierarchies](#parallel-inheritance-hierarchies)

\clearpage

#### Example

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

#### Solutions

* [Replace Conditional with Polymorphism](#replace-conditional-with-polymorphism)
to replace duplicated `case` statements and `if-elsif` blocks.
* [Replace Conditional with Null Object](#replace-conditional-with-null-object)
  if changing a method to return `nil` would require checks for `nil` in several
  places.
* [Extract Decorator](#extract-decorator) to replace duplicated display code in 
views/templates.
* [Introduce Parameter Object](#introduce-parameter-object) to hang useful
formatting methods alongside a data clump of related attributes.
