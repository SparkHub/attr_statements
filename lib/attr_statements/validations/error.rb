module AttrStatements
  module Validations
    class Error
      attr_reader :message
      attr_reader :options

      private

      attr_writer :message
      attr_writer :options

      def initialize(message, options = {})
        self.message = message.to_sym
        self.options = options
      end
    end
  end
end
