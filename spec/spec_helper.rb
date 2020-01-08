require 'rspec'
require 'pg'
require 'doctor'
require 'patient'
require 'pry'

# Shared code for clearing tests between runs and connecting to the DB will also go here.
DB = PG.connect({:dbname => 'doctor_office_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM doctors *;")
    DB.exec("DELETE FROM patients *;")
  end
end
