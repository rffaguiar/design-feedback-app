(function() {
  var ELS = {
    DesignImg: '#js-design-img',
    SpotsContainer: '.js-spots-container',
    Spot: '.js-design-spot',
    SpotForm: '.js-spot-form',
    ExistingSpotForm: '.js-existing-spot-form',
    NewSpot: '.js-new-design-spot',
    NewSpotForm: '.js-add-new-spot',
    NewSpotXPos: '#design-x-pos',
    NewSpotYPos: '#design-y-pos',
    NewSpotCommentContainer: '.js-new-spot-comment-container',
    DesignContainer: '.js-design-container',
    // SpotFormContainer: '.spot-form-container',
    MaintainFocus: '.js-maintain-focus',
    CommentTextarea: '.js-design-comment-text',
    MainApp: '.js-main-app',

    UpdateTitle: '#new_design_title',
    UpdateSubtitle: '#new_design_subtitle'
  };

  var VAR = {
    Around: 10
  };

  var BOT_QUESTIONS = [
    'Hmmm, você tem razão.',
    'Fique livre para clicar em outro lugar da imagem e dar o seu feedback.'
  ];

  var BOT_NAME = 'Seu Serviçal';

  var botQuestionCounter = 0;

  /*
  * function name says it all
  * @dependencies: jQuery, Velocity and Waypoints
  */
  function showIcon(iconClass) {

    if(!iconClass) {
      return;
    }

    var waypoint = new Waypoint({
      element: document.getElementsByClassName(iconClass),
      handler: function(direction) {
        $(this.element).velocity({
          opacity: 1,
          scaleX: "1.1",
          scaleY: "1.1"
        },{
          duration: 200
        }).velocity({
          scaleX: "1",
          scaleY: "1"
        }, {
          duration: 300
        });
        this.destroy();
      },
      offset: '60%'
    });
  }

  /*
  *
  * Add fake user comment
  * @bt submit_button
  *
  */
  function addFakeComment(bt) {
    var $spotForm = $(bt).closest(ELS.SpotForm);
    var $comments = $spotForm.find('.comments-container');
    var fakeComment = $spotForm.find('.design-comment-text').val();
    // clear what user typed
    $spotForm.find('.design-comment-text').val('');
    $("<p class=\"design-comment\">" + fakeComment + "<span>- Você</span></p>").appendTo($comments);
  }


  /*
  * add a bot comment
  * @bt submit_button
  */
  function addBotComment(bt) {

    if (botQuestionCounter >= BOT_QUESTIONS.length) {
      return;
    }

    var $spotForm = $(bt).closest(ELS.SpotForm);
    var $comments = $spotForm.find('.comments-container');
    var fakeComment = BOT_QUESTIONS[botQuestionCounter];
    botQuestionCounter++;

    $("<p class=\"design-comment\">" + fakeComment + "<span class=\"home-bot-user\">- "+ BOT_NAME +"</span></p>").appendTo($comments);
  }

  /*
  * Add a new spot and everything related to it: forms, buttons, classes
  * @bt submit_button
  */
  function addNewSpot(bt) {

    var $newSpotForm = $(bt).closest(ELS.SpotForm);
    var fakeComment = $newSpotForm.find('.design-comment-text').val();
    $newSpotForm.find('.design-comment-text').val('');
    var top = parseInt($newSpotForm.css('top'), 10);
    var left = parseInt($newSpotForm.css('left'), 10);

    // hide the new spot/comment form
    $('.js-add-new-spot').addClass('js-spot-created'); // hackish solution with js/css

    // this is to remove the :hover effect
    setTimeout(function(){
      $('.js-add-new-spot').removeClass('js-spot-created');
    }, 1000);

    var $designContainer = $('.js-design-container');
    var $spotFormContainer = $('<div class="spot-comment-container"></div>')

    var $span = $('<span>')
                .addClass('js-design-spot')
                .attr('style', "top:"+ (top - 10) +"px; left: " + (left - 10) + "px");

    $span.appendTo($spotFormContainer);

    var $formContainer = $('<div>')
                        .addClass('js-existing-spot-form js-spot-form')
                        .attr('style', "top:"+ top +"px; left: " + left + "px");


    var $commentsContainer = $('<div>')
                             .addClass('comments-container')
                             .append("<p class=\"design-comment\" >" + fakeComment + "<span>- Você</span></p>");

    var $form = $('<form>')
                 .addClass('js-home-fake-form')
                 .append($commentsContainer)
                 .append('<textarea name="design-comment-text" class="js-maintain-focus design-comment-text"></textarea>')
                 .append('<button name="button" type="button" class="design-comment-submit js-home-new-comment-submit">Enviar Feedback</button>');

    $form.appendTo($formContainer);
    $formContainer.appendTo($spotFormContainer);
    $spotFormContainer.appendTo('.js-spots-container');

    //find the new spot and show it
    $span.addClass('js-temp-display');

    // hackish solution
    setTimeout(function() {
      $span.removeClass('js-temp-display');
    }, 1000)

    // create focus on the newly created spot comment
    $formContainer.find('.js-maintain-focus').trigger('focus');
  }

  /*
  * The fake bot used to interact with user and append comments
  */
  function fakeBot() {
    $('.js-bot-comment-submit').on('click', function() {
      submit_bt = this;
      addFakeComment(submit_bt);
      addBotComment(submit_bt);
      addBotComment(submit_bt);
    });
  }

  /*
  * append a new fake comment in homepage
  */
  function fakeNewComments() {
    $('.js-spots-container').on('click', '.js-home-new-comment-submit', function() {
      submit_bt = this;
      addFakeComment(submit_bt);
    });
  }

  /*
  * create a new fake spot with comment in homepage
  */
  function fakeNewSpots() {
    $('.js-home-new-spot-submit').on('click', function() {
      submit_bt = this;
      addNewSpot(submit_bt);
    });
  }

  /*
  * Some animation on homepage
  */
  function homeStuff() {
    var $homepage = $('#js-home-page');

    if( !$homepage.length) {
      return;
    }

    showIcon('js-upload-home');
    showIcon('js-share-home');
    showIcon('js-feedback-home');

    fakeBot();
    fakeNewComments();
    fakeNewSpots();
  }

  /*
  * Show the comment box, may be the new comment box or a existing one
  * @e: click event
  * @offset: the current element (design img)
  */
  function showNewSpotBox(e, offset) {
    var xPos = e.pageX;
    var yPos = e.pageY;
    var relativeX = Math.round(e.pageX - offset.left);
    var relativeY = Math.round(e.pageY - offset.top);

    // $(ELS.NewSpotForm).closest(ELS.NewSpotCommentContainer).find(ELS.NewSpot).css({
    //   'top': yPos - 10, // this 3 is a :hover hackish
    //   'left': xPos - 10 // this 2 is a :hover hackish
    // });

    $(ELS.NewSpotForm).css({
      'top': relativeY - 3, // this 3 is a :hover hackish
      'left': relativeX - 2 // this 2 is a :hover hackish
    }).css('display', 'block');

    // make textarea focusable
    $(ELS.NewSpotForm).find(ELS.MaintainFocus).trigger('focus').css('display','');

    // setup positions on inputs
    $(ELS.NewSpotForm).find(ELS.NewSpotXPos).val(relativeX);
    $(ELS.NewSpotForm).find(ELS.NewSpotYPos).val(relativeY);
  }

  // Animate update title and subtitle with ajax
  // author: rffaguiar
  // since: 1.0
  // date: 25/03/2015
  // @dependencies: jquery, velocity, sweetalert
  function animateServerResponse(formClass) {

    // handle animation beforeSend
    $(formClass).on('ajax:beforeSend', function() {
      $(this).find('.js-form-update-icon').addClass('fa-refresh fa-spin').velocity({opacity: 1});
    });

    // handle animation after a successfull update
    $(formClass).on('ajax:success', function() {

      var $updateIcon = $(this).find('.js-form-update-icon');
      $updateIcon.velocity({
        opacity: 0
      },{
        complete: function(){
          $updateIcon.removeClass('fa-refresh fa-spin');
          $updateIcon.addClass('fa-check');
          $updateIcon.velocity({ opacity: 1 }, {
            complete: setTimeout(function(){
              $updateIcon.velocity({ opacity: 0 }, {
                complete: function() {
                  $updateIcon.removeClass('fa-check');
                }
              });
            }, 2500)
          });
        }
      });

    });

    // handle animation in an error update
    $(formClass).on('ajax:error', function() {

      var $updateIcon = $(this).find('.js-form-update-icon');
      $updateIcon.velocity({
        opacity: 0
      },{
        complete: function(){
          $updateIcon.removeClass('fa-refresh fa-spin');
          $updateIcon.addClass('fa-times');
          $updateIcon.velocity({ opacity: 1 }, {
            complete: setTimeout(function(){
              $updateIcon.velocity({ opacity: 0 }, {
                complete: function() {
                  $updateIcon.removeClass('fa-times');
                  swal({
                    title: "Ooops..!",
                    text: "Infelizmente não foi possível atualizar este campo. Tente novamente mais tarde ou entre em contato conosco.",
                    type: "error",
                    confirmButtonText: "Ok!"
                  });

                }
              });
            }, 2500)
          });
        }
      });
    });
  }

  // Allow update title and subtitle with ajax
  // author: rffaguiar
  // since: 1.0
  // date: 20/03/2015
  function updateTitleSubtitle() {
    $(ELS.UpdateTitle).on('blur', function() {
      $(this).closest('form').submit();
    });

    $(ELS.UpdateSubtitle).on('blur', function() {
      $(this).closest('form').submit();
    });

    animateServerResponse('.js-form-update-title');
    animateServerResponse('.js-form-update-subtitle');
  }

  function maintainTextareaFocus() {
    $(ELS.MainApp).on('focusin', ELS.MaintainFocus, function() {
      $parent = $(this).closest(ELS.SpotForm);
      $parent.css('display', 'block');
    });

    $(ELS.MainApp).on('focusout', ELS.MaintainFocus, function() {
      $parent = $(this).closest(ELS.SpotForm);
      $parent.css('display', '');
    });
  }

  // Show/Hide the new Spot when img is clicked and we need to show the new spot form
  function littleHackish() {
    $(ELS.NewSpotForm).hover(function(){
      $(this).closest(ELS.NewSpotCommentContainer).find(ELS.NewSpot).css('display', 'block');
    }, function() {
      $(this).closest(ELS.NewSpotCommentContainer).find(ELS.NewSpot).css('display', 'none');
    });
  }

  // Colorify usernames to a better UX
  // dependency: Please
  function colorifyUsers() {
    var unique_ids = []; // name says it all
    var colors = []; // array containing colors, one color - one id

    $('.js-spots-container').find('.js-username-comment').each(function(i, el) {
      if ($.inArray($(el).attr('data-user-ref'), unique_ids) === -1) {
        unique_ids.push($(el).attr('data-user-ref'));
      }
    });

    colors = Please.make_color();

    colors = Please.make_color({
      colors_returned: unique_ids.length,
      saturation: 0.7,
      value: 0.7
    });

    if ( typeof colors === 'string' ) {
      colors = [colors];
    }

    //colorifying usernames
    for( var i = 0; i < unique_ids.length; i++ ) {
      $('.js-username-comment[data-user-ref=' + unique_ids[i] + ']', '.js-spots-container').css('color', colors[i]);
    }
  }

  function feedbackFormAnimations() {
    $('#feedback-form-app').on('click', 'input[type=submit]', function() {
      $('.js-single-feedback-refresh').removeClass('hide');
    });
  }

  function commentDesign() {
    // this script can run only on these 2 pages
    // homepage for bot
    // design page for the main experience
    if ( !($('#js-home-page').length || $('#df-design-page').length) ) {
      return;
    }

    maintainTextareaFocus();
    littleHackish();
    colorifyUsers();
    feedbackFormAnimations();

    $(ELS.DesignContainer).on('click', ELS.DesignImg, function(e) {
      var _this = this;
      var offset = $(this).offset();
      showNewSpotBox(e, offset);
    });

    // clear comment textarea when ajax is a success in a ExistingSpotForm
    $(ELS.ExistingSpotForm).on('ajax:success', function(e, data, status, xhr) {
      $('textarea', ELS.ExistingSpotForm).val('');
    }).on('ajax:error', function(e, xhr, status, error) {
      console.log(error)
      console.log(status)
      console.log(xhr)
    });

    // clear comment textarea when ajax is a success in a newSpotForm
    $(ELS.NewSpotForm).on('ajax:success', function(e, data, status, xhr){
      $(ELS.CommentTextarea, ELS.NewSpotForm).val('');
    }).on('ajax:error', function(e, xhr, status, error) {
      console.log(error)
      console.log(status)
      console.log(xhr)
    });

    updateTitleSubtitle();
  }

  // name says it all. select the text from a selected element.
  // ATTENTION: it SELECTS, it doesn't copy
  function selectText(element) {
    var doc = document
        ,text = doc.getElementById(element)
        ,range, selection
    ;
    if (doc.body.createTextRange) {
        range = document.body.createTextRange();
        range.moveToElementText(text);
        range.select();
    } else if (window.getSelection) {
        selection = window.getSelection();
        range = document.createRange();
        range.selectNodeContents(text);
        selection.removeAllRanges();
        selection.addRange(range);
    }
  }

  // copy modal link text to a clipboard
  // dependency: ZeroClipboard
  function copyToClipboard() {
    // var $designPage = $('#df-design-page');
    if( !$('#df-design-page').length) {
      return;
    }

    $('#df-modal-link').on('click', function() {
      selectText('df-modal-link');
    });

    var client = new ZeroClipboard( document.getElementById('df-copy-to-clipboard-link') );

    client.on('ready', function(readyEvent) {
      // ZeroClipboard SWF is ready
      client.on('aftercopy', function(event) {
        setTimeout(function(){
          $('#js-df-modal-link').foundation('reveal', 'close')
        }, 1000);

      });
    });
  }


  // handle notification in all pages
  function notifications() {
    var $notifications = $('#df-notifications');

    if (!$notifications.length) {
      return false;
    }

    var text = '';
    var $deviseNotice = $('#js-df-devise-notice');
    var $deviseAlert = $('#js-df-devise-alert');

    if ($deviseNotice.length) {
      text = $deviseNotice.text();
    }

    if ($deviseAlert.length) {
      text = $deviseAlert.text();
    }

    toastr.options = {
       'closeButton': true,
       'timeout': 10000,
       'extendedTimeOut': 10000,
       'positionClass': 'toast-bottom-left'
    };

    toastr.info(text);
  }

  function init() {
    $(document).ready(function(){
      commentDesign();
      homeStuff();
      copyToClipboard();
      notifications();
    });
  }

  init();
}());
