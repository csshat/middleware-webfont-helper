google = require '../fonts/google'
typekit = require '../fonts/typekit'

normalize = (str) ->
  str.toLowerCase().replace /( |-)/g, ''

matchFontInLibraries = (name, libraries) ->
  normalizedName = normalize(name)
  for library in libraries
    fonts = library.getNames().filter (font) -> name is font or normalizedName.indexOf(normalize(font)) > -1 or normalize(font).indexOf(normalizedName) > -1
    if fonts.length > 0
      return [true, library, fonts[0]]

  return [false, null, null]

processFontObject = (font, libraries, layer) ->
  if font.name?
    [found, library, name] = matchFontInLibraries font.name, libraries

    if found
      font.name = library.normalizeName name
      layer.notifications.push
        content: "Webfont found: #{library.getLink(name)}"
        dismiss: 'document'
        icon: if library.icon? then library.icon else null

module.exports = (layer, settings, next) ->
  if layer.baseTextStyle? or layer.textStyles?.length
    libraries = []
    if settings.enableTypekit
      libraries.push typekit
    if settings.enableGoogleFonts
      libraries.push google

    if layer.baseTextStyle?.font?.name?
      processFontObject layer.baseTextStyle.font, libraries, layer

    processFontObject(style.font, libraries, layer) for style in layer.textStyles when style?.font? if layer.textStyles?.length

  next()
