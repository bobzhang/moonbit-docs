///|
fn min(a : Int32, b : Int32) -> Int32 {
  if a > b {
    return b
  } else {
    return a
  }
}

///|
/// `minPathSum(triangle : Array[Array[Int]])`
///
/// Calculate the minimum path sum through a triangle of integers.
pub fn minPathSum(triangle : Array[Array[Int32]]) -> Int32 {
  fn helper(row : Int32, col : Int32) -> Int32 {
    if row == triangle.length() {
      return 0
    }
    let next1 = helper(row + 1, col)
    let next2 = if col < row { helper(row + 1, col + 1) } else { 2147483647 }
    let cur = triangle[row][col]
    return cur + min(next1, next2)
  }

  helper(0, 0)
}
