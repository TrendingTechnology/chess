
#' Save a game as an PGN
#' @param x Any node of a game
#' @param file File or connection to write to
#' @export
write_game <- function(x, file) {
  writeLines(utils::capture.output(utils::str(root(x))), file)
  invisible(x)
}

#' Read a game from a PGN
#' @param file File or connection to read from
#' @param n_max Maximum number of games to read
#' @return A game node
#' @export
read_game <- function(file, n_max = Inf) {

  # Needs IO, but can't understand why
  io <- reticulate::import("io")

  # Read file
  text <- file %>%
    readLines() %>%
    paste0(collapse = "\n")


  if (!grepl("\n\n\n", text)) {
    n <- 1
  } else {
    n <- min(lengths(gregexpr("\n\n\n", text)) + 1, n_max)
  }

  # Convert to readable PGN
  pgn <- text %>%
    reticulate::r_to_py() %>%
    io$StringIO()

  if (n == 1) {
    return(chess_pgn$read_game(pgn))
  } else if (n > 1) {
    return(purrr::map(1:n, ~ chess_pgn$read_game(pgn)))
  }
}

#' Get PGN for node of a game
#' @param game A game node
#' @return A string
#' @export
pgn <- function(game) {
  paste0(utils::capture.output(utils::str(game)), collapse = "\n")
}
