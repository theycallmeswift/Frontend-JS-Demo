$(document).ready(function() {


  /**
   * Views
   */

  // Sidebar View
  //
  // Contains the currently active users.

  var SidebarView = Backbone.View.extend({
    el: "div#sidebar",

    render: function() {
      var self = this;
      $(self.el).css({'height':(($(window).height())-40)+'px'})
    }
  });

  window.Sidebar = new SidebarView();
});
