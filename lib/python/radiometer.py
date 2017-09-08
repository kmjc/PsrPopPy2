#!/usr/bin/python

import math


def calcFlux(snr,
             beta,
             Trec,
             Tsky,
             gain,
             n_p,
             t_obs,
             bw,
             duty):

    """Calculate flux assuming radiometer equation"""

    signal = signalterm(beta,
                        Trec,
                        Tsky,
                        gain,
                        n_p,
                        t_obs,
                        bw,
                        duty)

    return snr * signal


def calcSNR(flux,
            beta,
            Trec,
            Tsky,
            gain,
            n_p,
            t_obs,
            bw,
            duty):

    """Calculate the S/N ratio assuming radiometer equation"""

    signal = signalterm(beta,
                        Trec,
                        Tsky,
                        gain,
                        n_p,
                        t_obs,
                        bw,
                        duty)

    return flux / signal


def signalterm(beta,
               Trec,
               Tsky,
               gain,
               n_p,
               t_obs,
               bw,
               duty):

    """Returns the rest of the radiometer equation (aside from
        SNR/Flux"""

    dterm = duty / (1.0 - duty)
    return beta * (Trec+Tsky) * math.sqrt(dterm) \
        / gain / math.sqrt(n_p * t_obs * bw)

def single_pulse_snr(n_p,bw,duty,T_sys,gain,S_max):
    eta=0.868
    S_sys=T_sys/gain
    return(eta*math.sqrt(n_p*bw*duty)*S_max/S_sys)
