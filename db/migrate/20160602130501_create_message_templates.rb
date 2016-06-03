class CreateMessageTemplates < ActiveRecord::Migration
  def change
    create_table :message_templates do |t|
      t.string   :main_subject
      t.string   :sub_subject
      t.integer  :target_role
      t.string   :content
      t.datetime :deactivated_at

      t.timestamps null: false
    end
  end
end
