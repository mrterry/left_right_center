import numpy as np
cimport numpy as np
from libc.stdlib cimport malloc, free
import numpy.random
import cython

cdef int LEFT[2]
LEFT[:] = [0, 1]

cdef int RIGHT[2]
RIGHT[:] = [2, 3]

cdef int CENTER[1]
CENTER[:] = [4]

cdef int FREE[1]
FREE[:] = [5]

cdef int POT
POT = 0
cdef int ACTIVE
ACTIVE = 0


cdef class Game:
    cdef int players
    cdef int ante
    cdef int dice
    cdef int *dollars
    cdef int active
    cdef int pot
    
    def __init__(self, int players, int ante, int dice):
        self.players = players
        self.ante = ante
        self.dice = dice
        self.dollars = <int *>malloc((self.players+2)*sizeof(int))

    @cython.profile(True)
    def play(self):
        cdef int p, i
        with nogil:
            for i in range(self.players):
                self.dollars[i] = self.ante
            for i in range(self.players, self.players+2):
                self.dollars[i] = 0
            self.pot = 0
            self.active = self.ante*self.players

        for i in range(1000):
            with nogil:
                p = 1
                self.dollars[p] += self.dollars[self.players+1]
                self.dollars[self.players+1] = 0

            for p in range(1, self.players):
                windex = self.move(p)
                if windex != -1:
                    return i, windex

            with nogil:
                p = self.players
                self.dollars[p] += self.dollars[0]
                self.dollars[0] = 0

            windex = self.move(p)
            if windex != -1:
                return i, windex
        raise Exception('too many iterations')

    @cython.profile(True)
    cdef int move(self, int p):
        cdef int d, num
        with nogil:
            if self.dollars[p] > self.dice:
                num = self.dice
            else:
                num = self.dollars[p]
            self.dollars[p] -= num
        cdef np.ndarray rands = numpy.random.randint(6, size=num)
        for d in range(num):
            d = rands[d]
            with nogil:
                if d in LEFT:
                    self.dollars[p+1] += 1
                elif d in RIGHT:
                    self.dollars[p-1] += 1
                elif d in CENTER:
                    if self.active == 1:
                        return p
                    self.pot += 1
                    self.active -= 1
                elif d in FREE:
                    self.dollars[p] += 1
        cdef int mone = -1
        return mone
