'use strict';

jQuery(function($) {
  var reportPage = {
    selectTab: function(id) {
      $('#sources.active, #events.active').removeClass('active');
      $(id).addClass('active');
    },

    selectLine: function(id) {
      $('#source-code .source').hide();

      var source = $(id).parents('.source');
      source.show();

      $('.line-info.focus, .line-code.focus').removeClass('focus');
      var fid = id.slice(6);
      console.log(fid);
      $('#line-' + fid + ', #line-code-' + fid).addClass('focus');

      reportPage.selectTab('#sources');
    },

    selectFile: function(id) {
      $('#source-code').scrollTop(0);
      $('#source-code .source').hide()
      $(id).show();
    }
  };

  $('#report .tabs a').on('click', function(e) {
    e.preventDefault();

    var href = $(this).attr('href');
    reportPage.selectTab(href);
  });

  $('#source-list a').on('click', function(e) {
    e.preventDefault();

    var href = $(this).attr('href');
    reportPage.selectFile(href);
  });

  $('#events .backtraces a, #sources .source .line-no a').on('click', function(e) {
    e.preventDefault();

    var href = $(this).attr('href');
    reportPage.selectLine(href);
  });

  $('#events .event .event-name a').on('click', function(e) {
    e.preventDefault();

    var id = $(this).attr('href');
    $(id).find('> .event-info .event-payload').slideToggle();
  });
});
