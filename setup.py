from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize

examples_extension = Extension(
    name="pyCardRange",
    sources=["pyCardRange.pyx"],
    language='c++',
    libraries=["ompeval", "boost_python"],
    library_dirs=["./lib"],
    include_dirs=["./omp"]
)

setup(
  name = 'omp',
  ext_modules = cythonize([examples_extension])
)
