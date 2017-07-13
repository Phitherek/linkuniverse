# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', 'a.title-on-the-fly', (e) ->
  e.preventDefault()
  target = $(this)
  form = target.closest('form')
  urlInput = form.find('input[name="link[url]"]')
  titleInput = form.find('input[name="link[title]"]')
  collectionHandle = target.data('collection-handle')
  url = urlInput.val()
  $.ajax
    type: 'GET'
    url: '/collections/' + collectionHandle + '/links/title_on_the_fly'
    data: { link_url: url }
    success: (data) ->
      titleInput.val(data)

$(document).on 'click', '.collection-link .meta .score .upvote', (e) ->
  e.preventDefault()
  target = $(this)
  collectionHandle = target.data('collection-handle')
  linkId = target.data('link-id')
  $.ajax
    type: 'PATCH'
    url: '/collections/' + collectionHandle + '/links/' + linkId + '/upvote'
    success: (data) ->
      target.closest('.score').html(data)

$(document).on 'click', '.collection-link .meta .score .downvote', (e) ->
  e.preventDefault()
  target = $(this)
  collectionHandle = target.data('collection-handle')
  linkId = target.data('link-id')
  $.ajax
    type: 'PATCH'
    url: '/collections/' + collectionHandle + '/links/' + linkId + '/downvote'
    success: (data) ->
      target.closest('.score').html(data)
