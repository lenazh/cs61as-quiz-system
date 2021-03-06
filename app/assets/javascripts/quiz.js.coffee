onchange = ->
  if map[70] == false and map[17] == false and map[114] == false
    $.ajax
      url: gon.lock_path,
      type: 'POST'

fullscreen = ->
  $('#fullscreen').click (e) ->
    e.preventDefault()
    docElement = document.documentElement
    request = docElement.requestFullscreen or docElement.webkitRequestFullscreen or docElement.mozRequestFullscreen or docElement.msRequestFullscreen
    request.call docElement if typeof request isnt "undefined" and request
    $('#quiz').show()
    $('#fullscreen').hide()
    $('li.name').hide()
    fs = 'webkitfullscreenchange mozfullscreenchange fullscreenchange'
    fullScreen = false
    $(document).on fs, (e) ->
      fullScreen = !fullScreen
      if !fullScreen
        $.ajax
          url: gon.lock_path,
          type: 'POST'

    opts = {
        lineNumbers : true,
        matchBrackets : true,
        theme: "blackboard",
        tabSize: 2,
        smartIndent: true
      }

    editors = (CodeMirror.fromTextArea(textedit, opts) for textedit in $('.textedit'))
    for editor in editors
      do (editor) ->
        id = $(editor.getTextArea()).attr("id")
        if Cookies.get(id) != undefined
          editor.setValue(Cookies.get(id))
        editor.on 'change', ->
          Cookies.set(id, editor.getValue(), { expires: 6000 })
        , editor

  # $('.hilite').keydown (e) ->
  #   if (e.keyCode == 9)
  #     start = this.selectionStart
  #     end = this.selectionEnd
  #     $this = $(this)
  #     $this.val($this.val().substring(0, start) + "\t" + $this.val().substring(end))
  #     this.selectionStart = this.selectionEnd = start + 1
  #     return false

hilite = ->
  $('.hilite').keyup (e) ->
    HighlightLisp.highlight_element(e.target)

# hilite_answer = ->
#   answers = $('.replace')
#   for i in [0...answers.length]
#     HighlightLisp.highlight_element(answers[i])


window.map = {70: false, 17: false, 91: false, 114: false};

window.resetmap = ->
  map[70] = false
  map[17] = false

ready = ->
  if $('#take_quiz_form').length
    fullscreen()
    
    $(window).keydown (e) ->
      if (e.keyCode == 70 || e.keyCode == 17 || e.keyCode == 114)
        window.map[e.keyCode] = true;
        if e.keyCode != 70
          e.preventDefault()
        else
          if window.map[17] == true
            e.preventDefault()

        #alert "key" + String.fromCharCode(e.keyCode)
      setTimeout (-> 
        for val in [70,17,114]
          window.map[val] = false), 500


    $(window).blur -> onchange()
    hilite()
    timer(gon.time_left)
  else if $('#show_quiz').length
    # hilite_answer()
    for show in $('.show')
      CodeMirror.fromTextArea(show, {
        readOnly: true,
        lineNumbers : true,
        theme: "blackboard",
        tabSize: 2
      })
  else
    $(window).off 'blur'



#Countdown timer:

timer = (time) ->
  if time > 0
    [minutes, seconds] = [parseInt(time / 60), time % 60]
    $(".seconds").html("#{seconds} second(s)")
    $(".minutes").html("#{minutes} minute(s)")
    setTimeout (-> timer(time - 1)), 1000
  else
    $(".seconds").html("0 second(s)")
    $("#honesty_statement").prop('checked',true);
    $("#submit_quiz").click()

$(document).ready ready
$(document).on 'page:load', ready
