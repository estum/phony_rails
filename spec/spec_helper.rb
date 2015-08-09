require 'coveralls'
Coveralls.wear!

ENV["RAILS_ENV"] ||= "test"
ENV['DATABASE_URL'] ||= 'sqlite3::memory:'

require File.expand_path("../dummy/config/environment", __FILE__)
I18n.config.enforce_available_locales = true

ActiveRecord::Schema.define do
  create_table :active_record_models do |table|
    table.column :phone_attribute, :string
    table.column :phone_number, :string
    table.column :phone_number_as_normalized, :string
    table.column :fax_number, :string
  end
end

module SharedModelMethods
  extend ActiveSupport::Concern
  included do
    attr_accessor :phone_method, :phone1_method, :country_code
    phony_normalized_method :phone_attribute # adds normalized_phone_attribute method
    phony_normalized_method :phone_method # adds normalized_phone_method method
    phony_normalized_method :phone1_method, :default_country_code => 'DE' # adds normalized_phone_method method
    phony_normalize :phone_number # normalized on validation
    phony_normalize :fax_number, :default_country_code => 'AU'
  end
end

class ActiveRecordModel < ActiveRecord::Base
  include SharedModelMethods
end

class RelaxedActiveRecordModel < ActiveRecord::Base
  self.table_name = 'active_record_models'
  attr_accessor :phone_number, :country_code

  phony_normalize :phone_number, :enforce_record_country => false
end

class ActiveRecordDummy < ActiveRecordModel
end

class MongoidModel
  include Mongoid::Document
  include Mongoid::Phony
  field :phone_attribute, :type => String
  field :phone_number,    :type => String
  field :phone_number_as_normalized, :type => String
  field :fax_number
  include SharedModelMethods
end

class MongoidDummy < MongoidModel
end

RSpec.configure do |config|
  # some (optional) config here
end