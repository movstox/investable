# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready (e) ->
  $('#search_panel1 a').click (e) ->
      e.preventDefault()
      param = $(this).attr('href').replace('#', '')
      concept = $(this).text()
      $('#search_panel1 span#search_concept1').text concept
      $('#search_panel1 .input-group #search_param1').val param
      return
    return

  $('#search_panel2 a').click (e) ->
      e.preventDefault()
      param = $(this).attr('href').replace('#', '')
      concept = $(this).text()
      $('#search_panel2 span#search_concept2').text concept
      $('#search_panel2 .input-group #search_param2').val param
      return
    return
