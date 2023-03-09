---
title: Ruby Science
---

Ruby on Rails is more than 15 years old and its community has developed a number
of principles for building applications that are fast, fun and easy to change: 
Don't repeat yourself, keep your views dumb, keep your controllers skinny, and
keep business logic in your models. These principles carry most applications to
their first release or beyond.

However, these principles only get you so far. After a few releases, most
applications begin to suffer. Models become fat, classes become few and large,
tests become slow and changes become painful. In many applications, there
comes a day when the developers realize that there's no going back; the
application is a twisted mess and the only way out is a rewrite or a new job.

Fortunately, it doesn't have to be this way. Developers have been using
object-oriented programming for several decades and there's a wealth of
knowledge out there that still applies to developing applications today. We can
use the lessons learned by these developers to write good Rails applications by
applying good object-oriented programming.

Ruby Science will outline a process for detecting emerging problems in code and
will dive into the solutions, old and new.

## Introduction

1. [Code Review](book/introduction/code_review.md)
2. [Smells](book/introduction/smells.md)
3. [Resistance](book/introduction/resistance.md)
4. [Bugs and Churn](book/introduction/bugs_and_churn.md)
5. [Tools to Find Smells](book/introduction/tools_to_find_smells.md)
6. [Navigating](book/introduction/navigating.md)
7. [Example Application](book/introduction/example_application.md)

## Code Smells

1. [Long Method](book/code_smells/long_method.md)
2. [Large Class](book/code_smells/large_class.md)
3. [Feature Envy](book/code_smells/feature_envy.md)
4. [Case Statement](book/code_smells/case_statement.md)
5. [Shotgun Surgery](book/code_smells/shotgun_surgery.md)
6. [Divergent Change](book/code_smells/divergent_change.md)
7. [Long Parameter List](book/code_smells/long_parameter_list.md)
8. [Duplicated Code](book/code_smells/duplicated_code.md)
9. [Uncommunicative Name](book/code_smells/uncommunicative_name.md)
10. [Single Table Inheritance](book/code_smells/sti.md)
11. [Comments](book/code_smells/comments.md)
12. [Mixins](book/code_smells/mixin.md)
13. [Callbacks](book/code_smells/callback.md)

## Solutions

1. [Replace Conditional with Polymorphism](book/solutions/replace_conditional_with_polymorphism.md)
2. [Replace Conditional with Null Object](book/solutions/replace_conditional_with_null_object.md)
3. [Extract Method](book/solutions/extract_method.md)
4. [Rename Method](book/solutions/rename_method.md)
5. [Extract Class](book/solutions/extract_class.md)
6. [Extract Value Object](book/solutions/extract_value_object.md)
7. [Extract Decorator](book/solutions/extract_decorator.md)
8. [Extract Partial](book/solutions/extract_partial.md)
9. [Extract Validator](book/solutions/extract_validator.md)
10. [Introduce Explaining Variable](book/solutions/introduce_explaining_variable.md)
11. [Introduce Form Object](book/solutions/introduce_form_object.md)
12. [Introduce Parameter Object](book/solutions/introduce_parameter_object.md)
13. [Use Class as Factory](book/solutions/use_class_as_factory.md)
14. [Move Method](book/solutions/move_method.md)
15. [Inline Class](book/solutions/inline_class.md)
16. [Inject Dependencies](book/solutions/inject_dependencies.md)
17. [Replace Subclasses with Strategies](book/solutions/replace_subclasses_with_strategies.md)
18. [Replace Mixin with Composition](book/solutions/replace_mixin_with_composition.md)
19. [Replace Callback with Method](book/solutions/replace_callback_with_method.md)
20. [Use Convention Over Configuration](book/solutions/use_convention_over_configuration.md)

## Principles

1. [Dry](book/principles/dry.md)
2. [Single Responsibility Principle](book/principles/single_responsibility_principle.md)
3. [Tell Don't Ask](book/principles/tell_dont_ask.md)
4. [Law of Demeter](book/principles/law_of_demeter.md)
5. [Composition Over Inheritance](book/principles/composition_over_inheritance.md)
6. [Open Closed Principle](book/principles/open_closed_principle.md)
7. [Dependency Inversion Principle](book/principles/dependency_inversion_principle.md)
