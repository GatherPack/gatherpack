# Pin npm packages by running ./bin/importmap

pin 'application'
pin 'photo_capture'
pin 'font_awesome'
pin 'code_editor'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'bootstrap', to: 'bootstrap.min.js'
pin 'trix'
pin '@rails/actiontext', to: 'actiontext.esm.js'
pin "codemirror" # @6.0.1
pin "@codemirror/autocomplete", to: "@codemirror--autocomplete.js" # @6.17.0
pin "@codemirror/commands", to: "@codemirror--commands.js" # @6.6.0
pin "@codemirror/language", to: "@codemirror--language.js" # @6.10.2
pin "@codemirror/lint", to: "@codemirror--lint.js" # @6.8.1
pin "@codemirror/search", to: "@codemirror--search.js" # @6.5.6
pin "@codemirror/state", to: "@codemirror--state.js" # @6.4.1
pin "@codemirror/view", to: "@codemirror--view.js" # @6.28.6
pin "@lezer/common", to: "@lezer--common.js" # @1.2.1
pin "@lezer/highlight", to: "@lezer--highlight.js" # @1.2.0
pin "crelt" # @1.0.6
pin "style-mod" # @4.1.2
pin "w3c-keyname" # @2.2.8
pin "@codemirror/legacy-modes/mode/ruby", to: "@codemirror--legacy-modes--mode--ruby.js" # @6.4.0
pin "@codemirror/lang-html", to: "@codemirror--lang-html.js" # @6.4.9
pin "@codemirror/lang-css", to: "@codemirror--lang-css.js" # @6.2.1
pin "@codemirror/lang-javascript", to: "@codemirror--lang-javascript.js" # @6.2.2
pin "@lezer/css", to: "@lezer--css.js" # @1.1.8
pin "@lezer/html", to: "@lezer--html.js" # @1.3.10
pin "@lezer/javascript", to: "@lezer--javascript.js" # @1.4.17
pin "@lezer/lr", to: "@lezer--lr.js" # @1.4.1
pin "@codemirror/lang-markdown", to: "@codemirror--lang-markdown.js" # @6.2.5
pin "@lezer/markdown", to: "@lezer--markdown.js" # @1.3.0
pin "@codemirror/lang-json", to: "@codemirror--lang-json.js" # @6.0.1
pin "@lezer/json", to: "@lezer--json.js" # @1.0.2
