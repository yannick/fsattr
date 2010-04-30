#provides bindings for hfs+ filesystem attributes via FFI
module FSattrOSX

  extend FFI::Library
  ffi_lib 'System'
  
  #ssize_t getxattr(const char *path, const char *name, void *value, size_t size, u_int32_t position, int options);
  attach_function 'getxattr', [ :string, :string, :string, :size_t, :uint, :int ], :int

  #ssize_t fgetxattr(int fd, const char *name, void *value, size_t size, u_int32_t position, int options);
  attach_function 'fgetxattr', [ :int, :string, :string, :size_t, :uint, :int ], :int


  # int setxattr(const char *@path, const char *name, void *value, size_t size, u_int32_t position, int options);
  attach_function 'setxattr', [ :string, :string, :string, :size_t, :uint, :int ], :int
  
  # int fsetxattr(int fd, const char *name, void *value, size_t size, u_int32_t position, int options);
  attach_function 'fsetxattr', [ :int, :string, :string, :size_t, :uint, :int ], :int


  #ssize_t listxattr(const char *@path, char *namebuf, size_t size, int options);
  attach_function 'listxattr', [:string, :string, :size_t, :int], :size_t
  
  #ssize_t flistxattr(int fd, char *namebuf, size_t size, int options);
  attach_function 'flistxattr', [:int, :string, :size_t, :int], :size_t

  #see man 2 getxattr
  def fsattr_pget(attribut)
    size = getxattr(@path, attribut, nil, 0,0,0)
    return "" if size < 0
    result = " " * size
    size = getxattr(@path, attribut, result, size, 0,0)
    return result
  end

  #see man 2 setxattr
  def fsattr_pset(attribute, value)
    err = setxattr(@path, attribute, value, value.bytesize, 0,0)
  end

  #see man 2 listxattr
  def fsattr_plist()
    size = listxattr(@path, nil, 0,0)
    result = " " * size
    err = listxattr(@path, result, size, 0)
    return result.split("\x00")
  end

  #man 2 getxattr
  def fsattr_fget(attribut)
    size = fgetxattr(fileno.to_i, attribut, nil, 0,0,0)
    return "" if size < 0
    result = " " * size
    size = fgetxattr(fileno.to_i, attribut, result, size, 0,0)
    return result
  end
  
  #see man 2 setxattr
  def fsattr_fset(attribute, value)
    err = fsetxattr(fileno.to_i, attribute, value, value.bytesize, 0,0)
  end

  #see man 2 listxattr
  def fsattr_flist()
    size = flistxattr(fileno.to_i, nil, 0,0)
    result = " " * size
    err = flistxattr(fileno.to_i, result, size, 0)
    return result.split("\x00")
  end  

end
