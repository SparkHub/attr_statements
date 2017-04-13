module AttrStatements
  module Validations
    class Length < Validation
      private

      ERROR_TYPES = {
        maximum: :too_long
      }.freeze
      private_constant :ERROR_TYPES

      def validate_each(value)
        type_errors = []

        ERROR_TYPES.each do |check_key, error_message|
          check_value = statement.length[check_key]

          if __send__(check_key, check_value, value)
            type_errors << Error.new(error_message, options(check_value))
          end
        end

        type_errors
      end

      def options(value)
        { count: value }
      end

      # :reek:UtilityFunction (because of metaprogramming)
      def maximum(max, value)
        max.is_a?(Integer) && value.is_a?(String) && value.size > max
      end
    end
  end
end
