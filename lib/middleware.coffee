google = require '../fonts/google'
typekit = require '../fonts/typekit'

normalize = (str) ->
  str.toLowerCase().replace ' ', ''

matchFontInLibraries = (name, libraries) ->
  normalizedName = normalize(name)
  for library in libraries
    for font in library.getNames() when name is font or normalizedName.indexOf(normalize(font)) or normalize(font).indexOf(normalizedName)
      return [true, library, name]

  return [false, null, null]

module.exports = (layer, settings, next) ->
  if layer.baseTextStyle?.font?.name?
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
