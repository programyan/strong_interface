# frozen_string_literal: true

module StrongInterface
  class ParametersValidator
    def initialize(interface_method, klass_method)
      @interface_method = interface_method
      @interface_method_parameters = interface_method.parameters.map { |param| param[0] }
      @klass_method = klass_method
      @klass_method_parameters = klass_method.parameters.map { |param| param[0] }
    end

    def validate
      return if valid?

      "Invalid parameters at method `#{@klass_method.name}`, expected: `def #{description(@interface_method)}`," \
        " got: `def #{description(@klass_method)}`"
    end

    def valid?
      return true if @interface_method_parameters == [:rest]
      return true if @klass_method_parameters == [:rest]

      return true if @interface_method_parameters == @klass_method_parameters
      return false if @interface_method_parameters.size != @klass_method_parameters.size

      @interface_method_parameters.each.with_index.all? do |key, index|
        if key == :req
          %i(req opt).include? @klass_method_parameters[index]
        elsif key == :keyreq
          %i(keyreq key).include? @klass_method_parameters[index]
        end
      end
    end

    def description(m)
      m.inspect.scan(/[\.|#](\S+?\(.*?\))/).last.first
    end
  end
end