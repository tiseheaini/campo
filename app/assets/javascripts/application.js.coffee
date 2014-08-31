#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap
#= require jquery.autosize
#= require jquery.validate
#= require template
#= require jquery.timeago
#= require nprogress
#= require campo
#= require simditor-all.min
#= require_tree ./plugins

$(document).on 'page:update', ->
  $('[data-behaviors~=autosize]').autosize()

  $("time[data-behaviors~=timeago]").timeago()

$(document).on 'page:fetch', ->
  NProgress.start()
$(document).on 'page:change', ->
  NProgress.done()
$(document).on 'page:restore', ->
  NProgress.remove()
