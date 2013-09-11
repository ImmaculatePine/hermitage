module Hermitage

  class Configurator

    Defaults.constants.each do |c|
      define_method c.downcase do |value|
        @config.merge!({ c.downcase.to_sym => value })
      end
    end

    def respond_to?(method_name)
      Defaults.constants.include? method_name.upcase.to_sym || super
    end

    def initialize(config_name, &block)
      Hermitage.configs[config_name] ||= {}
      @config = Hermitage.configs[config_name]
      self.instance_eval(&block) if block_given?
    end
  end

end