// This will eventually hold the authenticated user model.
var currentUser;

$(document).ready(function() {


  /**
   * The User Model
   */
  var User = Backbone.Model.extend({});

  /**
   * The User Collection
   */
  var UserList = Backbone.Collection.extend({
    model: User
  });


  /**
   * The ChatLog View
   */
  var ChatLog = Backbone.View.extend({
    // Attach the view to the #app #log div
    el: $("#app #log"),

    // Initialize the view
    initialize: function() {
      // Bind the following methods to the current context of this.
      _.bindAll(this, 'render');

      // This view is self rendering
      this.render();
    },

    render: function() {
      // Display the log which is hidden by default.
      $(this.el).show();
    }
  });

  var chatLog = new ChatLog();

  /**
  * The Signup View
  */
  var Signup = Backbone.View.extend({
    // Attach the view to the signup form
    el: $('#signup'),

    // Attach 
    events: {
      'click #connectButton': 'signUp'
    },

    initialize: function() {
      // Bind signUp to the current context of this
      _.bindAll(this, 'signUp');
    },

    /**
     * signUp
     *
     * Handles authenticating new users.
     */
     signUp: function(event) {
       var self = this;

       event.preventDefault();

       var email = $('#email', self.el).val();
       var nickname = $('#nickname', self.el).val();

       currentUser = new User({ email: email, nickname: nickname });

       $('#entry').show();
       this.remove();
     }

  });

  var signup = new Signup();
});
