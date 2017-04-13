module Factory
  class << self
    def statement_attribute(key: :key, class_type: String, options: {})
      AttrStatements::Attribute.new(key, class_type, options)
    end
  end
end
