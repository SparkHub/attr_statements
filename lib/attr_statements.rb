require 'attr_statements/version'
require 'attr_statements/error_manager'
require 'attr_statements/attribute'

module AttrStatements
  class << self
    def included(base)
      base.class_eval do
        extend  ClassMethods
        include InstanceMethods
        include AttrStatements::ErrorManager
      end
    end
  end

  module InstanceMethods
    private

    def get_statement_value(key)
      instance_variable_get("@#{key}")
    end

    def set_statement_value(key, value)
      instance_variable_set("@#{key}", value)
    end
  end

  module ClassMethods
    def attr_statements
      @attr_statements ||= []
    end

    protected

    attr_writer :attr_statements

    private

    def attr_statement(key, class_type, options = {})
      attr_statements << key.to_sym

      define_writer_object_method(key, Attribute.new(key, class_type, options))
      define_reader_object_method(key)
      define_writer_instance_method(key)
      define_reader_instance_method(key)
    end

    def define_writer_object_method(key, attribute)
      set_statement_object(key, attribute)
    end

    def define_reader_object_method(key)
      # define as singleton method
      (class << self; self end).send(:define_method, key) do
        get_statement_object(key)
      end
    end

    def set_statement_object(key, value)
      class_variable_set("@@#{key}", value)
    end

    def get_statement_object(key)
      class_variable_get("@@#{key}")
    end

    def define_reader_instance_method(key)
      define_method(key) do
        get_statement_value(key)
      end
    end

    def define_writer_instance_method(key)
      define_method("#{key}=") do |value|
        set_statement_value(key, value)
      end
    end
  end
end
