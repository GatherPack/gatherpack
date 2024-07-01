// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"

FontAwesome.config.mutateApproach = 'sync'
import "trix"
import "@rails/actiontext"

document.addEventListener("turbo:load", ev => {
    document.querySelectorAll('.fancy-color-container input[type="color"]').forEach(elem => {
        elem.addEventListener("input", ev => {
            ev.target.parentElement.nextElementSibling.firstChild.value = ev.target.value
        });
    });
    document.querySelectorAll('.fancy-color-container input[type="text"]').forEach(elem => {
        elem.addEventListener("input", ev => {
            ev.target.parentElement.previousElementSibling.firstChild.value = ev.target.value
        });
        elem.value = elem.parentElement.previousElementSibling.firstChild.value
    });
})
