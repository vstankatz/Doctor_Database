class Doctor
  attr_accessor :name, :specialty
  attr_reader :id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @specialty = attributes.fetch(:specialty)
    @id = attributes.fetch(:id)
  end

  def save()
    result = DB.exec("INSERT INTO doctors (name, specialty) VALUES ('#{@name}', '#{@specialty}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def self.all
    returned_doctors = DB.exec("SELECT * FROM doctors;")
    doctors = []
    returned_doctors.each() do |doctor|
      name = doctor.fetch("name")
      id = doctor.fetch("id").to_i
      specialty = doctor.fetch("specialty")

      doctors.push(Doctor.new({:name => name, :specialty => specialty, :id => id}))
    end
    doctors
  end

  def ==(doctor_to_compare)
    self.name().downcase().eql?(doctor_to_compare.name.downcase()) && self.specialty().downcase().eql?(doctor_to_compare.specialty.downcase())
  end

  def self.clear
    DB.exec("DELETE FROM doctors *;")
  end

  def self.find(id)
    doctor = DB.exec("SELECT * FROM doctors WHERE id = #{id};").first
    name = doctor.fetch("name")
    id = doctor.fetch("id").to_i
    specialty = doctor.fetch("specialty").to_i
    Doctor.new({:name => name, :id => id, :specialty => specialty})
  end

  def patients
    Patient.find_by_doctor(self.id)
  end

  def update(attributes)
    @name = attributes.fetch(:name)
    @specialty = attributes.fetch(:specialty)

    DB.exec("UPDATE doctors SET name = '#{@name}', specialty = '#{@specialty}' WHERE id = #{@id};")

  end

  def delete
    DB.exec("DELETE FROM doctors WHERE id = #{@id};")
    # DB.exec("DELETE FROM patients WHERE doctor_id = #{@id};")
  end


end
