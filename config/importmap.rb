# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "popper", to: 'popper.js', preload: true
pin "bootstrap", to: 'bootstrap.min.js', preload: true
pin "trix"
pin "@rails/actiontext",    to: "actiontext.js"
# pin "@rails/activestorage", to: "activestorage.js"
# pin "@rails/activestorage", to: "https://ga.jspm.io/npm:activestorage@5.2.8-1/app/assets/javascripts/activestorage.js"
# pin "@rails/activestorage", to: "https://ga.jspm.io/npm:@rails/activestorage@7.0.8/app/assets/javascripts/activestorage.esm.js"pin "activestorage", to: "https://ga.jspm.io/npm:activestorage@5.2.8-1/app/assets/javascripts/activestorage.js"
pin "activestorage" # @5.2.8
pin "@stripe/stripe-js", to: "https://ga.jspm.io/npm:@stripe/stripe-js@2.1.10/dist/stripe.esm.js"
