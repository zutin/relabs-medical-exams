class Patient
  attr_accessor :cpf, :name, :email, :birthday, :address, :city, :state

  def initialize(attribute = {})
    @cpf = attribute[:cpf]
    @name = attribute[:name]
    @email = attribute[:email]
    @birthday = attribute[:birthday]
    @address = attribute[:address]
    @city = attribute[:city]
    @state = attribute[:state]
  end

  def save
    conn = Database.connect
    conn.exec_params(
      'INSERT INTO patients (cpf, name, email, birthday, address, city, state) VALUES ($1, $2, $3, $4, $5, $6, $7)
                      ON CONFLICT (cpf) DO NOTHING
                      RETURNING id',
      [cpf, name, email, birthday, address, city, state]
    )
    conn.close
  rescue StandardError => e
    puts e.message
  end

  def self.find_by_cpf(cpf)
    conn = Database.connect
    data = conn.exec('SELECT * FROM patients WHERE cpf = $1 LIMIT 1', [cpf])
    conn.close

    parse_patient(data.first)
  rescue StandardError
    nil
  end

  def self.all
    conn = Database.connect
    data = conn.exec('SELECT * FROM patients')
    conn.close

    data.map do |row|
      parse_patient(row)
    end
  end

  def self.parse_patient(data)
    {
      id: data['id'],
      cpf: data['cpf'],
      name: data['name'],
      email: data['email'],
      birthday: data['birthday'],
      address: data['address'],
      city: data['city'],
      state: data['state']
    }
  end

  private_class_method :parse_patient
end
