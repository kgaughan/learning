Originally this was going to be about working out how to use Paste and
PasteScript to generate projects from templates. Now it's going to be me
evaluating a number of project generation tools.

=============== =======================================
Tool            Manual/Project Homepage
--------------- ---------------------------------------
PasteScript_    http://pythonpaste.org/script/
mr.bob_         http://mrbob.readthedocs.org/
Templer_        http://templer-manual.readthedocs.org/
cookiecutter_   https://github.com/audreyr/cookiecutter
diecutter_      http://diecutter.io/
=============== =======================================

I was going to look at Ubuntu Quickly, but that has a heavy Ubuntu bent to it
and I can't install it from PyPI, so both of those eliminate it early.

.. _templer:

Templer
-------

- Installed as `templer.core <https://pypi.python.org/pypi/templer.core>`_

- Last updated 2012-05-18; last repo activity 2013-04-25

- Uses `cheetah <https://pypi.python.org/pypi/Cheetah>`_ as its template
  engine; would prefer Jinja

- Templates are installed as python packages and use setuptools hooks to
  register themselves

- Also ends up installing Paste, PasteDeploy, and PasteScript_, which is
  peculiar to say the least

- Slight legacy Plone/Zope bias

- Documentation on how to create new templates is lacking

- Invoked as follows::

    $ templer <template> <output-name>

- Output from ``templer --help`` indicates that it's intended to be a wrapper
  around PasteScript_

- I'm not seeing much advantage over just using ``paster create``.

mr.bob
------

- Silly name

- Works on python 2 and 3 without having to be ran through 2to3

- Uses Jinja as its template engine

- Last update was 2013-06-09.

- Intended as a successor to both PasteScript_ and Templer_.

- Developer proposed a merger with cookiecutter_ recently and may be
  abandoning it in favour of cookiecutter_:
  https://github.com/audreyr/cookiecutter/issues/44

- Templates also installed as python packages

- Documentation is quite good

- Invoked as follows::

    $ mrbob [-O<output-name>] <template>

  The default output directory is the current directory.

- Format for template names is <package>:<template> as unfortunately it
  doesn't use setuptools hooks.

- Filename templating is pretty much the same as PasteScript: +placeholder+

.. _cookiecutter:

cookiecutter
------------

- Less silly name.

- Definitely under active development, and it seems to have a good-size
  community.

- Plays nice with Python 2 and 3.

- Also uses Jinja.

- It has directory and repo based templates, but unfortunately not
  package-based ones.

- Documentation needs work: the structure of templates isn't explained, but
  the API is well-documented.

- More uniform templating than PasteScript-derived systems: Jinja is used
  for everything.

- Invoked as follows::

    $ cookiecutter <template>

  The output directory name is generated based on your answers upon
  invocation.

- git interfacing involves shelling out to use git rather than depending
  on the likes of dulwich.

.. _diecutter:

diecutter
---------

This is completely different from all the others. It's more 'templating as a
service' than anything else. I think it, or something like it, might be useful
for deployment at work as a globally available templating service available
from shell scripts.

The one issue I have its that it's somewhat heavyweight; it pulls in the
following dependencies in addition to the ones installed by the other packages
I've been trying out:

 * cornice
 * waitress
 * django
 * mock
 * webtest
 * pyramid
 * simplejson
 * WebOb
 * beautifulsoup4
 * Chameleon
 * Mako
 * repoze.lru
 * zope.interface
 * zope.deprecation
 * venusian
 * translationstring

That, to be frank, is crazypants. Moreover, it's written with Pyramid, so why
it needs to pull in Django as a requirement rather than as an 'extra' is a
mystery to me. The fact that a whole pile of testing dependencies are pulled
in as basic dependencies is also annoying.

One nice thing about it is that it can work with not just single files, but
whole directories, which is pretty sweet.

It appears to do templating with Jinja, but filename templating is done in
the PasteScript style of +placeholder+.

I'm not sure I'd end up using this, but at least it's an interesting idea.

.. _pastescript:

PasteScript
-----------

TODO.
