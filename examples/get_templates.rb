require 'blazingdocs'

client = BlazingDocs.create_client('API-KEY')

templates = client.get_templates