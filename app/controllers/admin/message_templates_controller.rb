class Admin::MessageTemplatesController < AdminController
=begin
  def index
  end
=end

#  before_filter :configure_new_template_params, only: [:create]

  def new
    @template = MessageTemplate.new
    @subjects = MessageSubject.main_subjects
  end

  def create
    set_subject
    set_sub_subject
    @template = @sub_subject.message_templates.build(message_template_params)

    if @template.save
      redirect_to admin_message_templates_path, notice: 'Message template was successfully created.'
    else
      redirect_to new_admin_message_template_path, notice: 'There are errors creating the message templates.'
    end
  end

  def upload_template
  end

  def edit_filters
    get_all_main_subjects
  end

  private

  def set_subject
    if params[:parent_subject_id].present?
      @subject = MessageSubject.find params[:parent_subject_id]
    else
      @subject = MessageSubject.create(title: params[:parent_subject_text])
    end
  end

  def set_sub_subject
    if params[:message_template][:sub_subject_id].present?
      @sub_subject = @subject.sub_subjects.find(params[:message_template][:sub_subject_id])
    else
      @sub_subject = @subject.sub_subjects.create(title: params[:sub_subject_text])
    end
  end

  def get_all_main_subjects
    @subjects = MessageSubject.main_subjects
  end

  def message_template_params
    params.require(:message_template).permit(
      :sub_subject_id,
      :target_role,
      :content
    )
  end

=begin
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
    set_possible_subjects
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

  def set_possible_subjects
    @subjects = Subject.active
  end
=end
end
