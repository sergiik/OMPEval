from libcpp cimport bool
from libcpp.vector cimport vector
from libc.stdint cimport uint64_t

cdef extern from "omp/CardRange.h" namespace "omp":
    cdef cppclass CardRange:
        CardRange(const char* text) except +

cdef extern from "boost_wrapper.hpp":
    cdef cppclass bpo "boost::python::object":
        # manually set name (it'll conflict with "object" otherwise
        bpo()
    bpo get_as_bpo(object)

cdef extern from "omp/EquityCalculator.h" namespace "omp":
    cdef cppclass EquityCalculator:
        EquityCalculator() except +
        bool start(vector[CardRange]& handRanges, 
        	uint64_t boardCards = 0,
            uint64_t deadCards = 0,
            bool enumerateAll = false,
            double stdevTarget = 5e-5,
            bpo callback = nullptr,
            double updateInterval = 0.2,
            unsigned threadCount = 0) except +
        void wait()

cdef class PyCardRange:
    cdef CardRange *c_card_range

    def __cinit__(self, const char* text):
        self.c_card_range = new CardRange(text)

    def __dealloc__(self):
        del self.c_card_range

cdef class PyEquityCalculator:
    cdef EquityCalculator c_ec

    def __cinit__(self):
        pass

    def start(self, list r):
        cdef vector[CardRange] v = vector[CardRange]()
        for i in range(len(r)):
            v.push_back(CardRange(r[i]))
        print('executing c_ec.start(v)')
        self.c_ec.start(v)

    def wait(self):
        self.c_ec.wait()
