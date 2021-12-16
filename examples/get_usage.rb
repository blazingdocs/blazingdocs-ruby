require 'blazingdocs'
require 'blazingdocs/parameters/merge_parameters'

client = BlazingDocs.create_client('API-KEY')

usage = client.get_usage