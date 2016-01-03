""""
This is a saved model run from invest_natcap.recreation.recreation_client.
Generated: 12/30/15 07:15:13
InVEST version: 3.2.0
"""

import invest_natcap.recreation.recreation_client


args = {
        u'aoi_file_name': u'/home/mayer/recreation/edinburghAOI_UTM_new.shp',
        u'cell_size': 250.0,
        u'comments': u'',
        u'data_dir': u'',
        u'download': False,
        u'global_data': True,
        u'grid': True,
        u'grid_type': u'0',
        u'landscan': True,
        u'lulc': False,
        u'mode': u'initial',
        u'osm': False,
        u'workspace_dir': u'/home/mayer/recreation',
}

if __name__ == '__main__':
    invest_natcap.recreation.recreation_client.execute(args)
