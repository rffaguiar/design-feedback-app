class Design < ActiveRecord::Base
  belongs_to :user
  has_many :spots, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :title,
    length: {maximum: 250, message: 'O título pode ter no máximo 250 caracteres.'}, allow_blank: true
  validates :subtitle,
    length: {maximum: 250, message: 'O subtítulo pode ter no máximo 250 caracteres.'}, allow_blank: true
  validates :link,
    presence: { message: 'Um link precisa ser criado para este design.' },
    uniqueness: { message: 'Este link já existe.' }
  validates :image_path, presence: { message: 'O caminho da imagem precisa ser criado para este design.' }
  validates :image_thumb_path, presence: { message: 'O caminho da imagem thumbnail precisa ser criado para este design.' }
  
  validates :user, presence: { message: 'Um usuário precisa estar associado a este design.' }

  before_save :strip_columns, :nullify_fields
  before_destroy :delete_images

  private

    # nil to fields and they respond true to empty?
    # author: rffaguiar
    # since: 1.0
    # date: 16/03/2015
    def nullify_fields
      user_fields = %W(
        title
        subtitle
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
        title
        subtitle
        link
        image_path
        image_thumb_path
      )

      user_fields.each do |field|
        next if self[field].nil?
        self[field] = self[field].strip
      end
    end

    # remove images (normal and thumbs) when an user deletes a design
    # author: rffaguiar
    # since: 1.0
    # date: 20/03/2015
    def delete_images
      File.delete(Rails.root.join('public', 'assets', 'uploads', 'designs', self.image_path ))
      File.delete(Rails.root.join('public', 'assets', 'uploads', 'designs', self.image_thumb_path ))
    end
end
