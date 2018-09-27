=====================================
Repository of Machine Learning Models
=====================================

This repository collects together an archive of pre-built machine
learning models that can be readily shared for individuals to download
and to demonstrate the model in action. 

The sample R pre-built models *rain-tomorrow*, *iris*, and
*clothes-recommender* serve as templates which model package authors
can mimic. The model package file *.mlm* is simply a zip archive
containing scripts like *demo.R* or *demo.py*, and the required
support files. The *DESCRIPTION.yaml* file contains meta-information
about the package and is used by the mlhub command line tool.

DESCRIPTION.yaml
================

A sample DESCRIPTION.yaml file is::

  meta:
    name        : iris
    title       : Classical iris plant species classifier.
    keywords    : r, iris, biology, decision tree, rpart, classification
    languages   : R
    modeller    : rpart
    type        : decision tree
    display     : display
    version     : 1.1.6
    maintainer  : Graham Williams <Graham.Williams@microsoft.com>
    dependencies:
      R: rpart, magrittr, caret, rpart.plot, RColorBrewer
  commands:
    demo    : Apply the model to a sample dataset.
    print   : Print a textual summary of the model.
    display : Display a graphical representation of the model.
    score   :
      description: Apply the model to interactive or supplied dataset.
      optional: <csv file> A CSV file with columns as noted in README.


license
-------

One of *gpl3* (strong license requiring derivative works to also be open
source) or *mit* (moderate license not limiting derivative work). A
LICENSE file is provided within the package.

language
--------

This can be *python* or *R*. The language is then a dependency that is
checked for and installed as required.

dependencies
------------

A list of other packages (and optionally versions) that the model
depends on. For python these might form the contents of
requirements.txt for a pip install, for example. On Ubuntu, specific
OS packages might be searched for to be installed before using pip
install. Similarly for R packages, OS distributed versions of the
packages are sought first and then R's own package installer is used
if no OS version found. In general, we are moving to perform the
dependency install within a local container for each model so as to
not require sys admin access nor to affect other users.

Examples::

  dependencies: rattle, rpart, magrittr


display
-------

A list of commands which implemented by the model package that require
a graphic display to present visual results.  MLHub will check if
there is a display available and if not the user is informed and given
the option to exit or continue.

Examples::

  display: demo display


modeller
--------

The name and email address of the original model developer. This can
be different to the person who packages the model for the MLHub.

author
------

The name and email address of the person who packaged the model for
sharing on ML Hub.

maintainer
----------

The name and email address of the person who is maintaining the model
package for the ML Hub.

LICENSE
=======

Each model archive must come with a license with a LICENSE file
capturing the license. Depending on the license of the original model,
the model package author may be limited as to the choice of
license. Generally favoured licenses include GPL3 and MIT.

