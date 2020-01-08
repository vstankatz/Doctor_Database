require('sinatra')
require('sinatra/reloader')
require('./lib/doctor')
require('pry')
require("pg")

also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => "doctor_office"})

get('/') do
  @doctors = Doctor.all
  erb(:doctors_home)
end

get('/doctors_home') do
  @doctors = Doctor.all
  erb(:doctors_home)
end

get('/doctors_home/add_doctor') do
  erb(:add_doctor)
end

post('/doctors_home') do
  name = params[:add_doctor]
  specialty = params[:add_specialty]
  doctor = Doctor.new(:name => name, :specialty => specialty, :id => nil)
  doctor.save()
  @doctors = Doctor.all
  erb(:doctors_home)
end

get('/doctors_home/:id') do
  @doctor = Doctor.find(params[:id].to_i())
  erb(:doctor)
end

get('/doctors_home/:id/edit_doctor') do
  @doctor = Doctor.find(params[:id].to_i())
  erb(:edit_doctor)
end

patch('/doctors_home/:id') do
  @doctor = Doctor.find(params[:id].to_i())
  name = params[:edit_name]
  specialty = params[:edit_specialty]
  @doctor.update(:name => params[:edit_name], :specialty => params[:edit_specialty])
  @doctors = Doctor.all
  erb(:doctors_home)
end

delete('/doctors_home/:id') do
  @doctor = Doctor.find(params[:id].to_i())
  @doctor.delete()
  @doctors = Doctor.all
  erb(:doctors_home)
end
