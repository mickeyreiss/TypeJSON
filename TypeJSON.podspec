Pod::Spec.new do |s|
  s.name             = "TypeJSON"
  s.version          = "0.0.1"
  s.summary          = "Simple, type-safe JSON parsing"
  s.description      = <<-DESC
    A simple JSON parsing library that aims to adhere to the JSON spec with a sprinkle of type safety.
  DESC
  s.homepage         = "https://github.com/mickeyreiss/TypeJSON"
  s.license          = "MIT"
  s.author           = { "Mickey Reiss" => "mickeyreiss@gmail.com" }
  s.source           = { :git => "https://github.com/mickeyreiss/TypeJSON.git", :tag => "v#{s.version}" }

  s.platform         = :ios, "8.1"
  s.requires_arc     = true

  s.source_files     = "TypeJSON.{m,h}"

  s.compiler_flags = "-Wall -Werror -Wextra"
  s.xcconfig = { "GCC_TREAT_WARNINGS_AS_ERRORS" => "YES" }
end
