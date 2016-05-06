module ActsAsHashids
  class Exception < ::Exception; end
end

require 'acts_as_hashids/version'

if defined?(Rails::Railtie)
  require 'acts_as_hashids/railtie'
elsif defined?(ActiveRecord)
  require 'acts_as_hashids/methods'
  ActiveRecord::Base.send(:include, ActsAsHashids::Methods)
end
