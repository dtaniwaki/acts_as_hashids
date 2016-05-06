require 'acts_as_hashids/methods'

module ActsAsHashids
  class Railtie < Rails::Railtie
    initializer 'acts_as_hashids.include_methods' do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:include, ActsAsHashids::Methods)
      end
    end
  end
end
