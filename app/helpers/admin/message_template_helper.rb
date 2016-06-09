module Admin::MessageTemplateHelper

  def options_for_sub_subject_select
    @subjects.map(&:sub_subjects)
      .flatten
      .map{|sub| [sub.title, sub.id, {'data-parent_id': sub.parent_subject_id}]}
  end

  def edit_template_header
    t('admin.breadcrumb.edit_template') + ' : '
  end

  def choose_template_header
    "#{t('admin.breadcrumb.message')} > #{t('admin.breadcrumb.choose_template')} : "
  end

  def add_subject_header
    "#{t('admin.breadcrumb.message')} > #{t('admin.breadcrumb.create_template')} > #{t('admin.breadcrumb.create_subject')} : "
  end

  def add_sub_subject_header
    "#{t('admin.breadcrumb.message')} > #{t('admin.breadcrumb.create_template')} > #{t('admin.breadcrumb.create_subject')} > #{t('admin.breadcrumb.create_sub_subject')}  "
  end

  def add_recipient_header
    "#{t('admin.breadcrumb.message')} > #{t('admin.breadcrumb.create_template')} > #{t('admin.breadcrumb.create_subject')} > #{t('admin.breadcrumb.create_sub_subject')} > #{t('admin.breadcrumb.choose_recipient')} :"
  end

  def add_template_content_header
    "#{t('admin.breadcrumb.message')} > ... > #{t('admin.breadcrumb.choose_recipient')} > #{t('admin.breadcrumb.add_content')} :"
  end


  def yield_js_translations
    trans = {}
    trans['no_template_for_role'] = I18n.t('admin.no_template_for_role')

    trans
  end

  def progress_bar_step(page_step, form_step)
    page_step > form_step ? 'complete' : page_step == form_step ? 'active' : 'disabled'
  end

end
