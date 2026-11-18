///|
pub struct Path {
  mut inner : String
  platform : Platform
  file_type : FileType
}

///|
pub enum FileType {
  File
  Directory
  Symlink
  Unknown
}

///|
pub enum Platform {
  Posix
  Windows
}

///|
pub fn Path::new(s : String, platform : Platform, file_type : FileType) -> Path {
  { inner: s, platform, file_type, }
}

///|
pub fn Path::parent(self : Path) -> String {
  match self.platform {
    Posix => {
      let (parts, l) = split(self.inner, '/')
      let mut parent = ""
      let mut index = 0
      let end = if parts[l] == "" { l - 1 } else { l }
      while index < end {
        parent = parent + parts[index] + "/"
        index = index + 1
      }
      parent
    }
    Windows => {
      let (parts, l) = split(self.inner, '\\')
      let mut parent = ""
      let mut index = 0
      let end = if parts[l] == "" { l - 1 } else { l }
      while index < end {
        parent = parent + parts[index] + "\\"
        index = index + 1
      }
      parent
    }
  }
}

///|
pub fn Path::is_absolute(self : Path) -> Bool {
  self.has_root()
}

///|
pub fn Path::is_relative(self : Path) -> Bool {
  not(self.has_root())
}

///|
pub fn Path::has_root(self : Path) -> Bool {
  match self.platform {
    Posix => self.inner[0] == '/'
    Windows =>
      (
        (self.inner[0].compare('a') >= 0 && self.inner[0].compare('z') <= 0) ||
        (self.inner[0].compare('A') >= 0 && self.inner[0].compare('Z') <= 0)
      ) &&
      self.inner[1] == ':'
  }
}

///|
pub fn Path::file_name(self : Path) -> String? {
  match self.file_type {
    FileType::File => {
      let (parts, l) = match self.platform {
        Posix => split(self.inner, '/')
        Windows => split(self.inner, '\\')
      }
      Some(parts[l])
    }
    _ => None
  }
}

///|
pub fn Path::append(self : Path, p : String) {
  match self.platform {
    Posix => {
      if self.inner[self.inner.length() - 1] != '/' {
        self.inner = self.inner + "/"
      }
      self.inner = self.inner + p
    }
    Windows => {
      if self.inner[self.inner.length() - 1] != '\\' {
        self.inner = self.inner + "\\"
      }
      self.inner = self.inner + p
    }
  }
}

///|
pub fn Path::to_string(self : Path) -> String {
  self.inner
}

///|
fn init {
  ()
}
