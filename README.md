![Alt text](app/assets/images/plus_ultra.png?raw=true "Plus Ultra")

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

- Watir & Chrome. Need to install Chrome and compatible version of chromedriver

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

## Application Notes

### Rails 
- Active Storage for file uploads
- ActionText Trix WYSIWYG editor
- dotenv for environment
- Redis for key value store
- Boostrap SCSS
- Sanitize for cleaning up text input by user

### Operations
- Admin Dashboard 
- Customer Dashboard
- Responsive HTML Email templates (Outlook compatible)
- Auditing for recording model changes and user who made them - https://github.com/collectiveidea/audited

### Useful Web stuff
- Phony & Phonelib for international telephone numbers
- Invisible Captcha for anti-spam form catching
- QRCode to generate QR codes
- SEO optimisation - Title, Meta Description/Keywords and image tagging
- Charting Chartkick https://chartkick.com/ & ApexCharts https://github.com/styd/apexcharts.rb
- Font awesome free

### Make money with Stripe
- Once off Purchase
- Subscriptions (weekly, fortnightly, monthly, annual) with idempotence.
- Webhooks

# 
* TODO 

- elastic search
- Outbound campaigns and inbound tracking
- subscriptions history
- upgrade to Ruby 3.3 & YJIT
- campaign management

* Ruby version

* System dependencies
- See Gem file 
- Mailcatcher for development and test environments 
- chromedriver 
- postgres

* Configuration

* Database creation
- rails db:create 

* Database initialization

* How to run the test suite
- cd watir 
- ./go.sh TestFile.rb

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
gem install watir
gem install mailcatcher 

## License

Plus Ultra is released under the [MIT License](https://opensource.org/licenses/MIT).

