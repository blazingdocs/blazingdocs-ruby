# BlazingDocs C#, .NET client
High-performance document generation API. Generate documents and reports from СSV, JSON, XML with 99,9% uptime and 24/7 monitoring.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blazingdocs'
```
## Integration basics

### Setup

You can get your API Key at https://app.blazingdocs.com
```ruby
client = BlazingDocs.create_client('api-key')
```
### Getting account info

```ruby
account = client.get_account
```

### Getting merge templates list

```ruby
templates = client.get_templates

# with parent folder path
templates = client.get_templates('parentfolder')
```

### Getting usage info

```ruby
usage = client.get_usage
```

### Executing merge

```ruby
data = File.open('PO-Template.json').read
template = File.open('PO-Template.docx')

merge_parameters = BlazingDocs::MergeParameters.new(
  false, # data is object: sequence = false
  'json', # data in json format
  true # keep json types: strict = true
) 

merge_result = client.merge(data, 'output.pdf', merge_parameters, template)
```

## Documentation

See more details here https://docs.blazingdocs.com