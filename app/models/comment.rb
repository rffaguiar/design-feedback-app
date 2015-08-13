class Comment < ActiveRecord::Base
  belongs_to :spot
  belongs_to :design
  belongs_to :user

  validates :comment,
    presence: { message: 'O comentário é necessário.'},
    length: { maximum: 250, message: 'Seu comentário deve possuir no máximo 200 caracteres.' }
  validates :user, presence: { message: 'Voce precisa estar logado para comentar.'}
  validates :spot, presence: { message: 'Um Spot precisa estar associado a este comentário' }
  validates :design, presence: { message: 'Um Design precisa estar associado a este comentário' }

  before_save :strip_columns, :nullify_fields

  # check if user can delete a comment
  # author: rffaguiar
  # since: 1.0
  # date: 25/03
  def can_user_delete?(current_user = nil)
    return false if current_user.nil?


    if current_user.id == self.user.id
      # can delete - comment owner
      return true
    # this decision is up to you: to enable the design owner delete the comment
    # elsif current_user.id == self.design.user.id
    #   # can delete - design owner
    #   return true
    elsif current_user.id != self.user.id
      # 'cannot delete - user is logged, but isnt comment owner'
      return false
    else
      # can't delete - guest
      return false
    end
  end

  private

    # normalization: nil to fields and they respond true to empty?
    # author: rffaguiar
    # since: 1.0
    # date: 16/03/2015
    def nullify_fields
      user_fields = %W(
        comment
      )
      user_fields.each do |field|
        next if self[field].nil?
        self[field] = nil if self[field].empty?
      end
    end

    # normalization: remove whitespace from left and right from all listed fields
    # author: rffaguiar
    # since: 1.0
    # date: 16/03/2015
    def strip_columns
      user_fields = %W(
        comment
      )

      user_fields.each do |field|
        next if self[field].nil?
        self[field] = self[field].strip
      end
    end

end
