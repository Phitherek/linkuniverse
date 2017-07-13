# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', '.collection .meta .score .upvote', (e) ->
  e.preventDefault()
  target = $(this)
  collectionId = target.data('collection-id')
  $.ajax
    type: 'PATCH'
    url: '/collections/' + collectionId + '/upvote'
    success: (data) ->
      target.closest('.score').html(data)

$(document).on 'click', '.collection .meta .score .downvote', (e) ->
  e.preventDefault()
  target = $(this)
  collectionId = target.data('collection-id')
  $.ajax
    type: 'PATCH'
    url: '/collections/' + collectionId + '/downvote'
    success: (data) ->
      target.closest('.score').html(data)