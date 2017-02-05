class TransactionsController < ApplicationController
  def create
    @subscription = Subscription.find(params[:subscription_id])
    @plan = Plan.where(plan_type: 1, language: I18n.locale.upcase).first
    @deposit_plan = Plan.where(plan_type: 0, language: I18n.locale.upcase).first

    days = 0
    unless @subscription.payment_mode
      case @subscription.payment_mode.until
      when 'week'
        days = 7 * @subscription.payment_mode.period
      when 'month'
        days = 30 * @subscription.payment_mode.period
      when 'year'        
        days = 30 * @subscription.payment_mode.period * 12
      end
    end

    full_amount = @plan.price * current_user.daycare.num_children * days
    bill_amount = @subscription.discount_code.nil? ? full_amount : full_amount * (100-@subscription.discount_code.value) * 0.01
    if current_user.transactions.where(deposit: false).count == 0
      bill_amount -= current_user.total_deposit_amount
      bill_amount = 0 if bill_amount <= 0
    end
    @transaction = Transaction.new
    @transaction.amount = params[:upgrade_type] ? @deposit_plan.price : bill_amount
    @transaction.currency = params[:upgrade_type] ? @deposit_plan.currency : @plan.currency
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
