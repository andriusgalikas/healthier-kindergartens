class Admin::MessageTemplatesController < AdminController

  def index
    @templates = MessageTemplate.active
  end

  def new
    @template = MessageTemplate.new
  end

  def create
    @template = MessageTemplate.new(template_params)

    if @template.save
      redirect_to admin_message_templates_url, notice: 'Message template was successfully created.'
    else
      render :new
    end
  end

  def edit
    set_message_template
  end

  def update
    set_message_template

    if @template.update(template_params)
      redirect_to admin_message_templates_url, notice: 'Message template was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    set_message_template
    @template.deactivate!

    redirect_to admin_message_templates_url, notice: 'Message template was successfully destroyed.'
  end

  private

  def template_params
    params.require(:message_template).permit(:main_subject, :sub_subject, :target_role, :content)
  end

  def set_message_template
    @template = MessageTemplate.find(params[:id])
  end

end
