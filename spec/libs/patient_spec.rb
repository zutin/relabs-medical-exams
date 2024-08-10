require 'spec_helper'

RSpec.describe 'Patient' do
  describe '.save' do
    it 'saves a patient to the database' do
      patient = Patient.new(cpf: '12345678901', name: 'John Doe', email: 'test@test.com', birthday: '2000-01-01',
                            address: '123 Main St', city: 'Springfield', state: 'IL')
      patient.save

      data = Patient.find_by_cpf('12345678901')
      expect(data[:cpf]).to eq('12345678901')
    end
  end

  describe '.find_by_cpf' do
    it 'finds a patient by cpf' do
      patient = Patient.new(cpf: '12345678901', name: 'John Doe', email: 'test@test.com', birthday: '2000-01-01',
                            address: '123 Main St', city: 'Springfield', state: 'IL')
      patient.save

      data = Patient.find_by_cpf('12345678901')
      expect(data[:name]).to eq('John Doe')
    end

    it 'returns nil if the patient is not found' do
      data = Patient.find_by_cpf('12345678901')
      expect(data).to be_nil
    end
  end

  describe '.all' do
    it 'returns all patients' do
      patient = Patient.new(cpf: '12345678901', name: 'John Doe', email: 'test@test.com', birthday: '2000-01-01',
                            address: '123 Main St', city: 'Springfield', state: 'IL')
      patient.save

      data = Patient.all
      expect(data.size).to eq(1)
    end

    it 'returns an empty array if there are no patients' do
      data = Patient.all
      expect(data).to eq([])
    end
  end
end
