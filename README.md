SwiftStack Plugin for Fuel
==========================


Overview
--------

SwiftStack plugin for Fuel provides the functionality to integrate SwiftStack
Swift cluster for Mirantis OpenStack as object storage backend option.


Requirements
------------

| Requirement                    | Version/Comment |
|--------------------------------|-----------------|
| Mirantis OpenStack compatility | 8.0 or higher   |
| A running SwiftStack Swift cluster | all versions, the `Keystone Auth` and `'Keystone Auth Token Support` middlewares must be enable |


Limitations
-----------

The plugin is only support integration a running SwiftStack Swift cluster in first stage.


Build Fuel plugin
-----------------

```
# Create a virtualenv for Fuel to build plugin
$ sudo apt-get install python-dev python-pip python-virtualenv
$ virtualenv fuel

# Clone fule-plugin-builder and SwiftStack Swift Fuel plugin
$ git clone https://github.com/openstack/fuel-plugins
$ git clone https://github.com/openstack/fuel-plugin-swiftstack

$ source fuel/bin/activate
(fuel) $ cd fuel-plugins/fuel_plugin_builder/
(fuel) fuel-plugins/fuel_plugin_builder $ pip install -e .

(fuel) $ cd fuel_plugin_swiftstack/
(fuel) fuel_plugin_swiftstack $ fpb --build ./
Plugin is built
```

