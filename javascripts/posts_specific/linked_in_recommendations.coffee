
$recommendations = []
$textarea        = undefined
$height          = undefined
$style           = $('<style type="text/css">').appendTo('head')

onLinkedInAuth = ->
  $textarea = $('textarea#output')
  $textarea.removeProp('disabled').prop('placeholder', "Loading script... Please wait a second or two.")

  IN.API.Raw("/people/~:(recommendations-received)").method("GET").result (result) ->
    received       = result.recommendationsReceived.values
    receivedCount  = received.length
    profilesLoaded = 0
    $.each received, (i, data) ->
      IN.API.Profile(data.recommender.id).fields(["pictureUrl", "headline", "publicProfileUrl"]).result (result) ->
        profilesLoaded += 1
        recommender    = result.values[0]
        $recommendations.push { 
          text: data.recommendationText, 
          recommender: {
            id: data.recommender.id
            pictureUrl: recommender.pictureUrl
            profileUrl: recommender.publicProfileUrl
            headline: recommender.headline
            name: "#{ data.recommender.firstName } #{ data.recommender.lastName }"
          }
        }
        unless profilesLoaded < receivedCount
          $('#plugin .settings').show()
          rebuildScriptAndPreview()
    
rebuildScriptAndPreview = ->
  # console.log $recommendations
  $('#plugin .preview .content').html( '' )
  $textarea.val( "" )

  salt  = "bcbd66f0-6c45-11e4-9803-0800200c9a66"
  theme =
    """
    #linkedIn-recommendations-#{salt} { overflow-y: #{ if $height is undefined then 'none' else 'scroll' }; height: #{ if $height is undefined then 'auto' else "#{ $height }px" }; font-family: Helvetica,FreeSans,"Liberation Sans",Helmet,Arial,sans-serif; } 
    #linkedIn-recommendations-#{salt} .recommendation  > img { border: none; border-radius: 0; width: 38px; float: left; margin: 0 10px 4px 0; } 
    #linkedIn-recommendations-#{salt} .recommendation  hgroup a { color: #069; font-size: 12px; text-decoration: none; font-weight: bold; display: block; line-height: 14px; }
    #linkedIn-recommendations-#{salt} .recommendation  hgroup a:hover { text-decoration: underline; }
    #linkedIn-recommendations-#{salt} .recommendation  hgroup h5 { font-weight: normal; color: #333333; font-size: 12px; line-height: 14px; }
    #linkedIn-recommendations-#{salt} .recommendation  p { clear: left; color: #666666; font-size: 12px; line-height: 14px; }
    """
  $style.html( theme )
  wrapper = $('<div>')
  output  = $("<div id=\"linkedIn-recommendations-#{salt}\">")
  output.appendTo(wrapper)

  $.each $recommendations, (i, data) ->
    recommendation =
      """
      <div class="recommendation">
        <img src="#{ data.recommender.pictureUrl }"></img>
        <hgroup>
          <a href="#{ data.recommender.profileUrl }" target="_blank">#{ data.recommender.name }</a>
          <h5>#{ data.recommender.headline }</h5>
        </hgroup>
        <p style="clear: left;">#{ data.text }</p>
      </div>
      """
    $(recommendation).appendTo(output)

  $('#plugin .preview .content').append( output.clone() )

  embedCode = 
    """
    <!-- LinkedIn recommendations plugin. Generated: #{ Date() }-->
    <script>
      var style = document.createElement('style');
      style.type = 'text/css';
      style.innerHTML = '#{ theme.replace(/(\r\n|\n|\r)/gm,"") }';
      document.getElementsByTagName('head')[0].appendChild(style);

      document.write("#{ wrapper.html().replace(/(")/g, '\\"').replace(/(\r\n|\n|\r)/gm,"") }");
    </script>
    """

  $textarea.val( embedCode )

$(document).ready ->
  $('input[name="height"]').on('change', ->
    return unless $recommendations.length
    if $(this).val() is "auto"
      $height = undefined
    else
      $height = $('#heightInput').val()
    console.log $height
    rebuildScriptAndPreview()
  ).trigger 'change'