require 'blazingdocs'

client = BlazingDocs.create_client('API-KEY')

usage = client.get_usage