require_relative 'csv_parser'
require_relative 'database'

class DataImporter
  def initialize(file)
    data = JSON.parse(CsvParser.new(file).parse)
    @patients = data['patients'].to_json
    @doctors = data['doctors'].to_json
    @exams = data['exams'].to_json
  end

  def import
    insert_all_patients(@patients)
    insert_all_doctors(@doctors)
  end

  private

  def insert_all_patients(patients)
    patients = JSON.parse(patients, symbolize_names: true)

    query = <<~SQL
      INSERT INTO patients (cpf, name, email, birthday, address, city, state) VALUES #{parse_values(patients)}
      ON CONFLICT (cpf) DO NOTHING
    SQL

    params = patients.flat_map { |p| [p[:cpf], p[:name], p[:email], p[:birthday], p[:address], p[:city], p[:state]] }

    conn = Database.connect
    conn.exec_params(query, params)
    conn.close
  end

  def insert_all_doctors(doctors)
    doctors = JSON.parse(doctors, symbolize_names: true)

    query = <<~SQL
      INSERT INTO doctors (crm, crm_state, name, email) VALUES #{parse_values(doctors)}
      ON CONFLICT (crm) DO NOTHING
    SQL

    params = doctors.flat_map { |p| [p[:crm], p[:crm_state], p[:name], p[:email]] }

    conn = Database.connect
    conn.exec_params(query, params)
    conn.close
  end

  def parse_values(data)
    size = data.first.length
    data.length.times.map do |i|
      query = '('
      size.times do |s|
        query << "$#{(size * i) + s + 1}, "
      end
      query.chop.chop << ')'
    end.join(', ')
  end
end
