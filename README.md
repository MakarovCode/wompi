# Wompi client

Ruby gem to use the Wompi  API simple (Is still in progress)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wompi'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install wompi
```

## Usage

For Rails First create an wompi.rb in your config/initializers

```ruby
require "wompi"

Wompi::RApi.configure do |config|
  config.pub_key = "pub_key"
  config.prv_key = "prv_key"
  config.webhook = "https://domain.com/wompi_webhook"
  config.sandbox = true # or false for production
end

```

## Flow

### First login

```ruby
wompi_login = Wompi::RApi::Login.new
wompi_login.get_acceptance_token

wompi_card = Wompi::RApi::PaymentMethod.new(wompi_login)
wompi_card.as_dummy_card(params["card_status"])
wompi_card.create

if wompi_card.success?
  # DO something
end

```

### Second prepare and create transaction

```ruby
# login
wompi_login = Wompi::RApi::Login.new
wompi_login.get_acceptance_token

# handle payment method
wompi_card = Wompi::RApi::PaymentMethod.new(wompi_login)
wompi_card.as_card_with_known_id("token")
wompi_card.as_dummy_card("APPROVED") # or "DECLINED"
wompi_card.as_card("number", "cvc", "exp_month", "exp_year", "holder")
wompi_card.as_dummy_nequi("APPROVED") # or "DECLINED"
wompi_card.as_nequi("phone")
wompi_card.get_nequi("id")
wompi_card.check_nequi("phone") # use after initializing PaymentMethod and using get_nequi

# create payment source from payment method
wompi_source = Wompi::RApi::PaymentSource.new(wompi_login)
wompi_source.create(wompi_card, "email")

# create transaction
wompi_trans = Wompi::RApi::Transaction.new(wompi_login)
wompi_trans.prepare("amount_in_cents", "currency", "customer_email", "payment_source", "installments", "reference")
wompi_trans.create

if wompi_trans.success?
  # DO something
end

# you can also
wompi_trans.get("id")
wompi_trans.search("reference")
wompi_trans.void("id")


```
