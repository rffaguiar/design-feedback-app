$(function(){

  var ELS = {
    Scope: '#js-individuais-page',
    UpdateTitle: '.new_design_title_individuais',
    UpdateSubtitle: '.new_design_subtitle_individuais',
    SinglesContainer: '.design-container-individuais',
  };

  // Dropzone upload logic
  // author: rffaguiar
  // since: 1.0
  // date: 25/03/2015
  // @dependencies: velocity, sweetalert
  function singularDropzone() {

    var dMaxFilesize = 24, // in MB
        dMaxFiles = 30; // in quantity

    var SingularDropzone = new Dropzone('#js-singular-dropzone',{
      url: "/create_single",
      paramName: 'design_images',
      maxFilesize: dMaxFilesize,
      uploadMultiple: true,
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') // rails checks CSRF token on every ajax request, since this is not being done by jquery rails, we need to make it by ourselves
      },
      previewsContainer: '.dropzone-previews',
      addRemoveLinks: false,
      maxFiles: dMaxFiles,
      acceptedFiles: "image/jpeg, image/jpg, image/png",

      // messages
      dictFallbackMessage: 'Seu navegador não suporta upload de arrastar, use o botão padrão',
      dictInvalidFileType: 'Somente imagens nos formatos .png e .jpg são aceitas',
      dictFileTooBig: 'Sua imagem é muito grande, o limite é de ' + dMaxFilesize + ' MB por imagem',
      dictResponseError: 'Infelizmente estamos passando por alguma dificuldade técnica. Tente mais tarde.',
      // dictMaxFilesExceeded: 'O número de imagens foi excedido. O limite é de ' + dMaxFiles,

      //template
      previewTemplate: document.querySelector('#js-mydropzone-singular-theme').innerHTML

    });

    // handling UI/UX while images are being uploaded
    SingularDropzone.on('sending', function(file,response,xhr) {
      $(file.previewElement).insertAfter('#js-dropzone-position');
      $(file.previewElement).find('input').attr({
        'disabled': 'disabled',
        'placeholder': 'Espere por favor.'
      })
    });

    // handle data when a new image is uploaded
    SingularDropzone.on('success', function(file,response,xhr) {

      successResponse = response.shift();

      // put the id
      $(file.previewElement).find('[data-design-id]').val(successResponse.id);
      // put the link
      $(file.previewElement).find('.painel-design-link').attr('href', '/' + successResponse.link);
      // put the real image
      $(file.previewElement).find('img[data-dz-thumbnail]').attr('src', '/assets/uploads/designs/' + successResponse.image_thumb_path);
      //enable the inputs
      $(file.previewElement).find('input').removeAttr('disabled');
      //Show the correct placeholders
      $(file.previewElement).find('.new_design_title_individuais').attr('placeholder','Tïtulo');
      $(file.previewElement).find('.new_design_subtitle_individuais').attr('placeholder','Breve Descrição');

      // move to initial position
      // $(file.previewElement).insertAfter('#js-dropzone-position');
    });


    // handling Dropzone error upload
    SingularDropzone.on('error', function(file, response, xhr){
      // move to initial position
      $(file.previewElement).find('.df-individual-inputs-container form').hide();
      $(file.previewElement).insertAfter('#js-dropzone-position');

      // remove the problematic image after a few seconds
      setTimeout(
        function(){
          $(file.previewElement).velocity({
            opacity: 0
          },{
            duration: 1000,
            complete: function(){
              $(file.previewElement).remove();
            }
          });
        } , 5000 );
    });

  }

  // Animate update title and subtitle inputs with ajax
  // author: rffaguiar
  // since: 1.0
  // date: 25/03/2015
  // @dependencies: velocity, sweetalert
  function animateServerResponse(formClass) {

    // handle animation beforeSend
    $(ELS.SinglesContainer).on('ajax:beforeSend', formClass, function() {
      $(this).find('.js-form-update-icon').addClass('fa-refresh fa-spin').velocity({opacity: 1});
    });

    // handle animation after a successfull update
    $(ELS.SinglesContainer).on('ajax:success', formClass, function() {
      var $updateIcon = $(this).find('.js-form-update-icon');
      $updateIcon.velocity({
        opacity: 0
      },{
        complete: function(){
          $updateIcon.removeClass('fa-refresh fa-spin').addClass('fa-check');
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
    $(ELS.SinglesContainer).on('ajax:error', formClass, function() {

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

  // Update title and subtitle with ajax
  // author: rffaguiar
  // since: 1.0
  // date: 20/03/2015
  function updateTitleSubtitle() {
    $(ELS.SinglesContainer).on('blur', ELS.UpdateTitle, function() {
      $(this).closest('form').submit();
    });

    $(ELS.SinglesContainer).on('blur', ELS.UpdateSubtitle, function() {
      $(this).closest('form').submit();
    });

    animateServerResponse('.js-form-update-title');
    animateServerResponse('.js-form-update-subtitle');
  }


  // Put things to work
  // author: rffaguiar
  // since: 1.0
  // date: 20/03/2015
  function init() {

    $(document).ready(function() {
      if ( !$(ELS.Scope).length ) {
        return;
      }
      updateTitleSubtitle();
      singularDropzone();
    });
  }

  init();

}());
