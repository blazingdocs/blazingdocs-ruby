require 'blazingdocs'
require 'blazingdocs/parameters/merge_parameters'

client = BlazingDocs.create_client('API-KEY')

templates = client.get_templates