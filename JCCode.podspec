Pod::Spec.new do |s|
    s.name         = 'JCCode'
    s.version      = '0.1.1'
    s.summary      = 'An easy way read or write QRCode'
    s.homepage     = 'https://github.com/joeykika/JCCode'
    s.license      = 'MIT'
    s.authors      = {'joeykika' => 'jc_developer@163.com'}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'https://github.com/joeykika/JCCode.git', :tag => s.version}
    s.source_files = 'JCCode/**/*.{h,m}'
    s.resource     = 'JCCode/Resources/JCCode.bundle'
    s.requires_arc = true
end