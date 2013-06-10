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
* Make view logic easier to reuse, making it easier to [avoid
  duplication](#dry).

### Steps

* Create a new file for partial prefixed with an underscore (_filename.html.erb).
* Move common code into newly created file.
* Render the partial from the source file.

### Example

Let's revisit the view code for _adding_ and _editing_ questions.

Note: There are a few small differences in the files (the url endpoint, and the 
label on the submit button).

` app/views/questions/new.html.erb@cec19d8

` app/views/questions/edit.html.erb@cec19d8

First extract the common code into a partial, remove any instance variables, and 
use `question` and `url` as a local variables.

` app/views/questions/_form.html.erb@57f0f48

Move the submit button text into the locales file.

` config/locales/en.yml@57f0f48

Then render the partial from each of the views, passing in the values for
`question` and `url`.

` app/views/questions/new.html.erb@57f0f48

` app/views/questions/edit.html.erb@57f0f48

### Next Steps

* Check for other occurances of the duplicated view code in your application and 
replace them with the newly extracted partial.
