bean
====

An utility to generate JSON file from a coffee-script as well as yaml.

Installation
---------

    $ npm install -g coffee-bean

Usage
-----

    $ bean [-s file.bean|file.coffee|file.yml|file.yaml]
    # file.json will be generated

Motivation
---------

Writing JSON files manually is tedious and error prone

* Forgetting to add commas between items
* Adding commas to the last item of an error or an object
* Forgetting to quote the keys
* Cannot add comments

Coffeescript's object notation is much cleaner by comparison.

A bean file is basically a coffeescript file that returns a JSON
object. The object will then be formatted according to JSON rules.
You can perform any legal coffeescript logic as long as the end result
is a JSON object.

This is best used for managing configuration files, such as
package.json.  Just take a look at this module's [package.bean](./bean/package.bean) for
inspiration.

YAML is also now supported. 

LICENSE
------

Released under [MIT License](http://opensource.org/licenses/MIT).
