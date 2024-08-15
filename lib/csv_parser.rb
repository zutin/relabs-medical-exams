require 'csv'

class CsvParser
  def initialize(file)
    @file = file.is_a?(String) && file.include?(';') ? file : File.read(file)
  end

  def parse
    rows = CSV.parse(@file, col_sep: ';', headers: true)
    data = { 'patients' => [], 'doctors' => [], 'exams' => [], 'results' => [] }

    rows.map do |row|
      process_patient(data, row)
      process_doctor(data, row)
      process_exams(data, row)
      process_results(data, row)
    end

    data
  end

  private

  def process_patient(data, row)
    patient = parse_patient(row)
    data['patients'] << patient unless find_patient(data['patients'], patient)
  end

  def process_doctor(data, row)
    doctor = parse_doctor(row)
    data['doctors'] << doctor unless find_doctor(data['doctors'], doctor)
  end

  def process_exams(data, row)
    exam = parse_exam(row)

    data['exams'] << exam unless find_exam(data['exams'], exam)
  end

  def process_results(data, row)
    result = parse_result(row)
    data['results'] << result
  end

  def find_patient(data, patient)
    data.find { |ptt| ptt['cpf'] == patient['cpf'] }
  end

  def find_doctor(data, doctor)
    data.find { |doc| doc['crm'] == doctor['crm'] }
  end

  def find_exam(exams, exam)
    exams.find { |ex| ex['token'] == exam['token'] }
  end

  def parse_patient(row)
    {
      'cpf' => row[0],
      'name' => row[1],
      'email' => row[2],
      'birthday' => row[3],
      'address' => row[4],
      'city' => row[5],
      'state' => row[6]
    }
  end

  def parse_doctor(row)
    {
      'crm' => row[7],
      'crm_state' => row[8],
      'name' => row[9],
      'email' => row[10]
    }
  end

  def parse_exam(row)
    {
      'patient_cpf' => row[0],
      'doctor_crm' => row[7],
      'token' => row[11],
      'date' => row[12]
    }
  end

  def parse_result(row)
    {
      'exam_token' => row[11],
      'type' => row[13],
      'limits' => row[14],
      'result' => row[15]
    }
  end
end
