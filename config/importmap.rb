# Pin npm packages by running ./bin/importmap

pin 'application'
pin 'photo_capture'
pin 'font_awesome'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'bootstrap', to: 'bootstrap.min.js'
pin 'trix'
pin '@rails/actiontext', to: 'actiontext.esm.js'
pin 'fullcalendar'
pin "chroma-js" # @2.4.2
