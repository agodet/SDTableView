Pod::Spec.new do |s|
  s.name         = "SDTableView"
  s.version      = "1.0"
  s.summary      = "SDTableView is a simple UITableView Framework for quick and advanced development"
  s.license      = ""
  s.authors      = 'xlebrustiec.prestataire@voyages-sncf.com'
  s.homepage     = 'http://www.google.fr' 
  s.source       = { :git => "git@github.com:agodet/SDTableView.git", :tag => "1.0" }
  s.platform     = :ios, '7.0'
  s.public_header_files = 'SDTableView/*.h'
  s.source_files = 'SDTableView/*.h', 'SDTableView/*.m'
  s.frameworks = 'UIKit', 'CoreFoundation'
end

