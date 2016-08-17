class CollaborationMailerPreview < ActionMailer::Preview

  def invite
    set_email
    CollaborationMailer.invite(@email)
  end

  private

  def set_email
    @email = Faker::Internet.email
  end

end
