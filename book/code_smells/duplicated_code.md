## Duplicated Code

One of the first principles we're taught as developers: [Don't Repeat
Yourself](#dry).

### Symptoms

* You find yourself copying and pasting code from one place to another.
* [Shotgun surgery](#shotgun-surgery) occurs when changes to your application
require the same small edits in multiple places.

\clearpage

### Example

The `QuestionsController` suffers from duplication in the `create` and `update` methods.

```ruby
# app/controllers/questions_controller.rb
def create
  @survey = Survey.find(params[:survey_id])
  question_params = params.
    require(:question).
    permit(:title, :options_attributes, :minimum, :maximum)
  @question = type.constantize.new(question_params)
  @question.survey = @survey

  if @question.save
    redirect_to @survey
  else
    render :new
  end
end

def update
  @question = Question.find(params[:id])
  question_params = params.
    require(:question).
    permit(:title, :options_attributes, :minimum, :maximum)
  @question.update_attributes(question_params)

  if @question.save
    redirect_to @question.survey
  else
    render :edit
  end
end
```

### Solutions

* [Extract method](#extract-method) for duplicated code in the same file.
* [Extract class](#extract-class) for duplicated code across multiple files.
* [Extract partial](#extract-partial) for duplicated view and template code.
* [Replace conditional with polymorphism](#replace-conditional-with-polymorphism)
for duplicated conditional logic.
* [Replace conditional with null object](#replace-conditional-with-null-object)
  to remove duplicated checks for `nil` values.

### Prevention

Following the [single responsibility
principle](#single-responsibility-principle) will result in small classes that
are easier to reuse, reducing the temptation of duplication.
