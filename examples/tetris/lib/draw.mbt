///|
type Canvas_ctx

///|
fn Canvas_ctx::set_stroke_color(self : Canvas_ctx, color : Int32) = "canvas" "set_stroke_color"

///|
fn Canvas_ctx::set_line_width(self : Canvas_ctx, width : Double) = "canvas" "set_line_width"

///|
fn Canvas_ctx::stroke_rect(
  self : Canvas_ctx,
  x : Int32,
  y : Int32,
  width : Int32,
  height : Int32,
) = "canvas" "stroke_rect"

///|
fn Canvas_ctx::fill_rect(
  self : Canvas_ctx,
  x : Int32,
  y : Int32,
  width : Int32,
  height : Int32,
) = "canvas" "fill_rect"

///|
fn Canvas_ctx::set_fill_style(self : Canvas_ctx, color : Int32) = "canvas" "set_fill_style"

///|
fn Canvas_ctx::draw_game_over(self : Canvas_ctx) = "canvas" "draw_game_over"

///|
pub fn draw(canvas : Canvas_ctx, tetris : Tetris) -> Unit {
  let mut c = 0

  // draw backgroud
  while c < grid_col_count {
    let color = if c % 2 == 0 { 0 } else { 1 }
    canvas.set_fill_style(color)
    canvas.fill_rect(c, 0, 1, grid_row_count)
    c = c + 1
  }
  draw_piece(canvas, tetris.grid, (0, 0))
  draw_piece(
    canvas,
    List::from_array(tetris.pice_shap),
    (tetris.pice_x, tetris.pice_y),
  )
  if tetris.dead {
    canvas.draw_game_over()
  }
}

///|
pub fn draw_piece(
  canvas : Canvas_ctx,
  matrix : List[Array[Int32]],
  offset : (Int32, Int32),
) -> Unit {
  fn go(l : List[Array[Int32]], r : Int32, canvas : Canvas_ctx) {
    match l {
      Cons(v, n) => {
        let mut c = 0
        while c < v.length() {
          if v[c] == 0 {
            c = c + 1
            continue
          }
          canvas.set_fill_style(v[c] + 1)
          canvas.fill_rect(offset.0 + c, offset.1 + r, 1, 1)
          canvas.set_stroke_color(0)
          canvas.set_line_width(0.1)
          canvas.stroke_rect(offset.0 + c, offset.1 + r, 1, 1)
          c = c + 1
        }
        go(n, r + 1, canvas)
      }
      Nil => ()
    }
  }

  go(matrix, 0, canvas)
}
