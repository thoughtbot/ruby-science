# Duplicated Code

One of the first principles we're taught as developers: Keep your code [DRY](#dry).

#### Symptoms

* You find yourself copy and pasting code from one place to another.
* [Shotgun Surgery](#shotgun-surgery) occurs when changes to your application 
require the same small edits in multiple places.

\clearpage

#### Example

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

#### Solutions

* [Extract Method](#extract-method) for duplicated code in the same file.
* [Extract Class](#extract-class) for duplicated code across multiple files.
* [Extract Partial](#extract-partial) for duplicated view and template code.
* [Replace Conditional with Polymorphism](#replace-conditional-with-polymorphism)
for duplicated conditional logic.
* [Replace Conditional with Null Object](#replace-conditional-with-null-object)
  to remove duplicated checks for `nil` values.
