require 'ffi'
require 'sysinfo'



File.class_eval do

  if (SysInfo.new.impl == :osx)
    require 'fsattr/fsattr-osx'
    include FSattrOSX 
  end
  if (SysInfo.new.impl == :linux)
    require 'fsattr/fsattr-linux'
    include FSattrLinux 
  end
  alias_method :fsattr_get, :fsattr_fget
  alias_method :fsattr_set, :fsattr_fset
  alias_method :fsattr_list, :fsattr_flist

end


#todo: not complete
class FSattr 

  include Enumerable 
  include FSattrOSX if (SysInfo.new.impl == :osx)
  include FSattrLinux if (SysInfo.new.impl == :linux)

  attr_accessor :path

  alias_method :get, :fsattr_pget
  alias_method :set, :fsattr_pset
  alias_method :list, :fsattr_plist

  def initialize(path)
    @path = path
  end

  def each
    list
  end

  def [](key)
    get key
  end

  def []=(key, val)
    set key, val
  end



end




