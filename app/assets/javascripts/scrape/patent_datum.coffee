# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ft = (el, maxFont)->
  $(el).flowtype
    minimum: 500
    maximum: 1200
    minFont: 12
    maxFont: maxFont
    fontRatio: 30

$(document).ready ->
  ft 'h1', 50
  ft 'h2', 50
  ft 'h3', 28
  ft 'h4', 25
  ft 'li', 23
  ft 'p', 23
  ft 'blockquote', 23
  ft 'address', 23
