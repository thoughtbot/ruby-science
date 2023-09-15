## Extract Partial

Extracting a partial is a technique used for removing complex or duplicated view
code from your application. This is the equivalent of using [long method](#long-method) and
[extract method](#extract-method) in your views and templates.

### Uses

* Removes [duplicated code](#duplicated-code) from views.
* Avoids [shotgun surgery](#shotgun-surgery) by forcing changes to happen in one place.
* Removes [divergent change](#divergent-change) by removing a reason for the view to change.
* Groups common code.
* Reduces view size and complexity.
* Makes view logic easier to reuse, which makes it easier to [avoid
  duplication](#dry).

### Steps

* Create a new file for partial prefixed with an underscore (_filename.html.erb).
* Move common code into newly created file.
* Render the partial from the source file.

### Example

Let's revisit the view code for _adding_ and _editing_ questions.

Note: There are a few small differences in the files (the URL endpoint and the
label on the submit button).

` app/views/questions/new.html.erb@cec19d8

` app/views/questions/edit.html.erb@cec19d8

First, extract the common code into a partial, remove any instance variables and
use `question` and `url` as local variables:

` app/views/questions/_form.html.erb@57f0f48

Move the submit button text into the locales file:

` config/locales/en.yml@57f0f48

Then render the partial from each of the views, passing in the values for
`question` and `url`:

` app/views/questions/new.html.erb@57f0f48

` app/views/questions/edit.html.erb@57f0f48

### Next Steps

* Check for other occurrences of the duplicated view code in your application and
replace them with the newly extracted partial.
