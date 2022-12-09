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

1. [Code Review](introduction/code_review.md)
2. [Smells](introduction/smells.md)
3. [Resistance](introduction/resistance.md)
4. [Bugs and Churn](introduction/bugs_and_churn.md)
5. [Tools to Find Smells](introduction/tools_to_find_smells.md)
6. [Navigating](introduction/navigating.md)
7. [Example Application](introduction/example_application.md)

## Code Smells

1. [Long Method](code_smells/long_method.md)
2. [Large Class](code_smells/large_class.md)
3. [Feature Envy](code_smells/feature_envy.md)
4. [Case Statement](code_smells/case_statement.md)
5. [Shotgun Surgery](code_smells/shotgun_surgery.md)
6. [Divergent Change](code_smells/divergent_change.md)
7. [Long Parameter List](code_smells/long_parameter_list.md)
8. [Duplicated Code](code_smells/duplicated_code.md)
9. [Uncommunicative Name](code_smells/uncommunicative_name.md)
10. [Single Table Inheritance](code_smells/sti.md)
11. [Comments](code_smells/comments.md)
12. [Mixins](code_smells/mixin.md)
13. [Callbacks](code_smells/callback.md)

## Solutions

1. [Replace Conditional with Polymorphism](solutions/replace_conditional_with_polymorphism.md)
2. [Replace Conditional with Null Object](solutions/replace_conditional_with_null_object.md)
3. [Extract Method](solutions/extract_method.md)
4. [Rename Method](solutions/rename_method.md)
5. [Extract Class](solutions/extract_class.md)
6. [Extract Value Object](solutions/extract_value_object.md)
7. [Extract Decorator](solutions/extract_decorator.md)
8. [Extract Partial](solutions/extract_partial.md)
9. [Extract Validator](solutions/extract_validator.md)
10. [Introduce Explaining Variable](solutions/introduce_explaining_variable.md)
11. [Introduce Form Object](solutions/introduce_form_object.md)
12. [Introduce Parameter Object](solutions/introduce_parameter_object.md)
13. [Use Class as Factory](solutions/use_class_as_factory.md)
14. [Move Method](solutions/move_method.md)
15. [Inline Class](solutions/inline_class.md)
16. [Inject Dependencies](solutions/inject_dependencies.md)
17. [Replace Subclasses with Strategies](solutions/replace_subclasses_with_strategies.md)
18. [Replace Mixin with Composition](solutions/replace_mixin_with_composition.md)
19. [Replace Callback with Method](solutions/replace_callback_with_method.md)
20. [Use Convention Over Configuration](solutions/use_convention_over_configuration.md)

## Principles

1. [Dry](principles/dry)
2. [Single Responsibility Principle](principles/single_responsibility_principle)
3. [Tell Don't Ask](principles/tell_dont_ask)
4. [Law of Demeter](principles/law_of_demeter)
5. [Composition Over Inheritance](principles/composition_over_inheritance)
6. [Open Closed Principle](principles/open_closed_principle)
7. [Dependency Inversion Principle](principles/dependency_inversion_principle)
