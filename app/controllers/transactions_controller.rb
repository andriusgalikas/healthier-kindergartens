class TransactionsController < ApplicationController
  def create
    @subscription = Subscription.find(params[:subscription_id])
    @plan = Plan.find(1)
    @deposit_plan = Plan.find(2)

    full_amount = @plan.price * current_user.daycare.num_children * 30 * @subscription.month.to_i
    bill_amount = @subscription.discount_code.nil? ? full_amount : full_amount * (100-@subscription.discount_code.value) * 0.01
    if current_user.transactions.where(deposit: false).count == 0
      bill_amount -= current_user.total_deposit_amount
      bill_amount = 0 if bill_amount <= 0
    end
    @transaction = Transaction.new
    @transaction.amount = params[:upgrade_type] ? @deposit_plan.price : bill_amount
    @transaction.currency = 'usd'
    @transaction.card_num = params[:card_number]
    @transaction.user_id = current_user.id

    # Create a charge: this will charge the user's card
    begin
      charge = Stripe::Charge.create(
        :amount => (@transaction.amount * 100).to_i, # Amount in cents
        :currency => @transaction.currency,
        :source => params[:stripe_card_token],
        :description => ""
      )
      @transaction.charge_id = charge.id
      @transaction.deposit = params[:upgrade_type]
      @transaction.save

      @subscription.transaction_id = @transaction.id
      @subscription.save

      current_user.card_number = params[:card_number]
      current_user.save

    rescue Stripe::CardError => e
      # The card has been declined
    end

    redirect_to ethic_2_path
  end 
end
