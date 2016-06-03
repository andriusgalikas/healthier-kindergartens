module Admin::MessageTemplateHelper

  def message_template_roles
    MessageTemplate::ALLOWED_TARGET_ROLES
  end

end
