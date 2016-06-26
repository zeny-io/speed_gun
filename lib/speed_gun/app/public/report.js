'use strict';

jQuery(function($) {
  var reportPage = {
    selectTab: function(id) {
      $('#report .tabs .active, #sources.active, #events.active').removeClass('active');
      $(id).addClass('active');
      $('[href="' + id + '"]').addClass('active');
    },

    selectLine: function(id) {
      $('.source-line.focus').removeClass('focus');
      var fid = id.slice(6);
      var line = $('#line-' + fid);
      line.addClass('focus');
      reportPage.selectFile('#' + line.parents('.source').attr('id'));

      reportPage.selectTab('#sources');
    },

    selectFile: function(id) {
      $('#source-code').scrollTop(0);
      $('#source-code .source').hide();
      $('.source-link.focus').removeClass('focus');

      $('.source-link a[href="' + id + '"]').parent().addClass('focus');
      $(id).show();
    }
  };

  $('#report .tabs a').on('click', function(e) {
    e.preventDefault();

    var href = $(this).attr('href');
    reportPage.selectTab(href);
  });

  $('#source-list a, #source-code .source .filename a').on('click', function(e) {
    e.preventDefault();

    var href = $(this).attr('href');
    reportPage.selectFile(href);
  });

  $('#events .backtraces a, #sources .source .line-info a').on('click', function(e) {
    e.preventDefault();

    var href = $(this).attr('href');
    reportPage.selectLine(href);
  });

  $('#events .event .event-name a').on('click', function(e) {
    e.preventDefault();

    var id = $(this).attr('href');
    $(id).find('> .event-info .event-payload').slideToggle();
    $(id).find('> .event-info').toggleClass('closed');
  });

  if(location.hash.startsWith('#line-')) {
    reportPage.selectLine(location.hash);
  }
});
