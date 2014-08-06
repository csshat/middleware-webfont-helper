google = require '../fonts/google'
typekit = require '../fonts/typekit'

matchFontInLibraries = (name, libraries) ->
  for library in libraries
    if name in library.getNames()
      return [true, library, name]

  return [false, null, null]

module.exports = (layer, settings, next) ->
  if layer.baseTextStyle?
    libraries = []
    if settings.enableTypekit
      libraries.push typekit
    if settings.enableGoogleFonts
      libraries.push google

    [found, library, name] = matchFontInLibraries layer.baseTextStyle.font.name, libraries

    if found
      layer.baseTextStyle.font.name = library.normalizeName name
      layer.notifications.push "Webfont found: #{library.getLink(name)}"

  next()
