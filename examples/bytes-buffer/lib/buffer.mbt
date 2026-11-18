///|
struct Buffer {
  mut data : Bytes
  mut len : Int32
}

///|
pub fn Buffer::new(size : Int32) -> Buffer {
  { data: Bytes::make(size, 0), len: 0, }
}

///|
pub fn Buffer::op_get(self : Buffer, i : Int32) -> Int32? {
  if i < self.data.length() {
    Some(self.data[i])
  } else {
    None
  }
}

///|
pub fn Buffer::capacity(self : Buffer) -> Int32 {
  self.data.length()
}

///|
pub fn Buffer::length(self : Buffer) -> Int32 {
  self.len
}

///|
fn Buffer::expand_size(self : Buffer) {
  let new_capacity = if self.data.length() != 0 {
    self.data.length() * 2
  } else {
    (self.data.length() + 1) * 2
  }
  let new_data = Bytes::make(new_capacity, 0)
  let mut index = 0
  while index < self.len {
    new_data[index] = self.data[index]
    index = index + 1
  }
  self.data = new_data
}

///|
pub fn Buffer::append_int(self : Buffer, value : Int32) {
  if self.len >= self.data.length() {
    self.expand_size()
  }
  if value > 127 || value < -128 {
    self.data[self.len] = value.asr(24).land(0xFF)
    self.data[self.len + 1] = value.asr(16).land(0xFF)
    self.data[self.len + 2] = value.asr(8).land(0xFF)
    self.data[self.len + 3] = value.land(0xFF)
    self.len = self.len + 4
  } else {
    self.data[self.len] = value
    self.len = self.len + 1
  }
}

///|
pub fn Buffer::truncate(self : Buffer, another : Buffer) {
  let mut index = 0
  while index < another.len {
    if self.len >= self.data.length() {
      self.expand_size()
    }
    self.data[self.len] = another.data[index]
    self.len = self.len + 1
    index = index + 1
  }
}

///|
pub fn Buffer::clear(self : Buffer) {
  let mut index = 0
  while index < self.len {
    self.data[index] = 0
    index = index + 1
  }
  self.len = 0
}

///|
pub fn Buffer::reset(self : Buffer, capacity : Int32) {
  self.len = 0
  self.data = Bytes::make(capacity, 0)
}

///|
pub fn Buffer::to_bytes(self : Buffer) -> Bytes {
  self.data
}

///|
pub fn bytes_to_int(bytes : Bytes, start : Int32) -> Int32 {
  bytes[start]
  .land(0xff)
  .lsl(24)
  .lor(
    bytes[start + 1]
    .land(0xff)
    .lsl(16)
    .lor(bytes[start + 2].land(0xff).lsl(8).lor(bytes[start + 3].land(0xff))),
  )
}

///|
fn init {
  ()
}
