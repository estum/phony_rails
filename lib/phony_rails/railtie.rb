module PhonyRails
  class Railtie < Rails::Railtie
    # check whether it is ActiveRecord or Mongoid being used

    initializer 'phony_rails.load_extension' do
      ActiveSupport.on_load :active_record do
        include PhonyRails::Extension
      end

      ActiveSupport.on_load :mongoid do
        module Mongoid::Phony
          extend ActiveSupport::Concern
          include PhonyRails::Extension
        end
      end
    end

    initializer 'phony_rails.initialize_i18n' do |app|
      available_locales = Array(app.config.i18n.available_locales)
      pattern = available_locales.blank? ? '*' : "{#{available_locales.join ','}}"

      I18n.load_path.concat Dir[File.join(File.dirname(__FILE__), 'locales', "#{pattern}.yml")]
    end
  end
end
