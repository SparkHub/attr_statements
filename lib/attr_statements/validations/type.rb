module AttrStatements
  module Validations
    class Type < Validation
      private

      ERROR_KEY = :type
      private_constant :ERROR_KEY

      def validate_each(value)
        type_errors = []
        if value.present? && statement.class_type != value.class
          type_errors << Error.new(ERROR_KEY, options)
        end
        type_errors
      end

      def options
        { class: statement.class_type }
      end
    end
  end
end
