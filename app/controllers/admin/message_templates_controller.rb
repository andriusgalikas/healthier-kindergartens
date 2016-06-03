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
      render :new
    end
  end

  def upload_template
  end

  private

  def set_subject
    if params[:parent_subject_id].present?
      @subject = MessageSubject.find params[:parent_subject_id]
    elsif params[:parent_subject_text].present?
      @subject = MessageSubject.create(title: params[:parent_subject_text])
    else
      render :new, notice: 'Please choose a subject.'
    end
  end

  def set_sub_subject
    if params[:message_template][:sub_subject_id].present?
      @sub_subject = @subject.sub_subjects.find(params[:message_template][:sub_subject_id])
    elsif params[:sub_subject_text].present?
      @sub_subject = @subject.sub_subjects.create(title: params[:sub_subject_text])
    else
      render :new, notice: 'Please choose a sub-subject.'
    end
  end

=begin
  def configure_new_template_params
    params.permit(
      :parent_subject_id,
      :parent_subject_text,
      :sub_subject_text,
      message_template: [
        :sub_subject_id,
        :target_role,
        :content
      ]
    )
  end

  def message_subject_params
    params.permit(:parent_subject_text)
  end

  def message_sub_subject_params
    params.permit(:sub_subject_text)
  end
=end
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
