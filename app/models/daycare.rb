# == Schema Information
#
# Table name: daycares
#
#  id            :integer          not null, primary key
#  name          :string
#  address_line1 :string
#  postcode      :string
#  country       :string
#  telephone     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Daycare < ActiveRecord::Base
    has_many :departments,                              dependent: :destroy
    has_many :children,                                 through: :departments
    has_many :user_daycares
    has_many :users,                                    through: :user_daycares
    has_many :parents,                                  -> { (where(role: 0)) }, through: :user_daycares, source: :user
    has_many :workers,                                  -> { (where(role: 1)) }, through: :user_daycares, source: :user
    has_many :managers,                                 -> { (where(role: 2)) }, through: :user_daycares, source: :user

    has_many :survey_subjects
    has_many :surveys,                                  through: :survey_subjects

    # Dashboard relations
    has_many :local_todos,                              class_name: 'Todo'

    # Reporting relations
    has_many :local_completed_todos,                    -> { complete }, class_name: 'Todo'
    has_many :local_incomplete_todos,                   -> { incomplete }, class_name: 'Todo'
    has_many :local_available_todos,                    -> { available }, class_name: 'Todo'

    # Dashboard relations
    has_many :global_todos,                             through: :departments, source: :todos

    # Reporting relations
    has_many :global_completed_todos,                   -> { complete }, through: :departments, source: :todos
    has_many :global_incomplete_todos,                  -> { incomplete }, through: :departments, source: :todos
    has_many :global_available_todos,                   -> { available }, through: :departments, source: :todos

    validates :name, :address_line1, :postcode,
                :country, :telephone,                   presence: true

    validates :departments,                             presence: true

    scope :search,                                              ->(query, page, per_page_count, limit_count) { where("name LIKE :search", search: "%#{query}%").limit(limit_count).page(page).per(per_page_count) }

    accepts_nested_attributes_for :departments, :user_daycares, allow_destroy: true               

    def active_subscription?
        managers.map(&:subscribed?).include?(true) || managers.map(&:active_trial?).include?(true) ? true : false
    end

    def all_completed_todos
        (global_completed_todos + local_completed_todos).uniq
    end

    def all_incomplete_todos
        (global_incomplete_todos + local_incomplete_todos).uniq
    end

    def all_available_todos
        (global_available_todos + local_available_todos).uniq
    end

    def all_todos
        (global_todos + local_todos).uniq
    end
end