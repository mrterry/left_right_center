from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import numpy
print numpy.get_include()

setup(
        cmdclass = {'build_ext': build_ext},
        ext_modules = [Extension('clrc', ['clrc.pyx'])]
        )
