class EmailAddressValidator < ActiveModel::EachValidator
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  def validate_each(record, attribute, value)
    if value.present? && !value.match(EMAIL_REGEX)
      record.errors.add(attribute, "#{value} is not a valid email")
    end
  end
end
