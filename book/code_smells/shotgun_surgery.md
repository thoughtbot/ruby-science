## Shotgun Surgery

Shotgun Surgery is usually a more obvious symptom that reveals another smell.

### Symptoms

* You have to make the same small change across several different files.
* Changes become difficult to manage because they are hard to keep track of.

Make sure you look for related smells in the affected code:

* [Duplicated code](#duplicated-code)
* [Case statement](#case-statement)
* [Feature envy](#feature-envy)
* [Long parameter list](#long-parameter-list)

### Example

Users' names are formatted and displayed as "First Last" throughout the
application. If you want to change the formatting to include a middle initial
(example: "First M. Last") you'll need to make the same small change in several
places.

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

* [Replace conditional with polymorphism](#replace-conditional-with-polymorphism)
to replace duplicated `case` statements and `if-elsif` blocks.
* [Replace conditional with null object](#replace-conditional-with-null-object)
  if changing a method to return `nil` would require checks for `nil` in several
  places.
* [Extract decorator](#extract-decorator) to replace duplicated display code in
views/templates.
* [Introduce parameter object](#introduce-parameter-object) to hang useful
formatting methods alongside a data clump of related attributes.
* [Use convention over configuration](#use-convention-over-configuration) to
  eliminate small steps that can be inferred based on a convention, such as a
  name.
* [Inline class](#inline-class) if the class only serves to add extra steps when
  performing changes.

### Prevention

If your changes become spread out because you need to pass information between
boundaries for dependencies, try [inverting
control](#dependency-inversion-principle).

If you find yourself repeating the exact same change in several places, make
sure that you [Don't Repeat Yourself](#dry).

If you need to change several places because of a modification in your
dependency chain, such as changing `user.plan.price` to
`user.account.plan.price`, make sure that you're following the [law of
Demeter](#law-of-demeter).

If conditional logic is affected in several places by a single, cohesive change,
make sure that you're following [tell, don't ask](#tell-dont-ask).
