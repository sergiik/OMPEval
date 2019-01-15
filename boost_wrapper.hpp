#include <boost/python/object.hpp>

inline boost::python::object get_as_bpo(PyObject* o) {
        return boost::python::object(boost::python::handle<>(boost::python::borrowed(o)));
}
