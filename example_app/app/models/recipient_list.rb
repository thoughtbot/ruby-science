class RecipientList
  include Enumerable

  def initialize(recipient_string)
    @recipient_string = recipient_string
  end

  def each(&block)
    recipients.each(&block)
  end

  def to_s
    @recipient_string
  end

  private

  def recipients
    @recipient_string.to_s.gsub(/\s+/, '').split(/[\n,;]+/)
  end
end
