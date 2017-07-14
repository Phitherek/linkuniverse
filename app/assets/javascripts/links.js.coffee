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
    data: {link_url: url}
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

$(document).on 'click', '.collection-link-comments .btn.add-comment', (e) ->
  e.preventDefault()
  target = $(this)
  form = target.closest('form')
  content = form.find('textarea[name="content"]').val()
  container = $('.collection-link-comments')
  $.ajax
    type: 'POST'
    url: form.attr('action')
    data: {content: content}
    success: (data) ->
      container.html(data)
      $.ajax
        type: 'GET'
        url: form.attr('action').replace('add_comment', 'comment_count')
        success: (data) ->
          $('.collection-link small.meta .comments').html(data)

$(document).on 'click', '.collection-link-comments .comment a.edit-comment', (e) ->
  e.preventDefault()
  target = $(this)
  comment = target.closest('.comment')
  collectionHandle = comment.data('collection-handle')
  linkId = comment.data('link-id')
  id = comment.data('id')
  $.ajax
    type: 'GET'
    url: '/collections/' + collectionHandle + '/links/' + linkId + '/edit_comment'
    data: {comment_id: id}
    success: (data) ->
      comment.html(data)

$(document).on 'click', '.collection-link-comments .comment a.cancel-edit-comment', (e) ->
  e.preventDefault()
  target = $(this)
  comment = target.closest('.comment')
  collectionHandle = comment.data('collection-handle')
  linkId = comment.data('link-id')
  id = comment.data('id')
  $.ajax
    type: 'GET'
    url: '/collections/' + collectionHandle + '/links/' + linkId + '/cancel_edit_comment'
    data: {comment_id: id}
    success: (data) ->
      comment.replaceWith(data)

$(document).on 'click', '.collection-link-comments .comment .btn.update-comment', (e) ->
  e.preventDefault()
  target = $(this)
  form = target.closest('form')
  content = form.find('textarea[name="content"]').val()
  comment = target.closest('.comment')
  collectionHandle = comment.data('collection-handle')
  linkId = comment.data('link-id')
  id = comment.data('id')
  $.ajax
    type: 'PATCH'
    url: '/collections/' + collectionHandle + '/links/' + linkId + '/update_comment'
    data: {comment_id: id, content: content}
    success: (data) ->
      comment.replaceWith(data)

$(document).on 'click', '.collection-link-comments .comment a.delete-comment', (e) ->
  e.preventDefault()
  target = $(this)
  comment = target.closest('.comment')
  collectionHandle = comment.data('collection-handle')
  linkId = comment.data('link-id')
  id = comment.data('id')
  $.ajax
    type: 'DELETE'
    url: '/collections/' + collectionHandle + '/links/' + linkId + '/destroy_comment'
    data: {comment_id: id}
    success: (data) ->
      $('.collection-link-comments').html(data)
      $.ajax
        type: 'GET'
        url: '/collections/' + collectionHandle + '/links/' + linkId + '/comment_count'
        success: (data) ->
          $('.collection-link small.meta .comments').html(data)