CREATE TABLE IF NOT EXISTS patients (
  id serial PRIMARY KEY,
  cpf VARCHAR(14) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  birthday DATE NOT NULL,
  address VARCHAR(100) NOT NULL,
  city VARCHAR(100) NOT NULL,
  state VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS doctors (
  id serial PRIMARY KEY,
  crm VARCHAR(10) UNIQUE NOT NULL,
  crm_state VARCHAR(2) NOT NULL,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS exams (
  id serial PRIMARY KEY,
  patient_id INTEGER REFERENCES patients(id),
  doctor_id INTEGER REFERENCES doctors(id),
  token VARCHAR(10) UNIQUE NOT NULL,
  date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS exam_results (
  id serial PRIMARY KEY,
  exam_id INTEGER REFERENCES exams(id),
  exam_type VARCHAR(100) NOT NULL,
  limits VARCHAR(100) NOT NULL,
  result VARCHAR(100) NOT NULL
);

CREATE INDEX idx_patients_cpf ON patients(cpf);
CREATE INDEX idx_doctors_crm ON doctors(crm);
CREATE INDEX idx_exams_token ON exams(token);
