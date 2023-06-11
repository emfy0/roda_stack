# frozen_string_literal: true

module Users
  class VerifySession
    def call(input)
      session = input[:session]

      user = User[session[:user_id]]

      if user
        Success(input.merge!(user:))
      else
        Failure(:unauthorized)
      end
    end
  end
end
