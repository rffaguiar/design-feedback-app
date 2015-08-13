class Spot < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  belongs_to :design
  belongs_to :user

  validates :x_pos,
    presence: { message: 'A coordenada X é necessária para criar o spot.' },
    numericality: { message: 'A coordenada X precisa ser um valor numérico maior que 0', only_integer: true, greater_than: 0 }

  validates :y_pos,
    presence: { message: 'A coordenada Y é necessária para criar o spot.' },
    numericality: { message: 'A coordenada Y precisa ser um valor numérico maior que 0', only_integer: true, greater_than: 0 }

  validates :user_id, presence: { message: 'Um usuário precisa estar associado a este spot.' }

  validates :design,
    presence: { message: 'Um design precisa estar associado a este spot.' },
    uniqueness: { scope: [:x_pos, :y_pos], message: 'Já existe um spot nessas coordenadas para este design.' }


  before_save :clean_positions

  private

    # treat correctly these fields
    # strip: clean the borders
    # to_i: automatically round the number and transform to integer (String doesnt have a round)
    # to_s: return the number to string
    # author: rffaguiar
    # since: 1.0
    # date: 16/03/2015
    def clean_positions
      self.x_pos = self.x_pos.strip.to_i.to_s
      self.y_pos = self.y_pos.strip.to_i.to_s
    end
end
