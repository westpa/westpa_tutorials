import numpy as np
import westpa
import logging

log = logging.getLogger(__name__)
log.debug('loading module %r' % __name__)

def walkers_test(we_driver, ibin, **kwargs):
    log.debug('using odld_system._group_walkers_identity')
    bin_set = we_driver.next_iter_binning[ibin]

    log.debug('bin_set: {!r}'.format(bin_set)) #KFW 

    list_bins = [set()]
    log.debug('list_bins empty: {!r}'.format(list_bins)) #KFW

    for i in bin_set:

        log.debug('>>> i: {!r}'.format(i)) #KFW

        list_bins[0].add(i)

    log.debug('list_bins: {!r}'.format(list_bins)) #KFW
    return list_bins


def walkers_by_color(we_driver, ibin, states, **kwargs):
    '''Groups walkers inside of a bin according to a user defined state definition.
    Must be n-dimensional.

    Creates a group, which takes the same data format as a bin, and then passes into the
    normal split/merge functions.'''
    # Pass in the bin object instead of the index
    log.debug('using group.walkers_by_color')
    log.debug('state definitions: {!r}'.format(states))
    # Generate a dictionary which contains bin indices for the states.
    states_ibin = {}
    for i in states.keys():
        for pcoord in states[i]:
            try:
                states_ibin[i].append(we_driver.bin_mapper.assign([pcoord])[0])
            except:
                states_ibin[i] = []
                states_ibin[i].append(we_driver.bin_mapper.assign([pcoord])[0])
    for state in states_ibin:
        states_ibin[state] = list(set(states_ibin[state]))
    log.debug('state bins: {!r}'.format(states_ibin))
    bin = we_driver.next_iter_binning[ibin]
    groups = dict()
    z = 0
    for segment in bin:
        color = we_driver.bin_mapper.assign([segment.pcoord[0,:]])[0]
        for i in states_ibin.keys():
            if color in set(states_ibin[i]):
                segment.data['color'] = np.float64(i)
            else:
                segment.data['color'] = -1
        try:
            groups[segment.data['color']].add(segment)
        except KeyError:
            groups[segment.data['color']] = set([segment])
    return groups.values()

    
def color_data_loader(fieldname, data_filename, segment, single_point):
    '''Groups walkers inside of a bin according to a user defined state definition.
    Must be n-dimensional.

    Creates a group, which takes the same data format as a bin, and then passes into the
    normal split/merge functions.'''
    # Pass in the bin object instead of the index
    # Generate a dictionary which contains bin indices for the states.
    we_driver = westpa.rc.get_we_driver()
    states = we_driver.subgroup_function_kwargs['states']
    system = westpa.rc.get_system_driver()
    states_ibin = {}
    for i in states.keys():
        for pcoord in states[i]:
            try:
                states_ibin[i].append(system.bin_mapper.assign([pcoord])[0])
            except:
                states_ibin[i] = []
                states_ibin[i].append(system.bin_mapper.assign([pcoord])[0])
    for state in states_ibin:
        states_ibin[state] = list(set(states_ibin[state]))
    color = system.bin_mapper.assign([segment.pcoord[0,:]])[0]
    
    for i in states_ibin.keys():
        if color in set(states_ibin[i]):
            segment.data['color'] = np.float64(i)
        else:
            segment.data['color'] = -1
