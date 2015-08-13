class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable and :validatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  has_many :designs, dependent: :destroy, inverse_of: :user
  has_many :spots, dependent: :destroy, inverse_of: :user
  has_many :comments, dependent: :destroy, inverse_of: :user

  validates :name,
    presence: { message: 'O nome é obrigatório.' },
    length: { minimum: 1, maximum: 200, message: 'O nome deve conter entre 1 e 200 caracteres' }

  validates :email,
    presence: { message: 'O email é obrigatório.' },
    length: { minimum: 10, maximum: 200, message: 'O email deve conter entre 10 e 200 caracteres' },
    uniqueness: { message: 'Este email já está cadastrado. Escolha outro.'}

  validates :password,
              presence: {message: 'deve ser preenchido.'},
              length: {minimum: 8, message: 'deve ter no mínimo 8 caracteres'},
              confirmation: {message: 'Campos Senha e Confirmação de Senha devem ser iguais.'},
              on: :create

  validates :password,
              presence: { message: 'A senha é obrigatória.' },
              length: { minimum: 8, maximum: 30, message: 'A senha deve conter entre 8 e 30 caracteres' },
              confirmation: {message: 'Campos Senha e Confirmação de Senha devem ser iguais.'},
              on: :update,
              if: lambda{ !password.blank? }

   before_save :strip_columns, :downcase_columns, :nullify_fields

  private

    # nil to fields and they respond true to empty?
    # author: rffaguiar
    # since: 1.0
    # date: 16/03/2015
    def nullify_fields
      user_fields = %W(
        name
        email
        address
      )

      user_fields.each do |field|
        next if self[field].nil?
        self[field] = nil if self[field].empty?
      end
    end

    # remove whitespace from left and right
    # author: rffaguiar
    # since: 1.0
    # date: 16/03/2015
    def strip_columns
      user_fields = %W(
        name
        email
        address
      )

      user_fields.each do |field|
        next if self[field].nil?
        self[field] = self[field].strip
      end
    end

    # as the name says
    # author: rffaguiar
    # since: 1.0
    # date: 16/03/2015
    def downcase_columns
      return if self.email.nil?
      self.email = self.email.downcase
    end
end
