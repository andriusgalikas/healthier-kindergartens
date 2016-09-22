# == Schema Information
#
# Table name: todos
#
#  id                    :integer          not null, primary key
#  title                 :string
#  iteration_type        :integer          default("0")
#  frequency             :integer          default("0")
#  daycare_id            :integer
#  user_id               :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  completion_date_type  :integer          default("0")
#  completion_date_value :integer          default("1")
#

require 'rails_helper'

RSpec.describe Todo, type: :model do

    describe "#global? method" do

        context "if todo has an associated daycare" do
            let(:daycare) { create(:daycare) }
            let(:todo) { create(:single_todo, daycare: daycare) }

            it "should return false" do
                expect(todo.global?).to eq false
            end
        end

        context "if todo has no associated daycare" do
            let(:todo) { create(:single_todo, daycare: nil, user: create(:admin_user)) }

            it "should return true" do
                expect(todo.global?).to eq true
            end
        end
    end

    describe "#frequency_to_time method" do
        let(:day_todo) { create(:recurring_todo, frequency: 'day') }
        let(:week_todo) { create(:recurring_todo, frequency: 'week') }
        let(:month_todo) { create(:recurring_todo, frequency: 'month') }
        let(:year_todo) { create(:recurring_todo, frequency: 'year') }

        it "should return the correct datetime for the frequency" do
            expect(day_todo.frequency_to_time).to eq 1.days.ago.to_date
            expect(week_todo.frequency_to_time).to eq 7.days.ago.to_date
            expect(month_todo.frequency_to_time).to eq 1.month.ago.to_date
            expect(year_todo.frequency_to_time).to eq 1.year.ago.to_date
        end
    end
end
