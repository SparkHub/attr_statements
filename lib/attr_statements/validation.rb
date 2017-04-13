module AttrStatements
  class Validation
    VALIDATORS = %w[type presence length].freeze

    attr_reader :errors

    def valid?(value)
      self.errors = validate_each(value)
      errors.empty?
    end

    protected

    attr_reader :statement

    private

    attr_writer :statement
    attr_writer :errors

    def initialize(statement)
      self.statement = statement
    end
  end
end
