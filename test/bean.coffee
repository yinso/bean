assert = require 'assert'
fs = require 'fs'
path = require 'path'
{run} = require '../src/bean'

source = path.join(__dirname, '../package.bean')
target = path.join(__dirname, '../package.json')

describe 'bean Test', () ->
  it "should equal #{target}", (done) ->
    run {source: source, noTarget: true}, (err, result) ->
      if err
        done err
      else
        fs.readFile target, (err, data) ->
          if err
            done err
          else
            assert.equal result, data.toString()
            done err
  