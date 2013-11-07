
#Model Concepts in Dart#

by Dzenan Ridjanovic
started on 2011-12-09

**Categories**: design tool, graphical models, canvas, local storage, json.

##Description
A graphical design tool for domain models of
[dartling](https://github.com/dzenanr/dartling).
Spirals can be found in the [mb_spirals](https://github.com/dzenanr/mb_spirals)
project.
The last spiral is a graphical model designer.
The json representation of a model is generated in Model Concepts.
This representation is used in the
[dartling_gen](https://github.com/dzenanr/dartling_gen) project to
generate code for a model supported by the
[dartling](https://github.com/dzenanr/dartling) domain model framework.

[Summary](http://goo.gl/DqF7d)

If an attribute name is oid or code, it will not be generated as a specific
attribute in dartling, because every concept inherits both the
oid (object id generated automatically by dartling) and
code (an id that may be null, but if non-null it must be unique) properties.

In the attribute init field, you may use increment for incrementing a value
of the int type in dartling by increment starting with increment.
The empty text indicates that a default value will be a non-null empty String.
For the DateTime type, the now value determines the today's current time
at the moment of adding an entity in dartling.

Based on:
[Magic Boxes (in Java)](http://code.google.com/p/magic-boxes/)
and
[Modelibra Modeler (in Java)](http://www.modelibra.org/)

[Blog](http://dzenanr.github.io/)

[On Dart](https://plus.google.com/+OndartMe)

