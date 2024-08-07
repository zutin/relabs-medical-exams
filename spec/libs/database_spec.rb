require 'spec_helper'
require 'database'

RSpec.describe 'Database' do
  describe '#connect' do
    it 'successfully connects to the database' do
      expect(Database.connect).to be_a(PG::Connection)
    end
  end

  describe '#create' do
    it 'creates the patients table successfully' do
      Database.create
      conn = Database.connect
      expect(conn.exec('SELECT COUNT(*) FROM patients')).to be_a(PG::Result)
      Database.drop
    end

    it 'creates the doctors table successfully' do
      Database.create
      conn = Database.connect
      expect(conn.exec('SELECT COUNT(*) FROM doctors')).to be_a(PG::Result)
      Database.drop
    end

    it 'creates the exams table successfully' do
      Database.create
      conn = Database.connect
      expect(conn.exec('SELECT COUNT(*) FROM exams')).to be_a(PG::Result)
      Database.drop
    end

    it 'creates the exam_types table successfully' do
      Database.create
      conn = Database.connect
      expect(conn.exec('SELECT COUNT(*) FROM exam_types')).to be_a(PG::Result)
      Database.drop
    end
  end

  describe '#drop' do
    it 'drops the patients table successfully' do
      Database.create
      Database.drop
      conn = Database.connect
      expect { conn.exec('SELECT COUNT(*) FROM patients') }.to raise_error(PG::UndefinedTable)
    end

    it 'drops the doctors table successfully' do
      Database.create
      Database.drop
      conn = Database.connect
      expect { conn.exec('SELECT COUNT(*) FROM doctors') }.to raise_error(PG::UndefinedTable)
    end

    it 'drops the exams table successfully' do
      Database.create
      Database.drop
      conn = Database.connect
      expect { conn.exec('SELECT COUNT(*) FROM exams') }.to raise_error(PG::UndefinedTable)
    end

    it 'drops the exam_types table successfully' do
      Database.create
      Database.drop
      conn = Database.connect
      expect { conn.exec('SELECT COUNT(*) FROM exam_types') }.to raise_error(PG::UndefinedTable)
    end
  end
end
