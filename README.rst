=====================================
Repository of Machine Learning Models
=====================================

This repository collects together an archive of pre-built machine
learning models that can be readily shared for individuals to download
and to demonstrate the model in action. 

The sample R model *rain-tomorrow* is a template which other model
package authors can mimic.

DESCRIPTION.yaml
================

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
OS packages are searched for to be installed before using pip
install. Similarly for R packages, OS distributed versions of the
packages are sought first and then R's own package installer is used
if no OS version found.

Examples::

  dependencies: rpart, magrittr

For Ubuntu this might be translated to::

  wajig install r-cran-rpart r-cran-magrittr

For Windows this might be translated to::

  Rscript -e 'install.packages(c("rpart", "magrittr"))'

The latter is also what would have been run if for Ubuntu no OS
packages were found for the dependencies.

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

