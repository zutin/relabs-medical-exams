require_relative 'database'
require_relative 'data_importer'

class ApiController
  def tests
    @conn = Database.connect
    exams = retrieve_exams

    exams.group_by { |exam| exam['token'] }.map do |_index, rows|
      parse_exam(rows)
    end
  rescue StandardError => e
    { error: e.message }
  ensure
    @conn&.close
  end

  def test(token)
    @conn = Database.connect
    exam = retrieve_exam_by_token(token)
    return nil if exam.ntuples.zero?

    parse_exam(exam)
  rescue StandardError => e
    { error: e.message }
  ensure
    @conn&.close
  end

  private

  def retrieve_exams
    query = <<-SQL
      SELECT exams.token, exams.date, patients.cpf, patients.name as patient_name, patients.email, patients.birthday,
      doctors.crm, doctors.crm_state, doctors.name as doctor_name, exam_results.exam_type, exam_results.limits,
      exam_results.result FROM exams INNER JOIN patients ON exams.patient_id = patients.id
      INNER JOIN doctors ON exams.doctor_id = doctors.id LEFT JOIN exam_results ON exams.id = exam_results.exam_id
    SQL

    @conn.exec(query)
  rescue PG::Error => e
    { error: "Database error: #{e.message}" }
  end

  def retrieve_exam_by_token(token)
    query = <<~SQL
      SELECT exams.token, exams.date, patients.cpf, patients.name as patient_name, patients.email, patients.birthday,
      doctors.crm, doctors.crm_state, doctors.name as doctor_name, exam_results.exam_type, exam_results.limits,
      exam_results.result FROM exams INNER JOIN patients ON exams.patient_id = patients.id
      INNER JOIN doctors ON exams.doctor_id = doctors.id LEFT JOIN exam_results ON exams.id = exam_results.exam_id
      WHERE exams.token = $1
    SQL

    @conn.exec_params(query, [token])
  rescue PG::Error => e
    { error: "Database error: #{e.message}" }
  end

  def parse_exam(data)
    exam = data.first
    {
      result_token: exam['token'], result_date: exam['date'],
      cpf: exam['cpf'], name: exam['patient_name'], email: exam['email'], birthday: exam['birthday'],
      doctor: { crm: exam['crm'], crm_state: exam['crm_state'], name: exam['doctor_name'] },
      tests: data.map { |result| { type: result['exam_type'], limits: result['limits'], result: result['result'] } }
    }
  rescue StandardError
    { error: 'No exams were provided to parse' }
  end
end
