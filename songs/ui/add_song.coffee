{render} = require '../../helpers/snippets.coffee'
$        = require '../../lib/zepto.js'
router   = require '../../router/router.coffee'
songs    = require '../songs.coffee'

exports.handler = ->
    render '#content', (require './add_song.hbs')

    $('#text').on focus: -> $('#text-container').addClass 'focus'
    $('#text').on blur: -> $('#text-container').removeClass 'focus'
    $('#text').on "input", (e) ->
        $('#preview').html songs.text_to_html songs.parse_song($('#text').val()).data.text

    $('#song-file').on change: (e) ->
        reader = new FileReader()
        reader.onload = (e) ->
            res = songs.parse_song e.target.result
            $('#author').val res.meta.author
            $('#title').val res.meta.title
            $('#text').text res.data.text; $('#text').trigger 'input'
            $('legend.divide span').text 'edit'
        reader.readAsText (e.target.files ? e.dataTransfer.files)[0]

    $('#add-song-form').submit (e) ->
            e.preventDefault()
            s = new songs.Song meta: { author: $('#author').val(), title: $('#title').val() }, txt: $('#text').val()
            router.redirect s.save()
