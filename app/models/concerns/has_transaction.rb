module HasTransaction
    extend ActiveSupport::Concern

    included do
        has_many :transactions

        def total_deposit_amount
            transactions.where(deposit: true).sum(:amount)
        end
    end
end