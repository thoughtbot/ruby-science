## Long Method

The most common smell in Rails applications is the Long Method.

Long methods are exactly what they sound like: methods that are too long.
They're easy to spot.

### Symptoms

* If you can't tell exactly what a method does at a glance, it's too long.
* Methods with more than one level of nesting are usually too long.
* Methods with more than one level of abstraction may be too long.
* Methods with a flog score of 10 or higher may be too long.

You can watch out for long methods as you write them, but finding existing
methods is easiest with tools like flog:

    % flog app lib
        72.9: flog total
         5.6: flog/method average

        15.7: QuestionsController#create       app/controllers/questions_controller.rb:9
        11.7: QuestionsController#new          app/controllers/questions_controller.rb:2
        11.0: Question#none
         8.1: SurveysController#create         app/controllers/surveys_controller.rb:6

Methods with higher scores are more complicated. Anything with a score higher
than 10 is worth looking at, but flog only helps you find potential trouble
spots; use your own judgment when refactoring.

### Example

For an example of a long method, let's take a look at the highest scored method
from flog, `QuestionsController#create`:

``` ruby
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
```

### Solutions

* [Extract method](#extract-method) is the most common way to break apart long methods.
* [Replace temp with query](#replace-temp-with-query) if you have local variables
in the method.

After extracting methods, check for [feature envy](#feature-envy) in the new
methods to see if you should employ [move method](#move-method) to provide the
method with a better home.
