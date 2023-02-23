
#Model Concepts in Dart#

by Dzenan Ridjanovic
started on 2011-12-09

**Categories**: design tool, graphical models, canvas, local storage, json.

##Description
A graphical design tool for domain models of
[EDNetCore](https://github.com/ednet-dev/ednet_core).
Spirals can be found in the [mb_spirals](https://github.com/dzenanr/mb_spirals)
project.
The last spiral is a graphical model designer.
The json representation of a model is generated in Model Concepts.
This representation is used in the
[EDNetCoreGen](https://github.com/ednet-dev/ednet_core_gen) project to
generate code for a model supported by the
[EDNetCore](https://github.com/ednet-dev/ednet_core) domain model framework.

[Summary](http://goo.gl/DqF7d)

If an attribute name is oid or code, it will not be generated as a specific
attribute in EDNetCore, because every concept inherits both the
oid (object id generated automatically by ednet_core) and
code (an id that may be null, but if non-null it must be unique) properties.

In the attribute init field, you may use increment for incrementing a value
of the int type in EDNetCore by increment starting with increment.
The empty text indicates that a default value will be a non-null empty String.
For the DateTime type, the now value determines the today's current time
at the moment of adding an entity in EDNetCore.

### Based On

[Magic Boxes (in Java)](http://code.google.com/p/magic-boxes/)

and

[Modelibra Modeler (in Java)](http://www.modelibra.org/)

### More Details

[**ednet_core: Domain Model Framework**](http://goo.gl/Fd08zZ)

[*Version History*](LOG.md)

[*Learning Dart*](http://learningdart.org/)

[Blog](http://dzenanr.github.io/)

[On Dart](https://plus.google.com/+OndartMe)
