Rails.application.config.stripe.secret_key = Rails.application.secrets.stripe_secret_key
Rails.application.config.stripe.publishable_key = Rails.application.secrets.stripe_public_key

Rails.configuration.stripe = {
  :publishable_key => ENV['pk_test_UAxlZhbShmSlcy05O0IySGd9'],
  :secret_key      => ENV['sk_test_Ty35BKr9soo2eIYo7wJC7g1w']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]