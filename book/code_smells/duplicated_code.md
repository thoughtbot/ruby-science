# Duplicated Code

One of the first principles we're taught as developers: Keep your code [DRY](#dry).

#### Symptoms

+ You find yourself copy and pasting code from one place to another.
+ Changes to your application require you to make the same edits in multiple places.

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

* [Extract Method](#extract-method) is the most common way to remove duplicated code.
* [Extract Class](#extract-class) when code is duplicated across several files.
