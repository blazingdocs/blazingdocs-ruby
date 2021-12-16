require 'blazingdocs'
require 'blazingdocs/parameters/merge_parameters'

client = BlazingDocs.create_client('API-KEY')

merge_parameters = BlazingDocs::MergeParameters.new
merge_parameters.sequence = false
merge_parameters.data_source_type = 'json'
merge_parameters.strict = true

data = File.open('./templates/PO-Template.json').read
template = File.open('./templates/PO-Template.docx')

merge_result = client.merge(data, 'output.pdf', merge_parameters, template)