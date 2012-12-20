class EnumerableValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, enumerable)
    enumerable.each do |value|
      validator.validate_each(record, attribute, value)
    end
  end

  private

  def validator
    options[:validator].new(validator_options)
  end

  def validator_options
    options.except(:validator).merge(attributes: attributes)
  end
end
