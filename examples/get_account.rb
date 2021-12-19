require 'blazingdocs'

client = BlazingDocs.create_client('API-KEY')

account = client.get_account