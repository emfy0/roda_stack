# frozen_string_literal: true

class TestMailer < MailerBase
  def set_mail(subject, to, test)
    @subject = subject
    @to = to
    @test = test
  end

  # def build_mail
  #   mail = super # mail skelet
  #   @mail # mail skelet
  # end
end
