require 'json'
require_relative 'csv_parser'
require_relative 'database'

class DataImporter
  def initialize(file)
    data = CsvParser.new(file).parse
    @patients = data['patients'].to_json
    @doctors = data['doctors'].to_json
    @exams = data['exams'].to_json
    @results = data['results'].to_json
  end

  def import
    @conn = Database.connect
    insert_all_patients(@patients)
    insert_all_doctors(@doctors)
    insert_all_exams(@exams)
    insert_all_results(@results)
  rescue StandardError => e
    { error: e.message }
  ensure
    @conn&.close
  end

  private

  def insert_all_patients(patients)
    patients = JSON.parse(patients, symbolize_names: true)

    query = <<~SQL
      INSERT INTO patients (cpf, name, email, birthday, address, city, state) VALUES #{parse_values(patients)}
      ON CONFLICT (cpf) DO NOTHING
    SQL

    params = patients.flat_map { |p| [p[:cpf], p[:name], p[:email], p[:birthday], p[:address], p[:city], p[:state]] }

    @conn.exec_params(query, params)
  end

  def insert_all_doctors(doctors)
    doctors = JSON.parse(doctors, symbolize_names: true)

    query = <<~SQL
      INSERT INTO doctors (crm, crm_state, name, email) VALUES #{parse_values(doctors)}
      ON CONFLICT (crm) DO NOTHING
    SQL

    params = doctors.flat_map { |p| [p[:crm], p[:crm_state], p[:name], p[:email]] }

    @conn.exec_params(query, params)
  end

  def insert_all_exams(exams)
    exams = JSON.parse(exams, symbolize_names: true)

    params = parse_exam_related_ids(exams)

    query = <<~SQL
      INSERT INTO exams (patient_id, doctor_id, token, date) VALUES #{parse_values(exams)}
      ON CONFLICT (token) DO NOTHING
    SQL

    @conn.exec_params(query, params)
  end

  def insert_all_results(results)
    results = JSON.parse(results, symbolize_names: true)

    params = parse_results_related_ids(results)

    query = <<~SQL
      INSERT INTO exam_results (exam_id, exam_type, limits, result) VALUES #{parse_values(results)}
    SQL

    @conn.exec_params(query, params)
  end

  def parse_exam_related_ids(exams)
    parsed_exams = []
    patient_ids = fetch_patients_ids(exams)
    doctor_ids = fetch_doctors_ids(exams)
    exams.each do |exam|
      patient_id = patient_ids[exam[:patient_cpf]]
      doctor_id = doctor_ids[exam[:doctor_crm]]

      parsed_exams.push(patient_id, doctor_id, exam[:token], exam[:date])
    end
    parsed_exams
  end

  def parse_results_related_ids(results)
    parsed_results = []
    exam_ids = fetch_exams_ids(results)
    results.each do |result|
      exam_id = exam_ids[result[:exam_token]]
      parsed_results.push(exam_id, result[:type], result[:limits], result[:result])
    end
    parsed_results
  end

  def fetch_patients_ids(exams)
    cpfs = "{ #{exams.map { |exam| exam[:patient_cpf] }.uniq.join(',')} }"
    result = @conn.exec_params('SELECT id, cpf FROM patients WHERE cpf = ANY($1::text[])', [cpfs])
    result.each_with_object({}) { |row, hash| hash[row['cpf']] = row['id'] }
  end

  def fetch_doctors_ids(exams)
    crms = "{ #{exams.map { |exam| exam[:doctor_crm] }.uniq.join(',')} }"
    result = @conn.exec_params('SELECT id, crm FROM doctors WHERE crm = ANY($1::text[])', [crms])
    result.each_with_object({}) { |row, hash| hash[row['crm']] = row['id'] }
  end

  def fetch_exams_ids(results)
    results = "{ #{results.map { |result| result[:exam_token] }.uniq.join(',')} }"
    result = @conn.exec_params('SELECT id, token FROM exams WHERE token = ANY($1::text[])', [results])
    result.each_with_object({}) { |row, hash| hash[row['token']] = row['id'] }
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
