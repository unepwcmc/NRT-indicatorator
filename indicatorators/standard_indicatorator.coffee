fs = require('fs')
_  = require('underscore')

class StandardIndicatorator
  constructor: (indicatorType, indicatorCode) ->
    indicatorType = indicatorType.toLowerCase()

    @indicatorDefinition = JSON.parse(
      fs.readFileSync("./#{indicatorType}_indicator_definitions.json", 'UTF8')
    )[indicatorCode]

  indicatorate: (data) ->
    unless data?
      throw "No data to indicatorate"

    valueField = @indicatorDefinition.valueField

    outputRows = []

    for row in data
      value = row[valueField]
      continue unless value?
      text = @calculateIndicatorText(value)
      outputRows.push(_.extend(row, text: text))

    return outputRows

  calculateIndicatorText: (value) ->
    value = parseFloat(value)
    ranges = @indicatorDefinition.ranges

    for range in ranges
      return range.message if value > range.minValue

    return "Error: Value #{value} outside expected range"

module.exports = StandardIndicatorator
