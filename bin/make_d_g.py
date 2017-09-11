#!/usr/bin/python

import sys
sys.path.append("../lib/python")
import cPickle
import numpy as np
import argparse 

## Arguments
parser = argparse.ArgumentParser(description="Make the histrogram distrubtions for period, luminosity, Z and R.")
parser.add_argument('-f', '--outfile', help='output distribution file', default='dist_gen')
args = parser.parse_args()

## bins for the population distributions
nbins_p=20  #period
nbins_l=20  #luminosity
nbins_z=20  #Z scale height
nbins_R=20  #R distribution

## Make changes here to introduce your own distribitons
## corr_var_hist = histogram values
## vare_pop = bin edges
corr_p_hist,pe_pop=np.histogram(np.random.uniform(0.001, 8000.00, nbins_p**2),bins=nbins_p) 
corr_l_hist,le_pop=np.histogram(np.random.uniform(1.500, 4.70, nbins_l**2),bins=nbins_l) 
corr_R_hist,Re_pop=np.histogram(np.random.uniform(0.000, 12.3, nbins_R**2),bins=nbins_R) 
corr_z_hist,Ze_pop=np.histogram(np.random.uniform(-1.06, 1.91, nbins_z**2),bins=nbins_z) 


## Make dicts
dataDict={'pHist':np.array(corr_p_hist), 'pBins':np.array(pe_pop), 'lHist':np.array(corr_l_hist), 'lBins':np.array(le_pop),\
        'RHist':np.array(corr_R_hist), 'RBins':np.array(Re_pop), 'ZHist':np.array(corr_z_hist),'ZBins':np.array(Ze_pop) }

## Write dicts
output=open(args.outfile,'wb')
cPickle.dump(dataDict,output,2)
output.close()

## dicts read check
try:
    f = open(args.outfile, 'rb')
except IOError:
    print "Could not open file {0}.".format(sys.argv[1])
    sys.exit()
pop_read = cPickle.load(f)
f.close()
