# require "copycat/engine"
require "copycat/implementation"
require "copycat/routes"
require "copycat/simple"
require 'copycat'
require 'phrasing/phrasable_error_handler'
require 'phrasing/blacklisted_attribute_error'
require 'bootstrap-editable-rails'

module Phrasing
  module Rails
    class Engine < ::Rails::Engine
      initializer :assets, :group => :all do
        ::Rails.application.config.assets.precompile += %w(copycat_engine.css)
      end
      initializer "phrasing" do
        ActiveSupport.on_load(:action_controller) do
          # ActionController::Base.send(:include, PhrasableErrorHandler)
        end
        ::ActiveSupport.on_load(:action_view) do
          ::ActionView::Base.send :include, Bootstrap::Editable::Rails::ViewHelper
        end
      end
    end
  end
end


module Phrasing
  
  mattr_accessor :allow_update_on_all_models_and_attributes
  mattr_accessor :username
  mattr_accessor :password
  mattr_accessor :route
  mattr_accessor :everything_is_html_safe
  mattr_accessor :staging_server_endpoint

  @@route = 'copycat_translations'
  @@everything_is_html_safe = false

  def self.setup
    yield self
  end

  WHITELIST = "CopycatTranslation.value"
  
  def self.whitelist
    if defined? @@whitelist
      @@whitelist + [WHITELIST]
    else
      [WHITELIST]
    end
  end

  def self.whitelist=(whitelist)
    @@whitelist = whitelist
  end

  def self.is_whitelisted?(klass,attribute)
    allow_update_on_all_models_and_attributes == true or whitelist.include? "#{klass}.#{attribute}"
  end

end