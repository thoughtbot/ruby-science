## Extract Method

The simplest refactoring to perform is extract method. To extract a method:

* Pick a name for the new method.
* Move extracted code into the new method.
* Call the new method from the point of extraction.

### Uses

* Removes [long methods](#long-method).
* Sets the stage for moving behavior via [move method](#move-method).
* Resolves obscurity by introducing intention-revealing names.
* Allows removal of [duplicated code](#duplicated-code) by moving the common
  code into the extracted method.
* Reveals complexity, making it easier to follow the [single responsibility
  principle](#single-responsibility-principle).
* Makes behavior easier to reuse, which makes it easier to [avoid duplication](#dry).

\clearpage

### Example

Let's take a look at an example of [long method](#long-method) and improve it by
extracting smaller methods:

```` ruby
def create
  @survey = Survey.find(params[:survey_id])
  @submittable_type = params[:submittable_type_id]
  question_params = params.
    require(:question).
    permit(:submittable_type, :title, :options_attributes, :minimum, :maximum)
  @question = @survey.questions.new(question_params)
  @question.submittable_type = @submittable_type

  if @question.save
    redirect_to @survey
  else
    render :new
  end
end
````

This method performs a number of tasks:

* It finds the survey that the question should belong to.
* It figures out what type of question we're creating (the `submittable_type`).
* It builds parameters for the new question by applying a white list to the HTTP
  parameters.
* It builds a question from the given survey, parameters and submittable type.
* It attempts to save the question.
* It redirects back to the survey for a valid question.
* It re-renders the form for an invalid question.

Any of these tasks can be extracted to a method. Let's start by extracting the
task of building the question.

```` ruby
def create
  @survey = Survey.find(params[:survey_id])
  @submittable_type = params[:submittable_type_id]
  build_question

  if @question.save
    redirect_to @survey
  else
    render :new
  end
end

private

def build_question
  question_params = params.
    require(:question).
    permit(:submittable_type, :title, :options_attributes, :minimum, :maximum)
  @question = @survey.questions.new(question_params)
  @question.submittable_type = @submittable_type
end
````

The `create` method is already much more readable. The new `build_question`
method is noisy, though, with the wrong details at the beginning. The task of
pulling out question parameters is clouding up the task of building the
question. Let's extract another method.

\clearpage

### Replace Temp with Query

One simple way to extract methods is by replacing local variables. Let's pull
`question_params` into its own method:

```` ruby
def build_question
  @question = @survey.questions.new(question_params)
  @question.submittable_type = @submittable_type
end

def question_params
  params.
    require(:question).
    permit(:submittable_type, :title, :options_attributes, :minimum, :maximum)
end
````

### Other Examples

For more examples of [extract method](#extract-method), take a look at these chapters:


* [Extract class](#extract-class):
  [b434954d](https://github.com/thoughtbot/ruby-science/commit/b434954d),
  [000babe1](https://github.com/thoughtbot/ruby-science/commit/000babe1)
* [Extract decorator](#extract-decorator):
  [15f5b96e](https://github.com/thoughtbot/ruby-science/commit/15f5b96e)
* [Introduce explaining variable](#introduce-explaining-variable) (inline)
* [Move method](#move-method):
  [d5b4871](https://github.com/thoughtbot/ruby-science/commit/d5b4871)
* [Replace conditional with null object](#replace-conditional-with-null-object):
  [1e35c68](https://github.com/thoughtbot/ruby-science/commit/1e35c68)

### Next Steps

* Check the original method and the extracted method to make sure neither is a
  [long method](#long-method).
* Check the original method and the extracted method to make sure that they both
  relate to the same core concern. If the methods aren't highly related, the
  class will suffer from [divergent change](#divergent-change).
* Check newly extracted methods for [feature envy](#feature-envy). If you find
  some, you may wish to employ [move method](#move-method) to provide the new
  method with a better home.
* Check the affected class to make sure it's not a [large class](#large-class).
  Extracting methods reveals complexity, making it clearer when a class is doing
  too much.
