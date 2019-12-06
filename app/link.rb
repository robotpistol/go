# Link DB Model
class Link < Sequel::Model
  def hit!
    self.hits += 1
    save(validate: false)
  end

  def validate
    super
    errors.add(:name, 'cannot be empty') if name.nil? || name.empty?
    errors.add(:url, 'cannot be empty') if !url || url.empty?
  end

  def to_json(_ = nil)
    {
      name: name,
      url: url,
      description: description,
      hits: hits
    }
  end
end
