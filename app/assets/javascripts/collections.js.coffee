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

$(document).on 'click', '.collection .participants .new-participant a.btn.add-participant', (e) ->
  e.preventDefault()
  target = $(this)
  collectionId = $('.collection .participants').data('collection-id')
  userKey = $('.new-participant').find('input[name="username"]').val()
  permission = $('.new-participant').find('select[name="permission"]').val()
  $.ajax
    type: 'POST'
    url: '/collections/' + collectionId + '/add_participant'
    data: {user_key: userKey, permission: permission}
    success: (data) ->
      $('.collection .participants-wrapper').html(data)

$(document).on 'click', '.collection .participants .participant a.btn.save-participant', (e) ->
  e.preventDefault()
  target = $(this)
  collectionId = $('.collection .participants').data('collection-id')
  participant = target.closest('.participant')
  membershipId = participant.data('id')
  permission = $('.participant').find('select[name="permission"]').val()
  $.ajax
    type: 'PATCH'
    url: '/collections/' + collectionId + '/update_participant'
    data: {membership_id: membershipId, permission: permission}
    success: (data) ->
      $('.collection .participants-wrapper').html(data)

$(document).on 'click', '.collection .participants .participant a.btn.delete-participant', (e) ->
  e.preventDefault()
  target = $(this)
  collectionId = $('.collection .participants').data('collection-id')
  participant = target.closest('.participant')
  membershipId = participant.data('id')
  $.ajax
    type: 'DELETE'
    url: '/collections/' + collectionId + '/destroy_participant'
    data: {membership_id: membershipId}
    success: (data) ->
      $('.collection .participants-wrapper').html(data)

$(document).on 'input propertychange', 'form.search-public input[name="filter"]', (e) ->
  e.preventDefault()
  target = $(this)
  filter = target.val()
  $.ajax
    type: 'GET'
    url: '/collections/public_list'
    data: { filter: filter }
    success: (data) ->
      $('.public-collections-list').html(data)

$(document).on 'input propertychange', 'form.search-shared input[name="filter"]', (e) ->
  e.preventDefault()
  target = $(this)
  filter = target.val()
  $.ajax
    type: 'GET'
    url: '/collections/shared_list'
    data: { filter: filter }
    success: (data) ->
      $('.shared-collections-list').html(data)

$(document).on 'input propertychange', 'form.search-own input[name="filter"]', (e) ->
  e.preventDefault()
  target = $(this)
  filter = target.val()
  $.ajax
    type: 'GET'
    url: '/collections/own_list'
    data: { filter: filter }
    success: (data) ->
      $('.own-collections-list').html(data)
