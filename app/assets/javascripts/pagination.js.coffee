jQuery ->
  pushPage = (page) ->
    History.pushState null, "InfiniteScrolling | Page " + page, "?page=" + page
    return

  window.preparePagination = (el) ->
    el.waypoint (direction) ->
      $this = $(this)
      unless $this.hasClass('first-page') && direction is 'up'
        page = parseInt($this.data('page'), 10)
        page -= 1 if direction is 'up'
        page_el = $($('#static-pagination li').get(page))
        unless page_el.hasClass('active')
          $('#static-pagination .active').removeClass('active')
          pushPage(page)
          page_el.addClass('active')
    return

  if $('#infinite-scrolling').size() > 0
    preparePagination($('.page-delimiter'))
    $(window).bindWithDelay 'scroll', ->
      more_users_url = $('#infinite-scrolling .next_page a').attr('href')
      if more_users_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60
        $('#infinite-scrolling .pagination').html(
          '<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
        $.getScript more_users_url, ->
          pushPage(more_users_url.match(page_regexp)[0])
      return
    , 100
