# Redmine Project Colors Plugin

This plugin allows to set a headline color for each project according to a custom field. This project is not intended for public use, it was created
for our internal company needs. But you can use it if you want.

The plugin does not require any migration, it just adds two new fields to the Redmine administration.

This plugin is a fork of [Redmine Progressive Projects List Plugin](https://github.com/ergoserv/redmine-progressive-projects-list), although almost nothing left from the original code.

## Compatibility
I am using it with Redmine 4.1.6, but it should work with any Redmine version starting from 4.0.0.

## Installation
- Download the plugin archive and extract it to `<redmine_path>/plugins`.
- Check or rename plugin's directory to `<redmine_path>/plugins/redmine_project_colors` directory.
- Restart Redmine.
- Enjoy!

## Usage
- Create a key/value list custom field for projects. You can give it any name.
- Define the list of values in the custom field settings. These values can mean anything you want.
- Go to the plugin settings and configure it:
  - **Color Field ID**: Enter your custom field ID. You can easily spot it in the URL when you edit the field properties.
  - **Color Assignment**: Define the colors for values you defined in the custom field settings:
    Each color is defined on its own line in the format `value: #color` where the `value` is the custom field value id (you will see it when you hover the *Delete* link in the custom field settings) and the `color` is a hexadecimal color code including its initial hash. For example:
	```text
	1: #ff0000
	2: #00ff00
	3: #0000ff
	```
	If you don't provide a color for a value, it will be displayed in standard color defined by your theme.

## License
This plugin is licensed under the MIT license. See LICENSE for details.
