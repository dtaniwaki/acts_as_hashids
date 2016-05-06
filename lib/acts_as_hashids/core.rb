require 'hashids'

module ActsAsHashids
  module Core
    extend ActiveSupport::Concern

    def to_param
      id = public_send(self.class.primary_key)
      id && self.class.hashids.encode(id)
    end

    module FinderMethods
      def find(ids = nil, &block)
        return detect(&block) if block.present? && respond_to?(:detect)

        encoded_ids = Array(ids).map { |id| id.is_a?(String) ? id : hashids.encode(id) }.flatten
        res = with_hashids(encoded_ids).all
        if ids.is_a?(Array)
          raise_record_not_found_exception! encoded_ids, res.size, encoded_ids.size if res.size != encoded_ids.size
        else
          raise_record_not_found_exception! encoded_ids[0], res.size, encoded_ids.size if res.empty?
          res = res[0]
        end
        res
      end

      private

      def raise_record_not_found_exception!(ids, result_size, expected_size)
        if Array(ids).size == 1
          error = "Couldn't find #{name} with '#{primary_key}'=#{ids.inspect}"
        else
          error = "Couldn't find all #{name.pluralize} with '#{primary_key}': "
          error << "(#{ids.map(&:inspect).join(', ')}) (found #{result_size} results, but was looking for #{expected_size})"
        end

        raise ActiveRecord::RecordNotFound, error
      end
    end

    module ClassMethods
      include FinderMethods

      def with_hashids(*ids)
        ids = ids.flatten
        decoded_ids = ids.map { |id| hashids.decode(id) }.flatten
        raise ActsAsHashids::Exception, "Decode error: #{ids.inspect}" if ids.size != decoded_ids.size

        where(primary_key => decoded_ids)
      end

      def has_many(*args, &block) # rubocop:disable Style/PredicateName
        options = args.extract_options!
        options[:extend] = (options[:extend] || []).concat([FinderMethods])
        super(*args, options, &block)
      end

      def relation
        r = super
        r.extend FinderMethods
        r
      end
    end
  end
end
