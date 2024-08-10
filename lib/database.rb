require 'pg'

class Database
  def self.connect
    host = ENV['DATABASE_URL'] || 'db'
    PG.connect(host:, dbname: 'medical-exams', user: 'postgres', password: 'postgres')
  end

  def self.create
    conn = Database.connect
    create_patients_table(conn)
    create_doctors_table(conn)
    create_exams_table(conn)
    create_exam_types_table(conn)
    conn.close
  end

  def self.drop
    conn = Database.connect
    conn.exec('DROP TABLE IF EXISTS exam_types')
    conn.exec('DROP TABLE IF EXISTS exams')
    conn.exec('DROP TABLE IF EXISTS doctors')
    conn.exec('DROP TABLE IF EXISTS patients')
    conn.close
  end
end

private

def create_patients_table(conn)
  conn.exec('CREATE TABLE IF NOT EXISTS patients (
    id serial PRIMARY KEY,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    birthday DATE NOT NULL,
    address VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL
  )')
end

def create_doctors_table(conn)
  conn.exec('CREATE TABLE IF NOT EXISTS doctors (
    id serial PRIMARY KEY,
    crm VARCHAR(10) UNIQUE NOT NULL,
    crm_state VARCHAR(2) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
  )')
end

def create_exams_table(conn)
  conn.exec('CREATE TABLE IF NOT EXISTS exams (
    id serial PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id),
    doctor_id INTEGER REFERENCES doctors(id),
    token VARCHAR(10) UNIQUE NOT NULL,
    date DATE NOT NULL
  )')
end

def create_exam_types_table(conn)
  conn.exec('CREATE TABLE IF NOT EXISTS exam_types (
    id serial PRIMARY KEY,
    exam_id INTEGER REFERENCES exams(id),
    type_name VARCHAR(100) NOT NULL,
    limits VARCHAR(100) NOT NULL,
    result VARCHAR(100) NOT NULL
  )')
end
