lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'blazingdocs/version'

Gem::Specification.new do |spec|
  spec.name          = 'blazingdocs'
  spec.version       = BlazingDocs::VERSION
  spec.authors       = ['Mentalstack']
  spec.email         = ['hello@blazingdocs.com']

  spec.summary       = 'BlazingDocs Ruby client'
  spec.description   = 'BlazingDocs Ruby client. High-performance document generation API. Generate documents and reports from СSV, JSON, XML with 99,9% uptime and 24/7 monitoring'
  spec.homepage      = 'https://blazingdocs.com'
  spec.license       = 'MIT'
  spec.metadata = {
    "bug_tracker_uri"   => "https://github.com/blazingdocs/blazingdocs-ruby/issues",
    "changelog_uri"     => "https://github.com/blazingdocs/blazingdocs-ruby/blob/master/CHANGELOG.md",
    "documentation_uri" => "https://docs.blazingdocs.com",
    "homepage_uri"      => spec.homepage,
    "source_code_uri"   => "https://github.com/blazingdocs/blazingdocs-ruby"
  }

  ignored = Regexp.union(
    /\.editorconfig/,
    /\.git/,
    /\.vscode/,
    /^test/,
    /^examples/,
    /^templates/
  )
  spec.files = `git ls-files`.split("\n").reject { |f| ignored.match(f) }

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.extra_rdoc_files = Dir["README.md", "CHANGELOG.md", "LICENSE.txt"]
  spec.rdoc_options    += [
    "--title", "BlazingDocs Ruby client",
    "--main", "README.md",
    "--line-numbers",
    "--inline-source",
    "--quiet"
  ]
end