from __future__ import division
import subprocess as sub
sub.call(['python', 'setup.py', 'build_ext', '--inplace'])

import numpy as np
from clrc import Game
import pylab as plt

nplayers = 20
winners = np.zeros(nplayers)
iters = np.zeros(games, dtype=int)

games = 300000
game = Game(nplayers, 3, 3)
for g in range(games):
    iters[g], won = game.play()
    winners[won-1] += 1

print winners
plt.plot( winners / winners.sum() * 100)
plt.axhline( 1./len(winners) * 100)
plt.show()
