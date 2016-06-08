module Admin::MessageTemplateHelper

  def options_for_sub_subject_select
    @subjects.map(&:sub_subjects)
      .flatten
      .map{|sub| [sub.title, sub.id, {'data-parent_id': sub.parent_subject_id, style: 'display: none;'}]}
  end

  def create_template_header
    t('admin.message') + ' > ' + t('admin.create_template') + ' :'
  end

  def edit_template_header
    t('admin.message') + ' > ' + t('admin.edit_template') + ' : '
  end

  def yield_js_translations
    trans = {}
    trans['no_template_for_role'] = I18n.t('admin.no_template_for_role')

    trans
  end

end
