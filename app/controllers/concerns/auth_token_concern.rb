module AuthTokenConcern
  extend ActiveSupport::Concern

  private

  def auth_token
    binding.pry

    token = header['Authorization']
    unless token.present?
      raise BooksException,
            'Authorization required'
    end
    @current_user = User.find_by(token: token)

    raise BooksException, 'invalid Authorization' unless @current_user.present?
  end
end
