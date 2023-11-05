# README

Aim:

Starter app with everything needed to launch and run a business. Just add an idea and designer.

Modern Rails 7 Hotwire app with no Javascript build complexity.

## 1. Marketing

- Blog 
- Email lists
- Campaign management

## 2. Sales

- Products 
- Once off & subscription payments via Stripe
- Shopping Cart

## 3. Operations

- User/Customer management with 2FA
- Receipts

## 4. Reporting

- Customer signup 
- Sales performance 
- Campaign tracking

## 5. Testing 

- Watir & Chrome

## Development Environment

### Mailcatcher

* Mailcatcher url: http://127.0.0.1:1080/
 - run mailcatcher in console 
 - mailcatcher -f -b -v

### Stripe CLI
- https://stripe.com/docs/stripe-cli
- stripe login  - to authenticate - will need to do this every 90 days
- stripe listen --forward-to localhost:3000/webhooks/stripe
- Trigger test api calls 
-- stripe trigger checkout.session.completed to test responses will be received

### Notes

- Active Storage for file uploads
- ActionText Trix WYSIWYG editor
- Phony & Phonelib for international telephone numbers
- Invisible Captcha
- dotenv
- QRCode


# 
* TODO 

- captcha 
- subscriptions - stripe
- charts - reporting
- elastic search


* Ruby version

* System dependencies
- See Gem file 

* Configuration

* Database creation

* Database initialization

* How to run the test suite
- Watir

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
gem install watir
gem install mailcatcher 


```
* ...


