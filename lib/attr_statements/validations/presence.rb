module AttrStatements
  module Validations
    class Presence < Validation
      private

      ERROR_KEY = :blank
      private_constant :ERROR_KEY

      def validate_each(value)
        type_errors = []
        if statement.presence? && value.blank?
          type_errors << Error.new(ERROR_KEY)
        end
        type_errors
      end
    end
  end
end
