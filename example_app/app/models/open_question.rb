class OpenQuestion < Question
  def submittable
    OpenSubmittable.new(self)
  end
end
