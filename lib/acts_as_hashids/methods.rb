require_relative 'core'

module ActsAsHashids
  module Methods
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_hashids(options = {})
        include ActsAsHashids::Core unless ancestors.include?(ActsAsHashids::Core)

        define_singleton_method :hashids_secret do
          secret = options[:secret]
          (secret.respond_to?(:call) ? instance_exec(&secret) : secret) || base_class.name
        end

        define_singleton_method :hashids do
          length = options[:length] || 8
          alphabet = options[:alphabet] || Hashids::DEFAULT_ALPHABET
          Hashids.new(hashids_secret, length, alphabet)
        end
      end
    end
  end
end
