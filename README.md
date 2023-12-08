![Alt text](app/assets/images/logo.png?raw=true "Plus Ultra")

# README

Aim:

Starter app with everything needed to launch and run a business. Just add an idea and designer.

Modern Rails 7 Hotwire app with no Javascript build complexity.

Note: Not production ready. Still work in progress. Aim is to be completed in Feb 2024.

## 1. Marketing

- Blog 
- Email lists (https://www.mailgun.com/ to send marketing emails )
- Campaign management

## 2. Sales

- Shopping Cart
- Stripe sales & subscriptions

## 3. Operations

- User/Customer management with 2FA
- Admin Dashboard
- Receipts

## 4. Reporting

- Customer signup 
- Campaign tracking - open, clicks, signups & purchases
- Sales performance 

## 5. Testing 

- Watir & Chromedriver
- install Chrome and compatible version of chromedriver

## Development Environment

### Sidekiq for background task 
- bundle exec sidekiq

### Mailcatcher

* Mailcatcher url: http://127.0.0.1:1080/
 - run mailcatcher in console 

### Stripe CLI
- https://stripe.com/docs/stripe-cli
- stripe login  - to authenticate - will need to do this every 90 days
- stripe listen --forward-to localhost:3000/webhooks/stripe
- Trigger test api calls 
-- stripe trigger checkout.session.completed to test responses will be received

## Application Notes

### Rails 
- Turbo 8
- Active Storage for file uploads
- ActionText Trix WYSIWYG editor
- dotenv for environment
- Redis for key value store
- Boostrap SCSS
- Sanitize for cleaning up text input by user
- Bulk emails sent on background thread
- Simple calendar for events
- Users individual time zones

### Ensure your email marketing does not end up in the spam bin
- Email sending is separated into operational and marketing. So if your marketing emails are flagged as spam, operational emails will not be affected. Aggressive marketing tactics may see your email domain added to Spam Blacklists and it's time consuming to get these removed.
-- operational emails use SMTP 
-- marketing emails use Mailgun (or it's easy to add a different 3rd Party Mailer)
- Setup SPF, DKIM and DMARK records for your email sending domain 
- Ensure reverse DNS responds with the domain name used for sending email
- Setup and monitor abuse@mydomain.com
- Review Spam Blacklists for any of your IP addresses and domains 

### Third parties 
- Google Tag Manager 
- Facebook Open Graph Pixel tracking
- Twilio SMS - outbound and inbound
- Stripe for purchase and subscriptions

#### Sample .env 

- APP_NAME           = "Plus Ultra"
- MOTTO             = "Go Beyond!"
- WHO_AM_I          = "http://localhost:3000"
- STRIPE_PUBLIC_KEY = "will start with pk_..."
- STRIPE_SECRET_KEY = "will start with sk_..."
- DATABASE_NAME_DEV  = "development db name"
- DATABASE_NAME_TEST = "test db name"
- DATABASE_NAME_PROD = "production db name"
- DATABASE_MAX_POOL  = 5
- DATABASE_TIMEOUT   = 5000
- FACEBOOK_DOMAIN_VERIFICATION = "FACEBOOK VERIFICATION CODE"
- FACEBOOK_OPENGRAPH_IMAGE = "https://www.mydomain.com/images/my-facebook-opengraph.jpg"
- GOOGLE_TAG_MANAGER_ID = ""
- TWILIO_ACCOUNT_SID = ""
- TWILIO_AUTH_TOKEN  = ""
- TWILIO_CALLBACK_URL = "https://www.mydomain.com/webhooks/twilio"
- TWILIO_MOBILE_NUMBER_SID = ""
- TWILIO_MOBILE_NUMBER = "+61400000000"
- FROM_EMAIL           = "role@mydomain.com"
- FROM_EMAIL_MARKETING = 'mydomain <noreply@mydomain.com>'

- MAILGUN_API_KEY      = ""

### Operations
- Admin Dashboard 
- Customer Dashboard
- Responsive HTML Email templates (Outlook compatible)
- Auditing for recording model changes and user who made them - https://github.com/collectiveidea/audited

### Useful Web stuff
- Phony & Phonelib for international telephone numbers
- International Time Zones
- Invisible Captcha for anti-spam form catching
- Generate QR and Barcodes
- SEO optimisation - Title, Meta Description/Keywords and image tagging
- Charting Chartkick https://chartkick.com/ & ApexCharts https://github.com/styd/apexcharts.rb
- Font awesome free
- Turbo 8 - how to use: https://fly.io/ruby-dispatch/turbo-8-in-8-minutes/

### Make money with Stripe
- Once off Purchase
- Subscriptions (weekly, fortnightly, monthly, annual) with idempotence.
- Webhooks

# 
* TODO 

- Elastic search
- subscriptions history
- upgrade to Ruby 3.3 & YJIT
- Calendar

* Ruby version

* System dependencies
- See Gem file 
- Mailcatcher for development and test environments 
- Chromedriver 
- Postgres
- Redis

* Configuration

* Database creation
- rails db:create 

* Database initialization
- rails db:migrate

* How to run the test suite
- cd watir 
- ./go.sh TestFile.rb

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
gem install watir
gem install mailcatcher 

## Setup server 

- setup rails app    in /var/apps/site_name 
- setup puma  server in /var/apps/shared/site_name

## Let's Encrypt Free SSL / Certbot
- Instructions for Ubuntu Linux
- First setup NGINX (see below) and enure http is visible on web.
- Verify NGINX setup is good: sudo nginx -t
- enable HTTPS through firewall 
- sudo ufw status
- sudo ufw allow 'Nginx Full'
- sudo ufw delete allow 'Nginx HTTP'
- sudo ufw status
- sudo apt install certbot python3-certbot-apache
- sudo certbot --nginx -d my_site.domain -d www.my_site.domain
- Choose to redirect HTTP to HTTPS
- Verify certbot has automated 90 day renewal process: sudo systemctl status certbot.timer
- Test certbot renewal: sudo certbot renew --dry-run
- Resolve any errors

## NGINX 

- /etc/nginx/nginx.conf 

user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
	worker_connections 768;
	# multi_accept on;
}

http {

	##
	# Basic Settings
	##

	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	keepalive_timeout 65;
	types_hash_max_size 2048;
	# server_tokens off;

	# server_names_hash_bucket_size 64;
	# server_name_in_redirect off;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	##
	# SSL Settings
	##

	ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
	ssl_prefer_server_ciphers on;

	##
	# Logging Settings
	##

	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	##
	# Gzip Settings
	##

	gzip on;

	gzip_vary on;
	gzip_proxied any;
	gzip_comp_level 6;
	gzip_buffers 16 8k;
	gzip_http_version 1.1;
	gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
        gzip_disable "MSIE [1-6]\.";

	##
	# Virtual Host Configs
	##

	include /etc/nginx/conf.d/*.conf;
	include /etc/nginx/sites-enabled/*;
}




- /etc/nginx/sites_enabled - one file for each domain

upstream my_site {
    # Path to Puma SOCK file, as defined previously
    server unix:/var/apps/shared/my_site/sockets/puma.sock fail_timeout=0;
}

server {
    server_name my_site.domain;

    return 301 https://www.mysite.domain$request_uri;


    root /var/apps/my_site/public;

    try_files $uri/index.html $uri @my_site;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    location @my_site {
	      proxy_http_version 1.1;

	      proxy_set_header Upgrade $http_upgrade;
	      proxy_set_header Connection "upgrade";

        proxy_pass http://my_site;
        # proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        # proxy_set_header Host $http_host;
        #proxy_redirect off;

        proxy_set_header  Host $host;
        proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header  X-Forwarded-Proto $scheme;
        proxy_set_header  X-Forwarded-Ssl on; # Optional
        proxy_set_header  X-Forwarded-Port $server_port;
        proxy_set_header  X-Forwarded-Host $host;
    }

    error_page 500 502 503 504 /500.html;
    client_max_body_size 1G;
    keepalive_timeout 10;

    # Certbot will add SSL/port 443 config here
}

server {
    # Certbot will insert redirection to SSL/Port 443 here

    server_name mysite_domain;
    listen 80;
}


## License

Plus Ultra is released under the [MIT License](https://opensource.org/licenses/MIT).

