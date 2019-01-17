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

cdef extern from "omp/EquityCalculator.h" namespace "omp::EquityCalculator":
    cppclass Results:
        unsigned players
        double equity[6]
        uint64_t wins[6]
        double ties[6]
        uint64_t winsByPlayerMask[1 << 6]
        uint64_t hands, intervalHands
        double speed, intervalSpeed0
        double time, intervalTime
        double stdev
        double stdevPerHand
        double progress
        uint64_t preflopCombos
        uint64_t skippedPreflopCombos
        uint64_t evaluatedPreflopCombos
        uint64_t evaluations
        bool enumerateAll
        bool finished

cdef extern from "omp/EquityCalculator.h" namespace "omp":
    cppclass EquityCalculator:
        EquityCalculator() except +
        bool start(vector[CardRange]& handRanges, 
        	uint64_t boardCards = 0,
            uint64_t deadCards = 0,
            bool enumerateAll = 0,
            double stdevTarget = 0.05,
            bpo callback = 0,
            double updateInterval = 0.2,
            unsigned threadCount = 0) except +
        void wait()
        Results getResults()

cdef class PyCardRange:
    cdef CardRange *c_card_range

    def __cinit__(self, const char* text):
        self.c_card_range = new CardRange(text)

    def __dealloc__(self):
        del self.c_card_range

cdef class PyResults:
    cdef Results c_results

    def __cinit__(self):
        pass

    def getPlayers(self):
        return self.c_results.players

    def getEquity(self):
        return self.c_results.equity

cdef object PyPyResults_factory(Results r):
    cdef PyResults py_obj = PyResults()
    # Set extension pointer to existing C++ class ptr
    py_obj.c_results = r
    return py_obj

cdef class PyEquityCalculator:
    cdef EquityCalculator c_ec

    def __cinit__(self):
        pass

    def start(self, list r, callback):
        cdef vector[CardRange] v = vector[CardRange]()
        cdef bpo f = get_as_bpo(callback)
        for i in range(len(r)):
            v.push_back(CardRange(r[i]))
        print('executing c_ec.start(v)')
        #self.c_ec.start(v)
        self.c_ec.start(v, 0)

    def wait(self):
        self.c_ec.wait()

    def getResults(self):
        return PyPyResults_factory(self.c_ec.getResults())